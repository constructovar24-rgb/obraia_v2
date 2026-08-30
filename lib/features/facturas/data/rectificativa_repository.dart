import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../database/app_database.dart' hide Factura, FacturaLinea;
import '../../cobros/domain/factura_estado_economico.dart';
import '../../creditos_cliente/data/credito_cliente_repository.dart';
import '../../timeline/data/timeline_repository.dart';
import '../domain/estado_factura.dart';
import '../domain/factura.dart';
import '../domain/factura_linea.dart';
import '../domain/rectificativa.dart';
import '../domain/redondeo_monetario.dart';
import '../domain/tipo_documento_factura.dart';
import '../services/factura_pdf_service.dart';
import 'factura_repository.dart';

class RectificativaRepository {
  RectificativaRepository(this.database)
    : _timeline = TimelineRepository(database.timelineEventsDao);

  final AppDatabase database;
  final TimelineRepository _timeline;
  late final CreditoClienteRepository _credito = CreditoClienteRepository(
    database,
  );

  Stream<List<Factura>> observarRectificativasDe(String facturaId) =>
      database.facturasDao.observarRectificativasDe(facturaId);

  Future<Uint8List?> obtenerPdfEmitido(String facturaId) async {
    final documento = await database.facturaDocumentosEmitidosDao.obtener(
      facturaId,
    );
    if (documento == null) return null;
    if (sha256.convert(documento.pdf).toString() != documento.sha256) {
      throw const RectificativaException(
        'El PDF histórico no supera la verificación de integridad.',
      );
    }
    return documento.pdf;
  }

  Future<Factura?> obtenerOriginal(Factura rectificativa) {
    final id = rectificativa.facturaRectificadaId;
    return id == null ? Future.value() : database.facturasDao.obtenerPorId(id);
  }

  Future<String> crear({
    required String facturaRectificadaId,
    required String motivo,
    required List<AjusteRectificativa> ajustes,
    double? ivaDiferencia,
    bool rectificacionFormal = false,
  }) => database.transaction(() async {
    if (motivo.trim().length < 3) {
      throw const RectificativaException(
        'El motivo de rectificación es obligatorio.',
      );
    }
    if (!rectificacionFormal && ajustes.isEmpty && ivaDiferencia == null) {
      throw const RectificativaException(
        'Indica al menos un importe o cantidad a rectificar.',
      );
    }

    final objetivo = await database.facturasDao.obtenerPorId(
      facturaRectificadaId,
    );
    if (objetivo == null || !facturaPuedeOriginarRectificativa(objetivo)) {
      throw const RectificativaException(
        'Solo puede rectificarse una factura emitida, vencida o cobrada.',
      );
    }
    _validarDocumentoOriginalSeguro(objetivo);

    final raizId = objetivo.facturaRaizId ?? objetivo.id;
    final raiz = await database.facturasDao.obtenerPorId(raizId);
    if (raiz == null || raiz.esRectificativa) {
      throw const RectificativaException(
        'No se puede reconstruir la factura ordinaria raíz.',
      );
    }
    final cadena = await database.facturasDao.obtenerCadenaPorRaiz(raizId);
    if (objetivo.esRectificativa && objetivo.facturaRaizId != raiz.id) {
      throw const RectificativaException(
        'La cadena de rectificación no es válida.',
      );
    }
    final expedienteId = await _expedienteId(raiz.presupuestoOrigenId);
    if (expedienteId == null) {
      throw const RectificativaException(
        'La factura no tiene expediente trazable y no puede rectificarse de forma segura.',
      );
    }

    final lineasObjetivo = await database.facturaLineasDao.obtenerPorFactura(
      objetivo.id,
    );
    final lineasRaiz = await database.facturaLineasDao.obtenerPorFactura(
      raiz.id,
    );
    final lineasCadena = await database.facturaLineasDao.obtenerPorFacturas(
      cadena.where((item) => item.esRectificativa).map((item) => item.id),
    );
    final idsCadenaActiva = cadena
        .where(
          (item) =>
              item.esRectificativa && item.estado != EstadoFactura.anulada,
        )
        .map((item) => item.id)
        .toSet();

    final preparadas = <_AjustePreparado>[];
    final usadas = <String>{};
    for (final ajuste in ajustes) {
      if (!usadas.add(ajuste.lineaRectificadaId)) {
        throw const RectificativaException('Una línea está repetida.');
      }
      final lineaObjetivo = lineasObjetivo
          .where((item) => item.id == ajuste.lineaRectificadaId)
          .firstOrNull;
      if (lineaObjetivo == null) {
        throw const RectificativaException(
          'Una línea no pertenece a la factura rectificada.',
        );
      }
      final raizLineaId = lineaObjetivo.lineaRaizId ?? lineaObjetivo.id;
      final lineaRaiz = lineasRaiz
          .where((item) => item.id == raizLineaId)
          .firstOrNull;
      if (lineaRaiz == null) {
        throw const RectificativaException(
          'No se puede reconstruir la línea ordinaria raíz.',
        );
      }
      final base = monedaACentimos(ajuste.baseDiferencia);
      if (!ajuste.baseDiferencia.isFinite || base == 0) {
        throw const RectificativaException(
          'Cada diferencia económica debe ser distinta de cero.',
        );
      }
      final acumulada = lineasCadena
          .where(
            (item) =>
                idsCadenaActiva.contains(item.facturaId) &&
                item.lineaRaizId == raizLineaId,
          )
          .fold<int>(0, (sum, item) => sum + monedaACentimos(item.importe));
      final limite = monedaACentimos(lineaRaiz.importe).abs();
      if ((acumulada + base).abs() > limite) {
        throw const RectificativaException(
          'La rectificación acumulada supera la base de la línea original.',
        );
      }

      final cantidad = ajuste.cantidadDiferencia;
      if (cantidad != null && (!cantidad.isFinite || cantidad == 0)) {
        throw const RectificativaException(
          'La diferencia de cantidad debe ser distinta de cero.',
        );
      }
      if (cantidad != null) {
        final acumuladaCantidad = lineasCadena
            .where(
              (item) =>
                  idsCadenaActiva.contains(item.facturaId) &&
                  item.lineaRaizId == raizLineaId,
            )
            .fold<double>(0, (sum, item) => sum + item.cantidad);
        if ((acumuladaCantidad + cantidad).abs() >
            lineaRaiz.cantidad.abs() + 0.000000001) {
          throw const RectificativaException(
            'La rectificación acumulada supera la cantidad original.',
          );
        }
      }
      preparadas.add(
        _AjustePreparado(
          objetivo: lineaObjetivo,
          raiz: lineaRaiz,
          baseCentimos: base,
          cantidad: cantidad,
        ),
      );
    }

    final baseCentimos = preparadas.fold<int>(
      0,
      (sum, item) => sum + item.baseCentimos,
    );
    final ivaCentimos = ivaDiferencia == null
        ? monedaACentimos(
            centimosAMoneda(baseCentimos) * raiz.ivaPorcentaje / 100,
          )
        : monedaACentimos(ivaDiferencia);
    final ivaAcumulado = cadena
        .where(
          (item) =>
              item.esRectificativa && item.estado != EstadoFactura.anulada,
        )
        .fold<int>(0, (sum, item) => sum + monedaACentimos(item.efectoIva));
    if ((ivaAcumulado + ivaCentimos).abs() > monedaACentimos(raiz.iva).abs()) {
      throw const RectificativaException(
        'La rectificación acumulada supera el IVA original.',
      );
    }
    if (!rectificacionFormal && baseCentimos == 0 && ivaCentimos == 0) {
      throw const RectificativaException(
        'La rectificación económica no puede tener efecto cero.',
      );
    }

    final facturaId = const Uuid().v4();
    final ahora = DateTime.now();
    await database.facturasDao.insertarFactura(
      FacturasCompanion.insert(
        id: facturaId,
        clienteId: raiz.clienteId,
        fecha: Value(ahora),
        fechaVencimiento: Value(ahora),
        estado: const Value('borrador'),
        subtotal: Value(centimosAMoneda(baseCentimos)),
        iva: Value(centimosAMoneda(ivaCentimos)),
        ivaPorcentaje: Value(raiz.ivaPorcentaje),
        total: Value(centimosAMoneda(baseCentimos + ivaCentimos)),
        observaciones: Value(motivo.trim()),
        presupuestoOrigenId: Value(raiz.presupuestoOrigenId),
        tipoDocumento: Value(TipoDocumentoFactura.rectificativa.name),
        serie: const Value('RECT'),
        facturaRectificadaId: Value(objetivo.id),
        facturaRaizId: Value(raiz.id),
        modalidadRectificacion: Value(ModalidadRectificacion.diferencias.name),
        motivoRectificacion: Value(motivo.trim()),
        efectoBase: Value(centimosAMoneda(baseCentimos)),
        efectoIva: Value(centimosAMoneda(ivaCentimos)),
        efectoTotal: Value(centimosAMoneda(baseCentimos + ivaCentimos)),
      ),
    );

    final asignaciones = await database.facturaAsignacionesPresupuestoDao
        .observarTodas()
        .first;
    for (final ajuste in preparadas) {
      final lineaId = const Uuid().v4();
      final cantidad =
          ajuste.cantidad ?? (ajuste.baseCentimos < 0 ? -1.0 : 1.0);
      await database.facturaLineasDao.insertarLinea(
        FacturaLineasCompanion.insert(
          id: lineaId,
          facturaId: facturaId,
          descripcion: ajuste.raiz.descripcion,
          cantidad: cantidad,
          unidad: Value(ajuste.raiz.unidad),
          precioUnitario: centimosAMoneda(ajuste.baseCentimos.abs()),
          importe: Value(centimosAMoneda(ajuste.baseCentimos)),
          lineaRectificadaId: Value(ajuste.objetivo.id),
          lineaRaizId: Value(ajuste.raiz.id),
        ),
      );
      final asignacionRaiz = asignaciones
          .where((item) => item.facturaLineaId == ajuste.raiz.id)
          .firstOrNull;
      if (asignacionRaiz != null) {
        await database.facturaAsignacionesPresupuestoDao.insertar(
          FacturaAsignacionesPresupuestoCompanion.insert(
            id: const Uuid().v4(),
            facturaId: facturaId,
            facturaLineaId: lineaId,
            presupuestoId: asignacionRaiz.presupuestoId,
            lineaPresupuestoId: asignacionRaiz.lineaPresupuestoId,
            cantidadAplicada: Value(ajuste.cantidad),
            baseAplicada: centimosAMoneda(ajuste.baseCentimos),
          ),
        );
      }
    }
    await _validarAsignacionesPresupuesto(raiz.presupuestoOrigenId);
    await _timeline.registrarRectificativaCreada(
      expedienteId: expedienteId,
      facturaId: facturaId,
      titulo: 'Rectificativa creada',
      descripcion: 'Rectifica ${objetivo.codigo}: ${motivo.trim()}',
    );
    return facturaId;
  });

  Future<String> crearCancelatoria({
    required String facturaId,
    required String motivo,
  }) => database.transaction(() async {
    final raiz = await database.facturasDao.obtenerPorId(facturaId);
    if (raiz == null ||
        raiz.esRectificativa ||
        !facturaPuedeOriginarRectificativa(raiz)) {
      throw const RectificativaException(
        'Solo puede cancelarse una factura ordinaria emitida.',
      );
    }
    final cadena = await database.facturasDao.obtenerCadenaPorRaiz(raiz.id);
    if (cadena.any(
      (item) => item.esRectificativa && item.estado == EstadoFactura.borrador,
    )) {
      throw const RectificativaException(
        'Emite o elimina las rectificativas en borrador antes de cancelar.',
      );
    }
    final activas = cadena
        .where(
          (item) =>
              item.esRectificativa &&
              item.estado != EstadoFactura.borrador &&
              item.estado != EstadoFactura.anulada,
        )
        .toList();
    final lineasRaiz = await database.facturaLineasDao.obtenerPorFactura(
      raiz.id,
    );
    final lineasRectificativas = await database.facturaLineasDao
        .obtenerPorFacturas(activas.map((item) => item.id));
    final ajustes = <AjusteRectificativa>[];
    for (final linea in lineasRaiz) {
      final relacionadas = lineasRectificativas.where(
        (item) => item.lineaRaizId == linea.id,
      );
      final baseVigente =
          monedaACentimos(linea.importe) +
          relacionadas.fold<int>(
            0,
            (total, item) => total + monedaACentimos(item.importe),
          );
      if (baseVigente == 0) continue;
      final cantidadVigente =
          linea.cantidad +
          relacionadas.fold<double>(0, (total, item) => total + item.cantidad);
      ajustes.add(
        AjusteRectificativa(
          lineaRectificadaId: linea.id,
          baseDiferencia: centimosAMoneda(-baseVigente),
          cantidadDiferencia: cantidadVigente.abs() < 0.000000001
              ? null
              : -cantidadVigente,
        ),
      );
    }
    final ivaVigente =
        monedaACentimos(raiz.iva) +
        activas.fold<int>(
          0,
          (total, item) => total + monedaACentimos(item.efectoIva),
        );
    if (ajustes.isEmpty && ivaVigente == 0) {
      throw const RectificativaException(
        'La familia documental ya está completamente neutralizada.',
      );
    }
    return crear(
      facturaRectificadaId: raiz.id,
      motivo: motivo,
      ajustes: ajustes,
      ivaDiferencia: centimosAMoneda(-ivaVigente),
    );
  });

  Future<void> emitir(String facturaId) => database.transaction(() async {
    final factura = await database.facturasDao.obtenerPorId(facturaId);
    if (factura == null || !factura.esRectificativa) {
      throw const RectificativaException('La rectificativa no existe.');
    }
    if (factura.estado != EstadoFactura.borrador) {
      throw const RectificativaException(
        'Solo puede emitirse una rectificativa en borrador.',
      );
    }
    final original = await database.facturasDao.obtenerPorId(
      factura.facturaRectificadaId!,
    );
    final raiz = await database.facturasDao.obtenerPorId(
      factura.facturaRaizId!,
    );
    if (original == null || raiz == null) {
      throw const RectificativaException(
        'La cadena de rectificación está rota.',
      );
    }
    _validarDocumentoOriginalSeguro(raiz);
    if (monedaACentimos(factura.efectoTotal) > 0) {
      final resumen = await _credito.obtenerResumen(raiz.id);
      await _credito.validarCreditoTrasCambio(
        facturaRaizId: raiz.id,
        nuevoNetoDocumental: redondearMoneda(
          resumen.netoDocumental + factura.efectoTotal,
        ),
      );
    }
    await _validarLimitesAlEmitir(factura: factura, raiz: raiz);
    final (anio, numero, codigo) = await FacturaRepository(
      database,
    ).generarCodigoFactura(factura.fecha.year, serie: 'RECT');
    await database.facturasDao.actualizarEmision(
      facturaId,
      FacturasCompanion(
        codigo: Value(codigo),
        anioNumeracion: Value(anio),
        numeroLegal: Value(numero),
        estado: const Value('emitida'),
        fechaEmision: Value(DateTime.now()),
        clienteNombreHistorico: Value(raiz.clienteNombreHistorico),
        clienteNifHistorico: Value(raiz.clienteNifHistorico),
        clienteDireccionHistorica: Value(raiz.clienteDireccionHistorica),
        clienteTelefonoHistorico: Value(raiz.clienteTelefonoHistorico),
        clienteEmailHistorico: Value(raiz.clienteEmailHistorico),
        empresaNombreHistorico: Value(raiz.empresaNombreHistorico),
        empresaCifHistorico: Value(raiz.empresaCifHistorico),
        empresaDireccionHistorica: Value(raiz.empresaDireccionHistorica),
        empresaCodigoPostalHistorico: Value(raiz.empresaCodigoPostalHistorico),
        empresaPoblacionHistorica: Value(raiz.empresaPoblacionHistorica),
        empresaProvinciaHistorica: Value(raiz.empresaProvinciaHistorica),
        empresaTelefonoHistorico: Value(raiz.empresaTelefonoHistorico),
        empresaEmailHistorico: Value(raiz.empresaEmailHistorico),
        empresaWebHistorica: Value(raiz.empresaWebHistorica),
        expedienteOrigenIdHistorico: Value(raiz.expedienteOrigenIdHistorico),
        expedienteCodigoHistorico: Value(raiz.expedienteCodigoHistorico),
        expedienteNombreHistorico: Value(raiz.expedienteNombreHistorico),
        presupuestoCodigoHistorico: Value(raiz.presupuestoCodigoHistorico),
        fechaModificacion: Value(DateTime.now()),
      ),
    );
    final emitida = (await database.facturasDao.obtenerPorId(facturaId))!;
    final lineas = await database.facturaLineasDao.obtenerPorFactura(facturaId);
    final empresa = await database.empresaConfiguracionDao
        .obtenerConfiguracion();
    if (empresa == null) {
      throw const RectificativaException(
        'Falta la configuración de empresa para generar el PDF.',
      );
    }
    final pdf = await FacturaPdfService().generarPdf(
      factura: emitida,
      facturaOriginal: original,
      lineas: lineas,
      empresaConfiguracion: empresa,
    );
    await database.facturaDocumentosEmitidosDao.insertar(
      facturaId: facturaId,
      pdf: pdf,
      sha256: sha256.convert(pdf).toString(),
    );
    final saldo = await calcularSaldo(emitida);
    final expedienteId = await _expedienteId(raiz.presupuestoOrigenId);
    if (expedienteId != null) {
      await _timeline.registrarRectificativaEmitida(
        expedienteId: expedienteId,
        facturaId: facturaId,
        titulo: 'Rectificativa emitida',
        descripcion: '$codigo rectifica ${original.codigo}',
      );
      if (saldo.saldoAFavor > 0) {
        await _timeline.registrarSaldoFavorGenerado(
          expedienteId: expedienteId,
          facturaId: facturaId,
          titulo: 'Saldo a favor generado',
          descripcion: '${saldo.saldoAFavor.toStringAsFixed(2)} € pendientes',
        );
      }
    }
  });

  Future<SaldoRectificacion> calcularSaldo(Factura factura) async {
    final raizId = factura.facturaRaizId ?? factura.id;
    final raiz = await database.facturasDao.obtenerPorId(raizId);
    if (raiz == null) {
      throw const RectificativaException('Factura raíz inexistente.');
    }
    final cadena = await database.facturasDao.obtenerCadenaPorRaiz(raizId);
    final efecto = cadena
        .where(
          (item) =>
              item.esRectificativa &&
              item.estado != EstadoFactura.borrador &&
              item.estado != EstadoFactura.anulada,
        )
        .fold<int>(0, (sum, item) => sum + monedaACentimos(item.efectoTotal));
    final cobros = await database.cobrosDao.obtenerPorFactura(raizId);
    final cobrado = monedaACentimos(calcularTotalCobradoNeto(cobros));
    final neto = monedaACentimos(raiz.total) + efecto;
    return SaldoRectificacion(
      netoDocumental: centimosAMoneda(neto),
      cobradoOriginal: centimosAMoneda(cobrado),
      saldoAFavor: centimosAMoneda((cobrado - neto).clamp(0, 1 << 62)),
    );
  }

  Future<void> _validarLimitesAlEmitir({
    required Factura factura,
    required Factura raiz,
  }) async {
    final cadena = await database.facturasDao.obtenerCadenaPorRaiz(raiz.id);
    final activas = cadena
        .where(
          (item) =>
              item.esRectificativa &&
              item.id != factura.id &&
              item.estado != EstadoFactura.borrador &&
              item.estado != EstadoFactura.anulada,
        )
        .toList();
    final idsActivas = activas.map((item) => item.id).toSet();
    final lineasRaiz = await database.facturaLineasDao.obtenerPorFactura(
      raiz.id,
    );
    final lineasCadena = await database.facturaLineasDao.obtenerPorFacturas([
      ...idsActivas,
      factura.id,
    ]);
    for (final lineaRaiz in lineasRaiz) {
      final relacionadas = lineasCadena.where(
        (item) => item.lineaRaizId == lineaRaiz.id,
      );
      final baseAcumulada = relacionadas.fold<int>(
        0,
        (total, item) => total + monedaACentimos(item.importe),
      );
      if (baseAcumulada.abs() > monedaACentimos(lineaRaiz.importe).abs()) {
        throw const RectificativaException(
          'La rectificación acumulada supera la base de la línea original.',
        );
      }
      final cantidadAcumulada = relacionadas.fold<double>(
        0,
        (total, item) => total + item.cantidad,
      );
      if (cantidadAcumulada.abs() > lineaRaiz.cantidad.abs() + 0.000000001) {
        throw const RectificativaException(
          'La rectificación acumulada supera la cantidad original.',
        );
      }
    }
    final ivaAcumulado =
        activas.fold<int>(
          0,
          (total, item) => total + monedaACentimos(item.efectoIva),
        ) +
        monedaACentimos(factura.efectoIva);
    if (ivaAcumulado.abs() > monedaACentimos(raiz.iva).abs()) {
      throw const RectificativaException(
        'La rectificación acumulada supera el IVA original.',
      );
    }
  }

  void _validarDocumentoOriginalSeguro(Factura factura) {
    if (factura.numeroLegal == null ||
        factura.codigo.trim().isEmpty ||
        factura.fechaEmision == null ||
        factura.clienteNombreHistorico.trim().isEmpty ||
        factura.clienteNifHistorico.trim().isEmpty ||
        factura.empresaNombreHistorico.trim().isEmpty ||
        factura.empresaCifHistorico.trim().isEmpty) {
      throw const RectificativaException(
        'La factura no tiene número o fotografía fiscal histórica suficiente.',
      );
    }
  }

  Future<void> _validarAsignacionesPresupuesto(String? presupuestoId) async {
    if (presupuestoId == null) return;
    final facturas = await database.facturasDao.obtenerPorPresupuestoOrigen(
      presupuestoId,
    );
    final asignaciones = await database.facturaAsignacionesPresupuestoDao
        .obtenerPorPresupuesto(presupuestoId);
    final lineasPresupuesto = await database.lineasPresupuestoDao
        .obtenerPorPresupuesto(presupuestoId);
    for (final linea in lineasPresupuesto) {
      var base = 0;
      var cantidad = 0.0;
      for (final asignacion in asignaciones.where(
        (item) => item.lineaPresupuestoId == linea.id,
      )) {
        final factura = facturas
            .where((item) => item.id == asignacion.facturaId)
            .firstOrNull;
        if (factura == null || factura.estado == EstadoFactura.anulada) {
          continue;
        }
        if (factura.esRectificativa &&
            factura.estado == EstadoFactura.borrador &&
            asignacion.baseAplicada < 0) {
          continue;
        }
        base += monedaACentimos(asignacion.baseAplicada);
        cantidad += asignacion.cantidadAplicada ?? 0;
      }
      if (base < 0 || base > monedaACentimos(linea.importe)) {
        throw const RectificativaException(
          'La rectificación supera la base disponible del presupuesto.',
        );
      }
      if (cantidad < -0.000000001 || cantidad > linea.cantidad + 0.000000001) {
        throw const RectificativaException(
          'La rectificación supera la cantidad disponible del presupuesto.',
        );
      }
    }
  }

  Future<String?> _expedienteId(String? presupuestoId) async {
    if (presupuestoId == null) return null;
    final presupuestos = await database.presupuestosDao
        .observarPresupuestos()
        .first;
    return presupuestos
        .where((item) => item.id == presupuestoId)
        .firstOrNull
        ?.expedienteId;
  }
}

class _AjustePreparado {
  const _AjustePreparado({
    required this.objetivo,
    required this.raiz,
    required this.baseCentimos,
    required this.cantidad,
  });
  final FacturaLinea objetivo;
  final FacturaLinea raiz;
  final int baseCentimos;
  final double? cantidad;
}

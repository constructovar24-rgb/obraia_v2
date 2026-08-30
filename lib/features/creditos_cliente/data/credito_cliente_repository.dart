import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../database/app_database.dart' hide Factura;
import '../../cobros/domain/factura_estado_economico.dart';
import '../../facturas/domain/estado_factura.dart';
import '../../facturas/domain/factura.dart';
import '../../facturas/domain/redondeo_monetario.dart';
import '../../timeline/data/timeline_repository.dart';
import '../../timeline/domain/timeline_event.dart';
import '../domain/credito_cliente.dart';

class CreditoClienteException implements Exception {
  const CreditoClienteException(this.mensaje);
  final String mensaje;
  @override
  String toString() => mensaje;
}

class CreditoClienteRepository {
  CreditoClienteRepository(this.database, {TimelineRepository? timeline})
    : _timeline = timeline ?? TimelineRepository(database.timelineEventsDao);

  final AppDatabase database;
  final TimelineRepository _timeline;

  Stream<List<MovimientoCreditoCliente>> observarMovimientos(String raizId) =>
      database.movimientosCreditoClienteDao.observarPorFamilia(raizId);

  Future<CreditoClienteFamilia> obtenerResumen(String facturaId) async {
    final factura = await _factura(facturaId);
    return _resumen(factura.facturaRaizId ?? factura.id);
  }

  Stream<CreditoClienteFamilia> observarResumen(String facturaId) {
    return Stream<CreditoClienteFamilia>.multi((controller) async {
      final factura = await _factura(facturaId);
      final raizId = factura.facturaRaizId ?? factura.id;
      var emitiendo = false;
      var pendiente = false;
      Future<void> emitir() async {
        if (emitiendo) {
          pendiente = true;
          return;
        }
        emitiendo = true;
        do {
          pendiente = false;
          try {
            controller.add(await _resumen(raizId));
          } catch (error, stack) {
            controller.addError(error, stack);
          }
        } while (pendiente);
        emitiendo = false;
      }

      final movimientos = database.movimientosCreditoClienteDao
          .observarPorFamilia(raizId)
          .listen((_) => emitir(), onError: controller.addError);
      final cobros = database.cobrosDao
          .observarPorFactura(raizId)
          .listen((_) => emitir(), onError: controller.addError);
      final facturas = database.facturasDao.observarFacturas().listen(
        (_) => emitir(),
        onError: controller.addError,
      );
      controller.onCancel = () async {
        await movimientos.cancel();
        await cobros.cancel();
        await facturas.cancel();
      };
    });
  }

  Future<List<CreditoClienteFamilia>> obtenerDestinosElegibles(
    String origenId,
  ) async {
    final origen = await _factura(origenId);
    final raizOrigen = origen.facturaRaizId ?? origen.id;
    final facturas = await database.facturasDao.observarFacturas().first;
    final raices = facturas.where(
      (f) =>
          !f.esRectificativa &&
          f.id != raizOrigen &&
          facturasTienenMismaIdentidadFiscal(origen, f) &&
          estadoFacturaEsEfectiva(f.estado),
    );
    final result = <CreditoClienteFamilia>[];
    for (final factura in raices) {
      final resumen = await _resumen(factura.id);
      if (monedaACentimos(resumen.pendiente) > 0) result.add(resumen);
    }
    return result;
  }

  Future<List<DestinoCompensacion>> obtenerFacturasDestinoElegibles(
    String origenId,
  ) async {
    final resumenes = await obtenerDestinosElegibles(origenId);
    final destinos = <DestinoCompensacion>[];
    for (final resumen in resumenes) {
      final factura = await _raiz(resumen.facturaRaizId);
      destinos.add(
        DestinoCompensacion(
          facturaRaizId: factura.id,
          codigo: factura.codigo,
          pendiente: resumen.pendiente,
        ),
      );
    }
    return destinos;
  }

  Future<String> registrarDevolucion({
    required String facturaRaizId,
    required double importe,
    required DateTime fecha,
    required String metodo,
    required String motivo,
    String referencia = '',
    String observaciones = '',
  }) => database.transaction(() async {
    final centimos = _validarComun(importe, fecha, motivo);
    final metodoLimpio = metodo.trim();
    if (metodoLimpio.isEmpty) {
      throw const CreditoClienteException('El método es obligatorio.');
    }
    if (_requiereReferencia(metodoLimpio) && referencia.trim().isEmpty) {
      throw const CreditoClienteException(
        'La referencia es obligatoria para este método.',
      );
    }
    final raiz = await _raiz(facturaRaizId);
    final resumen = await _resumen(raiz.id);
    if (centimos > monedaACentimos(resumen.creditoDisponible)) {
      throw const CreditoClienteException(
        'La devolución supera el crédito disponible.',
      );
    }
    final id = const Uuid().v4();
    await _insertar(
      id: id,
      clienteId: raiz.clienteId,
      origenId: raiz.id,
      tipo: TipoMovimientoCreditoCliente.devolucion,
      centimos: centimos,
      fecha: fecha,
      metodo: metodoLimpio,
      referencia: referencia,
      motivo: motivo,
      observaciones: observaciones,
    );
    await _timelineCredito(
      raiz,
      id,
      TimelineCreditoTipo.devolucionRegistrada,
      'Devolución registrada',
      '${creditoMoneda(centimos).toStringAsFixed(2)} € · ${motivo.trim()}',
      fecha,
    );
    return id;
  });

  Future<String> compensar({
    required String facturaRaizOrigenId,
    required String facturaRaizDestinoId,
    required double importe,
    required DateTime fecha,
    required String motivo,
    String observaciones = '',
  }) => database.transaction(() async {
    final centimos = _validarComun(importe, fecha, motivo);
    final origen = await _raiz(facturaRaizOrigenId);
    final destino = await _raiz(facturaRaizDestinoId);
    if (origen.id == destino.id) {
      throw const CreditoClienteException(
        'Origen y destino deben ser distintos.',
      );
    }
    if (!facturasTienenMismaIdentidadFiscal(origen, destino)) {
      throw const CreditoClienteException(
        'La compensación exige el mismo cliente fiscal.',
      );
    }
    final resumenOrigen = await _resumen(origen.id);
    final resumenDestino = await _resumen(destino.id);
    if (centimos > monedaACentimos(resumenOrigen.creditoDisponible)) {
      throw const CreditoClienteException(
        'La compensación supera el crédito disponible.',
      );
    }
    if (centimos > monedaACentimos(resumenDestino.pendiente)) {
      throw const CreditoClienteException(
        'La compensación supera el pendiente del destino.',
      );
    }
    final id = const Uuid().v4();
    await _insertar(
      id: id,
      clienteId: origen.clienteId,
      origenId: origen.id,
      destinoId: destino.id,
      tipo: TipoMovimientoCreditoCliente.compensacion,
      centimos: centimos,
      fecha: fecha,
      motivo: motivo,
      observaciones: observaciones,
    );
    await _sincronizarEstado(destino.id);
    final importeTexto = creditoMoneda(centimos).toStringAsFixed(2);
    await _timelineCredito(
      origen,
      id,
      TimelineCreditoTipo.compensacionAplicada,
      'Compensación aplicada',
      '$importeTexto € a ${destino.codigo}',
      fecha,
    );
    await _timelineCredito(
      destino,
      id,
      TimelineCreditoTipo.compensacionRecibida,
      'Compensación recibida',
      '$importeTexto € desde ${origen.codigo}',
      fecha,
    );
    return id;
  });

  Future<String> revertir({
    required String movimientoId,
    required double importe,
    required DateTime fecha,
    required String motivo,
  }) => database.transaction(() async {
    final centimos = _validarComun(importe, fecha, motivo);
    final original = await database.movimientosCreditoClienteDao.obtener(
      movimientoId,
    );
    if (original == null ||
        (original.tipo != TipoMovimientoCreditoCliente.devolucion &&
            original.tipo != TipoMovimientoCreditoCliente.compensacion)) {
      throw const CreditoClienteException('El movimiento no es reversible.');
    }
    if (_dia(fecha).isBefore(_dia(original.fecha))) {
      throw const CreditoClienteException(
        'La reversión no puede ser anterior al movimiento.',
      );
    }
    final movimientos = await database.movimientosCreditoClienteDao
        .obtenerTodos();
    final revertido = movimientos
        .where((m) => m.movimientoOrigenId == original.id)
        .fold<int>(0, (sum, m) => sum + monedaACentimos(m.importe));
    if (centimos > monedaACentimos(original.importe) - revertido) {
      throw const CreditoClienteException(
        'La reversión acumulada supera el movimiento original.',
      );
    }
    if (original.tipo == TipoMovimientoCreditoCliente.compensacion) {
      final destino = await _resumen(original.facturaRaizDestinoId!);
      final liquidadoTras = monedaACentimos(destino.totalLiquidado) - centimos;
      final dispuestoDestino = monedaACentimos(destino.creditoDispuesto);
      final creditoTras =
          (liquidadoTras - monedaACentimos(destino.netoDocumental)).clamp(
            0,
            1 << 62,
          );
      if (creditoTras < dispuestoDestino) {
        throw const CreditoClienteException(
          'La familia destino ya dispuso del crédito; revierta primero esas aplicaciones.',
        );
      }
    }
    final tipo = original.tipo == TipoMovimientoCreditoCliente.devolucion
        ? TipoMovimientoCreditoCliente.reversionDevolucion
        : TipoMovimientoCreditoCliente.reversionCompensacion;
    final id = const Uuid().v4();
    await _insertar(
      id: id,
      clienteId: original.clienteId,
      origenId: original.facturaRaizOrigenId,
      destinoId: original.facturaRaizDestinoId,
      tipo: tipo,
      centimos: centimos,
      fecha: fecha,
      movimientoOrigenId: original.id,
      motivo: motivo,
    );
    if (original.facturaRaizDestinoId != null) {
      await _sincronizarEstado(original.facturaRaizDestinoId!);
    }
    final origen = await _raiz(original.facturaRaizOrigenId);
    await _timelineCredito(
      origen,
      id,
      original.tipo == TipoMovimientoCreditoCliente.devolucion
          ? TimelineCreditoTipo.devolucionRevertida
          : TimelineCreditoTipo.compensacionRevertida,
      original.tipo == TipoMovimientoCreditoCliente.devolucion
          ? 'Devolución revertida'
          : 'Compensación revertida',
      '${creditoMoneda(centimos).toStringAsFixed(2)} € · ${motivo.trim()}',
      fecha,
    );
    return id;
  });

  Future<void> validarCreditoTrasCambio({
    required String facturaRaizId,
    required double nuevoNetoDocumental,
    double? nuevoTotalLiquidado,
  }) async {
    final resumen = await _resumen(facturaRaizId);
    final liquidado = monedaACentimos(
      nuevoTotalLiquidado ?? resumen.totalLiquidado,
    );
    final generado = (liquidado - monedaACentimos(nuevoNetoDocumental)).clamp(
      0,
      1 << 62,
    );
    if (generado < monedaACentimos(resumen.creditoDispuesto)) {
      throw const CreditoClienteException(
        'Existen devoluciones o compensaciones que deben revertirse primero.',
      );
    }
  }

  Future<CreditoClienteFamilia> _resumen(String raizId) async {
    final raiz = await _raiz(raizId);
    final cadena = await database.facturasDao.obtenerCadenaPorRaiz(raiz.id);
    final neto =
        monedaACentimos(raiz.total) +
        cadena
            .where(
              (f) =>
                  f.esRectificativa &&
                  f.estado != EstadoFactura.borrador &&
                  f.estado != EstadoFactura.anulada,
            )
            .fold<int>(0, (sum, f) => sum + monedaACentimos(f.efectoTotal));
    final cobros = monedaACentimos(
      calcularTotalCobradoNeto(
        await database.cobrosDao.obtenerPorFactura(raiz.id),
      ),
    );
    final movimientos = await database.movimientosCreditoClienteDao
        .obtenerTodos();
    var recibidas = 0;
    var devueltas = 0;
    var emitidas = 0;
    for (final m in movimientos) {
      final importe = monedaACentimos(m.importe);
      if (m.facturaRaizDestinoId == raiz.id) {
        if (m.tipo == TipoMovimientoCreditoCliente.compensacion) {
          recibidas += importe;
        }
        if (m.tipo == TipoMovimientoCreditoCliente.reversionCompensacion) {
          recibidas -= importe;
        }
      }
      if (m.facturaRaizOrigenId == raiz.id) {
        if (m.tipo == TipoMovimientoCreditoCliente.devolucion) {
          devueltas += importe;
        }
        if (m.tipo == TipoMovimientoCreditoCliente.reversionDevolucion) {
          devueltas -= importe;
        }
        if (m.tipo == TipoMovimientoCreditoCliente.compensacion) {
          emitidas += importe;
        }
        if (m.tipo == TipoMovimientoCreditoCliente.reversionCompensacion) {
          emitidas -= importe;
        }
      }
    }
    final liquidado = cobros + recibidas;
    final generado = (liquidado - neto).clamp(0, 1 << 62);
    final dispuesto = devueltas + emitidas;
    if (dispuesto > generado) {
      throw const CreditoClienteException(
        'La familia presenta una incoherencia económica.',
      );
    }
    final pendiente = (neto - liquidado).clamp(0, 1 << 62);
    return CreditoClienteFamilia(
      clienteId: raiz.clienteId,
      facturaRaizId: raiz.id,
      netoDocumental: creditoMoneda(neto),
      cobrosNetos: creditoMoneda(cobros),
      compensacionesRecibidas: creditoMoneda(recibidas),
      totalLiquidado: creditoMoneda(liquidado),
      creditoGenerado: creditoMoneda(generado),
      devolucionesNetas: creditoMoneda(devueltas),
      compensacionesEmitidas: creditoMoneda(emitidas),
      creditoDispuesto: creditoMoneda(dispuesto),
      creditoDisponible: creditoMoneda(generado - dispuesto),
      pendiente: creditoMoneda(pendiente),
      estado: CreditoClienteFamilia.resolver(
        liquidado: liquidado,
        pendiente: pendiente,
        generado: generado,
        dispuesto: dispuesto,
      ),
    );
  }

  Future<Factura> _factura(String id) async {
    final factura = await database.facturasDao.obtenerPorId(id);
    if (factura == null) {
      throw const CreditoClienteException('La factura no existe.');
    }
    return factura;
  }

  Future<Factura> _raiz(String id) async {
    final factura = await _factura(id);
    final raiz = factura.facturaRaizId == null
        ? factura
        : await _factura(factura.facturaRaizId!);
    if (raiz.esRectificativa) {
      throw const CreditoClienteException('La raíz documental no es válida.');
    }
    return raiz;
  }

  int _validarComun(double importe, DateTime fecha, String motivo) {
    final centimos = importe.isFinite ? monedaACentimos(importe) : 0;
    if (centimos <= 0) {
      throw const CreditoClienteException(
        'El importe debe ser mayor que cero.',
      );
    }
    if (_dia(fecha).isAfter(_dia(DateTime.now()))) {
      throw const CreditoClienteException('La fecha no puede ser futura.');
    }
    if (motivo.trim().length < 3) {
      throw const CreditoClienteException('El motivo es obligatorio.');
    }
    return centimos;
  }

  bool _requiereReferencia(String metodo) =>
      const {'Transferencia', 'Tarjeta', 'Domiciliacion'}.contains(metodo);
  DateTime _dia(DateTime value) => DateTime(value.year, value.month, value.day);

  Future<void> _insertar({
    required String id,
    required String clienteId,
    required String origenId,
    required TipoMovimientoCreditoCliente tipo,
    required int centimos,
    required DateTime fecha,
    required String motivo,
    String? destinoId,
    String? movimientoOrigenId,
    String? metodo,
    String referencia = '',
    String observaciones = '',
  }) => database.movimientosCreditoClienteDao.insertar(
    MovimientosCreditoClienteCompanion.insert(
      id: id,
      clienteId: clienteId,
      facturaRaizOrigenId: origenId,
      tipoMovimiento: tipo.name,
      importe: creditoMoneda(centimos),
      fecha: fecha,
      movimientoOrigenId: Value(movimientoOrigenId),
      facturaRaizDestinoId: Value(destinoId),
      metodo: Value(metodo),
      referencia: Value(referencia.trim()),
      motivo: motivo.trim(),
      observaciones: Value(observaciones.trim()),
    ),
  );

  Future<void> _sincronizarEstado(String raizId) async {
    final factura = await _raiz(raizId);
    final resumen = await _resumen(raizId);
    final estado = resolverEstadoDocumentalFactura(
      estadoActual: factura.estado,
      totalFactura: resumen.netoDocumental,
      totalCobrado: resumen.totalLiquidado,
      fechaVencimiento: factura.fechaVencimiento,
    );
    if (estado != factura.estado) {
      await database.facturasDao.actualizarEstado(
        raizId,
        estadoFacturaToString(estado),
      );
    }
  }

  Future<void> _timelineCredito(
    Factura factura,
    String movimientoId,
    TimelineCreditoTipo tipo,
    String titulo,
    String descripcion,
    DateTime fecha,
  ) async {
    final presupuestoId = factura.presupuestoOrigenId;
    if (presupuestoId == null) return;
    final presupuestos = await database.presupuestosDao
        .observarPresupuestos()
        .first;
    final expediente = presupuestos
        .where((p) => p.id == presupuestoId)
        .firstOrNull
        ?.expedienteId;
    if (expediente != null) {
      await _timeline.registrarMovimientoCredito(
        expedienteId: expediente,
        movimientoId: movimientoId,
        tipo: tipo,
        titulo: titulo,
        descripcion: descripcion,
        fecha: fecha,
      );
    }
  }
}

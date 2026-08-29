import 'dart:async';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../database/app_database.dart';
import '../../timeline/data/timeline_repository.dart';
import '../../presupuestos/domain/linea_presupuesto.dart';
import '../../presupuestos/domain/presupuesto.dart' as presupuesto_domain;
import '../domain/estado_factura.dart';
import '../domain/facturacion_parcial.dart';
import '../domain/factura_asignacion_presupuesto.dart';
import '../domain/factura.dart' as factura_domain;
import '../domain/redondeo_monetario.dart';

class FacturacionParcialRepository {
  FacturacionParcialRepository(this.database)
    : _timeline = TimelineRepository(database.timelineEventsDao);

  final AppDatabase database;
  final TimelineRepository _timeline;

  Stream<List<factura_domain.Factura>> observarFacturas(String presupuestoId) =>
      database.facturasDao.observarPorPresupuestoOrigen(presupuestoId);

  Future<factura_domain.Factura?> obtenerFactura(String facturaId) =>
      database.facturasDao.obtenerPorId(facturaId);

  Stream<ResumenFacturacionPresupuesto> observarResumen(String presupuestoId) {
    return Stream.multi((controller) {
      Object? presupuestos;
      Object? facturas;
      Object? asignaciones;

      void emitir() {
        if (presupuestos == null || facturas == null || asignaciones == null) {
          return;
        }
        final listaPresupuestos =
            presupuestos! as List<presupuesto_domain.Presupuesto>;
        final presupuesto = listaPresupuestos
            .where((item) => item.id == presupuestoId)
            .firstOrNull;
        if (presupuesto == null) {
          controller.addError(
            const FacturacionParcialException('El presupuesto no existe.'),
          );
          return;
        }
        controller.add(
          _calcularResumen(
            basePresupuestada: presupuesto.importeTotal,
            facturas: facturas! as List<factura_domain.Factura>,
            asignaciones: asignaciones! as List<FacturaAsignacionPresupuesto>,
          ),
        );
      }

      final subs = <StreamSubscription<dynamic>>[
        database.presupuestosDao.observarPresupuestos().listen((value) {
          presupuestos = value;
          emitir();
        }, onError: controller.addError),
        database.facturasDao.observarPorPresupuestoOrigen(presupuestoId).listen(
          (value) {
            facturas = value;
            emitir();
          },
          onError: controller.addError,
        ),
        database.facturaAsignacionesPresupuestoDao
            .observarPorPresupuesto(presupuestoId)
            .listen((value) {
              asignaciones = value;
              emitir();
            }, onError: controller.addError),
      ];
      controller.onCancel = () async {
        for (final sub in subs) {
          await sub.cancel();
        }
      };
    });
  }

  ResumenFacturacionPresupuesto _calcularResumen({
    required double basePresupuestada,
    required List<factura_domain.Factura> facturas,
    required List<FacturaAsignacionPresupuesto> asignaciones,
  }) {
    final activas = facturas
        .where((factura) => factura.estado != EstadoFactura.anulada)
        .toList();
    final idsActivas = activas.map((factura) => factura.id).toSet();
    final idsConAsignacion = asignaciones.map((item) => item.facturaId).toSet();
    var facturado = 0;
    var reservado = 0;
    for (final factura in activas) {
      final base = idsConAsignacion.contains(factura.id)
          ? asignaciones
                .where((item) => item.facturaId == factura.id)
                .fold<int>(
                  0,
                  (suma, item) => suma + monedaACentimos(item.baseAplicada),
                )
          : monedaACentimos(factura.subtotal);
      if (factura.estado == EstadoFactura.borrador) {
        if (!factura.esRectificativa || base > 0) reservado += base;
      } else {
        facturado += base;
      }
    }
    final total = monedaACentimos(basePresupuestada);
    return ResumenFacturacionPresupuesto(
      basePresupuestadaCentimos: total,
      facturadoCentimos: facturado,
      reservadoCentimos: reservado,
      pendienteCentimos: total - facturado - reservado,
      tieneConsumoLegacySinDetalle: activas.any(
        (factura) =>
            !factura.esRectificativa &&
            idsActivas.contains(factura.id) &&
            !idsConAsignacion.contains(factura.id),
      ),
    );
  }

  Future<String> crearPorPorcentaje({
    required String presupuestoId,
    required double porcentaje,
  }) async {
    if (!porcentaje.isFinite || porcentaje <= 0 || porcentaje > 100) {
      throw const FacturacionParcialException(
        'El porcentaje debe estar entre 0 y 100.',
      );
    }
    return database.transaction(() async {
      final contexto = await _cargarContexto(presupuestoId);
      final importe =
          (contexto.resumen.basePresupuestadaCentimos * porcentaje / 100)
              .round();
      return _crearProporcional(contexto, importe);
    });
  }

  Future<String> crearPorImporte({
    required String presupuestoId,
    required double importe,
  }) {
    if (!importe.isFinite || importe <= 0) {
      throw const FacturacionParcialException(
        'El importe debe ser mayor que cero.',
      );
    }
    return database.transaction(() async {
      final contexto = await _cargarContexto(presupuestoId);
      return _crearProporcional(contexto, monedaACentimos(importe));
    });
  }

  Future<String> crearPorPartidas({
    required String presupuestoId,
    required List<SeleccionPartidaFactura> selecciones,
  }) => database.transaction(() async {
    final contexto = await _cargarContexto(presupuestoId);
    if (contexto.resumen.tieneConsumoLegacySinDetalle) {
      throw const FacturacionParcialException(
        'Hay facturas legacy sin detalle de asignaciones; no se puede demostrar la disponibilidad por partida.',
      );
    }
    if (selecciones.isEmpty) {
      throw const FacturacionParcialException(
        'Selecciona al menos una partida.',
      );
    }
    final consumos = _consumosActivos(contexto);
    final asignaciones = <AsignacionFacturaParcial>[];
    final usadas = <String>{};
    for (final seleccion in selecciones) {
      if (!usadas.add(seleccion.lineaPresupuestoId)) {
        throw const FacturacionParcialException('Una partida está repetida.');
      }
      final linea = contexto.lineas
          .where((item) => item.id == seleccion.lineaPresupuestoId)
          .firstOrNull;
      if (linea == null) {
        throw const FacturacionParcialException(
          'Una partida no pertenece al presupuesto.',
        );
      }
      final cantidad = seleccion.cantidad;
      final importe = seleccion.importe;
      if ((cantidad == null) == (importe == null)) {
        throw const FacturacionParcialException(
          'Indica cantidad o importe, pero no ambos.',
        );
      }
      if (cantidad != null && (!cantidad.isFinite || cantidad <= 0)) {
        throw const FacturacionParcialException(
          'La cantidad debe ser mayor que cero.',
        );
      }
      if (importe != null && (!importe.isFinite || importe <= 0)) {
        throw const FacturacionParcialException(
          'El importe debe ser mayor que cero.',
        );
      }
      final base = cantidad != null
          ? monedaACentimos(cantidad * linea.precioUnitario)
          : monedaACentimos(importe!);
      if (base <= 0) {
        throw const FacturacionParcialException(
          'La asignación debe ser mayor que cero.',
        );
      }
      final baseDisponible =
          monedaACentimos(linea.importe) -
          (consumos.basePorLinea[linea.id] ?? 0);
      if (base > baseDisponible) {
        throw const FacturacionParcialException(
          'La partida supera su importe disponible.',
        );
      }
      if (cantidad != null) {
        final disponible =
            linea.cantidad - (consumos.cantidadPorLinea[linea.id] ?? 0);
        if (cantidad > disponible + 0.000000001) {
          throw const FacturacionParcialException(
            'La partida supera su cantidad disponible.',
          );
        }
      }
      asignaciones.add(
        AsignacionFacturaParcial(
          linea: linea,
          baseCentimos: base,
          cantidad: cantidad,
        ),
      );
    }
    return _persistir(contexto, asignaciones);
  });

  Future<String> _crearProporcional(_Contexto contexto, int importe) async {
    if (contexto.resumen.tieneConsumoLegacySinDetalle) {
      throw const FacturacionParcialException(
        'Hay facturas legacy sin detalle; solo pueden consultarse hasta su regularización.',
      );
    }
    if (importe > contexto.resumen.pendienteCentimos) {
      throw const FacturacionParcialException(
        'El importe supera el pendiente disponible.',
      );
    }
    final consumos = _consumosActivos(contexto);
    final asignaciones = repartirProporcionalmente(
      importeCentimos: importe,
      lineas: contexto.lineas,
      consumidoPorLineaCentimos: consumos.basePorLinea,
    );
    return _persistir(contexto, asignaciones);
  }

  Future<String> _persistir(
    _Contexto contexto,
    List<AsignacionFacturaParcial> asignaciones,
  ) async {
    final total = asignaciones.fold<int>(0, (s, item) => s + item.baseCentimos);
    if (total <= 0 || total > contexto.resumen.pendienteCentimos) {
      throw const FacturacionParcialException(
        'La asignación supera el disponible.',
      );
    }
    final facturaId = const Uuid().v4();
    final ahora = DateTime.now();
    final iva = contexto.presupuesto.ivaPorcentaje;
    final ivaCentimos = monedaACentimos(centimosAMoneda(total) * iva / 100);
    await database.facturasDao.insertarFactura(
      FacturasCompanion.insert(
        id: facturaId,
        clienteId: contexto.clienteId,
        fecha: Value(ahora),
        fechaVencimiento: Value(ahora.add(const Duration(days: 30))),
        subtotal: Value(centimosAMoneda(total)),
        iva: Value(centimosAMoneda(ivaCentimos)),
        ivaPorcentaje: Value(iva),
        total: Value(centimosAMoneda(total + ivaCentimos)),
        observaciones: Value(contexto.presupuesto.descripcion),
        presupuestoOrigenId: Value(contexto.presupuesto.id),
      ),
    );
    for (final asignacion in asignaciones) {
      final lineaId = const Uuid().v4();
      final cantidad = asignacion.cantidad ?? 1;
      final precio = asignacion.cantidad == null
          ? asignacion.base
          : asignacion.linea.precioUnitario;
      await database.facturaLineasDao.insertarLinea(
        FacturaLineasCompanion.insert(
          id: lineaId,
          facturaId: facturaId,
          descripcion: asignacion.linea.concepto,
          cantidad: cantidad,
          unidad: Value(
            asignacion.cantidad == null ? 'importe' : asignacion.linea.unidad,
          ),
          precioUnitario: precio,
          importe: Value(asignacion.base),
        ),
      );
      await database.facturaAsignacionesPresupuestoDao.insertar(
        FacturaAsignacionesPresupuestoCompanion.insert(
          id: const Uuid().v4(),
          facturaId: facturaId,
          facturaLineaId: lineaId,
          presupuestoId: contexto.presupuesto.id,
          lineaPresupuestoId: asignacion.linea.id,
          cantidadAplicada: Value(asignacion.cantidad),
          baseAplicada: asignacion.base,
        ),
      );
    }
    await _timeline.registrarFacturaCreada(
      expedienteId: contexto.presupuesto.expedienteId,
      facturaId: facturaId,
      titulo: 'Factura parcial creada',
      descripcion:
          'Reserva ${centimosAMoneda(total).toStringAsFixed(2)} € de ${contexto.presupuesto.codigo}',
    );
    return facturaId;
  }

  Future<_Contexto> _cargarContexto(String presupuestoId) async {
    final presupuestos = await database.presupuestosDao
        .observarPresupuestos()
        .first;
    final presupuesto = presupuestos
        .where((p) => p.id == presupuestoId)
        .firstOrNull;
    if (presupuesto == null) {
      throw const FacturacionParcialException('El presupuesto no existe.');
    }
    if (presupuesto.estado.trim().toLowerCase() != 'aceptado') {
      throw const FacturacionParcialException(
        'El presupuesto debe estar aceptado.',
      );
    }
    final expediente = await database.expedientesDao.obtenerExpediente(
      presupuesto.expedienteId,
    );
    final clienteId = expediente?.clienteId;
    if (clienteId == null || clienteId.isEmpty) {
      throw const FacturacionParcialException(
        'El expediente no tiene cliente.',
      );
    }
    final facturas = await database.facturasDao.obtenerPorPresupuestoOrigen(
      presupuestoId,
    );
    final asignaciones = await database.facturaAsignacionesPresupuestoDao
        .obtenerPorPresupuesto(presupuestoId);
    final lineas = await database.lineasPresupuestoDao.obtenerPorPresupuesto(
      presupuestoId,
    );
    final resumen = _calcularResumen(
      basePresupuestada: presupuesto.importeTotal,
      facturas: facturas,
      asignaciones: asignaciones,
    );
    return _Contexto(
      presupuesto: presupuesto,
      clienteId: clienteId,
      facturas: facturas,
      asignaciones: asignaciones,
      lineas: lineas,
      resumen: resumen,
    );
  }

  _Consumos _consumosActivos(_Contexto contexto) {
    final ids = contexto.facturas
        .where(
          (f) =>
              f.estado != EstadoFactura.anulada &&
              (!f.esRectificativa ||
                  f.estado != EstadoFactura.borrador ||
                  f.efectoBase > 0),
        )
        .map((f) => f.id)
        .toSet();
    final base = <String, int>{};
    final cantidad = <String, double>{};
    for (final item in contexto.asignaciones.where(
      (a) => ids.contains(a.facturaId),
    )) {
      base.update(
        item.lineaPresupuestoId,
        (value) => value + monedaACentimos(item.baseAplicada),
        ifAbsent: () => monedaACentimos(item.baseAplicada),
      );
      if (item.cantidadAplicada != null) {
        cantidad.update(
          item.lineaPresupuestoId,
          (value) => value + item.cantidadAplicada!,
          ifAbsent: () => item.cantidadAplicada!,
        );
      }
    }
    return _Consumos(basePorLinea: base, cantidadPorLinea: cantidad);
  }
}

class _Contexto {
  const _Contexto({
    required this.presupuesto,
    required this.clienteId,
    required this.facturas,
    required this.asignaciones,
    required this.lineas,
    required this.resumen,
  });
  final presupuesto_domain.Presupuesto presupuesto;
  final String clienteId;
  final List<factura_domain.Factura> facturas;
  final List<FacturaAsignacionPresupuesto> asignaciones;
  final List<LineaPresupuesto> lineas;
  final ResumenFacturacionPresupuesto resumen;
}

class _Consumos {
  const _Consumos({required this.basePorLinea, required this.cantidadPorLinea});
  final Map<String, int> basePorLinea;
  final Map<String, double> cantidadPorLinea;
}

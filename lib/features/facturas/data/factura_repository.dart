import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/database/database_provider.dart';
import 'package:obraia_v2/features/cobros/domain/factura_estado_economico.dart';
import 'package:obraia_v2/features/facturas/domain/estado_factura.dart';
import 'package:obraia_v2/features/facturas/domain/factura.dart'
    as factura_domain;
import 'package:obraia_v2/features/presupuestos/domain/presupuesto.dart'
    as presupuesto_domain;
import 'package:obraia_v2/features/timeline/data/timeline_repository.dart';
import 'package:uuid/uuid.dart';

final facturaRepositoryProvider = Provider<FacturaRepository>((ref) {
  final database = ref.read(databaseProvider);
  return FacturaRepository(database);
});

class PresupuestoYaConvertidoException implements Exception {
  const PresupuestoYaConvertidoException({
    required this.presupuestoId,
    required this.facturaId,
  });

  final String presupuestoId;
  final String facturaId;
}

class FacturaRepository {
  final AppDatabase database;
  final TimelineRepository _timelineRepository;

  FacturaRepository(this.database)
    : _timelineRepository = TimelineRepository(database.timelineEventsDao);

  Stream<List<factura_domain.Factura>> observarFacturas() {
    return database.facturasDao.observarFacturas();
  }

  Stream<List<FacturaConEstadoEconomico>> observarFacturasConEstadoEconomico() {
    return _observarConEstadoEconomico(observarFacturas());
  }

  Stream<List<FacturaConEstadoEconomico>> observarPorClienteConEstadoEconomico(
    String clienteId,
  ) {
    return _observarConEstadoEconomico(observarPorCliente(clienteId));
  }

  Stream<List<FacturaConEstadoEconomico>>
  observarPorExpedienteConEstadoEconomico(String expedienteId) {
    return _observarConEstadoEconomico(observarPorExpediente(expedienteId));
  }

  Stream<List<FacturaConEstadoEconomico>> _observarConEstadoEconomico(
    Stream<List<factura_domain.Factura>> facturasStream,
  ) {
    return Stream<List<FacturaConEstadoEconomico>>.multi((controller) {
      List<factura_domain.Factura>? facturas;
      Map<String, double>? cobradoPorFactura;

      void emitirSiCompleto() {
        final facturasActuales = facturas;
        final cobrosActuales = cobradoPorFactura;
        if (facturasActuales == null || cobrosActuales == null) {
          return;
        }

        final fechaReferencia = DateTime.now();
        controller.add(
          facturasActuales.map((factura) {
            final totalCobrado = cobrosActuales[factura.id] ?? 0;
            return FacturaConEstadoEconomico(
              factura: factura,
              estadoEconomico: calcularResumenEconomicoFactura(
                totalFactura: factura.total,
                totalCobrado: totalCobrado,
                fechaVencimiento: factura.fechaVencimiento,
                estadoFactura: factura.estado,
                fechaReferencia: fechaReferencia,
              ),
            );
          }).toList(),
        );
      }

      final facturasSubscription = facturasStream.listen((data) {
        facturas = data;
        emitirSiCompleto();
      }, onError: controller.addError);
      final cobrosSubscription = database.cobrosDao.observarCobros().listen((
        cobros,
      ) {
        final agrupados = <String, double>{};
        for (final cobro in cobros) {
          agrupados.update(
            cobro.facturaId,
            (total) => total + cobro.importe,
            ifAbsent: () => cobro.importe,
          );
        }
        cobradoPorFactura = agrupados;
        emitirSiCompleto();
      }, onError: controller.addError);

      controller.onCancel = () async {
        await facturasSubscription.cancel();
        await cobrosSubscription.cancel();
      };
    });
  }

  Stream<List<factura_domain.Factura>> observarPorCliente(String clienteId) {
    return database.facturasDao.observarPorCliente(clienteId);
  }

  Stream<List<factura_domain.Factura>> observarPorExpediente(
    String expedienteId,
  ) {
    return database.facturasDao.observarPorExpediente(expedienteId);
  }

  Future<factura_domain.Factura?> obtenerPorId(String facturaId) {
    return database.facturasDao.obtenerPorId(facturaId);
  }

  Future<String> _generarCodigoFactura() async {
    final year = DateTime.now().year;
    final prefijo = 'FAC-$year-';

    final codigosExistentes = await database.facturasDao
        .obtenerCodigosPorPrefijo(prefijo);

    var maxCorrelativo = 0;

    for (final codigo in codigosExistentes) {
      if (!codigo.startsWith(prefijo)) {
        continue;
      }

      final valor = int.tryParse(codigo.substring(prefijo.length));
      if (valor != null && valor > maxCorrelativo) {
        maxCorrelativo = valor;
      }
    }

    final siguiente = maxCorrelativo + 1;
    final correlativo = siguiente.toString().padLeft(4, '0');
    return '$prefijo$correlativo';
  }

  Future<String> crearFactura({
    required String clienteId,
    required DateTime fecha,
    required DateTime fechaVencimiento,
    EstadoFactura estado = EstadoFactura.borrador,
    double subtotal = 0,
    double iva = 0,
    double total = 0,
    String observaciones = '',
    String? presupuestoOrigenId,
  }) async {
    final facturaId = const Uuid().v4();
    final codigo = await _generarCodigoFactura();

    await database.facturasDao.insertarFactura(
      FacturasCompanion.insert(
        id: facturaId,
        codigo: Value(codigo),
        clienteId: clienteId,
        fecha: Value(fecha),
        fechaVencimiento: Value(fechaVencimiento),
        estado: Value(estadoFacturaToString(estado)),
        subtotal: Value(subtotal),
        iva: Value(iva),
        total: Value(total),
        observaciones: Value(observaciones),
        presupuestoOrigenId: presupuestoOrigenId == null
            ? const Value.absent()
            : Value(presupuestoOrigenId),
      ),
    );

    return facturaId;
  }

  Future<String> convertirDesdePresupuesto(
    presupuesto_domain.Presupuesto presupuesto,
  ) async {
    final facturaExistenteId = await database.facturasDao
        .obtenerIdPorPresupuestoOrigen(presupuesto.id);
    if (facturaExistenteId != null) {
      throw PresupuestoYaConvertidoException(
        presupuestoId: presupuesto.id,
        facturaId: facturaExistenteId,
      );
    }

    final expediente = await database.expedientesDao.obtenerExpediente(
      presupuesto.expedienteId,
    );

    final clienteId = expediente?.clienteId;
    if (clienteId == null || clienteId.trim().isEmpty) {
      throw Exception(
        'El presupuesto no tiene cliente asociado en su expediente.',
      );
    }

    final lineas = await database.lineasPresupuestoDao.obtenerPorPresupuesto(
      presupuesto.id,
    );

    final subtotal = presupuesto.importeTotal;
    final iva = subtotal * presupuesto.ivaPorcentaje / 100;
    final total = subtotal + iva;
    final fechaFactura = DateTime.now();
    final fechaVencimiento = fechaFactura.add(const Duration(days: 30));

    late final String facturaId;

    await database.transaction(() async {
      facturaId = await crearFactura(
        clienteId: clienteId,
        fecha: fechaFactura,
        fechaVencimiento: fechaVencimiento,
        estado: EstadoFactura.borrador,
        subtotal: subtotal,
        iva: iva,
        total: total,
        observaciones: presupuesto.descripcion,
        presupuestoOrigenId: presupuesto.id,
      );

      for (final linea in lineas) {
        await database.facturaLineasDao.insertarLinea(
          FacturaLineasCompanion.insert(
            id: const Uuid().v4(),
            facturaId: facturaId,
            descripcion: linea.concepto,
            cantidad: linea.cantidad,
            unidad: const Value('ud'),
            precioUnitario: linea.precioUnitario,
            descuento: const Value(0),
            importe: Value(linea.importe),
          ),
        );
      }

      await _timelineRepository.registrarFacturaCreada(
        expedienteId: presupuesto.expedienteId,
        facturaId: facturaId,
        titulo: 'Factura creada',
        descripcion: 'Generada desde presupuesto ${presupuesto.codigo}',
      );
    });

    return facturaId;
  }

  Future<void> actualizarTotales({
    required String facturaId,
    required double subtotal,
    required double iva,
  }) {
    final total = subtotal + iva;

    return database.facturasDao.actualizarTotales(
      facturaId: facturaId,
      subtotal: subtotal,
      iva: iva,
      total: total,
    );
  }

  Future<void> actualizarEstado(String facturaId, EstadoFactura estado) {
    return _actualizarEstadoConEvento(
      facturaId: facturaId,
      nuevoEstado: estado,
    );
  }

  Future<void> actualizarFactura({
    required String id,
    required String clienteId,
    required DateTime fecha,
    required DateTime fechaVencimiento,
    required EstadoFactura estado,
    required String observaciones,
  }) async {
    final facturaActual = await database.facturasDao.obtenerPorId(id);

    await database.facturasDao.actualizarFactura(
      id: id,
      clienteId: clienteId,
      fecha: fecha,
      fechaVencimiento: fechaVencimiento,
      estado: estadoFacturaToString(estado),
      observaciones: observaciones,
    );

    if (_esTransicionRealAAnulada(
      estadoAnterior: facturaActual?.estado,
      estadoNuevo: estado,
    )) {
      await _registrarFacturaAnuladaSiAplica(
        facturaId: id,
        facturaCodigo: facturaActual?.codigo,
        presupuestoOrigenId: facturaActual?.presupuestoOrigenId,
      );
    }
  }

  Future<void> eliminarFactura(String facturaId) async {
    await database.transaction(() async {
      await database.cobrosDao.eliminarPorFactura(facturaId);
      await database.facturaLineasDao.eliminarPorFactura(facturaId);
      await database.facturasDao.eliminarFactura(facturaId);
    });
  }

  Future<void> _actualizarEstadoConEvento({
    required String facturaId,
    required EstadoFactura nuevoEstado,
  }) async {
    final facturaActual = await database.facturasDao.obtenerPorId(facturaId);

    await database.facturasDao.actualizarEstado(
      facturaId,
      estadoFacturaToString(nuevoEstado),
    );

    if (_esTransicionRealAAnulada(
      estadoAnterior: facturaActual?.estado,
      estadoNuevo: nuevoEstado,
    )) {
      await _registrarFacturaAnuladaSiAplica(
        facturaId: facturaId,
        facturaCodigo: facturaActual?.codigo,
        presupuestoOrigenId: facturaActual?.presupuestoOrigenId,
      );
    }
  }

  bool _esTransicionRealAAnulada({
    required EstadoFactura? estadoAnterior,
    required EstadoFactura estadoNuevo,
  }) {
    if (estadoNuevo != EstadoFactura.anulada) {
      return false;
    }

    if (estadoAnterior == null) {
      return false;
    }

    return estadoAnterior != EstadoFactura.anulada;
  }

  Future<void> _registrarFacturaAnuladaSiAplica({
    required String facturaId,
    required String? facturaCodigo,
    required String? presupuestoOrigenId,
  }) async {
    final expedienteId = await _obtenerExpedienteIdDesdePresupuestoOrigen(
      presupuestoOrigenId,
    );
    if (expedienteId == null || expedienteId.trim().isEmpty) {
      return;
    }

    await _timelineRepository.registrarFacturaAnulada(
      expedienteId: expedienteId,
      facturaId: facturaId,
      titulo: 'Factura anulada',
      descripcion: facturaCodigo,
    );
  }

  Future<String?> _obtenerExpedienteIdDesdePresupuestoOrigen(
    String? presupuestoOrigenId,
  ) async {
    if (presupuestoOrigenId == null || presupuestoOrigenId.trim().isEmpty) {
      return null;
    }

    final presupuestos = await database.presupuestosDao
        .observarPresupuestos()
        .first;

    for (final presupuesto in presupuestos) {
      if (presupuesto.id == presupuestoOrigenId) {
        return presupuesto.expedienteId;
      }
    }

    return null;
  }
}

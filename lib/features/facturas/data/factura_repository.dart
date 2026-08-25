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

class FacturaEmisionException implements Exception {
  const FacturaEmisionException(this.mensaje);
  final String mensaje;
}

class FacturaAnulacionConCobrosException implements Exception {
  const FacturaAnulacionConCobrosException();
}

class FacturaRepository {
  final AppDatabase database;
  final TimelineRepository _timelineRepository;

  FacturaRepository(this.database)
    : _timelineRepository = TimelineRepository(database.timelineEventsDao);

  Stream<List<factura_domain.Factura>> observarFacturas() {
    return database.facturasDao.observarFacturas().asyncMap((facturas) async {
      final cambio = await _reconciliarFacturas(facturas);
      return cambio ? database.facturasDao.observarFacturas().first : facturas;
    });
  }

  Stream<List<factura_domain.Factura>> observarFacturadoEnMes(DateTime mes) {
    return observarFacturas().map(
      (facturas) => facturas.where((factura) {
        return estadoFacturaEsEfectiva(factura.estado) &&
            factura.fecha.year == mes.year &&
            factura.fecha.month == mes.month;
      }).toList(),
    );
  }

  Stream<List<FacturaConEstadoEconomico>>
  observarFacturadoEnMesConEstadoEconomico(DateTime mes) {
    return _observarConEstadoEconomico(observarFacturadoEnMes(mes));
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
    return observarFacturas().map(
      (facturas) =>
          facturas.where((factura) => factura.clienteId == clienteId).toList(),
    );
  }

  Stream<List<factura_domain.Factura>> observarPorExpediente(
    String expedienteId,
  ) {
    return observarFacturas().asyncMap((facturas) async {
      final presupuestos = await database.presupuestosDao
          .observarPresupuestos()
          .first;
      final ids = presupuestos
          .where((p) => p.expedienteId == expedienteId)
          .map((p) => p.id)
          .toSet();
      return facturas
          .where(
            (f) =>
                f.presupuestoOrigenId != null &&
                ids.contains(f.presupuestoOrigenId),
          )
          .toList();
    });
  }

  Future<factura_domain.Factura?> obtenerPorId(String facturaId) async {
    final factura = await database.facturasDao.obtenerPorId(facturaId);
    if (factura == null) return null;
    await _reconciliarFactura(factura);
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
        estado: const Value('borrador'),
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
  }) async {
    final total = subtotal + iva;
    await database.facturasDao.actualizarTotales(
      facturaId: facturaId,
      subtotal: subtotal,
      iva: iva,
      total: total,
    );
    final factura = await database.facturasDao.obtenerPorId(facturaId);
    if (factura != null) await _reconciliarFactura(factura);
  }

  Future<void> actualizarEstado(String facturaId, EstadoFactura estado) async {
    if (estado == EstadoFactura.emitida) {
      await emitirFactura(facturaId);
      return;
    }
    if (estado == EstadoFactura.anulada) {
      await anularFactura(facturaId);
      return;
    }
    throw StateError(
      'El estado documental no puede seleccionarse manualmente.',
    );
  }

  Future<void> actualizarFactura({
    required String id,
    required String clienteId,
    required DateTime fecha,
    required DateTime fechaVencimiento,
    required String observaciones,
  }) async {
    final facturaActual = await database.facturasDao.obtenerPorId(id);

    await database.transaction(() async {
      await database.facturasDao.actualizarFactura(
        id: id,
        clienteId: clienteId,
        fecha: fecha,
        fechaVencimiento: fechaVencimiento,
        estado: estadoFacturaToString(
          facturaActual?.estado ?? EstadoFactura.borrador,
        ),
        observaciones: observaciones,
      );
      final actualizada = await database.facturasDao.obtenerPorId(id);
      if (actualizada != null) {
        await _reconciliarFactura(actualizada);
      }
    });
  }

  Future<void> emitirFactura(String facturaId) async {
    await database.transaction(() async {
      final factura = await database.facturasDao.obtenerPorId(facturaId);
      if (factura == null) {
        throw const FacturaEmisionException('La factura no existe.');
      }
      final cliente = await database.clientesDao.obtenerCliente(
        factura.clienteId,
      );
      final lineas = await database.facturaLineasDao.obtenerPorFactura(
        facturaId,
      );
      final motivo = validarEmisionFactura(
        estadoActual: factura.estado,
        clienteExiste: cliente != null && !cliente.eliminado,
        lineas: lineas.map(
          (linea) => DatosLineaEmision(
            cantidad: linea.cantidad,
            precioUnitario: linea.precioUnitario,
          ),
        ),
        total: factura.total,
        fechaFactura: factura.fecha,
        fechaVencimiento: factura.fechaVencimiento,
      );
      if (motivo != null) {
        throw FacturaEmisionException(motivo);
      }
      final cobros = await database.cobrosDao
          .observarPorFactura(facturaId)
          .first;
      final cobrado = cobros.fold<double>(
        0,
        (suma, cobro) => suma + cobro.importe,
      );
      final estado = resolverEstadoDocumentalFactura(
        estadoActual: EstadoFactura.emitida,
        totalFactura: factura.total,
        totalCobrado: cobrado,
        fechaVencimiento: factura.fechaVencimiento,
      );
      await database.facturasDao.actualizarEstado(
        facturaId,
        estadoFacturaToString(estado),
      );
    });
  }

  Future<void> anularFactura(String facturaId) async {
    await database.transaction(() async {
      final factura = await database.facturasDao.obtenerPorId(facturaId);
      if (factura == null || factura.estado == EstadoFactura.anulada) return;
      final cobros = await database.cobrosDao
          .observarPorFactura(facturaId)
          .first;
      if (cobros.isNotEmpty) throw const FacturaAnulacionConCobrosException();
      await _actualizarEstadoConEvento(
        facturaId: facturaId,
        nuevoEstado: EstadoFactura.anulada,
      );
    });
  }

  Future<bool> _reconciliarFacturas(
    List<factura_domain.Factura> facturas,
  ) async {
    var cambio = false;
    await database.transaction(() async {
      for (final factura in facturas) {
        cambio = await _reconciliarFactura(factura) || cambio;
      }
    });
    return cambio;
  }

  Future<bool> _reconciliarFactura(factura_domain.Factura factura) async {
    final cobros = await database.cobrosDao
        .observarPorFactura(factura.id)
        .first;
    final cobrado = cobros.fold<double>(
      0,
      (suma, cobro) => suma + cobro.importe,
    );
    final estado = resolverEstadoDocumentalFactura(
      estadoActual: factura.estado,
      totalFactura: factura.total,
      totalCobrado: cobrado,
      fechaVencimiento: factura.fechaVencimiento,
    );
    if (estado == factura.estado) return false;
    await database.facturasDao.actualizarEstado(
      factura.id,
      estadoFacturaToString(estado),
    );
    return true;
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

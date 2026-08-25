import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/database/database_provider.dart';
import 'package:obraia_v2/features/cobros/domain/cobro.dart' as cobro_domain;
import 'package:obraia_v2/features/cobros/domain/factura_estado_economico.dart';
import 'package:obraia_v2/features/facturas/domain/estado_factura.dart';
import 'package:obraia_v2/features/timeline/data/timeline_repository.dart';
import 'package:uuid/uuid.dart';

final cobroRepositoryProvider = Provider<CobroRepository>((ref) {
  final database = ref.read(databaseProvider);
  return CobroRepository(database);
});

class CobroSuperaPendienteException implements Exception {
  const CobroSuperaPendienteException({
    required this.facturaId,
    required this.importeSolicitado,
    required this.pendienteActual,
  });

  final String facturaId;
  final double importeSolicitado;
  final double pendienteActual;
}

class FacturaNoEncontradaException implements Exception {
  const FacturaNoEncontradaException({required this.facturaId});

  final String facturaId;
}

class FacturaNoCobrableException implements Exception {
  const FacturaNoCobrableException({required this.facturaId});

  final String facturaId;
}

class CobroRepository {
  final AppDatabase database;
  final TimelineRepository _timelineRepository;

  CobroRepository(this.database)
    : _timelineRepository = TimelineRepository(database.timelineEventsDao);

  Stream<List<cobro_domain.Cobro>> observarPorFactura(String facturaId) {
    return database.cobrosDao.observarPorFactura(facturaId);
  }

  Stream<List<cobro_domain.Cobro>> observarCobros() {
    return database.cobrosDao.observarCobros();
  }

  Stream<List<cobro_domain.Cobro>> observarCobrosEnMesConFactura(DateTime mes) {
    return Stream<List<cobro_domain.Cobro>>.multi((controller) {
      List<cobro_domain.Cobro>? cobros;
      Set<String>? facturasExistentes;

      void emitirSiCompleto() {
        final cobrosActuales = cobros;
        final idsFactura = facturasExistentes;
        if (cobrosActuales == null || idsFactura == null) {
          return;
        }

        controller.add(
          cobrosActuales
              .where(
                (cobro) =>
                    cobro.fecha.year == mes.year &&
                    cobro.fecha.month == mes.month &&
                    idsFactura.contains(cobro.facturaId),
              )
              .toList(),
        );
      }

      final cobrosSubscription = observarCobros().listen((data) {
        cobros = data;
        emitirSiCompleto();
      }, onError: controller.addError);
      final facturasSubscription = database.facturasDao
          .observarFacturas()
          .listen((data) {
            facturasExistentes = data.map((factura) => factura.id).toSet();
            emitirSiCompleto();
          }, onError: controller.addError);

      controller.onCancel = () async {
        await cobrosSubscription.cancel();
        await facturasSubscription.cancel();
      };
    });
  }

  Stream<double> observarTotalCobradoPorFactura(String facturaId) {
    return observarPorFactura(facturaId).map((cobros) {
      return cobros.fold<double>(0, (sum, cobro) => sum + cobro.importe);
    });
  }

  Stream<FacturaEstadoEconomico> observarEstadoEconomicoFactura({
    required String facturaId,
    required double totalFactura,
  }) {
    return observarTotalCobradoPorFactura(facturaId).map((totalCobrado) {
      final pendiente = (totalFactura - totalCobrado)
          .clamp(0, double.infinity)
          .toDouble();

      return FacturaEstadoEconomico(
        totalFactura: totalFactura,
        totalCobrado: totalCobrado,
        pendiente: pendiente,
        estado: calcularEstadoEconomicoFactura(
          totalFactura: totalFactura,
          totalCobrado: totalCobrado,
        ),
      );
    });
  }

  Future<cobro_domain.Cobro?> obtenerPorId(String id) {
    return database.cobrosDao.obtenerPorId(id);
  }

  Future<void> crearCobro({
    required String facturaId,
    required DateTime fecha,
    required double importe,
    required String metodoPago,
    String referencia = '',
    String observaciones = '',
  }) async {
    final factura = await database.facturasDao.obtenerPorId(facturaId);
    if (factura == null) {
      throw FacturaNoEncontradaException(facturaId: facturaId);
    }

    if (!estadoFacturaAdmiteNuevosCobros(factura.estado)) {
      throw FacturaNoCobrableException(facturaId: facturaId);
    }

    final cobrosActuales = await database.cobrosDao
        .observarPorFactura(facturaId)
        .first;
    final totalCobrado = cobrosActuales.fold<double>(
      0,
      (sum, cobro) => sum + cobro.importe,
    );

    final pendienteActual = (factura.total - totalCobrado)
        .clamp(0, double.infinity)
        .toDouble();

    const epsilon = 0.000001;
    if (importe - pendienteActual > epsilon) {
      throw CobroSuperaPendienteException(
        facturaId: facturaId,
        importeSolicitado: importe,
        pendienteActual: pendienteActual,
      );
    }

    final cobroId = const Uuid().v4();

    await database.cobrosDao.insertarCobro(
      CobrosCompanion.insert(
        id: cobroId,
        facturaId: facturaId,
        fecha: Value(fecha),
        importe: Value(importe),
        metodoPago: Value(metodoPago),
        referencia: Value(referencia),
        observaciones: Value(observaciones),
      ),
    );

    final expedienteId = await _obtenerExpedienteIdDesdePresupuestoOrigen(
      factura.presupuestoOrigenId,
    );
    if (expedienteId == null || expedienteId.trim().isEmpty) {
      return;
    }

    await _timelineRepository.registrarCobroRegistrado(
      expedienteId: expedienteId,
      cobroId: cobroId,
      titulo: 'Cobro registrado',
      descripcion: factura.codigo,
      fecha: fecha,
    );
  }

  Future<void> actualizarCobro({
    required String id,
    required DateTime fecha,
    required double importe,
    required String metodoPago,
    required String referencia,
    required String observaciones,
  }) {
    return database.cobrosDao.actualizarCobro(
      id: id,
      fecha: fecha,
      importe: importe,
      metodoPago: metodoPago,
      referencia: referencia,
      observaciones: observaciones,
    );
  }

  Future<void> eliminarCobro(String id) {
    return database.cobrosDao.eliminarCobro(id);
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

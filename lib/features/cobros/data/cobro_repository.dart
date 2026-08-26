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

class CobroNoEncontradoException implements Exception {
  const CobroNoEncontradoException({required this.cobroId});

  final String cobroId;
}

class ImporteCobroNoValidoException implements Exception {
  const ImporteCobroNoValidoException({required this.importe});

  final double importe;
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

  Stream<List<cobro_domain.Cobro>> observarCobrosOperativos() {
    return _observarCobrosOperativos(mes: null);
  }

  Stream<List<cobro_domain.Cobro>> observarCobrosEnMesConFactura(DateTime mes) {
    return _observarCobrosOperativos(mes: mes);
  }

  Stream<List<cobro_domain.Cobro>> _observarCobrosOperativos({DateTime? mes}) {
    return Stream<List<cobro_domain.Cobro>>.multi((controller) {
      List<cobro_domain.Cobro>? cobros;
      Set<String>? facturasOperativas;

      void emitirSiCompleto() {
        final cobrosActuales = cobros;
        final idsFactura = facturasOperativas;
        if (cobrosActuales == null || idsFactura == null) return;

        controller.add(
          cobrosActuales.where((cobro) {
            return idsFactura.contains(cobro.facturaId) &&
                (mes == null ||
                    (cobro.fecha.year == mes.year &&
                        cobro.fecha.month == mes.month));
          }).toList(),
        );
      }

      final cobrosSubscription = observarCobros().listen((data) {
        cobros = data;
        emitirSiCompleto();
      }, onError: controller.addError);
      final facturasSubscription = database.facturasDao
          .observarFacturas()
          .listen((data) {
            facturasOperativas = data
                .where((factura) => estadoFacturaEsEfectiva(factura.estado))
                .map((factura) => factura.id)
                .toSet();
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
    await database.transaction(() async {
      final factura = await database.facturasDao.obtenerPorId(facturaId);
      if (factura == null) {
        throw FacturaNoEncontradaException(facturaId: facturaId);
      }
      if (!estadoFacturaAdmiteNuevosCobros(factura.estado)) {
        throw FacturaNoCobrableException(facturaId: facturaId);
      }
      _validarImporteCobro(importe);

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
      if (importe - pendienteActual > facturaEstadoEconomicoEpsilon) {
        throw CobroSuperaPendienteException(
          facturaId: facturaId,
          importeSolicitado: importe,
          pendienteActual: pendienteActual,
        );
      }

      final cobroId = const Uuid().v4();
      final expedienteId = await _obtenerExpedienteIdDesdePresupuestoOrigen(
        factura.presupuestoOrigenId,
      );
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
      await _sincronizarEstadoFactura(factura.id);
      if (expedienteId != null && expedienteId.trim().isNotEmpty) {
        await _timelineRepository.registrarCobroRegistrado(
          expedienteId: expedienteId,
          cobroId: cobroId,
          titulo: 'Cobro registrado',
          descripcion: factura.codigo,
          fecha: fecha,
        );
      }
    });
  }

  Future<void> actualizarCobro({
    required String id,
    required DateTime fecha,
    required double importe,
    required String metodoPago,
    required String referencia,
    required String observaciones,
  }) async {
    await database.transaction(() async {
      final cobroExistente = await database.cobrosDao.obtenerPorId(id);
      if (cobroExistente == null) {
        throw CobroNoEncontradoException(cobroId: id);
      }
      final factura = await database.facturasDao.obtenerPorId(
        cobroExistente.facturaId,
      );
      if (factura == null) {
        throw FacturaNoEncontradaException(facturaId: cobroExistente.facturaId);
      }
      if (!estadoFacturaAdmiteModificarCobros(factura.estado)) {
        throw FacturaNoCobrableException(facturaId: factura.id);
      }
      _validarImporteCobro(importe);

      final cobrosActuales = await database.cobrosDao
          .observarPorFactura(factura.id)
          .first;
      final maximoImporte = calcularMaximoImporteEditableCobro(
        totalFactura: factura.total,
        cobrosActuales: cobrosActuales,
        cobroId: cobroExistente.id,
      );
      if (importeSuperaMaximoEditableCobro(
        importe: importe,
        maximoImporte: maximoImporte,
      )) {
        throw CobroSuperaPendienteException(
          facturaId: factura.id,
          importeSolicitado: importe,
          pendienteActual: maximoImporte,
        );
      }

      await database.cobrosDao.actualizarCobro(
        id: id,
        fecha: fecha,
        importe: importe,
        metodoPago: metodoPago,
        referencia: referencia,
        observaciones: observaciones,
      );
      await _sincronizarEstadoFactura(factura.id);
    });
  }

  Future<void> eliminarCobro(String id) async {
    await database.transaction(() async {
      final cobro = await database.cobrosDao.obtenerPorId(id);
      if (cobro == null) throw CobroNoEncontradoException(cobroId: id);
      final factura = await database.facturasDao.obtenerPorId(cobro.facturaId);
      if (factura == null) {
        throw FacturaNoEncontradaException(facturaId: cobro.facturaId);
      }
      if (!estadoFacturaAdmiteEliminarCobros(factura.estado)) {
        throw FacturaNoCobrableException(facturaId: factura.id);
      }
      final expedienteId = await _obtenerExpedienteIdDesdePresupuestoOrigen(
        factura.presupuestoOrigenId,
      );
      final descripcion = _descripcionCobroEliminado(
        cobro: cobro,
        facturaCodigo: factura.codigo,
      );

      await database.cobrosDao.eliminarCobro(id);
      await _sincronizarEstadoFactura(factura.id);
      if (expedienteId != null && expedienteId.trim().isNotEmpty) {
        await _timelineRepository.registrarCobroEliminado(
          expedienteId: expedienteId,
          cobroId: cobro.id,
          titulo: 'Cobro eliminado',
          descripcion: descripcion,
        );
      }
    });
  }

  void _validarImporteCobro(double importe) {
    if (!importe.isFinite || importe <= 0) {
      throw ImporteCobroNoValidoException(importe: importe);
    }
  }

  Future<void> _sincronizarEstadoFactura(String facturaId) async {
    final factura = await database.facturasDao.obtenerPorId(facturaId);
    if (factura == null) return;
    final cobros = await database.cobrosDao.observarPorFactura(facturaId).first;
    final totalCobrado = cobros.fold<double>(
      0,
      (suma, cobro) => suma + cobro.importe,
    );
    final estado = resolverEstadoDocumentalFactura(
      estadoActual: factura.estado,
      totalFactura: factura.total,
      totalCobrado: totalCobrado,
      fechaVencimiento: factura.fechaVencimiento,
    );
    if (estado != factura.estado) {
      await database.facturasDao.actualizarEstado(
        facturaId,
        estadoFacturaToString(estado),
      );
    }
  }

  String _descripcionCobroEliminado({
    required cobro_domain.Cobro cobro,
    required String facturaCodigo,
  }) {
    final fecha =
        '${cobro.fecha.day.toString().padLeft(2, '0')}/'
        '${cobro.fecha.month.toString().padLeft(2, '0')}/${cobro.fecha.year}';
    final referencia = cobro.referencia.trim().isEmpty
        ? 'sin referencia'
        : cobro.referencia.trim();
    return 'Factura $facturaCodigo · Importe ${cobro.importe.toStringAsFixed(2)} € · '
        'Fecha $fecha · Método ${cobro.metodoPago} · Referencia $referencia';
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

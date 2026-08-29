import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/database/database_provider.dart';
import 'package:obraia_v2/features/cobros/domain/cobro.dart' as cobro_domain;
import 'package:obraia_v2/features/cobros/domain/factura_estado_economico.dart';
import 'package:obraia_v2/features/cobros/domain/metodos_pago.dart';
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

class FechaMovimientoCobroNoValidaException implements Exception {
  const FechaMovimientoCobroNoValidaException();
}

class MetodoPagoCobroNoValidoException implements Exception {
  const MetodoPagoCobroNoValidoException();
}

class CobroNoReversibleException implements Exception {
  const CobroNoReversibleException();
}

class CobroConfirmadoNoEditableException implements Exception {
  const CobroConfirmadoNoEditableException();
}

class CobroRepository {
  final AppDatabase database;
  final TimelineRepository _timelineRepository;

  CobroRepository(this.database, {TimelineRepository? timelineRepository})
    : _timelineRepository =
          timelineRepository ?? TimelineRepository(database.timelineEventsDao);

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
      return calcularTotalCobradoNeto(cobros);
    });
  }

  Stream<FacturaEstadoEconomico> observarEstadoEconomicoFactura({
    required String facturaId,
    required double totalFactura,
  }) {
    return observarTotalCobradoPorFactura(facturaId).map((totalCobrado) {
      final pendiente = normalizarImporteCobro(
        totalFactura - totalCobrado,
      ).clamp(0, double.infinity).toDouble();

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
      _validarFechaCobro(fecha: fecha, fechaFactura: factura.fecha);
      _validarMetodoPago(metodoPago: metodoPago, observaciones: observaciones);
      final importeNormalizado = normalizarImporteCobro(importe);

      final cobrosActuales = await database.cobrosDao.obtenerPorFactura(
        facturaId,
      );
      final totalCobrado = calcularTotalCobradoNeto(cobrosActuales);
      final pendienteActual = normalizarImporteCobro(
        factura.total - totalCobrado,
      ).clamp(0, double.infinity).toDouble();
      if (importeNormalizado > pendienteActual) {
        throw CobroSuperaPendienteException(
          facturaId: facturaId,
          importeSolicitado: importeNormalizado,
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
          importe: Value(importeNormalizado),
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
          descripcion: _descripcionMovimiento(
            facturaCodigo: factura.codigo,
            importe: importeNormalizado,
            fecha: fecha,
            metodoPago: metodoPago,
            referencia: referencia,
            observaciones: observaciones,
          ),
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
    if (await database.cobrosDao.obtenerPorId(id) == null) {
      throw CobroNoEncontradoException(cobroId: id);
    }
    throw const CobroConfirmadoNoEditableException();
  }

  Future<String> revertirCobro({
    required String cobroId,
    required DateTime fecha,
    required double importe,
    required String motivo,
  }) async {
    late String reversionId;
    await database.transaction(() async {
      final original = await database.cobrosDao.obtenerPorId(cobroId);
      if (original == null) {
        throw CobroNoEncontradoException(cobroId: cobroId);
      }
      if (original.esReversion) throw const CobroNoReversibleException();
      final factura = await database.facturasDao.obtenerPorId(
        original.facturaId,
      );
      if (factura == null) {
        throw FacturaNoEncontradaException(facturaId: original.facturaId);
      }
      if (!estadoFacturaAdmiteModificarCobros(factura.estado)) {
        throw FacturaNoCobrableException(facturaId: factura.id);
      }
      _validarImporteCobro(importe);
      _validarFechaReversion(fecha: fecha, fechaOriginal: original.fecha);
      if (motivo.trim().length < 3) throw const CobroNoReversibleException();

      final movimientos = await database.cobrosDao.obtenerPorFactura(
        factura.id,
      );
      final yaRevertido = normalizarImporteCobro(
        movimientos
            .where(
              (movimiento) =>
                  movimiento.esReversion &&
                  movimiento.cobroOrigenId == original.id,
            )
            .fold<double>(0, (total, movimiento) => total + movimiento.importe),
      );
      final disponible = normalizarImporteCobro(original.importe - yaRevertido);
      final importeNormalizado = normalizarImporteCobro(importe);
      if (importeNormalizado > disponible) {
        throw const CobroNoReversibleException();
      }

      reversionId = const Uuid().v4();
      await database.cobrosDao.insertarCobro(
        CobrosCompanion.insert(
          id: reversionId,
          facturaId: factura.id,
          fecha: Value(fecha),
          importe: Value(importeNormalizado),
          metodoPago: Value(original.metodoPago),
          referencia: Value(original.referencia),
          observaciones: Value(original.observaciones),
          tipoMovimiento: Value(
            cobro_domain.TipoMovimientoCobro.reversion.name,
          ),
          cobroOrigenId: Value(original.id),
          motivo: Value(motivo.trim()),
        ),
      );
      await _sincronizarEstadoFactura(factura.id);

      final expedienteId = await _obtenerExpedienteIdDesdePresupuestoOrigen(
        factura.presupuestoOrigenId,
      );
      if (expedienteId != null && expedienteId.trim().isNotEmpty) {
        await _timelineRepository.registrarCobroRevertido(
          expedienteId: expedienteId,
          reversionId: reversionId,
          titulo: 'Cobro revertido',
          descripcion: _descripcionMovimiento(
            facturaCodigo: factura.codigo,
            importe: importeNormalizado,
            fecha: fecha,
            metodoPago: original.metodoPago,
            referencia: original.referencia,
            observaciones: motivo.trim(),
          ),
          fecha: fecha,
        );
      }
    });
    return reversionId;
  }

  Future<void> eliminarCobro(String id) async {
    await database.transaction(() async {
      final cobro = await database.cobrosDao.obtenerPorId(id);
      if (cobro == null) throw CobroNoEncontradoException(cobroId: id);
      final factura = await database.facturasDao.obtenerPorId(cobro.facturaId);
      if (factura == null) {
        throw FacturaNoEncontradaException(facturaId: cobro.facturaId);
      }
      if (factura.estado != EstadoFactura.anulada) {
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
    if (!importe.isFinite || normalizarImporteCobro(importe) <= 0) {
      throw ImporteCobroNoValidoException(importe: importe);
    }
  }

  Future<void> _sincronizarEstadoFactura(String facturaId) async {
    final factura = await database.facturasDao.obtenerPorId(facturaId);
    if (factura == null) return;
    final cobros = await database.cobrosDao.obtenerPorFactura(facturaId);
    final totalCobrado = calcularTotalCobradoNeto(cobros);
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

  void _validarFechaCobro({
    required DateTime fecha,
    required DateTime fechaFactura,
  }) {
    final dia = _soloFecha(fecha);
    final hoy = _soloFecha(DateTime.now());
    final diaFactura = _soloFecha(fechaFactura);
    if (dia.isAfter(hoy) || dia.isBefore(diaFactura)) {
      throw const FechaMovimientoCobroNoValidaException();
    }
  }

  void _validarFechaReversion({
    required DateTime fecha,
    required DateTime fechaOriginal,
  }) {
    final dia = _soloFecha(fecha);
    if (dia.isAfter(_soloFecha(DateTime.now())) ||
        dia.isBefore(_soloFecha(fechaOriginal))) {
      throw const FechaMovimientoCobroNoValidaException();
    }
  }

  void _validarMetodoPago({
    required String metodoPago,
    required String observaciones,
  }) {
    if (!metodoPagoCobroConocido(metodoPago) ||
        !descripcionMetodoPagoOtroValida(
          metodoPago: metodoPago,
          descripcion: observaciones,
        )) {
      throw const MetodoPagoCobroNoValidoException();
    }
  }

  DateTime _soloFecha(DateTime fecha) =>
      DateTime(fecha.year, fecha.month, fecha.day);

  String _descripcionMovimiento({
    required String facturaCodigo,
    required double importe,
    required DateTime fecha,
    required String metodoPago,
    required String referencia,
    required String observaciones,
  }) {
    final fechaTexto =
        '${fecha.day.toString().padLeft(2, '0')}/'
        '${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';
    final partes = <String>[
      'Factura $facturaCodigo',
      'Importe ${importe.toStringAsFixed(2)} €',
      'Fecha $fechaTexto',
      'Método $metodoPago',
      if (referencia.trim().isNotEmpty) 'Referencia ${referencia.trim()}',
      if (observaciones.trim().isNotEmpty)
        'Observación ${observaciones.trim()}',
    ];
    return partes.join(' · ');
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

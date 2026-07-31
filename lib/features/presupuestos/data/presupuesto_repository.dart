import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/database/database_provider.dart';
import 'package:obraia_v2/features/presupuestos/domain/presupuesto.dart'
    as presupuesto_domain;
import 'package:obraia_v2/features/timeline/data/timeline_repository.dart';
import 'package:uuid/uuid.dart';

final presupuestoRepositoryProvider = Provider<PresupuestoRepository>((ref) {
  final database = ref.read(databaseProvider);
  return PresupuestoRepository(database);
});

class PresupuestoRepository {
  final AppDatabase database;
  final TimelineRepository _timelineRepository;

  PresupuestoRepository(this.database)
      : _timelineRepository = TimelineRepository(database.timelineEventsDao);

  Stream<List<presupuesto_domain.Presupuesto>> observarPorExpediente(
    String expedienteId,
  ) {
    return database.presupuestosDao.observarPorExpediente(expedienteId);
  }

  Stream<List<presupuesto_domain.Presupuesto>> observarPresupuestos() {
    return database.presupuestosDao.observarPresupuestos();
  }

  Future<String> _generarCodigoPresupuesto(String expedienteId) async {
    final expediente = await database.expedientesDao.obtenerExpediente(
      expedienteId,
    );
    if (expediente == null) {
      throw Exception('No se encontró el expediente para generar el código');
    }

    final codigoExpediente = expediente.codigo.trim();
    final codigosExistentes = await database.presupuestosDao
        .obtenerCodigosPorExpediente(expedienteId);

    final prefijo = '$codigoExpediente-P';
    var maxCorrelativo = 0;

    for (final codigo in codigosExistentes) {
      if (!codigo.startsWith(prefijo)) {
        continue;
      }

      final sufijo = codigo.substring(prefijo.length);
      final valor = int.tryParse(sufijo);
      if (valor != null && valor > maxCorrelativo) {
        maxCorrelativo = valor;
      }
    }

    final siguiente = maxCorrelativo + 1;
    final secuencia = siguiente.toString().padLeft(2, '0');
    return '$codigoExpediente-P$secuencia';
  }

  Future<void> crearPresupuesto({
    required String expedienteId,
    required DateTime fecha,
    String descripcion = '',
    double importeTotal = 0,
    String estado = 'Borrador',
  }) async {
    final codigo = await _generarCodigoPresupuesto(expedienteId);
    final presupuestoId = const Uuid().v4();

    await database.presupuestosDao.insertarPresupuesto(
      PresupuestosCompanion.insert(
        id: presupuestoId,
        expedienteId: expedienteId,
        titulo: Value(codigo),
        codigo: Value(codigo),
        fecha: Value(fecha),
        descripcion: Value(descripcion),
        importeTotal: Value(importeTotal),
        estado: Value(estado),
      ),
    );

    await _timelineRepository.registrarPresupuestoCreado(
      expedienteId: expedienteId,
      presupuestoId: presupuestoId,
      titulo: codigo,
    );
  }

  Future<void> actualizarImporteTotal(
    String presupuestoId,
    double importeTotal,
  ) {
    return database.presupuestosDao.actualizarImporteTotal(
      presupuestoId,
      importeTotal,
    );
  }

  Future<void> actualizarIvaPorcentaje(
    String presupuestoId,
    double ivaPorcentaje,
  ) {
    return database.presupuestosDao.actualizarIvaPorcentaje(
      presupuestoId,
      ivaPorcentaje,
    );
  }

  Future<bool> eliminarSiNoFacturado(String presupuestoId) async {
    final tieneFacturaAsociada = await database.presupuestosDao
        .tieneFacturaAsociada(presupuestoId);

    if (tieneFacturaAsociada) {
      return false;
    }

    await database.presupuestosDao.eliminarLogicamente(presupuestoId);
    return true;
  }
}

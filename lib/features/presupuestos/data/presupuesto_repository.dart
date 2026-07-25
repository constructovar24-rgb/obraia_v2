import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/database/database_provider.dart';
import 'package:obraia_v2/features/presupuestos/domain/presupuesto.dart'
    as presupuesto_domain;
import 'package:uuid/uuid.dart';

final presupuestoRepositoryProvider = Provider<PresupuestoRepository>((ref) {
  final database = ref.read(databaseProvider);
  return PresupuestoRepository(database);
});

class PresupuestoRepository {
  final AppDatabase database;

  PresupuestoRepository(this.database);

  Stream<List<presupuesto_domain.Presupuesto>> observarPorExpediente(
    String expedienteId,
  ) {
    return database.presupuestosDao.observarPorExpediente(expedienteId);
  }

  Future<void> crearPresupuesto({
    required String expedienteId,
    required String codigo,
    required DateTime fecha,
    String descripcion = '',
    double importeTotal = 0,
    String estado = 'Borrador',
  }) {
    return database.presupuestosDao.insertarPresupuesto(
      PresupuestosCompanion.insert(
        id: const Uuid().v4(),
        expedienteId: expedienteId,
        titulo: Value(codigo),
        codigo: Value(codigo),
        fecha: Value(fecha),
        descripcion: Value(descripcion),
        importeTotal: Value(importeTotal),
        estado: Value(estado),
      ),
    );
  }
}

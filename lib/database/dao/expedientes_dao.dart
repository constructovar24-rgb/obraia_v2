import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/expedientes.dart';

part 'expedientes_dao.g.dart';

@DriftAccessor(tables: [Expedientes])
class ExpedientesDao extends DatabaseAccessor<AppDatabase>
    with _$ExpedientesDaoMixin {
  ExpedientesDao(AppDatabase db) : super(db);

  Stream<List<Expediente>> observarExpedientes() {
    final table = attachedDatabase.expedientes;

    return (select(table)
          ..where((t) => t.eliminado.equals(false))
          ..orderBy([
            (t) => OrderingTerm.desc(t.fechaCreacion),
          ]))
        .watch();
  }

  Future<Expediente?> obtenerExpediente(String id) {
    final table = attachedDatabase.expedientes;

    return (select(table)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<void> insertarExpediente(
      ExpedientesCompanion expediente) async {
    final table = attachedDatabase.expedientes;

    await into(table).insert(expediente);
  }

  Future<void> actualizarExpediente(
    String id,
    ExpedientesCompanion companion,
  ) async {
    final table = attachedDatabase.expedientes;

    await (update(table)
          ..where((t) => t.id.equals(id)))
        .write(companion);
  }

  Future<void> eliminarLogicamente(
    String id,
  ) async {
    final table = attachedDatabase.expedientes;

    await (update(table)
          ..where((t) => t.id.equals(id)))
        .write(
      const ExpedientesCompanion(
        eliminado: Value(true),
      ),
    );
  }
}
import 'package:drift/drift.dart';

import '../../features/presupuestos/domain/presupuesto.dart' as presupuesto_domain;
import '../app_database.dart';
import '../tables/presupuestos.dart';

part 'presupuestos_dao.g.dart';

@DriftAccessor(tables: [Presupuestos])
class PresupuestosDao extends DatabaseAccessor<AppDatabase>
    with _$PresupuestosDaoMixin {
  PresupuestosDao(AppDatabase db) : super(db);

  Stream<List<presupuesto_domain.Presupuesto>> observarPorExpediente(
    String expedienteId,
  ) {
    final table = attachedDatabase.presupuestos;

    return (select(table)
          ..where(
            (t) => t.expedienteId.equals(expedienteId) & t.eliminado.equals(false),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.fecha)]))
        .watch()
        .map(
          (rows) => rows
              .map(
                (row) => presupuesto_domain.Presupuesto(
                  id: row.id,
                  expedienteId: row.expedienteId,
                  codigo: row.codigo,
                  fecha: row.fecha,
                  descripcion: row.descripcion,
                  estado: row.estado,
                  eliminado: row.eliminado,
                  fechaCreacion: row.fechaCreacion,
                  fechaModificacion: row.fechaModificacion,
                ),
              )
              .toList(),
        );
  }

  Future<void> insertarPresupuesto(PresupuestosCompanion presupuesto) async {
    await into(presupuestos).insert(presupuesto);
  }

  Future<void> eliminarLogicamente(String id) async {
    await (update(presupuestos)
          ..where((t) => t.id.equals(id)))
        .write(
      const PresupuestosCompanion(
        eliminado: Value(true),
      ),
    );
  }
}

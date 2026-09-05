import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/actuaciones_obra.dart';
import '../tables/diario_obra.dart';

part 'diario_obra_dao.g.dart';

class DiarioObraRow {
  const DiarioObraRow(this.entrada, this.actuacionDescripcion);
  final DiarioObraData entrada;
  final String? actuacionDescripcion;
}

@DriftAccessor(tables: [DiarioObra, ActuacionesObra])
class DiarioObraDao extends DatabaseAccessor<AppDatabase>
    with _$DiarioObraDaoMixin {
  DiarioObraDao(super.db);

  Stream<List<DiarioObraRow>> observarPorObra(String expedienteId) {
    final query =
        select(diarioObra).join([
            leftOuterJoin(
              actuacionesObra,
              actuacionesObra.tenantId.equalsExp(diarioObra.tenantId) &
                  actuacionesObra.id.equalsExp(diarioObra.actuacionId),
            ),
          ])
          ..where(
            diarioObra.tenantId.equals(attachedDatabase.activeTenantId) &
                diarioObra.expedienteId.equals(expedienteId),
          )
          ..orderBy([
            OrderingTerm.desc(diarioObra.fechaTrabajo),
            OrderingTerm.desc(diarioObra.fechaCreacion),
          ]);
    return query.watch().map(
      (rows) => rows
          .map(
            (row) => DiarioObraRow(
              row.readTable(diarioObra),
              row.readTableOrNull(actuacionesObra)?.descripcion,
            ),
          )
          .toList(growable: false),
    );
  }

  Future<DiarioObraData?> obtener(String id) =>
      (select(diarioObra)..where(
            (t) =>
                t.tenantId.equals(attachedDatabase.activeTenantId) &
                t.id.equals(id),
          ))
          .getSingleOrNull();

  Future<void> insertar(DiarioObraCompanion value) => into(
    diarioObra,
  ).insert(value.copyWith(tenantId: Value(attachedDatabase.activeTenantId)));

  Future<int> actualizar(String id, DiarioObraCompanion value) =>
      (update(diarioObra)..where(
            (t) =>
                t.tenantId.equals(attachedDatabase.activeTenantId) &
                t.id.equals(id),
          ))
          .write(value);
}

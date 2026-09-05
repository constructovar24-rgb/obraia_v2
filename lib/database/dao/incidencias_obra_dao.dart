import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/incidencia_diario.dart';
import '../tables/incidencia_documentos.dart';
import '../tables/incidencias_obra.dart';

part 'incidencias_obra_dao.g.dart';

@DriftAccessor(
  tables: [IncidenciasObra, IncidenciaDocumentos, IncidenciaDiario],
)
class IncidenciasObraDao extends DatabaseAccessor<AppDatabase>
    with _$IncidenciasObraDaoMixin {
  IncidenciasObraDao(super.db);

  Stream<List<IncidenciasObraData>> observarPorObra(String expedienteId) =>
      (select(incidenciasObra)
            ..where(
              (row) =>
                  row.tenantId.equals(attachedDatabase.activeTenantId) &
                  row.expedienteId.equals(expedienteId),
            )
            ..orderBy([
              (row) => OrderingTerm(
                expression: row.estado.isIn(['resuelta', 'cancelada']),
              ),
              (row) => OrderingTerm.desc(row.fechaDeteccion),
              (row) => OrderingTerm.desc(row.fechaCreacion),
            ]))
          .watch();

  Future<IncidenciasObraData?> obtener(String id) =>
      (select(incidenciasObra)..where(
            (row) =>
                row.tenantId.equals(attachedDatabase.activeTenantId) &
                row.id.equals(id),
          ))
          .getSingleOrNull();

  Future<void> insertar(IncidenciasObraCompanion value) => into(
    incidenciasObra,
  ).insert(value.copyWith(tenantId: Value(attachedDatabase.activeTenantId)));

  Future<int> actualizar(String id, IncidenciasObraCompanion value) =>
      (update(incidenciasObra)..where(
            (row) =>
                row.tenantId.equals(attachedDatabase.activeTenantId) &
                row.id.equals(id),
          ))
          .write(value);

  Future<List<String>> obtenerDocumentoIds(String incidenciaId) async =>
      (select(incidenciaDocumentos)..where(
            (row) =>
                row.tenantId.equals(attachedDatabase.activeTenantId) &
                row.incidenciaId.equals(incidenciaId),
          ))
          .map((row) => row.documentoId)
          .get();

  Future<List<String>> obtenerEntradaDiarioIds(String incidenciaId) async =>
      (select(incidenciaDiario)..where(
            (row) =>
                row.tenantId.equals(attachedDatabase.activeTenantId) &
                row.incidenciaId.equals(incidenciaId),
          ))
          .map((row) => row.entradaDiarioId)
          .get();

  Future<void> reemplazarDocumentos(
    String incidenciaId,
    Iterable<String> documentoIds,
  ) async {
    await (delete(incidenciaDocumentos)..where(
          (row) =>
              row.tenantId.equals(attachedDatabase.activeTenantId) &
              row.incidenciaId.equals(incidenciaId),
        ))
        .go();
    for (final documentoId in documentoIds.toSet()) {
      await into(incidenciaDocumentos).insert(
        IncidenciaDocumentosCompanion.insert(
          tenantId: attachedDatabase.activeTenantId,
          incidenciaId: incidenciaId,
          documentoId: documentoId,
        ),
      );
    }
  }

  Future<void> reemplazarEntradasDiario(
    String incidenciaId,
    Iterable<String> entradaIds,
  ) async {
    await (delete(incidenciaDiario)..where(
          (row) =>
              row.tenantId.equals(attachedDatabase.activeTenantId) &
              row.incidenciaId.equals(incidenciaId),
        ))
        .go();
    for (final entradaId in entradaIds.toSet()) {
      await into(incidenciaDiario).insert(
        IncidenciaDiarioCompanion.insert(
          tenantId: attachedDatabase.activeTenantId,
          incidenciaId: incidenciaId,
          entradaDiarioId: entradaId,
        ),
      );
    }
  }
}

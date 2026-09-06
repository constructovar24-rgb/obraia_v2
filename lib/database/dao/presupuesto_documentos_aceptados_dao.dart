import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/presupuesto_documentos_aceptados.dart';

part 'presupuesto_documentos_aceptados_dao.g.dart';

@DriftAccessor(tables: [PresupuestoDocumentosAceptados])
class PresupuestoDocumentosAceptadosDao extends DatabaseAccessor<AppDatabase>
    with _$PresupuestoDocumentosAceptadosDaoMixin {
  PresupuestoDocumentosAceptadosDao(super.db);

  Future<PresupuestoDocumentosAceptado?> obtener(String presupuestoId) =>
      (select(presupuestoDocumentosAceptados)..where(
            (t) =>
                t.tenantId.equals(attachedDatabase.activeTenantId) &
                t.presupuestoId.equals(presupuestoId),
          ))
          .getSingleOrNull();

  Future<void> insertar(PresupuestoDocumentosAceptadosCompanion value) => into(
    presupuestoDocumentosAceptados,
  ).insert(value.copyWith(tenantId: Value(attachedDatabase.activeTenantId)));
}

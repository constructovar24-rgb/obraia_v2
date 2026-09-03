import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/compras.dart';

part 'compras_dao.g.dart';

@DriftAccessor(tables: [Compras])
class ComprasDao extends DatabaseAccessor<AppDatabase> with _$ComprasDaoMixin {
  ComprasDao(super.db);

  Future<void> insertarCompra(ComprasCompanion compra) async {
    await into(
      compras,
    ).insert(compra.copyWith(tenantId: Value(attachedDatabase.activeTenantId)));
  }

  Future<void> actualizarCompra(String id, ComprasCompanion compra) async {
    await (update(compras)..where(
          (t) =>
              t.tenantId.equals(attachedDatabase.activeTenantId) &
              t.id.equals(id),
        ))
        .write(compra.copyWith(fechaModificacion: Value(DateTime.now())));
  }

  Stream<List<Compra>> observarPorExpediente(String expedienteId) {
    return (select(compras)
          ..where(
            (t) =>
                t.tenantId.equals(attachedDatabase.activeTenantId) &
                t.expedienteId.equals(expedienteId) &
                t.eliminado.equals(false),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.fecha)]))
        .watch();
  }

  Future<List<Compra>> obtenerPorExpediente(String expedienteId) {
    return (select(compras)
          ..where(
            (t) =>
                t.tenantId.equals(attachedDatabase.activeTenantId) &
                t.expedienteId.equals(expedienteId) &
                t.eliminado.equals(false),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.fecha)]))
        .get();
  }

  Stream<List<Compra>> observarTodas() {
    return (select(compras)
          ..where(
            (t) =>
                t.tenantId.equals(attachedDatabase.activeTenantId) &
                t.eliminado.equals(false),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.fecha)]))
        .watch();
  }

  Future<void> eliminarLogicamente(String id) async {
    await (update(compras)..where(
          (t) =>
              t.tenantId.equals(attachedDatabase.activeTenantId) &
              t.id.equals(id),
        ))
        .write(const ComprasCompanion(eliminado: Value(true)));
  }

  Future<bool> tieneCompraPorExpediente(String expedienteId) async {
    final row =
        await (select(compras)
              ..where(
                (t) =>
                    t.tenantId.equals(attachedDatabase.activeTenantId) &
                    t.expedienteId.equals(expedienteId) &
                    t.eliminado.equals(false),
              )
              ..limit(1))
            .getSingleOrNull();

    return row != null;
  }
}

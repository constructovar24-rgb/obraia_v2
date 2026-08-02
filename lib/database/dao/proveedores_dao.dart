import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/proveedores.dart';

part 'proveedores_dao.g.dart';

@DriftAccessor(tables: [Proveedores])
class ProveedoresDao extends DatabaseAccessor<AppDatabase>
    with _$ProveedoresDaoMixin {
  ProveedoresDao(super.db);

  Future<void> insertarProveedor(ProveedoresCompanion proveedor) async {
    await into(proveedores).insert(proveedor);
  }

  Stream<List<Proveedore>> observarProveedores() {
    return (select(proveedores)
          ..where((t) => t.eliminado.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.fechaCreacion)]))
        .watch();
  }

  Future<List<Proveedore>> obtenerProveedores() {
    return (select(proveedores)
          ..where((t) => t.eliminado.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.fechaCreacion)]))
        .get();
  }

  Future<Proveedore?> obtenerProveedor(String id) {
    return (select(proveedores)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<void> actualizarProveedor(
    String id,
    ProveedoresCompanion proveedor,
  ) async {
    await (update(proveedores)..where((t) => t.id.equals(id))).write(
      proveedor.copyWith(
        fechaModificacion: Value(DateTime.now()),
      ),
    );
  }

  Future<void> eliminarLogicamente(String id) async {
    await (update(proveedores)..where((t) => t.id.equals(id))).write(
      const ProveedoresCompanion(
        eliminado: Value(true),
      ),
    );
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proveedores_dao.dart';

// ignore_for_file: type=lint
mixin _$ProveedoresDaoMixin on DatabaseAccessor<AppDatabase> {
  $TenantsTable get tenants => attachedDatabase.tenants;
  $ProveedoresTable get proveedores => attachedDatabase.proveedores;
  ProveedoresDaoManager get managers => ProveedoresDaoManager(this);
}

class ProveedoresDaoManager {
  final _$ProveedoresDaoMixin _db;
  ProveedoresDaoManager(this._db);
  $$TenantsTableTableManager get tenants =>
      $$TenantsTableTableManager(_db.attachedDatabase, _db.tenants);
  $$ProveedoresTableTableManager get proveedores =>
      $$ProveedoresTableTableManager(_db.attachedDatabase, _db.proveedores);
}

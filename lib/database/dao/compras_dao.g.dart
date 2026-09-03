// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compras_dao.dart';

// ignore_for_file: type=lint
mixin _$ComprasDaoMixin on DatabaseAccessor<AppDatabase> {
  $TenantsTable get tenants => attachedDatabase.tenants;
  $ClientesTable get clientes => attachedDatabase.clientes;
  $ExpedientesTable get expedientes => attachedDatabase.expedientes;
  $ProveedoresTable get proveedores => attachedDatabase.proveedores;
  $ComprasTable get compras => attachedDatabase.compras;
  ComprasDaoManager get managers => ComprasDaoManager(this);
}

class ComprasDaoManager {
  final _$ComprasDaoMixin _db;
  ComprasDaoManager(this._db);
  $$TenantsTableTableManager get tenants =>
      $$TenantsTableTableManager(_db.attachedDatabase, _db.tenants);
  $$ClientesTableTableManager get clientes =>
      $$ClientesTableTableManager(_db.attachedDatabase, _db.clientes);
  $$ExpedientesTableTableManager get expedientes =>
      $$ExpedientesTableTableManager(_db.attachedDatabase, _db.expedientes);
  $$ProveedoresTableTableManager get proveedores =>
      $$ProveedoresTableTableManager(_db.attachedDatabase, _db.proveedores);
  $$ComprasTableTableManager get compras =>
      $$ComprasTableTableManager(_db.attachedDatabase, _db.compras);
}

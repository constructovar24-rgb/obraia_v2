// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clientes_dao.dart';

// ignore_for_file: type=lint
mixin _$ClientesDaoMixin on DatabaseAccessor<AppDatabase> {
  $TenantsTable get tenants => attachedDatabase.tenants;
  $ClientesTable get clientes => attachedDatabase.clientes;
  ClientesDaoManager get managers => ClientesDaoManager(this);
}

class ClientesDaoManager {
  final _$ClientesDaoMixin _db;
  ClientesDaoManager(this._db);
  $$TenantsTableTableManager get tenants =>
      $$TenantsTableTableManager(_db.attachedDatabase, _db.tenants);
  $$ClientesTableTableManager get clientes =>
      $$ClientesTableTableManager(_db.attachedDatabase, _db.clientes);
}

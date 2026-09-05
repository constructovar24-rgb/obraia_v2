// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diario_obra_dao.dart';

// ignore_for_file: type=lint
mixin _$DiarioObraDaoMixin on DatabaseAccessor<AppDatabase> {
  $TenantsTable get tenants => attachedDatabase.tenants;
  $ClientesTable get clientes => attachedDatabase.clientes;
  $ExpedientesTable get expedientes => attachedDatabase.expedientes;
  $ActuacionesObraTable get actuacionesObra => attachedDatabase.actuacionesObra;
  $DiarioObraTable get diarioObra => attachedDatabase.diarioObra;
  DiarioObraDaoManager get managers => DiarioObraDaoManager(this);
}

class DiarioObraDaoManager {
  final _$DiarioObraDaoMixin _db;
  DiarioObraDaoManager(this._db);
  $$TenantsTableTableManager get tenants =>
      $$TenantsTableTableManager(_db.attachedDatabase, _db.tenants);
  $$ClientesTableTableManager get clientes =>
      $$ClientesTableTableManager(_db.attachedDatabase, _db.clientes);
  $$ExpedientesTableTableManager get expedientes =>
      $$ExpedientesTableTableManager(_db.attachedDatabase, _db.expedientes);
  $$ActuacionesObraTableTableManager get actuacionesObra =>
      $$ActuacionesObraTableTableManager(
        _db.attachedDatabase,
        _db.actuacionesObra,
      );
  $$DiarioObraTableTableManager get diarioObra =>
      $$DiarioObraTableTableManager(_db.attachedDatabase, _db.diarioObra);
}

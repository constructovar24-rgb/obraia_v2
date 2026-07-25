// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expedientes_dao.dart';

// ignore_for_file: type=lint
mixin _$ExpedientesDaoMixin on DatabaseAccessor<AppDatabase> {
  $ClientesTable get clientes => attachedDatabase.clientes;
  $ExpedientesTable get expedientes => attachedDatabase.expedientes;
  ExpedientesDaoManager get managers => ExpedientesDaoManager(this);
}

class ExpedientesDaoManager {
  final _$ExpedientesDaoMixin _db;
  ExpedientesDaoManager(this._db);
  $$ClientesTableTableManager get clientes =>
      $$ClientesTableTableManager(_db.attachedDatabase, _db.clientes);
  $$ExpedientesTableTableManager get expedientes =>
      $$ExpedientesTableTableManager(_db.attachedDatabase, _db.expedientes);
}

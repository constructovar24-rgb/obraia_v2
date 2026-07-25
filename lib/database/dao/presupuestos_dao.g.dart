// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'presupuestos_dao.dart';

// ignore_for_file: type=lint
mixin _$PresupuestosDaoMixin on DatabaseAccessor<AppDatabase> {
  $ClientesTable get clientes => attachedDatabase.clientes;
  $ExpedientesTable get expedientes => attachedDatabase.expedientes;
  $PresupuestosTable get presupuestos => attachedDatabase.presupuestos;
  PresupuestosDaoManager get managers => PresupuestosDaoManager(this);
}

class PresupuestosDaoManager {
  final _$PresupuestosDaoMixin _db;
  PresupuestosDaoManager(this._db);
  $$ClientesTableTableManager get clientes =>
      $$ClientesTableTableManager(_db.attachedDatabase, _db.clientes);
  $$ExpedientesTableTableManager get expedientes =>
      $$ExpedientesTableTableManager(_db.attachedDatabase, _db.expedientes);
  $$PresupuestosTableTableManager get presupuestos =>
      $$PresupuestosTableTableManager(_db.attachedDatabase, _db.presupuestos);
}

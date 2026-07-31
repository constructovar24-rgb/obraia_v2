// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cobros_dao.dart';

// ignore_for_file: type=lint
mixin _$CobrosDaoMixin on DatabaseAccessor<AppDatabase> {
  $ClientesTable get clientes => attachedDatabase.clientes;
  $ExpedientesTable get expedientes => attachedDatabase.expedientes;
  $PresupuestosTable get presupuestos => attachedDatabase.presupuestos;
  $FacturasTable get facturas => attachedDatabase.facturas;
  $CobrosTable get cobros => attachedDatabase.cobros;
  CobrosDaoManager get managers => CobrosDaoManager(this);
}

class CobrosDaoManager {
  final _$CobrosDaoMixin _db;
  CobrosDaoManager(this._db);
  $$ClientesTableTableManager get clientes =>
      $$ClientesTableTableManager(_db.attachedDatabase, _db.clientes);
  $$ExpedientesTableTableManager get expedientes =>
      $$ExpedientesTableTableManager(_db.attachedDatabase, _db.expedientes);
  $$PresupuestosTableTableManager get presupuestos =>
      $$PresupuestosTableTableManager(_db.attachedDatabase, _db.presupuestos);
  $$FacturasTableTableManager get facturas =>
      $$FacturasTableTableManager(_db.attachedDatabase, _db.facturas);
  $$CobrosTableTableManager get cobros =>
      $$CobrosTableTableManager(_db.attachedDatabase, _db.cobros);
}

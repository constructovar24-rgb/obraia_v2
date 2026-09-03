// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lineas_presupuesto_dao.dart';

// ignore_for_file: type=lint
mixin _$LineasPresupuestoDaoMixin on DatabaseAccessor<AppDatabase> {
  $TenantsTable get tenants => attachedDatabase.tenants;
  $ClientesTable get clientes => attachedDatabase.clientes;
  $ExpedientesTable get expedientes => attachedDatabase.expedientes;
  $PresupuestosTable get presupuestos => attachedDatabase.presupuestos;
  $LineasPresupuestoTable get lineasPresupuesto =>
      attachedDatabase.lineasPresupuesto;
  LineasPresupuestoDaoManager get managers => LineasPresupuestoDaoManager(this);
}

class LineasPresupuestoDaoManager {
  final _$LineasPresupuestoDaoMixin _db;
  LineasPresupuestoDaoManager(this._db);
  $$TenantsTableTableManager get tenants =>
      $$TenantsTableTableManager(_db.attachedDatabase, _db.tenants);
  $$ClientesTableTableManager get clientes =>
      $$ClientesTableTableManager(_db.attachedDatabase, _db.clientes);
  $$ExpedientesTableTableManager get expedientes =>
      $$ExpedientesTableTableManager(_db.attachedDatabase, _db.expedientes);
  $$PresupuestosTableTableManager get presupuestos =>
      $$PresupuestosTableTableManager(_db.attachedDatabase, _db.presupuestos);
  $$LineasPresupuestoTableTableManager get lineasPresupuesto =>
      $$LineasPresupuestoTableTableManager(
        _db.attachedDatabase,
        _db.lineasPresupuesto,
      );
}

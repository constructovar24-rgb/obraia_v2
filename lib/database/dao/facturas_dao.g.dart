// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'facturas_dao.dart';

// ignore_for_file: type=lint
mixin _$FacturasDaoMixin on DatabaseAccessor<AppDatabase> {
  $TenantsTable get tenants => attachedDatabase.tenants;
  $ClientesTable get clientes => attachedDatabase.clientes;
  $ExpedientesTable get expedientes => attachedDatabase.expedientes;
  $PresupuestosTable get presupuestos => attachedDatabase.presupuestos;
  $FacturasTable get facturas => attachedDatabase.facturas;
  FacturasDaoManager get managers => FacturasDaoManager(this);
}

class FacturasDaoManager {
  final _$FacturasDaoMixin _db;
  FacturasDaoManager(this._db);
  $$TenantsTableTableManager get tenants =>
      $$TenantsTableTableManager(_db.attachedDatabase, _db.tenants);
  $$ClientesTableTableManager get clientes =>
      $$ClientesTableTableManager(_db.attachedDatabase, _db.clientes);
  $$ExpedientesTableTableManager get expedientes =>
      $$ExpedientesTableTableManager(_db.attachedDatabase, _db.expedientes);
  $$PresupuestosTableTableManager get presupuestos =>
      $$PresupuestosTableTableManager(_db.attachedDatabase, _db.presupuestos);
  $$FacturasTableTableManager get facturas =>
      $$FacturasTableTableManager(_db.attachedDatabase, _db.facturas);
}

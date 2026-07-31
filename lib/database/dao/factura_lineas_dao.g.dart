// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'factura_lineas_dao.dart';

// ignore_for_file: type=lint
mixin _$FacturaLineasDaoMixin on DatabaseAccessor<AppDatabase> {
  $ClientesTable get clientes => attachedDatabase.clientes;
  $ExpedientesTable get expedientes => attachedDatabase.expedientes;
  $PresupuestosTable get presupuestos => attachedDatabase.presupuestos;
  $FacturasTable get facturas => attachedDatabase.facturas;
  $FacturaLineasTable get facturaLineas => attachedDatabase.facturaLineas;
  FacturaLineasDaoManager get managers => FacturaLineasDaoManager(this);
}

class FacturaLineasDaoManager {
  final _$FacturaLineasDaoMixin _db;
  FacturaLineasDaoManager(this._db);
  $$ClientesTableTableManager get clientes =>
      $$ClientesTableTableManager(_db.attachedDatabase, _db.clientes);
  $$ExpedientesTableTableManager get expedientes =>
      $$ExpedientesTableTableManager(_db.attachedDatabase, _db.expedientes);
  $$PresupuestosTableTableManager get presupuestos =>
      $$PresupuestosTableTableManager(_db.attachedDatabase, _db.presupuestos);
  $$FacturasTableTableManager get facturas =>
      $$FacturasTableTableManager(_db.attachedDatabase, _db.facturas);
  $$FacturaLineasTableTableManager get facturaLineas =>
      $$FacturaLineasTableTableManager(_db.attachedDatabase, _db.facturaLineas);
}

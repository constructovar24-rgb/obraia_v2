// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'factura_asignaciones_presupuesto_dao.dart';

// ignore_for_file: type=lint
mixin _$FacturaAsignacionesPresupuestoDaoMixin
    on DatabaseAccessor<AppDatabase> {
  $TenantsTable get tenants => attachedDatabase.tenants;
  $ClientesTable get clientes => attachedDatabase.clientes;
  $ExpedientesTable get expedientes => attachedDatabase.expedientes;
  $PresupuestosTable get presupuestos => attachedDatabase.presupuestos;
  $FacturasTable get facturas => attachedDatabase.facturas;
  $FacturaLineasTable get facturaLineas => attachedDatabase.facturaLineas;
  $LineasPresupuestoTable get lineasPresupuesto =>
      attachedDatabase.lineasPresupuesto;
  $CertificacionesTable get certificaciones => attachedDatabase.certificaciones;
  $FacturaAsignacionesPresupuestoTable get facturaAsignacionesPresupuesto =>
      attachedDatabase.facturaAsignacionesPresupuesto;
  FacturaAsignacionesPresupuestoDaoManager get managers =>
      FacturaAsignacionesPresupuestoDaoManager(this);
}

class FacturaAsignacionesPresupuestoDaoManager {
  final _$FacturaAsignacionesPresupuestoDaoMixin _db;
  FacturaAsignacionesPresupuestoDaoManager(this._db);
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
  $$FacturaLineasTableTableManager get facturaLineas =>
      $$FacturaLineasTableTableManager(_db.attachedDatabase, _db.facturaLineas);
  $$LineasPresupuestoTableTableManager get lineasPresupuesto =>
      $$LineasPresupuestoTableTableManager(
        _db.attachedDatabase,
        _db.lineasPresupuesto,
      );
  $$CertificacionesTableTableManager get certificaciones =>
      $$CertificacionesTableTableManager(
        _db.attachedDatabase,
        _db.certificaciones,
      );
  $$FacturaAsignacionesPresupuestoTableTableManager
  get facturaAsignacionesPresupuesto =>
      $$FacturaAsignacionesPresupuestoTableTableManager(
        _db.attachedDatabase,
        _db.facturaAsignacionesPresupuesto,
      );
}

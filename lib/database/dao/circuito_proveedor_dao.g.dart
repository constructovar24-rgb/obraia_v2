// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circuito_proveedor_dao.dart';

// ignore_for_file: type=lint
mixin _$CircuitoProveedorDaoMixin on DatabaseAccessor<AppDatabase> {
  $TenantsTable get tenants => attachedDatabase.tenants;
  $ProveedoresTable get proveedores => attachedDatabase.proveedores;
  $ClientesTable get clientes => attachedDatabase.clientes;
  $ExpedientesTable get expedientes => attachedDatabase.expedientes;
  $DocumentosTable get documentos => attachedDatabase.documentos;
  $AlbaranesProveedorTable get albaranesProveedor =>
      attachedDatabase.albaranesProveedor;
  $LineasAlbaranProveedorTable get lineasAlbaranProveedor =>
      attachedDatabase.lineasAlbaranProveedor;
  $AsignacionesAlbaranObraTable get asignacionesAlbaranObra =>
      attachedDatabase.asignacionesAlbaranObra;
  $FacturasRecibidasTable get facturasRecibidas =>
      attachedDatabase.facturasRecibidas;
  $FacturaRecibidaAlbaranesTable get facturaRecibidaAlbaranes =>
      attachedDatabase.facturaRecibidaAlbaranes;
  $AsignacionesFacturaRecibidaTable get asignacionesFacturaRecibida =>
      attachedDatabase.asignacionesFacturaRecibida;
  $ComprasTable get compras => attachedDatabase.compras;
  $FacturaRecibidaComprasTable get facturaRecibidaCompras =>
      attachedDatabase.facturaRecibidaCompras;
  $PagosProveedorTable get pagosProveedor => attachedDatabase.pagosProveedor;
  CircuitoProveedorDaoManager get managers => CircuitoProveedorDaoManager(this);
}

class CircuitoProveedorDaoManager {
  final _$CircuitoProveedorDaoMixin _db;
  CircuitoProveedorDaoManager(this._db);
  $$TenantsTableTableManager get tenants =>
      $$TenantsTableTableManager(_db.attachedDatabase, _db.tenants);
  $$ProveedoresTableTableManager get proveedores =>
      $$ProveedoresTableTableManager(_db.attachedDatabase, _db.proveedores);
  $$ClientesTableTableManager get clientes =>
      $$ClientesTableTableManager(_db.attachedDatabase, _db.clientes);
  $$ExpedientesTableTableManager get expedientes =>
      $$ExpedientesTableTableManager(_db.attachedDatabase, _db.expedientes);
  $$DocumentosTableTableManager get documentos =>
      $$DocumentosTableTableManager(_db.attachedDatabase, _db.documentos);
  $$AlbaranesProveedorTableTableManager get albaranesProveedor =>
      $$AlbaranesProveedorTableTableManager(
        _db.attachedDatabase,
        _db.albaranesProveedor,
      );
  $$LineasAlbaranProveedorTableTableManager get lineasAlbaranProveedor =>
      $$LineasAlbaranProveedorTableTableManager(
        _db.attachedDatabase,
        _db.lineasAlbaranProveedor,
      );
  $$AsignacionesAlbaranObraTableTableManager get asignacionesAlbaranObra =>
      $$AsignacionesAlbaranObraTableTableManager(
        _db.attachedDatabase,
        _db.asignacionesAlbaranObra,
      );
  $$FacturasRecibidasTableTableManager get facturasRecibidas =>
      $$FacturasRecibidasTableTableManager(
        _db.attachedDatabase,
        _db.facturasRecibidas,
      );
  $$FacturaRecibidaAlbaranesTableTableManager get facturaRecibidaAlbaranes =>
      $$FacturaRecibidaAlbaranesTableTableManager(
        _db.attachedDatabase,
        _db.facturaRecibidaAlbaranes,
      );
  $$AsignacionesFacturaRecibidaTableTableManager
  get asignacionesFacturaRecibida =>
      $$AsignacionesFacturaRecibidaTableTableManager(
        _db.attachedDatabase,
        _db.asignacionesFacturaRecibida,
      );
  $$ComprasTableTableManager get compras =>
      $$ComprasTableTableManager(_db.attachedDatabase, _db.compras);
  $$FacturaRecibidaComprasTableTableManager get facturaRecibidaCompras =>
      $$FacturaRecibidaComprasTableTableManager(
        _db.attachedDatabase,
        _db.facturaRecibidaCompras,
      );
  $$PagosProveedorTableTableManager get pagosProveedor =>
      $$PagosProveedorTableTableManager(
        _db.attachedDatabase,
        _db.pagosProveedor,
      );
}

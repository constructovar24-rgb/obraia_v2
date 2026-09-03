// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'factura_documentos_emitidos_dao.dart';

// ignore_for_file: type=lint
mixin _$FacturaDocumentosEmitidosDaoMixin on DatabaseAccessor<AppDatabase> {
  $TenantsTable get tenants => attachedDatabase.tenants;
  $ClientesTable get clientes => attachedDatabase.clientes;
  $ExpedientesTable get expedientes => attachedDatabase.expedientes;
  $PresupuestosTable get presupuestos => attachedDatabase.presupuestos;
  $FacturasTable get facturas => attachedDatabase.facturas;
  $FacturaDocumentosEmitidosTable get facturaDocumentosEmitidos =>
      attachedDatabase.facturaDocumentosEmitidos;
  FacturaDocumentosEmitidosDaoManager get managers =>
      FacturaDocumentosEmitidosDaoManager(this);
}

class FacturaDocumentosEmitidosDaoManager {
  final _$FacturaDocumentosEmitidosDaoMixin _db;
  FacturaDocumentosEmitidosDaoManager(this._db);
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
  $$FacturaDocumentosEmitidosTableTableManager get facturaDocumentosEmitidos =>
      $$FacturaDocumentosEmitidosTableTableManager(
        _db.attachedDatabase,
        _db.facturaDocumentosEmitidos,
      );
}

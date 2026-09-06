// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'presupuesto_documentos_aceptados_dao.dart';

// ignore_for_file: type=lint
mixin _$PresupuestoDocumentosAceptadosDaoMixin
    on DatabaseAccessor<AppDatabase> {
  $TenantsTable get tenants => attachedDatabase.tenants;
  $ClientesTable get clientes => attachedDatabase.clientes;
  $ExpedientesTable get expedientes => attachedDatabase.expedientes;
  $PresupuestosTable get presupuestos => attachedDatabase.presupuestos;
  $PresupuestoDocumentosAceptadosTable get presupuestoDocumentosAceptados =>
      attachedDatabase.presupuestoDocumentosAceptados;
  PresupuestoDocumentosAceptadosDaoManager get managers =>
      PresupuestoDocumentosAceptadosDaoManager(this);
}

class PresupuestoDocumentosAceptadosDaoManager {
  final _$PresupuestoDocumentosAceptadosDaoMixin _db;
  PresupuestoDocumentosAceptadosDaoManager(this._db);
  $$TenantsTableTableManager get tenants =>
      $$TenantsTableTableManager(_db.attachedDatabase, _db.tenants);
  $$ClientesTableTableManager get clientes =>
      $$ClientesTableTableManager(_db.attachedDatabase, _db.clientes);
  $$ExpedientesTableTableManager get expedientes =>
      $$ExpedientesTableTableManager(_db.attachedDatabase, _db.expedientes);
  $$PresupuestosTableTableManager get presupuestos =>
      $$PresupuestosTableTableManager(_db.attachedDatabase, _db.presupuestos);
  $$PresupuestoDocumentosAceptadosTableTableManager
  get presupuestoDocumentosAceptados =>
      $$PresupuestoDocumentosAceptadosTableTableManager(
        _db.attachedDatabase,
        _db.presupuestoDocumentosAceptados,
      );
}

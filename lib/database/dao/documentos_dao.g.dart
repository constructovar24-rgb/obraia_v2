// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'documentos_dao.dart';

// ignore_for_file: type=lint
mixin _$DocumentosDaoMixin on DatabaseAccessor<AppDatabase> {
  $TenantsTable get tenants => attachedDatabase.tenants;
  $ClientesTable get clientes => attachedDatabase.clientes;
  $ExpedientesTable get expedientes => attachedDatabase.expedientes;
  $DocumentosTable get documentos => attachedDatabase.documentos;
  DocumentosDaoManager get managers => DocumentosDaoManager(this);
}

class DocumentosDaoManager {
  final _$DocumentosDaoMixin _db;
  DocumentosDaoManager(this._db);
  $$TenantsTableTableManager get tenants =>
      $$TenantsTableTableManager(_db.attachedDatabase, _db.tenants);
  $$ClientesTableTableManager get clientes =>
      $$ClientesTableTableManager(_db.attachedDatabase, _db.clientes);
  $$ExpedientesTableTableManager get expedientes =>
      $$ExpedientesTableTableManager(_db.attachedDatabase, _db.expedientes);
  $$DocumentosTableTableManager get documentos =>
      $$DocumentosTableTableManager(_db.attachedDatabase, _db.documentos);
}

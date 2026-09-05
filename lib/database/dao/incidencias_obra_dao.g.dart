// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incidencias_obra_dao.dart';

// ignore_for_file: type=lint
mixin _$IncidenciasObraDaoMixin on DatabaseAccessor<AppDatabase> {
  $TenantsTable get tenants => attachedDatabase.tenants;
  $ClientesTable get clientes => attachedDatabase.clientes;
  $ExpedientesTable get expedientes => attachedDatabase.expedientes;
  $IncidenciasObraTable get incidenciasObra => attachedDatabase.incidenciasObra;
  $DocumentosTable get documentos => attachedDatabase.documentos;
  $IncidenciaDocumentosTable get incidenciaDocumentos =>
      attachedDatabase.incidenciaDocumentos;
  $ActuacionesObraTable get actuacionesObra => attachedDatabase.actuacionesObra;
  $DiarioObraTable get diarioObra => attachedDatabase.diarioObra;
  $IncidenciaDiarioTable get incidenciaDiario =>
      attachedDatabase.incidenciaDiario;
  IncidenciasObraDaoManager get managers => IncidenciasObraDaoManager(this);
}

class IncidenciasObraDaoManager {
  final _$IncidenciasObraDaoMixin _db;
  IncidenciasObraDaoManager(this._db);
  $$TenantsTableTableManager get tenants =>
      $$TenantsTableTableManager(_db.attachedDatabase, _db.tenants);
  $$ClientesTableTableManager get clientes =>
      $$ClientesTableTableManager(_db.attachedDatabase, _db.clientes);
  $$ExpedientesTableTableManager get expedientes =>
      $$ExpedientesTableTableManager(_db.attachedDatabase, _db.expedientes);
  $$IncidenciasObraTableTableManager get incidenciasObra =>
      $$IncidenciasObraTableTableManager(
        _db.attachedDatabase,
        _db.incidenciasObra,
      );
  $$DocumentosTableTableManager get documentos =>
      $$DocumentosTableTableManager(_db.attachedDatabase, _db.documentos);
  $$IncidenciaDocumentosTableTableManager get incidenciaDocumentos =>
      $$IncidenciaDocumentosTableTableManager(
        _db.attachedDatabase,
        _db.incidenciaDocumentos,
      );
  $$ActuacionesObraTableTableManager get actuacionesObra =>
      $$ActuacionesObraTableTableManager(
        _db.attachedDatabase,
        _db.actuacionesObra,
      );
  $$DiarioObraTableTableManager get diarioObra =>
      $$DiarioObraTableTableManager(_db.attachedDatabase, _db.diarioObra);
  $$IncidenciaDiarioTableTableManager get incidenciaDiario =>
      $$IncidenciaDiarioTableTableManager(
        _db.attachedDatabase,
        _db.incidenciaDiario,
      );
}

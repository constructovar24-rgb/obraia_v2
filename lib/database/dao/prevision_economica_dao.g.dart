// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prevision_economica_dao.dart';

// ignore_for_file: type=lint
mixin _$PrevisionEconomicaDaoMixin on DatabaseAccessor<AppDatabase> {
  $TenantsTable get tenants => attachedDatabase.tenants;
  $ClientesTable get clientes => attachedDatabase.clientes;
  $ExpedientesTable get expedientes => attachedDatabase.expedientes;
  $CategoriasEconomicasTable get categoriasEconomicas =>
      attachedDatabase.categoriasEconomicas;
  $PresupuestosTable get presupuestos => attachedDatabase.presupuestos;
  $PlanesEconomicosTable get planesEconomicos =>
      attachedDatabase.planesEconomicos;
  $LineasPresupuestoTable get lineasPresupuesto =>
      attachedDatabase.lineasPresupuesto;
  $PlanEconomicoPartidasTable get planEconomicoPartidas =>
      attachedDatabase.planEconomicoPartidas;
  $CompromisosEconomicosTable get compromisosEconomicos =>
      attachedDatabase.compromisosEconomicos;
  $HechosCosteTable get hechosCoste => attachedDatabase.hechosCoste;
  $AplicacionesCompromisoCosteTable get aplicacionesCompromisoCoste =>
      attachedDatabase.aplicacionesCompromisoCoste;
  $EstimacionesCosteRestanteTable get estimacionesCosteRestante =>
      attachedDatabase.estimacionesCosteRestante;
  PrevisionEconomicaDaoManager get managers =>
      PrevisionEconomicaDaoManager(this);
}

class PrevisionEconomicaDaoManager {
  final _$PrevisionEconomicaDaoMixin _db;
  PrevisionEconomicaDaoManager(this._db);
  $$TenantsTableTableManager get tenants =>
      $$TenantsTableTableManager(_db.attachedDatabase, _db.tenants);
  $$ClientesTableTableManager get clientes =>
      $$ClientesTableTableManager(_db.attachedDatabase, _db.clientes);
  $$ExpedientesTableTableManager get expedientes =>
      $$ExpedientesTableTableManager(_db.attachedDatabase, _db.expedientes);
  $$CategoriasEconomicasTableTableManager get categoriasEconomicas =>
      $$CategoriasEconomicasTableTableManager(
        _db.attachedDatabase,
        _db.categoriasEconomicas,
      );
  $$PresupuestosTableTableManager get presupuestos =>
      $$PresupuestosTableTableManager(_db.attachedDatabase, _db.presupuestos);
  $$PlanesEconomicosTableTableManager get planesEconomicos =>
      $$PlanesEconomicosTableTableManager(
        _db.attachedDatabase,
        _db.planesEconomicos,
      );
  $$LineasPresupuestoTableTableManager get lineasPresupuesto =>
      $$LineasPresupuestoTableTableManager(
        _db.attachedDatabase,
        _db.lineasPresupuesto,
      );
  $$PlanEconomicoPartidasTableTableManager get planEconomicoPartidas =>
      $$PlanEconomicoPartidasTableTableManager(
        _db.attachedDatabase,
        _db.planEconomicoPartidas,
      );
  $$CompromisosEconomicosTableTableManager get compromisosEconomicos =>
      $$CompromisosEconomicosTableTableManager(
        _db.attachedDatabase,
        _db.compromisosEconomicos,
      );
  $$HechosCosteTableTableManager get hechosCoste =>
      $$HechosCosteTableTableManager(_db.attachedDatabase, _db.hechosCoste);
  $$AplicacionesCompromisoCosteTableTableManager
  get aplicacionesCompromisoCoste =>
      $$AplicacionesCompromisoCosteTableTableManager(
        _db.attachedDatabase,
        _db.aplicacionesCompromisoCoste,
      );
  $$EstimacionesCosteRestanteTableTableManager get estimacionesCosteRestante =>
      $$EstimacionesCosteRestanteTableTableManager(
        _db.attachedDatabase,
        _db.estimacionesCosteRestante,
      );
}

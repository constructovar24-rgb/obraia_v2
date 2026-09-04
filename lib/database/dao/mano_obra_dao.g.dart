// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mano_obra_dao.dart';

// ignore_for_file: type=lint
mixin _$ManoObraDaoMixin on DatabaseAccessor<AppDatabase> {
  $TenantsTable get tenants => attachedDatabase.tenants;
  $PersonasLaboralesTable get personasLaborales =>
      attachedDatabase.personasLaborales;
  $TarifasPersonaTable get tarifasPersona => attachedDatabase.tarifasPersona;
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
  $HechosCosteTable get hechosCoste => attachedDatabase.hechosCoste;
  $PartesTrabajoTable get partesTrabajo => attachedDatabase.partesTrabajo;
  ManoObraDaoManager get managers => ManoObraDaoManager(this);
}

class ManoObraDaoManager {
  final _$ManoObraDaoMixin _db;
  ManoObraDaoManager(this._db);
  $$TenantsTableTableManager get tenants =>
      $$TenantsTableTableManager(_db.attachedDatabase, _db.tenants);
  $$PersonasLaboralesTableTableManager get personasLaborales =>
      $$PersonasLaboralesTableTableManager(
        _db.attachedDatabase,
        _db.personasLaborales,
      );
  $$TarifasPersonaTableTableManager get tarifasPersona =>
      $$TarifasPersonaTableTableManager(
        _db.attachedDatabase,
        _db.tarifasPersona,
      );
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
  $$HechosCosteTableTableManager get hechosCoste =>
      $$HechosCosteTableTableManager(_db.attachedDatabase, _db.hechosCoste);
  $$PartesTrabajoTableTableManager get partesTrabajo =>
      $$PartesTrabajoTableTableManager(_db.attachedDatabase, _db.partesTrabajo);
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'economia_prevista_dao.dart';

// ignore_for_file: type=lint
mixin _$EconomiaPrevistaDaoMixin on DatabaseAccessor<AppDatabase> {
  $TenantsTable get tenants => attachedDatabase.tenants;
  $CategoriasEconomicasTable get categoriasEconomicas =>
      attachedDatabase.categoriasEconomicas;
  $ConfiguracionEconomicaTable get configuracionEconomica =>
      attachedDatabase.configuracionEconomica;
  $ClientesTable get clientes => attachedDatabase.clientes;
  $ExpedientesTable get expedientes => attachedDatabase.expedientes;
  $PresupuestosTable get presupuestos => attachedDatabase.presupuestos;
  $LineasPresupuestoTable get lineasPresupuesto =>
      attachedDatabase.lineasPresupuesto;
  $LineaPresupuestoCostesPrevistosTable get lineaPresupuestoCostesPrevistos =>
      attachedDatabase.lineaPresupuestoCostesPrevistos;
  $PlanesEconomicosTable get planesEconomicos =>
      attachedDatabase.planesEconomicos;
  $PlanEconomicoPartidasTable get planEconomicoPartidas =>
      attachedDatabase.planEconomicoPartidas;
  EconomiaPrevistaDaoManager get managers => EconomiaPrevistaDaoManager(this);
}

class EconomiaPrevistaDaoManager {
  final _$EconomiaPrevistaDaoMixin _db;
  EconomiaPrevistaDaoManager(this._db);
  $$TenantsTableTableManager get tenants =>
      $$TenantsTableTableManager(_db.attachedDatabase, _db.tenants);
  $$CategoriasEconomicasTableTableManager get categoriasEconomicas =>
      $$CategoriasEconomicasTableTableManager(
        _db.attachedDatabase,
        _db.categoriasEconomicas,
      );
  $$ConfiguracionEconomicaTableTableManager get configuracionEconomica =>
      $$ConfiguracionEconomicaTableTableManager(
        _db.attachedDatabase,
        _db.configuracionEconomica,
      );
  $$ClientesTableTableManager get clientes =>
      $$ClientesTableTableManager(_db.attachedDatabase, _db.clientes);
  $$ExpedientesTableTableManager get expedientes =>
      $$ExpedientesTableTableManager(_db.attachedDatabase, _db.expedientes);
  $$PresupuestosTableTableManager get presupuestos =>
      $$PresupuestosTableTableManager(_db.attachedDatabase, _db.presupuestos);
  $$LineasPresupuestoTableTableManager get lineasPresupuesto =>
      $$LineasPresupuestoTableTableManager(
        _db.attachedDatabase,
        _db.lineasPresupuesto,
      );
  $$LineaPresupuestoCostesPrevistosTableTableManager
  get lineaPresupuestoCostesPrevistos =>
      $$LineaPresupuestoCostesPrevistosTableTableManager(
        _db.attachedDatabase,
        _db.lineaPresupuestoCostesPrevistos,
      );
  $$PlanesEconomicosTableTableManager get planesEconomicos =>
      $$PlanesEconomicosTableTableManager(
        _db.attachedDatabase,
        _db.planesEconomicos,
      );
  $$PlanEconomicoPartidasTableTableManager get planEconomicoPartidas =>
      $$PlanEconomicoPartidasTableTableManager(
        _db.attachedDatabase,
        _db.planEconomicoPartidas,
      );
}

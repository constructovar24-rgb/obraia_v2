// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cierre_economico_dao.dart';

// ignore_for_file: type=lint
mixin _$CierreEconomicoDaoMixin on DatabaseAccessor<AppDatabase> {
  $TenantsTable get tenants => attachedDatabase.tenants;
  $ClientesTable get clientes => attachedDatabase.clientes;
  $ExpedientesTable get expedientes => attachedDatabase.expedientes;
  $EstadosEconomicosObraTable get estadosEconomicosObra =>
      attachedDatabase.estadosEconomicosObra;
  $CierresEconomicosObraTable get cierresEconomicosObra =>
      attachedDatabase.cierresEconomicosObra;
  $ReaperturasEconomicasObraTable get reaperturasEconomicasObra =>
      attachedDatabase.reaperturasEconomicasObra;
  CierreEconomicoDaoManager get managers => CierreEconomicoDaoManager(this);
}

class CierreEconomicoDaoManager {
  final _$CierreEconomicoDaoMixin _db;
  CierreEconomicoDaoManager(this._db);
  $$TenantsTableTableManager get tenants =>
      $$TenantsTableTableManager(_db.attachedDatabase, _db.tenants);
  $$ClientesTableTableManager get clientes =>
      $$ClientesTableTableManager(_db.attachedDatabase, _db.clientes);
  $$ExpedientesTableTableManager get expedientes =>
      $$ExpedientesTableTableManager(_db.attachedDatabase, _db.expedientes);
  $$EstadosEconomicosObraTableTableManager get estadosEconomicosObra =>
      $$EstadosEconomicosObraTableTableManager(
        _db.attachedDatabase,
        _db.estadosEconomicosObra,
      );
  $$CierresEconomicosObraTableTableManager get cierresEconomicosObra =>
      $$CierresEconomicosObraTableTableManager(
        _db.attachedDatabase,
        _db.cierresEconomicosObra,
      );
  $$ReaperturasEconomicasObraTableTableManager get reaperturasEconomicasObra =>
      $$ReaperturasEconomicasObraTableTableManager(
        _db.attachedDatabase,
        _db.reaperturasEconomicasObra,
      );
}

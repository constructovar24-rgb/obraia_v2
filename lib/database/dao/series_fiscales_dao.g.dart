// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'series_fiscales_dao.dart';

// ignore_for_file: type=lint
mixin _$SeriesFiscalesDaoMixin on DatabaseAccessor<AppDatabase> {
  $TenantsTable get tenants => attachedDatabase.tenants;
  $SeriesFiscalesTable get seriesFiscales => attachedDatabase.seriesFiscales;
  $EventosSerieFiscalTable get eventosSerieFiscal =>
      attachedDatabase.eventosSerieFiscal;
  SeriesFiscalesDaoManager get managers => SeriesFiscalesDaoManager(this);
}

class SeriesFiscalesDaoManager {
  final _$SeriesFiscalesDaoMixin _db;
  SeriesFiscalesDaoManager(this._db);
  $$TenantsTableTableManager get tenants =>
      $$TenantsTableTableManager(_db.attachedDatabase, _db.tenants);
  $$SeriesFiscalesTableTableManager get seriesFiscales =>
      $$SeriesFiscalesTableTableManager(
        _db.attachedDatabase,
        _db.seriesFiscales,
      );
  $$EventosSerieFiscalTableTableManager get eventosSerieFiscal =>
      $$EventosSerieFiscalTableTableManager(
        _db.attachedDatabase,
        _db.eventosSerieFiscal,
      );
}

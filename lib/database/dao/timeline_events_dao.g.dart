// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline_events_dao.dart';

// ignore_for_file: type=lint
mixin _$TimelineEventsDaoMixin on DatabaseAccessor<AppDatabase> {
  $TenantsTable get tenants => attachedDatabase.tenants;
  $ClientesTable get clientes => attachedDatabase.clientes;
  $ExpedientesTable get expedientes => attachedDatabase.expedientes;
  $TimelineEventsTable get timelineEvents => attachedDatabase.timelineEvents;
  TimelineEventsDaoManager get managers => TimelineEventsDaoManager(this);
}

class TimelineEventsDaoManager {
  final _$TimelineEventsDaoMixin _db;
  TimelineEventsDaoManager(this._db);
  $$TenantsTableTableManager get tenants =>
      $$TenantsTableTableManager(_db.attachedDatabase, _db.tenants);
  $$ClientesTableTableManager get clientes =>
      $$ClientesTableTableManager(_db.attachedDatabase, _db.clientes);
  $$ExpedientesTableTableManager get expedientes =>
      $$ExpedientesTableTableManager(_db.attachedDatabase, _db.expedientes);
  $$TimelineEventsTableTableManager get timelineEvents =>
      $$TimelineEventsTableTableManager(
        _db.attachedDatabase,
        _db.timelineEvents,
      );
}

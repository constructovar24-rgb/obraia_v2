// ignore_for_file: unused_import

import 'package:drift/drift.dart';

import 'expedientes.dart';
import 'tenants.dart';

class TimelineEvents extends Table {
  TextColumn get tenantId => text()
      .clientDefault(() => defaultTenantIdForTesting)
      .references(Tenants, #id)();

  TextColumn get id => text()();

  TextColumn get expedienteId => text()();

  DateTimeColumn get fecha => dateTime().withDefault(currentDateAndTime)();

  TextColumn get tipo => text()();

  TextColumn get titulo => text().withDefault(const Constant(''))();

  TextColumn get descripcion => text().nullable()();

  TextColumn get referenciaId => text().nullable()();

  DateTimeColumn get fechaCreacion =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {tenantId, id},
  ];

  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (tenant_id, expediente_id) REFERENCES expedientes (tenant_id, id)',
  ];
}

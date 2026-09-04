import 'package:drift/drift.dart';

import 'tenants.dart';

class ConfiguracionEconomica extends Table {
  TextColumn get tenantId => text().references(Tenants, #id)();
  TextColumn get id => text()();
  RealColumn get porcentajeIndirectos => real().nullable()();
  DateTimeColumn get fechaCreacion => dateTime()();
  DateTimeColumn get fechaModificacion => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {tenantId},
    {tenantId, id},
  ];

  @override
  List<String> get customConstraints => [
    'CHECK (porcentaje_indirectos IS NULL OR (porcentaje_indirectos >= 0 AND porcentaje_indirectos <= 100))',
  ];
}

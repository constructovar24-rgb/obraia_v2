import 'package:drift/drift.dart';

import 'tenants.dart';

class CategoriasEconomicas extends Table {
  TextColumn get tenantId => text().references(Tenants, #id)();
  TextColumn get id => text()();
  TextColumn get codigo => text()();
  TextColumn get nombre => text()();
  TextColumn get tipo => text().withDefault(const Constant('directo'))();
  IntColumn get orden => integer().withDefault(const Constant(0))();
  BoolColumn get activa => boolean().withDefault(const Constant(true))();
  DateTimeColumn get fechaCreacion => dateTime()();
  DateTimeColumn get fechaModificacion => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {tenantId, id},
    {tenantId, codigo},
  ];

  @override
  List<String> get customConstraints => [
    "CHECK (tipo IN ('directo'))",
    'CHECK (orden >= 0)',
  ];
}

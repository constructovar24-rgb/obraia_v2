// ignore_for_file: unused_import

import 'package:drift/drift.dart';

import 'tenants.dart';

class PersonasLaborales extends Table {
  TextColumn get tenantId => text().references(Tenants, #id)();
  TextColumn get id => text()();
  TextColumn get nombre => text()();
  TextColumn get tipo => text()();
  BoolColumn get activa => boolean().withDefault(const Constant(true))();
  TextColumn get observaciones => text().nullable()();
  DateTimeColumn get fechaCreacion => dateTime()();
  DateTimeColumn get fechaModificacion => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
  @override
  List<Set<Column>> get uniqueKeys => [
    {tenantId, id},
  ];
  @override
  List<String> get customConstraints => [
    "CHECK (tipo IN ('titular', 'empleado', 'colaboradorInterno', 'otroInterno'))",
    "CHECK (length(trim(nombre)) > 0)",
  ];
}

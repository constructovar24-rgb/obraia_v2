import 'package:drift/drift.dart';

class Expedientes extends Table {
  TextColumn get id => text()();

  TextColumn get codigo => text()();

  TextColumn get nombre => text()();

  IntColumn get estado =>
      integer().withDefault(const Constant(0))();

  BoolColumn get eliminado =>
      boolean().withDefault(const Constant(false))();

  DateTimeColumn get fechaCreacion =>
      dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get fechaModificacion =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
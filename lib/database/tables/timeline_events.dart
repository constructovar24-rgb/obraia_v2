import 'package:drift/drift.dart';

import 'expedientes.dart';

class TimelineEvents extends Table {
  TextColumn get id => text()();

  TextColumn get expedienteId => text().references(Expedientes, #id)();

  DateTimeColumn get fecha => dateTime().withDefault(currentDateAndTime)();

  TextColumn get tipo => text()();

  TextColumn get titulo => text().withDefault(const Constant(''))();

  TextColumn get descripcion => text().nullable()();

  TextColumn get referenciaId => text().nullable()();

  DateTimeColumn get fechaCreacion =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

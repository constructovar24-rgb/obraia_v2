import 'package:drift/drift.dart';

import 'expedientes.dart';

class Presupuestos extends Table {
  TextColumn get id => text()();

  TextColumn get expedienteId => text().references(Expedientes, #id)();

  TextColumn get titulo => text().withDefault(const Constant(''))();

  TextColumn get codigo => text().withDefault(const Constant(''))();

  DateTimeColumn get fecha => dateTime().withDefault(currentDateAndTime)();

  TextColumn get descripcion => text().withDefault(const Constant(''))();

  RealColumn get importeTotal => real().withDefault(const Constant(0))();

  TextColumn get estado => text().withDefault(const Constant('Borrador'))();

  BoolColumn get eliminado => boolean().withDefault(const Constant(false))();

  DateTimeColumn get fechaCreacion =>
      dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get fechaModificacion =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

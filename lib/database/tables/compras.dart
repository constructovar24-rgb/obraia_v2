import 'package:drift/drift.dart';

import 'expedientes.dart';

class Compras extends Table {
  TextColumn get id => text()();

  TextColumn get expedienteId => text().references(Expedientes, #id)();

  TextColumn get proveedorId => text().nullable()();

  TextColumn get proveedorNombre =>
      text().withDefault(const Constant(''))();

  DateTimeColumn get fecha => dateTime().withDefault(currentDateAndTime)();

  TextColumn get numeroFactura => text().nullable()();

  TextColumn get concepto => text().withDefault(const Constant(''))();

  RealColumn get baseImponible => real().withDefault(const Constant(0))();

  RealColumn get ivaPorcentaje => real().withDefault(const Constant(21))();

  RealColumn get importeTotal => real().withDefault(const Constant(0))();

  TextColumn get estado => text().withDefault(const Constant(''))();

  TextColumn get observaciones => text().nullable()();

  BoolColumn get eliminado => boolean().withDefault(const Constant(false))();

  DateTimeColumn get fechaCreacion =>
      dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get fechaModificacion =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

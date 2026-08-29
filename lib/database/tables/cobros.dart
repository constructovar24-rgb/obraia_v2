import 'package:drift/drift.dart';

import 'facturas.dart';

class Cobros extends Table {
  TextColumn get id => text()();

  TextColumn get facturaId => text().references(Facturas, #id)();

  DateTimeColumn get fecha => dateTime().withDefault(currentDateAndTime)();

  RealColumn get importe => real().withDefault(const Constant(0))();

  TextColumn get metodoPago =>
      text().withDefault(const Constant('Transferencia'))();

  TextColumn get referencia => text().withDefault(const Constant(''))();

  TextColumn get observaciones => text().withDefault(const Constant(''))();

  TextColumn get tipoMovimiento =>
      text().withDefault(const Constant('cobro'))();

  TextColumn get cobroOrigenId => text().nullable().references(Cobros, #id)();

  TextColumn get motivo => text().withDefault(const Constant(''))();

  DateTimeColumn get fechaCreacion =>
      dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get fechaModificacion =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

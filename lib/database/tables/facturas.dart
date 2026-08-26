import 'package:drift/drift.dart';

import 'clientes.dart';
import 'presupuestos.dart';

class Facturas extends Table {
  TextColumn get id => text()();

  TextColumn get codigo => text().withDefault(const Constant(''))();

  TextColumn get clienteId => text().references(Clientes, #id)();

  DateTimeColumn get fecha => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get fechaVencimiento =>
      dateTime().withDefault(currentDateAndTime)();

  TextColumn get estado => text().withDefault(const Constant('borrador'))();

  RealColumn get subtotal => real().withDefault(const Constant(0))();

  RealColumn get iva => real().withDefault(const Constant(0))();

  RealColumn get ivaPorcentaje => real().withDefault(const Constant(21))();

  RealColumn get total => real().withDefault(const Constant(0))();

  TextColumn get observaciones => text().withDefault(const Constant(''))();

  TextColumn get presupuestoOrigenId =>
      text().nullable().references(Presupuestos, #id)();

  DateTimeColumn get fechaCreacion =>
      dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get fechaModificacion =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

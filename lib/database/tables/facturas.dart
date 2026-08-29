import 'package:drift/drift.dart';

import 'clientes.dart';
import 'presupuestos.dart';

class Facturas extends Table {
  TextColumn get id => text()();

  TextColumn get codigo => text().withDefault(const Constant(''))();

  IntColumn get anioNumeracion => integer().nullable()();

  IntColumn get numeroLegal => integer().nullable()();

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

  DateTimeColumn get fechaEmision => dateTime().nullable()();

  TextColumn get clienteNombreHistorico =>
      text().withDefault(const Constant(''))();
  TextColumn get clienteNifHistorico =>
      text().withDefault(const Constant(''))();
  TextColumn get clienteDireccionHistorica =>
      text().withDefault(const Constant(''))();
  TextColumn get clienteTelefonoHistorico =>
      text().withDefault(const Constant(''))();
  TextColumn get clienteEmailHistorico =>
      text().withDefault(const Constant(''))();

  TextColumn get empresaNombreHistorico =>
      text().withDefault(const Constant(''))();
  TextColumn get empresaCifHistorico =>
      text().withDefault(const Constant(''))();
  TextColumn get empresaDireccionHistorica =>
      text().withDefault(const Constant(''))();
  TextColumn get empresaCodigoPostalHistorico =>
      text().withDefault(const Constant(''))();
  TextColumn get empresaPoblacionHistorica =>
      text().withDefault(const Constant(''))();
  TextColumn get empresaProvinciaHistorica =>
      text().withDefault(const Constant(''))();
  TextColumn get empresaTelefonoHistorico =>
      text().withDefault(const Constant(''))();
  TextColumn get empresaEmailHistorico =>
      text().withDefault(const Constant(''))();
  TextColumn get empresaWebHistorica =>
      text().withDefault(const Constant(''))();

  TextColumn get expedienteOrigenIdHistorico =>
      text().withDefault(const Constant(''))();
  TextColumn get expedienteCodigoHistorico =>
      text().withDefault(const Constant(''))();
  TextColumn get expedienteNombreHistorico =>
      text().withDefault(const Constant(''))();
  TextColumn get presupuestoCodigoHistorico =>
      text().withDefault(const Constant(''))();

  DateTimeColumn get fechaCreacion =>
      dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get fechaModificacion =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

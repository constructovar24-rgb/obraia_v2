import 'package:drift/drift.dart';

import 'clientes.dart';

class Expedientes extends Table {
  TextColumn get id => text()();

  TextColumn get codigo => text()();

  TextColumn get nombre => text()();

  // Cliente / Promotor
  TextColumn get cliente =>
      text().withDefault(const Constant(''))();

  TextColumn get clienteId => text().nullable().references(Clientes, #id)();

  // Datos de ubicación
  TextColumn get direccion =>
      text().withDefault(const Constant(''))();

  TextColumn get poblacion =>
      text().withDefault(const Constant(''))();

  TextColumn get provincia =>
      text().withDefault(const Constant(''))();

  TextColumn get codigoPostal =>
      text().withDefault(const Constant(''))();

  TextColumn get pais =>
      text().withDefault(const Constant('España'))();

  // Estado del expediente
  IntColumn get estado =>
      integer().withDefault(const Constant(0))();

  BoolColumn get eliminado =>
      boolean().withDefault(const Constant(false))();

  // Fechas
  DateTimeColumn get fechaCreacion =>
      dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get fechaModificacion =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
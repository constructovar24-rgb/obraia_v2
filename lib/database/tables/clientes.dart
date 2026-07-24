import 'package:drift/drift.dart';

class Clientes extends Table {
  TextColumn get id => text()();

  TextColumn get nombre => text()();

  TextColumn get apellidos => text().withDefault(const Constant(''))();

  TextColumn get nif => text().withDefault(const Constant(''))();

  TextColumn get telefono => text().withDefault(const Constant(''))();

  TextColumn get email => text().withDefault(const Constant(''))();

  TextColumn get direccion => text().withDefault(const Constant(''))();

  TextColumn get poblacion => text().withDefault(const Constant(''))();

  TextColumn get provincia => text().withDefault(const Constant(''))();

  TextColumn get codigoPostal => text().withDefault(const Constant(''))();

  TextColumn get pais => text().withDefault(const Constant('España'))();

  TextColumn get empresa => text().withDefault(const Constant(''))();

  TextColumn get observaciones => text().withDefault(const Constant(''))();

  IntColumn get estado => integer().withDefault(const Constant(0))();

  BoolColumn get eliminado => boolean().withDefault(const Constant(false))();

  DateTimeColumn get fechaCreacion => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get fechaModificacion => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

import 'package:drift/drift.dart';

import 'expedientes.dart';

class Documentos extends Table {
  TextColumn get id => text()();

  TextColumn get expedienteId => text().references(Expedientes, #id)();

  TextColumn get titulo => text()();

  TextColumn get nombreArchivo => text()();

  TextColumn get rutaArchivo => text()();

  TextColumn get mimeType => text().nullable()();

  IntColumn get tamanoBytes => integer()();

  DateTimeColumn get fecha => dateTime().withDefault(currentDateAndTime)();

  TextColumn get observaciones => text().nullable()();

  TextColumn get tipo => text().withDefault(const Constant('otro'))();

  BoolColumn get eliminado => boolean().withDefault(const Constant(false))();

  DateTimeColumn get fechaCreacion =>
      dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get fechaModificacion =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
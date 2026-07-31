import 'package:drift/drift.dart';

class EmpresaConfiguracion extends Table {
  TextColumn get id => text()();

  TextColumn get nombreEmpresa => text().withDefault(const Constant(''))();

  TextColumn get cif => text().withDefault(const Constant(''))();

  TextColumn get direccion => text().withDefault(const Constant(''))();

  TextColumn get codigoPostal => text().withDefault(const Constant(''))();

  TextColumn get poblacion => text().withDefault(const Constant(''))();

  TextColumn get provincia => text().withDefault(const Constant(''))();

  TextColumn get telefono => text().withDefault(const Constant(''))();

  TextColumn get email => text().withDefault(const Constant(''))();

  TextColumn get web => text().withDefault(const Constant(''))();

  TextColumn get logoPath => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

import 'package:drift/drift.dart';
import 'tenants.dart';

@DataClassName('SerieFiscalRow')
class SeriesFiscales extends Table {
  TextColumn get tenantId => text().references(Tenants, #id)();
  IntColumn get ejercicio => integer()();
  TextColumn get tipo => text()();
  TextColumn get serie => text()();
  IntColumn get numeroInicial => integer()();
  IntColumn get siguienteNumero => integer()();
  BoolColumn get preparada => boolean().withDefault(const Constant(false))();
  IntColumn get documentosPrevios => integer().withDefault(const Constant(0))();
  IntColumn get emisiones => integer().withDefault(const Constant(0))();
  DateTimeColumn get fechaConfiguracion => dateTime()();
  DateTimeColumn get primerUso => dateTime().nullable()();
  @override
  Set<Column> get primaryKey => {tenantId, ejercicio, tipo};
  @override
  List<Set<Column>> get uniqueKeys => [
    {tenantId, ejercicio, serie},
  ];
  @override
  List<String> get customConstraints => [
    "CHECK (tipo IN ('ordinaria','rectificativa'))",
    'CHECK (ejercicio BETWEEN 1900 AND 9999)',
    "CHECK (length(serie) BETWEEN 1 AND 20 AND serie = upper(trim(serie)) AND serie NOT GLOB '*[^A-Z0-9_-]*')",
    'CHECK (numero_inicial > 0 AND siguiente_numero >= numero_inicial AND siguiente_numero <= 2147483647)',
    'CHECK (emisiones >= 0 AND siguiente_numero = numero_inicial + emisiones)',
    'CHECK ((emisiones = 0 AND primer_uso IS NULL) OR (emisiones > 0 AND primer_uso IS NOT NULL AND preparada = 1))',
  ];
}

@DataClassName('EventoSerieFiscalRow')
class EventosSerieFiscal extends Table {
  TextColumn get tenantId => text().references(Tenants, #id)();
  TextColumn get id => text()();
  IntColumn get ejercicio => integer()();
  TextColumn get tipo => text()();
  TextColumn get accion => text()();
  TextColumn get detalleJson => text()();
  DateTimeColumn get fecha => dateTime()();
  @override
  Set<Column> get primaryKey => {tenantId, id};
  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (tenant_id, ejercicio, tipo) REFERENCES series_fiscales (tenant_id, ejercicio, tipo)',
  ];
}

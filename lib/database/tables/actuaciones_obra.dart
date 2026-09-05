import 'package:drift/drift.dart';

import 'tenants.dart';

class ActuacionesObra extends Table {
  TextColumn get tenantId => text().references(Tenants, #id)();
  TextColumn get id => text()();
  TextColumn get expedienteId => text()();
  TextColumn get tipo => text()();
  TextColumn get descripcion => text()();
  DateTimeColumn get fechaPrevista => dateTime().nullable()();
  TextColumn get estado => text().withDefault(const Constant('pendiente'))();
  IntColumn get orden => integer().withDefault(const Constant(0))();
  TextColumn get observaciones => text().nullable()();
  DateTimeColumn get fechaCreacion =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get fechaModificacion =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {tenantId, id};

  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (tenant_id, expediente_id) REFERENCES expedientes (tenant_id, id)',
    "CHECK (tipo IN ('proximoPaso', 'actuacion'))",
    "CHECK (estado IN ('pendiente', 'completado', 'cancelado'))",
    'CHECK (length(trim(descripcion)) > 0)',
  ];
}

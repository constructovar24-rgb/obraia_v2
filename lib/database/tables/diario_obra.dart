// ignore_for_file: unused_import

import 'package:drift/drift.dart';

import 'actuaciones_obra.dart';
import 'expedientes.dart';
import 'tenants.dart';

class DiarioObra extends Table {
  TextColumn get tenantId => text().references(Tenants, #id)();
  TextColumn get id => text()();
  TextColumn get expedienteId => text()();
  DateTimeColumn get fechaTrabajo => dateTime()();
  TextColumn get trabajos => text()();
  TextColumn get observaciones => text().nullable()();
  TextColumn get meteorologia => text().nullable()();
  TextColumn get incidenciaTexto => text().nullable()();
  TextColumn get actuacionId => text().nullable()();
  BoolColumn get anulado => boolean().withDefault(const Constant(false))();
  DateTimeColumn get fechaCreacion =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get fechaModificacion =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {tenantId, id};

  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (tenant_id, expediente_id) REFERENCES expedientes (tenant_id, id)',
    'FOREIGN KEY (tenant_id, actuacion_id) REFERENCES actuaciones_obra (tenant_id, id)',
    'CHECK (length(trim(trabajos)) > 0)',
  ];
}

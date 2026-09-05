// ignore_for_file: unused_import

import 'package:drift/drift.dart';

import 'documentos.dart';
import 'incidencias_obra.dart';
import 'tenants.dart';

class IncidenciaDocumentos extends Table {
  TextColumn get tenantId => text().references(Tenants, #id)();
  TextColumn get incidenciaId => text()();
  TextColumn get documentoId => text()();
  DateTimeColumn get fechaCreacion =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {tenantId, incidenciaId, documentoId};

  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (tenant_id, incidencia_id) REFERENCES incidencias_obra (tenant_id, id) ON DELETE CASCADE',
    'FOREIGN KEY (tenant_id, documento_id) REFERENCES documentos (tenant_id, id)',
  ];
}

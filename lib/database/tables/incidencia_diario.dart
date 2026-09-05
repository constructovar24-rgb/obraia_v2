// ignore_for_file: unused_import

import 'package:drift/drift.dart';

import 'diario_obra.dart';
import 'incidencias_obra.dart';
import 'tenants.dart';

class IncidenciaDiario extends Table {
  TextColumn get tenantId => text().references(Tenants, #id)();
  TextColumn get incidenciaId => text()();
  TextColumn get entradaDiarioId => text()();
  DateTimeColumn get fechaCreacion =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {tenantId, incidenciaId, entradaDiarioId};

  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (tenant_id, incidencia_id) REFERENCES incidencias_obra (tenant_id, id) ON DELETE CASCADE',
    'FOREIGN KEY (tenant_id, entrada_diario_id) REFERENCES diario_obra (tenant_id, id)',
  ];
}

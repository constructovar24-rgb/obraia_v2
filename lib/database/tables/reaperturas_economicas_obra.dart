// ignore_for_file: unused_import
import 'package:drift/drift.dart';
import 'cierres_economicos_obra.dart';
import 'expedientes.dart';
import 'tenants.dart';

class ReaperturasEconomicasObra extends Table {
  TextColumn get tenantId => text().references(Tenants, #id)();
  TextColumn get id => text()();
  TextColumn get expedienteId => text()();
  TextColumn get cierreId => text()();
  DateTimeColumn get fechaReapertura => dateTime()();
  TextColumn get motivo => text()();
  @override
  Set<Column> get primaryKey => {id};
  @override
  List<Set<Column>> get uniqueKeys => [
    {tenantId, id},
  ];
  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (tenant_id, expediente_id) REFERENCES expedientes (tenant_id, id)',
    'FOREIGN KEY (tenant_id, cierre_id) REFERENCES cierres_economicos_obra (tenant_id, id)',
    'CHECK (length(trim(motivo)) > 0)',
  ];
}

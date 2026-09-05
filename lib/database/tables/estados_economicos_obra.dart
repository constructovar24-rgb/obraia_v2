// ignore_for_file: unused_import
import 'package:drift/drift.dart';
import 'expedientes.dart';
import 'tenants.dart';

class EstadosEconomicosObra extends Table {
  TextColumn get tenantId => text().references(Tenants, #id)();
  TextColumn get expedienteId => text()();
  TextColumn get estado => text()();
  IntColumn get numeroCierres => integer().withDefault(const Constant(0))();
  DateTimeColumn get fechaModificacion => dateTime()();
  @override
  Set<Column> get primaryKey => {tenantId, expedienteId};
  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (tenant_id, expediente_id) REFERENCES expedientes (tenant_id, id)',
    "CHECK (estado IN ('abierto', 'cerrado'))",
    'CHECK (numero_cierres >= 0)',
  ];
}

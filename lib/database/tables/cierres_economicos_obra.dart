// ignore_for_file: unused_import
import 'package:drift/drift.dart';
import 'expedientes.dart';
import 'tenants.dart';

class CierresEconomicosObra extends Table {
  TextColumn get tenantId => text().references(Tenants, #id)();
  TextColumn get id => text()();
  TextColumn get expedienteId => text()();
  IntColumn get numero => integer()();
  DateTimeColumn get fechaCierre => dateTime()();
  IntColumn get ventaPlanificadaCentimos => integer().nullable()();
  IntColumn get costePlanificadoCentimos => integer().nullable()();
  IntColumn get costeRealCentimos => integer()();
  IntColumn get compromisoPendienteCentimos => integer()();
  IntColumn get restanteEstimadoCentimos => integer()();
  IntColumn get costeFinalEstimadoCentimos => integer().nullable()();
  IntColumn get beneficioPrevistoCentimos => integer().nullable()();
  IntColumn get beneficioFinalCentimos => integer().nullable()();
  RealColumn get margenPrevistoPorcentaje => real().nullable()();
  RealColumn get margenFinalPorcentaje => real().nullable()();
  TextColumn get cobertura => text()();
  IntColumn get desviacionCosteCentimos => integer().nullable()();
  IntColumn get desviacionBeneficioCentimos => integer().nullable()();
  BoolColumn get conAdvertencias => boolean()();
  TextColumn get resumenPrecheck => text()();
  @override
  Set<Column> get primaryKey => {id};
  @override
  List<Set<Column>> get uniqueKeys => [
    {tenantId, id},
    {tenantId, expedienteId, numero},
  ];
  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (tenant_id, expediente_id) REFERENCES expedientes (tenant_id, id)',
    "CHECK (cobertura IN ('noDisponible', 'parcial', 'completa'))",
    'CHECK (numero > 0)',
  ];
}

// ignore_for_file: unused_import

import 'package:drift/drift.dart';

import 'expedientes.dart';
import 'presupuestos.dart';
import 'tenants.dart';

class PlanesEconomicos extends Table {
  TextColumn get tenantId => text().references(Tenants, #id)();
  TextColumn get id => text()();
  TextColumn get expedienteId => text()();
  TextColumn get presupuestoId => text()();
  TextColumn get tipo => text().withDefault(const Constant('base'))();
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get estado => text().withDefault(const Constant('vigente'))();
  DateTimeColumn get fechaAceptacion => dateTime()();
  IntColumn get ventaNetaCentimos => integer()();
  IntColumn get costeDirectoCentimos => integer().nullable()();
  RealColumn get porcentajeIndirectos => real().nullable()();
  IntColumn get costesIndirectosCentimos => integer().nullable()();
  IntColumn get costeTotalCentimos => integer().nullable()();
  IntColumn get beneficioPrevistoCentimos => integer().nullable()();
  RealColumn get margenPrevistoPorcentaje => real().nullable()();
  TextColumn get coberturaCostes => text()();
  DateTimeColumn get fechaCreacion => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
  @override
  List<Set<Column>> get uniqueKeys => [
    {tenantId, id},
    {tenantId, presupuestoId},
  ];
  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (tenant_id, expediente_id) REFERENCES expedientes (tenant_id, id)',
    'FOREIGN KEY (tenant_id, presupuesto_id) REFERENCES presupuestos (tenant_id, id)',
    "CHECK (tipo IN ('base', 'sustitucion', 'modificado'))",
    "CHECK (estado IN ('vigente', 'sustituido', 'anulado'))",
    "CHECK (cobertura_costes IN ('sinCostes', 'parcial', 'completo'))",
    'CHECK (version > 0)',
    'CHECK (venta_neta_centimos >= 0)',
  ];
}

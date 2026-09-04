// ignore_for_file: unused_import

import 'package:drift/drift.dart';

import 'categorias_economicas.dart';
import 'lineas_presupuesto.dart';
import 'planes_economicos.dart';
import 'tenants.dart';

class PlanEconomicoPartidas extends Table {
  TextColumn get tenantId => text().references(Tenants, #id)();
  TextColumn get id => text()();
  TextColumn get planEconomicoId => text()();
  TextColumn get lineaPresupuestoOrigenId => text().nullable()();
  TextColumn get categoriaEconomicaId => text().nullable()();
  TextColumn get categoriaCodigoSnapshot => text().nullable()();
  TextColumn get categoriaNombreSnapshot => text().nullable()();
  TextColumn get descripcion => text()();
  TextColumn get unidad => text()();
  RealColumn get cantidad => real()();
  IntColumn get precioVentaUnitarioCentimos => integer()();
  IntColumn get importeVentaCentimos => integer()();
  IntColumn get costePrevistoCentimos => integer().nullable()();
  IntColumn get orden => integer()();

  @override
  Set<Column> get primaryKey => {id};
  @override
  List<Set<Column>> get uniqueKeys => [
    {tenantId, id},
    {tenantId, planEconomicoId, orden},
  ];
  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (tenant_id, plan_economico_id) REFERENCES planes_economicos (tenant_id, id)',
    'FOREIGN KEY (tenant_id, linea_presupuesto_origen_id) REFERENCES lineas_presupuesto (tenant_id, id)',
    'FOREIGN KEY (tenant_id, categoria_economica_id) REFERENCES categorias_economicas (tenant_id, id)',
    'CHECK (cantidad > 0)',
    'CHECK (precio_venta_unitario_centimos >= 0)',
    'CHECK (importe_venta_centimos >= 0)',
    'CHECK (coste_previsto_centimos IS NULL OR coste_previsto_centimos >= 0)',
    'CHECK (orden >= 0)',
  ];
}

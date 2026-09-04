// ignore_for_file: unused_import

import 'package:drift/drift.dart';

import 'categorias_economicas.dart';
import 'lineas_presupuesto.dart';
import 'tenants.dart';

class LineaPresupuestoCostesPrevistos extends Table {
  TextColumn get tenantId => text().references(Tenants, #id)();
  TextColumn get id => text()();
  TextColumn get lineaPresupuestoId => text()();
  TextColumn get categoriaEconomicaId => text()();
  IntColumn get costePrevistoCentimos => integer()();
  DateTimeColumn get fechaCreacion => dateTime()();
  DateTimeColumn get fechaModificacion => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {tenantId, id},
    {tenantId, lineaPresupuestoId},
  ];

  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (tenant_id, linea_presupuesto_id) REFERENCES lineas_presupuesto (tenant_id, id) ON DELETE CASCADE',
    'FOREIGN KEY (tenant_id, categoria_economica_id) REFERENCES categorias_economicas (tenant_id, id)',
    'CHECK (coste_previsto_centimos >= 0)',
  ];
}

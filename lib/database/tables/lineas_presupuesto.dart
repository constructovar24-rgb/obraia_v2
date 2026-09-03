// ignore_for_file: unused_import

import 'package:drift/drift.dart';

import 'presupuestos.dart';
import 'tenants.dart';

class LineasPresupuesto extends Table {
  TextColumn get tenantId => text()
      .clientDefault(() => defaultTenantIdForTesting)
      .references(Tenants, #id)();

  TextColumn get id => text()();

  TextColumn get presupuestoId => text()();

  TextColumn get concepto => text()();

  RealColumn get cantidad => real()();

  TextColumn get unidad => text().withDefault(const Constant('ud'))();

  RealColumn get precioUnitario => real()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {tenantId, id},
  ];

  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (tenant_id, presupuesto_id) REFERENCES presupuestos (tenant_id, id)',
  ];
}

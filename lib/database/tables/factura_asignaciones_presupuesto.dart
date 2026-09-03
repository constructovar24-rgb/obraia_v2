// ignore_for_file: unused_import

import 'package:drift/drift.dart';

import 'certificaciones.dart';
import 'factura_lineas.dart';
import 'facturas.dart';
import 'lineas_presupuesto.dart';
import 'presupuestos.dart';
import 'tenants.dart';

class FacturaAsignacionesPresupuesto extends Table {
  TextColumn get tenantId => text()
      .clientDefault(() => defaultTenantIdForTesting)
      .references(Tenants, #id)();
  TextColumn get id => text()();
  TextColumn get facturaId => text()();
  TextColumn get facturaLineaId => text()();
  TextColumn get presupuestoId => text()();
  TextColumn get lineaPresupuestoId => text()();
  RealColumn get cantidadAplicada => real().nullable()();
  RealColumn get baseAplicada => real()();
  TextColumn get certificacionOrigenId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {tenantId, id},
    {tenantId, facturaLineaId},
  ];

  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (tenant_id, factura_id) REFERENCES facturas (tenant_id, id)',
    'FOREIGN KEY (tenant_id, factura_linea_id) REFERENCES factura_lineas (tenant_id, id)',
    'FOREIGN KEY (tenant_id, presupuesto_id) REFERENCES presupuestos (tenant_id, id)',
    'FOREIGN KEY (tenant_id, linea_presupuesto_id) REFERENCES lineas_presupuesto (tenant_id, id)',
    'FOREIGN KEY (tenant_id, certificacion_origen_id) REFERENCES certificaciones (tenant_id, id)',
  ];
}

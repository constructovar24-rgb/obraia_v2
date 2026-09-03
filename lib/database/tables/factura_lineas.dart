// ignore_for_file: unused_import

import 'package:drift/drift.dart';

import 'facturas.dart';
import 'tenants.dart';

class FacturaLineas extends Table {
  TextColumn get tenantId => text()
      .clientDefault(() => defaultTenantIdForTesting)
      .references(Tenants, #id)();

  TextColumn get id => text()();

  TextColumn get facturaId => text()();

  TextColumn get lineaRectificadaId => text().nullable()();

  TextColumn get lineaRaizId => text().nullable()();

  TextColumn get descripcion => text()();

  RealColumn get cantidad => real()();

  TextColumn get unidad => text().withDefault(const Constant('ud'))();

  RealColumn get precioUnitario => real()();

  RealColumn get descuento => real().withDefault(const Constant(0))();

  RealColumn get importe => real().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {tenantId, id},
  ];

  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (tenant_id, factura_id) REFERENCES facturas (tenant_id, id)',
    'FOREIGN KEY (tenant_id, linea_rectificada_id) REFERENCES factura_lineas (tenant_id, id)',
    'FOREIGN KEY (tenant_id, linea_raiz_id) REFERENCES factura_lineas (tenant_id, id)',
  ];
}

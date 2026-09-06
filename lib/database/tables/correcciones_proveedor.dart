import 'package:drift/drift.dart';
import 'tenants.dart';

class ControlFacturasProveedor extends Table {
  TextColumn get tenantId => text().references(Tenants, #id)();
  TextColumn get facturaId => text()();
  TextColumn get estadoDocumento =>
      text().withDefault(const Constant('borrador'))();
  BoolColumn get pagoVerificado =>
      boolean().withDefault(const Constant(false))();
  TextColumn get tipo => text().withDefault(const Constant('factura'))();
  TextColumn get originalId => text().nullable()();
  TextColumn get destino => text().withDefault(const Constant('sinAsignar'))();
  @override
  Set<Column> get primaryKey => {tenantId, facturaId};
  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (tenant_id, factura_id) REFERENCES facturas_recibidas (tenant_id,id)',
    'FOREIGN KEY (tenant_id, original_id) REFERENCES facturas_recibidas (tenant_id,id)',
    "CHECK (estado_documento IN ('borrador','registrada','anulada'))",
    "CHECK (tipo IN ('factura','abono'))",
    "CHECK (destino IN ('obra','general','sinAsignar'))",
    "CHECK (original_id IS NULL OR original_id != factura_id)",
  ];
}

class EventosProveedor extends Table {
  TextColumn get tenantId => text().references(Tenants, #id)();
  TextColumn get id => text()();
  TextColumn get facturaId => text()();
  TextColumn get accion => text()();
  TextColumn get motivo => text()();
  TextColumn get actor => text()();
  TextColumn get detalleJson => text()();
  DateTimeColumn get fecha => dateTime()();
  @override
  Set<Column> get primaryKey => {tenantId, id};
  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (tenant_id, factura_id) REFERENCES facturas_recibidas (tenant_id,id)',
    'CHECK (length(trim(motivo)) > 0 AND length(trim(actor)) > 0)',
  ];
}

class ReversionesPagosProveedor extends Table {
  TextColumn get tenantId => text().references(Tenants, #id)();
  TextColumn get pagoId => text()();
  TextColumn get motivo => text()();
  TextColumn get actor => text()();
  DateTimeColumn get fecha => dateTime()();
  @override
  Set<Column> get primaryKey => {tenantId, pagoId};
  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (tenant_id, pago_id) REFERENCES pagos_proveedor (tenant_id,id)',
    'CHECK (length(trim(motivo)) > 0 AND length(trim(actor)) > 0)',
  ];
}

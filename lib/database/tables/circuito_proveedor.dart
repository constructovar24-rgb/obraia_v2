// ignore_for_file: unused_import
import 'package:drift/drift.dart';
import 'compras.dart';
import 'documentos.dart';
import 'expedientes.dart';
import 'proveedores.dart';
import 'tenants.dart';

class AlbaranesProveedor extends Table {
  TextColumn get tenantId => text().references(Tenants, #id)();
  TextColumn get id => text()();
  TextColumn get proveedorId => text()();
  TextColumn get referenciaProveedor => text()();
  DateTimeColumn get fecha => dateTime()();
  TextColumn get estado => text().withDefault(const Constant('recibido'))();
  TextColumn get observaciones => text().nullable()();
  TextColumn get documentoId => text().nullable()();
  DateTimeColumn get fechaCreacion => dateTime()();
  DateTimeColumn get fechaModificacion => dateTime()();
  @override
  Set<Column> get primaryKey => {tenantId, id};
  @override
  List<Set<Column>> get uniqueKeys => [
    {tenantId, proveedorId, referenciaProveedor},
  ];
  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (tenant_id, proveedor_id) REFERENCES proveedores (tenant_id,id)',
    'FOREIGN KEY (tenant_id, documento_id) REFERENCES documentos (tenant_id,id)',
    "CHECK (estado IN ('recibido','revisado','facturado','cancelado'))",
  ];
}

class LineasAlbaranProveedor extends Table {
  TextColumn get tenantId => text().references(Tenants, #id)();
  TextColumn get id => text()();
  TextColumn get albaranId => text()();
  TextColumn get descripcionOriginal => text()();
  RealColumn get cantidad => real()();
  TextColumn get unidad => text().nullable()();
  IntColumn get precioUnitarioCentimos => integer().nullable()();
  IntColumn get importeCentimos => integer().nullable()();
  TextColumn get observaciones => text().nullable()();
  @override
  Set<Column> get primaryKey => {tenantId, id};
  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (tenant_id, albaran_id) REFERENCES albaranes_proveedor (tenant_id,id) ON DELETE CASCADE',
    'CHECK (cantidad > 0)',
  ];
}

class AsignacionesAlbaranObra extends Table {
  TextColumn get tenantId => text().references(Tenants, #id)();
  TextColumn get id => text()();
  TextColumn get lineaAlbaranId => text()();
  TextColumn get expedienteId => text().nullable()();
  IntColumn get importeCentimos => integer().nullable()();
  @override
  Set<Column> get primaryKey => {tenantId, id};
  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (tenant_id, linea_albaran_id) REFERENCES lineas_albaran_proveedor (tenant_id,id) ON DELETE CASCADE',
    'FOREIGN KEY (tenant_id, expediente_id) REFERENCES expedientes (tenant_id,id)',
    'CHECK (importe_centimos IS NULL OR importe_centimos >= 0)',
  ];
}

class FacturasRecibidas extends Table {
  TextColumn get tenantId => text().references(Tenants, #id)();
  TextColumn get id => text()();
  TextColumn get proveedorId => text()();
  TextColumn get numeroNormalizado => text()();
  TextColumn get numeroProveedor => text()();
  DateTimeColumn get fechaFactura => dateTime()();
  DateTimeColumn get fechaVencimiento => dateTime().nullable()();
  IntColumn get baseCentimos => integer()();
  IntColumn get ivaCentimos => integer()();
  IntColumn get totalCentimos => integer()();
  TextColumn get estado => text().withDefault(const Constant('pendiente'))();
  TextColumn get documentoId => text().nullable()();
  DateTimeColumn get fechaCreacion => dateTime()();
  DateTimeColumn get fechaModificacion => dateTime()();
  @override
  Set<Column> get primaryKey => {tenantId, id};
  @override
  List<Set<Column>> get uniqueKeys => [
    {tenantId, proveedorId, numeroNormalizado},
  ];
  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (tenant_id, proveedor_id) REFERENCES proveedores (tenant_id,id)',
    'FOREIGN KEY (tenant_id, documento_id) REFERENCES documentos (tenant_id,id)',
    "CHECK (estado IN ('pendiente','parcialmentePagada','pagada','cancelada'))",
    'CHECK (base_centimos >= 0 AND iva_centimos >= 0 AND total_centimos = base_centimos + iva_centimos)',
  ];
}

class FacturaRecibidaAlbaranes extends Table {
  TextColumn get tenantId => text().references(Tenants, #id)();
  TextColumn get facturaId => text()();
  TextColumn get albaranId => text()();
  @override
  Set<Column> get primaryKey => {tenantId, facturaId, albaranId};
  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (tenant_id, factura_id) REFERENCES facturas_recibidas (tenant_id,id) ON DELETE CASCADE',
    'FOREIGN KEY (tenant_id, albaran_id) REFERENCES albaranes_proveedor (tenant_id,id)',
  ];
}

class AsignacionesFacturaRecibida extends Table {
  TextColumn get tenantId => text().references(Tenants, #id)();
  TextColumn get id => text()();
  TextColumn get facturaId => text()();
  TextColumn get expedienteId => text().nullable()();
  IntColumn get baseCentimos => integer()();
  IntColumn get ivaNoRecuperableCentimos =>
      integer().withDefault(const Constant(0))();
  @override
  Set<Column> get primaryKey => {tenantId, id};
  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (tenant_id, factura_id) REFERENCES facturas_recibidas (tenant_id,id) ON DELETE CASCADE',
    'FOREIGN KEY (tenant_id, expediente_id) REFERENCES expedientes (tenant_id,id)',
    'CHECK (base_centimos >= 0 AND iva_no_recuperable_centimos >= 0)',
  ];
}

class FacturaRecibidaCompras extends Table {
  TextColumn get tenantId => text().references(Tenants, #id)();
  TextColumn get facturaId => text()();
  TextColumn get asignacionId => text()();
  TextColumn get compraId => text()();
  @override
  Set<Column> get primaryKey => {tenantId, facturaId, asignacionId};
  @override
  List<Set<Column>> get uniqueKeys => [
    {tenantId, compraId},
  ];
  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (tenant_id, factura_id) REFERENCES facturas_recibidas (tenant_id,id)',
    'FOREIGN KEY (tenant_id, asignacion_id) REFERENCES asignaciones_factura_recibida (tenant_id,id)',
    'FOREIGN KEY (tenant_id, compra_id) REFERENCES compras (tenant_id,id)',
  ];
}

class PagosProveedor extends Table {
  TextColumn get tenantId => text().references(Tenants, #id)();
  TextColumn get id => text()();
  TextColumn get facturaId => text()();
  DateTimeColumn get fecha => dateTime()();
  IntColumn get importeCentimos => integer()();
  TextColumn get metodo => text().nullable()();
  TextColumn get referencia => text().nullable()();
  TextColumn get observaciones => text().nullable()();
  DateTimeColumn get fechaCreacion => dateTime()();
  @override
  Set<Column> get primaryKey => {tenantId, id};
  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (tenant_id, factura_id) REFERENCES facturas_recibidas (tenant_id,id)',
    'CHECK (importe_centimos > 0)',
  ];
}

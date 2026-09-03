// ignore_for_file: unused_import

import 'package:drift/drift.dart';

import 'facturas.dart';
import 'tenants.dart';

class FacturaDocumentosEmitidos extends Table {
  TextColumn get tenantId => text()
      .clientDefault(() => defaultTenantIdForTesting)
      .references(Tenants, #id)();
  TextColumn get facturaId => text()();
  BlobColumn get pdf => blob()();
  TextColumn get sha256 => text()();
  DateTimeColumn get fechaCreacion =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {tenantId, facturaId};

  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (tenant_id, factura_id) REFERENCES facturas (tenant_id, id)',
  ];
}

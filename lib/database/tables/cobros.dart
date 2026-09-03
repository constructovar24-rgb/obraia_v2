// ignore_for_file: unused_import

import 'package:drift/drift.dart';

import 'facturas.dart';
import 'tenants.dart';

class Cobros extends Table {
  TextColumn get tenantId => text()
      .clientDefault(() => defaultTenantIdForTesting)
      .references(Tenants, #id)();

  TextColumn get id => text()();

  TextColumn get facturaId => text()();

  DateTimeColumn get fecha => dateTime().withDefault(currentDateAndTime)();

  RealColumn get importe => real().withDefault(const Constant(0))();

  TextColumn get metodoPago =>
      text().withDefault(const Constant('Transferencia'))();

  TextColumn get referencia => text().withDefault(const Constant(''))();

  TextColumn get observaciones => text().withDefault(const Constant(''))();

  TextColumn get tipoMovimiento =>
      text().withDefault(const Constant('cobro'))();

  TextColumn get cobroOrigenId => text().nullable()();

  TextColumn get motivo => text().withDefault(const Constant(''))();

  DateTimeColumn get fechaCreacion =>
      dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get fechaModificacion =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {tenantId, id},
  ];

  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (tenant_id, factura_id) REFERENCES facturas (tenant_id, id)',
    'FOREIGN KEY (tenant_id, cobro_origen_id) REFERENCES cobros (tenant_id, id)',
  ];
}

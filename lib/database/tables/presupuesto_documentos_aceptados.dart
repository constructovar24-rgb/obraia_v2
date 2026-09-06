// ignore_for_file: unused_import

import 'presupuestos.dart';
import 'package:drift/drift.dart';
import 'tenants.dart';

class PresupuestoDocumentosAceptados extends Table {
  TextColumn get tenantId => text().references(Tenants, #id)();
  TextColumn get presupuestoId => text()();
  TextColumn get snapshotJson => text()();
  BlobColumn get pdf => blob()();
  TextColumn get sha256 => text()();
  DateTimeColumn get fechaCongelacion => dateTime()();

  @override
  Set<Column> get primaryKey => {tenantId, presupuestoId};

  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (tenant_id, presupuesto_id) REFERENCES presupuestos (tenant_id, id)',
    'CHECK (length(pdf) > 0 AND length(sha256) = 64)',
  ];
}

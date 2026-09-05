// ignore_for_file: unused_import

import 'package:drift/drift.dart';

import 'compromisos_economicos.dart';
import 'hechos_coste.dart';
import 'tenants.dart';

class AplicacionesCompromisoCoste extends Table {
  TextColumn get tenantId => text().references(Tenants, #id)();
  TextColumn get id => text()();
  TextColumn get compromisoId => text()();
  TextColumn get hechoCosteId => text()();
  IntColumn get importeAplicadoCentimos => integer()();
  DateTimeColumn get fechaCreacion => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
  @override
  List<Set<Column>> get uniqueKeys => [
    {tenantId, id},
  ];
  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (tenant_id, compromiso_id) REFERENCES compromisos_economicos (tenant_id, id)',
    'FOREIGN KEY (tenant_id, hecho_coste_id) REFERENCES hechos_coste (tenant_id, id)',
    'CHECK (importe_aplicado_centimos > 0)',
  ];
}

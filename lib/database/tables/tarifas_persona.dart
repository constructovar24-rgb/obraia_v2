// ignore_for_file: unused_import

import 'package:drift/drift.dart';

import 'personas_laborales.dart';
import 'tenants.dart';

class TarifasPersona extends Table {
  TextColumn get tenantId => text().references(Tenants, #id)();
  TextColumn get id => text()();
  TextColumn get personaId => text()();
  IntColumn get importeHoraCentimos => integer()();
  DateTimeColumn get vigenteDesde => dateTime()();
  DateTimeColumn get vigenteHasta => dateTime().nullable()();
  TextColumn get nota => text().nullable()();
  DateTimeColumn get fechaCreacion => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
  @override
  List<Set<Column>> get uniqueKeys => [
    {tenantId, id},
    {tenantId, personaId, vigenteDesde},
  ];
  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (tenant_id, persona_id) REFERENCES personas_laborales (tenant_id, id)',
    'CHECK (importe_hora_centimos >= 0)',
    'CHECK (vigente_hasta IS NULL OR vigente_hasta >= vigente_desde)',
  ];
}

// ignore_for_file: unused_import

import 'package:drift/drift.dart';

import 'categorias_economicas.dart';
import 'expedientes.dart';
import 'plan_economico_partidas.dart';
import 'planes_economicos.dart';
import 'tenants.dart';

class EstimacionesCosteRestante extends Table {
  TextColumn get tenantId => text().references(Tenants, #id)();
  TextColumn get id => text()();
  TextColumn get serieId => text()();
  IntColumn get version => integer()();
  TextColumn get expedienteId => text()();
  TextColumn get categoriaEconomicaId => text().nullable()();
  TextColumn get planEconomicoId => text().nullable()();
  TextColumn get planEconomicoPartidaId => text().nullable()();
  IntColumn get importeAdicionalCentimos => integer()();
  TextColumn get justificacion => text()();
  DateTimeColumn get fechaEstimacion => dateTime()();
  DateTimeColumn get fechaCreacion => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
  @override
  List<Set<Column>> get uniqueKeys => [
    {tenantId, id},
    {tenantId, serieId, version},
  ];
  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (tenant_id, expediente_id) REFERENCES expedientes (tenant_id, id)',
    'FOREIGN KEY (tenant_id, categoria_economica_id) REFERENCES categorias_economicas (tenant_id, id)',
    'FOREIGN KEY (tenant_id, plan_economico_id) REFERENCES planes_economicos (tenant_id, id)',
    'FOREIGN KEY (tenant_id, plan_economico_id, plan_economico_partida_id) REFERENCES plan_economico_partidas (tenant_id, plan_economico_id, id)',
    'CHECK (version > 0)',
    'CHECK (importe_adicional_centimos >= 0)',
    'CHECK ((plan_economico_id IS NULL AND plan_economico_partida_id IS NULL) OR (plan_economico_id IS NOT NULL AND plan_economico_partida_id IS NOT NULL))',
  ];
}

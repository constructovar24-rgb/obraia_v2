// ignore_for_file: unused_import

import 'package:drift/drift.dart';

import 'categorias_economicas.dart';
import 'expedientes.dart';
import 'hechos_coste.dart';
import 'personas_laborales.dart';
import 'plan_economico_partidas.dart';
import 'planes_economicos.dart';
import 'tarifas_persona.dart';
import 'tenants.dart';

class PartesTrabajo extends Table {
  TextColumn get tenantId => text().references(Tenants, #id)();
  TextColumn get id => text()();
  TextColumn get expedienteId => text()();
  TextColumn get personaId => text()();
  DateTimeColumn get fechaTrabajo => dateTime()();
  IntColumn get horasDiezMilesimas => integer()();
  TextColumn get descripcionTrabajo => text()();
  TextColumn get categoriaEconomicaId => text()();
  TextColumn get planEconomicoId => text().nullable()();
  TextColumn get planEconomicoPartidaId => text().nullable()();
  TextColumn get tarifaOrigenId => text().nullable()();
  IntColumn get tarifaHoraSnapshotCentimos => integer().nullable()();
  IntColumn get costeSnapshotCentimos => integer().nullable()();
  TextColumn get estado => text()();
  TextColumn get hechoCosteId => text().nullable()();
  DateTimeColumn get fechaCreacion => dateTime()();
  DateTimeColumn get fechaModificacion => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
  @override
  List<Set<Column>> get uniqueKeys => [
    {tenantId, id},
    {tenantId, hechoCosteId},
  ];
  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (tenant_id, expediente_id) REFERENCES expedientes (tenant_id, id)',
    'FOREIGN KEY (tenant_id, persona_id) REFERENCES personas_laborales (tenant_id, id)',
    'FOREIGN KEY (tenant_id, categoria_economica_id) REFERENCES categorias_economicas (tenant_id, id)',
    'FOREIGN KEY (tenant_id, plan_economico_id) REFERENCES planes_economicos (tenant_id, id)',
    'FOREIGN KEY (tenant_id, plan_economico_id, plan_economico_partida_id) REFERENCES plan_economico_partidas (tenant_id, plan_economico_id, id)',
    'FOREIGN KEY (tenant_id, tarifa_origen_id) REFERENCES tarifas_persona (tenant_id, id)',
    'FOREIGN KEY (tenant_id, hecho_coste_id) REFERENCES hechos_coste (tenant_id, id)',
    "CHECK (estado IN ('pendienteValoracion', 'valorado', 'revertido'))",
    'CHECK (horas_diez_milesimas > 0)',
    'CHECK ((plan_economico_id IS NULL AND plan_economico_partida_id IS NULL) OR (plan_economico_id IS NOT NULL AND plan_economico_partida_id IS NOT NULL))',
    "CHECK ((estado = 'pendienteValoracion' AND tarifa_origen_id IS NULL AND tarifa_hora_snapshot_centimos IS NULL AND coste_snapshot_centimos IS NULL AND hecho_coste_id IS NULL) OR (estado != 'pendienteValoracion' AND tarifa_origen_id IS NOT NULL AND tarifa_hora_snapshot_centimos IS NOT NULL AND coste_snapshot_centimos IS NOT NULL AND hecho_coste_id IS NOT NULL))",
  ];
}

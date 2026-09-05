// ignore_for_file: unused_import

import 'package:drift/drift.dart';

import 'categorias_economicas.dart';
import 'expedientes.dart';
import 'plan_economico_partidas.dart';
import 'planes_economicos.dart';
import 'tenants.dart';

class CompromisosEconomicos extends Table {
  TextColumn get tenantId => text().references(Tenants, #id)();
  TextColumn get id => text()();
  TextColumn get expedienteId => text()();
  TextColumn get categoriaEconomicaId => text().nullable()();
  TextColumn get planEconomicoId => text().nullable()();
  TextColumn get planEconomicoPartidaId => text().nullable()();
  TextColumn get descripcion => text()();
  TextColumn get origenTipo => text()();
  TextColumn get origenId => text().nullable()();
  IntColumn get importeComprometidoCentimos => integer()();
  TextColumn get estado => text()();
  TextColumn get motivoUltimoCambio => text().nullable()();
  DateTimeColumn get fechaCompromiso => dateTime()();
  DateTimeColumn get fechaCreacion => dateTime()();
  DateTimeColumn get fechaModificacion => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
  @override
  List<Set<Column>> get uniqueKeys => [
    {tenantId, id},
  ];
  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (tenant_id, expediente_id) REFERENCES expedientes (tenant_id, id)',
    'FOREIGN KEY (tenant_id, categoria_economica_id) REFERENCES categorias_economicas (tenant_id, id)',
    'FOREIGN KEY (tenant_id, plan_economico_id) REFERENCES planes_economicos (tenant_id, id)',
    'FOREIGN KEY (tenant_id, plan_economico_id, plan_economico_partida_id) REFERENCES plan_economico_partidas (tenant_id, plan_economico_id, id)',
    "CHECK (estado IN ('activo', 'cumplido', 'cancelado'))",
    "CHECK (origen_tipo IN ('pedido', 'contrato', 'subcontrata', 'compra', 'otro'))",
    'CHECK (importe_comprometido_centimos >= 0)',
    'CHECK ((plan_economico_id IS NULL AND plan_economico_partida_id IS NULL) OR (plan_economico_id IS NOT NULL AND plan_economico_partida_id IS NOT NULL))',
  ];
}

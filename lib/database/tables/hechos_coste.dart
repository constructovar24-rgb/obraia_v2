// ignore_for_file: unused_import

import 'package:drift/drift.dart';

import 'categorias_economicas.dart';
import 'expedientes.dart';
import 'plan_economico_partidas.dart';
import 'planes_economicos.dart';
import 'tenants.dart';

class HechosCoste extends Table {
  TextColumn get tenantId => text().references(Tenants, #id)();
  TextColumn get id => text()();
  TextColumn get expedienteId => text()();
  TextColumn get categoriaEconomicaId => text().nullable()();
  TextColumn get planEconomicoId => text().nullable()();
  TextColumn get planEconomicoPartidaId => text().nullable()();
  DateTimeColumn get fechaDevengo => dateTime()();
  IntColumn get importeNetoCentimos => integer()();
  IntColumn get ivaNoRecuperableCentimos => integer()();
  IntColumn get importeCosteCentimos => integer()();
  TextColumn get descripcion => text()();
  TextColumn get origenTipo => text()();
  TextColumn get origenId => text()();
  TextColumn get tipoMovimiento => text()();
  TextColumn get hechoRevertidoId => text().nullable()();
  TextColumn get claveIdempotencia => text()();
  DateTimeColumn get fechaCreacion => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {tenantId, id},
    {tenantId, claveIdempotencia},
  ];

  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (tenant_id, expediente_id) REFERENCES expedientes (tenant_id, id)',
    'FOREIGN KEY (tenant_id, categoria_economica_id) REFERENCES categorias_economicas (tenant_id, id)',
    'FOREIGN KEY (tenant_id, plan_economico_id) REFERENCES planes_economicos (tenant_id, id)',
    'FOREIGN KEY (tenant_id, plan_economico_partida_id) REFERENCES plan_economico_partidas (tenant_id, id)',
    'FOREIGN KEY (tenant_id, hecho_revertido_id) REFERENCES hechos_coste (tenant_id, id)',
    "CHECK (tipo_movimiento IN ('alta', 'reversion', 'ajuste'))",
    "CHECK (origen_tipo IN ('compra', 'parteTrabajo', 'facturaProveedor', 'maquinaria', 'consumoAlmacen', 'subcontrata', 'ajusteManual'))",
    'CHECK (importe_coste_centimos = importe_neto_centimos + iva_no_recuperable_centimos)',
    "CHECK ((tipo_movimiento = 'reversion' AND hecho_revertido_id IS NOT NULL) OR (tipo_movimiento != 'reversion' AND hecho_revertido_id IS NULL))",
  ];
}

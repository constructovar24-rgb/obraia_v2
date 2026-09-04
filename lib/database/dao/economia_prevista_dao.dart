import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/categorias_economicas.dart';
import '../tables/configuracion_economica.dart';
import '../tables/linea_presupuesto_costes_previstos.dart';
import '../tables/plan_economico_partidas.dart';
import '../tables/planes_economicos.dart';

part 'economia_prevista_dao.g.dart';

@DriftAccessor(
  tables: [
    CategoriasEconomicas,
    ConfiguracionEconomica,
    LineaPresupuestoCostesPrevistos,
    PlanesEconomicos,
    PlanEconomicoPartidas,
  ],
)
class EconomiaPrevistaDao extends DatabaseAccessor<AppDatabase>
    with _$EconomiaPrevistaDaoMixin {
  EconomiaPrevistaDao(super.db);

  String get _tenantId => attachedDatabase.activeTenantId;

  Stream<List<CategoriasEconomica>> observarCategorias({
    bool soloActivas = true,
  }) {
    final query = select(categoriasEconomicas)
      ..where((t) => t.tenantId.equals(_tenantId));
    if (soloActivas) query.where((t) => t.activa.equals(true));
    query.orderBy([(t) => OrderingTerm.asc(t.orden)]);
    return query.watch();
  }

  Future<CategoriasEconomica?> obtenerCategoria(String id) =>
      (select(categoriasEconomicas)
            ..where((t) => t.tenantId.equals(_tenantId) & t.id.equals(id)))
          .getSingleOrNull();

  Future<CategoriasEconomica?> obtenerCategoriaPorCodigo(String codigo) =>
      (select(categoriasEconomicas)..where(
            (t) => t.tenantId.equals(_tenantId) & t.codigo.equals(codigo),
          ))
          .getSingleOrNull();

  Future<void> insertarCategoria(CategoriasEconomicasCompanion value) => into(
    categoriasEconomicas,
  ).insert(value.copyWith(tenantId: Value(_tenantId)));

  Future<ConfiguracionEconomicaData?> obtenerConfiguracion() => (select(
    configuracionEconomica,
  )..where((t) => t.tenantId.equals(_tenantId))).getSingleOrNull();

  Future<void> guardarPorcentajeIndirectos(double? porcentaje) =>
      (update(
        configuracionEconomica,
      )..where((t) => t.tenantId.equals(_tenantId))).write(
        ConfiguracionEconomicaCompanion(
          porcentajeIndirectos: Value(porcentaje),
          fechaModificacion: Value(DateTime.now().toUtc()),
        ),
      );

  Future<LineaPresupuestoCostesPrevisto?> obtenerCosteLinea(String lineaId) =>
      (select(lineaPresupuestoCostesPrevistos)..where(
            (t) =>
                t.tenantId.equals(_tenantId) &
                t.lineaPresupuestoId.equals(lineaId),
          ))
          .getSingleOrNull();

  Stream<LineaPresupuestoCostesPrevisto?> observarCosteLinea(String lineaId) =>
      (select(lineaPresupuestoCostesPrevistos)..where(
            (t) =>
                t.tenantId.equals(_tenantId) &
                t.lineaPresupuestoId.equals(lineaId),
          ))
          .watchSingleOrNull();

  Future<List<LineaPresupuestoCostesPrevisto>> obtenerCostesLineas(
    Iterable<String> lineaIds,
  ) {
    final ids = lineaIds.toList(growable: false);
    if (ids.isEmpty) return Future.value(const []);
    return (select(lineaPresupuestoCostesPrevistos)..where(
          (t) => t.tenantId.equals(_tenantId) & t.lineaPresupuestoId.isIn(ids),
        ))
        .get();
  }

  Future<void> guardarCosteLinea(
    LineaPresupuestoCostesPrevistosCompanion value,
  ) => into(
    lineaPresupuestoCostesPrevistos,
  ).insertOnConflictUpdate(value.copyWith(tenantId: Value(_tenantId)));

  Future<int> eliminarCosteLinea(String lineaId) =>
      (delete(lineaPresupuestoCostesPrevistos)..where(
            (t) =>
                t.tenantId.equals(_tenantId) &
                t.lineaPresupuestoId.equals(lineaId),
          ))
          .go();

  Future<PlanesEconomico?> obtenerPlanPorPresupuesto(String presupuestoId) =>
      (select(planesEconomicos)..where(
            (t) =>
                t.tenantId.equals(_tenantId) &
                t.presupuestoId.equals(presupuestoId),
          ))
          .getSingleOrNull();

  Future<PlanesEconomico?> obtenerPlanPorExpediente(String expedienteId) =>
      (select(planesEconomicos)
            ..where(
              (t) =>
                  t.tenantId.equals(_tenantId) &
                  t.expedienteId.equals(expedienteId),
            )
            ..orderBy([(t) => OrderingTerm.desc(t.fechaAceptacion)])
            ..limit(1))
          .getSingleOrNull();

  Stream<PlanesEconomico?> observarPlanPorPresupuesto(String presupuestoId) =>
      (select(planesEconomicos)..where(
            (t) =>
                t.tenantId.equals(_tenantId) &
                t.presupuestoId.equals(presupuestoId),
          ))
          .watchSingleOrNull();

  Future<List<PlanEconomicoPartida>> obtenerPartidasPlan(String planId) =>
      (select(planEconomicoPartidas)
            ..where(
              (t) =>
                  t.tenantId.equals(_tenantId) &
                  t.planEconomicoId.equals(planId),
            )
            ..orderBy([(t) => OrderingTerm.asc(t.orden)]))
          .get();

  Future<void> insertarPlan(PlanesEconomicosCompanion value) =>
      into(planesEconomicos).insert(value.copyWith(tenantId: Value(_tenantId)));

  Future<void> insertarPartida(PlanEconomicoPartidasCompanion value) => into(
    planEconomicoPartidas,
  ).insert(value.copyWith(tenantId: Value(_tenantId)));
}

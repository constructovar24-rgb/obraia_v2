import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/cierres_economicos_obra.dart';
import '../tables/estados_economicos_obra.dart';
import '../tables/reaperturas_economicas_obra.dart';

part 'cierre_economico_dao.g.dart';

@DriftAccessor(
  tables: [
    EstadosEconomicosObra,
    CierresEconomicosObra,
    ReaperturasEconomicasObra,
  ],
)
class CierreEconomicoDao extends DatabaseAccessor<AppDatabase>
    with _$CierreEconomicoDaoMixin {
  CierreEconomicoDao(super.db);
  String get _tenantId => attachedDatabase.activeTenantId;

  Future<EstadosEconomicosObraData?> obtenerEstado(String expedienteId) =>
      (select(estadosEconomicosObra)..where(
            (t) =>
                t.tenantId.equals(_tenantId) &
                t.expedienteId.equals(expedienteId),
          ))
          .getSingleOrNull();

  Future<void> exigirEconomiaAbierta(String expedienteId) async {
    final estado = await obtenerEstado(expedienteId);
    if (estado?.estado == 'cerrado') {
      throw StateError(
        'La economía de la obra está cerrada. Debe reabrirse antes de modificarla.',
      );
    }
  }

  Stream<EstadosEconomicosObraData?> observarEstado(String expedienteId) =>
      (select(estadosEconomicosObra)..where(
            (t) =>
                t.tenantId.equals(_tenantId) &
                t.expedienteId.equals(expedienteId),
          ))
          .watchSingleOrNull();

  Future<void> guardarEstado(EstadosEconomicosObraCompanion value) => into(
    estadosEconomicosObra,
  ).insertOnConflictUpdate(value.copyWith(tenantId: Value(_tenantId)));

  Future<void> insertarCierre(CierresEconomicosObraCompanion value) => into(
    cierresEconomicosObra,
  ).insert(value.copyWith(tenantId: Value(_tenantId)));

  Future<List<CierresEconomicosObraData>> obtenerCierres(String expedienteId) =>
      (select(cierresEconomicosObra)
            ..where(
              (t) =>
                  t.tenantId.equals(_tenantId) &
                  t.expedienteId.equals(expedienteId),
            )
            ..orderBy([(t) => OrderingTerm.desc(t.numero)]))
          .get();

  Future<CierresEconomicosObraData?> obtenerUltimoCierre(String expedienteId) =>
      (select(cierresEconomicosObra)
            ..where(
              (t) =>
                  t.tenantId.equals(_tenantId) &
                  t.expedienteId.equals(expedienteId),
            )
            ..orderBy([(t) => OrderingTerm.desc(t.numero)])
            ..limit(1))
          .getSingleOrNull();

  Future<void> insertarReapertura(ReaperturasEconomicasObraCompanion value) =>
      into(
        reaperturasEconomicasObra,
      ).insert(value.copyWith(tenantId: Value(_tenantId)));

  Future<List<ReaperturasEconomicasObraData>> obtenerReaperturas(
    String expedienteId,
  ) =>
      (select(reaperturasEconomicasObra)
            ..where(
              (t) =>
                  t.tenantId.equals(_tenantId) &
                  t.expedienteId.equals(expedienteId),
            )
            ..orderBy([(t) => OrderingTerm.desc(t.fechaReapertura)]))
          .get();
}

import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/aplicaciones_compromiso_coste.dart';
import '../tables/compromisos_economicos.dart';
import '../tables/estimaciones_coste_restante.dart';
import '../tables/hechos_coste.dart';

part 'prevision_economica_dao.g.dart';

@DriftAccessor(
  tables: [
    CompromisosEconomicos,
    AplicacionesCompromisoCoste,
    EstimacionesCosteRestante,
    HechosCoste,
  ],
)
class PrevisionEconomicaDao extends DatabaseAccessor<AppDatabase>
    with _$PrevisionEconomicaDaoMixin {
  PrevisionEconomicaDao(super.db);

  String get _tenantId => attachedDatabase.activeTenantId;

  Future<void> insertarCompromiso(CompromisosEconomicosCompanion value) => into(
    compromisosEconomicos,
  ).insert(value.copyWith(tenantId: Value(_tenantId)));

  Future<CompromisosEconomico?> obtenerCompromiso(String id) =>
      (select(compromisosEconomicos)
            ..where((t) => t.tenantId.equals(_tenantId) & t.id.equals(id)))
          .getSingleOrNull();

  Future<List<CompromisosEconomico>> obtenerCompromisos(String expedienteId) =>
      (select(compromisosEconomicos)
            ..where(
              (t) =>
                  t.tenantId.equals(_tenantId) &
                  t.expedienteId.equals(expedienteId),
            )
            ..orderBy([(t) => OrderingTerm.desc(t.fechaCompromiso)]))
          .get();

  Stream<List<CompromisosEconomico>> observarCompromisos(String expedienteId) =>
      (select(compromisosEconomicos)..where(
            (t) =>
                t.tenantId.equals(_tenantId) &
                t.expedienteId.equals(expedienteId),
          ))
          .watch();

  Future<int> actualizarCompromiso(
    String id,
    CompromisosEconomicosCompanion value,
  ) => (update(
    compromisosEconomicos,
  )..where((t) => t.tenantId.equals(_tenantId) & t.id.equals(id))).write(value);

  Future<void> insertarAplicacion(AplicacionesCompromisoCosteCompanion value) =>
      into(
        aplicacionesCompromisoCoste,
      ).insert(value.copyWith(tenantId: Value(_tenantId)));

  Future<List<AplicacionesCompromisoCosteData>> obtenerAplicaciones(
    String compromisoId,
  ) =>
      (select(aplicacionesCompromisoCoste)..where(
            (t) =>
                t.tenantId.equals(_tenantId) &
                t.compromisoId.equals(compromisoId),
          ))
          .get();

  Future<void> insertarEstimacion(EstimacionesCosteRestanteCompanion value) =>
      into(
        estimacionesCosteRestante,
      ).insert(value.copyWith(tenantId: Value(_tenantId)));

  Future<List<EstimacionesCosteRestanteData>> obtenerEstimaciones(
    String expedienteId,
  ) =>
      (select(estimacionesCosteRestante)
            ..where(
              (t) =>
                  t.tenantId.equals(_tenantId) &
                  t.expedienteId.equals(expedienteId),
            )
            ..orderBy([
              (t) => OrderingTerm.asc(t.serieId),
              (t) => OrderingTerm.desc(t.version),
            ]))
          .get();
}

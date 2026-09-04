import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/hechos_coste.dart';

part 'hechos_coste_dao.g.dart';

@DriftAccessor(tables: [HechosCoste])
class HechosCosteDao extends DatabaseAccessor<AppDatabase>
    with _$HechosCosteDaoMixin {
  HechosCosteDao(super.db);

  String get _tenantId => attachedDatabase.activeTenantId;

  Future<void> insertar(HechosCosteCompanion hecho) =>
      into(hechosCoste).insert(hecho.copyWith(tenantId: Value(_tenantId)));

  Future<HechosCosteData?> obtenerAltaCompra(String compraId) =>
      (select(hechosCoste)..where(
            (t) =>
                t.tenantId.equals(_tenantId) &
                t.origenTipo.equals('compra') &
                t.origenId.equals(compraId) &
                t.tipoMovimiento.equals('alta'),
          ))
          .getSingleOrNull();

  Future<List<HechosCosteData>> obtenerPorOrigen(
    String origenTipo,
    String origenId,
  ) =>
      (select(hechosCoste)
            ..where(
              (t) =>
                  t.tenantId.equals(_tenantId) &
                  t.origenTipo.equals(origenTipo) &
                  t.origenId.equals(origenId),
            )
            ..orderBy([(t) => OrderingTerm.asc(t.fechaCreacion)]))
          .get();

  Stream<List<HechosCosteData>> observarPorExpediente(String expedienteId) =>
      (select(hechosCoste)
            ..where(
              (t) =>
                  t.tenantId.equals(_tenantId) &
                  t.expedienteId.equals(expedienteId),
            )
            ..orderBy([(t) => OrderingTerm.desc(t.fechaDevengo)]))
          .watch();

  Future<List<HechosCosteData>> obtenerPorExpediente(String expedienteId) =>
      (select(hechosCoste)..where(
            (t) =>
                t.tenantId.equals(_tenantId) &
                t.expedienteId.equals(expedienteId),
          ))
          .get();
}

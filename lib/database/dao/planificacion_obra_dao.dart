import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/actuaciones_obra.dart';
import '../tables/expedientes.dart';

part 'planificacion_obra_dao.g.dart';

@DriftAccessor(tables: [Expedientes, ActuacionesObra])
class PlanificacionObraDao extends DatabaseAccessor<AppDatabase>
    with _$PlanificacionObraDaoMixin {
  PlanificacionObraDao(super.db);

  Stream<Expediente?> observarPlanificacion(String expedienteId) =>
      (select(expedientes)..where(
            (t) =>
                t.tenantId.equals(attachedDatabase.activeTenantId) &
                t.id.equals(expedienteId),
          ))
          .watchSingleOrNull();

  Future<Expediente?> obtenerPlanificacion(String expedienteId) =>
      (select(expedientes)..where(
            (t) =>
                t.tenantId.equals(attachedDatabase.activeTenantId) &
                t.id.equals(expedienteId),
          ))
          .getSingleOrNull();

  Future<int> actualizarPlanificacion(
    String expedienteId,
    ExpedientesCompanion values,
  ) =>
      (update(expedientes)..where(
            (t) =>
                t.tenantId.equals(attachedDatabase.activeTenantId) &
                t.id.equals(expedienteId),
          ))
          .write(values);

  Stream<List<ActuacionesObraData>> observarActuaciones(String expedienteId) =>
      (select(actuacionesObra)
            ..where(
              (t) =>
                  t.tenantId.equals(attachedDatabase.activeTenantId) &
                  t.expedienteId.equals(expedienteId),
            )
            ..orderBy([
              (t) => OrderingTerm.asc(t.orden),
              (t) => OrderingTerm.asc(t.fechaPrevista),
              (t) => OrderingTerm.asc(t.fechaCreacion),
            ]))
          .watch();

  Future<List<ActuacionesObraData>> obtenerActuaciones(String expedienteId) =>
      (select(actuacionesObra)..where(
            (t) =>
                t.tenantId.equals(attachedDatabase.activeTenantId) &
                t.expedienteId.equals(expedienteId),
          ))
          .get();

  Future<void> insertarActuacion(ActuacionesObraCompanion value) => into(
    actuacionesObra,
  ).insert(value.copyWith(tenantId: Value(attachedDatabase.activeTenantId)));

  Future<int> actualizarActuacion(String id, ActuacionesObraCompanion value) =>
      (update(actuacionesObra)..where(
            (t) =>
                t.tenantId.equals(attachedDatabase.activeTenantId) &
                t.id.equals(id),
          ))
          .write(value);
}

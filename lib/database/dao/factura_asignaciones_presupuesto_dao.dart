import 'package:drift/drift.dart';

import '../../features/facturas/domain/factura_asignacion_presupuesto.dart'
    as domain;
import '../app_database.dart';
import '../tables/factura_asignaciones_presupuesto.dart';

part 'factura_asignaciones_presupuesto_dao.g.dart';

@DriftAccessor(tables: [FacturaAsignacionesPresupuesto])
class FacturaAsignacionesPresupuestoDao extends DatabaseAccessor<AppDatabase>
    with _$FacturaAsignacionesPresupuestoDaoMixin {
  FacturaAsignacionesPresupuestoDao(super.db);

  domain.FacturaAsignacionPresupuesto _toDomain(
    FacturaAsignacionesPresupuestoData row,
  ) => domain.FacturaAsignacionPresupuesto(
    id: row.id,
    facturaId: row.facturaId,
    facturaLineaId: row.facturaLineaId,
    presupuestoId: row.presupuestoId,
    lineaPresupuestoId: row.lineaPresupuestoId,
    cantidadAplicada: row.cantidadAplicada,
    baseAplicada: row.baseAplicada,
    certificacionOrigenId: row.certificacionOrigenId,
  );

  Future<void> insertar(FacturaAsignacionesPresupuestoCompanion value) => into(
    facturaAsignacionesPresupuesto,
  ).insert(value.copyWith(tenantId: Value(attachedDatabase.activeTenantId)));

  Future<List<domain.FacturaAsignacionPresupuesto>> obtenerPorPresupuesto(
    String presupuestoId,
  ) async =>
      (await (select(facturaAsignacionesPresupuesto)..where(
                (t) =>
                    t.tenantId.equals(attachedDatabase.activeTenantId) &
                    t.presupuestoId.equals(presupuestoId),
              ))
              .get())
          .map(_toDomain)
          .toList();

  Stream<List<domain.FacturaAsignacionPresupuesto>> observarPorPresupuesto(
    String presupuestoId,
  ) =>
      (select(facturaAsignacionesPresupuesto)..where(
            (t) =>
                t.tenantId.equals(attachedDatabase.activeTenantId) &
                t.presupuestoId.equals(presupuestoId),
          ))
          .watch()
          .map((rows) => rows.map(_toDomain).toList());

  Stream<List<domain.FacturaAsignacionPresupuesto>> observarTodas() =>
      (select(facturaAsignacionesPresupuesto)
            ..where((t) => t.tenantId.equals(attachedDatabase.activeTenantId)))
          .watch()
          .map((rows) => rows.map(_toDomain).toList());

  Future<void> eliminarPorFactura(String facturaId) =>
      (delete(facturaAsignacionesPresupuesto)..where(
            (t) =>
                t.tenantId.equals(attachedDatabase.activeTenantId) &
                t.facturaId.equals(facturaId),
          ))
          .go();

  Future<bool> existePorFactura(String facturaId) async =>
      await (select(facturaAsignacionesPresupuesto)
            ..where(
              (t) =>
                  t.tenantId.equals(attachedDatabase.activeTenantId) &
                  t.facturaId.equals(facturaId),
            )
            ..limit(1))
          .getSingleOrNull() !=
      null;

  Future<bool> existePorLineaPresupuesto(String lineaId) async =>
      await (select(facturaAsignacionesPresupuesto)
            ..where(
              (t) =>
                  t.tenantId.equals(attachedDatabase.activeTenantId) &
                  t.lineaPresupuestoId.equals(lineaId),
            )
            ..limit(1))
          .getSingleOrNull() !=
      null;
}

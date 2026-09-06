import 'package:drift/drift.dart';

import '../../features/presupuestos/domain/linea_presupuesto.dart'
    as linea_domain;
import '../app_database.dart';
import '../tables/lineas_presupuesto.dart';
import '../../features/presupuestos/domain/estado_presupuesto.dart';

part 'lineas_presupuesto_dao.g.dart';

@DriftAccessor(tables: [LineasPresupuesto])
class LineasPresupuestoDao extends DatabaseAccessor<AppDatabase>
    with _$LineasPresupuestoDaoMixin {
  LineasPresupuestoDao(super.db);

  Future<List<linea_domain.LineaPresupuesto>> obtenerPorPresupuesto(
    String presupuestoId,
  ) async {
    final rows =
        await (select(lineasPresupuesto)..where(
              (t) =>
                  t.tenantId.equals(attachedDatabase.activeTenantId) &
                  t.presupuestoId.equals(presupuestoId),
            ))
            .get();

    return rows
        .map(
          (row) => linea_domain.LineaPresupuesto(
            id: row.id,
            presupuestoId: row.presupuestoId,
            concepto: row.concepto,
            cantidad: row.cantidad,
            unidad: row.unidad,
            precioUnitario: row.precioUnitario,
          ),
        )
        .toList();
  }

  Stream<List<linea_domain.LineaPresupuesto>> observarPorPresupuesto(
    String presupuestoId,
  ) {
    return (select(lineasPresupuesto)..where(
          (t) =>
              t.tenantId.equals(attachedDatabase.activeTenantId) &
              t.presupuestoId.equals(presupuestoId),
        ))
        .watch()
        .map(
          (rows) => rows
              .map(
                (row) => linea_domain.LineaPresupuesto(
                  id: row.id,
                  presupuestoId: row.presupuestoId,
                  concepto: row.concepto,
                  cantidad: row.cantidad,
                  unidad: row.unidad,
                  precioUnitario: row.precioUnitario,
                ),
              )
              .toList(),
        );
  }

  Future<void> insertarLinea(LineasPresupuestoCompanion linea) async {
    await attachedDatabase.presupuestosDao.exigirEditable(
      linea.presupuestoId.value,
    );
    await into(
      lineasPresupuesto,
    ).insert(linea.copyWith(tenantId: Value(attachedDatabase.activeTenantId)));
  }

  Future<LineasPresupuestoData?> obtenerPorId(String id) =>
      (select(lineasPresupuesto)..where(
            (t) =>
                t.tenantId.equals(attachedDatabase.activeTenantId) &
                t.id.equals(id),
          ))
          .getSingleOrNull();

  Future<void> exigirEditable(String id) async {
    final linea = await obtenerPorId(id);
    if (linea == null) {
      throw const EstadoPresupuestoException('La partida no está disponible.');
    }
    await attachedDatabase.presupuestosDao.exigirEditable(linea.presupuestoId);
  }

  Future<void> actualizarLinea(
    String id,
    LineasPresupuestoCompanion linea,
  ) async {
    await exigirEditable(id);
    if (linea.presupuestoId.present) {
      await attachedDatabase.presupuestosDao.exigirEditable(
        linea.presupuestoId.value,
      );
    }
    await (update(lineasPresupuesto)..where(
          (t) =>
              t.tenantId.equals(attachedDatabase.activeTenantId) &
              t.id.equals(id),
        ))
        .write(linea);
  }

  Future<void> eliminarLinea(String id) async {
    await exigirEditable(id);
    await (delete(lineasPresupuesto)..where(
          (t) =>
              t.tenantId.equals(attachedDatabase.activeTenantId) &
              t.id.equals(id),
        ))
        .go();
  }
}

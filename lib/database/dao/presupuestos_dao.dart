import 'package:drift/drift.dart';

import '../../features/presupuestos/domain/presupuesto.dart' as presupuesto_domain;
import '../app_database.dart';
import '../tables/presupuestos.dart';

part 'presupuestos_dao.g.dart';

@DriftAccessor(tables: [Presupuestos])
class PresupuestosDao extends DatabaseAccessor<AppDatabase>
    with _$PresupuestosDaoMixin {
  PresupuestosDao(super.db);

  Future<List<String>> obtenerCodigosPorExpediente(String expedienteId) async {
    final table = attachedDatabase.presupuestos;

    final rows = await (select(table)
          ..where((t) => t.expedienteId.equals(expedienteId)))
        .get();

    return rows.map((row) => row.codigo).toList();
  }

  Stream<List<presupuesto_domain.Presupuesto>> observarPorExpediente(
    String expedienteId,
  ) {
    final table = attachedDatabase.presupuestos;

    return (select(table)
          ..where(
            (t) => t.expedienteId.equals(expedienteId) & t.eliminado.equals(false),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.fecha)]))
        .watch()
        .map(
          (rows) => rows
              .map(
                (row) => presupuesto_domain.Presupuesto(
                  id: row.id,
                  expedienteId: row.expedienteId,
                  codigo: row.codigo,
                  fecha: row.fecha,
                  descripcion: row.descripcion,
                  importeTotal: row.importeTotal,
                  ivaPorcentaje: row.ivaPorcentaje,
                  estado: row.estado,
                  eliminado: row.eliminado,
                  fechaCreacion: row.fechaCreacion,
                  fechaModificacion: row.fechaModificacion,
                ),
              )
              .toList(),
        );
  }

  Stream<List<presupuesto_domain.Presupuesto>> observarPresupuestos() {
    final table = attachedDatabase.presupuestos;

    return (select(table)
          ..where((t) => t.eliminado.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.fecha)]))
        .watch()
        .map(
          (rows) => rows
              .map(
                (row) => presupuesto_domain.Presupuesto(
                  id: row.id,
                  expedienteId: row.expedienteId,
                  codigo: row.codigo,
                  fecha: row.fecha,
                  descripcion: row.descripcion,
                  importeTotal: row.importeTotal,
                  ivaPorcentaje: row.ivaPorcentaje,
                  estado: row.estado,
                  eliminado: row.eliminado,
                  fechaCreacion: row.fechaCreacion,
                  fechaModificacion: row.fechaModificacion,
                ),
              )
              .toList(),
        );
  }

  Future<void> insertarPresupuesto(PresupuestosCompanion presupuesto) async {
    await into(presupuestos).insert(presupuesto);
  }

  Future<void> actualizarImporteTotal(
    String presupuestoId,
    double importeTotal,
  ) async {
    await (update(presupuestos)
          ..where((t) => t.id.equals(presupuestoId)))
        .write(
      PresupuestosCompanion(
        importeTotal: Value(importeTotal),
        fechaModificacion: Value(DateTime.now()),
      ),
    );
  }

  Future<void> actualizarIvaPorcentaje(
    String presupuestoId,
    double ivaPorcentaje,
  ) async {
    await (update(presupuestos)
          ..where((t) => t.id.equals(presupuestoId)))
        .write(
      PresupuestosCompanion(
        ivaPorcentaje: Value(ivaPorcentaje),
        fechaModificacion: Value(DateTime.now()),
      ),
    );
  }

  Future<void> eliminarLogicamente(String id) async {
    await (update(presupuestos)
          ..where((t) => t.id.equals(id)))
        .write(
      const PresupuestosCompanion(
        eliminado: Value(true),
      ),
    );
  }

  Future<bool> tieneFacturaAsociada(String presupuestoId) async {
    final tableFacturas = attachedDatabase.facturas;

    final factura = await (select(tableFacturas)
          ..where((t) => t.presupuestoOrigenId.equals(presupuestoId))
          ..limit(1))
        .getSingleOrNull();

    return factura != null;
  }
}

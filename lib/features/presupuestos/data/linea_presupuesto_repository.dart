import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/features/presupuestos/domain/linea_presupuesto.dart'
    as linea_domain;
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class LineaPresupuestoRepository {
  final AppDatabase database;

  LineaPresupuestoRepository(this.database);

  Future<void> _validarLineaSinHistorialFacturado(String lineaId) async {
    if (await database.facturaAsignacionesPresupuestoDao
        .existePorLineaPresupuesto(lineaId)) {
      throw StateError(
        'La partida ya tiene historial de facturación y no puede modificarse.',
      );
    }
  }

  /// Recalculates and persists the header total in the transaction that
  /// changes a line. This keeps a budget and its lines consistent if either
  /// write fails.
  Future<void> _recalcularImporteTotal(String presupuestoId) async {
    final lineas = await database.lineasPresupuestoDao.obtenerPorPresupuesto(
      presupuestoId,
    );

    final importeTotal = lineas.fold<double>(
      0,
      (sum, linea) => sum + linea.importe,
    );

    await database.presupuestosDao.actualizarImporteTotal(
      presupuestoId,
      importeTotal,
    );
  }

  Future<void> crearLinea({
    required String presupuestoId,
    required String concepto,
    required double cantidad,
    String unidad = 'ud',
    required double precioUnitario,
  }) async {
    await database.transaction(() async {
      await database.lineasPresupuestoDao.insertarLinea(
        LineasPresupuestoCompanion.insert(
          id: const Uuid().v4(),
          presupuestoId: presupuestoId,
          concepto: concepto,
          cantidad: cantidad,
          unidad: Value(unidad),
          precioUnitario: precioUnitario,
        ),
      );

      await _recalcularImporteTotal(presupuestoId);
    });
  }

  Future<void> actualizarLinea({
    required String id,
    required String presupuestoId,
    required String concepto,
    required double cantidad,
    String unidad = 'ud',
    required double precioUnitario,
  }) async {
    await database.transaction(() async {
      await _validarLineaSinHistorialFacturado(id);
      await database.lineasPresupuestoDao.actualizarLinea(
        id,
        LineasPresupuestoCompanion(
          concepto: Value(concepto),
          cantidad: Value(cantidad),
          unidad: Value(unidad),
          precioUnitario: Value(precioUnitario),
        ),
      );

      await _recalcularImporteTotal(presupuestoId);
    });
  }

  Future<void> eliminarLinea(String id, String presupuestoId) async {
    await database.transaction(() async {
      await _validarLineaSinHistorialFacturado(id);
      await database.lineasPresupuestoDao.eliminarLinea(id);
      await _recalcularImporteTotal(presupuestoId);
    });
  }

  Stream<List<linea_domain.LineaPresupuesto>> observarPorPresupuesto(
    String presupuestoId,
  ) {
    return database.lineasPresupuestoDao.observarPorPresupuesto(presupuestoId);
  }
}

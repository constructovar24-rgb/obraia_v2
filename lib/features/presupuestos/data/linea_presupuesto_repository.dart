import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/database/database_provider.dart';
import 'package:obraia_v2/features/presupuestos/domain/linea_presupuesto.dart'
    as linea_domain;
import 'package:obraia_v2/features/presupuestos/data/presupuesto_repository.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

final lineaPresupuestoRepositoryProvider =
    Provider<LineaPresupuestoRepository>((ref) {
      final database = ref.read(databaseProvider);
      return LineaPresupuestoRepository(database);
    });

class LineaPresupuestoRepository {
  final AppDatabase database;

  LineaPresupuestoRepository(this.database);

  Future<void> _recalcularImporteTotal(String presupuestoId) async {
    final lineas = await database.lineasPresupuestoDao
        .obtenerPorPresupuesto(presupuestoId);

    final importeTotal = lineas.fold<double>(
      0,
      (sum, linea) => sum + linea.importe,
    );

    final presupuestoRepository = PresupuestoRepository(database);
    await presupuestoRepository.actualizarImporteTotal(
      presupuestoId,
      importeTotal,
    );
  }

  Future<void> crearLinea({
    required String presupuestoId,
    required String concepto,
    required double cantidad,
    required double precioUnitario,
  }) async {
    await database.lineasPresupuestoDao.insertarLinea(
      LineasPresupuestoCompanion.insert(
        id: const Uuid().v4(),
        presupuestoId: presupuestoId,
        concepto: concepto,
        cantidad: cantidad,
        precioUnitario: precioUnitario,
      ),
    );

    await _recalcularImporteTotal(presupuestoId);
  }

  Future<void> actualizarLinea({
    required String id,
    required String presupuestoId,
    required String concepto,
    required double cantidad,
    required double precioUnitario,
  }) async {
    await database.lineasPresupuestoDao.actualizarLinea(
      id,
      LineasPresupuestoCompanion(
        concepto: Value(concepto),
        cantidad: Value(cantidad),
        precioUnitario: Value(precioUnitario),
      ),
    );

    await _recalcularImporteTotal(presupuestoId);
  }

  Future<void> eliminarLinea(
    String id,
    String presupuestoId,
  ) async {
    await database.lineasPresupuestoDao.eliminarLinea(id);
    await _recalcularImporteTotal(presupuestoId);
  }

  Stream<List<linea_domain.LineaPresupuesto>> observarPorPresupuesto(
    String presupuestoId,
  ) {
    return database.lineasPresupuestoDao.observarPorPresupuesto(presupuestoId);
  }
}

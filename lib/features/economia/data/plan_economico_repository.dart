import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../database/app_database.dart';
import '../../facturas/domain/redondeo_monetario.dart';
import '../domain/plan_economico.dart';

class PlanEconomicoRepository {
  PlanEconomicoRepository(this.database);

  final AppDatabase database;
  static const _uuid = Uuid();

  Stream<List<CategoriaEconomica>> observarCategorias() =>
      database.economiaPrevistaDao.observarCategorias().map(
        (rows) => rows
            .map(
              (row) => CategoriaEconomica(
                id: row.id,
                codigo: row.codigo,
                nombre: row.nombre,
                orden: row.orden,
                activa: row.activa,
              ),
            )
            .toList(growable: false),
      );

  Future<double?> obtenerPorcentajeIndirectos() async =>
      (await database.economiaPrevistaDao.obtenerConfiguracion())
          ?.porcentajeIndirectos;

  Future<void> guardarPorcentajeIndirectos(double? porcentaje) async {
    if (porcentaje != null &&
        (!porcentaje.isFinite || porcentaje < 0 || porcentaje > 100)) {
      throw ArgumentError.value(
        porcentaje,
        'porcentaje',
        'Debe estar entre 0 y 100.',
      );
    }
    await database.economiaPrevistaDao.guardarPorcentajeIndirectos(porcentaje);
  }

  Future<CostePrevistoLinea?> obtenerCosteLinea(String lineaId) async {
    final row = await database.economiaPrevistaDao.obtenerCosteLinea(lineaId);
    return row == null
        ? null
        : CostePrevistoLinea(
            lineaPresupuestoId: row.lineaPresupuestoId,
            categoriaEconomicaId: row.categoriaEconomicaId,
            costeCentimos: row.costePrevistoCentimos,
          );
  }

  Stream<CostePrevistoLinea?> observarCosteLinea(String lineaId) => database
      .economiaPrevistaDao
      .observarCosteLinea(lineaId)
      .map(
        (row) => row == null
            ? null
            : CostePrevistoLinea(
                lineaPresupuestoId: row.lineaPresupuestoId,
                categoriaEconomicaId: row.categoriaEconomicaId,
                costeCentimos: row.costePrevistoCentimos,
              ),
      );

  Future<void> guardarCosteLinea({
    required String lineaId,
    required String categoriaId,
    required double coste,
  }) async {
    if (!coste.isFinite || coste < 0) {
      throw ArgumentError.value(coste, 'coste', 'Debe ser cero o positivo.');
    }
    final categoria = await database.economiaPrevistaDao.obtenerCategoria(
      categoriaId,
    );
    if (categoria == null || !categoria.activa) {
      throw StateError('La categoría económica no está disponible.');
    }
    final existente = await database.economiaPrevistaDao.obtenerCosteLinea(
      lineaId,
    );
    final ahora = DateTime.now().toUtc();
    await database.economiaPrevistaDao.guardarCosteLinea(
      LineaPresupuestoCostesPrevistosCompanion.insert(
        tenantId: database.activeTenantId,
        id: existente?.id ?? _uuid.v4(),
        lineaPresupuestoId: lineaId,
        categoriaEconomicaId: categoriaId,
        costePrevistoCentimos: monedaACentimos(coste),
        fechaCreacion: existente?.fechaCreacion ?? ahora,
        fechaModificacion: ahora,
      ),
    );
  }

  Future<void> eliminarCosteLinea(String lineaId) =>
      database.economiaPrevistaDao.eliminarCosteLinea(lineaId);

  Future<PlanEconomico?> obtenerPlanPorPresupuesto(String presupuestoId) async {
    final row = await database.economiaPrevistaDao.obtenerPlanPorPresupuesto(
      presupuestoId,
    );
    if (row == null) return null;
    return _mapPlan(row);
  }

  Stream<PlanEconomico?> observarPlanPorPresupuesto(String presupuestoId) =>
      database.economiaPrevistaDao
          .observarPlanPorPresupuesto(presupuestoId)
          .map((row) => row == null ? null : _mapPlan(row));

  Future<String> crearSnapshotParaAceptacion(String presupuestoId) async {
    if (await database.economiaPrevistaDao.obtenerPlanPorPresupuesto(
          presupuestoId,
        ) !=
        null) {
      throw StateError('El presupuesto ya tiene un plan económico.');
    }
    final presupuesto = await database.presupuestosDao.obtenerPorId(
      presupuestoId,
    );
    if (presupuesto == null || presupuesto.eliminado) {
      throw StateError('El presupuesto no está disponible.');
    }
    final lineas = await database.lineasPresupuestoDao.obtenerPorPresupuesto(
      presupuestoId,
    );
    final costes = await database.economiaPrevistaDao.obtenerCostesLineas(
      lineas.map((linea) => linea.id),
    );
    final costesPorLinea = {
      for (final coste in costes) coste.lineaPresupuestoId: coste,
    };
    final categorias = <String, CategoriasEconomica>{};
    for (final coste in costes) {
      final categoria = await database.economiaPrevistaDao.obtenerCategoria(
        coste.categoriaEconomicaId,
      );
      if (categoria == null) {
        throw StateError('Una categoría económica ya no existe.');
      }
      categorias[categoria.id] = categoria;
    }
    final porcentaje = await obtenerPorcentajeIndirectos();
    final venta = monedaACentimos(presupuesto.importeTotal);
    final magnitudes = calcularMagnitudesPrevistas(
      ventaNetaCentimos: venta,
      numeroPartidas: lineas.length,
      costesPartidasCentimos: lineas.map(
        (linea) => costesPorLinea[linea.id]?.costePrevistoCentimos,
      ),
      porcentajeIndirectos: porcentaje,
    );
    final planId = _uuid.v4();
    final ahora = DateTime.now().toUtc();
    await database.economiaPrevistaDao.insertarPlan(
      PlanesEconomicosCompanion.insert(
        tenantId: database.activeTenantId,
        id: planId,
        expedienteId: presupuesto.expedienteId,
        presupuestoId: presupuesto.id,
        fechaAceptacion: ahora,
        ventaNetaCentimos: venta,
        costeDirectoCentimos: Value(magnitudes.costeDirectoCentimos),
        porcentajeIndirectos: Value(magnitudes.porcentajeIndirectos),
        costesIndirectosCentimos: Value(magnitudes.costesIndirectosCentimos),
        costeTotalCentimos: Value(magnitudes.costeTotalCentimos),
        beneficioPrevistoCentimos: Value(magnitudes.beneficioPrevistoCentimos),
        margenPrevistoPorcentaje: Value(magnitudes.margenPrevistoPorcentaje),
        coberturaCostes: magnitudes.cobertura.name,
        fechaCreacion: ahora,
      ),
    );
    for (var orden = 0; orden < lineas.length; orden++) {
      final linea = lineas[orden];
      final coste = costesPorLinea[linea.id];
      final categoria = coste == null
          ? null
          : categorias[coste.categoriaEconomicaId];
      await database.economiaPrevistaDao.insertarPartida(
        PlanEconomicoPartidasCompanion.insert(
          tenantId: database.activeTenantId,
          id: _uuid.v4(),
          planEconomicoId: planId,
          lineaPresupuestoOrigenId: Value(linea.id),
          categoriaEconomicaId: Value(categoria?.id),
          categoriaCodigoSnapshot: Value(categoria?.codigo),
          categoriaNombreSnapshot: Value(categoria?.nombre),
          descripcion: linea.concepto,
          unidad: linea.unidad,
          cantidad: linea.cantidad,
          precioVentaUnitarioCentimos: monedaACentimos(linea.precioUnitario),
          importeVentaCentimos: monedaACentimos(linea.importe),
          costePrevistoCentimos: Value(coste?.costePrevistoCentimos),
          orden: orden,
        ),
      );
    }
    return planId;
  }

  PlanEconomico _mapPlan(PlanesEconomico row) => PlanEconomico(
    id: row.id,
    expedienteId: row.expedienteId,
    presupuestoId: row.presupuestoId,
    fechaAceptacion: row.fechaAceptacion,
    magnitudes: MagnitudesPrevistas(
      ventaNetaCentimos: row.ventaNetaCentimos,
      costeDirectoCentimos: row.costeDirectoCentimos,
      porcentajeIndirectos: row.porcentajeIndirectos,
      costesIndirectosCentimos: row.costesIndirectosCentimos,
      costeTotalCentimos: row.costeTotalCentimos,
      beneficioPrevistoCentimos: row.beneficioPrevistoCentimos,
      margenPrevistoPorcentaje: row.margenPrevistoPorcentaje,
      cobertura: CoberturaCostesPlan.values.byName(row.coberturaCostes),
    ),
  );
}

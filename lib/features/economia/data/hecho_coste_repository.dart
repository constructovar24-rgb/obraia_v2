import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../database/app_database.dart' hide TimelineEvent;
import '../../facturas/domain/redondeo_monetario.dart';
import '../../timeline/data/timeline_repository.dart';
import '../../timeline/domain/timeline_event.dart';
import '../domain/hecho_coste.dart';

class HechoCosteRepository {
  HechoCosteRepository(this.database)
    : _timeline = TimelineRepository(database.timelineEventsDao);

  final AppDatabase database;
  final TimelineRepository _timeline;
  static const _uuid = Uuid();

  Future<void> confirmarCompra({
    required String compraId,
    String? categoriaEconomicaId,
    String? planEconomicoId,
    String? planEconomicoPartidaId,
    int ivaNoRecuperableCentimos = 0,
  }) => database.transaction(() async {
    final compra = await database.comprasDao.obtenerPorId(compraId);
    if (compra == null || compra.eliminado) {
      throw StateError('La compra no está disponible.');
    }
    await database.cierreEconomicoDao.exigirEconomiaAbierta(
      compra.expedienteId,
    );
    if (compra.clasificacionEconomica == 'incurrido') {
      return;
    }
    if (compra.clasificacionEconomica == 'anulada') {
      throw StateError('Una compra anulada no puede confirmarse.');
    }
    if (categoriaEconomicaId != null &&
        await database.economiaPrevistaDao.obtenerCategoria(
              categoriaEconomicaId,
            ) ==
            null) {
      throw StateError('La categoría económica no está disponible.');
    }
    final neto = monedaACentimos(compra.baseImponible);
    if (ivaNoRecuperableCentimos < 0) {
      throw ArgumentError.value(ivaNoRecuperableCentimos);
    }
    final hechoId = _uuid.v4();
    final ahora = DateTime.now().toUtc();
    await database.hechosCosteDao.insertar(
      HechosCosteCompanion.insert(
        tenantId: database.activeTenantId,
        id: hechoId,
        expedienteId: compra.expedienteId,
        categoriaEconomicaId: Value(categoriaEconomicaId),
        planEconomicoId: Value(planEconomicoId),
        planEconomicoPartidaId: Value(planEconomicoPartidaId),
        fechaDevengo: compra.fecha,
        importeNetoCentimos: neto,
        ivaNoRecuperableCentimos: ivaNoRecuperableCentimos,
        importeCosteCentimos: neto + ivaNoRecuperableCentimos,
        descripcion: compra.concepto,
        origenTipo: 'compra',
        origenId: compra.id,
        tipoMovimiento: TipoMovimientoCoste.alta.name,
        claveIdempotencia: 'compra:${compra.id}:alta',
        fechaCreacion: ahora,
      ),
    );
    if (await database.comprasDao.actualizarClasificacion(
          compra.id,
          'incurrido',
        ) !=
        1) {
      throw StateError('No se pudo clasificar la compra.');
    }
    await _timeline.registrarEvento(
      TimelineEvent(
        id: _uuid.v4(),
        expedienteId: compra.expedienteId,
        fecha: ahora,
        tipo: TimelineEventType.compraCosteConfirmado,
        titulo: 'Compra confirmada como coste real',
        descripcion: compra.concepto,
        referenciaId: hechoId,
      ),
    );
  });

  Future<List<HechoCoste>> obtenerHechosOrigen(
    String origenTipo,
    String origenId,
  ) async =>
      (await database.hechosCosteDao.obtenerPorOrigen(origenTipo, origenId))
          .map(
            (row) => HechoCoste(
              id: row.id,
              expedienteId: row.expedienteId,
              categoriaEconomicaId: row.categoriaEconomicaId,
              planEconomicoId: row.planEconomicoId,
              planEconomicoPartidaId: row.planEconomicoPartidaId,
              fechaDevengo: row.fechaDevengo,
              importeNetoCentimos: row.importeNetoCentimos,
              ivaNoRecuperableCentimos: row.ivaNoRecuperableCentimos,
              importeCosteCentimos: row.importeCosteCentimos,
              descripcion: row.descripcion,
              origenTipo: row.origenTipo,
              origenId: row.origenId,
              tipoMovimiento: TipoMovimientoCoste.values.byName(
                row.tipoMovimiento,
              ),
              hechoRevertidoId: row.hechoRevertidoId,
            ),
          )
          .toList(growable: false);

  Future<void> revertirCompra(String compraId, {required String motivo}) =>
      database.transaction(() async {
        final compra = await database.comprasDao.obtenerPorId(compraId);
        if (compra == null || compra.clasificacionEconomica != 'incurrido') {
          throw StateError('La compra no tiene un coste vigente.');
        }
        await database.cierreEconomicoDao.exigirEconomiaAbierta(
          compra.expedienteId,
        );
        final original = await database.hechosCosteDao.obtenerAltaCompra(
          compraId,
        );
        if (original == null) throw StateError('No existe el hecho original.');
        final movimientos = await database.hechosCosteDao.obtenerPorOrigen(
          'compra',
          compraId,
        );
        if (movimientos.any((h) => h.tipoMovimiento == 'reversion')) {
          throw StateError('El coste ya está revertido.');
        }
        final reversionId = _uuid.v4();
        final ahora = DateTime.now().toUtc();
        await database.hechosCosteDao.insertar(
          HechosCosteCompanion.insert(
            tenantId: database.activeTenantId,
            id: reversionId,
            expedienteId: original.expedienteId,
            categoriaEconomicaId: Value(original.categoriaEconomicaId),
            planEconomicoId: Value(original.planEconomicoId),
            planEconomicoPartidaId: Value(original.planEconomicoPartidaId),
            fechaDevengo: ahora,
            importeNetoCentimos: -original.importeNetoCentimos,
            ivaNoRecuperableCentimos: -original.ivaNoRecuperableCentimos,
            importeCosteCentimos: -original.importeCosteCentimos,
            descripcion: motivo.trim(),
            origenTipo: 'compra',
            origenId: compraId,
            tipoMovimiento: TipoMovimientoCoste.reversion.name,
            hechoRevertidoId: Value(original.id),
            claveIdempotencia: 'compra:$compraId:reversion',
            fechaCreacion: ahora,
          ),
        );
        await database.comprasDao.actualizarClasificacion(compraId, 'anulada');
        await _timeline.registrarEvento(
          TimelineEvent(
            id: _uuid.v4(),
            expedienteId: compra.expedienteId,
            fecha: ahora,
            tipo: TimelineEventType.compraCosteRevertido,
            titulo: 'Coste real de compra revertido',
            descripcion: motivo.trim(),
            referenciaId: reversionId,
          ),
        );
      });

  Future<ResumenCosteReal> obtenerResumen(String expedienteId) async {
    final hechos = await database.hechosCosteDao.obtenerPorExpediente(
      expedienteId,
    );
    return _resumir(hechos);
  }

  Stream<ResumenCosteReal> observarResumen(String expedienteId) =>
      database.hechosCosteDao.observarPorExpediente(expedienteId).map(_resumir);

  ResumenCosteReal _resumir(List<HechosCosteData> hechos) {
    final categorias = <String, int>{};
    var sinAsignar = 0;
    var total = 0;
    for (final hecho in hechos) {
      total += hecho.importeCosteCentimos;
      final categoria = hecho.categoriaEconomicaId;
      if (categoria == null) {
        sinAsignar += hecho.importeCosteCentimos;
      } else {
        categorias[categoria] =
            (categorias[categoria] ?? 0) + hecho.importeCosteCentimos;
      }
    }
    return ResumenCosteReal(
      totalCentimos: total,
      porCategoriaCentimos: Map.unmodifiable(categorias),
      sinAsignarCentimos: sinAsignar,
      numeroHechos: hechos.length,
    );
  }

  Future<String> registrarAjuste({
    required String expedienteId,
    required DateTime fechaDevengo,
    required int importeNetoCentimos,
    required String descripcion,
    String? categoriaEconomicaId,
    int ivaNoRecuperableCentimos = 0,
  }) => database.transaction(() async {
    await database.cierreEconomicoDao.exigirEconomiaAbierta(expedienteId);
    if (descripcion.trim().isEmpty) {
      throw ArgumentError.value(descripcion, 'descripcion');
    }
    final id = _uuid.v4();
    final ahora = DateTime.now().toUtc();
    await database.hechosCosteDao.insertar(
      HechosCosteCompanion.insert(
        tenantId: database.activeTenantId,
        id: id,
        expedienteId: expedienteId,
        categoriaEconomicaId: Value(categoriaEconomicaId),
        fechaDevengo: fechaDevengo,
        importeNetoCentimos: importeNetoCentimos,
        ivaNoRecuperableCentimos: ivaNoRecuperableCentimos,
        importeCosteCentimos: importeNetoCentimos + ivaNoRecuperableCentimos,
        descripcion: descripcion.trim(),
        origenTipo: 'ajusteManual',
        origenId: id,
        tipoMovimiento: TipoMovimientoCoste.ajuste.name,
        claveIdempotencia: 'ajuste:$id',
        fechaCreacion: ahora,
      ),
    );
    await _timeline.registrarEvento(
      TimelineEvent(
        id: _uuid.v4(),
        expedienteId: expedienteId,
        fecha: ahora,
        tipo: TimelineEventType.compraCosteAjustado,
        titulo: 'Ajuste de coste real',
        descripcion: descripcion.trim(),
        referenciaId: id,
      ),
    );
    return id;
  });
}

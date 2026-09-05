import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../database/app_database.dart' hide TimelineEvent;
import '../../timeline/data/timeline_repository.dart';
import '../../timeline/domain/timeline_event.dart';
import '../domain/prevision_economica.dart';

class PrevisionEconomicaRepository {
  PrevisionEconomicaRepository(this.database)
    : _timeline = TimelineRepository(database.timelineEventsDao);

  final AppDatabase database;
  final TimelineRepository _timeline;
  static const _uuid = Uuid();

  Future<String> crearCompromiso({
    required String expedienteId,
    required String descripcion,
    required String origenTipo,
    required int importeCentimos,
    required DateTime fecha,
    String? categoriaEconomicaId,
    String? planEconomicoId,
    String? planEconomicoPartidaId,
    String? origenId,
  }) => database.transaction(() async {
    await database.cierreEconomicoDao.exigirEconomiaAbierta(expedienteId);
    _validarImporte(importeCentimos);
    _validarTexto(descripcion, 'descripcion');
    if (categoriaEconomicaId != null &&
        await database.economiaPrevistaDao.obtenerCategoria(
              categoriaEconomicaId,
            ) ==
            null) {
      throw StateError('La categoría económica no está disponible.');
    }
    final id = _uuid.v4();
    final ahora = DateTime.now().toUtc();
    await database.previsionEconomicaDao.insertarCompromiso(
      CompromisosEconomicosCompanion.insert(
        tenantId: database.activeTenantId,
        id: id,
        expedienteId: expedienteId,
        categoriaEconomicaId: Value(categoriaEconomicaId),
        planEconomicoId: Value(planEconomicoId),
        planEconomicoPartidaId: Value(planEconomicoPartidaId),
        descripcion: descripcion.trim(),
        origenTipo: origenTipo,
        origenId: Value(origenId),
        importeComprometidoCentimos: importeCentimos,
        estado: EstadoCompromiso.activo.name,
        fechaCompromiso: fecha,
        fechaCreacion: ahora,
        fechaModificacion: ahora,
      ),
    );
    await _evento(
      expedienteId,
      id,
      TimelineEventType.compromisoEconomicoCreado,
      'Compromiso económico creado',
      descripcion,
    );
    return id;
  });

  Future<void> ajustarCompromiso({
    required String id,
    required int nuevoImporteCentimos,
    required String motivo,
  }) => database.transaction(() async {
    _validarImporte(nuevoImporteCentimos);
    _validarTexto(motivo, 'motivo');
    final actual = await _requerirCompromiso(id);
    await database.cierreEconomicoDao.exigirEconomiaAbierta(
      actual.expedienteId,
    );
    if (actual.estado == EstadoCompromiso.cancelado.name) {
      throw StateError('Un compromiso cancelado no puede ajustarse.');
    }
    final consumido = await _consumidoEfectivo(actual);
    if (nuevoImporteCentimos < consumido) {
      throw StateError('El importe no puede ser inferior al ya consumido.');
    }
    final estado = nuevoImporteCentimos == consumido
        ? EstadoCompromiso.cumplido.name
        : EstadoCompromiso.activo.name;
    await database.previsionEconomicaDao.actualizarCompromiso(
      id,
      CompromisosEconomicosCompanion(
        importeComprometidoCentimos: Value(nuevoImporteCentimos),
        estado: Value(estado),
        motivoUltimoCambio: Value(motivo.trim()),
        fechaModificacion: Value(DateTime.now().toUtc()),
      ),
    );
    await _evento(
      actual.expedienteId,
      id,
      TimelineEventType.compromisoEconomicoAjustado,
      'Compromiso económico ajustado',
      '${actual.importeComprometidoCentimos} → $nuevoImporteCentimos céntimos. ${motivo.trim()}',
    );
  });

  Future<void> cancelarCompromiso(String id, {required String motivo}) =>
      database.transaction(() async {
        _validarTexto(motivo, 'motivo');
        final actual = await _requerirCompromiso(id);
        await database.cierreEconomicoDao.exigirEconomiaAbierta(
          actual.expedienteId,
        );
        if (await _consumidoEfectivo(actual) != 0) {
          throw StateError('No se puede cancelar un compromiso consumido.');
        }
        await database.previsionEconomicaDao.actualizarCompromiso(
          id,
          CompromisosEconomicosCompanion(
            estado: const Value('cancelado'),
            motivoUltimoCambio: Value(motivo.trim()),
            fechaModificacion: Value(DateTime.now().toUtc()),
          ),
        );
        await _evento(
          actual.expedienteId,
          id,
          TimelineEventType.compromisoEconomicoCancelado,
          'Compromiso económico cancelado',
          motivo,
        );
      });

  Future<void> aplicarHecho({
    required String compromisoId,
    required String hechoCosteId,
    required int importeCentimos,
  }) => database.transaction(() async {
    if (importeCentimos <= 0) throw ArgumentError.value(importeCentimos);
    final compromiso = await _requerirCompromiso(compromisoId);
    await database.cierreEconomicoDao.exigirEconomiaAbierta(
      compromiso.expedienteId,
    );
    if (compromiso.estado == EstadoCompromiso.cancelado.name) {
      throw StateError('El compromiso está cancelado.');
    }
    final hecho = await database.hechosCosteDao.obtenerPorId(hechoCosteId);
    if (hecho == null || hecho.expedienteId != compromiso.expedienteId) {
      throw StateError('El hecho real no pertenece a la misma obra.');
    }
    if (hecho.tipoMovimiento == 'reversion' ||
        hecho.importeCosteCentimos <= 0) {
      throw StateError('Solo se puede aplicar un hecho de coste positivo.');
    }
    final aplicaciones = await database.previsionEconomicaDao
        .obtenerAplicaciones(compromisoId);
    final consumido = await _consumidoEfectivo(compromiso);
    if (consumido + importeCentimos > compromiso.importeComprometidoCentimos) {
      throw StateError('La aplicación supera el saldo del compromiso.');
    }
    final yaAplicadoAlHecho = aplicaciones
        .where((a) => a.hechoCosteId == hechoCosteId)
        .fold<int>(0, (total, a) => total + a.importeAplicadoCentimos);
    if (yaAplicadoAlHecho + importeCentimos > hecho.importeCosteCentimos) {
      throw StateError('La aplicación supera el importe del hecho real.');
    }
    await database.previsionEconomicaDao.insertarAplicacion(
      AplicacionesCompromisoCosteCompanion.insert(
        tenantId: database.activeTenantId,
        id: _uuid.v4(),
        compromisoId: compromisoId,
        hechoCosteId: hechoCosteId,
        importeAplicadoCentimos: importeCentimos,
        fechaCreacion: DateTime.now().toUtc(),
      ),
    );
    if (consumido + importeCentimos == compromiso.importeComprometidoCentimos) {
      await database.previsionEconomicaDao.actualizarCompromiso(
        compromisoId,
        CompromisosEconomicosCompanion(
          estado: const Value('cumplido'),
          fechaModificacion: Value(DateTime.now().toUtc()),
        ),
      );
    }
    await _evento(
      compromiso.expedienteId,
      compromisoId,
      TimelineEventType.compromisoEconomicoConsumido,
      'Coste real aplicado a compromiso',
      compromiso.descripcion,
    );
  });

  Future<String> registrarEstimacion({
    required String expedienteId,
    required int importeAdicionalCentimos,
    required String justificacion,
    required DateTime fecha,
    String? serieId,
    String? categoriaEconomicaId,
    String? planEconomicoId,
    String? planEconomicoPartidaId,
  }) => database.transaction(() async {
    await database.cierreEconomicoDao.exigirEconomiaAbierta(expedienteId);
    _validarImporte(importeAdicionalCentimos);
    _validarTexto(justificacion, 'justificacion');
    final serie = serieId ?? _uuid.v4();
    final existentes = await database.previsionEconomicaDao.obtenerEstimaciones(
      expedienteId,
    );
    final versiones = existentes.where((e) => e.serieId == serie).toList();
    if (versiones.isNotEmpty) {
      final anterior = versiones.first;
      if (anterior.categoriaEconomicaId != categoriaEconomicaId ||
          anterior.planEconomicoId != planEconomicoId ||
          anterior.planEconomicoPartidaId != planEconomicoPartidaId) {
        throw StateError('Una revisión no puede cambiar su ámbito económico.');
      }
    }
    final id = _uuid.v4();
    await database.previsionEconomicaDao.insertarEstimacion(
      EstimacionesCosteRestanteCompanion.insert(
        tenantId: database.activeTenantId,
        id: id,
        serieId: serie,
        version: versiones.length + 1,
        expedienteId: expedienteId,
        categoriaEconomicaId: Value(categoriaEconomicaId),
        planEconomicoId: Value(planEconomicoId),
        planEconomicoPartidaId: Value(planEconomicoPartidaId),
        importeAdicionalCentimos: importeAdicionalCentimos,
        justificacion: justificacion.trim(),
        fechaEstimacion: fecha,
        fechaCreacion: DateTime.now().toUtc(),
      ),
    );
    await _evento(
      expedienteId,
      id,
      TimelineEventType.estimacionCosteRestanteActualizada,
      'Estimación de coste restante actualizada',
      justificacion,
    );
    return id;
  });

  Future<List<CompromisoEconomico>> obtenerCompromisos(
    String expedienteId,
  ) async {
    final rows = await database.previsionEconomicaDao.obtenerCompromisos(
      expedienteId,
    );
    return Future.wait(
      rows.map(
        (row) async => _mapCompromiso(row, await _consumidoEfectivo(row)),
      ),
    );
  }

  Future<List<EstimacionCosteRestante>> obtenerHistorialEstimaciones(
    String expedienteId,
  ) async => (await database.previsionEconomicaDao.obtenerEstimaciones(
    expedienteId,
  )).map(_mapEstimacion).toList(growable: false);

  Future<ResumenForecastObra> obtenerResumen(String expedienteId) async {
    final hechos = await database.hechosCosteDao.obtenerPorExpediente(
      expedienteId,
    );
    final compromisos = await obtenerCompromisos(expedienteId);
    final historial = await database.previsionEconomicaDao.obtenerEstimaciones(
      expedienteId,
    );
    final vigentes = <String, EstimacionesCosteRestanteData>{};
    for (final row in historial) {
      final actual = vigentes[row.serieId];
      if (actual == null || row.version > actual.version) {
        vigentes[row.serieId] = row;
      }
    }
    final real = hechos.fold<int>(0, (t, h) => t + h.importeCosteCentimos);
    final pendiente = compromisos
        .where((c) => c.estado != EstadoCompromiso.cancelado)
        .fold<int>(0, (t, c) => t + c.pendienteCentimos);
    final adicional = vigentes.values.fold<int>(
      0,
      (t, e) => t + e.importeAdicionalCentimos,
    );
    final plan = await database.economiaPrevistaDao.obtenerPlanPorExpediente(
      expedienteId,
    );
    final partidas = plan == null
        ? const <PlanEconomicoPartida>[]
        : await database.economiaPrevistaDao.obtenerPartidasPlan(plan.id);
    final categoriasPlan = partidas
        .map((p) => p.categoriaEconomicaId)
        .whereType<String>()
        .toSet();
    final categoriasEstimadas = vigentes.values
        .map((e) => e.categoriaEconomicaId)
        .whereType<String>()
        .toSet();
    final cobertura =
        categoriasPlan.isNotEmpty &&
            categoriasPlan.every(categoriasEstimadas.contains)
        ? CoberturaForecast.completa
        : vigentes.isNotEmpty || compromisos.isNotEmpty
        ? CoberturaForecast.parcial
        : CoberturaForecast.noDisponible;
    final subtotal = real + pendiente + adicional;
    final finalEstimado = cobertura == CoberturaForecast.completa
        ? subtotal
        : null;
    final venta = plan?.ventaNetaCentimos;
    final beneficio = venta != null && finalEstimado != null
        ? venta - finalEstimado
        : null;
    final margen = venta != null && venta != 0 && beneficio != null
        ? beneficio * 100 / venta
        : null;
    final porCategoria = <String?, int>{};
    final realPorCategoria = <String?, int>{};
    final compromisoPorCategoria = <String?, int>{};
    final restantePorCategoria = <String?, int>{};
    final previstoPorCategoria = <String?, int>{};
    for (final h in hechos) {
      realPorCategoria[h.categoriaEconomicaId] =
          (realPorCategoria[h.categoriaEconomicaId] ?? 0) +
          h.importeCosteCentimos;
      porCategoria[h.categoriaEconomicaId] =
          (porCategoria[h.categoriaEconomicaId] ?? 0) + h.importeCosteCentimos;
    }
    for (final c in compromisos.where(
      (c) => c.estado != EstadoCompromiso.cancelado,
    )) {
      compromisoPorCategoria[c.categoriaEconomicaId] =
          (compromisoPorCategoria[c.categoriaEconomicaId] ?? 0) +
          c.pendienteCentimos;
      porCategoria[c.categoriaEconomicaId] =
          (porCategoria[c.categoriaEconomicaId] ?? 0) + c.pendienteCentimos;
    }
    for (final e in vigentes.values) {
      restantePorCategoria[e.categoriaEconomicaId] =
          (restantePorCategoria[e.categoriaEconomicaId] ?? 0) +
          e.importeAdicionalCentimos;
      porCategoria[e.categoriaEconomicaId] =
          (porCategoria[e.categoriaEconomicaId] ?? 0) +
          e.importeAdicionalCentimos;
    }
    for (final partida in partidas) {
      final coste = partida.costePrevistoCentimos;
      if (coste != null) {
        previstoPorCategoria[partida.categoriaEconomicaId] =
            (previstoPorCategoria[partida.categoriaEconomicaId] ?? 0) + coste;
      }
    }
    final categorias = await database.economiaPrevistaDao
        .observarCategorias()
        .first;
    final nombres = {for (final c in categorias) c.id: c.nombre};
    final ids = <String?>{
      ...previstoPorCategoria.keys,
      ...realPorCategoria.keys,
      ...compromisoPorCategoria.keys,
      ...restantePorCategoria.keys,
    };
    final desglose =
        ids
            .map(
              (id) => DesgloseForecastCategoria(
                categoriaId: id,
                nombre: id == null ? 'Sin asignar' : nombres[id] ?? 'Categoría',
                previstoCentimos: previstoPorCategoria[id],
                realCentimos: realPorCategoria[id] ?? 0,
                comprometidoCentimos: compromisoPorCategoria[id] ?? 0,
                restanteCentimos: restantePorCategoria[id] ?? 0,
              ),
            )
            .toList(growable: false)
          ..sort((a, b) {
            if (a.categoriaId == null) return 1;
            if (b.categoriaId == null) return -1;
            return a.nombre.compareTo(b.nombre);
          });
    return ResumenForecastObra(
      costeRealCentimos: real,
      comprometidoPendienteCentimos: pendiente,
      estimacionAdicionalCentimos: adicional,
      subtotalConocidoCentimos: subtotal,
      cobertura: cobertura,
      ventaPlanificadaCentimos: venta,
      costePlanificadoCentimos: plan?.costeTotalCentimos,
      beneficioPlanificadoCentimos: plan?.beneficioPrevistoCentimos,
      margenPlanificadoPorcentaje: plan?.margenPrevistoPorcentaje,
      costeFinalEstimadoCentimos: finalEstimado,
      beneficioFinalEstimadoCentimos: beneficio,
      margenFinalEstimadoPorcentaje: margen,
      porCategoriaCentimos: Map.unmodifiable(porCategoria),
      tieneCompromisosSobreconsumidos: compromisos.any(
        (c) => c.importeConsumidoCentimos > c.importeComprometidoCentimos,
      ),
      desgloseCategorias: desglose,
    );
  }

  Future<CompromisosEconomico> _requerirCompromiso(String id) async {
    final value = await database.previsionEconomicaDao.obtenerCompromiso(id);
    if (value == null) throw StateError('El compromiso no está disponible.');
    return value;
  }

  Future<int> _consumidoEfectivo(CompromisosEconomico compromiso) async {
    final aplicaciones = await database.previsionEconomicaDao
        .obtenerAplicaciones(compromiso.id);
    final hechos = await database.hechosCosteDao.obtenerPorExpediente(
      compromiso.expedienteId,
    );
    final revertidos = hechos
        .where((h) => h.tipoMovimiento == 'reversion')
        .map((h) => h.hechoRevertidoId)
        .whereType<String>()
        .toSet();
    return aplicaciones
        .where((a) => !revertidos.contains(a.hechoCosteId))
        .fold<int>(0, (t, a) => t + a.importeAplicadoCentimos);
  }

  CompromisoEconomico _mapCompromiso(CompromisosEconomico r, int consumido) =>
      CompromisoEconomico(
        id: r.id,
        expedienteId: r.expedienteId,
        categoriaEconomicaId: r.categoriaEconomicaId,
        planEconomicoId: r.planEconomicoId,
        planEconomicoPartidaId: r.planEconomicoPartidaId,
        descripcion: r.descripcion,
        origenTipo: r.origenTipo,
        origenId: r.origenId,
        importeComprometidoCentimos: r.importeComprometidoCentimos,
        importeConsumidoCentimos: consumido,
        estado: r.estado == EstadoCompromiso.cancelado.name
            ? EstadoCompromiso.cancelado
            : consumido >= r.importeComprometidoCentimos
            ? EstadoCompromiso.cumplido
            : EstadoCompromiso.activo,
        fechaCompromiso: r.fechaCompromiso,
      );

  EstimacionCosteRestante _mapEstimacion(EstimacionesCosteRestanteData r) =>
      EstimacionCosteRestante(
        id: r.id,
        serieId: r.serieId,
        version: r.version,
        expedienteId: r.expedienteId,
        categoriaEconomicaId: r.categoriaEconomicaId,
        planEconomicoId: r.planEconomicoId,
        planEconomicoPartidaId: r.planEconomicoPartidaId,
        importeAdicionalCentimos: r.importeAdicionalCentimos,
        justificacion: r.justificacion,
        fechaEstimacion: r.fechaEstimacion,
      );

  Future<void> _evento(
    String expedienteId,
    String referenciaId,
    TimelineEventType tipo,
    String titulo,
    String descripcion,
  ) => _timeline.registrarEvento(
    TimelineEvent(
      id: _uuid.v4(),
      expedienteId: expedienteId,
      fecha: DateTime.now().toUtc(),
      tipo: tipo,
      titulo: titulo,
      descripcion: descripcion.trim(),
      referenciaId: referenciaId,
    ),
  );

  void _validarImporte(int value) {
    if (value < 0) throw ArgumentError.value(value);
  }

  void _validarTexto(String value, String nombre) {
    if (value.trim().isEmpty) throw ArgumentError.value(value, nombre);
  }
}

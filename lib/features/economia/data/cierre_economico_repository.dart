import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../database/app_database.dart' hide TimelineEvent;
import '../../timeline/data/timeline_repository.dart';
import '../../timeline/domain/timeline_event.dart';
import '../domain/cierre_economico.dart';
import '../domain/prevision_economica.dart';
import 'prevision_economica_repository.dart';

class CierreEconomicoRepository {
  CierreEconomicoRepository(this.database)
    : _prevision = PrevisionEconomicaRepository(database),
      _timeline = TimelineRepository(database.timelineEventsDao);

  final AppDatabase database;
  final PrevisionEconomicaRepository _prevision;
  final TimelineRepository _timeline;
  static const _uuid = Uuid();

  Future<PrecheckCierreEconomico> evaluarCierre(String expedienteId) async {
    final resumen = await _prevision.obtenerResumen(expedienteId);
    final compromisos = await _prevision.obtenerCompromisos(expedienteId);
    final manoObra = await database.manoObraDao.obtenerPartesObra(expedienteId);
    final controles = <ControlCierreEconomico>[
      if (resumen.tieneCompromisosSobreconsumidos)
        const ControlCierreEconomico(
          'compromiso_sobreconsumido',
          'Existe un compromiso sobreconsumido.',
          SeveridadControlCierre.bloqueo,
        ),
      if (compromisos.any(
        (c) => c.estado == EstadoCompromiso.activo && c.pendienteCentimos > 0,
      ))
        const ControlCierreEconomico(
          'compromisos_activos',
          'Existen compromisos económicos activos.',
          SeveridadControlCierre.advertencia,
        ),
      if (manoObra.any((p) => p.estado == 'pendienteValoracion'))
        const ControlCierreEconomico(
          'horas_sin_valorar',
          'Existen horas pendientes de valorar.',
          SeveridadControlCierre.advertencia,
        ),
      if ((resumen.porCategoriaCentimos[null] ?? 0) != 0)
        const ControlCierreEconomico(
          'costes_sin_categoria',
          'Existen costes reales sin categoría.',
          SeveridadControlCierre.advertencia,
        ),
      if (resumen.cobertura != CoberturaForecast.completa)
        const ControlCierreEconomico(
          'forecast_incompleto',
          'La previsión final no tiene cobertura completa.',
          SeveridadControlCierre.advertencia,
        ),
      if (resumen.estimacionAdicionalCentimos > 0)
        const ControlCierreEconomico(
          'restante_pendiente',
          'La estimación todavía contempla coste adicional pendiente.',
          SeveridadControlCierre.advertencia,
        ),
      if (resumen.beneficioNegativo)
        const ControlCierreEconomico(
          'perdida_estimada',
          'La obra presenta una pérdida económica estimada.',
          SeveridadControlCierre.advertencia,
        ),
      if (resumen.forecastSuperaPlan)
        const ControlCierreEconomico(
          'sobrecoste',
          'El coste final estimado supera el coste previsto.',
          SeveridadControlCierre.advertencia,
        ),
      if (resumen.margenInferiorAlPlan)
        const ControlCierreEconomico(
          'margen_inferior',
          'El margen final estimado es inferior al previsto.',
          SeveridadControlCierre.advertencia,
        ),
    ];
    if (controles.isEmpty) {
      controles.add(
        const ControlCierreEconomico(
          'sin_incidencias',
          'No se han detectado incidencias para el cierre.',
          SeveridadControlCierre.informacion,
        ),
      );
    }
    return PrecheckCierreEconomico(List.unmodifiable(controles));
  }

  Future<List<AlertaEconomica>> obtenerAlertas(String expedienteId) async {
    final check = await evaluarCierre(expedienteId);
    return check.controles
        .where((c) => c.codigo != 'sin_incidencias')
        .map(
          (c) => AlertaEconomica(
            c.codigo,
            c.mensaje,
            c.codigo == 'perdida_estimada' ||
                    c.codigo == 'compromiso_sobreconsumido'
                ? SeveridadAlertaEconomica.critica
                : SeveridadAlertaEconomica.atencion,
          ),
        )
        .toList(growable: false);
  }

  Future<EstadoCierreEconomico> obtenerEstado(String expedienteId) async {
    final state = await database.cierreEconomicoDao.obtenerEstado(expedienteId);
    final last = await database.cierreEconomicoDao.obtenerUltimoCierre(
      expedienteId,
    );
    return EstadoCierreEconomico(
      estado: state?.estado == 'cerrado'
          ? EstadoEconomicoObra.cerrado
          : EstadoEconomicoObra.abierto,
      numeroCierres: state?.numeroCierres ?? 0,
      ultimoCierre: last == null ? null : _mapCierre(last),
    );
  }

  Stream<EstadoCierreEconomico> observarEstado(String expedienteId) => database
      .cierreEconomicoDao
      .observarEstado(expedienteId)
      .asyncMap((_) => obtenerEstado(expedienteId));

  Future<String> cerrar(
    String expedienteId, {
    required bool confirmarAdvertencias,
  }) => database.transaction(() async {
    final actual = await obtenerEstado(expedienteId);
    if (actual.estado == EstadoEconomicoObra.cerrado) {
      throw StateError('La economía ya está cerrada.');
    }
    final precheck = await evaluarCierre(expedienteId);
    if (precheck.tieneBloqueos) {
      throw StateError('Existen bloqueos que impiden el cierre económico.');
    }
    if (precheck.tieneAdvertencias && !confirmarAdvertencias) {
      throw StateError('El cierre con advertencias exige confirmación.');
    }
    final resumen = await _prevision.obtenerResumen(expedienteId);
    final now = DateTime.now().toUtc();
    final id = _uuid.v4();
    final numero = actual.numeroCierres + 1;
    final detalle = precheck.controles
        .map((c) => '${c.severidad.name}:${c.codigo}:${c.mensaje}')
        .join('\n');
    await database.cierreEconomicoDao.insertarCierre(
      CierresEconomicosObraCompanion.insert(
        tenantId: database.activeTenantId,
        id: id,
        expedienteId: expedienteId,
        numero: numero,
        fechaCierre: now,
        ventaPlanificadaCentimos: Value(resumen.ventaPlanificadaCentimos),
        costePlanificadoCentimos: Value(resumen.costePlanificadoCentimos),
        costeRealCentimos: resumen.costeRealCentimos,
        compromisoPendienteCentimos: resumen.comprometidoPendienteCentimos,
        restanteEstimadoCentimos: resumen.estimacionAdicionalCentimos,
        costeFinalEstimadoCentimos: Value(resumen.costeFinalEstimadoCentimos),
        beneficioPrevistoCentimos: Value(resumen.beneficioPlanificadoCentimos),
        beneficioFinalCentimos: Value(resumen.beneficioFinalEstimadoCentimos),
        margenPrevistoPorcentaje: Value(resumen.margenPlanificadoPorcentaje),
        margenFinalPorcentaje: Value(resumen.margenFinalEstimadoPorcentaje),
        cobertura: resumen.cobertura.name,
        desviacionCosteCentimos: Value(resumen.desviacionCosteCentimos),
        desviacionBeneficioCentimos: Value(resumen.desviacionBeneficioCentimos),
        conAdvertencias: precheck.tieneAdvertencias,
        resumenPrecheck: detalle,
      ),
    );
    await database.cierreEconomicoDao.guardarEstado(
      EstadosEconomicosObraCompanion.insert(
        tenantId: database.activeTenantId,
        expedienteId: expedienteId,
        estado: 'cerrado',
        numeroCierres: Value(numero),
        fechaModificacion: now,
      ),
    );
    await _timeline.registrarEvento(
      TimelineEvent(
        id: _uuid.v4(),
        expedienteId: expedienteId,
        fecha: now,
        tipo: precheck.tieneAdvertencias
            ? TimelineEventType.economiaCerradaConAdvertencias
            : TimelineEventType.economiaCerrada,
        titulo: precheck.tieneAdvertencias
            ? 'Economía cerrada con advertencias'
            : 'Economía cerrada',
        descripcion: detalle,
        referenciaId: id,
      ),
    );
    return id;
  });

  Future<void> reabrir(String expedienteId, {required String motivo}) =>
      database.transaction(() async {
        if (motivo.trim().isEmpty) throw ArgumentError.value(motivo, 'motivo');
        final state = await obtenerEstado(expedienteId);
        if (state.estado != EstadoEconomicoObra.cerrado ||
            state.ultimoCierre == null) {
          throw StateError('La economía no está cerrada.');
        }
        final now = DateTime.now().toUtc();
        final id = _uuid.v4();
        await database.cierreEconomicoDao.insertarReapertura(
          ReaperturasEconomicasObraCompanion.insert(
            tenantId: database.activeTenantId,
            id: id,
            expedienteId: expedienteId,
            cierreId: state.ultimoCierre!.id,
            fechaReapertura: now,
            motivo: motivo.trim(),
          ),
        );
        await database.cierreEconomicoDao.guardarEstado(
          EstadosEconomicosObraCompanion.insert(
            tenantId: database.activeTenantId,
            expedienteId: expedienteId,
            estado: 'abierto',
            numeroCierres: Value(state.numeroCierres),
            fechaModificacion: now,
          ),
        );
        await _timeline.registrarEvento(
          TimelineEvent(
            id: _uuid.v4(),
            expedienteId: expedienteId,
            fecha: now,
            tipo: TimelineEventType.economiaReabierta,
            titulo: 'Economía reabierta',
            descripcion: motivo.trim(),
            referenciaId: id,
          ),
        );
      });

  Future<List<CierreEconomicoSnapshot>> obtenerHistorial(
    String expedienteId,
  ) async => (await database.cierreEconomicoDao.obtenerCierres(
    expedienteId,
  )).map(_mapCierre).toList(growable: false);

  Future<List<ReaperturaEconomica>> obtenerReaperturas(
    String expedienteId,
  ) async =>
      (await database.cierreEconomicoDao.obtenerReaperturas(expedienteId))
          .map(
            (r) => ReaperturaEconomica(
              id: r.id,
              cierreId: r.cierreId,
              fecha: r.fechaReapertura,
              motivo: r.motivo,
            ),
          )
          .toList(growable: false);

  CierreEconomicoSnapshot _mapCierre(CierresEconomicosObraData r) =>
      CierreEconomicoSnapshot(
        id: r.id,
        numero: r.numero,
        fechaCierre: r.fechaCierre,
        conAdvertencias: r.conAdvertencias,
        resumenPrecheck: r.resumenPrecheck,
        resumen: ResumenForecastObra(
          costeRealCentimos: r.costeRealCentimos,
          comprometidoPendienteCentimos: r.compromisoPendienteCentimos,
          estimacionAdicionalCentimos: r.restanteEstimadoCentimos,
          subtotalConocidoCentimos:
              r.costeRealCentimos +
              r.compromisoPendienteCentimos +
              r.restanteEstimadoCentimos,
          cobertura: CoberturaForecast.values.byName(r.cobertura),
          ventaPlanificadaCentimos: r.ventaPlanificadaCentimos,
          costePlanificadoCentimos: r.costePlanificadoCentimos,
          beneficioPlanificadoCentimos: r.beneficioPrevistoCentimos,
          margenPlanificadoPorcentaje: r.margenPrevistoPorcentaje,
          costeFinalEstimadoCentimos: r.costeFinalEstimadoCentimos,
          beneficioFinalEstimadoCentimos: r.beneficioFinalCentimos,
          margenFinalEstimadoPorcentaje: r.margenFinalPorcentaje,
          porCategoriaCentimos: const {},
          tieneCompromisosSobreconsumidos: false,
          desgloseCategorias: const [],
        ),
      );
}

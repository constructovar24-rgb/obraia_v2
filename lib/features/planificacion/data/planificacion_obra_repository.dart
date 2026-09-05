import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../database/app_database.dart';
import '../../timeline/data/timeline_repository.dart';
import '../../timeline/domain/timeline_event.dart' as timeline_domain;
import '../domain/planificacion_obra.dart';

class PlanificacionObraRepository {
  PlanificacionObraRepository(this.database)
    : _timeline = TimelineRepository(database.timelineEventsDao);

  final AppDatabase database;
  final TimelineRepository _timeline;
  static const _uuid = Uuid();

  Stream<PlanificacionObra?> observarPlanificacion(String expedienteId) =>
      database.planificacionObraDao
          .observarPlanificacion(expedienteId)
          .map((row) => row == null ? null : _mapPlanificacion(row));

  Stream<List<ActuacionObra>> observarActuaciones(String expedienteId) =>
      database.planificacionObraDao
          .observarActuaciones(expedienteId)
          .map((rows) => rows.map(_mapActuacion).toList(growable: false));

  Future<void> guardarCalendario({
    required String expedienteId,
    DateTime? inicioPrevisto,
    DateTime? finPrevisto,
    DateTime? inicioReal,
    DateTime? finReal,
  }) async {
    _validarFechas(inicioPrevisto, finPrevisto, 'prevista');
    _validarFechas(inicioReal, finReal, 'real');
    final count = await database.planificacionObraDao.actualizarPlanificacion(
      expedienteId,
      ExpedientesCompanion(
        fechaInicioPrevista: Value(inicioPrevisto),
        fechaFinPrevista: Value(finPrevisto),
        fechaInicioReal: Value(inicioReal),
        fechaFinReal: Value(finReal),
        fechaModificacion: Value(DateTime.now().toUtc()),
      ),
    );
    if (count != 1) throw StateError('La obra no existe.');
  }

  Future<void> cambiarEstado(
    String expedienteId,
    EstadoOperativoObra estado, {
    DateTime? inicioReal,
    DateTime? finReal,
  }) async {
    final actual = await database.planificacionObraDao.obtenerPlanificacion(
      expedienteId,
    );
    if (actual == null) throw StateError('La obra no existe.');
    final inicio = inicioReal ?? actual.fechaInicioReal;
    final fin = finReal ?? actual.fechaFinReal;
    _validarFechas(inicio, fin, 'real');
    if (estado == EstadoOperativoObra.finalizada && fin == null) {
      throw const PlanificacionFechasInvalidasException(
        'Indica la fecha real de fin para finalizar la obra.',
      );
    }
    await database.transaction(() async {
      final count = await database.planificacionObraDao.actualizarPlanificacion(
        expedienteId,
        ExpedientesCompanion(
          estadoOperativo: Value(estado.name),
          fechaInicioReal: Value(inicio),
          fechaFinReal: Value(fin),
          fechaModificacion: Value(DateTime.now().toUtc()),
        ),
      );
      if (count != 1) throw StateError('La obra no existe.');
      await _evento(
        expedienteId,
        timeline_domain.TimelineEventType.estadoOperativoObraCambiado,
        'Estado operativo: ${estado.name}',
      );
      if (inicioReal != null && actual.fechaInicioReal != inicioReal) {
        await _evento(
          expedienteId,
          timeline_domain.TimelineEventType.inicioRealObraRegistrado,
          'Inicio real registrado',
        );
      }
      if (finReal != null && actual.fechaFinReal != finReal) {
        await _evento(
          expedienteId,
          timeline_domain.TimelineEventType.finalizacionRealObraRegistrada,
          'Finalización real registrada',
        );
      }
    });
  }

  Future<void> guardarProximoPaso({
    required String expedienteId,
    required String descripcion,
    DateTime? fechaPrevista,
  }) async {
    final text = descripcion.trim();
    if (text.isEmpty) throw ArgumentError.value(descripcion, 'descripcion');
    final id = _uuid.v4();
    await database.transaction(() async {
      final rows = await database.planificacionObraDao.obtenerActuaciones(
        expedienteId,
      );
      for (final row in rows.where(
        (r) =>
            r.tipo == TipoActuacionObra.proximoPaso.name &&
            r.estado == EstadoActuacionObra.pendiente.name,
      )) {
        await database.planificacionObraDao.actualizarActuacion(
          row.id,
          ActuacionesObraCompanion(
            estado: Value(EstadoActuacionObra.cancelado.name),
            fechaModificacion: Value(DateTime.now().toUtc()),
          ),
        );
      }
      await database.planificacionObraDao.insertarActuacion(
        ActuacionesObraCompanion.insert(
          tenantId: database.activeTenantId,
          id: id,
          expedienteId: expedienteId,
          tipo: TipoActuacionObra.proximoPaso.name,
          descripcion: text,
          fechaPrevista: Value(fechaPrevista),
        ),
      );
      await _evento(
        expedienteId,
        timeline_domain.TimelineEventType.actuacionObraCreada,
        'Próximo paso: $text',
        referenciaId: id,
      );
    });
  }

  Future<void> crearActuacion({
    required String expedienteId,
    required String descripcion,
    DateTime? fechaPrevista,
    int orden = 0,
    String? observaciones,
  }) async {
    final id = _uuid.v4();
    await database.transaction(() async {
      await database.planificacionObraDao.insertarActuacion(
        ActuacionesObraCompanion.insert(
          tenantId: database.activeTenantId,
          id: id,
          expedienteId: expedienteId,
          tipo: TipoActuacionObra.actuacion.name,
          descripcion: descripcion.trim(),
          fechaPrevista: Value(fechaPrevista),
          orden: Value(orden),
          observaciones: Value(observaciones?.trim()),
        ),
      );
      await _evento(
        expedienteId,
        timeline_domain.TimelineEventType.actuacionObraCreada,
        'Actuación prevista: ${descripcion.trim()}',
        referenciaId: id,
      );
    });
  }

  Future<void> cambiarEstadoActuacion(
    ActuacionObra actuacion,
    EstadoActuacionObra estado,
  ) async {
    await database.transaction(() async {
      final count = await database.planificacionObraDao.actualizarActuacion(
        actuacion.id,
        ActuacionesObraCompanion(
          estado: Value(estado.name),
          fechaModificacion: Value(DateTime.now().toUtc()),
        ),
      );
      if (count != 1) throw StateError('La actuación no existe.');
      await _evento(
        actuacion.expedienteId,
        estado == EstadoActuacionObra.completado
            ? timeline_domain.TimelineEventType.actuacionObraCompletada
            : timeline_domain.TimelineEventType.actuacionObraCancelada,
        '${estado == EstadoActuacionObra.completado ? 'Completada' : 'Cancelada'}: ${actuacion.descripcion}',
        referenciaId: actuacion.id,
      );
    });
  }

  void _validarFechas(DateTime? inicio, DateTime? fin, String tipo) {
    if (inicio != null && fin != null && fin.isBefore(inicio)) {
      throw PlanificacionFechasInvalidasException(
        'La fecha de fin $tipo no puede ser anterior al inicio.',
      );
    }
  }

  Future<void> _evento(
    String expedienteId,
    timeline_domain.TimelineEventType tipo,
    String titulo, {
    String? referenciaId,
  }) => _timeline.registrarEvento(
    timeline_domain.TimelineEvent(
      id: _uuid.v4(),
      expedienteId: expedienteId,
      fecha: DateTime.now().toUtc(),
      tipo: tipo,
      titulo: titulo,
      referenciaId: referenciaId,
    ),
  );

  static PlanificacionObra _mapPlanificacion(Expediente row) =>
      PlanificacionObra(
        expedienteId: row.id,
        estado: EstadoOperativoObra.values.byName(row.estadoOperativo),
        inicioPrevisto: row.fechaInicioPrevista,
        finPrevisto: row.fechaFinPrevista,
        inicioReal: row.fechaInicioReal,
        finReal: row.fechaFinReal,
      );

  static ActuacionObra _mapActuacion(ActuacionesObraData row) => ActuacionObra(
    id: row.id,
    expedienteId: row.expedienteId,
    tipo: TipoActuacionObra.values.byName(row.tipo),
    descripcion: row.descripcion,
    fechaPrevista: row.fechaPrevista,
    estado: EstadoActuacionObra.values.byName(row.estado),
    orden: row.orden,
    observaciones: row.observaciones,
  );
}

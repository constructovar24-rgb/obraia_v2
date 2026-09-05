import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../database/app_database.dart';
import '../../timeline/data/timeline_repository.dart';
import '../../timeline/domain/timeline_event.dart' as timeline_domain;
import '../domain/incidencia_obra.dart';

class IncidenciaFechaResolucionInvalida implements Exception {}

class IncidenciasObraRepository {
  IncidenciasObraRepository(this.database)
    : _timeline = TimelineRepository(database.timelineEventsDao);

  final AppDatabase database;
  final TimelineRepository _timeline;
  static const _uuid = Uuid();

  Stream<List<IncidenciaObra>> observarPorObra(String expedienteId) => database
      .incidenciasObraDao
      .observarPorObra(expedienteId)
      .asyncMap((rows) async => Future.wait(rows.map(_map)));

  Future<String> crear({
    required String expedienteId,
    required DateTime fechaDeteccion,
    required String titulo,
    required String descripcion,
    required PrioridadIncidenciaObra prioridad,
    List<String> documentoIds = const [],
    List<String> entradaDiarioIds = const [],
  }) async {
    _validarTexto(titulo, descripcion);
    await _validarRelaciones(expedienteId, documentoIds, entradaDiarioIds);
    final id = _uuid.v4();
    final now = DateTime.now().toUtc();
    await database.transaction(() async {
      await database.incidenciasObraDao.insertar(
        IncidenciasObraCompanion.insert(
          tenantId: database.activeTenantId,
          id: id,
          expedienteId: expedienteId,
          fechaDeteccion: fechaDeteccion,
          titulo: titulo.trim(),
          descripcion: descripcion.trim(),
          prioridad: Value(prioridad.name),
          fechaCreacion: Value(now),
          fechaModificacion: Value(now),
        ),
      );
      await database.incidenciasObraDao.reemplazarDocumentos(id, documentoIds);
      await database.incidenciasObraDao.reemplazarEntradasDiario(
        id,
        entradaDiarioIds,
      );
      await _evento(
        expedienteId,
        id,
        timeline_domain.TimelineEventType.incidenciaObraCreada,
        'Incidencia creada: ${titulo.trim()}',
      );
    });
    return id;
  }

  Future<void> editar({
    required String id,
    required DateTime fechaDeteccion,
    required String titulo,
    required String descripcion,
    required PrioridadIncidenciaObra prioridad,
    required List<String> documentoIds,
    required List<String> entradaDiarioIds,
  }) async {
    final current = await _requerir(id);
    _validarTexto(titulo, descripcion);
    if (current.fechaResolucion != null &&
        current.fechaResolucion!.isBefore(fechaDeteccion)) {
      throw IncidenciaFechaResolucionInvalida();
    }
    await _validarRelaciones(
      current.expedienteId,
      documentoIds,
      entradaDiarioIds,
    );
    await database.transaction(() async {
      await database.incidenciasObraDao.actualizar(
        id,
        IncidenciasObraCompanion(
          fechaDeteccion: Value(fechaDeteccion),
          titulo: Value(titulo.trim()),
          descripcion: Value(descripcion.trim()),
          prioridad: Value(prioridad.name),
          fechaModificacion: Value(DateTime.now().toUtc()),
        ),
      );
      await database.incidenciasObraDao.reemplazarDocumentos(id, documentoIds);
      await database.incidenciasObraDao.reemplazarEntradasDiario(
        id,
        entradaDiarioIds,
      );
    });
  }

  Future<void> cambiarEstado(
    String id,
    EstadoIncidenciaObra estado, {
    DateTime? fechaResolucion,
    String? resolucion,
  }) async {
    final current = await _requerir(id);
    final resolvedAt = estado == EstadoIncidenciaObra.resuelta
        ? fechaResolucion ?? DateTime.now()
        : null;
    if (resolvedAt != null && resolvedAt.isBefore(current.fechaDeteccion)) {
      throw IncidenciaFechaResolucionInvalida();
    }
    final solution = _optional(resolucion);
    await database.transaction(() async {
      await database.incidenciasObraDao.actualizar(
        id,
        IncidenciasObraCompanion(
          estado: Value(estado.name),
          fechaResolucion: Value(resolvedAt),
          resolucion: Value(
            estado == EstadoIncidenciaObra.resuelta ? solution : null,
          ),
          fechaModificacion: Value(DateTime.now().toUtc()),
        ),
      );
      final reabierta =
          current.estado == EstadoIncidenciaObra.resuelta.name &&
          estado != EstadoIncidenciaObra.resuelta;
      final type = reabierta
          ? timeline_domain.TimelineEventType.incidenciaObraReabierta
          : estado == EstadoIncidenciaObra.resuelta
          ? timeline_domain.TimelineEventType.incidenciaObraResuelta
          : estado == EstadoIncidenciaObra.cancelada
          ? timeline_domain.TimelineEventType.incidenciaObraCancelada
          : timeline_domain.TimelineEventType.incidenciaObraEstadoCambiado;
      await _evento(
        current.expedienteId,
        id,
        type,
        'Incidencia ${_estadoLabel(estado)}: ${current.titulo}',
      );
    });
  }

  Future<IncidenciaObra> _map(IncidenciasObraData row) async => IncidenciaObra(
    id: row.id,
    expedienteId: row.expedienteId,
    fechaDeteccion: row.fechaDeteccion,
    titulo: row.titulo,
    descripcion: row.descripcion,
    estado: EstadoIncidenciaObra.values.byName(row.estado),
    prioridad: PrioridadIncidenciaObra.values.byName(row.prioridad),
    fechaResolucion: row.fechaResolucion,
    resolucion: row.resolucion,
    fechaCreacion: row.fechaCreacion,
    fechaModificacion: row.fechaModificacion,
    documentoIds: await database.incidenciasObraDao.obtenerDocumentoIds(row.id),
    entradaDiarioIds: await database.incidenciasObraDao.obtenerEntradaDiarioIds(
      row.id,
    ),
  );

  Future<IncidenciasObraData> _requerir(String id) async {
    final row = await database.incidenciasObraDao.obtener(id);
    if (row == null) throw StateError('La incidencia no existe.');
    return row;
  }

  Future<void> _validarRelaciones(
    String expedienteId,
    Iterable<String> documentoIds,
    Iterable<String> diarioIds,
  ) async {
    for (final id in documentoIds.toSet()) {
      final row = await database.documentosDao.obtenerDocumento(id);
      if (row == null || row.eliminado || row.expedienteId != expedienteId) {
        throw StateError('El documento no pertenece a esta obra.');
      }
    }
    for (final id in diarioIds.toSet()) {
      final row = await database.diarioObraDao.obtener(id);
      if (row == null || row.anulado || row.expedienteId != expedienteId) {
        throw StateError('La entrada de diario no pertenece a esta obra.');
      }
    }
  }

  void _validarTexto(String titulo, String descripcion) {
    if (titulo.trim().isEmpty || descripcion.trim().isEmpty) {
      throw ArgumentError('Título y descripción son obligatorios.');
    }
  }

  Future<void> _evento(
    String expedienteId,
    String id,
    timeline_domain.TimelineEventType type,
    String title,
  ) => _timeline.registrarEvento(
    timeline_domain.TimelineEvent(
      id: _uuid.v4(),
      expedienteId: expedienteId,
      fecha: DateTime.now().toUtc(),
      tipo: type,
      titulo: title,
      referenciaId: id,
    ),
  );

  static String? _optional(String? value) {
    final text = value?.trim();
    return text == null || text.isEmpty ? null : text;
  }

  static String _estadoLabel(EstadoIncidenciaObra estado) => switch (estado) {
    EstadoIncidenciaObra.abierta => 'abierta',
    EstadoIncidenciaObra.enSeguimiento => 'en seguimiento',
    EstadoIncidenciaObra.resuelta => 'resuelta',
    EstadoIncidenciaObra.cancelada => 'cancelada',
  };
}

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../database/app_database.dart';
import '../../timeline/data/timeline_repository.dart';
import '../../timeline/domain/timeline_event.dart' as timeline_domain;
import '../domain/entrada_diario_obra.dart';

class DiarioObraRepository {
  DiarioObraRepository(this.database)
    : _timeline = TimelineRepository(database.timelineEventsDao);

  final AppDatabase database;
  final TimelineRepository _timeline;
  static const _uuid = Uuid();

  Stream<List<EntradaDiarioObra>> observarEntradas(String expedienteId) =>
      database.diarioObraDao
          .observarPorObra(expedienteId)
          .map(
            (rows) => rows
                .map(
                  (row) => EntradaDiarioObra(
                    id: row.entrada.id,
                    expedienteId: row.entrada.expedienteId,
                    fechaTrabajo: row.entrada.fechaTrabajo,
                    trabajos: row.entrada.trabajos,
                    observaciones: row.entrada.observaciones,
                    meteorologia: row.entrada.meteorologia,
                    incidenciaTexto: row.entrada.incidenciaTexto,
                    actuacionId: row.entrada.actuacionId,
                    actuacionDescripcion: row.actuacionDescripcion,
                    anulado: row.entrada.anulado,
                    fechaCreacion: row.entrada.fechaCreacion,
                    fechaModificacion: row.entrada.fechaModificacion,
                  ),
                )
                .toList(growable: false),
          );

  Future<String> crear({
    required String expedienteId,
    required DateTime fechaTrabajo,
    required String trabajos,
    String? observaciones,
    String? meteorologia,
    String? incidenciaTexto,
    String? actuacionId,
  }) async {
    final text = trabajos.trim();
    if (text.isEmpty) throw ArgumentError.value(trabajos, 'trabajos');
    final id = _uuid.v4();
    final now = DateTime.now().toUtc();
    await database.transaction(() async {
      await database.diarioObraDao.insertar(
        DiarioObraCompanion.insert(
          tenantId: database.activeTenantId,
          id: id,
          expedienteId: expedienteId,
          fechaTrabajo: fechaTrabajo,
          trabajos: text,
          observaciones: Value(_optional(observaciones)),
          meteorologia: Value(_optional(meteorologia)),
          incidenciaTexto: Value(_optional(incidenciaTexto)),
          actuacionId: Value(_optional(actuacionId)),
          fechaCreacion: Value(now),
          fechaModificacion: Value(now),
        ),
      );
      await _evento(
        expedienteId,
        id,
        timeline_domain.TimelineEventType.entradaDiarioObraCreada,
        'Entrada de diario creada',
      );
    });
    return id;
  }

  Future<void> editar({
    required String id,
    required DateTime fechaTrabajo,
    required String trabajos,
    String? observaciones,
    String? meteorologia,
    String? incidenciaTexto,
    String? actuacionId,
  }) async {
    final current = await database.diarioObraDao.obtener(id);
    if (current == null || current.anulado) {
      throw StateError('La entrada no existe o está anulada.');
    }
    final text = trabajos.trim();
    if (text.isEmpty) throw ArgumentError.value(trabajos, 'trabajos');
    final count = await database.diarioObraDao.actualizar(
      id,
      DiarioObraCompanion(
        fechaTrabajo: Value(fechaTrabajo),
        trabajos: Value(text),
        observaciones: Value(_optional(observaciones)),
        meteorologia: Value(_optional(meteorologia)),
        incidenciaTexto: Value(_optional(incidenciaTexto)),
        actuacionId: Value(_optional(actuacionId)),
        fechaModificacion: Value(DateTime.now().toUtc()),
      ),
    );
    if (count != 1) throw StateError('No se pudo actualizar la entrada.');
  }

  Future<void> anular(String id) async {
    final current = await database.diarioObraDao.obtener(id);
    if (current == null || current.anulado) {
      throw StateError('La entrada no existe o ya está anulada.');
    }
    await database.transaction(() async {
      final count = await database.diarioObraDao.actualizar(
        id,
        DiarioObraCompanion(
          anulado: const Value(true),
          fechaModificacion: Value(DateTime.now().toUtc()),
        ),
      );
      if (count != 1) throw StateError('No se pudo anular la entrada.');
      await _evento(
        current.expedienteId,
        id,
        timeline_domain.TimelineEventType.entradaDiarioObraAnulada,
        'Entrada de diario anulada',
      );
    });
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
}

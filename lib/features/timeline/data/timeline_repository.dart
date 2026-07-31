import '../../../database/dao/timeline_events_dao.dart';
import '../domain/timeline_event.dart';
import 'timeline_event_mapper.dart';

class TimelineRepository {
  TimelineRepository(this._dao);

  final TimelineEventsDao _dao;

  Future<void> registrarEvento(TimelineEvent event) {
    return _dao.insertar(event.toCompanion());
  }

  Future<List<TimelineEvent>> obtenerEventos(String expedienteId) async {
    final rows = await _dao.obtenerPorExpediente(expedienteId);
    return rows.map((row) => row.toDomain()).toList();
  }

  Stream<List<TimelineEvent>> observarEventos(String expedienteId) {
    return _dao.observarPorExpediente(expedienteId).map(
      (rows) => rows.map((row) => row.toDomain()).toList(),
    );
  }

  Future<void> eliminarEventos(String expedienteId) {
    return _dao.eliminarPorExpediente(expedienteId);
  }
}

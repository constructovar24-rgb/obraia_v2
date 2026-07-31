import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/timeline_events.dart';

part 'timeline_events_dao.g.dart';

@DriftAccessor(tables: [TimelineEvents])
class TimelineEventsDao extends DatabaseAccessor<AppDatabase>
    with _$TimelineEventsDaoMixin {
  TimelineEventsDao(super.db);

  Future<void> insertar(TimelineEventsCompanion event) async {
    await into(timelineEvents).insert(event);
  }

  Future<List<TimelineEvent>> obtenerPorExpediente(
    String expedienteId,
  ) {
    return (select(timelineEvents)
          ..where((t) => t.expedienteId.equals(expedienteId))
          ..orderBy([(t) => OrderingTerm.desc(t.fecha)]))
        .get();
  }

  Stream<List<TimelineEvent>> observarPorExpediente(
    String expedienteId,
  ) {
    return (select(timelineEvents)
          ..where((t) => t.expedienteId.equals(expedienteId))
          ..orderBy([(t) => OrderingTerm.desc(t.fecha)]))
        .watch();
  }

  Future<void> eliminarPorExpediente(
    String expedienteId,
  ) async {
    await (delete(timelineEvents)
          ..where((t) => t.expedienteId.equals(expedienteId)))
        .go();
  }
}

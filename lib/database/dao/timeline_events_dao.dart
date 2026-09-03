import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/timeline_events.dart';

part 'timeline_events_dao.g.dart';

@DriftAccessor(tables: [TimelineEvents])
class TimelineEventsDao extends DatabaseAccessor<AppDatabase>
    with _$TimelineEventsDaoMixin {
  TimelineEventsDao(super.db);

  static const int defaultGlobalLimit = 100;

  Future<void> insertar(TimelineEventsCompanion event) async {
    await into(
      timelineEvents,
    ).insert(event.copyWith(tenantId: Value(attachedDatabase.activeTenantId)));
  }

  Future<List<TimelineEvent>> obtenerRecientesGlobales({
    int limit = defaultGlobalLimit,
  }) {
    return (select(timelineEvents)
          ..where((t) => t.tenantId.equals(attachedDatabase.activeTenantId))
          ..orderBy([(t) => OrderingTerm.desc(t.fecha)])
          ..limit(limit))
        .get();
  }

  Stream<List<TimelineEvent>> observarRecientesGlobales({
    int limit = defaultGlobalLimit,
  }) {
    return (select(timelineEvents)
          ..where((t) => t.tenantId.equals(attachedDatabase.activeTenantId))
          ..orderBy([(t) => OrderingTerm.desc(t.fecha)])
          ..limit(limit))
        .watch();
  }

  Future<List<TimelineEvent>> obtenerTodosLosEventosGlobales() {
    return (select(timelineEvents)
          ..where((t) => t.tenantId.equals(attachedDatabase.activeTenantId))
          ..orderBy([(t) => OrderingTerm.desc(t.fecha)]))
        .get();
  }

  Stream<List<TimelineEvent>> observarTodosLosEventosGlobales() {
    return (select(timelineEvents)
          ..where((t) => t.tenantId.equals(attachedDatabase.activeTenantId))
          ..orderBy([(t) => OrderingTerm.desc(t.fecha)]))
        .watch();
  }

  Future<List<TimelineEvent>> obtenerPorExpediente(String expedienteId) {
    return (select(timelineEvents)
          ..where(
            (t) =>
                t.tenantId.equals(attachedDatabase.activeTenantId) &
                t.expedienteId.equals(expedienteId),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.fecha)]))
        .get();
  }

  Stream<List<TimelineEvent>> observarPorExpediente(String expedienteId) {
    return (select(timelineEvents)
          ..where(
            (t) =>
                t.tenantId.equals(attachedDatabase.activeTenantId) &
                t.expedienteId.equals(expedienteId),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.fecha)]))
        .watch();
  }

  Future<void> eliminarPorExpediente(String expedienteId) async {
    await (delete(timelineEvents)..where(
          (t) =>
              t.tenantId.equals(attachedDatabase.activeTenantId) &
              t.expedienteId.equals(expedienteId),
        ))
        .go();
  }
}

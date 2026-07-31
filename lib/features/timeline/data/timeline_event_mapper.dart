import 'package:drift/drift.dart';

import '../../../database/app_database.dart' as db;
import '../domain/timeline_event.dart';

typedef TimelineEventData = db.TimelineEvent;

extension TimelineEventDataMapper on TimelineEventData {
  TimelineEvent toDomain() {
    return TimelineEvent(
      id: id,
      expedienteId: expedienteId,
      fecha: fecha,
      tipo: TimelineEventType.values.byName(tipo),
      titulo: titulo,
      descripcion: descripcion,
      referenciaId: referenciaId,
    );
  }
}

extension TimelineEventMapper on TimelineEvent {
  db.TimelineEventsCompanion toCompanion() {
    return db.TimelineEventsCompanion(
      id: Value(id),
      expedienteId: Value(expedienteId),
      fecha: Value(fecha),
      tipo: Value(tipo.name),
      titulo: Value(titulo),
      descripcion: Value(descripcion),
      referenciaId: Value(referenciaId),
    );
  }
}

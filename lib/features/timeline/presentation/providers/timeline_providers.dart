import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../database/database_provider.dart';
import '../../data/timeline_repository.dart';
import '../../domain/timeline_event.dart';

final timelineRepositoryProvider = Provider<TimelineRepository>((ref) {
  final database = ref.read(databaseProvider);
  return TimelineRepository(database.timelineEventsDao);
});

final timelineEventsProvider =
    StreamProvider.family<List<TimelineEvent>, String>((ref, expedienteId) {
      final timelineRepository = ref.read(timelineRepositoryProvider);
      return timelineRepository.observarEventos(expedienteId);
    });

final timelineGlobalEventsProvider = StreamProvider<List<TimelineEvent>>((ref) {
  final timelineRepository = ref.read(timelineRepositoryProvider);
  return timelineRepository.observarEventosGlobales();
});

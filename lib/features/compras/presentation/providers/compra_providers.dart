import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../database/database_provider.dart';
import '../../../timeline/data/timeline_repository.dart';
import '../../data/compra_repository.dart';
import '../../domain/compra.dart';

final compraRepositoryProvider = Provider<CompraRepository>((ref) {
  final database = ref.read(databaseProvider);
  return CompraRepository(
    database.comprasDao,
    TimelineRepository(database.timelineEventsDao),
  );
});

final comprasProvider =
    StreamProvider.family<List<Compra>, String>((ref, expedienteId) {
      final compraRepository = ref.read(compraRepositoryProvider);
      return compraRepository.observarCompras(expedienteId);
    });

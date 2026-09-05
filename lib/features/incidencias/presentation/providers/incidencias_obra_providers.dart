import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../database/database_provider.dart';
import '../../data/incidencias_obra_repository.dart';
import '../../domain/incidencia_obra.dart';

final incidenciasObraRepositoryProvider = Provider<IncidenciasObraRepository>((
  ref,
) {
  ref.watch(activeTenantIdProvider);
  return IncidenciasObraRepository(ref.watch(databaseProvider));
});

final incidenciasObraProvider =
    StreamProvider.family<List<IncidenciaObra>, String>((ref, expedienteId) {
      return ref
          .watch(incidenciasObraRepositoryProvider)
          .observarPorObra(expedienteId);
    });

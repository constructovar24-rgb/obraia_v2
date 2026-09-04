import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../database/database_provider.dart';
import '../../data/mano_obra_repository.dart';
import '../../domain/mano_obra.dart';

final manoObraRepositoryProvider = Provider<ManoObraRepository>((ref) {
  ref.watch(activeTenantIdProvider);
  return ManoObraRepository(ref.watch(databaseProvider));
});

final personasLaboralesProvider = StreamProvider<List<PersonaLaboral>>(
  (ref) => ref.watch(manoObraRepositoryProvider).observarPersonas(),
);

final partesTrabajoObraProvider =
    StreamProvider.family<List<ParteTrabajo>, String>(
      (ref, expedienteId) => ref
          .watch(manoObraRepositoryProvider)
          .observarPartesObra(expedienteId),
    );

final resumenManoObraProvider = StreamProvider.family<ResumenManoObra, String>(
  (ref, expedienteId) =>
      ref.watch(manoObraRepositoryProvider).observarResumenObra(expedienteId),
);

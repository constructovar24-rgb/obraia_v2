import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../database/database_provider.dart';
import '../../data/diario_obra_repository.dart';
import '../../domain/entrada_diario_obra.dart';

final diarioObraRepositoryProvider = Provider<DiarioObraRepository>((ref) {
  ref.watch(activeTenantIdProvider);
  return DiarioObraRepository(ref.watch(databaseProvider));
});

final entradasDiarioObraProvider =
    StreamProvider.family<List<EntradaDiarioObra>, String>(
      (ref, id) => ref.watch(diarioObraRepositoryProvider).observarEntradas(id),
    );

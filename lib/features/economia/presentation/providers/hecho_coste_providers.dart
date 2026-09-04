import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../database/database_provider.dart';
import '../../data/hecho_coste_repository.dart';
import '../../domain/hecho_coste.dart';

final hechoCosteRepositoryProvider = Provider<HechoCosteRepository>((ref) {
  ref.watch(activeTenantIdProvider);
  return HechoCosteRepository(ref.watch(databaseProvider));
});

final resumenCosteRealProvider =
    StreamProvider.family<ResumenCosteReal, String>(
      (ref, expedienteId) =>
          ref.watch(hechoCosteRepositoryProvider).observarResumen(expedienteId),
    );

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../database/database_provider.dart';
import '../../data/certificacion_repository.dart';
import '../../domain/certificacion.dart';

final certificacionRepositoryProvider = Provider<CertificacionRepository>((
  ref,
) {
  ref.watch(activeTenantIdProvider);
  final database = ref.watch(databaseProvider);
  return CertificacionRepository(database.certificacionesDao);
});

final certificacionesPorExpedienteProvider =
    StreamProvider.family<List<Certificacion>, String>((ref, expedienteId) {
      final certificacionRepository = ref.watch(
        certificacionRepositoryProvider,
      );
      return certificacionRepository.observarCertificacionesPorExpediente(
        expedienteId,
      );
    });

final certificacionProvider = StreamProvider.family<Certificacion?, String>((
  ref,
  id,
) {
  final certificacionRepository = ref.watch(certificacionRepositoryProvider);
  return certificacionRepository.observarCertificacion(id);
});

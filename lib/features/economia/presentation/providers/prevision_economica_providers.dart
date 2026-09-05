import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../database/database_provider.dart';
import '../../data/prevision_economica_repository.dart';
import '../../domain/prevision_economica.dart';

final previsionEconomicaRepositoryProvider =
    Provider<PrevisionEconomicaRepository>((ref) {
      ref.watch(activeTenantIdProvider);
      return PrevisionEconomicaRepository(ref.watch(databaseProvider));
    });

final resumenForecastProvider =
    FutureProvider.family<ResumenForecastObra, String>((ref, expedienteId) {
      return ref
          .watch(previsionEconomicaRepositoryProvider)
          .obtenerResumen(expedienteId);
    });

final compromisosEconomicosProvider =
    FutureProvider.family<List<CompromisoEconomico>, String>(
      (ref, expedienteId) => ref
          .watch(previsionEconomicaRepositoryProvider)
          .obtenerCompromisos(expedienteId),
    );

final estimacionesCosteRestanteProvider =
    FutureProvider.family<List<EstimacionCosteRestante>, String>(
      (ref, expedienteId) => ref
          .watch(previsionEconomicaRepositoryProvider)
          .obtenerHistorialEstimaciones(expedienteId),
    );

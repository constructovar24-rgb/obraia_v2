import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../database/database_provider.dart';
import '../../data/cierre_economico_repository.dart';
import '../../domain/cierre_economico.dart';

final cierreEconomicoRepositoryProvider = Provider<CierreEconomicoRepository>((
  ref,
) {
  ref.watch(activeTenantIdProvider);
  return CierreEconomicoRepository(ref.watch(databaseProvider));
});

final estadoCierreEconomicoProvider =
    StreamProvider.family<EstadoCierreEconomico, String>(
      (ref, expedienteId) => ref
          .watch(cierreEconomicoRepositoryProvider)
          .observarEstado(expedienteId),
    );

final precheckCierreEconomicoProvider =
    FutureProvider.family<PrecheckCierreEconomico, String>(
      (ref, expedienteId) => ref
          .watch(cierreEconomicoRepositoryProvider)
          .evaluarCierre(expedienteId),
    );

final alertasEconomicasProvider =
    FutureProvider.family<List<AlertaEconomica>, String>(
      (ref, expedienteId) => ref
          .watch(cierreEconomicoRepositoryProvider)
          .obtenerAlertas(expedienteId),
    );

final historialCierresProvider =
    FutureProvider.family<List<CierreEconomicoSnapshot>, String>(
      (ref, expedienteId) => ref
          .watch(cierreEconomicoRepositoryProvider)
          .obtenerHistorial(expedienteId),
    );

final historialReaperturasProvider =
    FutureProvider.family<List<ReaperturaEconomica>, String>(
      (ref, expedienteId) => ref
          .watch(cierreEconomicoRepositoryProvider)
          .obtenerReaperturas(expedienteId),
    );

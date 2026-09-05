import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../database/database_provider.dart';
import '../../data/planificacion_obra_repository.dart';
import '../../domain/planificacion_obra.dart';

final planificacionObraRepositoryProvider =
    Provider<PlanificacionObraRepository>((ref) {
      ref.watch(activeTenantIdProvider);
      return PlanificacionObraRepository(ref.watch(databaseProvider));
    });

final planificacionObraProvider =
    StreamProvider.family<PlanificacionObra?, String>(
      (ref, id) => ref
          .watch(planificacionObraRepositoryProvider)
          .observarPlanificacion(id),
    );

final actuacionesObraProvider =
    StreamProvider.family<List<ActuacionObra>, String>(
      (ref, id) => ref
          .watch(planificacionObraRepositoryProvider)
          .observarActuaciones(id),
    );

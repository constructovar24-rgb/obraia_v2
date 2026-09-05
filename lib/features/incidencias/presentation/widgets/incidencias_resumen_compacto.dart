import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_card.dart';
import '../../domain/incidencia_obra.dart';
import '../providers/incidencias_obra_providers.dart';

class IncidenciasResumenCompacto extends ConsumerWidget {
  const IncidenciasResumenCompacto({
    super.key,
    required this.expedienteId,
    required this.tab,
  });

  final String expedienteId;
  final int tab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rows =
        ref.watch(incidenciasObraProvider(expedienteId)).valueOrNull ??
        const [];
    final active = rows
        .where(
          (row) =>
              row.estado == EstadoIncidenciaObra.abierta ||
              row.estado == EstadoIncidenciaObra.enSeguimiento,
        )
        .toList();
    final hasHigh = active.any(
      (row) => row.prioridad == PrioridadIncidenciaObra.alta,
    );
    return AppCard(
      child: Row(
        children: [
          Icon(
            hasHigh ? Icons.warning_amber_rounded : Icons.report_outlined,
            color: hasHigh ? Theme.of(context).colorScheme.error : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Incidencias',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  active.isEmpty
                      ? 'Sin incidencias abiertas.'
                      : '${active.length} abierta${active.length == 1 ? '' : 's'}${hasHigh ? ' · Hay prioridad alta' : ''}',
                ),
              ],
            ),
          ),
          TextButton(
            key: const ValueKey('ver-incidencias'),
            onPressed: () => DefaultTabController.of(context).animateTo(tab),
            child: const Text('Ver incidencias'),
          ),
        ],
      ),
    );
  }
}

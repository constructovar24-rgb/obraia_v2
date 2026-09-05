import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/recomendacion_operativa.dart';
import '../providers/que_toca_ahora_providers.dart';

class QueTocaAhoraPanel extends ConsumerWidget {
  const QueTocaAhoraPanel({super.key, required this.expedienteId});
  final String expedienteId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(recomendacionesExpedienteProvider(expedienteId));
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('QUÉ TOCA AHORA', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          async.when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) =>
                Text('No se pudieron calcular las recomendaciones: $e'),
            data: (items) {
              if (items.isEmpty) {
                return const Text(
                  'No hay acciones pendientes derivadas de los datos actuales.',
                );
              }
              return Column(
                children: [
                  ...items
                      .take(5)
                      .map(
                        (item) => _RecommendationTile(
                          item: item,
                          onTap: () => _navigate(context, item),
                        ),
                      ),
                  if (items.length > 5)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => showDialog<void>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Qué toca ahora'),
                            content: SizedBox(
                              width: 620,
                              child: ListView(
                                shrinkWrap: true,
                                children: items
                                    .map(
                                      (item) => _RecommendationTile(
                                        item: item,
                                        onTap: () {
                                          Navigator.pop(context);
                                          _navigate(context, item);
                                        },
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cerrar'),
                              ),
                            ],
                          ),
                        ),
                        child: Text('Ver todas (${items.length})'),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  void _navigate(BuildContext context, RecomendacionOperativa item) {
    final index = const {
      'presupuestos': 1,
      'suministros': 2,
      'facturas': 5,
      'economia': 10,
      'planificacion': 11,
      'incidencias': 13,
    }[item.destino];
    if (index != null) DefaultTabController.of(context).animateTo(index);
  }
}

class _RecommendationTile extends StatelessWidget {
  const _RecommendationTile({required this.item, required this.onTap});
  final RecomendacionOperativa item;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final color = switch (item.prioridad) {
      PrioridadRecomendacion.critica => Theme.of(context).colorScheme.error,
      PrioridadRecomendacion.alta => Colors.orange.shade800,
      PrioridadRecomendacion.media => Theme.of(context).colorScheme.primary,
      PrioridadRecomendacion.baja => Theme.of(context).colorScheme.outline,
    };
    return ListTile(
      key: ValueKey('recomendacion-${item.reglaId}'),
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.circle, size: 12, color: color),
      title: Text(item.titulo),
      subtitle: Text(item.explicacion),
      trailing: TextButton(onPressed: onTap, child: Text(item.accion)),
    );
  }
}

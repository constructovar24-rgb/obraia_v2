import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/planificacion_obra.dart';
import '../providers/planificacion_obra_providers.dart';

class PlanificacionResumenCompacto extends ConsumerWidget {
  const PlanificacionResumenCompacto({
    super.key,
    required this.expedienteId,
    required this.tab,
  });
  final String expedienteId;
  final int tab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref
        .watch(planificacionObraProvider(expedienteId))
        .valueOrNull;
    final items =
        ref.watch(actuacionesObraProvider(expedienteId)).valueOrNull ??
        const [];
    final next = items
        .where(
          (a) =>
              a.tipo == TipoActuacionObra.proximoPaso &&
              a.estado == EstadoActuacionObra.pendiente,
        )
        .firstOrNull;
    final upcoming = items
        .where(
          (a) =>
              a.tipo == TipoActuacionObra.actuacion &&
              a.estado == EstadoActuacionObra.pendiente,
        )
        .firstOrNull;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Planificación', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Estado: ${value == null ? 'No disponible' : _label(value.estado)}',
          ),
          Text('Inicio previsto: ${_date(value?.inicioPrevisto)}'),
          Text('Próximo paso: ${next?.descripcion ?? 'No definido'}'),
          Text('Próxima actuación: ${upcoming?.descripcion ?? 'No definida'}'),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              key: const ValueKey('ver-planificacion'),
              onPressed: () => DefaultTabController.of(context).animateTo(tab),
              icon: const Icon(Icons.calendar_month_outlined),
              label: const Text('Ver planificación'),
            ),
          ),
        ],
      ),
    );
  }
}

String _date(DateTime? value) => value == null
    ? 'Sin fecha'
    : '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';
String _label(EstadoOperativoObra value) => switch (value) {
  EstadoOperativoObra.pendiente => 'Pendiente / programación',
  EstadoOperativoObra.preparada => 'Preparada',
  EstadoOperativoObra.enEjecucion => 'En ejecución',
  EstadoOperativoObra.pausada => 'Pausada',
  EstadoOperativoObra.finalizada => 'Finalizada',
  EstadoOperativoObra.cancelada => 'Cancelada',
};

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/timeline_providers.dart';

class TimelinePage extends ConsumerWidget {
  const TimelinePage({
    super.key,
    required this.expedienteId,
  }) : _modo = _TimelinePageMode.porExpediente;

  const TimelinePage.global({
    super.key,
  })  : _modo = _TimelinePageMode.global,
        expedienteId = null;

  final _TimelinePageMode _modo;
  final String? expedienteId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scope = _scope;
    final eventosAsync = ref.watch(timelineFilteredEventsProvider(scope));
    final filtroSeleccionado = ref.watch(timelineSelectedFilterProvider(scope));
    final filtros = ref.watch(timelineFilterOptionsProvider);

    return eventosAsync.when(
      data: (eventos) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('Todos'),
                      selected: filtroSeleccionado == null,
                      onSelected: (_) {
                        ref
                            .read(timelineSelectedFilterProvider(scope).notifier)
                            .state = null;
                      },
                    ),
                    ...filtros.map(
                      (filtro) => ChoiceChip(
                        label: Text(timelineEventTypeLabel(filtro)),
                        selected: filtroSeleccionado == filtro,
                        onSelected: (_) {
                          ref
                              .read(timelineSelectedFilterProvider(scope).notifier)
                              .state = filtro;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: eventos.isEmpty
                  ? Center(
                      child: Text(
                        filtroSeleccionado == null
                            ? 'Todavia no hay eventos.'
                            : 'No hay eventos para el filtro seleccionado.',
                      ),
                    )
                  : ListView.builder(
                      itemCount: eventos.length,
                      itemBuilder: (context, index) {
                        final evento = eventos[index];

                        return ListTile(
                          title: Text(evento.titulo),
                          subtitle: Text(_formatearFecha(evento.fecha)),
                          trailing: Text(timelineEventTypeLabel(evento.tipo)),
                        );
                      },
                    ),
            ),
          ],
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SelectableText(
            'ERROR:\n\n$error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }

  TimelineScope get _scope {
    if (_modo == _TimelinePageMode.global) {
      return const TimelineScope.global();
    }

    return TimelineScope.porExpediente(expedienteId!);
  }

  String _formatearFecha(DateTime fecha) {
    final day = fecha.day.toString().padLeft(2, '0');
    final month = fecha.month.toString().padLeft(2, '0');
    final year = fecha.year.toString();
    final hour = fecha.hour.toString().padLeft(2, '0');
    final minute = fecha.minute.toString().padLeft(2, '0');

    return '$day/$month/$year $hour:$minute';
  }
}

enum _TimelinePageMode {
  porExpediente,
  global,
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/timeline_providers.dart';

class TimelinePage extends ConsumerWidget {
  const TimelinePage({
    super.key,
    required this.expedienteId,
  });

  final String expedienteId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventosAsync = ref.watch(timelineEventsProvider(expedienteId));

    return eventosAsync.when(
      data: (eventos) {
        if (eventos.isEmpty) {
          return const Center(
            child: Text('Todavia no hay eventos.'),
          );
        }

        return ListView.builder(
          itemCount: eventos.length,
          itemBuilder: (context, index) {
            final evento = eventos[index];

            return ListTile(
              title: Text(evento.titulo),
              subtitle: Text(_formatearFecha(evento.fecha)),
              trailing: Text(evento.tipo.name),
            );
          },
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

  String _formatearFecha(DateTime fecha) {
    final day = fecha.day.toString().padLeft(2, '0');
    final month = fecha.month.toString().padLeft(2, '0');
    final year = fecha.year.toString();
    final hour = fecha.hour.toString().padLeft(2, '0');
    final minute = fecha.minute.toString().padLeft(2, '0');

    return '$day/$month/$year $hour:$minute';
  }
}
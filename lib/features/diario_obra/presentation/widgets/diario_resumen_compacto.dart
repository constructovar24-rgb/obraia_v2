import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_card.dart';
import '../providers/diario_obra_providers.dart';

class DiarioResumenCompacto extends ConsumerWidget {
  const DiarioResumenCompacto({
    super.key,
    required this.expedienteId,
    required this.tab,
  });
  final String expedienteId;
  final int tab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries =
        ref.watch(entradasDiarioObraProvider(expedienteId)).valueOrNull ??
        const [];
    final latest = entries.where((entry) => !entry.anulado).firstOrNull;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Diario de obra', style: Theme.of(context).textTheme.titleLarge),
          if (latest == null)
            const Text('Sin entradas registradas.')
          else ...[
            Text(_date(latest.fechaTrabajo)),
            Text(latest.trabajos, maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              key: const ValueKey('ver-diario'),
              onPressed: () => DefaultTabController.of(context).animateTo(tab),
              icon: const Icon(Icons.menu_book_outlined),
              label: const Text('Ver diario'),
            ),
          ),
        ],
      ),
    );
  }
}

String _date(DateTime value) =>
    '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';

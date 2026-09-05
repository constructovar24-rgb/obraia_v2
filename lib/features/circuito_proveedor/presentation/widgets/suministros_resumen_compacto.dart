import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_card.dart';
import '../providers/circuito_proveedor_providers.dart';

class SuministrosResumenCompacto extends ConsumerWidget {
  const SuministrosResumenCompacto({
    super.key,
    required this.expedienteId,
    required this.tab,
  });
  final String expedienteId;
  final int tab;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(senalesSuministrosObraProvider(expedienteId));
    return AppCard(
      child: Row(
        children: [
          const Icon(Icons.local_shipping_outlined),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Compras y suministros',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                async.when(
                  loading: () => const Text('Comprobando situación…'),
                  error: (_, _) => const Text('Situación no disponible'),
                  data: (s) {
                    final alerts = <String>[
                      if (s.albaranesPendientesFactura > 0)
                        '${s.albaranesPendientesFactura} albarán(es) sin factura',
                      if (s.imputacionesPendientesReconciliar > 0)
                        '${s.imputacionesPendientesReconciliar} imputación(es) sin reconciliar',
                      if (s.facturaVencidaPendiente)
                        'Hay pagos de proveedor vencidos',
                    ];
                    return Text(
                      alerts.isEmpty
                          ? 'Sin gestiones pendientes detectadas.'
                          : alerts.join(' · '),
                    );
                  },
                ),
              ],
            ),
          ),
          TextButton(
            key: const ValueKey('ver-suministros'),
            onPressed: () => DefaultTabController.of(context).animateTo(tab),
            child: const Text('Ver suministros'),
          ),
        ],
      ),
    );
  }
}

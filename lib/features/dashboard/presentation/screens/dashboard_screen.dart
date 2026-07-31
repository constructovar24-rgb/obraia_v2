import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/money_text.dart';
import '../../data/dashboard_repository.dart';
import '../../domain/dashboard_resumen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  late final Stream<DashboardResumen> _stream;

  @override
  void initState() {
    super.initState();
    final repository = ref.read(dashboardRepositoryProvider);
    _stream = repository.observarResumen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: StreamBuilder<DashboardResumen>(
        stream: _stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SelectableText(
                  'ERROR:\n\n${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingView(message: 'Cargando resumen...');
          }

          final resumen = snapshot.data;
          if (resumen == null || resumen.isEmpty) {
            return const EmptyState(
              message: 'Todavia no hay datos para mostrar en el dashboard.',
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _SectionCard(
                title: 'Expedientes',
                children: [
                  _CountRow(
                    label: 'Total',
                    value: resumen.numeroExpedientes,
                    emphasize: true,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _SectionCard(
                title: 'Presupuestos',
                children: [
                  _CountRow(
                    label: 'Total',
                    value: resumen.numeroPresupuestos,
                  ),
                  const SizedBox(height: 8),
                  _CountRow(
                    label: 'Pendientes de facturar',
                    value: resumen.presupuestosPendientesFacturar,
                  ),
                  const SizedBox(height: 8),
                  _CountRow(
                    label: 'Facturados',
                    value: resumen.presupuestosFacturados,
                  ),
                  const SizedBox(height: 8),
                  _AmountRow(
                    label: 'Total presupuestado',
                    value: resumen.totalPresupuestado,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _SectionCard(
                title: 'Facturas',
                children: [
                  _CountRow(
                    label: 'Pendientes de cobro',
                    value: resumen.facturasPendientesCobro,
                  ),
                  const SizedBox(height: 8),
                  _CountRow(
                    label: 'Parcialmente cobradas',
                    value: resumen.facturasParcialmenteCobradas,
                  ),
                  const SizedBox(height: 8),
                  _CountRow(
                    label: 'Cobradas',
                    value: resumen.facturasCobradas,
                  ),
                  const SizedBox(height: 8),
                  _AmountRow(
                    label: 'Total facturado',
                    value: resumen.totalFacturado,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _SectionCard(
                title: 'Cobros',
                children: [
                  _AmountRow(
                    label: 'Total cobrado este mes',
                    value: resumen.totalCobradoEsteMes,
                  ),
                  const SizedBox(height: 8),
                  _AmountRow(
                    label: 'Pendiente total',
                    value: resumen.pendienteTotal,
                    emphasize: true,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _CountRow extends StatelessWidget {
  const _CountRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final int value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final valueStyle = emphasize
        ? Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            )
        : Theme.of(context).textTheme.titleMedium;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          '$value',
          style: valueStyle,
        ),
      ],
    );
  }
}

class _AmountRow extends StatelessWidget {
  const _AmountRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final double value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final valueStyle = emphasize
        ? Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            )
        : Theme.of(context).textTheme.titleMedium;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        MoneyText(
          value,
          style: valueStyle,
        ),
      ],
    );
  }
}

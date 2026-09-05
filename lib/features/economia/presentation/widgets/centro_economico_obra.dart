import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/money_text.dart';
import '../../../mano_obra/presentation/providers/mano_obra_providers.dart';
import '../../domain/prevision_economica.dart';
import '../providers/prevision_economica_providers.dart';
import 'prevision_economica_panel.dart';

class CentroEconomicoObra extends ConsumerWidget {
  const CentroEconomicoObra({super.key, required this.expedienteId});
  final String expedienteId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forecast = ref.watch(resumenForecastProvider(expedienteId));
    final labor = ref.watch(resumenManoObraProvider(expedienteId));
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Situación económica',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.xs),
              const Text(
                'Plan original, ejecución real y previsión final de la obra.',
              ),
              const SizedBox(height: AppSpacing.md),
              forecast.when(
                loading: () => const LinearProgressIndicator(),
                error: (error, _) => AppCard(
                  child: Text('No se pudo cargar la economía: $error'),
                ),
                data: (value) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Headline(value: value),
                    const SizedBox(height: AppSpacing.md),
                    _Alerts(
                      value: value,
                      laborPending:
                          labor.valueOrNull?.horasSinValorarDiezMilesimas ?? 0,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _CategoryTable(rows: value.desgloseCategorias),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _LaborCard(expedienteId: expedienteId),
              const SizedBox(height: AppSpacing.md),
              _NavigationCard(expedienteId: expedienteId),
              const SizedBox(height: AppSpacing.md),
              PrevisionEconomicaPanel(expedienteId: expedienteId),
            ],
          ),
        ),
      ),
    );
  }
}

class EconomiaResumenCompacto extends ConsumerWidget {
  const EconomiaResumenCompacto({super.key, required this.expedienteId});
  final String expedienteId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(resumenForecastProvider(expedienteId));
    return AppCard(
      child: value.when(
        loading: () => const LinearProgressIndicator(),
        error: (_, _) => const Text('Situación económica no disponible.'),
        data: (summary) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Economía', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.lg,
              runSpacing: AppSpacing.sm,
              children: [
                _Value('Venta prevista', summary.ventaPlanificadaCentimos),
                _Value(
                  'Coste final estimado',
                  summary.costeFinalEstimadoCentimos,
                ),
                _Value(
                  'Beneficio final',
                  summary.beneficioFinalEstimadoCentimos,
                ),
                _Percent('Margen', summary.margenFinalEstimadoPorcentaje),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                key: const ValueKey('ver-economia-obra'),
                onPressed: () => DefaultTabController.of(context).animateTo(10),
                icon: const Icon(Icons.arrow_forward),
                label: Text('Ver economía · ${_coverage(summary.cobertura)}'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Headline extends StatelessWidget {
  const _Headline({required this.value});
  final ResumenForecastObra value;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final width = constraints.maxWidth >= 960
          ? (constraints.maxWidth - AppSpacing.md * 2) / 3
          : constraints.maxWidth >= 620
          ? (constraints.maxWidth - AppSpacing.md) / 2
          : constraints.maxWidth;
      return Wrap(
        spacing: AppSpacing.md,
        runSpacing: AppSpacing.md,
        children: [
          _Group(
            width: width,
            title: 'Previsto al inicio',
            values: [
              _Value('Venta prevista', value.ventaPlanificadaCentimos),
              _Value('Coste previsto', value.costePlanificadoCentimos),
              _Value('Beneficio previsto', value.beneficioPlanificadoCentimos),
              _Percent('Margen previsto', value.margenPlanificadoPorcentaje),
            ],
          ),
          _Group(
            width: width,
            title: 'Situación actual',
            values: [
              _Value('Coste real', value.costeRealCentimos),
              _Value('Comprometido', value.comprometidoPendienteCentimos),
              _Value('Restante estimado', value.estimacionAdicionalCentimos),
            ],
          ),
          _Group(
            width: width,
            title: 'Previsión final',
            values: [
              _Value('Coste final estimado', value.costeFinalEstimadoCentimos),
              _Value(
                'Beneficio final estimado',
                value.beneficioFinalEstimadoCentimos,
              ),
              _Percent(
                'Margen final estimado',
                value.margenFinalEstimadoPorcentaje,
              ),
              _Value('Desviación de coste', value.desviacionCosteCentimos),
              _Value(
                'Desviación de beneficio',
                value.desviacionBeneficioCentimos,
              ),
              Text('Cobertura: ${_coverage(value.cobertura)}'),
            ],
          ),
        ],
      );
    },
  );
}

class _Group extends StatelessWidget {
  const _Group({
    required this.width,
    required this.title,
    required this.values,
  });
  final double width;
  final String title;
  final List<Widget> values;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: width,
    child: AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const Divider(),
          Wrap(
            spacing: AppSpacing.lg,
            runSpacing: AppSpacing.sm,
            children: values,
          ),
        ],
      ),
    ),
  );
}

class _Value extends StatelessWidget {
  const _Value(this.label, this.cents);
  final String label;
  final int? cents;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 150,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        if (cents == null)
          const Text('No disponible')
        else
          MoneyText(cents! / 100),
      ],
    ),
  );
}

class _Percent extends StatelessWidget {
  const _Percent(this.label, this.value);
  final String label;
  final double? value;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 150,
    child: Text(
      value == null
          ? '$label\nNo disponible'
          : '$label\n${value!.toStringAsFixed(2)} %',
    ),
  );
}

class _Alerts extends StatelessWidget {
  const _Alerts({required this.value, required this.laborPending});
  final ResumenForecastObra value;
  final int laborPending;
  @override
  Widget build(BuildContext context) {
    final messages = <String>[
      if (value.cobertura != CoberturaForecast.completa) 'Forecast incompleto.',
      if (value.forecastSuperaPlan)
        'Coste final estimado superior al previsto.',
      if (value.beneficioNegativo) 'Beneficio final estimado negativo.',
      if (value.margenInferiorAlPlan) 'Margen final inferior al previsto.',
      if ((value.porCategoriaCentimos[null] ?? 0) != 0)
        'Existen costes sin categoría.',
      if (laborPending > 0) 'Existen horas pendientes de valorar.',
      if (value.tieneCompromisosSobreconsumidos)
        'Existe un compromiso sobreconsumido.',
    ];
    if (messages.isEmpty) return const SizedBox.shrink();
    return AppCard(
      highlighted: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: messages.map((message) => Text('• $message')).toList(),
      ),
    );
  }
}

class _CategoryTable extends StatelessWidget {
  const _CategoryTable({required this.rows});
  final List<DesgloseForecastCategoria> rows;
  @override
  Widget build(BuildContext context) => AppCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Desglose por categoría',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppSpacing.sm),
        if (rows.isEmpty)
          const Text('Todavía no existen importes clasificados por categoría.')
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Categoría')),
                DataColumn(label: Text('Previsto'), numeric: true),
                DataColumn(label: Text('Real'), numeric: true),
                DataColumn(label: Text('Comprometido'), numeric: true),
                DataColumn(label: Text('Restante'), numeric: true),
                DataColumn(label: Text('Final'), numeric: true),
                DataColumn(label: Text('Desviación'), numeric: true),
              ],
              rows: rows
                  .map(
                    (row) => DataRow(
                      cells: [
                        DataCell(Text(row.nombre)),
                        DataCell(_money(row.previstoCentimos)),
                        DataCell(_money(row.realCentimos)),
                        DataCell(_money(row.comprometidoCentimos)),
                        DataCell(_money(row.restanteCentimos)),
                        DataCell(_money(row.finalConocidoCentimos)),
                        DataCell(_money(row.desviacionCentimos)),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
      ],
    ),
  );
}

class _LaborCard extends ConsumerWidget {
  const _LaborCard({required this.expedienteId});
  final String expedienteId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labor = ref.watch(resumenManoObraProvider(expedienteId));
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Mano de obra', style: Theme.of(context).textTheme.titleLarge),
          labor.when(
            loading: () => const LinearProgressIndicator(),
            error: (_, _) => const Text('No disponible'),
            data: (value) => Text(
              'Horas: ${(value.horasTotalesDiezMilesimas / 10000).toStringAsFixed(2)} · '
              'valoradas: ${(value.horasValoradasDiezMilesimas / 10000).toStringAsFixed(2)} · '
              'sin valorar: ${(value.horasSinValorarDiezMilesimas / 10000).toStringAsFixed(2)} · '
              'coste ${(value.costeRealCentimos / 100).toStringAsFixed(2)} € · ${value.cobertura.name}',
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => DefaultTabController.of(context).animateTo(3),
              child: const Text('Abrir mano de obra'),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavigationCard extends StatelessWidget {
  const _NavigationCard({required this.expedienteId});
  final String expedienteId;
  @override
  Widget build(BuildContext context) => AppCard(
    child: Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        _go(context, 'Plan / presupuestos', 1),
        _go(context, 'Compras / costes reales', 2),
        _go(context, 'Mano de obra', 3),
        _go(context, 'Facturas y cobros', 5),
      ],
    ),
  );
  Widget _go(BuildContext context, String label, int tab) => OutlinedButton(
    onPressed: () => DefaultTabController.of(context).animateTo(tab),
    child: Text(label),
  );
}

String _coverage(CoberturaForecast value) => switch (value) {
  CoberturaForecast.completa => 'Completa',
  CoberturaForecast.parcial => 'Parcial',
  CoberturaForecast.noDisponible => 'No disponible',
};

Widget _money(int? cents) => Text(
  cents == null ? 'No disponible' : '${(cents / 100).toStringAsFixed(2)} €',
);

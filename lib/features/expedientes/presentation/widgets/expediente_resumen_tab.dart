import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/money_text.dart';
import '../../../certificaciones/presentation/providers/certificacion_providers.dart';
import '../../../documentos/domain/documento.dart';
import '../../../documentos/presentation/providers/documento_providers.dart';
import '../../../economia/presentation/widgets/centro_economico_obra.dart';
import '../../../timeline/presentation/providers/timeline_providers.dart';
import '../../../planificacion/presentation/widgets/planificacion_resumen_compacto.dart';
import '../../../diario_obra/presentation/widgets/diario_resumen_compacto.dart';
import '../../../incidencias/presentation/widgets/incidencias_resumen_compacto.dart';
import '../providers/expediente_workspace_providers.dart';

class ExpedienteResumenTab extends ConsumerWidget {
  const ExpedienteResumenTab({super.key, required this.expedienteId});
  final String expedienteId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final presupuestos = ref.watch(
      expedientePresupuestoResumenProvider(expedienteId),
    );
    final facturas = ref.watch(expedienteFacturaResumenProvider(expedienteId));
    final compras = ref.watch(expedienteCompraResumenProvider(expedienteId));
    final documentos = ref.watch(documentosPorExpedienteProvider(expedienteId));
    final certificaciones = ref.watch(
      certificacionesPorExpedienteProvider(expedienteId),
    );
    final actividad = ref.watch(timelineEventsProvider(expedienteId));
    final documentoItems = documentos.value ?? const [];
    final fotos = documentoItems
        .where((item) => item.tipo == DocumentoTipo.fotografia)
        .length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Resumen administrativo',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              LayoutBuilder(
                builder: (context, constraints) {
                  final cards = <Widget>[
                    _Metric(
                      label: 'Presupuestos',
                      detail:
                          '${presupuestos.value?.cantidad ?? 0} registrados',
                      amount: presupuestos.value?.total,
                      tab: 1,
                    ),
                    _Metric(
                      label: 'Facturado',
                      detail: '${facturas.value?.cantidad ?? 0} documentos',
                      amount: facturas.value?.facturado,
                      tab: 4,
                    ),
                    _Metric(
                      label: 'Cobrado',
                      detail: 'Movimientos registrados',
                      amount: facturas.value?.cobrado,
                      tab: 4,
                    ),
                    _Metric(
                      label: 'Pendiente de cobro',
                      detail: 'Estado económico validado',
                      amount: facturas.value?.pendiente,
                      tab: 4,
                    ),
                    _Metric(
                      label: 'Compras registradas',
                      detail:
                          '${compras.value?.cantidad ?? 0} apuntes de gasto',
                      amount: compras.value?.total,
                      tab: 2,
                    ),
                  ];
                  final width = constraints.maxWidth >= 900
                      ? (constraints.maxWidth - AppSpacing.md * 2) / 3
                      : constraints.maxWidth >= 600
                      ? (constraints.maxWidth - AppSpacing.md) / 2
                      : constraints.maxWidth;
                  return Wrap(
                    spacing: AppSpacing.md,
                    runSpacing: AppSpacing.md,
                    children: cards
                        .map((card) => SizedBox(width: width, child: card))
                        .toList(),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              EconomiaResumenCompacto(expedienteId: expedienteId),
              const SizedBox(height: AppSpacing.lg),
              PlanificacionResumenCompacto(expedienteId: expedienteId, tab: 11),
              const SizedBox(height: AppSpacing.lg),
              DiarioResumenCompacto(expedienteId: expedienteId, tab: 12),
              const SizedBox(height: AppSpacing.lg),
              IncidenciasResumenCompacto(expedienteId: expedienteId, tab: 13),
              const SizedBox(height: AppSpacing.lg),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Operación de la obra',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _Link(
                      icon: Icons.assignment_turned_in_outlined,
                      title: 'Certificaciones',
                      detail:
                          '${certificaciones.value?.length ?? 0} registradas',
                      tab: 3,
                    ),
                    _Link(
                      icon: Icons.insert_drive_file_outlined,
                      title: 'Documentos y fotos',
                      detail:
                          '${documentoItems.length} documentos · $fotos fotografías',
                      tab: 5,
                    ),
                    _Link(
                      icon: Icons.history,
                      title: 'Actividad',
                      detail: '${actividad.value?.length ?? 0} eventos reales',
                      tab: 6,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const AppCard(
                child: Text(
                  'La previsión económica usa el plan aceptado, costes reales, compromisos pendientes y estimaciones explícitas. No sustituye la facturación ni acredita pagos.',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.label,
    required this.detail,
    required this.amount,
    required this.tab,
  });
  final String label;
  final String detail;
  final double? amount;
  final int tab;

  @override
  Widget build(BuildContext context) => AppCard(
    child: InkWell(
      key: ValueKey('expediente-resumen-$label'),
      onTap: () => DefaultTabController.of(context).animateTo(tab),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          if (amount != null)
            MoneyText(
              amount!,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          Text(detail, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    ),
  );
}

class _Link extends StatelessWidget {
  const _Link({
    required this.icon,
    required this.title,
    required this.detail,
    required this.tab,
  });
  final IconData icon;
  final String title;
  final String detail;
  final int tab;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(detail),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => DefaultTabController.of(context).animateTo(tab),
    ),
  );
}

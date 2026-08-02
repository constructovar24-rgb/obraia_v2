import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/shortcuts/app_shortcuts.dart';
import '../../../../core/ui/app_spacing.dart';
import '../../../../core/ui/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/app_page_header.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_section.dart';
import '../../../../core/widgets/money_text.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../cobros/presentation/screens/nuevo_cobro_screen.dart';
import '../../../expedientes/data/expediente_repository.dart';
import '../../../expedientes/domain/expediente.dart' as expediente_domain;
import '../../../expedientes/presentation/screens/nuevo_expediente_screen.dart';
import '../../../facturas/data/factura_repository.dart';
import '../../../facturas/domain/factura.dart' as factura_domain;
import '../../../facturas/presentation/screens/nueva_factura_screen.dart';
import '../../../presupuestos/presentation/screens/nuevo_presupuesto_screen.dart';
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

  String _saludo() {
    final hour = DateTime.now().hour;
    if (hour < 14) {
      return 'Buenos días';
    }
    if (hour < 21) {
      return 'Buenas tardes';
    }
    return 'Buenas noches';
  }

  String _formatearFecha(DateTime fecha) {
    final day = fecha.day.toString().padLeft(2, '0');
    final month = fecha.month.toString().padLeft(2, '0');
    final year = fecha.year.toString();
    return '$day/$month/$year';
  }

  String _formatearPorcentaje(double value) {
    return '${value.toStringAsFixed(1)}%';
  }

  Future<void> _abrirNuevoExpediente() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const NuevoExpedienteScreen(),
      ),
    );
  }

  Future<void> _abrirNuevaFactura() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const NuevaFacturaScreen(),
      ),
    );
  }

  Future<void> _abrirNuevoPresupuesto() async {
    final expediente = await showModalBottomSheet<expediente_domain.Expediente>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final repository = ref.read(expedienteRepositoryProvider);
        return _ExpedienteSelectionSheet(
          stream: repository.observarExpedientes(),
        );
      },
    );

    if (!mounted || expediente == null) {
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NuevoPresupuestoScreen(
          expedienteId: expediente.id,
        ),
      ),
    );
  }

  Future<void> _abrirNuevoCobro() async {
    final factura = await showModalBottomSheet<factura_domain.Factura>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final repository = ref.read(facturaRepositoryProvider);
        return _FacturaSelectionSheet(
          stream: repository.observarFacturas(),
        );
      },
    );

    if (!mounted || factura == null) {
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NuevoCobroScreen(
          facturaId: factura.id,
        ),
      ),
    );
  }

  List<_AttentionItem> _buildAttentionItems(DashboardResumen resumen) {
    final items = <_AttentionItem>[];

    if (resumen.pendienteTotal > 0) {
      items.add(
        _AttentionItem.amount(
          title: 'Pendiente de cobrar',
          description:
              'Hay importe abierto que conviene revisar y convertir en cobro cuanto antes.',
          amount: resumen.pendienteTotal,
          statusLabel: 'Prioridad',
          statusType: StatusType.warning,
          icon: Icons.payments_outlined,
        ),
      );
    }

    if (resumen.presupuestosPendientesFacturar > 0) {
      items.add(
        _AttentionItem.count(
          title: 'Presupuestos pendientes de facturar',
          description:
              'Revisa presupuestos listos para convertirse en factura y acelerar el ciclo de cobro.',
          count: resumen.presupuestosPendientesFacturar,
          statusLabel: 'Seguimiento',
          statusType: StatusType.info,
          icon: Icons.request_quote_outlined,
        ),
      );
    }

    if (resumen.facturasPendientesCobro > 0) {
      items.add(
        _AttentionItem.count(
          title: 'Facturas pendientes de cobro',
          description:
              'Existen facturas sin cobrar que requieren seguimiento comercial o financiero.',
          count: resumen.facturasPendientesCobro,
          statusLabel: 'Atención',
          statusType: StatusType.warning,
          icon: Icons.receipt_long_outlined,
        ),
      );
    }

    if (resumen.facturasParcialmenteCobradas > 0) {
      items.add(
        _AttentionItem.count(
          title: 'Facturas parcialmente cobradas',
          description:
              'Hay cobros iniciados que conviene completar para cerrar pendientes abiertos.',
          count: resumen.facturasParcialmenteCobradas,
          statusLabel: 'En curso',
          statusType: StatusType.info,
          icon: Icons.timeline_outlined,
        ),
      );
    }

    return items;
  }

  List<_AttentionItem> _buildCriticalInsights(DashboardResumen resumen) {
    final items = <_AttentionItem>[
      _AttentionItem.amount(
        title: 'Facturas vencidas',
        description:
            '${resumen.facturasVencidasConteo} facturas con vencimiento superado y saldo pendiente.',
        amount: resumen.facturasVencidasImporte,
        statusLabel: resumen.facturasVencidasConteo > 0 ? 'Critico' : 'Controlado',
        statusType: resumen.facturasVencidasConteo > 0
            ? StatusType.error
            : StatusType.success,
        icon: Icons.warning_amber_outlined,
      ),
      _AttentionItem.count(
        title: 'Vencen en 7 días',
        description:
            'Facturas pendientes de cobro con vencimiento en la próxima semana.',
        count: resumen.facturasVencenProximos7Dias,
        statusLabel:
            resumen.facturasVencenProximos7Dias > 0 ? 'Seguimiento' : 'Sin riesgo',
        statusType: resumen.facturasVencenProximos7Dias > 0
            ? StatusType.warning
            : StatusType.success,
        icon: Icons.event_available_outlined,
      ),
      _AttentionItem.count(
        title: 'Presupuestos pendientes de facturar',
        description:
            'Presupuestos que aún no se han convertido en factura.',
        count: resumen.presupuestosPendientesFacturar,
        statusLabel:
            resumen.presupuestosPendientesFacturar > 0 ? 'Acción' : 'Al día',
        statusType: resumen.presupuestosPendientesFacturar > 0
            ? StatusType.info
            : StatusType.success,
        icon: Icons.request_quote_outlined,
      ),
        _AttentionItem.amount(
        title: 'Backlog comercial',
        description:
          '${resumen.presupuestosBacklogComercialConteo} presupuestos sin facturar con antigüedad de 60 días o más.',
        amount: resumen.presupuestosBacklogComercialImporte,
        statusLabel:
          resumen.presupuestosBacklogComercialConteo > 0 ? 'Seguimiento' : 'Controlado',
        statusType: resumen.presupuestosBacklogComercialConteo > 0
          ? StatusType.warning
          : StatusType.success,
        icon: Icons.work_history_outlined,
        ),
        _AttentionItem.count(
          title: 'Expedientes sin actividad',
          description:
              '${resumen.expedientesSinActividadConteo} expedientes sin eventos en los últimos 60 días o sin eventos registrados.',
          count: resumen.expedientesSinActividadConteo,
          statusLabel:
              resumen.expedientesSinActividadConteo > 0 ? 'Seguimiento' : 'Controlado',
          statusType: resumen.expedientesSinActividadConteo > 0
              ? StatusType.warning
              : StatusType.success,
          icon: Icons.hourglass_disabled_outlined,
        ),
    ];

    return items;
  }

  double _cardWidth(double maxWidth, {required int columns}) {
    final spacing = AppSpacing.sm * (columns - 1);
    return (maxWidth - spacing) / columns;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = AppTypography.textTheme(colorScheme);

    return AppShortcutScope(
      onBack: () => Navigator.maybePop(context),
      onNew: _abrirNuevoExpediente,
      child: Scaffold(
        appBar: const AppPageHeader(
          title: 'Dashboard',
          showBackButton: true,
        ),
        body: StreamBuilder<DashboardResumen>(
          stream: _stream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return AppErrorState(
                message: 'ERROR:\n\n${snapshot.error}',
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const AppLoading(
                message: 'Cargando dashboard...',
              );
            }

            final resumen = snapshot.data;
            if (resumen == null) {
              return AppEmptyState(
                icon: Icons.dashboard_outlined,
                title: 'Todavía no hay información disponible',
                subtitle:
                    'Empieza creando un expediente para activar el panel principal de ObraIA.',
                actionLabel: 'Nuevo expediente',
                onAction: _abrirNuevoExpediente,
              );
            }

            final attentionItems = _buildAttentionItems(resumen);
            final criticalInsights = _buildCriticalInsights(resumen);

            return LayoutBuilder(
              builder: (context, constraints) {
                return Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1180),
                    child: ListView(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      children: [
                        AppCard(
                          highlighted: true,
                          padding: const EdgeInsets.all(AppSpacing.xl),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${_saludo()}, este es el estado actual de ObraIA.',
                                          style: textTheme.headlineMedium,
                                        ),
                                        const SizedBox(height: AppSpacing.xs),
                                        Text(
                                          'Fecha: ${_formatearFecha(DateTime.now())}',
                                          style: textTheme.bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  StatusChip(
                                    label: attentionItems.isEmpty
                                        ? 'Operativa estable'
                                        : 'Revisar alertas',
                                    type: attentionItems.isEmpty
                                        ? StatusType.success
                                        : StatusType.warning,
                                    icon: attentionItems.isEmpty
                                        ? Icons.check_circle_outline
                                        : Icons.priority_high,
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              Text(
                                'Resumen ejecutivo del negocio para actuar rápido sobre expedientes, presupuestos, facturas y cobros.',
                                style: textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AppSection(
                          title: 'Acciones rápidas',
                          subtitle:
                              'Accede a las tareas de alta más habituales sin salir del dashboard.',
                          child: LayoutBuilder(
                            builder: (context, sectionConstraints) {
                              final columns = sectionConstraints.maxWidth >= 1000
                                  ? 6
                                  : sectionConstraints.maxWidth >= 640
                                      ? 2
                                      : 1;
                              final buttonWidth = columns == 1
                                  ? sectionConstraints.maxWidth
                                  : _cardWidth(
                                      sectionConstraints.maxWidth,
                                      columns: columns,
                                    );

                              return Wrap(
                                spacing: AppSpacing.sm,
                                runSpacing: AppSpacing.sm,
                                children: [
                                  SizedBox(
                                    width: buttonWidth,
                                    child: AppPrimaryButton(
                                      label: 'Nuevo expediente',
                                      icon: Icons.folder_copy_outlined,
                                      onPressed: _abrirNuevoExpediente,
                                    ),
                                  ),
                                  SizedBox(
                                    width: buttonWidth,
                                    child: AppPrimaryButton(
                                      label: 'Nuevo presupuesto',
                                      icon: Icons.request_quote_outlined,
                                      onPressed: _abrirNuevoPresupuesto,
                                    ),
                                  ),
                                  SizedBox(
                                    width: buttonWidth,
                                    child: AppPrimaryButton(
                                      label: 'Nueva factura',
                                      icon: Icons.receipt_long_outlined,
                                      onPressed: _abrirNuevaFactura,
                                    ),
                                  ),
                                  SizedBox(
                                    width: buttonWidth,
                                    child: AppPrimaryButton(
                                      label: 'Registrar cobro',
                                      icon: Icons.payments_outlined,
                                      onPressed: _abrirNuevoCobro,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AppSection(
                          title: 'Qué requiere mi atención',
                          subtitle:
                              'Prioriza lo que impacta antes en facturación y cobro.',
                          child: attentionItems.isEmpty
                              ? AppCard(
                                  highlighted: true,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          color: colorScheme.primaryContainer,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.check_circle_outline,
                                          color: colorScheme.onPrimaryContainer,
                                        ),
                                      ),
                                      const SizedBox(width: AppSpacing.md),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'No hay alertas prioritarias ahora mismo',
                                              style: textTheme.titleMedium,
                                            ),
                                            const SizedBox(
                                              height: AppSpacing.xs,
                                            ),
                                            Text(
                                              'El pipeline está estable y no hay pendientes urgentes que destaquen sobre el resto.',
                                              style: textTheme.bodyMedium,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: AppSpacing.sm),
                                      const StatusChip(
                                        label: 'OK',
                                        type: StatusType.success,
                                      ),
                                    ],
                                  ),
                                )
                              : Column(
                                  children: [
                                    for (var index = 0;
                                        index < attentionItems.length;
                                        index++) ...[
                                      _AttentionCard(item: attentionItems[index]),
                                      if (index < attentionItems.length - 1)
                                        const SizedBox(height: AppSpacing.sm),
                                    ],
                                  ],
                                ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AppSection(
                          title: 'Insights críticos',
                          subtitle:
                              'Alertas clave para actuar en vencimientos y conversión de presupuestos.',
                          child: Column(
                            children: [
                              for (var index = 0;
                                  index < criticalInsights.length;
                                  index++) ...[
                                _AttentionCard(item: criticalInsights[index]),
                                if (index < criticalInsights.length - 1)
                                  const SizedBox(height: AppSpacing.sm),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AppSection(
                          title: 'KPIs financieros',
                          subtitle:
                              'Indicadores económicos clave para entender la tracción del mes y la caja pendiente.',
                          child: LayoutBuilder(
                            builder: (context, sectionConstraints) {
                              final columns = sectionConstraints.maxWidth >= 1000
                                  ? 4
                                  : sectionConstraints.maxWidth >= 640
                                      ? 2
                                      : 1;
                              final itemWidth = columns == 1
                                  ? sectionConstraints.maxWidth
                                  : _cardWidth(
                                      sectionConstraints.maxWidth,
                                      columns: columns,
                                    );

                              return Wrap(
                                spacing: AppSpacing.sm,
                                runSpacing: AppSpacing.sm,
                                children: [
                                  SizedBox(
                                    width: itemWidth,
                                    child: _KpiCard(
                                      title: 'Cobertura de cobro',
                                      subtitle: 'Porcentaje cobrado sobre facturado',
                                      value: Text(
                                        _formatearPorcentaje(
                                          resumen.coberturaCobroPorcentaje,
                                        ),
                                        style: textTheme.headlineSmall,
                                      ),
                                      statusLabel: 'Salud financiera',
                                      statusType: StatusType.info,
                                      icon: Icons.show_chart_outlined,
                                    ),
                                  ),
                                  SizedBox(
                                    width: itemWidth,
                                    child: _KpiCard(
                                      title: 'Conversión presupuesto->factura',
                                      subtitle: 'Porcentaje de presupuestos facturados',
                                      value: Text(
                                        _formatearPorcentaje(
                                          resumen
                                              .conversionPresupuestosFacturasPorcentaje,
                                        ),
                                        style: textTheme.headlineSmall,
                                      ),
                                      statusLabel: 'Conversión',
                                      statusType: StatusType.info,
                                      icon: Icons.swap_horiz_outlined,
                                    ),
                                  ),
                                  SizedBox(
                                    width: itemWidth,
                                    child: _KpiCard(
                                      title: 'Pendiente de cobrar',
                                      subtitle: 'Importe actualmente abierto',
                                      value: MoneyText(
                                        resumen.pendienteTotal,
                                        style: textTheme.headlineSmall,
                                      ),
                                      statusLabel: resumen.pendienteTotal > 0
                                          ? 'Seguimiento'
                                          : 'Sin pendiente',
                                      statusType: resumen.pendienteTotal > 0
                                          ? StatusType.warning
                                          : StatusType.success,
                                      icon: Icons.account_balance_wallet_outlined,
                                      highlighted: true,
                                    ),
                                  ),
                                  SizedBox(
                                    width: itemWidth,
                                    child: _KpiCard(
                                      title: 'Cobrado este mes',
                                      subtitle: 'Entrada de caja del mes actual',
                                      value: MoneyText(
                                        resumen.totalCobradoEsteMes,
                                        style: textTheme.headlineSmall,
                                      ),
                                      statusLabel: 'Mes actual',
                                      statusType: StatusType.info,
                                      icon: Icons.payments_outlined,
                                    ),
                                  ),
                                  SizedBox(
                                    width: itemWidth,
                                    child: _KpiCard(
                                      title: 'Facturado este mes',
                                      subtitle: 'Volumen emitido en el mes actual',
                                      value: MoneyText(
                                        resumen.totalFacturadoEsteMes,
                                        style: textTheme.headlineSmall,
                                      ),
                                      statusLabel: 'Mes actual',
                                      statusType: StatusType.info,
                                      icon: Icons.receipt_long_outlined,
                                    ),
                                  ),
                                  SizedBox(
                                    width: itemWidth,
                                    child: _KpiCard(
                                      title: 'Total presupuestado',
                                      subtitle: 'Presupuestos acumulados',
                                      value: MoneyText(
                                        resumen.totalPresupuestado,
                                        style: textTheme.headlineSmall,
                                      ),
                                      statusLabel: 'Acumulado',
                                      statusType: StatusType.neutral,
                                      icon: Icons.request_quote_outlined,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AppSection(
                          title: 'Estado de la empresa',
                          subtitle:
                              'Vista de volumen actual por entidades principales del ERP.',
                          child: LayoutBuilder(
                            builder: (context, sectionConstraints) {
                              final columns = sectionConstraints.maxWidth >= 900
                                  ? 3
                                  : 1;
                              final itemWidth = columns == 1
                                  ? sectionConstraints.maxWidth
                                  : _cardWidth(
                                      sectionConstraints.maxWidth,
                                      columns: columns,
                                    );

                              return Wrap(
                                spacing: AppSpacing.sm,
                                runSpacing: AppSpacing.sm,
                                children: [
                                  SizedBox(
                                    width: itemWidth,
                                    child: _EntityStateCard(
                                      title: 'Expedientes',
                                      value: resumen.numeroExpedientes,
                                      description:
                                          'Base operativa activa del negocio.',
                                      icon: Icons.folder_copy_outlined,
                                      statusLabel: resumen.numeroExpedientes == 0
                                          ? 'Vacío'
                                          : 'Activo',
                                      statusType: resumen.numeroExpedientes == 0
                                          ? StatusType.neutral
                                          : StatusType.success,
                                    ),
                                  ),
                                  SizedBox(
                                    width: itemWidth,
                                    child: _EntityStateCard(
                                      title: 'Presupuestos',
                                      value: resumen.numeroPresupuestos,
                                      description:
                                          '${resumen.presupuestosPendientesFacturar} pendientes de facturar.',
                                      icon: Icons.request_quote_outlined,
                                      statusLabel:
                                          resumen.presupuestosPendientesFacturar > 0
                                              ? 'Seguimiento'
                                              : 'Al día',
                                      statusType:
                                          resumen.presupuestosPendientesFacturar > 0
                                              ? StatusType.warning
                                              : StatusType.success,
                                    ),
                                  ),
                                  SizedBox(
                                    width: itemWidth,
                                    child: _EntityStateCard(
                                      title: 'Facturas',
                                      value: resumen.numeroFacturas,
                                      description:
                                          '${resumen.facturasPendientesCobro} pendientes y ${resumen.facturasParcialmenteCobradas} parciales.',
                                      icon: Icons.receipt_long_outlined,
                                      statusLabel: resumen.facturasPendientesCobro > 0
                                          ? 'Cobro pendiente'
                                          : 'Controlado',
                                      statusType: resumen.facturasPendientesCobro > 0
                                          ? StatusType.warning
                                          : StatusType.success,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.statusLabel,
    required this.statusType,
    required this.icon,
    this.highlighted = false,
  });

  final String title;
  final String subtitle;
  final Widget value;
  final String statusLabel;
  final StatusType statusType;
  final IconData icon;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = AppTypography.textTheme(colorScheme);

    return AppCard(
      highlighted: highlighted,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              const Spacer(),
              StatusChip(
                label: statusLabel,
                type: statusType,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            style: textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            subtitle,
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          value,
        ],
      ),
    );
  }
}

class _EntityStateCard extends StatelessWidget {
  const _EntityStateCard({
    required this.title,
    required this.value,
    required this.description,
    required this.icon,
    required this.statusLabel,
    required this.statusType,
  });

  final String title;
  final int value;
  final String description;
  final IconData icon;
  final String statusLabel;
  final StatusType statusType;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = AppTypography.textTheme(colorScheme);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              const Spacer(),
              StatusChip(
                label: statusLabel,
                type: statusType,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            style: textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '$value',
            style: textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            description,
            style: textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _AttentionCard extends StatelessWidget {
  const _AttentionCard({
    required this.item,
  });

  final _AttentionItem item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = AppTypography.textTheme(colorScheme);

    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              item.icon,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    StatusChip(
                      label: item.statusLabel,
                      type: item.statusType,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  item.description,
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                item.trailing,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AttentionItem {
  const _AttentionItem({
    required this.title,
    required this.description,
    required this.trailing,
    required this.statusLabel,
    required this.statusType,
    required this.icon,
  });

  factory _AttentionItem.amount({
    required String title,
    required String description,
    required double amount,
    required String statusLabel,
    required StatusType statusType,
    required IconData icon,
  }) {
    return _AttentionItem(
      title: title,
      description: description,
      trailing: MoneyText(amount),
      statusLabel: statusLabel,
      statusType: statusType,
      icon: icon,
    );
  }

  factory _AttentionItem.count({
    required String title,
    required String description,
    required int count,
    required String statusLabel,
    required StatusType statusType,
    required IconData icon,
  }) {
    return _AttentionItem(
      title: title,
      description: description,
      trailing: Text(
        '$count',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      statusLabel: statusLabel,
      statusType: statusType,
      icon: icon,
    );
  }

  final String title;
  final String description;
  final Widget trailing;
  final String statusLabel;
  final StatusType statusType;
  final IconData icon;
}

class _ExpedienteSelectionSheet extends StatelessWidget {
  const _ExpedienteSelectionSheet({
    required this.stream,
  });

  final Stream<List<expediente_domain.Expediente>> stream;

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTypography.textTheme(Theme.of(context).colorScheme);

    return SafeArea(
      child: FractionallySizedBox(
        heightFactor: 0.85,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selecciona un expediente',
                style: textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'El nuevo presupuesto se creará dentro del expediente elegido.',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: StreamBuilder<List<expediente_domain.Expediente>>(
                  stream: stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return AppErrorState(
                        message: 'ERROR:\n\n${snapshot.error}',
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const AppLoading(
                        message: 'Cargando expedientes...',
                      );
                    }

                    final expedientes = snapshot.data ?? const [];

                    if (expedientes.isEmpty) {
                      return const AppEmptyState(
                        icon: Icons.folder_outlined,
                        title: 'Todavía no hay expedientes',
                        subtitle:
                            'Crea un expediente antes de registrar un presupuesto desde el dashboard.',
                      );
                    }

                    return ListView.separated(
                      itemCount: expedientes.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final expediente = expedientes[index];
                        final cliente =
                            expediente.clienteNombre?.trim().isNotEmpty == true
                                ? expediente.clienteNombre!.trim()
                                : 'Sin cliente';

                        return AppCard(
                          onTap: () => Navigator.of(context).pop(expediente),
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.all(AppSpacing.sm),
                            leading: const Icon(Icons.folder_copy_outlined),
                            title: Text(expediente.codigo),
                            subtitle: Text(
                              '${expediente.nombre}\nCliente: $cliente',
                              style: textTheme.bodyMedium,
                            ),
                            isThreeLine: true,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FacturaSelectionSheet extends StatelessWidget {
  const _FacturaSelectionSheet({
    required this.stream,
  });

  final Stream<List<factura_domain.Factura>> stream;

  String _formatearFecha(DateTime fecha) {
    final day = fecha.day.toString().padLeft(2, '0');
    final month = fecha.month.toString().padLeft(2, '0');
    final year = fecha.year.toString();
    return '$day/$month/$year';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTypography.textTheme(Theme.of(context).colorScheme);

    return SafeArea(
      child: FractionallySizedBox(
        heightFactor: 0.85,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selecciona una factura',
                style: textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'El cobro se registrará sobre la factura elegida.',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: StreamBuilder<List<factura_domain.Factura>>(
                  stream: stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return AppErrorState(
                        message: 'ERROR:\n\n${snapshot.error}',
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const AppLoading(
                        message: 'Cargando facturas...',
                      );
                    }

                    final facturas = snapshot.data ?? const [];

                    if (facturas.isEmpty) {
                      return const AppEmptyState(
                        icon: Icons.receipt_long_outlined,
                        title: 'Todavía no hay facturas',
                        subtitle:
                            'Crea una factura antes de registrar cobros desde el dashboard.',
                      );
                    }

                    return ListView.separated(
                      itemCount: facturas.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final factura = facturas[index];
                        final cliente = factura.clienteNombre.trim().isEmpty
                            ? 'Sin cliente'
                            : factura.clienteNombre.trim();

                        return AppCard(
                          onTap: () => Navigator.of(context).pop(factura),
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.all(AppSpacing.sm),
                            leading:
                                const Icon(Icons.receipt_long_outlined),
                            title: Text(factura.codigo),
                            subtitle: Text(
                              'Cliente: $cliente\nFecha: ${_formatearFecha(factura.fecha)}',
                              style: textTheme.bodyMedium,
                            ),
                            trailing: MoneyText(factura.total),
                            isThreeLine: true,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

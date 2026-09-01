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
import '../../../cobros/presentation/screens/cobros_screen.dart';
import '../../../cobros/presentation/screens/nuevo_cobro_screen.dart';
import '../../../expedientes/data/expediente_repository.dart';
import '../../../expedientes/domain/expediente.dart' as expediente_domain;
import '../../../expedientes/presentation/screens/expedientes_screen.dart';
import '../../../expedientes/presentation/screens/nuevo_expediente_screen.dart';
import '../../../facturas/data/factura_repository.dart';
import '../../../facturas/domain/estado_factura.dart';
import '../../../facturas/domain/factura.dart' as factura_domain;
import '../../../facturas/presentation/screens/facturas_screen.dart';
import '../../../facturas/presentation/screens/nueva_factura_screen.dart';
import '../../../presupuestos/presentation/screens/nuevo_presupuesto_screen.dart';
import '../../../presupuestos/presentation/screens/presupuestos_screen.dart';
import '../../data/dashboard_repository.dart';
import '../../domain/dashboard_resumen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key, this.embedded = false, this.summaryStream});

  final bool embedded;
  final Stream<DashboardResumen>? summaryStream;

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  late final Stream<DashboardResumen> _stream;

  @override
  void initState() {
    super.initState();
    _stream =
        widget.summaryStream ??
        ref.read(dashboardRepositoryProvider).observarResumen();
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

  Future<void> _abrirNuevoExpediente() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NuevoExpedienteScreen()),
    );
  }

  Future<void> _abrirExpedientes(ExpedientesInitialFilter initialFilter) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ExpedientesScreen(initialFilter: initialFilter),
      ),
    );
  }

  Future<void> _abrirNuevaFactura() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NuevaFacturaScreen()),
    );
  }

  Future<void> _abrirFacturas(FacturasInitialFilter initialFilter) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FacturasScreen(initialFilter: initialFilter),
      ),
    );
  }

  Future<void> _abrirCobrosDelMesActual() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CobrosScreen.delMesActual()),
    );
  }

  Future<void> _abrirPresupuestos(
    PresupuestosInitialFilter initialFilter,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PresupuestosScreen(initialFilter: initialFilter),
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
        builder: (_) => NuevoPresupuestoScreen(expedienteId: expediente.id),
      ),
    );
  }

  Future<void> _abrirNuevoCobro() async {
    final factura = await showModalBottomSheet<factura_domain.Factura>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final repository = ref.read(facturaRepositoryProvider);
        return _FacturaSelectionSheet(stream: repository.observarFacturas());
      },
    );

    if (!mounted || factura == null) {
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NuevoCobroScreen(facturaId: factura.id),
      ),
    );
  }

  List<_AttentionItem> _buildAttentionItems(DashboardResumen resumen) {
    final items = <_AttentionItem>[];

    if (resumen.facturasVencidasConteo > 0) {
      items.add(
        _AttentionItem.amount(
          title: 'Facturas vencidas',
          description: 'Facturas con vencimiento superado y saldo pendiente.',
          amount: resumen.facturasVencidasImporte,
          statusLabel: 'Critico',
          statusType: StatusType.error,
          icon: Icons.warning_amber_outlined,
          actionLabel: 'Ver facturas',
          onAction: () =>
              _abrirFacturas(const FacturasInitialFilter.vencidas()),
        ),
      );
    }

    if (resumen.facturasVencenProximos7Dias > 0) {
      items.add(
        _AttentionItem.count(
          title: 'Vencen de hoy a 7 días',
          description:
              'Facturas pendientes con vencimiento en la próxima semana.',
          count: resumen.facturasVencenProximos7Dias,
          statusLabel: 'Seguimiento',
          statusType: StatusType.warning,
          icon: Icons.event_available_outlined,
          actionLabel: 'Ver facturas',
          onAction: () =>
              _abrirFacturas(const FacturasInitialFilter.vencenProximos7Dias()),
        ),
      );
    }

    if (resumen.presupuestosPendientesFacturar > 0) {
      items.add(
        _AttentionItem.count(
          title: 'Presupuestos pendientes de facturar',
          description: 'Presupuestos listos para convertir en factura.',
          count: resumen.presupuestosPendientesFacturar,
          statusLabel: 'Seguimiento',
          statusType: StatusType.info,
          icon: Icons.request_quote_outlined,
          actionLabel: 'Ver presupuestos',
          onAction: () => _abrirPresupuestos(
            const PresupuestosInitialFilter.pendientesFacturar(),
          ),
        ),
      );
    }

    if (resumen.facturasParcialmenteCobradas > 0) {
      items.add(
        _AttentionItem.count(
          title: 'Facturas parcialmente cobradas',
          description: 'Cobros iniciados pendientes de completar.',
          count: resumen.facturasParcialmenteCobradas,
          statusLabel: 'En curso',
          statusType: StatusType.info,
          icon: Icons.timeline_outlined,
          actionLabel: 'Ver facturas',
          onAction: () => _abrirFacturas(
            const FacturasInitialFilter.parcialmenteCobradas(),
          ),
        ),
      );
    }

    if (resumen.presupuestosBacklogComercialConteo > 0) {
      items.add(
        _AttentionItem.amount(
          title: 'Backlog comercial',
          description:
              'Presupuestos presentados hace 60 días o más sin factura válida.',
          amount: resumen.presupuestosBacklogComercialImporte,
          statusLabel: 'Seguimiento',
          statusType: StatusType.warning,
          icon: Icons.work_history_outlined,
          actionLabel: 'Ver presupuestos',
          onAction: () => _abrirPresupuestos(
            const PresupuestosInitialFilter.backlogComercial(),
          ),
        ),
      );
    }

    if (resumen.expedientesSinActividadConteo > 0) {
      items.add(
        _AttentionItem.count(
          title: 'Expedientes sin actividad',
          description: 'Expedientes sin eventos en los últimos 60 días.',
          count: resumen.expedientesSinActividadConteo,
          statusLabel: 'Seguimiento',
          statusType: StatusType.warning,
          icon: Icons.hourglass_disabled_outlined,
          actionLabel: 'Ver expedientes',
          onAction: () =>
              _abrirExpedientes(const ExpedientesInitialFilter.sinActividad()),
        ),
      );
    }

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
        appBar: widget.embedded
            ? null
            : const AppPageHeader(title: 'Dashboard', showBackButton: true),
        body: StreamBuilder<DashboardResumen>(
          stream: _stream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return AppErrorState(message: 'ERROR:\n\n${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const AppLoading(message: 'Cargando dashboard...');
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
                          title: 'Qué debo hacer hoy',
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
                                    for (
                                      var index = 0;
                                      index < attentionItems.length;
                                      index++
                                    ) ...[
                                      _AttentionCard(
                                        item: attentionItems[index],
                                      ),
                                      if (index < attentionItems.length - 1)
                                        const SizedBox(height: AppSpacing.sm),
                                    ],
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
                              final columns =
                                  sectionConstraints.maxWidth >= 1000
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
                          title: 'KPIs financieros',
                          subtitle:
                              'Indicadores económicos clave para entender la tracción del mes y la caja pendiente.',
                          child: LayoutBuilder(
                            builder: (context, sectionConstraints) {
                              final columns =
                                  sectionConstraints.maxWidth >= 1000
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
                                      title: 'Cobrado este mes',
                                      subtitle:
                                          'Entrada de caja del mes actual',
                                      value: MoneyText(
                                        resumen.totalCobradoEsteMes,
                                        style: textTheme.headlineSmall,
                                      ),
                                      statusLabel: 'Mes actual',
                                      statusType: StatusType.info,
                                      icon: Icons.payments_outlined,
                                      actionLabel: 'Ver cobros',
                                      onAction: _abrirCobrosDelMesActual,
                                    ),
                                  ),
                                  SizedBox(
                                    width: itemWidth,
                                    child: _KpiCard(
                                      title: 'Facturado este mes',
                                      subtitle:
                                          'Volumen emitido en el mes actual',
                                      value: MoneyText(
                                        resumen.totalFacturadoEsteMes,
                                        style: textTheme.headlineSmall,
                                      ),
                                      statusLabel: 'Mes actual',
                                      statusType: StatusType.info,
                                      icon: Icons.receipt_long_outlined,
                                      actionLabel: 'Ver facturas',
                                      onAction: () => _abrirFacturas(
                                        const FacturasInitialFilter.facturadoEsteMes(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: itemWidth,
                                    child: _KpiCard(
                                      title: 'Saldo pendiente total',
                                      subtitle: 'Importe actualmente abierto',
                                      value: MoneyText(
                                        resumen.saldoPendienteTotal,
                                        style: textTheme.headlineSmall,
                                      ),
                                      statusLabel:
                                          resumen.saldoPendienteTotal > 0
                                          ? 'Seguimiento'
                                          : 'Sin pendiente',
                                      statusType:
                                          resumen.saldoPendienteTotal > 0
                                          ? StatusType.warning
                                          : StatusType.success,
                                      icon:
                                          Icons.account_balance_wallet_outlined,
                                      highlighted: true,
                                      actionLabel: 'Ver facturas',
                                      onAction: () => _abrirFacturas(
                                        const FacturasInitialFilter.saldoPendiente(),
                                      ),
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
                                      statusLabel:
                                          resumen.numeroExpedientes == 0
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
                                          resumen.presupuestosPendientesFacturar >
                                              0
                                          ? 'Seguimiento'
                                          : 'Al día',
                                      statusType:
                                          resumen.presupuestosPendientesFacturar >
                                              0
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
                                      statusLabel:
                                          resumen.facturasPendientesCobro > 0
                                          ? 'Cobro pendiente'
                                          : 'Controlado',
                                      statusType:
                                          resumen.facturasPendientesCobro > 0
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
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String subtitle;
  final Widget value;
  final String statusLabel;
  final StatusType statusType;
  final IconData icon;
  final bool highlighted;
  final String? actionLabel;
  final VoidCallback? onAction;

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
                child: Icon(icon, color: colorScheme.onPrimaryContainer),
              ),
              const Spacer(),
              StatusChip(label: statusLabel, type: statusType),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(title, style: textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(subtitle, style: textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.md),
          value,
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.arrow_forward),
                label: Text(actionLabel!),
              ),
            ),
          ],
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
                child: Icon(icon, color: colorScheme.onPrimaryContainer),
              ),
              const Spacer(),
              StatusChip(label: statusLabel, type: statusType),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(title, style: textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text('$value', style: textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.xs),
          Text(description, style: textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _AttentionCard extends StatelessWidget {
  const _AttentionCard({required this.item});

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
            child: Icon(item.icon, color: colorScheme.onPrimaryContainer),
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
                      child: Text(item.title, style: textTheme.titleMedium),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    StatusChip(label: item.statusLabel, type: item.statusType),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(item.description, style: textTheme.bodyMedium),
                const SizedBox(height: AppSpacing.sm),
                item.trailing,
                if (item.actionLabel != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Builder(
                    builder: (context) {
                      final isEnabled = item.onAction != null;
                      final label = isEnabled
                          ? item.actionLabel!
                          : '${item.actionLabel!} (Próximamente)';

                      return Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: item.onAction,
                          icon: Icon(
                            isEnabled
                                ? Icons.arrow_forward_outlined
                                : Icons.schedule_outlined,
                          ),
                          label: Text(label),
                        ),
                      );
                    },
                  ),
                ],
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
    this.actionLabel,
    this.onAction,
  });

  factory _AttentionItem.amount({
    required String title,
    required String description,
    required double amount,
    required String statusLabel,
    required StatusType statusType,
    required IconData icon,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return _AttentionItem(
      title: title,
      description: description,
      trailing: MoneyText(amount),
      statusLabel: statusLabel,
      statusType: statusType,
      icon: icon,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  factory _AttentionItem.count({
    required String title,
    required String description,
    required int count,
    required String statusLabel,
    required StatusType statusType,
    required IconData icon,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return _AttentionItem(
      title: title,
      description: description,
      trailing: Text(
        '$count',
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
      ),
      statusLabel: statusLabel,
      statusType: statusType,
      icon: icon,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  final String title;
  final String description;
  final Widget trailing;
  final String statusLabel;
  final StatusType statusType;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;
}

class _ExpedienteSelectionSheet extends StatelessWidget {
  const _ExpedienteSelectionSheet({required this.stream});

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
              Text('Selecciona un expediente', style: textTheme.headlineMedium),
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
                            contentPadding: const EdgeInsets.all(AppSpacing.sm),
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
  const _FacturaSelectionSheet({required this.stream});

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
              Text('Selecciona una factura', style: textTheme.headlineMedium),
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
                      return const AppLoading(message: 'Cargando facturas...');
                    }

                    final facturas = (snapshot.data ?? const [])
                        .where(
                          (factura) =>
                              estadoFacturaAdmiteNuevosCobros(factura.estado),
                        )
                        .toList();

                    if (facturas.isEmpty) {
                      return const AppEmptyState(
                        icon: Icons.receipt_long_outlined,
                        title: 'No hay facturas cobrables',
                        subtitle:
                            'Solo las facturas emitidas o vencidas admiten nuevos cobros.',
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
                            contentPadding: const EdgeInsets.all(AppSpacing.sm),
                            leading: const Icon(Icons.receipt_long_outlined),
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

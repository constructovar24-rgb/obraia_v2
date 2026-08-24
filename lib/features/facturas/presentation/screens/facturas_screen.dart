import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/formatters/currency_formatter.dart';
import '../../../../core/formatters/date_formatter.dart';
import '../../../../core/shortcuts/app_shortcuts.dart';
import '../../../../core/ui/app_spacing.dart';
import '../../../../core/ui/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_section.dart';
import '../../../../core/widgets/app_page_header.dart';
import '../../../cobros/domain/factura_estado_economico.dart';
import '../../data/factura_repository.dart';
import '../../domain/estado_factura.dart';
import 'editar_factura_screen.dart';
import 'nueva_factura_screen.dart';

enum FacturasInitialFilterType {
  todas,
  borrador,
  emitida,
  cobrada,
  anulada,
  cliente,
  expediente,
  vencidas,
  vencenProximos7Dias,
  saldoPendiente,
  pendientesCobro,
  parcialmenteCobradas,
  facturadoEsteMes,
}

class FacturasInitialFilter {
  const FacturasInitialFilter._({
    required this.type,
    this.clienteId,
    this.expedienteId,
    this.label,
  });

  const FacturasInitialFilter.todas({String? label})
    : this._(type: FacturasInitialFilterType.todas, label: label);

  const FacturasInitialFilter.borrador({String? label})
    : this._(type: FacturasInitialFilterType.borrador, label: label);

  const FacturasInitialFilter.emitida({String? label})
    : this._(type: FacturasInitialFilterType.emitida, label: label);

  const FacturasInitialFilter.cobrada({String? label})
    : this._(type: FacturasInitialFilterType.cobrada, label: label);

  const FacturasInitialFilter.anulada({String? label})
    : this._(type: FacturasInitialFilterType.anulada, label: label);

  const FacturasInitialFilter.vencidas({String? label})
    : this._(type: FacturasInitialFilterType.vencidas, label: label);

  const FacturasInitialFilter.vencenProximos7Dias({String? label})
    : this._(type: FacturasInitialFilterType.vencenProximos7Dias, label: label);

  const FacturasInitialFilter.saldoPendiente({String? label})
    : this._(type: FacturasInitialFilterType.saldoPendiente, label: label);

  const FacturasInitialFilter.pendientesCobro({String? label})
    : this._(type: FacturasInitialFilterType.pendientesCobro, label: label);

  const FacturasInitialFilter.parcialmenteCobradas({String? label})
    : this._(
        type: FacturasInitialFilterType.parcialmenteCobradas,
        label: label,
      );

  const FacturasInitialFilter.facturadoEsteMes({String? label})
    : this._(type: FacturasInitialFilterType.facturadoEsteMes, label: label);
  const FacturasInitialFilter.cliente({
    required String clienteId,
    String? label,
  }) : this._(
         type: FacturasInitialFilterType.cliente,
         clienteId: clienteId,
         label: label,
       );

  const FacturasInitialFilter.expediente({
    required String expedienteId,
    String? label,
  }) : this._(
         type: FacturasInitialFilterType.expediente,
         expedienteId: expedienteId,
         label: label,
       );

  final FacturasInitialFilterType type;
  final String? clienteId;
  final String? expedienteId;
  final String? label;
}

class FacturasScreen extends ConsumerStatefulWidget {
  const FacturasScreen({super.key, this.initialFilter});

  final FacturasInitialFilter? initialFilter;

  @override
  ConsumerState<FacturasScreen> createState() => _FacturasScreenState();
}

class _FacturasScreenState extends ConsumerState<FacturasScreen> {
  late final FacturaRepository _repository;
  late final Stream<List<FacturaConEstadoEconomico>> _stream;

  @override
  void initState() {
    super.initState();
    _repository = ref.read(facturaRepositoryProvider);

    final initialFilter = widget.initialFilter;
    if (initialFilter == null) {
      _stream = _repository.observarFacturasConEstadoEconomico();
      return;
    }

    switch (initialFilter.type) {
      case FacturasInitialFilterType.cliente:
        final clienteId = initialFilter.clienteId?.trim();
        _stream = clienteId == null || clienteId.isEmpty
            ? _repository.observarFacturasConEstadoEconomico()
            : _repository.observarPorClienteConEstadoEconomico(clienteId);
        break;
      case FacturasInitialFilterType.expediente:
        final expedienteId = initialFilter.expedienteId?.trim();
        _stream = expedienteId == null || expedienteId.isEmpty
            ? _repository.observarFacturasConEstadoEconomico()
            : _repository.observarPorExpedienteConEstadoEconomico(expedienteId);
        break;
      case FacturasInitialFilterType.facturadoEsteMes:
        _stream = _repository.observarFacturadoEnMesConEstadoEconomico(
          DateTime.now(),
        );
        break;
      case FacturasInitialFilterType.todas:
      case FacturasInitialFilterType.borrador:
      case FacturasInitialFilterType.emitida:
      case FacturasInitialFilterType.cobrada:
      case FacturasInitialFilterType.anulada:
      case FacturasInitialFilterType.vencidas:
      case FacturasInitialFilterType.vencenProximos7Dias:
      case FacturasInitialFilterType.saldoPendiente:
      case FacturasInitialFilterType.pendientesCobro:
      case FacturasInitialFilterType.parcialmenteCobradas:
        _stream = _repository.observarFacturasConEstadoEconomico();
        break;
    }
  }

  List<FacturaConEstadoEconomico> _applyInitialFilter(
    List<FacturaConEstadoEconomico> facturas,
  ) {
    final initialFilter = widget.initialFilter;
    if (initialFilter == null) {
      return facturas;
    }

    switch (initialFilter.type) {
      case FacturasInitialFilterType.borrador:
        return facturas
            .where((item) => item.factura.estado == EstadoFactura.borrador)
            .toList();
      case FacturasInitialFilterType.emitida:
        return facturas
            .where((item) => item.factura.estado == EstadoFactura.emitida)
            .toList();
      case FacturasInitialFilterType.cobrada:
        return facturas
            .where((item) => item.factura.estado == EstadoFactura.cobrada)
            .toList();
      case FacturasInitialFilterType.anulada:
        return facturas
            .where((item) => item.factura.estado == EstadoFactura.anulada)
            .toList();
      case FacturasInitialFilterType.vencidas:
        return facturas
            .where((item) => item.estadoEconomico.estaVencida)
            .toList();
      case FacturasInitialFilterType.vencenProximos7Dias:
        return facturas
            .where((item) => item.estadoEconomico.venceEnProximos7Dias)
            .toList();
      case FacturasInitialFilterType.saldoPendiente:
        return facturas
            .where((item) => item.estadoEconomico.tieneSaldoPendiente)
            .toList();
      case FacturasInitialFilterType.pendientesCobro:
        return facturas
            .where((item) => item.estadoEconomico.esPendienteDeCobro)
            .toList();
      case FacturasInitialFilterType.parcialmenteCobradas:
        return facturas
            .where((item) => item.estadoEconomico.esParcialmenteCobrada)
            .toList();
      case FacturasInitialFilterType.todas:
      case FacturasInitialFilterType.cliente:
      case FacturasInitialFilterType.expediente:
      case FacturasInitialFilterType.facturadoEsteMes:
        return facturas;
    }
  }

  String _activeFilterLabel() {
    final initialFilter = widget.initialFilter;
    if (initialFilter == null) {
      return '';
    }

    final customLabel = initialFilter.label?.trim();
    if (customLabel != null && customLabel.isNotEmpty) {
      return customLabel;
    }

    switch (initialFilter.type) {
      case FacturasInitialFilterType.todas:
        return 'Todas';
      case FacturasInitialFilterType.borrador:
        return 'Borrador';
      case FacturasInitialFilterType.emitida:
        return 'Emitida';
      case FacturasInitialFilterType.cobrada:
        return 'Cobrada';
      case FacturasInitialFilterType.anulada:
        return 'Anulada';
      case FacturasInitialFilterType.cliente:
        return 'Cliente';
      case FacturasInitialFilterType.expediente:
        return 'Expediente';
      case FacturasInitialFilterType.vencidas:
        return 'Vencidas';
      case FacturasInitialFilterType.vencenProximos7Dias:
        return 'Vencen en próximos 7 días';
      case FacturasInitialFilterType.saldoPendiente:
        return 'Saldo pendiente';
      case FacturasInitialFilterType.pendientesCobro:
        return 'Pendientes de cobro';
      case FacturasInitialFilterType.parcialmenteCobradas:
        return 'Parcialmente cobradas';
      case FacturasInitialFilterType.facturadoEsteMes:
        return 'Facturado este mes';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = AppTypography.textTheme(colorScheme);

    void abrirNuevaFactura() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const NuevaFacturaScreen()),
      );
    }

    return AppShortcutScope(
      onBack: () {
        Navigator.maybePop(context);
      },
      onNew: abrirNuevaFactura,
      child: Scaffold(
        appBar: const AppPageHeader(title: 'Facturas'),
        body: StreamBuilder<List<FacturaConEstadoEconomico>>(
          stream: _stream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return AppErrorState(message: 'ERROR:\n\n${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const AppLoading(message: 'Cargando facturas...');
            }

            final facturas = snapshot.data ?? const [];
            final facturasFiltradas = _applyInitialFilter(facturas);
            final filtroActivo = _activeFilterLabel();
            final hasInitialFilter = widget.initialFilter != null;

            if (facturasFiltradas.isEmpty) {
              if (hasInitialFilter && facturas.isNotEmpty) {
                return AppEmptyState(
                  icon: Icons.filter_alt_off_outlined,
                  title: 'No hay facturas para este filtro',
                  subtitle: 'Prueba con otro filtro para ver más resultados.',
                  actionLabel: 'Nueva factura',
                  onAction: abrirNuevaFactura,
                );
              }

              return AppEmptyState(
                icon: Icons.receipt_long_outlined,
                title: 'Todavía no hay facturas',
                subtitle: 'Crea la primera factura para empezar a trabajar.',
                actionLabel: 'Nueva factura',
                onAction: abrirNuevaFactura,
              );
            }

            return SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1180),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.md,
                            AppSpacing.md,
                            AppSpacing.md,
                            AppSpacing.sm,
                          ),
                          child: AppCard(
                            padding: const EdgeInsets.all(AppSpacing.xl),
                            highlighted: true,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 52,
                                  height: 52,
                                  decoration: BoxDecoration(
                                    color: colorScheme.primaryContainer,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.receipt_long_outlined,
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
                                        'Facturas',
                                        style: textTheme.headlineMedium,
                                      ),
                                      const SizedBox(height: AppSpacing.xs),
                                      Text(
                                        'Gestiona y abre cada factura desde una vista más clara y ordenada.',
                                        style: textTheme.bodyMedium,
                                      ),
                                      if (hasInitialFilter) ...[
                                        const SizedBox(height: AppSpacing.sm),
                                        Wrap(
                                          spacing: AppSpacing.xs,
                                          children: [
                                            Chip(
                                              avatar: const Icon(
                                                Icons.filter_alt_outlined,
                                                size: 18,
                                              ),
                                              label: Text(
                                                'Filtro activo: $filtroActivo',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                AppPrimaryButton(
                                  label: 'Nueva factura',
                                  icon: Icons.add,
                                  onPressed: abrirNuevaFactura,
                                  expand: false,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.md,
                            AppSpacing.sm,
                            AppSpacing.md,
                            AppSpacing.lg,
                          ),
                          child: AppSection(
                            title: 'Listado de facturas',
                            subtitle:
                                'Selecciona una factura para ver o editar su información.',
                            actionLabel: 'Nueva factura',
                            onAction: abrirNuevaFactura,
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: facturasFiltradas.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: AppSpacing.sm),
                              itemBuilder: (context, index) {
                                final factura =
                                    facturasFiltradas[index].factura;
                                final cliente = factura.clienteNombre.isEmpty
                                    ? 'Sin cliente'
                                    : factura.clienteNombre;

                                return AppCard(
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(
                                      AppSpacing.md,
                                    ),
                                    leading: CircleAvatar(
                                      backgroundColor:
                                          colorScheme.primaryContainer,
                                      foregroundColor:
                                          colorScheme.onPrimaryContainer,
                                      child: const Icon(
                                        Icons.receipt_long_outlined,
                                      ),
                                    ),
                                    title: Text(
                                      factura.codigo,
                                      style: textTheme.titleMedium,
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(
                                        top: AppSpacing.xs,
                                      ),
                                      child: Text(
                                        'Cliente: $cliente\nFecha: ${DateFormatter.formatDdMmYyyy(factura.fecha)}\nEstado: ${estadoFacturaToLabel(factura.estado)}\nTotal: ${CurrencyFormatter.format(factura.total)}',
                                        style: textTheme.bodyMedium,
                                      ),
                                    ),
                                    isThreeLine: true,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => EditarFacturaScreen(
                                            factura: factura,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

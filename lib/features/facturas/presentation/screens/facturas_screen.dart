import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/formatters/date_formatter.dart';
import '../../../../core/shortcuts/app_shortcuts.dart';
import '../../../../core/ui/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/app_page_header.dart';
import '../../../../core/widgets/money_text.dart';
import '../../../../core/widgets/status_chip.dart';
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
  vencida,
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
  const FacturasInitialFilter.vencida({String? label})
    : this._(type: FacturasInitialFilterType.vencida, label: label);
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

enum _TipoFiltro { todos, fac, rect }

class FacturasScreen extends ConsumerStatefulWidget {
  const FacturasScreen({super.key, this.initialFilter});
  final FacturasInitialFilter? initialFilter;
  @override
  ConsumerState<FacturasScreen> createState() => _FacturasScreenState();
}

class _FacturasScreenState extends ConsumerState<FacturasScreen> {
  late final Stream<List<FacturaConEstadoEconomico>> _stream;
  final _searchController = TextEditingController();
  EstadoFactura? _estadoFiltro;
  _TipoFiltro _tipoFiltro = _TipoFiltro.todos;

  @override
  void initState() {
    super.initState();
    final repository = ref.read(facturaRepositoryProvider);
    final initial = widget.initialFilter;
    if (initial?.type == FacturasInitialFilterType.cliente &&
        initial?.clienteId?.trim().isNotEmpty == true) {
      _stream = repository.observarPorClienteConEstadoEconomico(
        initial!.clienteId!,
      );
    } else if (initial?.type == FacturasInitialFilterType.expediente &&
        initial?.expedienteId?.trim().isNotEmpty == true) {
      _stream = repository.observarPorExpedienteConEstadoEconomico(
        initial!.expedienteId!,
      );
    } else if (initial?.type == FacturasInitialFilterType.facturadoEsteMes) {
      _stream = repository.observarFacturadoEnMesConEstadoEconomico(
        DateTime.now(),
      );
    } else {
      _stream = repository.observarFacturasConEstadoEconomico();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<FacturaConEstadoEconomico> _filtrar(
    List<FacturaConEstadoEconomico> items,
  ) {
    final query = _searchController.text.trim().toLowerCase();
    return items.where(_cumpleFiltroInicial).where((item) {
      final factura = item.factura;
      final cumpleEstado =
          _estadoFiltro == null || factura.estado == _estadoFiltro;
      final cumpleTipo = switch (_tipoFiltro) {
        _TipoFiltro.todos => true,
        _TipoFiltro.fac => !factura.esRectificativa,
        _TipoFiltro.rect => factura.esRectificativa,
      };
      final cumpleBusqueda =
          query.isEmpty ||
          [
            factura.codigo,
            factura.clienteNombre,
            factura.clienteNombreHistorico,
            factura.expedienteCodigoHistorico,
            factura.expedienteNombreHistorico,
            factura.presupuestoCodigoHistorico,
          ].any((value) => value.toLowerCase().contains(query));
      return cumpleEstado && cumpleTipo && cumpleBusqueda;
    }).toList();
  }

  bool _cumpleFiltroInicial(FacturaConEstadoEconomico item) {
    final type = widget.initialFilter?.type ?? FacturasInitialFilterType.todas;
    return switch (type) {
      FacturasInitialFilterType.borrador =>
        item.factura.estado == EstadoFactura.borrador,
      FacturasInitialFilterType.emitida =>
        item.factura.estado == EstadoFactura.emitida,
      FacturasInitialFilterType.cobrada =>
        item.factura.estado == EstadoFactura.cobrada,
      FacturasInitialFilterType.anulada =>
        item.factura.estado == EstadoFactura.anulada,
      FacturasInitialFilterType.vencida =>
        item.factura.estado == EstadoFactura.vencida,
      FacturasInitialFilterType.vencidas => item.estadoEconomico.estaVencida,
      FacturasInitialFilterType.vencenProximos7Dias =>
        item.estadoEconomico.venceEnProximos7Dias,
      FacturasInitialFilterType.saldoPendiente =>
        item.estadoEconomico.tieneSaldoPendiente,
      FacturasInitialFilterType.pendientesCobro =>
        item.estadoEconomico.esPendienteDeCobro,
      FacturasInitialFilterType.parcialmenteCobradas =>
        item.estadoEconomico.esParcialmenteCobrada,
      FacturasInitialFilterType.todas ||
      FacturasInitialFilterType.cliente ||
      FacturasInitialFilterType.expediente ||
      FacturasInitialFilterType.facturadoEsteMes => true,
    };
  }

  void _abrirNuevaFactura() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NuevaFacturaScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final initialLabel = widget.initialFilter?.label?.trim();
    return AppShortcutScope(
      onBack: () => Navigator.maybePop(context),
      onNew: _abrirNuevaFactura,
      child: Scaffold(
        appBar: AppPageHeader(
          title: 'Facturas',
          subtitle: initialLabel?.isNotEmpty == true
              ? initialLabel
              : 'Documentos, vencimientos y situación de cobro',
          actions: [
            AppPageHeaderAction(
              icon: Icons.add,
              tooltip: 'Nueva factura',
              onPressed: _abrirNuevaFactura,
            ),
          ],
        ),
        body: StreamBuilder<List<FacturaConEstadoEconomico>>(
          stream: _stream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return AppErrorState(message: 'ERROR:\n\n${snapshot.error}');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const AppLoading(message: 'Cargando facturas...');
            }
            final todas = snapshot.data ?? const [];
            if (todas.isEmpty) {
              return AppEmptyState(
                icon: Icons.receipt_long_outlined,
                title: 'Todavía no hay facturas',
                subtitle: 'Crea la primera factura para empezar a trabajar.',
                actionLabel: 'Nueva factura',
                onAction: _abrirNuevaFactura,
              );
            }
            final filtradas = _filtrar(todas);
            return Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  AppCard(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final compact = constraints.maxWidth < 760;
                        final search = TextField(
                          key: const Key('facturas-search'),
                          controller: _searchController,
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                            labelText: 'Buscar factura, cliente u origen',
                            prefixIcon: Icon(Icons.search),
                          ),
                        );
                        final estado = DropdownButtonFormField<EstadoFactura?>(
                          key: const Key('facturas-estado-filter'),
                          initialValue: _estadoFiltro,
                          decoration: const InputDecoration(
                            labelText: 'Estado documental',
                          ),
                          items: [
                            const DropdownMenuItem(
                              value: null,
                              child: Text('Todos los estados'),
                            ),
                            ...estadosFactura.map(
                              (value) => DropdownMenuItem(
                                value: value,
                                child: Text(estadoFacturaToLabel(value)),
                              ),
                            ),
                          ],
                          onChanged: (value) =>
                              setState(() => _estadoFiltro = value),
                        );
                        final tipo = DropdownButtonFormField<_TipoFiltro>(
                          key: const Key('facturas-tipo-filter'),
                          initialValue: _tipoFiltro,
                          decoration: const InputDecoration(
                            labelText: 'Tipo de documento',
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: _TipoFiltro.todos,
                              child: Text('FAC y RECT'),
                            ),
                            DropdownMenuItem(
                              value: _TipoFiltro.fac,
                              child: Text('Solo FAC'),
                            ),
                            DropdownMenuItem(
                              value: _TipoFiltro.rect,
                              child: Text('Solo RECT'),
                            ),
                          ],
                          onChanged: (value) => setState(
                            () => _tipoFiltro = value ?? _TipoFiltro.todos,
                          ),
                        );
                        if (compact) {
                          return Column(
                            children: [
                              search,
                              const SizedBox(height: AppSpacing.sm),
                              estado,
                              const SizedBox(height: AppSpacing.sm),
                              tipo,
                            ],
                          );
                        }
                        return Row(
                          children: [
                            Expanded(flex: 2, child: search),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(child: estado),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(child: tipo),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${filtradas.length} de ${todas.length} documentos',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Expanded(
                    child: filtradas.isEmpty
                        ? const AppEmptyState(
                            icon: Icons.filter_alt_off_outlined,
                            title: 'No hay coincidencias',
                            subtitle: 'Ajusta la búsqueda o los filtros.',
                          )
                        : AppCard(
                            padding: EdgeInsets.zero,
                            child: ListView.separated(
                              itemCount: filtradas.length,
                              separatorBuilder: (_, _) =>
                                  const Divider(height: 1),
                              itemBuilder: (context, index) =>
                                  _FacturaRow(item: filtradas[index]),
                            ),
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FacturaRow extends StatelessWidget {
  const _FacturaRow({required this.item});
  final FacturaConEstadoEconomico item;

  StatusType get _statusType => switch (item.factura.estado) {
    EstadoFactura.borrador => StatusType.neutral,
    EstadoFactura.emitida => StatusType.info,
    EstadoFactura.cobrada => StatusType.success,
    EstadoFactura.vencida => StatusType.warning,
    EstadoFactura.anulada => StatusType.error,
  };

  @override
  Widget build(BuildContext context) {
    final factura = item.factura;
    final economico = item.estadoEconomico;
    final cliente = factura.clienteNombreHistorico.trim().isNotEmpty
        ? factura.clienteNombreHistorico
        : factura.clienteNombre;
    final expediente = factura.expedienteCodigoHistorico.trim().isEmpty
        ? 'Sin expediente'
        : factura.expedienteCodigoHistorico;
    final codigo = factura.codigo.trim().isEmpty
        ? (factura.esRectificativa ? 'RECT en borrador' : 'FAC en borrador')
        : factura.codigo;
    return InkWell(
      key: Key('factura-row-${factura.id}'),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EditarFacturaScreen(factura: factura),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + AppSpacing.xs,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 820;
            final identity = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    StatusChip(
                      label: factura.esRectificativa ? 'RECT' : 'FAC',
                      type: factura.esRectificativa
                          ? StatusType.warning
                          : StatusType.info,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Flexible(
                      child: Text(
                        codigo,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${cliente.trim().isEmpty ? 'Sin cliente' : cliente} · $expediente',
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            );
            final dates = Text(
              'Fecha ${DateFormatter.formatDdMmYyyy(factura.fecha)}\nVence ${DateFormatter.formatDdMmYyyy(factura.fechaVencimiento)}',
            );
            final amounts = Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _Amount(label: 'Total', value: economico.totalFactura),
                _Amount(label: 'Cobrado', value: economico.totalCobrado),
                _Amount(label: 'Pendiente', value: economico.pendiente),
              ],
            );
            final state = Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                StatusChip(
                  label: estadoFacturaToLabel(factura.estado),
                  type: _statusType,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  estadoEconomicoFacturaToLabel(economico.estado),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            );
            if (compact) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  identity,
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(child: dates),
                      amounts,
                      const SizedBox(width: AppSpacing.md),
                      state,
                    ],
                  ),
                ],
              );
            }
            return Row(
              children: [
                Expanded(flex: 4, child: identity),
                Expanded(flex: 2, child: dates),
                Expanded(flex: 2, child: amounts),
                const SizedBox(width: AppSpacing.lg),
                state,
                const SizedBox(width: AppSpacing.sm),
                const Icon(Icons.chevron_right),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Amount extends StatelessWidget {
  const _Amount({required this.label, required this.value});
  final String label;
  final double value;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text('$label: ', style: Theme.of(context).textTheme.bodySmall),
      MoneyText(value, style: Theme.of(context).textTheme.bodyMedium),
    ],
  );
}

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
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/money_text.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../facturas/data/factura_repository.dart';
import '../../../facturas/domain/estado_factura.dart';
import '../../../facturas/presentation/screens/editar_factura_screen.dart';
import '../../data/cobro_repository.dart';
import '../../domain/cobro.dart' as cobro_domain;
import '../../domain/factura_estado_economico.dart';
import 'editar_cobro_screen.dart';
import 'nuevo_cobro_screen.dart';

enum _CobrosMode { global, factura, mes }

enum _CobrosFilter { todos, pendientes, parciales, cobradas, vencidas }

class CobrosScreen extends ConsumerStatefulWidget {
  const CobrosScreen({
    super.key,
    required this.facturaId,
    required this.facturaCodigo,
    required this.facturaEstado,
    this.facturaTotal,
  }) : _mode = _CobrosMode.factura,
       mes = null;

  const CobrosScreen.global({super.key})
    : _mode = _CobrosMode.global,
      facturaId = null,
      facturaCodigo = null,
      facturaEstado = null,
      facturaTotal = null,
      mes = null;

  CobrosScreen.delMesActual({super.key})
    : _mode = _CobrosMode.mes,
      facturaId = null,
      facturaCodigo = null,
      facturaEstado = null,
      facturaTotal = null,
      mes = DateTime.now();

  final _CobrosMode _mode;
  final String? facturaId;
  final String? facturaCodigo;
  final EstadoFactura? facturaEstado;
  final double? facturaTotal;
  final DateTime? mes;

  @override
  ConsumerState<CobrosScreen> createState() => _CobrosScreenState();
}

class _CobrosScreenState extends ConsumerState<CobrosScreen> {
  Stream<List<cobro_domain.Cobro>>? _movimientosStream;
  Stream<List<FacturaConEstadoEconomico>>? _facturasStream;
  final _searchController = TextEditingController();
  _CobrosFilter _filter = _CobrosFilter.todos;

  @override
  void initState() {
    super.initState();
    if (widget._mode == _CobrosMode.global) {
      _facturasStream = ref
          .read(facturaRepositoryProvider)
          .observarFacturasConEstadoEconomico();
    } else {
      final repository = ref.read(cobroRepositoryProvider);
      _movimientosStream = widget._mode == _CobrosMode.factura
          ? repository.observarPorFactura(widget.facturaId!)
          : repository.observarCobrosEnMesConFactura(widget.mes!);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget._mode == _CobrosMode.global
        ? _buildGlobal(context)
        : _buildMovimientos(context);
  }

  Widget _buildGlobal(BuildContext context) {
    return AppShortcutScope(
      onBack: () => Navigator.maybePop(context),
      child: Scaffold(
        appBar: const AppPageHeader(
          title: 'Cobros',
          subtitle: 'Seguimiento de facturas, vencimientos y saldos',
        ),
        body: StreamBuilder<List<FacturaConEstadoEconomico>>(
          stream: _facturasStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return AppErrorState(message: 'ERROR:\n\n${snapshot.error}');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const AppLoading(
                message: 'Cargando situación de cobros...',
              );
            }
            final operativas = (snapshot.data ?? const [])
                .where(
                  (item) =>
                      !item.factura.esRectificativa &&
                      item.factura.estado != EstadoFactura.borrador &&
                      item.factura.estado != EstadoFactura.anulada,
                )
                .toList();
            if (operativas.isEmpty) {
              return const AppEmptyState(
                icon: Icons.payments_outlined,
                title: 'No hay facturas en seguimiento',
                subtitle:
                    'Las facturas emitidas aparecerán aquí con su situación de cobro.',
              );
            }
            final filtradas = _filtrar(operativas);
            return Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  _buildGlobalFilters(context),
                  const SizedBox(height: AppSpacing.sm),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${filtradas.length} de ${operativas.length} facturas en seguimiento',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Expanded(
                    child: filtradas.isEmpty
                        ? const AppEmptyState(
                            icon: Icons.filter_alt_off_outlined,
                            title: 'No hay coincidencias',
                            subtitle:
                                'Ajusta la búsqueda o el filtro de situación.',
                          )
                        : AppCard(
                            padding: EdgeInsets.zero,
                            child: ListView.separated(
                              itemCount: filtradas.length,
                              separatorBuilder: (_, _) =>
                                  const Divider(height: 1),
                              itemBuilder: (context, index) => _FacturaCobroRow(
                                item: filtradas[index],
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditarFacturaScreen(
                                      factura: filtradas[index].factura,
                                    ),
                                  ),
                                ),
                              ),
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

  Widget _buildGlobalFilters(BuildContext context) {
    final search = TextField(
      key: const Key('cobros-search'),
      controller: _searchController,
      onChanged: (_) => setState(() {}),
      decoration: const InputDecoration(
        labelText: 'Buscar factura, cliente, expediente o presupuesto',
        prefixIcon: Icon(Icons.search),
      ),
    );
    final filter = DropdownButtonFormField<_CobrosFilter>(
      key: const Key('cobros-filter'),
      isExpanded: true,
      initialValue: _filter,
      decoration: const InputDecoration(labelText: 'Situación'),
      items: const [
        DropdownMenuItem(value: _CobrosFilter.todos, child: Text('Todas')),
        DropdownMenuItem(
          value: _CobrosFilter.pendientes,
          child: Text('Pendientes'),
        ),
        DropdownMenuItem(
          value: _CobrosFilter.parciales,
          child: Text('Parcialmente cobradas'),
        ),
        DropdownMenuItem(
          value: _CobrosFilter.cobradas,
          child: Text('Cobradas'),
        ),
        DropdownMenuItem(
          value: _CobrosFilter.vencidas,
          child: Text('Vencidas'),
        ),
      ],
      onChanged: (value) =>
          setState(() => _filter = value ?? _CobrosFilter.todos),
    );
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 720) {
            return Column(
              children: [
                search,
                const SizedBox(height: AppSpacing.sm),
                filter,
              ],
            );
          }
          return Row(
            children: [
              Expanded(flex: 2, child: search),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: filter),
            ],
          );
        },
      ),
    );
  }

  List<FacturaConEstadoEconomico> _filtrar(
    List<FacturaConEstadoEconomico> items,
  ) {
    final query = _searchController.text.trim().toLowerCase();
    return items.where((item) {
      final factura = item.factura;
      final estado = item.estadoEconomico;
      final matchesFilter = switch (_filter) {
        _CobrosFilter.todos => true,
        _CobrosFilter.pendientes => estado.esPendienteDeCobro,
        _CobrosFilter.parciales => estado.esParcialmenteCobrada,
        _CobrosFilter.cobradas =>
          estado.estado == EstadoEconomicoFactura.cobrada,
        _CobrosFilter.vencidas => estado.estaVencida,
      };
      final matchesQuery =
          query.isEmpty ||
          [
            factura.codigo,
            factura.clienteNombre,
            factura.clienteNombreHistorico,
            factura.expedienteCodigoHistorico,
            factura.expedienteNombreHistorico,
            factura.presupuestoCodigoHistorico,
          ].any((value) => value.toLowerCase().contains(query));
      return matchesFilter && matchesQuery;
    }).toList();
  }

  Widget _buildMovimientos(BuildContext context) {
    final porFactura = widget._mode == _CobrosMode.factura;
    final admiteNuevosCobros =
        porFactura &&
        widget.facturaEstado != null &&
        estadoFacturaAdmiteNuevosCobros(widget.facturaEstado!);
    final admiteModificar =
        widget.facturaEstado == null ||
        estadoFacturaAdmiteModificarCobros(widget.facturaEstado!);
    final admiteEliminar =
        widget.facturaEstado == EstadoFactura.anulada || admiteModificar;

    void abrirNuevoCobro() {
      if (widget.facturaId == null) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => NuevoCobroScreen(facturaId: widget.facturaId!),
        ),
      );
    }

    return AppShortcutScope(
      onBack: () => Navigator.maybePop(context),
      onNew: admiteNuevosCobros ? abrirNuevoCobro : null,
      child: Scaffold(
        appBar: AppPageHeader(
          title: porFactura
              ? 'Cobros de ${widget.facturaCodigo}'
              : 'Cobros de este mes',
          subtitle: porFactura
              ? 'Movimientos auditables de la factura'
              : 'Movimientos operativos del periodo',
          showBackButton: true,
        ),
        body: StreamBuilder<List<cobro_domain.Cobro>>(
          stream: _movimientosStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return AppErrorState(message: 'ERROR:\n\n${snapshot.error}');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const AppLoading(message: 'Cargando cobros...');
            }
            final movimientos = snapshot.data ?? const [];
            return Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  if (porFactura && widget.facturaTotal != null)
                    _ResumenFacturaCobros(
                      facturaId: widget.facturaId!,
                      total: widget.facturaTotal!,
                    ),
                  if (porFactura && widget.facturaTotal != null)
                    const SizedBox(height: AppSpacing.sm),
                  Expanded(
                    child: movimientos.isEmpty
                        ? AppEmptyState(
                            icon: Icons.payments_outlined,
                            title: porFactura
                                ? 'Todavía no hay movimientos'
                                : 'No hay cobros este mes',
                            subtitle: admiteNuevosCobros
                                ? 'Registra el primer cobro de esta factura.'
                                : 'No existen movimientos para este contexto.',
                            actionLabel: admiteNuevosCobros
                                ? 'Nuevo cobro'
                                : null,
                            onAction: admiteNuevosCobros
                                ? abrirNuevoCobro
                                : null,
                          )
                        : AppCard(
                            padding: EdgeInsets.zero,
                            child: ListView.separated(
                              itemCount: movimientos.length,
                              separatorBuilder: (_, _) =>
                                  const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final movimiento = movimientos[index];
                                return _MovimientoRow(
                                  movimiento: movimiento,
                                  onTap: admiteEliminar
                                      ? () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => EditarCobroScreen(
                                              cobro: movimiento,
                                              facturaEstado:
                                                  widget.facturaEstado,
                                            ),
                                          ),
                                        )
                                      : null,
                                );
                              },
                            ),
                          ),
                  ),
                  if (admiteNuevosCobros) ...[
                    const SizedBox(height: AppSpacing.sm),
                    AppPrimaryButton(
                      onPressed: abrirNuevoCobro,
                      label: 'Registrar cobro',
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FacturaCobroRow extends StatelessWidget {
  const _FacturaCobroRow({required this.item, required this.onTap});
  final FacturaConEstadoEconomico item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final factura = item.factura;
    final estado = item.estadoEconomico;
    final cliente = factura.clienteNombreHistorico.trim().isNotEmpty
        ? factura.clienteNombreHistorico
        : factura.clienteNombre;
    return InkWell(
      key: Key('cobros-factura-${factura.id}'),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + AppSpacing.xs,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final info = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  factura.codigo,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${cliente.trim().isEmpty ? 'Sin cliente' : cliente} · ${factura.expedienteCodigoHistorico.trim().isEmpty ? 'Sin expediente' : factura.expedienteCodigoHistorico}',
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            );
            final importes = Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _Amount(label: 'Total', value: estado.totalFactura),
                _Amount(label: 'Cobrado', value: estado.totalCobrado),
                _Amount(label: 'Pendiente', value: estado.pendiente),
              ],
            );
            final status = StatusChip(
              label: estadoEconomicoFacturaToLabel(estado.estado),
              type: estado.estado == EstadoEconomicoFactura.cobrada
                  ? StatusType.success
                  : estado.estado == EstadoEconomicoFactura.parcialmenteCobrada
                  ? StatusType.info
                  : StatusType.warning,
            );
            final vencimiento = Text(
              'Vence ${DateFormatter.formatDdMmYyyy(factura.fechaVencimiento)}',
              style: Theme.of(context).textTheme.bodySmall,
            );
            if (constraints.maxWidth < 760) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  info,
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(child: vencimiento),
                      importes,
                      const SizedBox(width: AppSpacing.md),
                      status,
                    ],
                  ),
                ],
              );
            }
            return Row(
              children: [
                Expanded(flex: 4, child: info),
                Expanded(flex: 2, child: vencimiento),
                Expanded(flex: 2, child: importes),
                const SizedBox(width: AppSpacing.md),
                status,
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

class _ResumenFacturaCobros extends ConsumerWidget {
  const _ResumenFacturaCobros({required this.facturaId, required this.total});
  final String facturaId;
  final double total;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<FacturaEstadoEconomico>(
      stream: ref
          .read(cobroRepositoryProvider)
          .observarEstadoEconomicoFactura(
            facturaId: facturaId,
            totalFactura: total,
          ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        final value = snapshot.data!;
        return AppCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Wrap(
            spacing: AppSpacing.xl,
            runSpacing: AppSpacing.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _Amount(label: 'Total factura', value: value.totalFactura),
              _Amount(label: 'Cobrado neto', value: value.totalCobrado),
              _Amount(label: 'Pendiente', value: value.pendiente),
              StatusChip(
                label: estadoEconomicoFacturaToLabel(value.estado),
                type: value.estado == EstadoEconomicoFactura.cobrada
                    ? StatusType.success
                    : value.estado == EstadoEconomicoFactura.parcialmenteCobrada
                    ? StatusType.info
                    : StatusType.warning,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MovimientoRow extends StatelessWidget {
  const _MovimientoRow({required this.movimiento, this.onTap});
  final cobro_domain.Cobro movimiento;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final referencia = movimiento.referencia.trim().isEmpty
        ? 'Sin referencia'
        : movimiento.referencia.trim();
    return ListTile(
      key: Key('cobro-movimiento-${movimiento.id}'),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      leading: Icon(
        movimiento.esReversion ? Icons.undo_outlined : Icons.payments_outlined,
        color: movimiento.esReversion
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.primary,
      ),
      title: Row(
        children: [
          StatusChip(
            label: movimiento.esReversion ? 'Reversión' : 'Cobro',
            type: movimiento.esReversion
                ? StatusType.error
                : StatusType.success,
          ),
          const SizedBox(width: AppSpacing.sm),
          MoneyText(
            movimiento.importeNeto,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: AppSpacing.xs),
        child: Text(
          '${DateFormatter.formatDdMmYyyy(movimiento.fecha)} · ${movimiento.metodoPago} · $referencia${movimiento.motivo.trim().isEmpty ? '' : '\nMotivo: ${movimiento.motivo.trim()}'}',
        ),
      ),
      trailing: onTap == null ? null : const Icon(Icons.chevron_right),
      onTap: onTap,
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
      MoneyText(value),
    ],
  );
}

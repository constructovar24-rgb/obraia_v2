import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/shortcuts/app_shortcuts.dart';
import '../../../../core/ui/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/app_page_header.dart';
import '../../../../core/widgets/money_text.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../expedientes/domain/expediente.dart';
import '../../domain/compra.dart';
import '../providers/compra_providers.dart';
import 'compra_detail_screen.dart';
import 'nueva_compra_screen.dart';

class ComprasScreen extends ConsumerStatefulWidget {
  const ComprasScreen({super.key});
  @override
  ConsumerState<ComprasScreen> createState() => _ComprasScreenState();
}

class _ComprasScreenState extends ConsumerState<ComprasScreen> {
  final _search = TextEditingController();
  CompraEstado? _estado;
  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _new() => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const NuevaCompraScreen()),
  );
  @override
  Widget build(BuildContext context) {
    final compras = ref.watch(comprasGlobalesProvider);
    final expedientes = ref.watch(expedientesCompraProvider);
    return AppShortcutScope(
      onBack: () => Navigator.maybePop(context),
      onNew: _new,
      child: Scaffold(
        appBar: AppPageHeader(
          title: 'Compras',
          subtitle: 'Apuntes de gasto vinculados a obras',
          actions: [
            AppPageHeaderAction(
              icon: Icons.add,
              tooltip: 'Nueva compra',
              onPressed: _new,
            ),
          ],
        ),
        body: compras.when(
          loading: () => const AppLoading(message: 'Cargando compras…'),
          error: (e, _) => AppErrorState(
            message: 'No se pudieron cargar las compras.\n\n$e',
          ),
          data: (items) => expedientes.when(
            loading: () => const AppLoading(message: 'Cargando obras…'),
            error: (e, _) => AppErrorState(
              message: 'No se pudieron cargar las obras.\n\n$e',
            ),
            data: (obras) => _body(items, obras),
          ),
        ),
      ),
    );
  }

  Widget _body(List<Compra> items, List<Expediente> obras) {
    if (items.isEmpty) {
      return AppEmptyState(
        icon: Icons.shopping_cart_outlined,
        title: 'Todavía no hay compras',
        subtitle: 'Registra el primer apunte de gasto vinculado a una obra.',
        actionLabel: 'Nueva compra',
        onAction: _new,
      );
    }
    final obraById = {for (final e in obras) e.id: e};
    final q = _search.text.trim().toLowerCase();
    final filtered = items.where((c) {
      final e = obraById[c.expedienteId];
      final matches =
          q.isEmpty ||
          [
            c.concepto,
            c.proveedorNombre,
            c.numeroFactura ?? '',
            e?.codigo ?? '',
            e?.nombre ?? '',
          ].any((v) => v.toLowerCase().contains(q));
      return matches && (_estado == null || c.estado == _estado);
    }).toList();
    final total = filtered.fold<double>(0, (sum, c) => sum + c.importeTotal);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          AppCard(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final search = TextField(
                  key: const Key('compras-search'),
                  controller: _search,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    labelText: 'Buscar concepto, proveedor, factura u obra',
                    prefixIcon: Icon(Icons.search),
                  ),
                );
                final filter = DropdownButtonFormField<CompraEstado?>(
                  key: const Key('compras-filter'),
                  initialValue: _estado,
                  decoration: const InputDecoration(
                    labelText: 'Estado registrado',
                  ),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Todos')),
                    ...CompraEstado.values.map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(compraEstadoLabel(e)),
                      ),
                    ),
                  ],
                  onChanged: (v) => setState(() => _estado = v),
                );
                return constraints.maxWidth >= 760
                    ? Row(
                        children: [
                          Expanded(flex: 3, child: search),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(child: filter),
                        ],
                      )
                    : Column(
                        children: [
                          search,
                          const SizedBox(height: AppSpacing.md),
                          filter,
                        ],
                      );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: Text('${filtered.length} de ${items.length} compras'),
              ),
              const Text('Importe mostrado: '),
              MoneyText(
                total,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: filtered.isEmpty
                ? const AppEmptyState(
                    icon: Icons.search_off_outlined,
                    title: 'No hay coincidencias',
                    subtitle: 'Ajusta la búsqueda o el filtro.',
                  )
                : AppCard(
                    padding: EdgeInsets.zero,
                    child: ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (_, i) {
                        final c = filtered[i];
                        final e = obraById[c.expedienteId];
                        return InkWell(
                          key: Key('compra-row-${c.id}'),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CompraDetailScreen(compra: c),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final identity = Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      c.concepto,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
                                    const SizedBox(height: AppSpacing.xs),
                                    Text(c.proveedorNombre),
                                  ],
                                );
                                if (constraints.maxWidth < 760) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      identity,
                                      const SizedBox(height: AppSpacing.sm),
                                      Text(
                                        e == null
                                            ? 'Obra no disponible'
                                            : '${e.codigo} · ${e.nombre}',
                                      ),
                                      const SizedBox(height: AppSpacing.sm),
                                      Row(
                                        children: [
                                          StatusChip(
                                            label: compraEstadoLabel(c.estado),
                                            type: compraEstadoType(c.estado),
                                          ),
                                          const Spacer(),
                                          MoneyText(c.importeTotal),
                                        ],
                                      ),
                                    ],
                                  );
                                }
                                return Row(
                                  children: [
                                    Expanded(flex: 3, child: identity),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        e == null
                                            ? 'Obra no disponible'
                                            : '${e.codigo} · ${e.nombre}',
                                      ),
                                    ),
                                    Expanded(child: Text(compraFecha(c.fecha))),
                                    StatusChip(
                                      label: compraEstadoLabel(c.estado),
                                      type: compraEstadoType(c.estado),
                                    ),
                                    SizedBox(
                                      width: 130,
                                      child: MoneyText(
                                        c.importeTotal,
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.sm),
                                    const Icon(Icons.chevron_right),
                                  ],
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

String compraEstadoLabel(CompraEstado e) => switch (e) {
  CompraEstado.pendiente => 'Pendiente',
  CompraEstado.pagada => 'Pagada',
  CompraEstado.anulada => 'Anulada',
};
StatusType compraEstadoType(CompraEstado e) => switch (e) {
  CompraEstado.pendiente => StatusType.warning,
  CompraEstado.pagada => StatusType.success,
  CompraEstado.anulada => StatusType.neutral,
};
String compraFecha(DateTime v) =>
    '${v.day.toString().padLeft(2, '0')}/${v.month.toString().padLeft(2, '0')}/${v.year}';

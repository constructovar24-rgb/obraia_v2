import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/shortcuts/app_shortcuts.dart';
import '../../../../core/ui/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/money_text.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../expedientes/data/expediente_repository.dart';
import '../../data/presupuesto_repository.dart';
import '../../domain/presupuesto.dart';
import '../providers/presupuesto_providers.dart';
import 'presupuesto_detail_screen.dart';

enum PresupuestosInitialFilterType {
  todos,
  pendientesFacturar,
  backlogComercial,
}

class PresupuestosInitialFilter {
  const PresupuestosInitialFilter._(this.type);
  const PresupuestosInitialFilter.todos()
    : this._(PresupuestosInitialFilterType.todos);
  const PresupuestosInitialFilter.pendientesFacturar()
    : this._(PresupuestosInitialFilterType.pendientesFacturar);
  const PresupuestosInitialFilter.backlogComercial()
    : this._(PresupuestosInitialFilterType.backlogComercial);
  final PresupuestosInitialFilterType type;
}

class PresupuestosScreen extends ConsumerStatefulWidget {
  const PresupuestosScreen({
    super.key,
    this.initialFilter = const PresupuestosInitialFilter.todos(),
  });
  final PresupuestosInitialFilter initialFilter;
  @override
  ConsumerState<PresupuestosScreen> createState() => _PresupuestosScreenState();
}

class _PresupuestosScreenState extends ConsumerState<PresupuestosScreen> {
  final _search = TextEditingController();
  final _focus = FocusNode();
  late PresupuestoRepository _repository;
  late Stream<List<Presupuesto>> _stream;
  String _estado = 'Todos';

  @override
  void initState() {
    super.initState();
    _repository = ref.read(presupuestoRepositoryProvider);
    _stream = switch (widget.initialFilter.type) {
      PresupuestosInitialFilterType.todos => _repository.observarPresupuestos(),
      PresupuestosInitialFilterType.pendientesFacturar =>
        _repository.observarPendientesFacturar(),
      PresupuestosInitialFilterType.backlogComercial =>
        _repository.observarBacklogComercial(),
    };
  }

  @override
  void dispose() {
    _search.dispose();
    _focus.dispose();
    super.dispose();
  }

  String get _title => switch (widget.initialFilter.type) {
    PresupuestosInitialFilterType.todos => 'Presupuestos',
    PresupuestosInitialFilterType.pendientesFacturar =>
      'Pendientes de facturar',
    PresupuestosInitialFilterType.backlogComercial => 'Backlog comercial',
  };

  @override
  Widget build(BuildContext context) => AppShortcutScope(
    onBack: () => Navigator.maybePop(context),
    onFind: _focus.requestFocus,
    child: Scaffold(
      body: StreamBuilder<List<Presupuesto>>(
        stream: _stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return AppErrorState(
              message:
                  'No se pudieron cargar los presupuestos.\n\n${snapshot.error}',
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const AppLoading(message: 'Cargando presupuestos…');
          }
          return _content(snapshot.data ?? const []);
        },
      ),
    ),
  );

  Widget _content(List<Presupuesto> items) => LayoutBuilder(
    builder: (context, constraints) {
      final compact = constraints.maxWidth < 760;
      final query = _search.text.trim().toLowerCase();
      final filtered = items
          .where(
            (p) =>
                (_estado == 'Todos' ||
                    p.estado.toLowerCase() == _estado.toLowerCase()) &&
                [
                  p.codigo,
                  p.descripcion,
                  p.estado,
                ].any((v) => v.toLowerCase().contains(query)),
          )
          .toList();
      final estados = <String>{'Todos', ...items.map((p) => p.estado)}.toList();
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: Padding(
            padding: EdgeInsets.all(compact ? AppSpacing.md : AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppCard(
                  highlighted: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _title,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '${items.length} documentos · estados e importes basados en datos registrados',
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      if (compact) ...[
                        _searchField(),
                        const SizedBox(height: AppSpacing.sm),
                        _filter(estados),
                      ] else
                        Row(
                          children: [
                            Expanded(child: _searchField()),
                            const SizedBox(width: AppSpacing.md),
                            SizedBox(width: 210, child: _filter(estados)),
                          ],
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                if (items.isEmpty)
                  const Expanded(
                    child: AppEmptyState(
                      icon: Icons.request_quote_outlined,
                      title: 'Todavía no hay presupuestos',
                      subtitle:
                          'Los presupuestos se crean desde el expediente correspondiente.',
                    ),
                  )
                else if (filtered.isEmpty)
                  const Expanded(
                    child: AppEmptyState(
                      icon: Icons.search_off,
                      title: 'No hay coincidencias',
                      subtitle: 'Cambia la búsqueda o el filtro de estado.',
                    ),
                  )
                else
                  Expanded(
                    child: AppCard(
                      padding: EdgeInsets.zero,
                      child: ListView.separated(
                        itemCount: filtered.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (_, i) => _row(filtered[i], compact),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    },
  );

  Widget _searchField() => TextField(
    key: const ValueKey('presupuestos-search'),
    controller: _search,
    focusNode: _focus,
    decoration: const InputDecoration(
      labelText: 'Buscar presupuestos',
      hintText: 'Referencia, descripción o estado',
      prefixIcon: Icon(Icons.search),
    ),
    onChanged: (_) => setState(() {}),
  );
  Widget _filter(List<String> estados) => DropdownButtonFormField<String>(
    key: const ValueKey('presupuestos-filter'),
    initialValue: _estado,
    decoration: const InputDecoration(labelText: 'Estado'),
    items: estados
        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
        .toList(),
    onChanged: (value) => setState(() => _estado = value ?? 'Todos'),
  );

  Widget _row(Presupuesto p, bool compact) => Consumer(
    builder: (context, ref, _) {
      final expediente = ref.watch(expedienteProvider(p.expedienteId)).value;
      final iva = p.importeTotal * p.ivaPorcentaje / 100;
      final total = p.importeTotal + iva;
      return InkWell(
        key: ValueKey('presupuesto-row-${p.id}'),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PresupuestoDetailScreen(presupuesto: p),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.codigo,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      expediente == null
                          ? 'Expediente no disponible'
                          : '${expediente.codigo} · ${expediente.clienteNombre ?? 'Sin cliente'}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (!compact) Expanded(flex: 2, child: Text(_date(p.fecha))),
              if (!compact) Expanded(flex: 2, child: MoneyText(p.importeTotal)),
              if (!compact)
                Expanded(
                  flex: 2,
                  child: Text(
                    '${p.ivaPorcentaje.toStringAsFixed(0)}% · ${MoneyText.format(iva)}',
                  ),
                ),
              Expanded(
                flex: 2,
                child: MoneyText(
                  total,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              StatusChip(label: p.estado, type: _status(p.estado)),
              const SizedBox(width: AppSpacing.xs),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      );
    },
  );
  String _date(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  StatusType _status(String value) {
    switch (value.trim().toLowerCase()) {
      case 'aceptado':
        return StatusType.success;
      case 'rechazado':
        return StatusType.error;
      case 'presentado':
        return StatusType.info;
      default:
        return StatusType.neutral;
    }
  }
}

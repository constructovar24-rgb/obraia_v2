import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/shortcuts/app_shortcuts.dart';
import '../../../../core/ui/app_spacing.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/app_page_header.dart';
import '../../data/presupuesto_repository.dart';
import '../../domain/presupuesto.dart' as presupuesto_domain;
import '../providers/presupuesto_providers.dart';
import '../widgets/presupuestos_tab.dart';

enum PresupuestosInitialFilterType { pendientesFacturar, backlogComercial }

class PresupuestosInitialFilter {
  const PresupuestosInitialFilter._(this.type);

  const PresupuestosInitialFilter.pendientesFacturar()
    : this._(PresupuestosInitialFilterType.pendientesFacturar);

  const PresupuestosInitialFilter.backlogComercial()
    : this._(PresupuestosInitialFilterType.backlogComercial);

  final PresupuestosInitialFilterType type;
}

class PresupuestosScreen extends ConsumerStatefulWidget {
  const PresupuestosScreen({
    super.key,
    this.initialFilter = const PresupuestosInitialFilter.pendientesFacturar(),
  });

  final PresupuestosInitialFilter initialFilter;

  @override
  ConsumerState<PresupuestosScreen> createState() =>
      _PresupuestosScreenState();
}

class _PresupuestosScreenState extends ConsumerState<PresupuestosScreen> {
  late final PresupuestoRepository _repository;
  late final Stream<List<presupuesto_domain.Presupuesto>> _stream;

  @override
  void initState() {
    super.initState();
    _repository = ref.read(presupuestoRepositoryProvider);
    switch (widget.initialFilter.type) {
      case PresupuestosInitialFilterType.pendientesFacturar:
        _stream = _repository.observarPendientesFacturar();
        break;
      case PresupuestosInitialFilterType.backlogComercial:
        _stream = _repository.observarBacklogComercial();
        break;
    }
  }

  String get _title {
    switch (widget.initialFilter.type) {
      case PresupuestosInitialFilterType.pendientesFacturar:
        return 'Presupuestos pendientes de facturar';
      case PresupuestosInitialFilterType.backlogComercial:
        return 'Backlog comercial';
    }
  }

  String get _emptyTitle {
    switch (widget.initialFilter.type) {
      case PresupuestosInitialFilterType.pendientesFacturar:
        return 'No hay presupuestos pendientes de facturar';
      case PresupuestosInitialFilterType.backlogComercial:
        return 'No hay presupuestos en backlog comercial';
    }
  }

  String get _emptySubtitle {
    switch (widget.initialFilter.type) {
      case PresupuestosInitialFilterType.pendientesFacturar:
        return 'Todos los presupuestos aceptados ya tienen una factura válida asociada.';
      case PresupuestosInitialFilterType.backlogComercial:
        return 'No hay presupuestos presentados con 60 días o más sin una factura válida asociada.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppShortcutScope(
      onBack: () => Navigator.maybePop(context),
      child: Scaffold(
        appBar: AppPageHeader(
          title: _title,
          showBackButton: true,
        ),
        body: StreamBuilder<List<presupuesto_domain.Presupuesto>>(
          stream: _stream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return AppErrorState(
                message: 'ERROR:\n\n${snapshot.error}',
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const AppLoading(
                message: 'Cargando presupuestos pendientes...',
              );
            }

            final presupuestos = snapshot.data ?? const [];
            if (presupuestos.isEmpty) {
              return AppEmptyState(
                icon: Icons.request_quote_outlined,
                title: _emptyTitle,
                subtitle: _emptySubtitle,
              );
            }

            return Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: PresupuestosList(presupuestos: presupuestos),
            );
          },
        ),
      ),
    );
  }
}

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

class PresupuestosScreen extends ConsumerStatefulWidget {
  const PresupuestosScreen({super.key});

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
    _stream = _repository.observarPendientesFacturar();
  }

  @override
  Widget build(BuildContext context) {
    return AppShortcutScope(
      onBack: () => Navigator.maybePop(context),
      child: Scaffold(
        appBar: const AppPageHeader(
          title: 'Presupuestos pendientes de facturar',
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
              return const AppEmptyState(
                icon: Icons.request_quote_outlined,
                title: 'No hay presupuestos pendientes de facturar',
                subtitle:
                    'Todos los presupuestos aceptados ya tienen una factura válida asociada.',
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

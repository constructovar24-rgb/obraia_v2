import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/app_spacing.dart';
import '../../../../core/ui/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../data/presupuesto_repository.dart';
import '../../domain/presupuesto.dart' as presupuesto_domain;
import '../providers/presupuesto_providers.dart';
import '../screens/nuevo_presupuesto_screen.dart';
import '../screens/presupuesto_detail_screen.dart';

class PresupuestosTab extends ConsumerStatefulWidget {
  const PresupuestosTab({
    super.key,
    required this.expedienteId,
  });

  final String expedienteId;

  @override
  ConsumerState<PresupuestosTab> createState() => _PresupuestosTabState();
}

class _PresupuestosTabState extends ConsumerState<PresupuestosTab> {
  late final PresupuestoRepository _repository;
  late final Stream<List<presupuesto_domain.Presupuesto>> _stream;

  @override
  void initState() {
    super.initState();
    _repository = ref.read(presupuestoRepositoryProvider);
    _stream = _repository.observarPorExpediente(widget.expedienteId);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = AppTypography.textTheme(colorScheme);

    void abrirNuevoPresupuesto() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => NuevoPresupuestoScreen(
            expedienteId: widget.expedienteId,
          ),
        ),
      );
    }

    String formatearFecha(DateTime fecha) {
      final day = fecha.day.toString().padLeft(2, '0');
      final month = fecha.month.toString().padLeft(2, '0');
      final year = fecha.year.toString();
      return '$day/$month/$year';
    }

    String formatearImporte(double importe) {
      return '${importe.toStringAsFixed(2)} €';
    }

    return StreamBuilder<List<presupuesto_domain.Presupuesto>>(
      stream: _stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return AppErrorState(
            message: 'ERROR:\n\n${snapshot.error}',
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const AppLoading(
            message: 'Cargando presupuestos...',
          );
        }

        final presupuestos = snapshot.data ?? const [];

        if (presupuestos.isEmpty) {
          return AppEmptyState(
            icon: Icons.request_quote_outlined,
            title: 'Todavía no hay presupuestos',
            subtitle: 'Crea el primer presupuesto para este expediente.',
            actionLabel: 'Nuevo presupuesto',
            onAction: abrirNuevoPresupuesto,
          );
        }

        return Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              AppCard(
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
                        Icons.request_quote_outlined,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Presupuestos',
                            style: textTheme.headlineMedium,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Consulta y abre cada presupuesto del expediente.',
                            style: textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    AppPrimaryButton(
                      label: 'Nuevo presupuesto',
                      icon: Icons.add,
                      onPressed: abrirNuevoPresupuesto,
                      expand: false,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: ListView.separated(
                  itemCount: presupuestos.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final presupuesto = presupuestos[index];

                    return AppCard(
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(AppSpacing.md),
                        leading: CircleAvatar(
                          backgroundColor: colorScheme.primaryContainer,
                          foregroundColor: colorScheme.onPrimaryContainer,
                          child: const Icon(Icons.request_quote_outlined),
                        ),
                        title: Text(
                          presupuesto.codigo,
                          style: textTheme.titleMedium,
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.xs),
                          child: Text(
                            '${formatearFecha(presupuesto.fecha)}\nEstado: ${presupuesto.estado}\nImporte: ${formatearImporte(presupuesto.importeTotal)}\n${presupuesto.descripcion}',
                            style: textTheme.bodyMedium,
                          ),
                        ),
                        isThreeLine: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PresupuestoDetailScreen(
                                presupuesto: presupuesto,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: AppPrimaryButton(
                  onPressed: abrirNuevoPresupuesto,
                  label: 'Nuevo presupuesto',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

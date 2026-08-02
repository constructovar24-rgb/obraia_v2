import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/app_spacing.dart';
import '../../../../core/ui/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../providers/compra_providers.dart';
import '../screens/editar_compra_screen.dart';
import '../screens/nueva_compra_screen.dart';

class ComprasTab extends ConsumerWidget {
  const ComprasTab({
    super.key,
    required this.expedienteId,
  });

  final String expedienteId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = AppTypography.textTheme(colorScheme);

    String formatearFecha(DateTime fecha) {
      final day = fecha.day.toString().padLeft(2, '0');
      final month = fecha.month.toString().padLeft(2, '0');
      final year = fecha.year.toString();
      return '$day/$month/$year';
    }

    String formatearImporte(double importe) {
      return '${importe.toStringAsFixed(2)} €';
    }

    void abrirNuevaCompra() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => NuevaCompraScreen(
            expedienteId: expedienteId,
          ),
        ),
      );
    }

    final comprasAsync = ref.watch(comprasProvider(expedienteId));

    return comprasAsync.when(
      loading: () => const AppLoading(
        message: 'Cargando compras...',
      ),
      error: (error, stackTrace) => AppErrorState(
        message: 'ERROR:\n\n$error',
      ),
      data: (compras) {
        if (compras.isEmpty) {
          return AppEmptyState(
            icon: Icons.shopping_bag_outlined,
            title: 'Todavía no hay compras',
            subtitle: 'Crea la primera compra para empezar a trabajar.',
            actionLabel: 'Nueva compra',
            onAction: abrirNuevaCompra,
          );
        }

        return Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: compras.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final compra = compras[index];

                    return AppCard(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: colorScheme.primaryContainer,
                          foregroundColor: colorScheme.onPrimaryContainer,
                          child: const Icon(Icons.shopping_bag_outlined),
                        ),
                        title: Text(
                          compra.concepto,
                          style: textTheme.titleMedium,
                        ),
                        subtitle: Text(
                          'Proveedor: ${compra.proveedorNombre}\n'
                          'Importe: ${formatearImporte(compra.importeTotal)}\n'
                          'Fecha: ${formatearFecha(compra.fecha)}',
                          style: textTheme.bodyMedium,
                        ),
                        isThreeLine: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditarCompraScreen(
                                compra: compra,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: AppPrimaryButton(
                  onPressed: abrirNuevaCompra,
                  label: 'Nueva compra',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

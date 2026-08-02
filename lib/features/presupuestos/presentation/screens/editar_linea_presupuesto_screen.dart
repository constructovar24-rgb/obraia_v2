import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/shortcuts/app_shortcuts.dart';
import '../../../../core/ui/app_spacing.dart';
import '../../../../core/ui/app_typography.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_section.dart';
import '../../domain/linea_presupuesto.dart' as linea_domain;
import '../providers/presupuesto_providers.dart';
import 'nuevo_linea_presupuesto_screen.dart';

class EditarLineaPresupuestoScreen extends ConsumerWidget {
  const EditarLineaPresupuestoScreen({
    super.key,
    required this.linea,
  });

  final linea_domain.LineaPresupuesto linea;

  Future<bool> _confirmarEliminacion(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text(
            'Toda la información de esta línea se eliminará de forma permanente.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = AppTypography.textTheme(colorScheme);

    Future<void> guardarLinea(
      String concepto,
      double cantidad,
      double precioUnitario,
    ) async {
      final repository = ref.read(lineaPresupuestoRepositoryProvider);

      await repository.actualizarLinea(
        id: linea.id,
        presupuestoId: linea.presupuestoId,
        concepto: concepto,
        cantidad: cantidad,
        precioUnitario: precioUnitario,
      );

      if (!context.mounted) return;
      Navigator.of(context).pop();
    }

    Future<void> eliminarLinea() async {
      final confirmado = await _confirmarEliminacion(context);
      if (!confirmado) {
        return;
      }

      final repository = ref.read(lineaPresupuestoRepositoryProvider);
      await repository.eliminarLinea(
        linea.id,
        linea.presupuestoId,
      );

      if (!context.mounted) return;
      Navigator.of(context).pop();
    }

    return AppShortcutScope(
      onBack: () {
        Navigator.maybePop(context);
      },
      onDelete: () {
        eliminarLinea();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Editar línea'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            Text(
              'Actualiza los datos de esta línea del presupuesto.',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            AppSection(
              title: 'Datos de la línea',
              subtitle: 'Edita concepto, cantidad y precio unitario.',
              child: LineaPresupuestoForm(
                initialConcepto: linea.concepto,
                initialCantidad: linea.cantidad,
                initialPrecioUnitario: linea.precioUnitario,
                onSubmit: guardarLinea,
                footer: AppPrimaryButton(
                  onPressed: eliminarLinea,
                  icon: Icons.delete_outline,
                  label: 'Eliminar línea',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

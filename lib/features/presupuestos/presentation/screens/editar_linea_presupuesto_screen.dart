import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/shortcuts/app_shortcuts.dart';
import '../../data/linea_presupuesto_repository.dart';
import '../../domain/linea_presupuesto.dart' as linea_domain;
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
        body: LineaPresupuestoForm(
          initialConcepto: linea.concepto,
          initialCantidad: linea.cantidad,
          initialPrecioUnitario: linea.precioUnitario,
          onSubmit: guardarLinea,
          footer: SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: eliminarLinea,
              child: const Text('Eliminar línea'),
            ),
          ),
        ),
      ),
    );
  }
}

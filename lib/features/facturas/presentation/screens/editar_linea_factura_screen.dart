import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/shortcuts/app_shortcuts.dart';
import '../../data/factura_linea_repository.dart';
import '../../domain/factura_linea.dart' as factura_linea_domain;
import 'nueva_linea_factura_screen.dart';

class EditarLineaFacturaScreen extends ConsumerWidget {
  const EditarLineaFacturaScreen({
    super.key,
    required this.linea,
  });

  final factura_linea_domain.FacturaLinea linea;

  Future<bool> _confirmarEliminacion(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text(
            'Toda la informacion de esta linea se eliminara de forma permanente.',
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
      String descripcion,
      double cantidad,
      String unidad,
      double precioUnitario,
      double descuento,
    ) async {
      final repository = ref.read(facturaLineaRepositoryProvider);

      await repository.actualizarLinea(
        id: linea.id,
        facturaId: linea.facturaId,
        descripcion: descripcion,
        cantidad: cantidad,
        unidad: unidad,
        precioUnitario: precioUnitario,
        descuento: descuento,
      );

      if (!context.mounted) return;
      Navigator.of(context).pop();
    }

    Future<void> eliminarLinea() async {
      final confirmado = await _confirmarEliminacion(context);
      if (!confirmado) {
        return;
      }

      final repository = ref.read(facturaLineaRepositoryProvider);
      await repository.eliminarLinea(
        linea.id,
        linea.facturaId,
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
          title: const Text('Editar linea'),
        ),
        body: LineaFacturaForm(
          initialDescripcion: linea.descripcion,
          initialCantidad: linea.cantidad,
          initialUnidad: linea.unidad,
          initialPrecioUnitario: linea.precioUnitario,
          initialDescuento: linea.descuento,
          onSubmit: guardarLinea,
          footer: SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: eliminarLinea,
              child: const Text('Eliminar linea'),
            ),
          ),
        ),
      ),
    );
  }
}

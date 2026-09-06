import '../screens/facturas_proveedor_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../compras/presentation/widgets/compras_tab.dart';
import '../../../proveedores/presentation/providers/proveedor_providers.dart';
import '../../domain/circuito_proveedor.dart';
import '../providers/circuito_proveedor_providers.dart';

class SuministrosObraTab extends ConsumerWidget {
  const SuministrosObraTab({super.key, required this.expedienteId});
  final String expedienteId;

  @override
  Widget build(BuildContext context, WidgetRef ref) => DefaultTabController(
    length: 3,
    child: Column(
      children: [
        const TabBar(
          tabs: [
            Tab(text: 'Compras'),
            Tab(text: 'Albaranes'),
            Tab(text: 'Facturas recibidas'),
          ],
        ),
        Expanded(
          child: TabBarView(
            children: [
              ComprasTab(expedienteId: expedienteId),
              _Albaranes(expedienteId),
              const FacturasProveedorScreen(),
            ],
          ),
        ),
      ],
    ),
  );
}

class _Albaranes extends ConsumerWidget {
  const _Albaranes(this.expedienteId);
  final String expedienteId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(albaranesObraProvider(expedienteId));
    return Scaffold(
      body: data.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (rows) => rows.isEmpty
            ? const Center(
                child: Text('No hay albaranes asignados a esta obra.'),
              )
            : ListView.builder(
                itemCount: rows.length,
                itemBuilder: (_, i) => ListTile(
                  leading: const Icon(Icons.local_shipping_outlined),
                  title: Text(rows[i].referenciaProveedor),
                  subtitle: Text(
                    '${rows[i].fecha.day}/${rows[i].fecha.month}/${rows[i].fecha.year} · ${rows[i].estado}',
                  ),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _nuevoAlbaran(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Albarán'),
      ),
    );
  }

  Future<void> _nuevoAlbaran(BuildContext context, WidgetRef ref) async {
    final proveedores = ref.read(proveedoresProvider).value ?? [];
    if (proveedores.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Crea primero un proveedor.')),
      );
      return;
    }
    final referencia = TextEditingController();
    final descripcion = TextEditingController();
    final cantidad = TextEditingController(text: '1');
    var proveedorId = proveedores.first.id;
    var saving = false;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (_, setState) => AlertDialog(
          title: const Text('Nuevo albarán'),
          content: SizedBox(
            width: 460,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: proveedorId,
                  items: proveedores
                      .map(
                        (p) => DropdownMenuItem(
                          value: p.id,
                          child: Text(p.nombre),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => proveedorId = v!,
                ),
                TextField(
                  controller: referencia,
                  decoration: const InputDecoration(
                    labelText: 'Referencia del proveedor',
                  ),
                ),
                TextField(
                  controller: descripcion,
                  decoration: const InputDecoration(
                    labelText: 'Material / descripción original',
                  ),
                ),
                TextField(
                  controller: cantidad,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Cantidad'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: saving ? null : () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: saving
                  ? null
                  : () async {
                      final q = double.tryParse(
                        cantidad.text.replaceAll(',', '.'),
                      );
                      if (referencia.text.trim().isEmpty ||
                          descripcion.text.trim().isEmpty ||
                          q == null ||
                          q <= 0) {
                        return;
                      }
                      setState(() => saving = true);
                      try {
                        await ref
                            .read(circuitoProveedorRepositoryProvider)
                            .crearAlbaran(
                              AlbaranInput(
                                proveedorId: proveedorId,
                                referencia: referencia.text,
                                fecha: DateTime.now(),
                                lineas: [
                                  LineaAlbaranInput(
                                    descripcion: descripcion.text,
                                    cantidad: q,
                                    asignaciones: [
                                      AsignacionImporteInput(
                                        expedienteId: expedienteId,
                                        importeCentimos: 0,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                        if (dialogContext.mounted) {
                          Navigator.pop(dialogContext);
                        }
                      } catch (e) {
                        setState(() => saving = false);
                        if (dialogContext.mounted) {
                          ScaffoldMessenger.of(
                            dialogContext,
                          ).showSnackBar(SnackBar(content: Text('$e')));
                        }
                      }
                    },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}

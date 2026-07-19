import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../database/database_provider.dart';

class NuevoExpedienteScreen extends ConsumerStatefulWidget {
  const NuevoExpedienteScreen({super.key});

  @override
ConsumerState<NuevoExpedienteScreen> createState() =>
    _NuevoExpedienteScreenState();
}

class _NuevoExpedienteScreenState
    extends ConsumerState<NuevoExpedienteScreen> {
  final _codigoController = TextEditingController();
  final _nombreController = TextEditingController();

  @override
  void dispose() {
    _codigoController.dispose();
    _nombreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nuevo expediente"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _codigoController,
              decoration: const InputDecoration(
                labelText: "Código",
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: "Nombre",
              ),
            ),
            const SizedBox(height: 30),
            FilledButton.icon(
              onPressed: () async {
  final db = ref.read(databaseProvider);

  await db.crearExpediente(
    codigo: _codigoController.text.trim(),
    nombre: _nombreController.text.trim(),
  );

  if (mounted) {
    Navigator.pop(context);
  }
},
              icon: const Icon(Icons.save),
              label: const Text("Guardar"),
            ),
          ],
        ),
      ),
    );
  }
}
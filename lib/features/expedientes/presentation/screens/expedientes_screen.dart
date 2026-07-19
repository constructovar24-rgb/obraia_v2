import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../database/database_provider.dart';
import 'nuevo_expediente_screen.dart';

class ExpedientesScreen extends ConsumerWidget {
  const ExpedientesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.read(databaseProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expedientes'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const NuevoExpedienteScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: db.observarExpedientes(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final expedientes = snapshot.data!;

          if (expedientes.isEmpty) {
            return const Center(
              child: Text(
                'Todavía no hay expedientes',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: expedientes.length,
            itemBuilder: (context, index) {
              final expediente = expedientes[index];

              return ListTile(
                leading: const Icon(Icons.folder),
                title: Text(expediente.nombre),
                subtitle: Text(expediente.codigo),
              );
            },
          );
        },
      ),
    );
  }
}
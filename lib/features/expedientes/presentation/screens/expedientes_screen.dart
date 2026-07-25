import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../database/database_provider.dart';
import '../../data/expediente_repository.dart';
import 'expediente_detail_screen.dart';
import 'nuevo_expediente_screen.dart';

class ExpedientesScreen extends ConsumerWidget {
  const ExpedientesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.read(databaseProvider);
    final repository = ExpedienteRepository(db);

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
        stream: repository.observarExpedientes(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SelectableText(
                  'ERROR:\n\n${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final expedientes = snapshot.data ?? [];

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

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.folder),
                  ),
                  title: Text(
                    expediente.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    expediente.clienteNombre?.isNotEmpty == true
                        ? '${expediente.codigo} · ${expediente.clienteNombre}'
                        : expediente.codigo,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ExpedienteDetailScreen(
                          id: expediente.id,
                          codigo: expediente.codigo,
                          nombre: expediente.nombre,
                          clienteNombre: expediente.clienteNombre,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
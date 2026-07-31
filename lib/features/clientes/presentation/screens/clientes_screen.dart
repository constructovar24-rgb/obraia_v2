import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/shortcuts/app_shortcuts.dart';
import '../../../../core/widgets/app_page_header.dart';
import '../../../../database/database_provider.dart';
import '../../data/cliente_repository.dart';
import 'cliente_detail_screen.dart';
import 'nuevo_cliente_screen.dart';

class ClientesScreen extends ConsumerWidget {
  const ClientesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.read(databaseProvider);
    final repository = ClienteRepository(db);

    void abrirNuevoCliente() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const NuevoClienteScreen(),
        ),
      );
    }

    return AppShortcutScope(
      onBack: () {
        Navigator.maybePop(context);
      },
      onNew: abrirNuevoCliente,
      child: Scaffold(
        appBar: const AppPageHeader(title: 'Clientes'),
        floatingActionButton: FloatingActionButton(
          onPressed: abrirNuevoCliente,
          child: const Icon(Icons.add),
        ),
        body: StreamBuilder(
          stream: repository.observarClientes(),
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

            final clientes = snapshot.data ?? [];

            if (clientes.isEmpty) {
              return const Center(
                child: Text(
                  'Todavía no hay clientes',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            return ListView.builder(
              itemCount: clientes.length,
              itemBuilder: (context, index) {
                final cliente = clientes[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    title: Text(
                      '${cliente.nombre} ${cliente.apellidos}'.trim(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      cliente.email.isNotEmpty
                          ? cliente.email
                          : cliente.telefono.isNotEmpty
                              ? cliente.telefono
                              : 'Sin datos',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ClienteDetailScreen(cliente: cliente),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

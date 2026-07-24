import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../database/database_provider.dart';
import '../../data/cliente_repository.dart';
import '../../domain/cliente.dart';
import 'editar_cliente_screen.dart';

class ClienteDetailScreen extends ConsumerWidget {
  const ClienteDetailScreen({
    super.key,
    required this.cliente,
  });

  final Cliente cliente;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ClienteRepository(ref.read(databaseProvider));

    return Scaffold(
      appBar: AppBar(
        title: Text('${cliente.nombre} ${cliente.apellidos}'.trim()),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              await repository.eliminarCliente(cliente.id);

              if (!context.mounted) return;

              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            '${cliente.nombre} ${cliente.apellidos}'.trim(),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Chip(
            label: Text(cliente.empresa.isNotEmpty ? cliente.empresa : 'Sin empresa'),
          ),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.badge_outlined),
            title: Text(cliente.nif.isNotEmpty ? cliente.nif : 'Sin NIF'),
          ),
          ListTile(
            leading: const Icon(Icons.phone_outlined),
            title: Text(cliente.telefono.isNotEmpty ? cliente.telefono : 'Sin teléfono'),
          ),
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: Text(cliente.email.isNotEmpty ? cliente.email : 'Sin email'),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: Text(cliente.direccion.isNotEmpty ? cliente.direccion : 'Sin dirección'),
          ),
          ListTile(
            leading: const Icon(Icons.location_city_outlined),
            title: Text(
              cliente.poblacion.isNotEmpty || cliente.provincia.isNotEmpty
                  ? '${cliente.poblacion} ${cliente.provincia}'.trim()
                  : 'Sin ubicación',
            ),
          ),
          ListTile(
            leading: const Icon(Icons.notes_outlined),
            title: Text(
              cliente.observaciones.isNotEmpty
                  ? cliente.observaciones
                  : 'Sin observaciones',
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditarClienteScreen(cliente: cliente),
                ),
              );
            },
            icon: const Icon(Icons.edit),
            label: const Text('Editar cliente'),
          ),
        ],
      ),
    );
  }
}

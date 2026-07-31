import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_page_header.dart';
import '../../../../core/widgets/entity_summary_card.dart';
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
      appBar: AppPageHeader(
        showBackButton: true,
        title: 'Cliente',
        actions: [
          AppPageHeaderAction(
            icon: Icons.delete_outline,
            tooltip: 'Eliminar cliente',
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
          EntitySummaryCard(
            title: '${cliente.nombre} ${cliente.apellidos}'.trim(),
            subtitle: cliente.empresa.isNotEmpty
                ? cliente.empresa
                : 'Sin empresa',
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

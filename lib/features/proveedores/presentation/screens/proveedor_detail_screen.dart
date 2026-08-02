import 'package:flutter/material.dart';

import '../../../../core/widgets/app_page_header.dart';
import '../../../../core/widgets/entity_summary_card.dart';
import '../../domain/proveedor.dart';
import 'editar_proveedor_screen.dart';

class ProveedorDetailScreen extends StatelessWidget {
  const ProveedorDetailScreen({
    super.key,
    required this.proveedor,
  });

  final Proveedor proveedor;

  bool _hasText(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final tiles = <Widget>[];

    if (_hasText(proveedor.personaContacto)) {
      tiles.add(
        ListTile(
          leading: const Icon(Icons.person_outline),
          title: Text(proveedor.personaContacto!.trim()),
        ),
      );
    }

    if (_hasText(proveedor.nif)) {
      tiles.add(
        ListTile(
          leading: const Icon(Icons.badge_outlined),
          title: Text(proveedor.nif.trim()),
        ),
      );
    }

    if (_hasText(proveedor.telefono)) {
      tiles.add(
        ListTile(
          leading: const Icon(Icons.phone_outlined),
          title: Text(proveedor.telefono.trim()),
        ),
      );
    }

    if (_hasText(proveedor.email)) {
      tiles.add(
        ListTile(
          leading: const Icon(Icons.email_outlined),
          title: Text(proveedor.email.trim()),
        ),
      );
    }

    if (_hasText(proveedor.direccion)) {
      tiles.add(
        ListTile(
          leading: const Icon(Icons.home_outlined),
          title: Text(proveedor.direccion.trim()),
        ),
      );
    }

    if (_hasText(proveedor.poblacion) || _hasText(proveedor.provincia)) {
      tiles.add(
        ListTile(
          leading: const Icon(Icons.location_city_outlined),
          title: Text(
            '${proveedor.poblacion} ${proveedor.provincia}'.trim(),
          ),
        ),
      );
    }

    if (_hasText(proveedor.codigoPostal)) {
      tiles.add(
        ListTile(
          leading: const Icon(Icons.markunread_mailbox_outlined),
          title: Text(proveedor.codigoPostal.trim()),
        ),
      );
    }

    if (_hasText(proveedor.pais)) {
      tiles.add(
        ListTile(
          leading: const Icon(Icons.public_outlined),
          title: Text(proveedor.pais.trim()),
        ),
      );
    }

    if (_hasText(proveedor.observaciones)) {
      tiles.add(
        ListTile(
          leading: const Icon(Icons.notes_outlined),
          title: Text(proveedor.observaciones.trim()),
        ),
      );
    }

    return Scaffold(
      appBar: const AppPageHeader(
        showBackButton: true,
        title: 'Proveedor',
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          EntitySummaryCard(
            title: proveedor.nombre.trim(),
            subtitle: _hasText(proveedor.personaContacto)
                ? proveedor.personaContacto!.trim()
                : '',
          ),
          const SizedBox(height: 24),
          ...tiles,
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditarProveedorScreen(proveedor: proveedor),
                ),
              );
            },
            icon: const Icon(Icons.edit),
            label: const Text('Editar proveedor'),
          ),
        ],
      ),
    );
  }
}

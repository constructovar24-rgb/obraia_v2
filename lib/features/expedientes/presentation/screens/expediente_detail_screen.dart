import 'package:flutter/material.dart';

import 'datos_generales_screen.dart';

class ExpedienteDetailScreen extends StatelessWidget {
  const ExpedienteDetailScreen({
    super.key,
    required this.id,
    required this.codigo,
    required this.nombre,
    this.clienteNombre,
  });

  final String id;
  final String codigo;
  final String nombre;
  final String? clienteNombre;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(codigo),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            nombre,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          if (clienteNombre != null && clienteNombre!.isNotEmpty)
            Text(
              'Cliente: $clienteNombre',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          const SizedBox(height: 8),
          const Chip(
            label: Text('Abierto'),
          ),
          const SizedBox(height: 24),

          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('Datos generales'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DatosGeneralesScreen(
                    id: id,
                    codigoExpediente: codigo,
                  ),
                ),
              );
            },
          ),

          const ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('Cliente'),
          ),
          const ListTile(
            leading: Icon(Icons.request_quote_outlined),
            title: Text('Presupuestos'),
          ),
          const ListTile(
            leading: Icon(Icons.straighten),
            title: Text('Mediciones'),
          ),
          const ListTile(
            leading: Icon(Icons.construction),
            title: Text('Obras'),
          ),
          const ListTile(
            leading: Icon(Icons.photo_library_outlined),
            title: Text('Fotografías'),
          ),
          const ListTile(
            leading: Icon(Icons.folder_outlined),
            title: Text('Documentos'),
          ),
          const ListTile(
            leading: Icon(Icons.euro_outlined),
            title: Text('Costes'),
          ),
          const ListTile(
            leading: Icon(Icons.receipt_long_outlined),
            title: Text('Facturas'),
          ),
          const ListTile(
            leading: Icon(Icons.bar_chart_outlined),
            title: Text('Rentabilidad'),
          ),
        ],
      ),
    );
  }
}
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

  static const List<Tab> _tabs = [
    Tab(text: 'Datos generales'),
    Tab(text: 'Cliente'),
    Tab(text: 'Presupuestos'),
    Tab(text: 'Certificaciones'),
    Tab(text: 'Facturas'),
    Tab(text: 'Documentos'),
    Tab(text: 'Notas'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(codigo),
          bottom: const TabBar(
            isScrollable: true,
            tabs: _tabs,
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Center(
                    child: ListTile(
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
                  ),
                  const Center(child: Text('En desarrollo')),
                  const Center(child: Text('En desarrollo')),
                  const Center(child: Text('En desarrollo')),
                  const Center(child: Text('En desarrollo')),
                  const Center(child: Text('En desarrollo')),
                  const Center(child: Text('En desarrollo')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

import 'cliente_tab.dart';
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
    final hasCliente = clienteNombre != null && clienteNombre!.isNotEmpty;

    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(codigo),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(hasCliente ? 196 : 172),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            codigo,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            nombre,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          if (hasCliente) ...[
                            const SizedBox(height: 6),
                            Text(
                              'Cliente: $clienteNombre',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                          const SizedBox(height: 8),
                          const Chip(
                            label: Text('Sin estado'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const TabBar(
                  isScrollable: true,
                  tabs: _tabs,
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            DatosGeneralesTab(
              id: id,
              codigoExpediente: codigo,
            ),
            ClienteTab(expedienteId: id),
            const Center(child: Text('En desarrollo')),
            const Center(child: Text('En desarrollo')),
            const Center(child: Text('En desarrollo')),
            const Center(child: Text('En desarrollo')),
            const Center(child: Text('En desarrollo')),
          ],
        ),
      ),
    );
  }
}
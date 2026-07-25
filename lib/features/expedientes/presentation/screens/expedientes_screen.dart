import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../database/database_provider.dart';
import '../../domain/expediente.dart' as expediente_domain;
import '../../data/expediente_repository.dart';
import 'expediente_detail_screen.dart';
import 'nuevo_expediente_screen.dart';

class ExpedientesScreen extends ConsumerStatefulWidget {
  const ExpedientesScreen({super.key});

  @override
  ConsumerState<ExpedientesScreen> createState() => _ExpedientesScreenState();
}

class _ExpedientesScreenState extends ConsumerState<ExpedientesScreen> {
  final TextEditingController _searchController = TextEditingController();
  late final ExpedienteRepository _repository;
  late final Stream<List<expediente_domain.Expediente>> _expedientesStream;

  @override
  void initState() {
    super.initState();
    _repository = ExpedienteRepository(ref.read(databaseProvider));
    _expedientesStream = _repository.observarExpedientes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        stream: _expedientesStream,
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
          final query = _searchController.text.trim().toLowerCase();
          final expedientesFiltrados = query.isEmpty
              ? expedientes
              : expedientes.where((expediente) {
                  final codigo = expediente.codigo.toLowerCase();
                  final nombre = expediente.nombre.toLowerCase();
                  final cliente = (expediente.clienteNombre ?? '').toLowerCase();

                  return codigo.contains(query) ||
                      nombre.contains(query) ||
                      cliente.contains(query);
                }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'Buscar expedientes',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              expedientesFiltrados.isEmpty
                  ? const Expanded(
                      child: Center(
                        child: Text(
                          'No hay expedientes que coincidan',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: expedientesFiltrados.length,
                        itemBuilder: (context, index) {
                          final expediente = expedientesFiltrados[index];

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
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }
}
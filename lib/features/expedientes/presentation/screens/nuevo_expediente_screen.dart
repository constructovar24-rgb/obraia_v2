import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../database/database_provider.dart';
import '../../../clientes/data/cliente_repository.dart';
import '../../../clientes/domain/cliente.dart';

class NuevoExpedienteScreen extends ConsumerStatefulWidget {
  const NuevoExpedienteScreen({super.key});

  @override
  ConsumerState<NuevoExpedienteScreen> createState() =>
      _NuevoExpedienteScreenState();
}

class _NuevoExpedienteScreenState
    extends ConsumerState<NuevoExpedienteScreen> {
  final _codigoController = TextEditingController();
  final _nombreController = TextEditingController();
  String? _clienteSeleccionadoId;
  String? _clienteSeleccionadoNombre;

  @override
  void dispose() {
    _codigoController.dispose();
    _nombreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clienteRepository = ClienteRepository(ref.read(databaseProvider));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo expediente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _codigoController,
              decoration: const InputDecoration(
                labelText: 'Código',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
              ),
            ),
            const SizedBox(height: 20),
            StreamBuilder<List<Cliente>>(
              stream: clienteRepository.observarClientes(),
              builder: (context, snapshot) {
                final clientes = snapshot.data ?? [];

                return DropdownButtonFormField<String>(
                  value: _clienteSeleccionadoId,
                  decoration: const InputDecoration(
                    labelText: 'Cliente',
                  ),
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('Sin cliente'),
                    ),
                    ...clientes.map(
                      (cliente) => DropdownMenuItem<String>(
                        value: cliente.id,
                        child: Text(
                          '${cliente.nombre} ${cliente.apellidos}'.trim(),
                        ),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _clienteSeleccionadoId = value;
                      if (value == null) {
                        _clienteSeleccionadoNombre = null;
                      } else {
                        final cliente = clientes.firstWhere(
                          (cliente) => cliente.id == value,
                          orElse: () => Cliente(
                            id: '',
                            nombre: '',
                            apellidos: '',
                            nif: '',
                            telefono: '',
                            email: '',
                            direccion: '',
                            poblacion: '',
                            provincia: '',
                            codigoPostal: '',
                            pais: '',
                            empresa: '',
                            observaciones: '',
                            estado: 0,
                            eliminado: false,
                            fechaCreacion: DateTime.now(),
                            fechaModificacion: DateTime.now(),
                          ),
                        );
                        _clienteSeleccionadoNombre = cliente.nombre;
                      }
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 30),
            FilledButton.icon(
              onPressed: () async {
                final db = ref.read(databaseProvider);

                await db.crearExpediente(
                  codigo: _codigoController.text.trim(),
                  nombre: _nombreController.text.trim(),
                  clienteId: _clienteSeleccionadoId,
                  cliente: _clienteSeleccionadoNombre,
                );

                if (!context.mounted) return;

                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.save),
              label: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
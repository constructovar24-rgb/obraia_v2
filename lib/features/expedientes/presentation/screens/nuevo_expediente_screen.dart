import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/shortcuts/app_shortcuts.dart';
import '../../../clientes/domain/cliente.dart';
import '../../../clientes/presentation/providers/cliente_providers.dart';
import '../../data/expediente_repository.dart';

class NuevoExpedienteScreen extends ConsumerStatefulWidget {
  const NuevoExpedienteScreen({super.key, this.clienteInicial});

  final Cliente? clienteInicial;

  @override
  ConsumerState<NuevoExpedienteScreen> createState() =>
      _NuevoExpedienteScreenState();
}

class _NuevoExpedienteScreenState
    extends ConsumerState<NuevoExpedienteScreen> {
  final _codigoController = TextEditingController();
  final _nombreController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _clienteSeleccionadoId;
  String? _clienteSeleccionadoNombre;

  @override
  void initState() {
    super.initState();
    final cliente = widget.clienteInicial;
    _clienteSeleccionadoId = cliente?.id;
    _clienteSeleccionadoNombre = cliente == null
        ? null
        : '${cliente.nombre} ${cliente.apellidos}'.trim();
  }

  @override
  void dispose() {
    _codigoController.dispose();
    _nombreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clienteRepository = ref.read(clienteRepositoryProvider);

    return AppShortcutScope(
      onBack: () {
        Navigator.maybePop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nuevo expediente'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _codigoController,
                  decoration: const InputDecoration(
                    labelText: 'Código',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El código es obligatorio';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El nombre es obligatorio';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                StreamBuilder<List<Cliente>>(
                  stream: clienteRepository.observarClientes(),
                  builder: (context, snapshot) {
                    final clientes = snapshot.data ?? [];

                    return DropdownButtonFormField<String>(
                      initialValue: _clienteSeleccionadoId,
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
                            _clienteSeleccionadoNombre =
                                '${cliente.nombre} ${cliente.apellidos}'.trim();
                          }
                        });
                      },
                    );
                  },
                ),
                const SizedBox(height: 30),
                FilledButton.icon(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }

                    final expedienteRepository = ref.read(
                      expedienteRepositoryProvider,
                    );

                    await expedienteRepository.crearExpediente(
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
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/shortcuts/app_shortcuts.dart';
import '../../../../database/database_provider.dart';
import '../../data/cliente_repository.dart';

class NuevoClienteScreen extends ConsumerStatefulWidget {
  const NuevoClienteScreen({super.key});

  @override
  ConsumerState<NuevoClienteScreen> createState() =>
      _NuevoClienteScreenState();
}

class _NuevoClienteScreenState extends ConsumerState<NuevoClienteScreen> {
  final _nombreController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _nifController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _emailController = TextEditingController();
  final _direccionController = TextEditingController();
  final _poblacionController = TextEditingController();
  final _provinciaController = TextEditingController();
  final _codigoPostalController = TextEditingController();
  final _paisController = TextEditingController(text: 'España');
  final _empresaController = TextEditingController();
  final _observacionesController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidosController.dispose();
    _nifController.dispose();
    _telefonoController.dispose();
    _emailController.dispose();
    _direccionController.dispose();
    _poblacionController.dispose();
    _provinciaController.dispose();
    _codigoPostalController.dispose();
    _paisController.dispose();
    _empresaController.dispose();
    _observacionesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repository = ClienteRepository(ref.read(databaseProvider));

    return AppShortcutScope(
      onBack: () {
        Navigator.maybePop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nuevo cliente'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _nombreController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _apellidosController,
                  decoration: const InputDecoration(
                    labelText: 'Apellidos',
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _nifController,
                  decoration: const InputDecoration(
                    labelText: 'NIF',
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _telefonoController,
                  decoration: const InputDecoration(
                    labelText: 'Teléfono',
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _direccionController,
                  decoration: const InputDecoration(
                    labelText: 'Dirección',
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _poblacionController,
                  decoration: const InputDecoration(
                    labelText: 'Población',
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _provinciaController,
                  decoration: const InputDecoration(
                    labelText: 'Provincia',
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _codigoPostalController,
                  decoration: const InputDecoration(
                    labelText: 'Código postal',
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _paisController,
                  decoration: const InputDecoration(
                    labelText: 'País',
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _empresaController,
                  decoration: const InputDecoration(
                    labelText: 'Empresa',
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _observacionesController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Observaciones',
                  ),
                ),
                const SizedBox(height: 30),
                FilledButton.icon(
                  onPressed: () async {
                    await repository.crearCliente(
                      nombre: _nombreController.text.trim(),
                      apellidos: _apellidosController.text.trim(),
                      nif: _nifController.text.trim(),
                      telefono: _telefonoController.text.trim(),
                      email: _emailController.text.trim(),
                      direccion: _direccionController.text.trim(),
                      poblacion: _poblacionController.text.trim(),
                      provincia: _provinciaController.text.trim(),
                      codigoPostal: _codigoPostalController.text.trim(),
                      pais: _paisController.text.trim(),
                      empresa: _empresaController.text.trim(),
                      observaciones: _observacionesController.text.trim(),
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

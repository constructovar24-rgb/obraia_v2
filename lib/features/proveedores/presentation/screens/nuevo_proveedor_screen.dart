import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/shortcuts/app_shortcuts.dart';
import '../../domain/proveedor.dart';
import '../providers/proveedor_providers.dart';

class NuevoProveedorScreen extends ConsumerStatefulWidget {
  const NuevoProveedorScreen({super.key});

  @override
  ConsumerState<NuevoProveedorScreen> createState() =>
      _NuevoProveedorScreenState();
}

class _NuevoProveedorScreenState extends ConsumerState<NuevoProveedorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _personaContactoController = TextEditingController();
  final _nifController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _emailController = TextEditingController();
  final _direccionController = TextEditingController();
  final _poblacionController = TextEditingController();
  final _provinciaController = TextEditingController();
  final _codigoPostalController = TextEditingController();
  final _paisController = TextEditingController(text: 'España');
  final _observacionesController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    _personaContactoController.dispose();
    _nifController.dispose();
    _telefonoController.dispose();
    _emailController.dispose();
    _direccionController.dispose();
    _poblacionController.dispose();
    _provinciaController.dispose();
    _codigoPostalController.dispose();
    _paisController.dispose();
    _observacionesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repository = ref.read(proveedorRepositoryProvider);

    return AppShortcutScope(
      onBack: () {
        Navigator.maybePop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nuevo proveedor'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
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
                TextFormField(
                  controller: _personaContactoController,
                  decoration: const InputDecoration(
                    labelText: 'Persona de contacto',
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nifController,
                  decoration: const InputDecoration(
                    labelText: 'NIF',
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _telefonoController,
                  decoration: const InputDecoration(
                    labelText: 'Teléfono',
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _direccionController,
                  decoration: const InputDecoration(
                    labelText: 'Dirección',
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _poblacionController,
                  decoration: const InputDecoration(
                    labelText: 'Población',
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _provinciaController,
                  decoration: const InputDecoration(
                    labelText: 'Provincia',
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _codigoPostalController,
                  decoration: const InputDecoration(
                    labelText: 'Código Postal',
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _paisController,
                  decoration: const InputDecoration(
                    labelText: 'País',
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _observacionesController,
                  decoration: const InputDecoration(
                    labelText: 'Observaciones',
                  ),
                  minLines: 3,
                  maxLines: 5,
                ),
                const SizedBox(height: 30),
                FilledButton.icon(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }

                    final personaContacto =
                        _personaContactoController.text.trim().isEmpty
                        ? null
                        : _personaContactoController.text.trim();

                    await repository.registrarProveedor(
                      Proveedor(
                        id: '',
                        nombre: _nombreController.text.trim(),
                        personaContacto: personaContacto,
                        nif: _nifController.text.trim(),
                        telefono: _telefonoController.text.trim(),
                        email: _emailController.text.trim(),
                        direccion: _direccionController.text.trim(),
                        poblacion: _poblacionController.text.trim(),
                        provincia: _provinciaController.text.trim(),
                        codigoPostal: _codigoPostalController.text.trim(),
                        pais: _paisController.text.trim(),
                        observaciones: _observacionesController.text.trim(),
                      ),
                    );

                    if (!context.mounted) {
                      return;
                    }

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

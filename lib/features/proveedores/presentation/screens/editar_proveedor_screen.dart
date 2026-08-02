import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/shortcuts/app_shortcuts.dart';
import '../../domain/proveedor.dart';
import '../providers/proveedor_providers.dart';

class EditarProveedorScreen extends ConsumerStatefulWidget {
  const EditarProveedorScreen({
    super.key,
    required this.proveedor,
  });

  final Proveedor proveedor;

  @override
  ConsumerState<EditarProveedorScreen> createState() =>
      _EditarProveedorScreenState();
}

class _EditarProveedorScreenState extends ConsumerState<EditarProveedorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreController;
  late final TextEditingController _personaContactoController;
  late final TextEditingController _nifController;
  late final TextEditingController _telefonoController;
  late final TextEditingController _emailController;
  late final TextEditingController _direccionController;
  late final TextEditingController _poblacionController;
  late final TextEditingController _provinciaController;
  late final TextEditingController _codigoPostalController;
  late final TextEditingController _paisController;
  late final TextEditingController _observacionesController;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.proveedor.nombre);
    _personaContactoController = TextEditingController(
      text: widget.proveedor.personaContacto ?? '',
    );
    _nifController = TextEditingController(text: widget.proveedor.nif);
    _telefonoController = TextEditingController(text: widget.proveedor.telefono);
    _emailController = TextEditingController(text: widget.proveedor.email);
    _direccionController = TextEditingController(text: widget.proveedor.direccion);
    _poblacionController = TextEditingController(text: widget.proveedor.poblacion);
    _provinciaController = TextEditingController(text: widget.proveedor.provincia);
    _codigoPostalController = TextEditingController(
      text: widget.proveedor.codigoPostal,
    );
    _paisController = TextEditingController(text: widget.proveedor.pais);
    _observacionesController = TextEditingController(
      text: widget.proveedor.observaciones,
    );
  }

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

  Future<void> _guardarProveedor() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final repository = ref.read(proveedorRepositoryProvider);
    final personaContacto = _personaContactoController.text.trim().isEmpty
        ? null
        : _personaContactoController.text.trim();

    final proveedorActualizado = Proveedor(
      id: widget.proveedor.id,
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
    );

    await repository.actualizarProveedor(proveedorActualizado);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppShortcutScope(
      onBack: () {
        Navigator.maybePop(context);
      },
      onSave: () {
        _guardarProveedor();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Editar proveedor'),
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
                    await _guardarProveedor();
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

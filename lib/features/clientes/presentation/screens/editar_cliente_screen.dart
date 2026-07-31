import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/shortcuts/app_shortcuts.dart';
import '../../../../database/database_provider.dart';
import '../../data/cliente_repository.dart';
import '../../domain/cliente.dart';

class EditarClienteScreen extends ConsumerStatefulWidget {
  const EditarClienteScreen({
    super.key,
    required this.cliente,
  });

  final Cliente cliente;

  @override
  ConsumerState<EditarClienteScreen> createState() =>
      _EditarClienteScreenState();
}

class _EditarClienteScreenState extends ConsumerState<EditarClienteScreen> {
  late final TextEditingController _nombreController;
  late final TextEditingController _apellidosController;
  late final TextEditingController _nifController;
  late final TextEditingController _telefonoController;
  late final TextEditingController _emailController;
  late final TextEditingController _direccionController;
  late final TextEditingController _poblacionController;
  late final TextEditingController _provinciaController;
  late final TextEditingController _codigoPostalController;
  late final TextEditingController _paisController;
  late final TextEditingController _empresaController;
  late final TextEditingController _observacionesController;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.cliente.nombre);
    _apellidosController = TextEditingController(text: widget.cliente.apellidos);
    _nifController = TextEditingController(text: widget.cliente.nif);
    _telefonoController = TextEditingController(text: widget.cliente.telefono);
    _emailController = TextEditingController(text: widget.cliente.email);
    _direccionController = TextEditingController(text: widget.cliente.direccion);
    _poblacionController = TextEditingController(text: widget.cliente.poblacion);
    _provinciaController = TextEditingController(text: widget.cliente.provincia);
    _codigoPostalController = TextEditingController(text: widget.cliente.codigoPostal);
    _paisController = TextEditingController(text: widget.cliente.pais);
    _empresaController = TextEditingController(text: widget.cliente.empresa);
    _observacionesController =
        TextEditingController(text: widget.cliente.observaciones);
  }

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

    Future<void> guardarCambios() async {
      await repository.actualizarCliente(
        id: widget.cliente.id,
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
    }

    return AppShortcutScope(
      onBack: () {
        Navigator.maybePop(context);
      },
      onSave: () {
        guardarCambios();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Editar cliente'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _apellidosController,
                  decoration: const InputDecoration(labelText: 'Apellidos'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _nifController,
                  decoration: const InputDecoration(labelText: 'NIF'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _telefonoController,
                  decoration: const InputDecoration(labelText: 'Teléfono'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _direccionController,
                  decoration: const InputDecoration(labelText: 'Dirección'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _poblacionController,
                  decoration: const InputDecoration(labelText: 'Población'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _provinciaController,
                  decoration: const InputDecoration(labelText: 'Provincia'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _codigoPostalController,
                  decoration: const InputDecoration(labelText: 'Código postal'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _paisController,
                  decoration: const InputDecoration(labelText: 'País'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _empresaController,
                  decoration: const InputDecoration(labelText: 'Empresa'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _observacionesController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Observaciones'),
                ),
                const SizedBox(height: 30),
                FilledButton.icon(
                  onPressed: guardarCambios,
                  icon: const Icon(Icons.save),
                  label: const Text('Guardar cambios'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

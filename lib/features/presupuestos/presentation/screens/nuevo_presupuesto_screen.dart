import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/presupuesto_repository.dart';

class NuevoPresupuestoScreen extends ConsumerStatefulWidget {
  const NuevoPresupuestoScreen({
    super.key,
    required this.expedienteId,
  });

  final String expedienteId;

  @override
  ConsumerState<NuevoPresupuestoScreen> createState() =>
      _NuevoPresupuestoScreenState();
}

class _NuevoPresupuestoScreenState
    extends ConsumerState<NuevoPresupuestoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codigoController = TextEditingController();
  final _fechaController = TextEditingController();
  final _descripcionController = TextEditingController();
  late DateTime _fechaSeleccionada;

  @override
  void initState() {
    super.initState();
    _fechaSeleccionada = DateTime.now();
    _fechaController.text = _formatearFecha(_fechaSeleccionada);
  }

  @override
  void dispose() {
    _codigoController.dispose();
    _fechaController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  String _formatearFecha(DateTime fecha) {
    final day = fecha.day.toString().padLeft(2, '0');
    final month = fecha.month.toString().padLeft(2, '0');
    final year = fecha.year.toString();
    return '$day/$month/$year';
  }

  Future<void> _seleccionarFecha() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked == null) {
      return;
    }

    setState(() {
      _fechaSeleccionada = picked;
      _fechaController.text = _formatearFecha(_fechaSeleccionada);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo presupuesto'),
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
                readOnly: true,
                controller: _fechaController,
                decoration: const InputDecoration(
                  labelText: 'Fecha',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: _seleccionarFecha,
                validator: (value) =>
                    (value == null || value.trim().isEmpty)
                        ? 'La fecha es obligatoria'
                        : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                ),
                minLines: 3,
                maxLines: 5,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }

                    final repository = ref.read(presupuestoRepositoryProvider);
                    final fecha = DateTime(
                      _fechaSeleccionada.year,
                      _fechaSeleccionada.month,
                      _fechaSeleccionada.day,
                    );

                    await repository.crearPresupuesto(
                      expedienteId: widget.expedienteId,
                      codigo: _codigoController.text.trim(),
                      fecha: fecha,
                      descripcion: _descripcionController.text.trim(),
                    );

                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('Guardar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/shortcuts/app_shortcuts.dart';
import '../../../../core/ui/app_spacing.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_section.dart';
import '../providers/presupuesto_providers.dart';

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
  static const List<String> _estados = [
    'Borrador',
    'Presentado',
    'Aceptado',
    'Rechazado',
  ];

  final _formKey = GlobalKey<FormState>();
  final _fechaController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _importeTotalController = TextEditingController();
  late DateTime _fechaSeleccionada;
  String _estadoSeleccionado = 'Borrador';

  @override
  void initState() {
    super.initState();
    _fechaSeleccionada = DateTime.now();
    _fechaController.text = _formatearFecha(_fechaSeleccionada);
  }

  @override
  void dispose() {
    _fechaController.dispose();
    _descripcionController.dispose();
    _importeTotalController.dispose();
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
    return AppShortcutScope(
      onBack: () {
        Navigator.maybePop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nuevo presupuesto'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                AppSection(
                  title: 'Datos del presupuesto',
                  subtitle:
                      'Completa la información para registrar el presupuesto en el expediente.',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
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
                      const SizedBox(height: AppSpacing.lg),
                      TextFormField(
                        controller: _descripcionController,
                        decoration: const InputDecoration(
                          labelText: 'Descripción',
                        ),
                        minLines: 3,
                        maxLines: 5,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      TextFormField(
                        controller: _importeTotalController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Importe total (€)',
                        ),
                        validator: (value) {
                          final raw = value?.trim() ?? '';
                          if (raw.isEmpty) {
                            return null;
                          }

                          final parsed = double.tryParse(raw.replaceAll(',', '.'));
                          if (parsed == null) {
                            return 'Introduce un importe decimal válido';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      DropdownButtonFormField<String>(
                        initialValue: _estadoSeleccionado,
                        decoration: const InputDecoration(
                          labelText: 'Estado',
                        ),
                        items: _estados
                            .map(
                              (estado) => DropdownMenuItem<String>(
                                value: estado,
                                child: Text(estado),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            _estadoSeleccionado = value;
                          });
                        },
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      AppPrimaryButton(
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
                          final importeRaw = _importeTotalController.text.trim();
                          final importeTotal = importeRaw.isEmpty
                              ? 0.0
                              : (double.tryParse(importeRaw.replaceAll(',', '.')) ??
                                  0.0);

                          await repository.crearPresupuesto(
                            expedienteId: widget.expedienteId,
                            fecha: fecha,
                            descripcion: _descripcionController.text.trim(),
                            importeTotal: importeTotal,
                            estado: _estadoSeleccionado,
                          );

                          if (!context.mounted) return;
                          Navigator.of(context).pop();
                        },
                        icon: Icons.save,
                        label: 'Guardar',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

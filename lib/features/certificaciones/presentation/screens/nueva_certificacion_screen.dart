import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/shortcuts/app_shortcuts.dart';
import '../../../../core/ui/app_spacing.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_section.dart';
import '../../domain/certificacion.dart';
import '../providers/certificacion_providers.dart';

class NuevaCertificacionScreen extends ConsumerStatefulWidget {
  const NuevaCertificacionScreen({
    super.key,
    required this.expedienteId,
  });

  final String expedienteId;

  @override
  ConsumerState<NuevaCertificacionScreen> createState() =>
      _NuevaCertificacionScreenState();
}

class _NuevaCertificacionScreenState
    extends ConsumerState<NuevaCertificacionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fechaController = TextEditingController();
  final _codigoController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _baseImponibleController = TextEditingController();
  final _ivaPorcentajeController = TextEditingController(text: '0');
  final _observacionesController = TextEditingController();

  late DateTime _fechaSeleccionada;
  CertificacionEstado _estadoSeleccionado = CertificacionEstado.borrador;

  @override
  void initState() {
    super.initState();
    _fechaSeleccionada = DateTime.now();
    _fechaController.text = _formatearFecha(_fechaSeleccionada);
  }

  @override
  void dispose() {
    _fechaController.dispose();
    _codigoController.dispose();
    _descripcionController.dispose();
    _baseImponibleController.dispose();
    _ivaPorcentajeController.dispose();
    _observacionesController.dispose();
    super.dispose();
  }

  String _formatearFecha(DateTime fecha) {
    final day = fecha.day.toString().padLeft(2, '0');
    final month = fecha.month.toString().padLeft(2, '0');
    final year = fecha.year.toString();
    return '$day/$month/$year';
  }

  double _parseDecimalOrZero(String value) {
    final raw = value.trim();
    if (raw.isEmpty) {
      return 0;
    }

    return double.tryParse(raw.replaceAll(',', '.')) ?? 0;
  }

  double _calcularImporteTotal() {
    final baseImponible = _parseDecimalOrZero(_baseImponibleController.text);
    final ivaPorcentaje = _parseDecimalOrZero(_ivaPorcentajeController.text);
    return baseImponible + (baseImponible * ivaPorcentaje / 100);
  }

  String _formatearImporte(double importe) {
    return '${importe.toStringAsFixed(2)} €';
  }

  String _formatearEstado(CertificacionEstado estado) {
    switch (estado) {
      case CertificacionEstado.borrador:
        return 'Borrador';
      case CertificacionEstado.emitida:
        return 'Emitida';
      case CertificacionEstado.facturada:
        return 'Facturada';
    }
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

  Future<void> _guardarCertificacion() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final repository = ref.read(certificacionRepositoryProvider);
    final fecha = DateTime(
      _fechaSeleccionada.year,
      _fechaSeleccionada.month,
      _fechaSeleccionada.day,
    );
    final baseImponible = _parseDecimalOrZero(_baseImponibleController.text);
    final ivaPorcentaje = _parseDecimalOrZero(_ivaPorcentajeController.text);
    final importeTotal = _calcularImporteTotal();

    await repository.registrarCertificacion(
      Certificacion(
        id: '',
        expedienteId: widget.expedienteId,
        presupuestoId: null,
        codigo: _codigoController.text.trim(),
        fecha: fecha,
        descripcion: _descripcionController.text.trim(),
        baseImponible: baseImponible,
        ivaPorcentaje: ivaPorcentaje,
        importeTotal: importeTotal,
        estado: _estadoSeleccionado,
        observaciones: _observacionesController.text.trim().isEmpty
            ? null
            : _observacionesController.text.trim(),
      ),
    );

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AppShortcutScope(
      onBack: () => Navigator.maybePop(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nueva certificación'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                AppSection(
                  title: 'Datos de certificación',
                  subtitle:
                      'Completa la información para registrar la certificación en el expediente.',
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
                        validator: (value) => (value == null || value.trim().isEmpty)
                            ? 'La fecha es obligatoria'
                            : null,
                      ),
                      const SizedBox(height: AppSpacing.lg),
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
                      const SizedBox(height: AppSpacing.lg),
                      TextFormField(
                        controller: _descripcionController,
                        decoration: const InputDecoration(
                          labelText: 'Descripción',
                        ),
                        minLines: 2,
                        maxLines: 4,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'La descripción es obligatoria';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      TextFormField(
                        controller: _baseImponibleController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Base imponible (€)',
                        ),
                        validator: (value) {
                          final raw = value?.trim() ?? '';
                          if (raw.isEmpty) {
                            return null;
                          }

                          if (double.tryParse(raw.replaceAll(',', '.')) == null) {
                            return 'Introduce una base imponible válida';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      TextFormField(
                        controller: _ivaPorcentajeController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'IVA (%)',
                        ),
                        validator: (value) {
                          final raw = value?.trim() ?? '';
                          if (raw.isEmpty) {
                            return null;
                          }

                          final parsed = double.tryParse(raw.replaceAll(',', '.'));
                          if (parsed == null) {
                            return 'Introduce un IVA válido';
                          }

                          if (parsed < 0 || parsed > 100) {
                            return 'El IVA debe estar entre 0 y 100';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _baseImponibleController,
                        builder: (context, valueBase, child) {
                          return ValueListenableBuilder<TextEditingValue>(
                            valueListenable: _ivaPorcentajeController,
                            builder: (context, valueIva, child) {
                              return InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Importe total (€)',
                                ),
                                child: Text(
                                  _formatearImporte(_calcularImporteTotal()),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      DropdownButtonFormField<CertificacionEstado>(
                        initialValue: _estadoSeleccionado,
                        decoration: const InputDecoration(
                          labelText: 'Estado',
                        ),
                        items: CertificacionEstado.values
                            .map(
                              (estado) => DropdownMenuItem<CertificacionEstado>(
                                value: estado,
                                child: Text(_formatearEstado(estado)),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }

                          setState(() {
                            _estadoSeleccionado = value;
                          });
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      TextFormField(
                        controller: _observacionesController,
                        decoration: const InputDecoration(
                          labelText: 'Observaciones',
                        ),
                        minLines: 3,
                        maxLines: 5,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      AppPrimaryButton(
                        onPressed: _guardarCertificacion,
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

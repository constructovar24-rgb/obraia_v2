import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/shortcuts/app_shortcuts.dart';
import '../../../proveedores/presentation/providers/proveedor_providers.dart';
import '../../domain/compra.dart';
import '../providers/compra_providers.dart';

class NuevaCompraScreen extends ConsumerStatefulWidget {
  const NuevaCompraScreen({
    super.key,
    required this.expedienteId,
  });

  final String expedienteId;

  @override
  ConsumerState<NuevaCompraScreen> createState() => _NuevaCompraScreenState();
}

class _NuevaCompraScreenState extends ConsumerState<NuevaCompraScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fechaController = TextEditingController();
  final _proveedorNombreController = TextEditingController();
  final _numeroFacturaController = TextEditingController();
  final _conceptoController = TextEditingController();
  final _baseImponibleController = TextEditingController();
  final _ivaPorcentajeController = TextEditingController(text: '21');
  final _observacionesController = TextEditingController();

  late DateTime _fechaSeleccionada;
  CompraEstado _estadoSeleccionado = CompraEstado.pendiente;
  String? _proveedorIdSeleccionado;

  @override
  void initState() {
    super.initState();
    _fechaSeleccionada = DateTime.now();
    _fechaController.text = _formatearFecha(_fechaSeleccionada);
  }

  @override
  void dispose() {
    _fechaController.dispose();
    _proveedorNombreController.dispose();
    _numeroFacturaController.dispose();
    _conceptoController.dispose();
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

  @override
  Widget build(BuildContext context) {
    final proveedoresAsync = ref.watch(proveedoresProvider);

    return AppShortcutScope(
      onBack: () {
        Navigator.maybePop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nueva compra'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: ListView(
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
                const SizedBox(height: 20),
                proveedoresAsync.when(
                  loading: () {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                  error: (error, _) {
                    return SelectableText(
                      'No se pudieron cargar proveedores:\n$error',
                      style: const TextStyle(color: Colors.red),
                    );
                  },
                  data: (proveedores) {
                    return DropdownButtonFormField<String>(
                      initialValue: _proveedorIdSeleccionado,
                      decoration: const InputDecoration(
                        labelText: 'Proveedor',
                      ),
                      items: proveedores
                          .map(
                            (proveedor) => DropdownMenuItem<String>(
                              value: proveedor.id,
                              child: Text(proveedor.nombre),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _proveedorIdSeleccionado = value;
                          final proveedorSeleccionado = proveedores
                              .where((proveedor) => proveedor.id == value)
                              .firstOrNull;
                          _proveedorNombreController.text =
                              proveedorSeleccionado?.nombre ?? '';
                        });
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'El proveedor es obligatorio';
                        }
                        return null;
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _numeroFacturaController,
                  decoration: const InputDecoration(
                    labelText: 'Número de factura',
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _conceptoController,
                  decoration: const InputDecoration(
                    labelText: 'Concepto',
                  ),
                  minLines: 2,
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El concepto es obligatorio';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
                DropdownButtonFormField<CompraEstado>(
                  initialValue: _estadoSeleccionado,
                  decoration: const InputDecoration(
                    labelText: 'Estado',
                  ),
                  items: CompraEstado.values
                      .map(
                        (estado) => DropdownMenuItem<CompraEstado>(
                          value: estado,
                          child: Text(estado.name),
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
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }

                      final proveedores = proveedoresAsync.valueOrNull;
                      if (proveedores == null) {
                        return;
                      }

                      final proveedorSeleccionado = proveedores
                          .where(
                            (proveedor) =>
                                proveedor.id == _proveedorIdSeleccionado,
                          )
                          .firstOrNull;
                      if (proveedorSeleccionado == null) {
                        return;
                      }

                      final repository = ref.read(compraRepositoryProvider);
                      final fecha = DateTime(
                        _fechaSeleccionada.year,
                        _fechaSeleccionada.month,
                        _fechaSeleccionada.day,
                      );
                      final importeTotal = _calcularImporteTotal();

                      await repository.registrarCompra(
                        Compra(
                          id: const Uuid().v4(),
                          expedienteId: widget.expedienteId,
                          proveedorId: proveedorSeleccionado.id,
                          proveedorNombre: proveedorSeleccionado.nombre,
                          fecha: fecha,
                          numeroFactura: _numeroFacturaController.text.trim().isEmpty
                              ? null
                              : _numeroFacturaController.text.trim(),
                          concepto: _conceptoController.text.trim(),
                          baseImponible: _parseDecimalOrZero(
                            _baseImponibleController.text,
                          ),
                          ivaPorcentaje: _parseDecimalOrZero(
                            _ivaPorcentajeController.text,
                          ),
                          importeTotal: importeTotal,
                          estado: _estadoSeleccionado,
                          observaciones: _observacionesController.text.trim().isEmpty
                              ? null
                              : _observacionesController.text.trim(),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/factura_linea_repository.dart';

class NuevaLineaFacturaScreen extends ConsumerStatefulWidget {
  const NuevaLineaFacturaScreen({super.key, required this.facturaId});

  final String facturaId;

  @override
  ConsumerState<NuevaLineaFacturaScreen> createState() =>
      _NuevaLineaFacturaScreenState();
}

class _NuevaLineaFacturaScreenState
    extends ConsumerState<NuevaLineaFacturaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva linea')),
      body: LineaFacturaForm(
        onSubmit: (descripcion, cantidad, unidad, precioUnitario, descuento) async {
          final repository = ref.read(facturaLineaRepositoryProvider);

          try {
            await repository.crearLinea(
              facturaId: widget.facturaId,
              descripcion: descripcion,
              cantidad: cantidad,
              unidad: unidad,
              precioUnitario: precioUnitario,
              descuento: descuento,
            );
          } on TotalFacturaInferiorACobrosException {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'No puedes reducir el total de la factura por debajo del importe ya cobrado.',
                ),
              ),
            );
            return;
          } on FacturaNoPermiteModificarLineasException {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Las líneas de una factura emitida no pueden modificarse. Anula la factura y crea una nueva para corregirla.',
                ),
              ),
            );
            return;
          }

          if (!context.mounted) return;
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

class LineaFacturaForm extends StatefulWidget {
  const LineaFacturaForm({
    super.key,
    required this.onSubmit,
    this.initialDescripcion = '',
    this.initialCantidad,
    this.initialUnidad = 'ud',
    this.initialPrecioUnitario,
    this.initialDescuento,
    this.submitLabel = 'Guardar',
    this.footer,
  });

  final Future<void> Function(
    String descripcion,
    double cantidad,
    String unidad,
    double precioUnitario,
    double descuento,
  )
  onSubmit;
  final String initialDescripcion;
  final double? initialCantidad;
  final String initialUnidad;
  final double? initialPrecioUnitario;
  final double? initialDescuento;
  final String submitLabel;
  final Widget? footer;

  @override
  State<LineaFacturaForm> createState() => _LineaFacturaFormState();
}

class _LineaFacturaFormState extends State<LineaFacturaForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _descripcionController;
  late final TextEditingController _cantidadController;
  late final TextEditingController _unidadController;
  late final TextEditingController _precioUnitarioController;
  late final TextEditingController _descuentoController;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _descripcionController = TextEditingController(
      text: widget.initialDescripcion,
    );
    _cantidadController = TextEditingController(
      text: widget.initialCantidad != null
          ? _formatDecimal(widget.initialCantidad!)
          : '',
    );
    _unidadController = TextEditingController(text: widget.initialUnidad);
    _precioUnitarioController = TextEditingController(
      text: widget.initialPrecioUnitario != null
          ? _formatDecimal(widget.initialPrecioUnitario!)
          : '',
    );
    _descuentoController = TextEditingController(
      text: widget.initialDescuento != null
          ? _formatDecimal(widget.initialDescuento!)
          : '0',
    );
  }

  @override
  void dispose() {
    _descripcionController.dispose();
    _cantidadController.dispose();
    _unidadController.dispose();
    _precioUnitarioController.dispose();
    _descuentoController.dispose();
    super.dispose();
  }

  double _parseDecimal(String value) {
    return double.parse(value.replaceAll(',', '.'));
  }

  String _formatDecimal(double value) {
    if (value == value.truncateToDouble()) {
      return value.toStringAsFixed(0);
    }

    return value.toStringAsFixed(2).replaceAll('.', ',');
  }

  String _formatearMoneda(double value) {
    return '${value.toStringAsFixed(2).replaceAll('.', ',')} €';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _descripcionController,
              decoration: const InputDecoration(labelText: 'Descripcion'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'La descripcion es obligatoria';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _cantidadController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(labelText: 'Cantidad'),
              validator: (value) {
                final raw = value?.trim() ?? '';
                if (raw.isEmpty) {
                  return 'La cantidad es obligatoria';
                }

                if (double.tryParse(raw.replaceAll(',', '.')) == null) {
                  return 'Introduce una cantidad valida';
                }

                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _unidadController,
              decoration: const InputDecoration(labelText: 'Unidad'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'La unidad es obligatoria';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _precioUnitarioController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Precio unitario (€)',
              ),
              validator: (value) {
                final raw = value?.trim() ?? '';
                if (raw.isEmpty) {
                  return 'El precio unitario es obligatorio';
                }

                if (double.tryParse(raw.replaceAll(',', '.')) == null) {
                  return 'Introduce un precio unitario valido';
                }

                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _descuentoController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(labelText: 'Descuento (%)'),
              validator: (value) {
                final raw = value?.trim() ?? '';
                if (raw.isEmpty) {
                  return null;
                }

                final parsed = double.tryParse(raw.replaceAll(',', '.'));
                if (parsed == null) {
                  return 'Introduce un descuento valido';
                }

                if (parsed < 0 || parsed > 100) {
                  return 'El descuento debe estar entre 0 y 100';
                }

                return null;
              },
            ),
            const SizedBox(height: 20),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _cantidadController,
              builder: (context, valueCantidad, childCantidad) {
                return ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _precioUnitarioController,
                  builder: (context, valuePrecio, childPrecio) {
                    return ValueListenableBuilder<TextEditingValue>(
                      valueListenable: _descuentoController,
                      builder: (context, valueDescuento, childDescuento) {
                        final cantidad =
                            double.tryParse(
                              _cantidadController.text.trim().replaceAll(
                                ',',
                                '.',
                              ),
                            ) ??
                            0;
                        final precio =
                            double.tryParse(
                              _precioUnitarioController.text.trim().replaceAll(
                                ',',
                                '.',
                              ),
                            ) ??
                            0;
                        final descuento =
                            double.tryParse(
                              _descuentoController.text.trim().replaceAll(
                                ',',
                                '.',
                              ),
                            ) ??
                            0;
                        final bruto = cantidad * precio;
                        final importe = bruto * ((100 - descuento) / 100);

                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Importe: ${_formatearMoneda(importe)}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _guardando
                    ? null
                    : () async {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }

                        setState(() => _guardando = true);
                        try {
                          await widget.onSubmit(
                            _descripcionController.text.trim(),
                            _parseDecimal(_cantidadController.text.trim()),
                            _unidadController.text.trim(),
                            _parseDecimal(
                              _precioUnitarioController.text.trim(),
                            ),
                            _descuentoController.text.trim().isEmpty
                                ? 0
                                : _parseDecimal(
                                    _descuentoController.text.trim(),
                                  ),
                          );
                        } finally {
                          if (mounted) setState(() => _guardando = false);
                        }
                      },
                icon: _guardando
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: Text(_guardando ? 'Guardando...' : widget.submitLabel),
              ),
            ),
            if (widget.footer != null) ...[
              const SizedBox(height: 12),
              widget.footer!,
            ],
          ],
        ),
      ),
    );
  }
}

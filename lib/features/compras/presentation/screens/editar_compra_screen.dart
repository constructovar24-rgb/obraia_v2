import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/shortcuts/app_shortcuts.dart';
import '../../../proveedores/presentation/providers/proveedor_providers.dart';
import '../../domain/compra.dart';
import '../providers/compra_providers.dart';

class EditarCompraScreen extends ConsumerStatefulWidget {
  const EditarCompraScreen({
    super.key,
    required this.compra,
  });

  final Compra compra;

  @override
  ConsumerState<EditarCompraScreen> createState() => _EditarCompraScreenState();
}

class _EditarCompraScreenState extends ConsumerState<EditarCompraScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fechaController;
  late final TextEditingController _proveedorNombreController;
  late final TextEditingController _numeroFacturaController;
  late final TextEditingController _conceptoController;
  late final TextEditingController _baseImponibleController;
  late final TextEditingController _ivaPorcentajeController;
  late final TextEditingController _observacionesController;

  late DateTime _fechaSeleccionada;
  late CompraEstado _estadoSeleccionado;
  String? _proveedorIdSeleccionado;

  @override
  void initState() {
    super.initState();
    _fechaController = TextEditingController();
    _proveedorNombreController = TextEditingController(
      text: widget.compra.proveedorNombre,
    );
    _numeroFacturaController = TextEditingController(
      text: widget.compra.numeroFactura ?? '',
    );
    _conceptoController = TextEditingController(text: widget.compra.concepto);
    _baseImponibleController = TextEditingController(
      text: _formatearDecimalInput(widget.compra.baseImponible),
    );
    _ivaPorcentajeController = TextEditingController(
      text: _formatearDecimalInput(widget.compra.ivaPorcentaje),
    );
    _observacionesController = TextEditingController(
      text: widget.compra.observaciones ?? '',
    );

    _fechaSeleccionada = widget.compra.fecha;
    _estadoSeleccionado = widget.compra.estado;
    _proveedorIdSeleccionado = widget.compra.proveedorId;
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

  String _formatearDecimalInput(double value) {
    if (value == value.truncateToDouble()) {
      return value.toStringAsFixed(0);
    }

    return value.toStringAsFixed(2).replaceAll('.', ',');
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

  Future<void> _guardarCompra() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final proveedores = ref.read(proveedoresProvider).valueOrNull;
    if (proveedores == null) {
      return;
    }

    dynamic proveedorSeleccionado;
    for (final proveedor in proveedores) {
      if (proveedor.id == _proveedorIdSeleccionado) {
        proveedorSeleccionado = proveedor;
        break;
      }
    }

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

    final compraActualizada = Compra(
      id: widget.compra.id,
      expedienteId: widget.compra.expedienteId,
      proveedorId: proveedorSeleccionado.id,
      proveedorNombre: proveedorSeleccionado.nombre,
      fecha: fecha,
      numeroFactura: _numeroFacturaController.text.trim().isEmpty
          ? null
          : _numeroFacturaController.text.trim(),
      concepto: _conceptoController.text.trim(),
      baseImponible: _parseDecimalOrZero(_baseImponibleController.text),
      ivaPorcentaje: _parseDecimalOrZero(_ivaPorcentajeController.text),
      importeTotal: importeTotal,
      estado: _estadoSeleccionado,
      observaciones: _observacionesController.text.trim().isEmpty
          ? null
          : _observacionesController.text.trim(),
    );

    await repository.actualizarCompra(compraActualizada);

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop();
  }

  Future<bool> _confirmarEliminar() async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar compra'),
          content: const Text(
            '¿Seguro que quieres eliminar esta compra?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    return confirmado ?? false;
  }

  Future<void> _eliminarCompra() async {
    final confirmado = await _confirmarEliminar();
    if (!confirmado) {
      return;
    }

    final repository = ref.read(compraRepositoryProvider);
    await repository.eliminarCompra(widget.compra.id);

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final proveedoresAsync = ref.watch(proveedoresProvider);

    return AppShortcutScope(
      onBack: () {
        Navigator.maybePop(context);
      },
      onSave: () {
        _guardarCompra();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Editar compra'),
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
                    var proveedorDisponible = false;
                    for (final proveedor in proveedores) {
                      if (proveedor.id == _proveedorIdSeleccionado) {
                        proveedorDisponible = true;
                        break;
                      }
                    }

                    final proveedorIdActual = proveedorDisponible
                        ? _proveedorIdSeleccionado
                        : null;

                    final mostrarProveedorHistorico =
                        proveedorIdActual == null &&
                        _proveedorNombreController.text.trim().isNotEmpty;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButtonFormField<String>(
                          initialValue: proveedorIdActual,
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
                              for (final proveedor in proveedores) {
                                if (proveedor.id == value) {
                                  _proveedorNombreController.text =
                                      proveedor.nombre;
                                  break;
                                }
                              }
                            });
                          },
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'El proveedor es obligatorio';
                            }
                            return null;
                          },
                        ),
                        if (mostrarProveedorHistorico) ...[
                          const SizedBox(height: 12),
                          TextFormField(
                            readOnly: true,
                            controller: _proveedorNombreController,
                            decoration: const InputDecoration(
                              labelText: 'Proveedor actual (histórico)',
                            ),
                          ),
                        ],
                      ],
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
                      await _guardarCompra();
                    },
                    icon: const Icon(Icons.save),
                    label: const Text('Guardar'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await _eliminarCompra();
                    },
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Eliminar compra'),
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

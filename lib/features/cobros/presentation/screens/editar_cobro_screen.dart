import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/formatters/date_formatter.dart';
import '../../../../core/shortcuts/app_shortcuts.dart';
import '../../../../core/ui/app_spacing.dart';
import '../../../../core/widgets/app_page_header.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_section.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../core/widgets/entity_summary_card.dart';
import '../../data/cobro_repository.dart';
import '../../domain/cobro.dart' as cobro_domain;
import '../../../facturas/domain/estado_factura.dart';

class EditarCobroScreen extends ConsumerStatefulWidget {
  const EditarCobroScreen({
    super.key,
    required this.cobro,
    required this.facturaEstado,
  });

  final cobro_domain.Cobro cobro;
  final EstadoFactura? facturaEstado;

  @override
  ConsumerState<EditarCobroScreen> createState() => _EditarCobroScreenState();
}

class _EditarCobroScreenState extends ConsumerState<EditarCobroScreen> {
  bool get _esFacturaAnulada => widget.facturaEstado == EstadoFactura.anulada;
  static const List<String> _metodosPago = [
    'Transferencia',
    'Efectivo',
    'Tarjeta',
    'Domiciliacion',
    'Otro',
  ];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fechaController;
  late final TextEditingController _importeController;
  late final TextEditingController _referenciaController;
  late final TextEditingController _observacionesController;

  late DateTime _fechaSeleccionada;
  late String _metodoPagoSeleccionado;

  @override
  void initState() {
    super.initState();
    _fechaSeleccionada = widget.cobro.fecha;
    _metodoPagoSeleccionado = _metodosPago.contains(widget.cobro.metodoPago)
        ? widget.cobro.metodoPago
        : _metodosPago.first;

    _fechaController = TextEditingController(
      text: DateFormatter.formatDdMmYyyy(_fechaSeleccionada),
    );
    _importeController = TextEditingController(
      text: widget.cobro.importe.toStringAsFixed(2),
    );
    _referenciaController = TextEditingController(
      text: widget.cobro.referencia,
    );
    _observacionesController = TextEditingController(
      text: widget.cobro.observaciones,
    );
  }

  @override
  void dispose() {
    _fechaController.dispose();
    _importeController.dispose();
    _referenciaController.dispose();
    _observacionesController.dispose();
    super.dispose();
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
      _fechaController.text = DateFormatter.formatDdMmYyyy(_fechaSeleccionada);
    });
  }

  Future<void> _confirmarEliminar() async {
    final importe = _formatearImporte(widget.cobro.importe.toString());
    final mensaje = _esFacturaAnulada
        ? 'Este cobro está asociado a una factura anulada. Se está saneando '
              'un dato histórico incoherente: el cobro de $importe se eliminará '
              'definitivamente, la factura seguirá anulada y la operación no '
              'puede deshacerse.'
        : 'Se eliminará definitivamente el cobro de $importe. Cambiarán el '
              'total cobrado y el saldo pendiente, y el estado de la factura se '
              'recalculará automáticamente. Esta acción no se puede deshacer.';
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Eliminar cobro',
      message: mensaje,
      confirmLabel: 'Eliminar',
      cancelLabel: 'Cancelar',
    );

    if (!confirmed || !mounted) return;

    try {
      await ref.read(cobroRepositoryProvider).eliminarCobro(widget.cobro.id);
      if (!mounted) return;
      Navigator.of(context).pop();
    } on CobroNoEncontradoException {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('El cobro ya no existe.')));
    } on FacturaNoEncontradaException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La factura asociada ya no existe.')),
      );
    } on FacturaNoCobrableException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Los cobros de una factura en borrador o anulada no se pueden eliminar.',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo eliminar el cobro: $error')),
      );
    }
  }

  String _formatearImporte(String rawValue) {
    final parsed = double.tryParse(rawValue.replaceAll(',', '.'));
    if (parsed == null) {
      return rawValue;
    }

    return '${parsed.toStringAsFixed(2)} €';
  }

  Future<void> _guardarCambios() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final repository = ref.read(cobroRepositoryProvider);
    final fecha = DateTime(
      _fechaSeleccionada.year,
      _fechaSeleccionada.month,
      _fechaSeleccionada.day,
    );
    final importe =
        double.tryParse(_importeController.text.trim().replaceAll(',', '.')) ??
        0.0;

    try {
      await repository.actualizarCobro(
        id: widget.cobro.id,
        fecha: fecha,
        importe: importe,
        metodoPago: _metodoPagoSeleccionado,
        referencia: _referenciaController.text.trim(),
        observaciones: _observacionesController.text.trim(),
      );
    } on CobroSuperaPendienteException catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'El importe supera el máximo permitido '
            '(${error.pendienteActual.toStringAsFixed(2)} €).',
          ),
        ),
      );
      return;
    } on FacturaNoCobrableException {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'El estado de la factura no permite modificar este cobro.',
          ),
        ),
      );
      return;
    } on FacturaNoEncontradaException {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se ha encontrado la factura del cobro.'),
        ),
      );
      return;
    } on CobroNoEncontradoException {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('El cobro ya no existe.')));
      return;
    } on ImporteCobroNoValidoException {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El importe debe ser mayor que 0.')),
      );
      return;
    }

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AppShortcutScope(
      onBack: () {
        Navigator.maybePop(context);
      },
      onSave: _esFacturaAnulada
          ? null
          : () {
              _guardarCambios();
            },
      onDelete: () {
        _confirmarEliminar();
      },
      child: Scaffold(
        appBar: AppPageHeader(
          showBackButton: true,
          title: 'Cobro',
          actions: [
            AppPageHeaderAction(
              icon: Icons.delete_outline,
              tooltip: 'Eliminar cobro',
              onPressed: _confirmarEliminar,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                EntitySummaryCard(
                  title: _formatearImporte(_importeController.text),
                  subtitle: _fechaController.text,
                  details: [
                    Text(
                      'Método: $_metodoPagoSeleccionado',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      'Referencia: ${_referenciaController.text.trim().isEmpty ? '-' : _referenciaController.text.trim()}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                AppSection(
                  title: 'Datos del cobro',
                  subtitle: _esFacturaAnulada
                      ? 'Factura anulada: solo se permite revisar y eliminar este cobro legacy.'
                      : 'Actualiza la información del cobro y guarda los cambios.',
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
                        onTap: _esFacturaAnulada ? null : _seleccionarFecha,
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                            ? 'La fecha es obligatoria'
                            : null,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      TextFormField(
                        controller: _importeController,
                        enabled: !_esFacturaAnulada,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(labelText: 'Importe'),
                        validator: (value) {
                          final raw = value?.trim() ?? '';
                          if (raw.isEmpty) {
                            return 'El importe es obligatorio';
                          }

                          final parsed = double.tryParse(
                            raw.replaceAll(',', '.'),
                          );
                          if (parsed == null) {
                            return 'Introduce un importe decimal valido';
                          }

                          if (parsed <= 0) {
                            return 'El importe debe ser mayor que 0';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      DropdownButtonFormField<String>(
                        initialValue: _metodoPagoSeleccionado,
                        onChanged: _esFacturaAnulada
                            ? null
                            : (value) {
                                if (value == null) return;
                                setState(() {
                                  _metodoPagoSeleccionado = value;
                                });
                              },
                        decoration: const InputDecoration(
                          labelText: 'Metodo de pago',
                        ),
                        items: _metodosPago
                            .map(
                              (metodo) => DropdownMenuItem<String>(
                                value: metodo,
                                child: Text(metodo),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      TextFormField(
                        controller: _referenciaController,
                        enabled: !_esFacturaAnulada,
                        decoration: const InputDecoration(
                          labelText: 'Referencia',
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      TextFormField(
                        controller: _observacionesController,
                        enabled: !_esFacturaAnulada,
                        decoration: const InputDecoration(
                          labelText: 'Observaciones',
                        ),
                        minLines: 3,
                        maxLines: 5,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      if (!_esFacturaAnulada)
                        AppPrimaryButton(
                          onPressed: _guardarCambios,
                          icon: Icons.save,
                          label: 'Guardar cambios',
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

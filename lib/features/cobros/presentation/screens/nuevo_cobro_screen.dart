import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/formatters/date_formatter.dart';
import '../../../../core/shortcuts/app_shortcuts.dart';
import '../../data/cobro_repository.dart';

class NuevoCobroScreen extends ConsumerStatefulWidget {
  const NuevoCobroScreen({
    super.key,
    required this.facturaId,
  });

  final String facturaId;

  @override
  ConsumerState<NuevoCobroScreen> createState() => _NuevoCobroScreenState();
}

class _NuevoCobroScreenState extends ConsumerState<NuevoCobroScreen> {
  static const List<String> _metodosPago = [
    'Transferencia',
    'Efectivo',
    'Tarjeta',
    'Domiciliacion',
    'Otro',
  ];

  final _formKey = GlobalKey<FormState>();
  final _fechaController = TextEditingController();
  final _importeController = TextEditingController();
  final _referenciaController = TextEditingController();
  final _observacionesController = TextEditingController();

  DateTime _fechaSeleccionada = DateTime.now();
  String _metodoPagoSeleccionado = _metodosPago.first;

  @override
  void initState() {
    super.initState();
    _fechaController.text = DateFormatter.formatDdMmYyyy(_fechaSeleccionada);
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

  @override
  Widget build(BuildContext context) {
    return AppShortcutScope(
      onBack: () {
        Navigator.maybePop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nuevo cobro'),
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
                TextFormField(
                  controller: _importeController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Importe',
                  ),
                  validator: (value) {
                    final raw = value?.trim() ?? '';
                    if (raw.isEmpty) {
                      return 'El importe es obligatorio';
                    }

                    final parsed = double.tryParse(raw.replaceAll(',', '.'));
                    if (parsed == null) {
                      return 'Introduce un importe decimal valido';
                    }

                    if (parsed <= 0) {
                      return 'El importe debe ser mayor que 0';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  initialValue: _metodoPagoSeleccionado,
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
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _metodoPagoSeleccionado = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _referenciaController,
                  decoration: const InputDecoration(
                    labelText: 'Referencia',
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
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () async {
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
                        await repository.crearCobro(
                          facturaId: widget.facturaId,
                          fecha: fecha,
                          importe: importe,
                          metodoPago: _metodoPagoSeleccionado,
                          referencia: _referenciaController.text.trim(),
                          observaciones: _observacionesController.text.trim(),
                        );
                      } on CobroSuperaPendienteException {
                        if (!context.mounted) {
                          return;
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'El importe supera el pendiente de la factura.',
                            ),
                          ),
                        );
                        return;
                      }

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
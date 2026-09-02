import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/shortcuts/app_shortcuts.dart';
import '../../../clientes/domain/cliente.dart';
import '../../../clientes/presentation/providers/cliente_providers.dart';
import '../../data/factura_repository.dart';
import '../../domain/estado_factura.dart';

class NuevaFacturaScreen extends ConsumerStatefulWidget {
  const NuevaFacturaScreen({super.key});

  @override
  ConsumerState<NuevaFacturaScreen> createState() => _NuevaFacturaScreenState();
}

class _NuevaFacturaScreenState extends ConsumerState<NuevaFacturaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fechaController = TextEditingController();
  final _fechaVencimientoController = TextEditingController();
  final _observacionesController = TextEditingController();

  DateTime _fechaSeleccionada = DateTime.now();
  DateTime _fechaVencimientoSeleccionada = DateTime.now().add(
    const Duration(days: 30),
  );
  String? _clienteSeleccionadoId;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _fechaController.text = _formatearFecha(_fechaSeleccionada);
    _fechaVencimientoController.text = _formatearFecha(
      _fechaVencimientoSeleccionada,
    );
  }

  @override
  void dispose() {
    _fechaController.dispose();
    _fechaVencimientoController.dispose();
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

  Future<void> _seleccionarFechaVencimiento() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fechaVencimientoSeleccionada,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked == null) {
      return;
    }

    setState(() {
      _fechaVencimientoSeleccionada = picked;
      _fechaVencimientoController.text = _formatearFecha(
        _fechaVencimientoSeleccionada,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final clienteRepository = ref.watch(clienteRepositoryProvider);

    return AppShortcutScope(
      onBack: () {
        Navigator.maybePop(context);
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Nueva factura')),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                StreamBuilder<List<Cliente>>(
                  stream: clienteRepository.observarClientes(),
                  builder: (context, snapshot) {
                    final clientes = snapshot.data ?? const [];

                    return DropdownButtonFormField<String>(
                      initialValue: _clienteSeleccionadoId,
                      decoration: const InputDecoration(labelText: 'Cliente'),
                      items: clientes
                          .map(
                            (cliente) => DropdownMenuItem<String>(
                              value: cliente.id,
                              child: Text(
                                '${cliente.nombre} ${cliente.apellidos}'.trim(),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _clienteSeleccionadoId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'El cliente es obligatorio';
                        }
                        return null;
                      },
                    );
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
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'La fecha es obligatoria'
                      : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  readOnly: true,
                  controller: _fechaVencimientoController,
                  decoration: const InputDecoration(
                    labelText: 'Fecha de vencimiento',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: _seleccionarFechaVencimiento,
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'La fecha de vencimiento es obligatoria'
                      : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  initialValue: estadoFacturaToLabel(EstadoFactura.borrador),
                  readOnly: true,
                  decoration: const InputDecoration(labelText: 'Estado'),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _observacionesController,
                  decoration: const InputDecoration(labelText: 'Observaciones'),
                  minLines: 3,
                  maxLines: 5,
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

                            final repository = ref.read(
                              facturaRepositoryProvider,
                            );
                            final fecha = DateTime(
                              _fechaSeleccionada.year,
                              _fechaSeleccionada.month,
                              _fechaSeleccionada.day,
                            );
                            final fechaVencimiento = DateTime(
                              _fechaVencimientoSeleccionada.year,
                              _fechaVencimientoSeleccionada.month,
                              _fechaVencimientoSeleccionada.day,
                            );

                            try {
                              await repository.crearFactura(
                                clienteId: _clienteSeleccionadoId!,
                                fecha: fecha,
                                fechaVencimiento: fechaVencimiento,
                                estado: EstadoFactura.borrador,
                                observaciones: _observacionesController.text
                                    .trim(),
                              );

                              if (context.mounted) {
                                Navigator.of(context).pop();
                              }
                            } finally {
                              if (mounted) {
                                setState(() => _guardando = false);
                              }
                            }
                          },
                    icon: _guardando
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save),
                    label: Text(_guardando ? 'Guardando...' : 'Guardar'),
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

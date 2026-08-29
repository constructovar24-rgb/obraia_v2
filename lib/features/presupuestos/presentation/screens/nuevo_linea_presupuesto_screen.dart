import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/app_spacing.dart';
import '../../../../core/ui/app_typography.dart';
import '../../../../core/widgets/app_section.dart';
import '../providers/presupuesto_providers.dart';

class NuevoLineaPresupuestoScreen extends ConsumerStatefulWidget {
  const NuevoLineaPresupuestoScreen({super.key, required this.presupuestoId});

  final String presupuestoId;

  @override
  ConsumerState<NuevoLineaPresupuestoScreen> createState() =>
      _NuevoLineaPresupuestoScreenState();
}

class _NuevoLineaPresupuestoScreenState
    extends ConsumerState<NuevoLineaPresupuestoScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = AppTypography.textTheme(colorScheme);

    return Scaffold(
      appBar: AppBar(title: const Text('Nueva línea')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text(
            'Registra un nuevo concepto para este presupuesto.',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          AppSection(
            title: 'Datos de la línea',
            subtitle: 'Completa concepto, cantidad y precio unitario.',
            child: LineaPresupuestoForm(
              onSubmit: (concepto, cantidad, unidad, precioUnitario) async {
                final repository = ref.read(lineaPresupuestoRepositoryProvider);

                await repository.crearLinea(
                  presupuestoId: widget.presupuestoId,
                  concepto: concepto,
                  cantidad: cantidad,
                  unidad: unidad,
                  precioUnitario: precioUnitario,
                );

                if (!context.mounted) return;
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class LineaPresupuestoForm extends StatefulWidget {
  const LineaPresupuestoForm({
    super.key,
    required this.onSubmit,
    this.initialConcepto = '',
    this.initialCantidad,
    this.initialUnidad = 'ud',
    this.initialPrecioUnitario,
    this.submitLabel = 'Guardar',
    this.footer,
  });

  final Future<void> Function(
    String concepto,
    double cantidad,
    String unidad,
    double precioUnitario,
  )
  onSubmit;
  final String initialConcepto;
  final double? initialCantidad;
  final String initialUnidad;
  final double? initialPrecioUnitario;
  final String submitLabel;
  final Widget? footer;

  @override
  State<LineaPresupuestoForm> createState() => _LineaPresupuestoFormState();
}

class _LineaPresupuestoFormState extends State<LineaPresupuestoForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _conceptoController;
  late final TextEditingController _cantidadController;
  late final TextEditingController _precioUnitarioController;
  late final TextEditingController _unidadController;

  @override
  void initState() {
    super.initState();
    _conceptoController = TextEditingController(text: widget.initialConcepto);
    _cantidadController = TextEditingController(
      text: widget.initialCantidad != null
          ? _formatDecimal(widget.initialCantidad!)
          : '',
    );
    _precioUnitarioController = TextEditingController(
      text: widget.initialPrecioUnitario != null
          ? _formatDecimal(widget.initialPrecioUnitario!)
          : '',
    );
    _unidadController = TextEditingController(text: widget.initialUnidad);
  }

  @override
  void dispose() {
    _conceptoController.dispose();
    _cantidadController.dispose();
    _precioUnitarioController.dispose();
    _unidadController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _conceptoController,
              decoration: const InputDecoration(labelText: 'Concepto'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El concepto es obligatorio';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _unidadController,
              decoration: const InputDecoration(labelText: 'Unidad'),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'La unidad es obligatoria'
                  : null,
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
                  return 'Introduce una cantidad válida';
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
                  return 'Introduce un precio unitario válido';
                }

                return null;
              },
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }

                  await widget.onSubmit(
                    _conceptoController.text.trim(),
                    _parseDecimal(_cantidadController.text.trim()),
                    _unidadController.text.trim(),
                    _parseDecimal(_precioUnitarioController.text.trim()),
                  );
                },
                icon: const Icon(Icons.save),
                label: Text(widget.submitLabel),
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

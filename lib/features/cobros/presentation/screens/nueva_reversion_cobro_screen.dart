import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/formatters/date_formatter.dart';
import '../../../../core/ui/app_spacing.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/money_text.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../data/cobro_repository.dart';
import '../../domain/cobro.dart';

class NuevaReversionCobroScreen extends ConsumerStatefulWidget {
  const NuevaReversionCobroScreen({super.key, required this.cobro});

  final Cobro cobro;

  @override
  ConsumerState<NuevaReversionCobroScreen> createState() =>
      _NuevaReversionCobroScreenState();
}

class _NuevaReversionCobroScreenState
    extends ConsumerState<NuevaReversionCobroScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _importeController;
  final _motivoController = TextEditingController();
  DateTime _fecha = DateTime.now();
  bool _guardando = false;
  double? _disponible;

  @override
  void initState() {
    super.initState();
    _importeController = TextEditingController(
      text: widget.cobro.importe.toStringAsFixed(2),
    );
    _cargarDisponible();
  }

  Future<void> _cargarDisponible() async {
    final disponible = await ref
        .read(cobroRepositoryProvider)
        .obtenerImporteDisponibleParaReversion(widget.cobro.id);
    if (!mounted) return;
    setState(() {
      _disponible = disponible;
      _importeController.text = disponible.toStringAsFixed(2);
    });
  }

  @override
  void dispose() {
    _importeController.dispose();
    _motivoController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (_guardando || !_formKey.currentState!.validate()) return;
    setState(() => _guardando = true);
    final importe = double.parse(
      _importeController.text.trim().replaceAll(',', '.'),
    );
    try {
      await ref
          .read(cobroRepositoryProvider)
          .revertirCobro(
            cobroId: widget.cobro.id,
            fecha: DateTime(_fecha.year, _fecha.month, _fecha.day),
            importe: importe,
            motivo: _motivoController.text.trim(),
          );
      if (mounted) Navigator.of(context).pop();
    } on FechaMovimientoCobroNoValidaException {
      _mostrarError('La fecha no puede ser futura ni anterior al cobro.');
    } on CobroNoReversibleException {
      _mostrarError(
        'La reversión supera el importe disponible o no es válida.',
      );
    } on ImporteCobroNoValidoException {
      _mostrarError('El importe debe ser mayor que 0.');
    } on FacturaNoCobrableException {
      _mostrarError('El estado de la factura no permite la reversión.');
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  void _mostrarError(String mensaje) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Revertir cobro')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Wrap(
                  spacing: AppSpacing.xl,
                  runSpacing: AppSpacing.sm,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const StatusChip(
                      label: 'Cobro confirmado',
                      type: StatusType.success,
                      icon: Icons.lock_outline,
                    ),
                    Text(DateFormatter.formatDdMmYyyy(widget.cobro.fecha)),
                    Text(widget.cobro.metodoPago),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Importe original'),
                        MoneyText(widget.cobro.importe),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Disponible para revertir'),
                        _disponible == null
                            ? const SizedBox.square(
                                dimension: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : MoneyText(_disponible!),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              controller: _importeController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Importe a revertir',
                helperText:
                    'La reversión crea un movimiento nuevo; no modifica el cobro original.',
              ),
              validator: (value) {
                final importe = double.tryParse(
                  (value ?? '').trim().replaceAll(',', '.'),
                );
                return importe == null || !importe.isFinite || importe <= 0
                    ? 'Introduce un importe válido mayor que 0'
                    : null;
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Fecha'),
              subtitle: Text(
                '${_fecha.day.toString().padLeft(2, '0')}/'
                '${_fecha.month.toString().padLeft(2, '0')}/${_fecha.year}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final elegida = await showDatePicker(
                  context: context,
                  initialDate: _fecha,
                  firstDate: widget.cobro.fecha,
                  lastDate: DateTime.now(),
                );
                if (elegida != null) setState(() => _fecha = elegida);
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              controller: _motivoController,
              minLines: 3,
              maxLines: 5,
              decoration: const InputDecoration(labelText: 'Motivo'),
              validator: (value) => (value?.trim().length ?? 0) < 3
                  ? 'Describe el motivo de la reversión'
                  : null,
            ),
            const SizedBox(height: AppSpacing.xl),
            AppPrimaryButton(
              onPressed: _guardar,
              icon: Icons.undo,
              label: _guardando ? 'Registrando...' : 'Registrar reversión',
              loading: _guardando,
            ),
          ],
        ),
      ),
    );
  }
}

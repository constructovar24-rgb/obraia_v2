import 'package:flutter/material.dart';

import '../../../../core/ui/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/money_text.dart';
import '../../../expedientes/domain/expediente.dart';
import '../../../proveedores/domain/proveedor.dart';
import '../../domain/compra.dart';

class CompraFormData {
  const CompraFormData({
    required this.expedienteId,
    required this.proveedorId,
    required this.proveedorNombre,
    required this.fecha,
    required this.numeroFactura,
    required this.concepto,
    required this.baseImponible,
    required this.ivaPorcentaje,
    required this.importeTotal,
    required this.estado,
    required this.observaciones,
  });
  final String expedienteId;
  final String proveedorId;
  final String proveedorNombre;
  final DateTime fecha;
  final String? numeroFactura;
  final String concepto;
  final double baseImponible;
  final double ivaPorcentaje;
  final double importeTotal;
  final CompraEstado estado;
  final String? observaciones;
}

class CompraForm extends StatefulWidget {
  const CompraForm({
    super.key,
    this.compra,
    this.expedienteId,
    required this.expedientes,
    required this.proveedores,
    required this.onSubmit,
    required this.onCancel,
  });
  final Compra? compra;
  final String? expedienteId;
  final List<Expediente> expedientes;
  final List<Proveedor> proveedores;
  final Future<void> Function(CompraFormData) onSubmit;
  final VoidCallback onCancel;
  @override
  State<CompraForm> createState() => _CompraFormState();
}

class _CompraFormState extends State<CompraForm> {
  final _key = GlobalKey<FormState>();
  late final TextEditingController _concepto;
  late final TextEditingController _numero;
  late final TextEditingController _base;
  late final TextEditingController _iva;
  late final TextEditingController _observaciones;
  late DateTime _fecha;
  late CompraEstado _estado;
  String? _expedienteId;
  String? _proveedorId;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final c = widget.compra;
    _concepto = TextEditingController(text: c?.concepto ?? '');
    _numero = TextEditingController(text: c?.numeroFactura ?? '');
    _base = TextEditingController(
      text: c == null ? '' : _decimal(c.baseImponible),
    );
    _iva = TextEditingController(
      text: c == null ? '21' : _decimal(c.ivaPorcentaje),
    );
    _observaciones = TextEditingController(text: c?.observaciones ?? '');
    _fecha = c?.fecha ?? DateTime.now();
    _estado = c?.estado ?? CompraEstado.pendiente;
    _expedienteId = c?.expedienteId ?? widget.expedienteId;
    _proveedorId = c?.proveedorId;
  }

  String _decimal(double value) => value == value.truncateToDouble()
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(2).replaceAll('.', ',');
  double? _parse(String value) =>
      double.tryParse(value.trim().replaceAll(',', '.'));
  double get _total {
    final base = _parse(_base.text) ?? 0;
    final iva = _parse(_iva.text) ?? 0;
    return base + base * iva / 100;
  }

  String _date(DateTime value) =>
      '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';

  @override
  void dispose() {
    for (final c in [_concepto, _numero, _base, _iva, _observaciones]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDate() async {
    final value = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (value != null) setState(() => _fecha = value);
  }

  Future<void> _submit() async {
    if (_saving || !_key.currentState!.validate()) return;
    final proveedor = widget.proveedores
        .where((p) => p.id == _proveedorId)
        .firstOrNull;
    if (proveedor == null || _expedienteId == null) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final base = _parse(_base.text) ?? 0;
      final iva = _parse(_iva.text) ?? 0;
      await widget.onSubmit(
        CompraFormData(
          expedienteId: _expedienteId!,
          proveedorId: proveedor.id,
          proveedorNombre: proveedor.nombre,
          fecha: DateTime(_fecha.year, _fecha.month, _fecha.day),
          numeroFactura: _numero.text.trim().isEmpty
              ? null
              : _numero.text.trim(),
          concepto: _concepto.text.trim(),
          baseImponible: base,
          ivaPorcentaje: iva,
          importeTotal: base + base * iva / 100,
          estado: _estado,
          observaciones: _observaciones.text.trim().isEmpty
              ? null
              : _observaciones.text.trim(),
        ),
      );
    } catch (error) {
      if (mounted) {
        setState(() => _error = 'No se pudo guardar la compra: $error');
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => Form(
    key: _key,
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1060),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppCard(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final fields = [
                      DropdownButtonFormField<String>(
                        key: const Key('compra-expediente'),
                        initialValue: _expedienteId,
                        decoration: const InputDecoration(
                          labelText: 'Expediente / obra *',
                        ),
                        items: widget.expedientes
                            .map(
                              (e) => DropdownMenuItem(
                                value: e.id,
                                child: Text(
                                  '${e.codigo} · ${e.nombre}',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: widget.compra == null
                            ? (v) => setState(() => _expedienteId = v)
                            : null,
                        validator: (v) =>
                            v == null ? 'Selecciona un expediente' : null,
                      ),
                      DropdownButtonFormField<String>(
                        key: const Key('compra-proveedor'),
                        initialValue:
                            widget.proveedores.any((p) => p.id == _proveedorId)
                            ? _proveedorId
                            : null,
                        decoration: InputDecoration(
                          labelText: 'Proveedor *',
                          helperText:
                              _proveedorId != null &&
                                  !widget.proveedores.any(
                                    (p) => p.id == _proveedorId,
                                  )
                              ? 'Proveedor histórico no disponible: ${widget.compra?.proveedorNombre}'
                              : null,
                        ),
                        items: widget.proveedores
                            .map(
                              (p) => DropdownMenuItem(
                                value: p.id,
                                child: Text(p.nombre),
                              ),
                            )
                            .toList(),
                        onChanged: (v) => setState(() => _proveedorId = v),
                        validator: (v) =>
                            v == null ? 'Selecciona un proveedor' : null,
                      ),
                      InkWell(
                        onTap: _pickDate,
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Fecha *',
                            suffixIcon: Icon(Icons.calendar_today_outlined),
                          ),
                          child: Text(_date(_fecha)),
                        ),
                      ),
                      DropdownButtonFormField<CompraEstado>(
                        initialValue: _estado,
                        decoration: const InputDecoration(
                          labelText: 'Estado registrado',
                        ),
                        items: CompraEstado.values
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.name),
                              ),
                            )
                            .toList(),
                        onChanged: (v) => setState(() => _estado = v!),
                      ),
                    ];
                    return _Grid(
                      wide: constraints.maxWidth >= 760,
                      children: fields,
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Concepto e importes',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextFormField(
                      key: const Key('compra-concepto'),
                      controller: _concepto,
                      decoration: const InputDecoration(
                        labelText: 'Concepto *',
                      ),
                      minLines: 2,
                      maxLines: 3,
                      validator: (v) => v == null || v.trim().isEmpty
                          ? 'El concepto es obligatorio'
                          : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    LayoutBuilder(
                      builder: (context, constraints) => _Grid(
                        wide: constraints.maxWidth >= 760,
                        children: [
                          TextFormField(
                            controller: _numero,
                            decoration: const InputDecoration(
                              labelText: 'Número de factura (si consta)',
                            ),
                          ),
                          TextFormField(
                            key: const Key('compra-base'),
                            controller: _base,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Base imponible (€)',
                            ),
                            onChanged: (_) => setState(() {}),
                            validator: (v) {
                              final n = _parse(v ?? '');
                              return n == null || n < 0
                                  ? 'Introduce una base válida'
                                  : null;
                            },
                          ),
                          TextFormField(
                            controller: _iva,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'IVA (%)',
                            ),
                            onChanged: (_) => setState(() {}),
                            validator: (v) {
                              final n = _parse(v ?? '');
                              return n == null || n < 0 || n > 100
                                  ? 'Introduce un IVA entre 0 y 100'
                                  : null;
                            },
                          ),
                          InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Importe total calculado',
                            ),
                            child: MoneyText(_total),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _observaciones,
                      decoration: const InputDecoration(
                        labelText: 'Observaciones',
                      ),
                      minLines: 3,
                      maxLines: 5,
                    ),
                  ],
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _saving ? null : widget.onCancel,
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  AppPrimaryButton(
                    key: const Key('compra-submit'),
                    label: _saving ? 'Guardando…' : 'Guardar compra',
                    icon: Icons.save_outlined,
                    onPressed: _submit,
                    loading: _saving,
                    expand: false,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _Grid extends StatelessWidget {
  const _Grid({required this.wide, required this.children});
  final bool wide;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => wide
      ? Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: children
              .map((c) => SizedBox(width: 470, child: c))
              .toList(),
        )
      : Column(
          children: [
            for (var i = 0; i < children.length; i++) ...[
              children[i],
              if (i < children.length - 1)
                const SizedBox(height: AppSpacing.md),
            ],
          ],
        );
}

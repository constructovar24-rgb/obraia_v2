import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/factura_linea_repository.dart';
import '../../data/factura_repository.dart';
import '../../domain/factura.dart';
import '../../domain/factura_linea.dart';
import '../../domain/rectificativa.dart';
import '../providers/rectificativa_providers.dart';
import 'editar_factura_screen.dart';

class NuevaRectificativaScreen extends ConsumerStatefulWidget {
  const NuevaRectificativaScreen({super.key, required this.factura});
  final Factura factura;

  @override
  ConsumerState<NuevaRectificativaScreen> createState() =>
      _NuevaRectificativaScreenState();
}

class _NuevaRectificativaScreenState
    extends ConsumerState<NuevaRectificativaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _motivo = TextEditingController();
  final _iva = TextEditingController();
  final _bases = <String, TextEditingController>{};
  final _cantidades = <String, TextEditingController>{};
  bool _formal = false;
  bool _guardando = false;

  @override
  void dispose() {
    _motivo.dispose();
    _iva.dispose();
    for (final controller in [..._bases.values, ..._cantidades.values]) {
      controller.dispose();
    }
    super.dispose();
  }

  double? _parse(String value) {
    final text = value.trim().replaceAll(',', '.');
    return text.isEmpty ? null : double.tryParse(text);
  }

  Future<void> _crear(List<FacturaLinea> lineas) async {
    if (!_formKey.currentState!.validate() || _guardando) return;
    final ajustes = <AjusteRectificativa>[];
    for (final linea in lineas) {
      final base = _parse(_bases[linea.id]?.text ?? '');
      if (base == null) continue;
      ajustes.add(
        AjusteRectificativa(
          lineaRectificadaId: linea.id,
          baseDiferencia: base,
          cantidadDiferencia: _parse(_cantidades[linea.id]?.text ?? ''),
        ),
      );
    }
    setState(() => _guardando = true);
    try {
      final id = await ref
          .read(rectificativaRepositoryProvider)
          .crear(
            facturaRectificadaId: widget.factura.id,
            motivo: _motivo.text,
            ajustes: ajustes,
            ivaDiferencia: _parse(_iva.text),
            rectificacionFormal: _formal,
          );
      final factura = await ref
          .read(facturaRepositoryProvider)
          .obtenerPorId(id);
      if (!mounted || factura == null) return;
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => EditarFacturaScreen(factura: factura),
        ),
      );
    } on RectificativaException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.mensaje)));
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lineasRepository = ref.read(facturaLineaRepositoryProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva factura rectificativa')),
      body: StreamBuilder<List<FacturaLinea>>(
        stream: lineasRepository.observarPorFactura(widget.factura.id),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final lineas = snapshot.data!;
          for (final linea in lineas) {
            _bases.putIfAbsent(linea.id, TextEditingController.new);
            _cantidades.putIfAbsent(linea.id, TextEditingController.new);
          }
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text('Rectifica ${widget.factura.codigo}'),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _motivo,
                  decoration: const InputDecoration(labelText: 'Motivo *'),
                  validator: (value) => (value?.trim().length ?? 0) < 3
                      ? 'Indica el motivo de la rectificación.'
                      : null,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Introduce diferencias con signo. Un importe negativo reduce la facturación.',
                ),
                ...lineas.map(
                  (linea) => Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(linea.descripcion),
                          Text(
                            'Base original: ${linea.importe.toStringAsFixed(2)} €',
                          ),
                          TextFormField(
                            controller: _bases[linea.id],
                            decoration: const InputDecoration(
                              labelText: 'Diferencia de base',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                              signed: true,
                            ),
                          ),
                          TextFormField(
                            controller: _cantidades[linea.id],
                            decoration: const InputDecoration(
                              labelText: 'Diferencia de cantidad (opcional)',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                              signed: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                TextFormField(
                  controller: _iva,
                  decoration: const InputDecoration(
                    labelText: 'Diferencia de IVA (opcional)',
                    helperText:
                        'Vacío: se calcula con el IVA de la factura raíz.',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                ),
                CheckboxListTile(
                  value: _formal,
                  onChanged: (value) =>
                      setState(() => _formal = value ?? false),
                  title: const Text(
                    'Rectificación formal sin efecto económico',
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _guardando ? null : () => _crear(lineas),
                  icon: const Icon(Icons.receipt_long_outlined),
                  label: Text(
                    _guardando ? 'Creando...' : 'Crear borrador RECT',
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

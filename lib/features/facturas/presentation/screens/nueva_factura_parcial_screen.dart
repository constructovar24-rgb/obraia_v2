import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../presupuestos/domain/linea_presupuesto.dart';
import '../../../presupuestos/domain/presupuesto.dart';
import '../../../presupuestos/presentation/providers/presupuesto_providers.dart';
import '../../domain/facturacion_parcial.dart';
import '../providers/facturacion_parcial_providers.dart';
import 'editar_factura_screen.dart';

class NuevaFacturaParcialScreen extends ConsumerStatefulWidget {
  const NuevaFacturaParcialScreen({super.key, required this.presupuesto});
  final Presupuesto presupuesto;

  @override
  ConsumerState<NuevaFacturaParcialScreen> createState() =>
      _NuevaFacturaParcialScreenState();
}

class _NuevaFacturaParcialScreenState
    extends ConsumerState<NuevaFacturaParcialScreen> {
  ModalidadFacturacionParcial _modalidad =
      ModalidadFacturacionParcial.porcentaje;
  final _valorController = TextEditingController();
  final _seleccionadas = <String, _EntradaPartida>{};
  bool _guardando = false;

  @override
  void dispose() {
    _valorController.dispose();
    for (final entrada in _seleccionadas.values) {
      entrada.controller.dispose();
    }
    super.dispose();
  }

  double? _numero(String value) =>
      double.tryParse(value.trim().replaceAll(',', '.'));

  Future<void> _crear() async {
    if (_guardando) return;
    setState(() => _guardando = true);
    try {
      final repository = ref.read(facturacionParcialRepositoryProvider);
      late final String facturaId;
      if (_modalidad == ModalidadFacturacionParcial.porcentaje) {
        facturaId = await repository.crearPorPorcentaje(
          presupuestoId: widget.presupuesto.id,
          porcentaje: _numero(_valorController.text) ?? 0,
        );
      } else if (_modalidad == ModalidadFacturacionParcial.importe) {
        facturaId = await repository.crearPorImporte(
          presupuestoId: widget.presupuesto.id,
          importe: _numero(_valorController.text) ?? 0,
        );
      } else {
        facturaId = await repository.crearPorPartidas(
          presupuestoId: widget.presupuesto.id,
          selecciones: _seleccionadas.entries.map((entry) {
            final valor = _numero(entry.value.controller.text);
            return SeleccionPartidaFactura(
              lineaPresupuestoId: entry.key,
              cantidad: entry.value.porCantidad ? valor : null,
              importe: entry.value.porCantidad ? null : valor,
            );
          }).toList(),
        );
      }
      final factura = await repository.obtenerFactura(facturaId);
      if (!mounted) return;
      if (factura == null) throw StateError('No se pudo abrir la factura.');
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => EditarFacturaScreen(factura: factura),
        ),
      );
    } on FacturacionParcialException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.mensaje)));
      }
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lineasRepository = ref.watch(lineaPresupuestoRepositoryProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva factura parcial')),
      body: StreamBuilder<List<LineaPresupuesto>>(
        stream: lineasRepository.observarPorPresupuesto(widget.presupuesto.id),
        builder: (context, snapshot) {
          final lineas = snapshot.data ?? const <LineaPresupuesto>[];
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              SegmentedButton<ModalidadFacturacionParcial>(
                segments: const [
                  ButtonSegment(
                    value: ModalidadFacturacionParcial.porcentaje,
                    label: Text('Porcentaje'),
                  ),
                  ButtonSegment(
                    value: ModalidadFacturacionParcial.importe,
                    label: Text('Importe'),
                  ),
                  ButtonSegment(
                    value: ModalidadFacturacionParcial.partidas,
                    label: Text('Partidas'),
                  ),
                ],
                selected: {_modalidad},
                onSelectionChanged: (value) =>
                    setState(() => _modalidad = value.single),
              ),
              const SizedBox(height: 20),
              if (_modalidad != ModalidadFacturacionParcial.partidas)
                TextField(
                  controller: _valorController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText:
                        _modalidad == ModalidadFacturacionParcial.porcentaje
                        ? 'Porcentaje de la base presupuestada'
                        : 'Base imponible a facturar',
                    suffixText:
                        _modalidad == ModalidadFacturacionParcial.porcentaje
                        ? '%'
                        : '€',
                  ),
                )
              else
                ...lineas.map((linea) => _partida(linea)),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _guardando ? null : _crear,
                icon: const Icon(Icons.receipt_long_outlined),
                label: Text(
                  _guardando ? 'Creando...' : 'Crear borrador parcial',
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _partida(LineaPresupuesto linea) {
    final entrada = _seleccionadas[linea.id];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            CheckboxListTile(
              value: entrada != null,
              title: Text(linea.concepto),
              subtitle: Text(
                '${linea.cantidad} ${linea.unidad} · ${linea.importe.toStringAsFixed(2)} €',
              ),
              onChanged: (selected) => setState(() {
                if (selected == true) {
                  _seleccionadas[linea.id] = _EntradaPartida();
                } else {
                  _seleccionadas.remove(linea.id)?.controller.dispose();
                }
              }),
            ),
            if (entrada != null) ...[
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<bool>(
                      initialValue: entrada.porCantidad,
                      items: const [
                        DropdownMenuItem(value: true, child: Text('Cantidad')),
                        DropdownMenuItem(value: false, child: Text('Importe')),
                      ],
                      onChanged: (value) => setState(() {
                        entrada.porCantidad = value ?? true;
                        entrada.controller.clear();
                      }),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: entrada.controller,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: entrada.porCantidad ? 'Cantidad' : 'Base',
                        suffixText: entrada.porCantidad ? linea.unidad : '€',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }
}

class _EntradaPartida {
  final controller = TextEditingController();
  bool porCantidad = true;
}

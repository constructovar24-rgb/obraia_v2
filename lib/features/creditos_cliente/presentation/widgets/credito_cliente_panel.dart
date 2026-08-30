import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../cobros/domain/metodos_pago.dart';
import '../../domain/credito_cliente.dart';
import '../providers/credito_cliente_providers.dart';

class CreditoClientePanel extends ConsumerWidget {
  const CreditoClientePanel({super.key, required this.facturaId});
  final String facturaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(creditoFamiliaProvider(facturaId))
        .when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Text('No se pudo obtener el resumen: $error'),
          data: (resumen) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Resumen económico familiar',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
              ),
              const SizedBox(height: 8),
              _fila('Neto documental', resumen.netoDocumental),
              _fila('Cobrado', resumen.cobrosNetos),
              _fila('Compensado recibido', resumen.compensacionesRecibidas),
              _fila('Total liquidado', resumen.totalLiquidado),
              _fila('Pendiente', resumen.pendiente),
              _fila('Crédito generado', resumen.creditoGenerado),
              _fila('Devuelto', resumen.devolucionesNetas),
              _fila(
                'Compensado a otras facturas',
                resumen.compensacionesEmitidas,
              ),
              _fila('Crédito disponible', resumen.creditoDisponible),
              Text('Estado: ${_estado(resumen.estado)}'),
              if (resumen.creditoDisponible > 0) ...[
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () => _devolver(context, ref, resumen),
                  icon: const Icon(Icons.currency_exchange),
                  label: const Text('Registrar devolución'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () => _compensar(context, ref, resumen),
                  icon: const Icon(Icons.compare_arrows),
                  label: const Text('Compensar con otra factura'),
                ),
              ],
              const SizedBox(height: 12),
              _HistorialCredito(raizId: resumen.facturaRaizId),
            ],
          ),
        );
  }

  static Widget _fila(String label, double value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(label), Text('${value.toStringAsFixed(2)} €')],
    ),
  );

  static String _estado(EstadoEconomicoFamilia value) => switch (value) {
    EstadoEconomicoFamilia.pendiente => 'Pendiente',
    EstadoEconomicoFamilia.parcialmenteLiquidada => 'Parcialmente liquidada',
    EstadoEconomicoFamilia.liquidada => 'Liquidada',
    EstadoEconomicoFamilia.saldoFavorPendiente => 'Saldo a favor pendiente',
    EstadoEconomicoFamilia.saldoFavorParcialmenteDispuesto =>
      'Saldo a favor parcialmente dispuesto',
    EstadoEconomicoFamilia.saldoFavorLiquidado => 'Saldo a favor liquidado',
  };

  Future<void> _devolver(
    BuildContext context,
    WidgetRef ref,
    CreditoClienteFamilia resumen,
  ) async {
    final importe = TextEditingController();
    final referencia = TextEditingController();
    final motivo = TextEditingController();
    final observaciones = TextEditingController();
    var metodo = metodosPagoCobro.first;
    var fecha = DateTime.now();
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Registrar devolución'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Disponible: ${resumen.creditoDisponible.toStringAsFixed(2)} €',
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Fecha'),
                  subtitle: Text(
                    '${fecha.day.toString().padLeft(2, '0')}/'
                    '${fecha.month.toString().padLeft(2, '0')}/${fecha.year}',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final seleccionada = await showDatePicker(
                      context: context,
                      initialDate: fecha,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (seleccionada != null) {
                      setState(() => fecha = seleccionada);
                    }
                  },
                ),
                TextField(
                  controller: importe,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(labelText: 'Importe'),
                ),
                DropdownButtonFormField<String>(
                  initialValue: metodo,
                  items: metodosPagoCobro
                      .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                      .toList(),
                  onChanged: (v) => setState(() => metodo = v!),
                  decoration: const InputDecoration(labelText: 'Método'),
                ),
                TextField(
                  controller: referencia,
                  decoration: const InputDecoration(labelText: 'Referencia'),
                ),
                TextField(
                  controller: motivo,
                  decoration: const InputDecoration(labelText: 'Motivo'),
                ),
                TextField(
                  controller: observaciones,
                  decoration: const InputDecoration(labelText: 'Observaciones'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Confirmar'),
            ),
          ],
        ),
      ),
    );
    if (confirmar != true || !context.mounted) return;
    await _ejecutar(
      context,
      () => ref
          .read(creditoClienteRepositoryProvider)
          .registrarDevolucion(
            facturaRaizId: resumen.facturaRaizId,
            importe: double.tryParse(importe.text.replaceAll(',', '.')) ?? 0,
            fecha: fecha,
            metodo: metodo,
            referencia: referencia.text,
            motivo: motivo.text,
            observaciones: observaciones.text,
          ),
    );
  }

  Future<void> _compensar(
    BuildContext context,
    WidgetRef ref,
    CreditoClienteFamilia resumen,
  ) async {
    final repository = ref.read(creditoClienteRepositoryProvider);
    final destinos = await repository.obtenerFacturasDestinoElegibles(
      resumen.facturaRaizId,
    );
    if (!context.mounted) return;
    if (destinos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay facturas pendientes del mismo cliente fiscal.'),
        ),
      );
      return;
    }
    String destinoId = destinos.first.facturaRaizId;
    final importe = TextEditingController();
    final motivo = TextEditingController();
    final observaciones = TextEditingController();
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) {
          final destino = destinos.firstWhere(
            (d) => d.facturaRaizId == destinoId,
          );
          return AlertDialog(
            title: const Text('Compensar crédito'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: destinoId,
                    items: destinos
                        .map(
                          (d) => DropdownMenuItem(
                            value: d.facturaRaizId,
                            child: Text(
                              '${d.codigo} · ${d.pendiente.toStringAsFixed(2)} €',
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => destinoId = v!),
                  ),
                  Text(
                    'Pendiente destino: ${destino.pendiente.toStringAsFixed(2)} €',
                  ),
                  TextField(
                    controller: importe,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(labelText: 'Importe'),
                  ),
                  TextField(
                    controller: motivo,
                    decoration: const InputDecoration(labelText: 'Motivo'),
                  ),
                  TextField(
                    controller: observaciones,
                    decoration: const InputDecoration(
                      labelText: 'Observaciones',
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Confirmar compensación'),
              ),
            ],
          );
        },
      ),
    );
    if (confirmar != true || !context.mounted) return;
    await _ejecutar(
      context,
      () => repository.compensar(
        facturaRaizOrigenId: resumen.facturaRaizId,
        facturaRaizDestinoId: destinoId,
        importe: double.tryParse(importe.text.replaceAll(',', '.')) ?? 0,
        fecha: DateTime.now(),
        motivo: motivo.text,
        observaciones: observaciones.text,
      ),
    );
  }

  Future<void> _ejecutar(
    BuildContext context,
    Future<void> Function() action,
  ) async {
    try {
      await action();
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Movimiento registrado.')));
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$error')));
      }
    }
  }
}

class _HistorialCredito extends ConsumerWidget {
  const _HistorialCredito({required this.raizId});
  final String raizId;
  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
      .watch(movimientosCreditoProvider(raizId))
      .when(
        loading: () => const SizedBox.shrink(),
        error: (e, _) => Text('No se pudo cargar el historial: $e'),
        data: (items) => items.isEmpty
            ? const Text('Sin movimientos de crédito.')
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Movimientos de crédito',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  ...items.map(
                    (m) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        '${m.tipo.name} · ${m.importe.toStringAsFixed(2)} €',
                      ),
                      subtitle: Text(
                        '${m.fecha.day}/${m.fecha.month}/${m.fecha.year} · ${m.motivo}',
                      ),
                      trailing:
                          (m.tipo == TipoMovimientoCreditoCliente.devolucion ||
                              m.tipo ==
                                  TipoMovimientoCreditoCliente.compensacion)
                          ? IconButton(
                              icon: const Icon(Icons.undo),
                              tooltip: 'Revertir',
                              onPressed: () => _revertir(context, ref, m),
                            )
                          : null,
                    ),
                  ),
                ],
              ),
      );

  Future<void> _revertir(
    BuildContext context,
    WidgetRef ref,
    MovimientoCreditoCliente movimiento,
  ) async {
    final importe = TextEditingController(
      text: movimiento.importe.toStringAsFixed(2),
    );
    final motivo = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Revertir movimiento'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: importe,
              decoration: const InputDecoration(labelText: 'Importe'),
            ),
            TextField(
              controller: motivo,
              decoration: const InputDecoration(labelText: 'Motivo'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Revertir'),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    try {
      await ref
          .read(creditoClienteRepositoryProvider)
          .revertir(
            movimientoId: movimiento.id,
            importe: double.tryParse(importe.text.replaceAll(',', '.')) ?? 0,
            fecha: DateTime.now(),
            motivo: motivo.text,
          );
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$error')));
      }
    }
  }
}

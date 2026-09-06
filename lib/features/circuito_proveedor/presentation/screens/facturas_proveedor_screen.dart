import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../compras/presentation/providers/compra_providers.dart';
import '../../../proveedores/presentation/providers/proveedor_providers.dart';
import '../../data/circuito_proveedor_repository.dart';
import '../../domain/circuito_proveedor.dart';
import '../providers/circuito_proveedor_providers.dart';

class FacturasProveedorScreen extends ConsumerStatefulWidget {
  const FacturasProveedorScreen({super.key});
  @override
  ConsumerState<FacturasProveedorScreen> createState() =>
      _FacturasProveedorScreenState();
}

class _FacturasProveedorScreenState
    extends ConsumerState<FacturasProveedorScreen> {
  bool busy = false;
  String money(dynamic n) =>
      n == null ? 'No verificado' : '${(n / 100).toStringAsFixed(2)} €';
  Future<void> run(Future<void> Function() action) async {
    if (busy) return;
    setState(() => busy = true);
    try {
      await action();
      ref.invalidate(fichasProveedorProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$e')));
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<Map<String, String>?> fields(
    String title,
    Map<String, String> values,
  ) async {
    final controllers = values.map(
      (k, v) => MapEntry(k, TextEditingController(text: v)),
    );
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: 480,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: controllers.entries
                  .map(
                    (e) => TextField(
                      controller: e.value,
                      decoration: InputDecoration(labelText: e.key),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(
              ctx,
              controllers.map((k, v) => MapEntry(k, v.text.trim())),
            ),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
    // Controllers remain alive until the dialog's closing animation has completed.
    await Future<void>.delayed(const Duration(milliseconds: 250));
    for (final c in controllers.values) {
      c.dispose();
    }
    return result;
  }

  Future<void> motivo(
    Map<String, dynamic> f,
    String accion,
    Future<void> Function(String) fn,
  ) async {
    final result = await fields('$accion · ${f['numero']}', {'Motivo': ''});
    if (result != null) await run(() => fn(result['Motivo']!));
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(proveedoresProvider);
    ref.watch(expedientesCompraProvider);
    final data = ref.watch(fichasProveedorProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Facturas recibidas'),
        actions: [
          IconButton(
            onPressed: busy
                ? null
                : () => ref.invalidate(fichasProveedorProvider),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: busy ? null : () => form(),
        icon: const Icon(Icons.add),
        label: const Text('Nueva factura'),
      ),
      body: data.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (rows) => rows.isEmpty
            ? const Center(child: Text('No hay facturas recibidas.'))
            : ListView(
                padding: const EdgeInsets.only(bottom: 100),
                children: rows.map(card).toList(),
              ),
      ),
    );
  }

  Widget card(Map<String, dynamic> f) {
    final repo = ref.read(circuitoProveedorRepositoryProvider);
    final registrada = f['estado'] == 'registrada',
        borrador = f['estado'] == 'borrador';
    final asignaciones = f['asignaciones'] as List;
    final obras = ref.read(expedientesCompraProvider).value ?? [];
    String nombreObra(dynamic id) =>
        obras.where((o) => o.id == id).firstOrNull?.nombre ?? '$id';
    final destino = f['destino'] == 'general'
        ? 'Gasto general'
        : f['destino'] == 'sinAsignar'
        ? 'Sin obra asignada'
        : asignaciones
              .map(
                (a) => a['obra'] == null
                    ? 'Sin obra asignada'
                    : nombreObra(a['obra']),
              )
              .join(', ');
    return Card(
      color: f['estado'] == 'anulada'
          ? Theme.of(context).colorScheme.surfaceContainerHighest
          : null,
      child: ExpansionTile(
        title: Text(
          "${f['tipo'] == 'abono' ? 'ABONO · ' : ''}${f['numero']} · ${f['proveedor']}",
        ),
        subtitle: Text(
          "${f['fecha'].toString().split(' ').first} · ${f['estado']} · $destino\n${f['estadoPago']} · Total ${money(f['tipo'] == 'abono' ? -f['total'] : f['total'])}",
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Base ${money(f['base'])} · IVA ${money(f['iva'])}\nPagado registrado ${money(f['pagado'])} · Abonos ${money(f['abonos'])}\nSaldo ${money(f['pendiente'])}",
                ),
                if (f['originalId'] != null)
                  Text("Relacionado con documento ${f['originalId']}"),
                if (f['documentoId'] != null)
                  Text("Original conservado: ${f['documentoId']}"),
                if (!f['verificado'])
                  const Text(
                    'No se conoce el pago completo. Revisa los justificantes antes de verificar; los pagos registrados pueden ser incompletos.',
                  ),
                Wrap(
                  spacing: 8,
                  children: [
                    if (borrador)
                      TextButton(
                        onPressed: busy ? null : () => form(f: f),
                        child: const Text('Editar borrador'),
                      ),
                    if (borrador)
                      TextButton(
                        onPressed: busy
                            ? null
                            : () => motivo(f, 'Consolidar', (m) async {
                                if (m.isEmpty) {
                                  throw ArgumentError(
                                    'Confirma el motivo de registro.',
                                  );
                                }
                                await repo.consolidarFactura(
                                  f['id'],
                                  motivo: m,
                                );
                              }),
                        child: const Text('Consolidar'),
                      ),
                    if (registrada && f['tipo'] == 'factura')
                      TextButton(
                        onPressed: busy
                            ? null
                            : () => form(f: f, corregir: true),
                        child: const Text('Corregir con sustitución'),
                      ),
                    if (registrada && f['tipo'] == 'factura')
                      TextButton(
                        onPressed: busy ? null : () => form(original: f),
                        child: const Text('Registrar abono recibido'),
                      ),
                    if (f['estado'] != 'anulada')
                      TextButton(
                        onPressed: busy
                            ? null
                            : () => motivo(
                                f,
                                'Anular',
                                (m) => repo.anularFactura(f['id'], motivo: m),
                              ),
                        child: const Text('Anular con motivo'),
                      ),
                    if (f['estado'] != 'anulada' && !f['verificado'])
                      TextButton(
                        onPressed: busy
                            ? null
                            : () => motivo(
                                f,
                                'Verificar pagos tras revisar justificantes',
                                (m) => repo.verificarPago(f['id'], motivo: m),
                              ),
                        child: const Text('Verificar estado de pago'),
                      ),
                    if (registrada && f['verificado'] && f['tipo'] == 'factura')
                      TextButton(
                        onPressed: busy ? null : () => pagar(f),
                        child: const Text('Registrar pago'),
                      ),
                    if (f['estado'] != 'anulada')
                      TextButton(
                        onPressed: busy ? null : () => imputar(f),
                        child: const Text('Cambiar imputación'),
                      ),
                  ],
                ),
                const Divider(),
                const Text('Pagos y reversiones'),
                for (final p in f['pagos'])
                  ListTile(
                    title: Text(
                      "${money(p['importe'])} · ${p['fecha'].toString().split(' ').first} · ${p['metodo'] ?? ''}",
                    ),
                    subtitle: Text(
                      p['revertido'] ? 'REVERTIDO · no computa' : 'Efectivo',
                    ),
                    trailing: p['revertido']
                        ? null
                        : TextButton(
                            onPressed: busy
                                ? null
                                : () => motivo(
                                    f,
                                    'Revertir pago',
                                    (m) => repo.revertirPagoProveedor(
                                      p['id'],
                                      motivo: m,
                                    ),
                                  ),
                            child: const Text('Revertir'),
                          ),
                  ),
                const Divider(),
                const Text('Historial'),
                for (final e in f['eventos']) Text(e),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> pagar(Map<String, dynamic> f) async {
    final r = await fields('Registrar pago · ${f['numero']}', {
      'Importe (€)': '',
      'Fecha (AAAA-MM-DD)': DateTime.now().toString().split(' ').first,
      'Medio': '',
      'Referencia': '',
    });
    if (r != null) {
      await run(() async {
        await ref
            .read(circuitoProveedorRepositoryProvider)
            .registrarPago(
              facturaId: f['id'],
              fecha: fecha(r['Fecha (AAAA-MM-DD)']!),
              importeCentimos: cents(r['Importe (€)']!),
              metodo: r['Medio'],
              referencia: r['Referencia'],
            );
      });
    }
  }

  DateTime fecha(String s) {
    final d = DateTime.parse(s);
    if (d.toString().split(' ').first != s) {
      throw ArgumentError('Revisa la fecha, con formato AAAA-MM-DD.');
    }
    return d;
  }

  int cents(String s) {
    final v = double.parse(s.replaceAll(',', '.'));
    if (!v.isFinite) throw ArgumentError('Importe no válido.');
    return (v * 100).round();
  }

  Future<void> form({
    Map<String, dynamic>? f,
    Map<String, dynamic>? original,
    bool corregir = false,
  }) async {
    final proveedores = ref.read(proveedoresProvider).value ?? [];
    if (proveedores.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Crea primero un proveedor.')),
      );
      return;
    }
    String proveedor =
        f?['proveedorId'] ?? original?['proveedorId'] ?? proveedores.first.id;
    final elegido = await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Proveedor del documento recibido'),
        children: proveedores
            .where((p) => original == null || p.id == proveedor)
            .map(
              (p) => SimpleDialogOption(
                onPressed: () => Navigator.pop(ctx, p.id),
                child: Text(p.nombre),
              ),
            )
            .toList(),
      ),
    );
    if (elegido == null || !mounted) return;
    proveedor = elegido;
    final r = await fields(
      original == null
          ? 'Factura recibida en borrador'
          : 'Abono recibido · importes a descontar',
      {
        'Número': f?['numero'] ?? '',
        'Fecha (AAAA-MM-DD)': (f?['fecha'] ?? DateTime.now())
            .toString()
            .split(' ')
            .first,
        'Base (€)': f == null ? '' : (f['base'] / 100).toStringAsFixed(2),
        'IVA (€)': f == null ? '' : (f['iva'] / 100).toStringAsFixed(2),
        if (f != null && (f['asignaciones'] as List).length > 1)
          for (var i = 0; i < (f['asignaciones'] as List).length; i++)
            'Base tramo ${i + 1} (€)': (f['asignaciones'][i]['base'] / 100)
                .toStringAsFixed(2),
      },
    );
    if (r == null) return;
    final razon = corregir
        ? await fields('Motivo de la sustitución', {'Motivo': ''})
        : null;
    if (corregir && razon == null) return;
    await run(() async {
      final base = cents(r['Base (€)']!);
      final asig = f == null
          ? [AsignacionImporteInput(importeCentimos: base)]
          : [
              for (var i = 0; i < (f['asignaciones'] as List).length; i++)
                AsignacionImporteInput(
                  expedienteId: f['asignaciones'][i]['obra'],
                  importeCentimos: (f['asignaciones'] as List).length == 1
                      ? base
                      : cents(r['Base tramo ${i + 1} (€)']!),
                  ivaNoRecuperableCentimos:
                      f['asignaciones'][i]['ivaNoRecuperable'],
                ),
            ];
      final input = FacturaRecibidaInput(
        proveedorId: proveedor,
        numero: r['Número']!,
        fecha: fecha(r['Fecha (AAAA-MM-DD)']!),
        baseCentimos: base,
        ivaCentimos: cents(r['IVA (€)']!),
        asignaciones: asig,
        tipo: original != null ? 'abono' : f?['tipo'] ?? 'factura',
        originalId: original?['id'] ?? f?['originalId'],
        documentoId: f?['documentoId'],
      );
      final repo = ref.read(circuitoProveedorRepositoryProvider);
      if (corregir) {
        await repo.corregirFactura(f!['id'], input, motivo: razon!['Motivo']!);
      } else if (f == null) {
        await repo.crearFactura(input);
      } else {
        await repo.editarBorrador(f['id'], input);
      }
    });
  }

  Future<void> imputar(Map<String, dynamic> f) async {
    final obras = ref.read(expedientesCompraProvider).value ?? [];
    final destino = await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Destino de la factura'),
        children: [
          for (final o in [
            ('sinAsignar', 'Sin obra asignada'),
            ('general', 'Gasto general'),
            ...obras.map((o) => (o.id, o.nombre)),
          ])
            SimpleDialogOption(
              onPressed: () => Navigator.pop(ctx, o.$1),
              child: Text(o.$2),
            ),
        ],
      ),
    );
    if (destino == null || !mounted) return;
    await motivo(
      f,
      'Cambiar imputación',
      (m) => ref
          .read(circuitoProveedorRepositoryProvider)
          .cambiarImputacion(
            f['id'],
            destino: ['sinAsignar', 'general'].contains(destino)
                ? destino
                : 'obra',
            motivo: m,
            asignaciones: (f['asignaciones'] as List)
                .map(
                  (a) => AsignacionImporteInput(
                    expedienteId: ['sinAsignar', 'general'].contains(destino)
                        ? null
                        : destino,
                    importeCentimos: a['base'],
                    ivaNoRecuperableCentimos: a['ivaNoRecuperable'],
                  ),
                )
                .toList(),
          ),
    );
  }
}

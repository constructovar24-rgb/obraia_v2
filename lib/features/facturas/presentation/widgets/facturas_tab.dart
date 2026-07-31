import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/factura_repository.dart';
import '../../domain/estado_factura.dart';
import '../../domain/factura.dart' as factura_domain;
import '../screens/editar_factura_screen.dart';

class FacturasTab extends ConsumerStatefulWidget {
  const FacturasTab({
    super.key,
    required this.expedienteId,
  });

  final String expedienteId;

  @override
  ConsumerState<FacturasTab> createState() => _FacturasTabState();
}

class _FacturasTabState extends ConsumerState<FacturasTab> {
  late final FacturaRepository _repository;
  late final Stream<List<factura_domain.Factura>> _stream;

  @override
  void initState() {
    super.initState();
    _repository = ref.read(facturaRepositoryProvider);
    _stream = _repository.observarPorExpediente(widget.expedienteId);
  }

  @override
  Widget build(BuildContext context) {
    String formatearFecha(DateTime fecha) {
      final day = fecha.day.toString().padLeft(2, '0');
      final month = fecha.month.toString().padLeft(2, '0');
      final year = fecha.year.toString();
      return '$day/$month/$year';
    }

    String formatearImporte(double importe) {
      return '${importe.toStringAsFixed(2)} €';
    }

    return StreamBuilder<List<factura_domain.Factura>>(
      stream: _stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SelectableText(
                'ERROR:\n\n${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final facturas = snapshot.data ?? const [];

        if (facturas.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Text(
                'Este expediente todavía no tiene facturas.',
                style: TextStyle(fontSize: 18),
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: ListView.builder(
            itemCount: facturas.length,
            itemBuilder: (context, index) {
              final factura = facturas[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: const Icon(Icons.receipt_long_outlined),
                  title: Text(factura.codigo),
                  subtitle: Text(
                    '${formatearFecha(factura.fecha)}\nEstado: ${estadoFacturaToLabel(factura.estado)}\nTotal: ${formatearImporte(factura.total)}',
                  ),
                  isThreeLine: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditarFacturaScreen(
                          factura: factura,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/formatters/currency_formatter.dart';
import '../../../../core/formatters/date_formatter.dart';
import '../../../../core/shortcuts/app_shortcuts.dart';
import '../../../../core/widgets/app_page_header.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../data/factura_repository.dart';
import '../../domain/estado_factura.dart';
import '../../domain/factura.dart' as factura_domain;
import 'editar_factura_screen.dart';
import 'nueva_factura_screen.dart';

class FacturasScreen extends ConsumerStatefulWidget {
  const FacturasScreen({super.key});

  @override
  ConsumerState<FacturasScreen> createState() => _FacturasScreenState();
}

class _FacturasScreenState extends ConsumerState<FacturasScreen> {
  late final FacturaRepository _repository;
  late final Stream<List<factura_domain.Factura>> _stream;

  @override
  void initState() {
    super.initState();
    _repository = ref.read(facturaRepositoryProvider);
    _stream = _repository.observarFacturas();
  }

  @override
  Widget build(BuildContext context) {
    void abrirNuevaFactura() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const NuevaFacturaScreen(),
        ),
      );
    }

    return AppShortcutScope(
      onBack: () {
        Navigator.maybePop(context);
      },
      onNew: abrirNuevaFactura,
      child: Scaffold(
        appBar: const AppPageHeader(title: 'Facturas'),
        body: StreamBuilder<List<factura_domain.Factura>>(
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
              return const LoadingView();
            }

            final facturas = snapshot.data ?? const [];

            if (facturas.isEmpty) {
              return EmptyState(
                message: 'Todavía no hay facturas.',
                action: FilledButton(
                  onPressed: abrirNuevaFactura,
                  child: const Text('Nueva factura'),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: facturas.length,
                      itemBuilder: (context, index) {
                        final factura = facturas[index];
                        final cliente = factura.clienteNombre.isEmpty
                            ? 'Sin cliente'
                            : factura.clienteNombre;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            leading: const Icon(Icons.receipt_long_outlined),
                            title: Text(factura.codigo),
                            subtitle: Text(
                              'Cliente: $cliente\nFecha: ${DateFormatter.formatDdMmYyyy(factura.fecha)}\nEstado: ${estadoFacturaToLabel(factura.estado)}\nTotal: ${CurrencyFormatter.format(factura.total)}',
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
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: abrirNuevaFactura,
                      child: const Text('Nueva factura'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

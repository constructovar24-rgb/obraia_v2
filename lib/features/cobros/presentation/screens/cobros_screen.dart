import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/formatters/currency_formatter.dart';
import '../../../../core/formatters/date_formatter.dart';
import '../../../../core/shortcuts/app_shortcuts.dart';
import '../../../../core/widgets/app_page_header.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../data/cobro_repository.dart';
import '../../domain/cobro.dart' as cobro_domain;
import 'editar_cobro_screen.dart';
import 'nuevo_cobro_screen.dart';

class CobrosScreen extends ConsumerStatefulWidget {
  const CobrosScreen({
    super.key,
    required this.facturaId,
    required this.facturaCodigo,
  });

  final String facturaId;
  final String facturaCodigo;

  @override
  ConsumerState<CobrosScreen> createState() => _CobrosScreenState();
}

class _CobrosScreenState extends ConsumerState<CobrosScreen> {
  late final CobroRepository _repository;
  late final Stream<List<cobro_domain.Cobro>> _stream;

  @override
  void initState() {
    super.initState();
    _repository = ref.read(cobroRepositoryProvider);
    _stream = _repository.observarPorFactura(widget.facturaId);
  }

  @override
  Widget build(BuildContext context) {
    void abrirNuevoCobro() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => NuevoCobroScreen(
            facturaId: widget.facturaId,
          ),
        ),
      );
    }

    return AppShortcutScope(
      onBack: () {
        Navigator.maybePop(context);
      },
      onNew: abrirNuevoCobro,
      child: Scaffold(
        appBar: AppPageHeader(title: 'Cobros de ${widget.facturaCodigo}'),
        body: StreamBuilder<List<cobro_domain.Cobro>>(
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

            final cobros = snapshot.data ?? const [];

            if (cobros.isEmpty) {
              return EmptyState(
                message: 'Todavia no hay cobros para esta factura.',
                action: FilledButton(
                  onPressed: abrirNuevoCobro,
                  child: const Text('Nuevo cobro'),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cobros.length,
                      itemBuilder: (context, index) {
                        final cobro = cobros[index];

                        final referencia = cobro.referencia.trim().isEmpty
                            ? '-'
                            : cobro.referencia.trim();

                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            leading: const Icon(Icons.payments_outlined),
                            title: Text(
                              CurrencyFormatter.format(cobro.importe),
                            ),
                            subtitle: Text(
                              'Fecha: ${DateFormatter.formatDdMmYyyy(cobro.fecha)}\nMetodo: ${cobro.metodoPago}\nReferencia: $referencia',
                            ),
                            isThreeLine: true,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditarCobroScreen(
                                    cobro: cobro,
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
                      onPressed: abrirNuevoCobro,
                      child: const Text('Nuevo cobro'),
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
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/formatters/currency_formatter.dart';
import '../../../../core/formatters/date_formatter.dart';
import '../../../../core/shortcuts/app_shortcuts.dart';
import '../../../../core/ui/app_spacing.dart';
import '../../../../core/ui/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_section.dart';
import '../../../../core/widgets/app_page_header.dart';
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = AppTypography.textTheme(colorScheme);

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
              return AppErrorState(
                message: 'ERROR:\n\n${snapshot.error}',
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const AppLoading(
                message: 'Cargando facturas...',
              );
            }

            final facturas = snapshot.data ?? const [];

            if (facturas.isEmpty) {
              return AppEmptyState(
                icon: Icons.receipt_long_outlined,
                title: 'Todavía no hay facturas',
                subtitle: 'Crea la primera factura para empezar a trabajar.',
                actionLabel: 'Nueva factura',
                onAction: abrirNuevaFactura,
              );
            }

            return SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1180),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.md,
                            AppSpacing.md,
                            AppSpacing.md,
                            AppSpacing.sm,
                          ),
                          child: AppCard(
                            padding: const EdgeInsets.all(AppSpacing.xl),
                            highlighted: true,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 52,
                                  height: 52,
                                  decoration: BoxDecoration(
                                    color: colorScheme.primaryContainer,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.receipt_long_outlined,
                                    color: colorScheme.onPrimaryContainer,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Facturas',
                                        style: textTheme.headlineMedium,
                                      ),
                                      const SizedBox(height: AppSpacing.xs),
                                      Text(
                                        'Gestiona y abre cada factura desde una vista más clara y ordenada.',
                                        style: textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                AppPrimaryButton(
                                  label: 'Nueva factura',
                                  icon: Icons.add,
                                  onPressed: abrirNuevaFactura,
                                  expand: false,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.md,
                            AppSpacing.sm,
                            AppSpacing.md,
                            AppSpacing.lg,
                          ),
                          child: AppSection(
                            title: 'Listado de facturas',
                            subtitle:
                                'Selecciona una factura para ver o editar su información.',
                            actionLabel: 'Nueva factura',
                            onAction: abrirNuevaFactura,
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: facturas.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: AppSpacing.sm),
                              itemBuilder: (context, index) {
                                final factura = facturas[index];
                                final cliente = factura.clienteNombre.isEmpty
                                    ? 'Sin cliente'
                                    : factura.clienteNombre;

                                return AppCard(
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(
                                      AppSpacing.md,
                                    ),
                                    leading: CircleAvatar(
                                      backgroundColor:
                                          colorScheme.primaryContainer,
                                      foregroundColor:
                                          colorScheme.onPrimaryContainer,
                                      child: const Icon(
                                        Icons.receipt_long_outlined,
                                      ),
                                    ),
                                    title: Text(
                                      factura.codigo,
                                      style: textTheme.titleMedium,
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(
                                        top: AppSpacing.xs,
                                      ),
                                      child: Text(
                                        'Cliente: $cliente\nFecha: ${DateFormatter.formatDdMmYyyy(factura.fecha)}\nEstado: ${estadoFacturaToLabel(factura.estado)}\nTotal: ${CurrencyFormatter.format(factura.total)}',
                                        style: textTheme.bodyMedium,
                                      ),
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
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

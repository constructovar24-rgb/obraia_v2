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
import '../../../../core/widgets/app_page_header.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../facturas/domain/estado_factura.dart';
import '../../data/cobro_repository.dart';
import '../../domain/cobro.dart' as cobro_domain;
import 'editar_cobro_screen.dart';
import 'nuevo_cobro_screen.dart';

class CobrosScreen extends ConsumerStatefulWidget {
  const CobrosScreen({
    super.key,
    required this.facturaId,
    required this.facturaCodigo,
    required this.facturaEstado,
  }) : mes = null;

  CobrosScreen.delMesActual({super.key})
    : facturaId = null,
      facturaCodigo = null,
      facturaEstado = null,
      mes = DateTime.now();

  final String? facturaId;
  final String? facturaCodigo;
  final EstadoFactura? facturaEstado;
  final DateTime? mes;

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
    final facturaId = widget.facturaId;
    _stream = facturaId == null
        ? _repository.observarCobrosEnMesConFactura(widget.mes!)
        : _repository.observarPorFactura(facturaId);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = AppTypography.textTheme(colorScheme);
    final esPorFactura = widget.facturaId != null;
    final admiteNuevosCobros =
        widget.facturaEstado != null &&
        estadoFacturaAdmiteNuevosCobros(widget.facturaEstado!);
    final admiteModificarCobros =
        widget.facturaEstado == null ||
        estadoFacturaAdmiteModificarCobros(widget.facturaEstado!);

    void abrirNuevoCobro() {
      final facturaId = widget.facturaId;
      if (facturaId == null) {
        return;
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => NuevoCobroScreen(facturaId: facturaId),
        ),
      );
    }

    return AppShortcutScope(
      onBack: () {
        Navigator.maybePop(context);
      },
      onNew: admiteNuevosCobros ? abrirNuevoCobro : null,
      child: Scaffold(
        appBar: AppPageHeader(
          title: esPorFactura
              ? 'Cobros de ${widget.facturaCodigo}'
              : 'Cobros de este mes',
        ),
        body: StreamBuilder<List<cobro_domain.Cobro>>(
          stream: _stream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return AppErrorState(message: 'ERROR:\n\n${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const AppLoading(message: 'Cargando cobros...');
            }

            final cobros = snapshot.data ?? const [];

            if (cobros.isEmpty) {
              if (!esPorFactura) {
                return const AppEmptyState(
                  icon: Icons.payments_outlined,
                  title: 'No hay cobros este mes',
                  subtitle:
                      'No se han registrado movimientos en el mes actual.',
                );
              }
              return AppEmptyState(
                icon: Icons.payments_outlined,
                title: 'Todavía no hay cobros',
                subtitle: admiteNuevosCobros
                    ? 'Añade el primer cobro de esta factura.'
                    : 'El estado de la factura no permite nuevos cobros.',
                actionLabel: admiteNuevosCobros ? 'Nuevo cobro' : null,
                onAction: admiteNuevosCobros ? abrirNuevoCobro : null,
              );
            }

            return Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: cobros.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final cobro = cobros[index];

                        final referencia = cobro.referencia.trim().isEmpty
                            ? '-'
                            : cobro.referencia.trim();

                        return AppCard(
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(AppSpacing.md),
                            leading: CircleAvatar(
                              backgroundColor: colorScheme.primaryContainer,
                              foregroundColor: colorScheme.onPrimaryContainer,
                              child: const Icon(Icons.payments_outlined),
                            ),
                            title: Text(
                              CurrencyFormatter.format(cobro.importe),
                              style: textTheme.titleMedium,
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(
                                top: AppSpacing.xs,
                              ),
                              child: Text(
                                'Fecha: ${DateFormatter.formatDdMmYyyy(cobro.fecha)}\nMetodo: ${cobro.metodoPago}\nReferencia: $referencia',
                                style: textTheme.bodyMedium,
                              ),
                            ),
                            isThreeLine: true,
                            onTap: admiteModificarCobros
                                ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            EditarCobroScreen(cobro: cobro),
                                      ),
                                    );
                                  }
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                  if (admiteNuevosCobros)
                    SizedBox(
                      width: double.infinity,
                      child: AppPrimaryButton(
                        onPressed: abrirNuevoCobro,
                        label: 'Nuevo cobro',
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

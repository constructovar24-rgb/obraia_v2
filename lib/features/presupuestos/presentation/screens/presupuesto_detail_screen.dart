import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/app_spacing.dart';
import '../../../../core/ui/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/app_page_header.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_section.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../core/widgets/entity_summary_card.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../facturas/data/factura_repository.dart';
import '../../../facturas/domain/factura_presupuesto_policy.dart';
import '../../../facturas/presentation/screens/editar_factura_screen.dart';
import '../../domain/linea_presupuesto.dart' as linea_domain;
import '../../domain/presupuesto.dart' as presupuesto_domain;
import '../providers/presupuesto_providers.dart';
import 'presupuesto_pdf_preview_screen.dart';
import 'editar_linea_presupuesto_screen.dart';
import 'nuevo_linea_presupuesto_screen.dart';

class PresupuestoDetailScreen extends StatelessWidget {
  const PresupuestoDetailScreen({super.key, required this.presupuesto});

  final presupuesto_domain.Presupuesto presupuesto;

  String _formatearFecha(DateTime fecha) {
    final day = fecha.day.toString().padLeft(2, '0');
    final month = fecha.month.toString().padLeft(2, '0');
    final year = fecha.year.toString();
    return '$day/$month/$year';
  }

  String _formatearImporte(double importe) {
    return '${importe.toStringAsFixed(2)} €';
  }

  String _formatearMoneda(double value) {
    return '${value.toStringAsFixed(2).replaceAll('.', ',')} €';
  }

  String _formatearCantidad(double value) {
    if (value == value.truncateToDouble()) {
      return value.toStringAsFixed(0);
    }

    return value.toStringAsFixed(2).replaceAll('.', ',');
  }

  String _formatearPorcentaje(double value) {
    if (value == value.truncateToDouble()) {
      return value.toStringAsFixed(0);
    }

    return value.toStringAsFixed(2).replaceAll('.', ',');
  }

  StatusType _statusTypeFromEstado(String estado) {
    final normalized = estado.trim().toLowerCase();

    if (normalized == 'aceptado') {
      return StatusType.success;
    }

    if (normalized == 'rechazado') {
      return StatusType.error;
    }

    if (normalized == 'presentado') {
      return StatusType.info;
    }

    return StatusType.neutral;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = AppTypography.textTheme(colorScheme);

    return Scaffold(
      appBar: const AppPageHeader(showBackButton: true, title: 'Presupuesto'),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          EntitySummaryCard(
            title: presupuesto.codigo,
            subtitle: presupuesto.descripcion.isNotEmpty
                ? presupuesto.descripcion
                : '-',
            details: [
              Text(
                'Fecha: ${_formatearFecha(presupuesto.fecha)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                'Importe total (€): ${_formatearImporte(presupuesto.importeTotal)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            statusWidget: StatusChip(
              label: presupuesto.estado,
              type: _statusTypeFromEstado(presupuesto.estado),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Consumer(
            builder: (context, ref, _) {
              final repository = ref.read(lineaPresupuestoRepositoryProvider);

              return StreamBuilder<List<linea_domain.LineaPresupuesto>>(
                stream: repository.observarPorPresupuesto(presupuesto.id),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return AppErrorState(
                      message: 'ERROR:\n\n${snapshot.error}',
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const AppLoading(
                      message: 'Cargando líneas del presupuesto...',
                    );
                  }

                  final lineas = snapshot.data ?? const [];

                  if (lineas.isEmpty) {
                    return const AppEmptyState(
                      icon: Icons.format_list_bulleted,
                      title: 'Todavía no hay líneas de presupuesto',
                      subtitle:
                          'Añade la primera línea para calcular el total.',
                    );
                  }

                  final subtotal = lineas.fold<double>(
                    0,
                    (sum, linea) => sum + linea.importe,
                  );
                  final iva = subtotal * presupuesto.ivaPorcentaje / 100;
                  final total = subtotal + iva;

                  return AppSection(
                    title: 'Líneas del presupuesto',
                    subtitle:
                        'Revisa cada línea y su impacto en el total del presupuesto.',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: lineas.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: AppSpacing.sm),
                          itemBuilder: (context, index) {
                            final linea = lineas[index];

                            return AppCard(
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(
                                  AppSpacing.md,
                                ),
                                leading: CircleAvatar(
                                  backgroundColor: colorScheme.primaryContainer,
                                  foregroundColor:
                                      colorScheme.onPrimaryContainer,
                                  child: const Icon(Icons.format_list_bulleted),
                                ),
                                title: Text(
                                  linea.concepto,
                                  style: textTheme.titleMedium,
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(
                                    top: AppSpacing.xs,
                                  ),
                                  child: Text(
                                    '${_formatearCantidad(linea.cantidad)} × ${_formatearMoneda(linea.precioUnitario)} = ${_formatearMoneda(linea.importe)}',
                                    style: textTheme.bodyMedium,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          EditarLineaPresupuestoScreen(
                                            linea: linea,
                                          ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),
                        const Divider(),
                        const SizedBox(height: AppSpacing.sm),
                        Text('Subtotal', style: textTheme.titleMedium),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          _formatearMoneda(subtotal),
                          style: textTheme.bodyLarge,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'IVA (${_formatearPorcentaje(presupuesto.ivaPorcentaje)}%)',
                          style: textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(_formatearMoneda(iva), style: textTheme.bodyLarge),
                        const SizedBox(height: AppSpacing.sm),
                        const Divider(),
                        const SizedBox(height: AppSpacing.sm),
                        Text('TOTAL', style: textTheme.titleLarge),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          _formatearMoneda(total),
                          style: textTheme.headlineSmall,
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(height: AppSpacing.md),
          Consumer(
            builder: (context, ref, _) {
              final facturaRepository = ref.read(facturaRepositoryProvider);
              return StreamBuilder<BloqueoConversionPresupuesto?>(
                stream: facturaRepository.observarBloqueoConversion(
                  presupuesto.id,
                ),
                builder: (context, snapshot) {
                  final cargando =
                      snapshot.connectionState == ConnectionState.waiting;
                  final bloqueo = snapshot.data;
                  final disponible = !cargando && bloqueo == null;
                  final explicacion = switch (bloqueo) {
                    BloqueoConversionPresupuesto.presupuestoNoAceptado =>
                      'Solo los presupuestos aceptados pueden convertirse.',
                    BloqueoConversionPresupuesto.facturaNoAnuladaExistente =>
                      'Ya existe una factura activa o en borrador.',
                    BloqueoConversionPresupuesto.facturaAnuladaConCobros =>
                      'Existe una factura anulada con cobros históricos pendientes de saneamiento.',
                    null => null,
                  };

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppPrimaryButton(
                        enabled: disponible,
                        onPressed: disponible
                            ? () async {
                                try {
                                  final facturaId = await facturaRepository
                                      .convertirDesdePresupuesto(presupuesto);
                                  final factura = await facturaRepository
                                      .obtenerPorId(facturaId);

                                  if (!context.mounted) return;
                                  if (factura == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'No se pudo abrir la factura convertida.',
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          EditarFacturaScreen(factura: factura),
                                    ),
                                  );
                                } on PresupuestoYaConvertidoException {
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Ya existe una factura activa o en borrador.',
                                      ),
                                    ),
                                  );
                                } on PresupuestoNoAceptadoException {
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Solo los presupuestos aceptados pueden convertirse.',
                                      ),
                                    ),
                                  );
                                } on FacturaAnuladaConCobrosLegacyException {
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Existe una factura anulada con cobros históricos pendientes de saneamiento.',
                                      ),
                                    ),
                                  );
                                } catch (e) {
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'No se pudo convertir el presupuesto: $e',
                                      ),
                                    ),
                                  );
                                }
                              }
                            : null,
                        label: 'Convertir en factura',
                        icon: Icons.receipt_long_outlined,
                      ),
                      if (explicacion != null) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(explicacion, style: textTheme.bodySmall),
                      ],
                    ],
                  );
                },
              );
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          AppPrimaryButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      PresupuestoPdfPreviewScreen(presupuesto: presupuesto),
                ),
              );
            },
            label: 'Ver PDF',
            icon: Icons.picture_as_pdf_outlined,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppPrimaryButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NuevoLineaPresupuestoScreen(
                    presupuestoId: presupuesto.id,
                  ),
                ),
              );
            },
            label: 'Añadir línea',
            icon: Icons.add,
          ),
          const SizedBox(height: AppSpacing.sm),
          Consumer(
            builder: (context, ref, _) {
              return SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final confirmarEliminacion = await ConfirmDialog.show(
                      context,
                      title: 'Eliminar presupuesto',
                      message: '¿Seguro que quieres eliminar este presupuesto?',
                      confirmLabel: 'Eliminar',
                      cancelLabel: 'Cancelar',
                    );

                    if (!confirmarEliminacion || !context.mounted) {
                      return;
                    }

                    final presupuestoRepository = ref.read(
                      presupuestoRepositoryProvider,
                    );

                    final eliminado = await presupuestoRepository
                        .eliminarSiNoFacturado(presupuesto.id);

                    if (!context.mounted) {
                      return;
                    }

                    if (!eliminado) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'No se puede eliminar: el presupuesto ya ha sido facturado.',
                          ),
                        ),
                      );
                      return;
                    }

                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Eliminar presupuesto'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

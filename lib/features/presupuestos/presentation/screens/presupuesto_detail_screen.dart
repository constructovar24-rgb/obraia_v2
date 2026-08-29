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
import '../../../facturas/domain/facturacion_parcial.dart';
import '../../../facturas/presentation/providers/facturacion_parcial_providers.dart';
import '../../../facturas/presentation/screens/nueva_factura_parcial_screen.dart';
import '../../../facturas/presentation/screens/editar_factura_screen.dart';
import '../../../expedientes/data/expediente_repository.dart';
import '../../domain/linea_presupuesto.dart' as linea_domain;
import '../../domain/presupuesto.dart' as presupuesto_domain;
import '../../domain/estado_presupuesto.dart';
import '../providers/presupuesto_providers.dart';
import 'presupuesto_pdf_preview_screen.dart';
import 'editar_linea_presupuesto_screen.dart';
import 'nuevo_linea_presupuesto_screen.dart';

class PresupuestoDetailScreen extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(presupuestoRepositoryProvider);

    return StreamBuilder<presupuesto_domain.Presupuesto?>(
      stream: repository.observarPresupuesto(presupuesto.id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Scaffold(
            body: AppErrorState(message: 'No se pudo cargar el presupuesto.'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: AppLoading(message: 'Cargando presupuesto...'),
          );
        }

        final presupuestoActual = snapshot.data;
        if (presupuestoActual == null) {
          return const Scaffold(
            body: AppErrorState(
              message: 'El presupuesto ya no está disponible.',
            ),
          );
        }

        return _buildContenido(context, presupuestoActual);
      },
    );
  }

  Widget _buildContenido(
    BuildContext context,
    presupuesto_domain.Presupuesto presupuesto,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = AppTypography.textTheme(colorScheme);

    return Scaffold(
      appBar: const AppPageHeader(showBackButton: true, title: 'Presupuesto'),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Consumer(
            builder: (context, ref, _) {
              final expediente = ref
                  .watch(expedienteProvider(presupuesto.expedienteId))
                  .value;

              return EntitySummaryCard(
                title: presupuesto.codigo,
                subtitle: presupuesto.descripcion.isNotEmpty
                    ? presupuesto.descripcion
                    : '-',
                details: [
                  Text(
                    'Fecha: ${_formatearFecha(presupuesto.fecha)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  if (expediente != null)
                    Text(
                      'Expediente: ${expediente.codigo}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  if (expediente?.clienteNombre?.isNotEmpty ?? false)
                    Text(
                      'Cliente: ${expediente!.clienteNombre}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  Text(
                    'Subtotal (€): ${_formatearImporte(presupuesto.importeTotal)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
                statusWidget: StatusChip(
                  label: presupuesto.estado,
                  type: _statusTypeFromEstado(presupuesto.estado),
                ),
              );
            },
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
                                    '${_formatearCantidad(linea.cantidad)} ${linea.unidad} × ${_formatearMoneda(linea.precioUnitario)} = ${_formatearMoneda(linea.importe)}',
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
          _ResumenFacturacionParcial(presupuesto: presupuesto),
          const SizedBox(height: AppSpacing.md),
          if (puedeAceptarPresupuesto(presupuesto.estado)) ...[
            Consumer(
              builder: (context, ref, _) => AppPrimaryButton(
                onPressed: () async {
                  final confirmado = await ConfirmDialog.show(
                    context,
                    title: 'Aceptar presupuesto',
                    message:
                        '¿Quieres aceptar este presupuesto y habilitar su facturación?',
                    confirmLabel: 'Aceptar presupuesto',
                    cancelLabel: 'Cancelar',
                  );
                  if (!confirmado || !context.mounted) return;

                  try {
                    await ref
                        .read(presupuestoRepositoryProvider)
                        .aceptarPresupuesto(presupuesto.id);
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Presupuesto aceptado.')),
                    );
                  } on EstadoPresupuestoException catch (error) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(error.mensaje)));
                  }
                },
                label: 'Aceptar presupuesto',
                icon: Icons.check_circle_outline,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          Consumer(
            builder: (context, ref, _) {
              final parcialRepository = ref.read(
                facturacionParcialRepositoryProvider,
              );
              return StreamBuilder<ResumenFacturacionPresupuesto>(
                stream: parcialRepository.observarResumen(presupuesto.id),
                builder: (context, snapshot) {
                  final cargando =
                      snapshot.connectionState == ConnectionState.waiting;
                  final resumen = snapshot.data;
                  final bloqueo = obtenerBloqueoCrearFacturaParcial(
                    estadoPresupuesto: presupuesto.estado,
                    resumen: cargando ? null : resumen,
                  );
                  final disponible = bloqueo == null;
                  final explicacion = switch (bloqueo) {
                    null => null,
                    BloqueoCrearFacturaParcial.presupuestoNoAceptado =>
                      'El presupuesto debe estar aceptado antes de facturarlo.',
                    BloqueoCrearFacturaParcial.calculandoDisponibilidad =>
                      'Calculando disponibilidad...',
                    BloqueoCrearFacturaParcial.consumoLegacySinDetalle =>
                      'Las facturas legacy sin detalle deben regularizarse antes de continuar.',
                    BloqueoCrearFacturaParcial.sinPendiente =>
                      'El presupuesto está completamente reservado o facturado.',
                  };

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppPrimaryButton(
                        enabled: disponible,
                        onPressed: disponible
                            ? () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => NuevaFacturaParcialScreen(
                                      presupuesto: presupuesto,
                                    ),
                                  ),
                                );
                              }
                            : null,
                        label: 'Crear factura parcial',
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

class _ResumenFacturacionParcial extends ConsumerWidget {
  const _ResumenFacturacionParcial({required this.presupuesto});
  final presupuesto_domain.Presupuesto presupuesto;

  String _importe(double value) =>
      '${value.toStringAsFixed(2).replaceAll('.', ',')} €';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(facturacionParcialRepositoryProvider);
    return StreamBuilder<ResumenFacturacionPresupuesto>(
      stream: repository.observarResumen(presupuesto.id),
      builder: (context, resumenSnapshot) {
        if (!resumenSnapshot.hasData) {
          return const AppLoading(message: 'Calculando facturación...');
        }
        final resumen = resumenSnapshot.data!;
        final iva = resumen.basePresupuestada * presupuesto.ivaPorcentaje / 100;
        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Facturación acumulada',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Base presupuestada: ${_importe(resumen.basePresupuestada)}',
              ),
              Text('IVA presupuestado: ${_importe(iva)}'),
              Text(
                'Total con IVA: ${_importe(resumen.basePresupuestada + iva)}',
              ),
              Text('Facturado emitido: ${_importe(resumen.facturado)}'),
              Text('Reservado en borradores: ${_importe(resumen.reservado)}'),
              Text('Pendiente disponible: ${_importe(resumen.pendiente)}'),
              if (resumen.tieneConsumoLegacySinDetalle)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'Existen facturas históricas sin asignación por partida. Se conserva su consumo global.',
                  ),
                ),
              const Divider(height: 24),
              StreamBuilder(
                stream: repository.observarFacturas(presupuesto.id),
                builder: (context, facturasSnapshot) {
                  final facturas = facturasSnapshot.data ?? const [];
                  if (facturas.isEmpty) {
                    return const Text('Todavía no hay facturas vinculadas.');
                  }
                  return Column(
                    children: facturas
                        .map(
                          (factura) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              factura.codigo.isEmpty
                                  ? 'Borrador sin número'
                                  : factura.codigo,
                            ),
                            subtitle: Text(
                              '${factura.estado.name} · ${_importe(factura.subtotal)}',
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    EditarFacturaScreen(factura: factura),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

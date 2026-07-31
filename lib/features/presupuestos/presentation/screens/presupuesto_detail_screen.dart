import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_page_header.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../core/widgets/entity_summary_card.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../facturas/data/factura_repository.dart';
import '../../../facturas/presentation/screens/editar_factura_screen.dart';
import '../../domain/linea_presupuesto.dart' as linea_domain;
import '../../domain/presupuesto.dart' as presupuesto_domain;
import '../providers/presupuesto_providers.dart';
import 'presupuesto_pdf_preview_screen.dart';
import 'editar_linea_presupuesto_screen.dart';
import 'nuevo_linea_presupuesto_screen.dart';

class PresupuestoDetailScreen extends StatelessWidget {
  const PresupuestoDetailScreen({
    super.key,
    required this.presupuesto,
  });

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
    return Scaffold(
      appBar: const AppPageHeader(
        showBackButton: true,
        title: 'Presupuesto',
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
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
          const SizedBox(height: 24),
          const Text(
            'Líneas del presupuesto',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Consumer(
            builder: (context, ref, _) {
              final repository = ref.read(lineaPresupuestoRepositoryProvider);

              return StreamBuilder<List<linea_domain.LineaPresupuesto>>(
                stream: repository.observarPorPresupuesto(presupuesto.id),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: SelectableText(
                        'ERROR:\n\n${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final lineas = snapshot.data ?? const [];

                  if (lineas.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text('Todavía no hay líneas de presupuesto.'),
                    );
                  }

                  final subtotal = lineas.fold<double>(
                    0,
                    (sum, linea) => sum + linea.importe,
                  );
                  final iva = subtotal * presupuesto.ivaPorcentaje / 100;
                  final total = subtotal + iva;

                  final lineasWidgets = lineas
                      .map<Widget>(
                        (linea) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(linea.concepto),
                          subtitle: Text(
                            '${_formatearCantidad(linea.cantidad)} × ${_formatearMoneda(linea.precioUnitario)} = ${_formatearMoneda(linea.importe)}',
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditarLineaPresupuestoScreen(
                                  linea: linea,
                                ),
                              ),
                            );
                          },
                        ),
                      )
                      .toList();

                  lineasWidgets.addAll([
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 8),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Subtotal',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _formatearMoneda(subtotal),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'IVA (${_formatearPorcentaje(presupuesto.ivaPorcentaje)}%)',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _formatearMoneda(iva),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                    const SizedBox(height: 12),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'TOTAL',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _formatearMoneda(total),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ]);

                  return Column(
                    children: lineasWidgets,
                  );
                },
              );
            },
          ),
          const SizedBox(height: 12),
          Consumer(
            builder: (context, ref, _) {
              return SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    final facturaRepository = ref.read(
                      facturaRepositoryProvider,
                    );

                    try {
                      final facturaId = await facturaRepository
                          .convertirDesdePresupuesto(presupuesto);

                      final factura = await facturaRepository.obtenerPorId(
                        facturaId,
                      );

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
                          builder: (_) => EditarFacturaScreen(
                            factura: factura,
                          ),
                        ),
                      );
                    } on PresupuestoYaConvertidoException {
                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Este presupuesto ya fue convertido en factura.',
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
                  },
                  child: const Text('Convertir en factura'),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PresupuestoPdfPreviewScreen(
                      presupuesto: presupuesto,
                    ),
                  ),
                );
              },
              child: const Text('Ver PDF'),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
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
              child: const Text('Añadir línea'),
            ),
          ),
          const SizedBox(height: 12),
          Consumer(
            builder: (context, ref, _) {
              return SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final confirmarEliminacion = await ConfirmDialog.show(
                      context,
                      title: 'Eliminar presupuesto',
                      message:
                          '¿Seguro que quieres eliminar este presupuesto?',
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

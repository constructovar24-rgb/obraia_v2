import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

import '../../../clientes/data/cliente_repository.dart';
import '../../../clientes/domain/cliente.dart' as cliente_domain;
import '../../../configuracion/data/empresa_configuracion_repository.dart';
import '../../data/factura_linea_repository.dart';
import '../../data/factura_repository.dart';
import '../../domain/factura.dart' as factura_domain;
import '../../domain/factura_linea.dart' as factura_linea_domain;
import '../../services/factura_pdf_service.dart';
import '../providers/rectificativa_providers.dart';

class FacturaPdfPreviewScreen extends ConsumerWidget {
  const FacturaPdfPreviewScreen({super.key, required this.factura});

  final factura_domain.Factura factura;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lineasRepository = ref.read(facturaLineaRepositoryProvider);
    final facturasRepository = ref.read(facturaRepositoryProvider);
    final empresaRepository = ref.read(empresaConfiguracionRepositoryProvider);
    final clienteRepository = ref.read(clienteRepositoryProvider);
    final rectificativasRepository = ref.read(rectificativaRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Vista previa de la factura')),
      body: StreamBuilder<List<factura_linea_domain.FacturaLinea>>(
        stream: lineasRepository.observarPorFactura(factura.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('No se pudo cargar el PDF: ${snapshot.error}'),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final lineas = snapshot.data ?? const [];

          return FutureBuilder(
            future: empresaRepository.obtenerOCrearConfiguracion(),
            builder: (context, empresaSnapshot) {
              if (empresaSnapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'No se pudo cargar la configuración de empresa: ${empresaSnapshot.error}',
                    ),
                  ),
                );
              }

              if (empresaSnapshot.connectionState == ConnectionState.waiting ||
                  !empresaSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final empresaConfiguracion = empresaSnapshot.data!;

              return FutureBuilder<cliente_domain.Cliente?>(
                future: clienteRepository.obtenerCliente(factura.clienteId),
                builder: (context, clienteSnapshot) {
                  if (clienteSnapshot.connectionState ==
                          ConnectionState.waiting &&
                      !clienteSnapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return FutureBuilder<factura_domain.Factura?>(
                    future: facturasRepository.obtenerPorId(factura.id),
                    builder: (context, facturaSnapshot) {
                      if (facturaSnapshot.connectionState ==
                              ConnectionState.waiting &&
                          !facturaSnapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final facturaActual = facturaSnapshot.data ?? factura;

                      return FutureBuilder(
                        future: Future.wait([
                          if (facturaActual.esRectificativa)
                            rectificativasRepository.obtenerOriginal(
                              facturaActual,
                            ),
                          if (facturaActual.esRectificativa &&
                              facturaActual.fechaEmision != null)
                            rectificativasRepository.obtenerPdfEmitido(
                              facturaActual.id,
                            ),
                          if (!facturaActual.esRectificativa &&
                              facturaActual.fechaEmision != null)
                            facturasRepository.obtenerPdfEmitido(
                              facturaActual.id,
                            ),
                        ]),
                        builder: (context, rectSnapshot) {
                          if (rectSnapshot.hasError) {
                            return Center(
                              child: Text(
                                'No se pudo verificar el PDF histórico: ${rectSnapshot.error}',
                              ),
                            );
                          }
                          if (rectSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final datos = rectSnapshot.data ?? const [];
                          final original = datos
                              .whereType<factura_domain.Factura>()
                              .firstOrNull;
                          final pdfHistorico = datos
                              .whereType<Uint8List>()
                              .firstOrNull;
                          final preview = PdfPreview(
                            build: (format) async =>
                                pdfHistorico ??
                                FacturaPdfService().generarPdf(
                                  factura: facturaActual,
                                  facturaOriginal: original,
                                  lineas: lineas,
                                  empresaConfiguracion: empresaConfiguracion,
                                  cliente: clienteSnapshot.data,
                                ),
                            allowPrinting: true,
                            allowSharing: true,
                            canChangeOrientation: false,
                            canChangePageFormat: false,
                          );
                          if (facturaActual.fechaEmision != null &&
                              pdfHistorico == null) {
                            return Column(
                              children: [
                                const MaterialBanner(
                                  content: Text(
                                    'Factura legacy: no existe un PDF original histórico almacenado. La vista inferior es una reconstrucción actual para consulta y no se archivará como original.',
                                  ),
                                  actions: [SizedBox.shrink()],
                                ),
                                Expanded(child: preview),
                              ],
                            );
                          }
                          return preview;
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

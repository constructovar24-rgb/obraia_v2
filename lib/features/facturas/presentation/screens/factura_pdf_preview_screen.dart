import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

import '../../../../database/database_provider.dart';
import '../../../clientes/data/cliente_repository.dart';
import '../../../clientes/domain/cliente.dart' as cliente_domain;
import '../../../configuracion/data/empresa_configuracion_repository.dart';
import '../../data/factura_linea_repository.dart';
import '../../data/factura_repository.dart';
import '../../domain/factura.dart' as factura_domain;
import '../../domain/factura_linea.dart' as factura_linea_domain;
import '../../services/factura_pdf_service.dart';

class FacturaPdfPreviewScreen extends ConsumerWidget {
  const FacturaPdfPreviewScreen({
    super.key,
    required this.factura,
  });

  final factura_domain.Factura factura;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lineasRepository = ref.read(facturaLineaRepositoryProvider);
    final facturasRepository = ref.read(facturaRepositoryProvider);
    final empresaRepository = ref.read(empresaConfiguracionRepositoryProvider);
    final clienteRepository = ClienteRepository(ref.read(databaseProvider));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vista previa de la factura'),
      ),
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

                      return PdfPreview(
                        build: (format) => FacturaPdfService().generarPdf(
                          factura: facturaActual,
                          lineas: lineas,
                          empresaConfiguracion: empresaConfiguracion,
                          cliente: clienteSnapshot.data,
                        ),
                        allowPrinting: true,
                        allowSharing: true,
                        canChangeOrientation: false,
                        canChangePageFormat: false,
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
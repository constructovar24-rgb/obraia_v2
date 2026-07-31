import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

import '../../../configuracion/data/empresa_configuracion_repository.dart';
import '../../domain/linea_presupuesto.dart' as linea_domain;
import '../../domain/presupuesto.dart' as presupuesto_domain;
import '../providers/presupuesto_providers.dart';
import '../../services/presupuesto_pdf_service.dart';

class PresupuestoPdfPreviewScreen extends ConsumerWidget {
  const PresupuestoPdfPreviewScreen({
    super.key,
    required this.presupuesto,
  });

  final presupuesto_domain.Presupuesto presupuesto;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.read(lineaPresupuestoRepositoryProvider);
    final empresaRepository = ref.read(empresaConfiguracionRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vista previa del presupuesto'),
      ),
      body: StreamBuilder<List<linea_domain.LineaPresupuesto>>(
        stream: repository.observarPorPresupuesto(presupuesto.id),
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

              return PdfPreview(
                build: (format) => PresupuestoPdfService().generarPdf(
                  presupuesto,
                  lineas,
                  empresaConfiguracion,
                ),
                allowPrinting: true,
                allowSharing: true,
                canChangeOrientation: false,
                canChangePageFormat: false,
              );
            },
          );
        },
      ),
    );
  }
}

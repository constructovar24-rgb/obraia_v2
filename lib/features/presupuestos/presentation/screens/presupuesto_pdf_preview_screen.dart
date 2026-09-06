import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import '../../domain/presupuesto.dart' as presupuesto_domain;
import '../../domain/estado_presupuesto.dart';
import '../providers/presupuesto_providers.dart';

class PresupuestoPdfPreviewScreen extends ConsumerWidget {
  const PresupuestoPdfPreviewScreen({super.key, required this.presupuesto});
  final presupuesto_domain.Presupuesto presupuesto;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bytes = ref.watch(presupuestoPdfProvider(presupuesto.id));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          estadoPresupuestoEsAceptado(presupuesto.estado)
              ? 'PDF definitivo aceptado'
              : 'PDF borrador',
        ),
      ),
      body: bytes.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(error.toString()),
          ),
        ),
        data: (pdf) => PdfPreview(
          build: (_) async => pdf,
          allowPrinting: true,
          allowSharing: true,
          canChangeOrientation: false,
          canChangePageFormat: false,
        ),
      ),
    );
  }
}

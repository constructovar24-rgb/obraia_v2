import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../database/database_provider.dart';
import '../../data/documento_repository.dart';
import '../../domain/documento.dart';

final documentoRepositoryProvider = Provider<DocumentoRepository>((ref) {
  ref.watch(activeTenantIdProvider);
  final database = ref.watch(databaseProvider);
  return DocumentoRepository(database.documentosDao);
});

final documentosPorExpedienteProvider =
    StreamProvider.family<List<Documento>, String>((ref, expedienteId) {
      final documentoRepository = ref.watch(documentoRepositoryProvider);
      return documentoRepository.observarDocumentosPorExpediente(expedienteId);
    });

final documentoProvider = StreamProvider.family<Documento?, String>((ref, id) {
  final documentoRepository = ref.watch(documentoRepositoryProvider);
  return documentoRepository.observarDocumento(id);
});

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../database/database_provider.dart';
import '../../data/documento_repository.dart';
import '../../domain/documento.dart';

final documentoRepositoryProvider = Provider<DocumentoRepository>((ref) {
  final database = ref.read(databaseProvider);
  return DocumentoRepository(database.documentosDao);
});

final documentosPorExpedienteProvider =
    StreamProvider.family<List<Documento>, String>((ref, expedienteId) {
  final documentoRepository = ref.read(documentoRepositoryProvider);
  return documentoRepository.observarDocumentosPorExpediente(
    expedienteId,
  );
});

final documentoProvider = StreamProvider.family<Documento?, String>((
  ref,
  id,
) {
  final documentoRepository = ref.read(documentoRepositoryProvider);
  return documentoRepository.observarDocumento(id);
});

import 'package:uuid/uuid.dart';

import '../../../database/dao/documentos_dao.dart';
import '../domain/documento.dart';
import 'documento_mapper.dart';

class DocumentoRepository {
  DocumentoRepository(this._dao);

  final DocumentosDao _dao;

  Future<void> registrarDocumento(Documento documento) async {
    final documentoConId = Documento(
      id: const Uuid().v4(),
      expedienteId: documento.expedienteId,
      titulo: documento.titulo,
      nombreArchivo: documento.nombreArchivo,
      rutaArchivo: documento.rutaArchivo,
      mimeType: documento.mimeType,
      tamanoBytes: documento.tamanoBytes,
      fecha: documento.fecha,
      observaciones: documento.observaciones,
      tipo: documento.tipo,
    );

    await _dao.insertarDocumento(documentoConId.toCompanion());
  }

  Future<List<Documento>> obtenerDocumentosPorExpediente(
    String expedienteId,
  ) async {
    final rows = await _dao.obtenerPorExpediente(expedienteId);
    return rows.map((row) => row.toDomain()).toList();
  }

  Stream<List<Documento>> observarDocumentosPorExpediente(String expedienteId) {
    return _dao.observarPorExpediente(expedienteId).map(
      (rows) => rows.map((row) => row.toDomain()).toList(),
    );
  }

  Stream<Documento?> observarDocumento(String id) {
    return _dao.observarDocumento(id).map(
      (row) => row?.toDomain(),
    );
  }

  Future<Documento?> obtenerDocumento(String id) async {
    final row = await _dao.obtenerDocumento(id);
    return row?.toDomain();
  }

  Future<void> actualizarDocumento(Documento documento) {
    return _dao.actualizarDocumento(
      documento.id,
      documento.toCompanion(),
    );
  }

  Future<void> eliminarDocumento(String documentoId) {
    return _dao.eliminarLogicamente(documentoId);
  }
}

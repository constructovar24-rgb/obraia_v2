import 'package:crypto/crypto.dart';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../core/environment/environment_paths.dart';
import '../../../database/dao/documentos_dao.dart';
import '../domain/documento.dart';
import 'documento_mapper.dart';
import 'managed_document_store.dart';

class DocumentoRepository {
  DocumentoRepository(this._dao, {this.store});
  final DocumentosDao _dao;
  final ManagedDocumentStore? store;
  Future<ManagedDocumentStore> _storage() async {
    final storage =
        store ??
        ManagedDocumentStore(
          await EnvironmentPaths.resolve(_dao.attachedDatabase.environment),
        );
    if (storage.paths.environment != _dao.attachedDatabase.environment) {
      throw StateError('El almacén documental pertenece a otro entorno.');
    }
    return storage;
  }

  Future<void> registrarDocumento(Documento documento) async {
    final tenant = _dao.attachedDatabase.activeTenantId;
    final original = await (await _storage()).incorporate(
      documento.rutaArchivo,
      tenant,
    );
    if (_dao.attachedDatabase.activeTenantId != tenant) {
      throw StateError('La empresa activa ha cambiado.');
    }
    final nuevo = Documento(
      id: const Uuid().v4(),
      expedienteId: documento.expedienteId,
      titulo: documento.titulo,
      nombreArchivo: original.originalName,
      rutaArchivo: documento.rutaArchivo,
      mimeType: documento.mimeType,
      tamanoBytes: original.size,
      fecha: documento.fecha,
      observaciones: documento.observaciones,
      tipo: documento.tipo,
      rutaGestionada: original.relativePath,
      sha256Original: original.hash,
      incorporadoUtc: DateTime.now().toUtc(),
    );
    await _dao.insertarDocumento(nuevo.toCompanion());
  }

  Future<List<Documento>> obtenerDocumentosPorExpediente(
    String expedienteId,
  ) async => (await _dao.obtenerPorExpediente(
    expedienteId,
  )).map((row) => row.toDomain()).toList();
  Stream<List<Documento>> observarDocumentosPorExpediente(
    String expedienteId,
  ) => _dao
      .observarPorExpediente(expedienteId)
      .map((rows) => rows.map((row) => row.toDomain()).toList());
  Stream<Documento?> observarDocumento(String id) =>
      _dao.observarDocumento(id).map((row) => row?.toDomain());
  Future<Documento?> obtenerDocumento(String id) async =>
      (await _dao.obtenerDocumento(id))?.toDomain();

  Future<String> verificarDocumento(String id) async {
    final row = await _dao.obtenerDocumento(id);
    if (row == null) throw StateError('Documento no disponible.');
    if (row.rutaGestionada == null) {
      return await File(row.rutaArchivo).exists()
          ? 'Archivo externo'
          : 'Archivo no encontrado';
    }
    if (row.incorporadoUtc == null || row.sha256Original == null) {
      return 'Metadatos incoherentes / revisar';
    }
    return (await _storage()).verify(
      relative: row.rutaGestionada!,
      tenantId: row.tenantId,
      hash: row.sha256Original ?? '',
      size: row.tamanoBytes,
    );
  }

  Future<void> exportarOriginal(String id, String destinationPath) async {
    final row = await _dao.obtenerDocumento(id);
    if (row == null) throw StateError('Documento no disponible.');
    File source;
    if (row.rutaGestionada != null) {
      final storage = await _storage();
      if (await storage.verify(
            relative: row.rutaGestionada!,
            tenantId: row.tenantId,
            hash: row.sha256Original ?? '',
            size: row.tamanoBytes,
          ) !=
          'Integridad correcta') {
        throw StateError('El archivo no supera la comprobación de integridad.');
      }
      source = await storage.resolve(
        row.rutaGestionada!,
        row.tenantId,
        row.sha256Original!,
      );
    } else {
      source = File(row.rutaArchivo);
    }
    final destination = File(destinationPath);
    if (await destination.exists()) {
      throw StateError('Elige un nombre de destino que no exista.');
    }
    final bytes = await source.readAsBytes();
    if (row.rutaGestionada != null &&
        (bytes.length != row.tamanoBytes ||
            sha256.convert(bytes).toString() != row.sha256Original)) {
      throw StateError('El archivo cambió durante la exportación.');
    }
    await destination.create(exclusive: true);
    await destination.writeAsBytes(bytes, flush: true);
  }

  Future<void> actualizarDocumento(Documento documento) async {
    final old = await _dao.obtenerDocumento(documento.id);
    if (old == null) throw StateError('Documento no disponible.');
    if (old.rutaGestionada != null &&
        (documento.rutaArchivo != old.rutaArchivo ||
            documento.nombreArchivo != old.nombreArchivo ||
            documento.tamanoBytes != old.tamanoBytes ||
            documento.mimeType != old.mimeType)) {
      throw StateError(
        'El original protegido no se puede sustituir. Incorpore otro documento.',
      );
    }
    await _dao.actualizarDocumento(
      documento.id,
      documento.toCompanion().copyWith(
        rutaGestionada: Value(old.rutaGestionada),
        sha256Original: Value(old.sha256Original),
        incorporadoUtc: Value(old.incorporadoUtc),
      ),
    );
  }

  Future<void> eliminarDocumento(String id) => _dao.eliminarLogicamente(id);
}

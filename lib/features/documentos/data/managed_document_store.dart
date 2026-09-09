import 'dart:typed_data';
import 'original_source_reader.dart';
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;
import '../../../core/environment/environment_paths.dart';

/// Immutable original files. Paths use hashed tenant identifiers and content hashes.
class ManagedDocumentStore {
  ManagedDocumentStore(
    this.paths, {
    Future<Uint8List> Function(File)? sourceReader,
  }) : _sourceReader = sourceReader ?? readStableOriginal;
  final Future<Uint8List> Function(File) _sourceReader;
  final EnvironmentPaths paths;
  static const maxFileBytes = 100 * 1024 * 1024;

  static String tenantSegment(String tenantId) =>
      sha256.convert(utf8.encode(tenantId)).toString();

  static bool validPath(String path, String tenantId, String hash) =>
      RegExp(r'^[0-9a-f]{64}$').hasMatch(hash) &&
      path == '${tenantSegment(tenantId)}/$hash.original';

  static Future<void> requireNoLinks(String path) async {
    var current = p.normalize(p.absolute(path));
    while (true) {
      if (await FileSystemEntity.type(current, followLinks: false) ==
          FileSystemEntityType.link) {
        throw StateError('No se admiten enlaces en el archivo documental.');
      }
      final parent = p.dirname(current);
      if (parent == current) return;
      current = parent;
    }
  }

  Future<File> resolve(String relative, String tenantId, String hash) async {
    if (!validPath(relative, tenantId, hash)) {
      throw StateError('Metadatos del documento incoherentes.');
    }
    final root = paths.managedDocumentsDirectory;
    final parent = Directory(p.join(root.path, tenantSegment(tenantId)));
    final file = File(p.join(parent.path, '$hash.original'));
    await requireNoLinks(file.path);
    for (final path in [root.path, parent.path, file.path]) {
      if (await FileSystemEntity.type(path, followLinks: false) ==
          FileSystemEntityType.link) {
        throw StateError('No se admiten enlaces en el archivo documental.');
      }
    }
    return file;
  }

  Future<ManagedOriginal> incorporate(
    String sourcePath,
    String tenantId,
  ) async {
    final source = File(sourcePath);
    final bytes = await _sourceReader(source);
    if (bytes.isEmpty) {
      throw StateError(
        'El archivo está vacío (0 bytes). Guarda su contenido antes de incorporarlo.',
      );
    }
    if (bytes.length > maxFileBytes) {
      throw StateError('El archivo supera 100 MB.');
    }
    final hash = sha256.convert(bytes).toString();
    final relative = '${tenantSegment(tenantId)}/$hash.original';
    final target = await resolve(relative, tenantId, hash);
    await target.parent.create(recursive: true);
    final staging = await target.parent.createTemp('.import-');
    try {
      final candidate = File(p.join(staging.path, 'original.pending'));
      await candidate.writeAsBytes(bytes, flush: true);
      if (await candidate.length() != bytes.length ||
          sha256.convert(await candidate.readAsBytes()).toString() != hash) {
        throw StateError('No se pudo comprobar la copia del original.');
      }
      final current = await _sourceReader(source);
      if (current.length != bytes.length ||
          sha256.convert(current).toString() != hash) {
        throw StateError(
          'El archivo cambió durante la incorporación. Guarda el archivo y vuelve a seleccionarlo.',
        );
      }
      // No await between the existence check and rename: imports in this process
      // cannot interleave publication. Only a fully written candidate is visible.
      if (target.existsSync()) {
        if (target.lengthSync() != bytes.length ||
            sha256.convert(target.readAsBytesSync()).toString() != hash) {
          throw StateError(
            'El archivo gestionado fue modificado. Revise su integridad.',
          );
        }
      } else {
        candidate.renameSync(target.path);
      }
      return ManagedOriginal(
        relative,
        hash,
        bytes.length,
        p.basename(source.path),
      );
    } finally {
      if (await staging.exists()) await staging.delete(recursive: true);
    }
  }

  Future<String> verify({
    required String relative,
    required String tenantId,
    required String hash,
    required int size,
  }) async {
    try {
      final file = await resolve(relative, tenantId, hash);
      if (!await file.exists()) return 'Archivo no encontrado';
      if (size <= 0 || await file.length() == 0) {
        return 'Archivo vacío / revisar';
      }
      if (await file.length() != size ||
          sha256.convert(await file.readAsBytes()).toString() != hash) {
        return 'Archivo modificado / revisar';
      }
      return 'Integridad correcta';
    } catch (_) {
      return 'Metadatos incoherentes / revisar';
    }
  }
}

class ManagedOriginal {
  const ManagedOriginal(
    this.relativePath,
    this.hash,
    this.size,
    this.originalName,
  );
  final String relativePath;
  final String hash;
  final int size;
  final String originalName;
}

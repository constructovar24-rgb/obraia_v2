import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:sqlite3/sqlite3.dart';
import '../../../core/environment/environment_paths.dart';
import '../../documentos/data/managed_document_store.dart';
import '../domain/backup_manifest.dart';
import 'backup_archive_service.dart';

/// Inventories the immutable originals from the consistent SQLite snapshot,
/// including logically deleted documents retained for history.
class DocumentBackupInventory {
  static List<Map<String, Object?>> rows(String databasePath) {
    final db = sqlite3.open(databasePath, mode: OpenMode.readOnly);
    try {
      if (db.userVersion < 36) return [];
      final rows = db.select(
        'SELECT tenant_id, ruta_gestionada, sha256_original, tamano_bytes, incorporado_utc FROM documentos WHERE ruta_gestionada IS NOT NULL OR sha256_original IS NOT NULL OR incorporado_utc IS NOT NULL',
      );
      for (final row in rows) {
        if (row['ruta_gestionada'] is! String ||
            row['sha256_original'] is! String ||
            row['incorporado_utc'] is! int ||
            row['tamano_bytes'] is! int ||
            (row['tamano_bytes'] as int) < 0 ||
            !ManagedDocumentStore.validPath(
              row['ruta_gestionada'] as String,
              row['tenant_id'] as String,
              row['sha256_original'] as String,
            )) {
          throw const BackupValidationException();
        }
      }
      return rows.map((r) => Map<String, Object?>.from(r)).toList();
    } finally {
      db.close();
    }
  }

  static Future<List<ArchiveFile>> collect(
    String databasePath,
    EnvironmentPaths paths,
  ) async {
    final files = <String, ArchiveFile>{};
    final store = ManagedDocumentStore(paths);
    var totalBytes = 0;
    for (final row in rows(databasePath)) {
      final relative = row['ruta_gestionada'] as String;
      final hash = row['sha256_original'] as String;
      if (!files.containsKey(relative)) {
        totalBytes += row['tamano_bytes'] as int;
        if (totalBytes > BackupArchiveService.maxUncompressedBytes ||
            files.length >= BackupArchiveService.maxEntries - 2) {
          throw const BackupSizeLimitException();
        }
      }
      final file = await store.resolve(
        relative,
        row['tenant_id'] as String,
        hash,
      );
      if (!await file.exists() || await file.length() != row['tamano_bytes']) {
        throw const BackupValidationException();
      }
      final bytes = await file.readAsBytes();
      if (sha256.convert(bytes).toString() != hash) {
        throw const BackupValidationException();
      }
      files[relative] = ArchiveFile.bytes('documents/$relative', bytes);
    }
    return files.values.toList();
  }

  static void validate(String databasePath, BackupManifest manifest) {
    final expected = <String, Map<String, Object?>>{};
    for (final row in rows(databasePath)) {
      final path = 'documents/${row['ruta_gestionada']}';
      if (expected.containsKey(path) &&
          expected[path]!['tamano_bytes'] != row['tamano_bytes']) {
        throw const BackupValidationException();
      }
      expected[path] = row;
    }
    final entries = manifest.entries
        .where((e) => e.path != manifest.databasePath)
        .toList();
    if (!manifest.includesManagedDocuments && expected.isNotEmpty) {
      throw const BackupValidationException();
    }
    if (!manifest.documentPackageComplete) {
      if (entries.isNotEmpty) throw const BackupValidationException();
      return;
    }
    if (entries.length != expected.length) {
      throw const BackupValidationException();
    }
    for (final entry in entries) {
      final row = expected.remove(entry.path);
      if (row == null ||
          entry.type != 'managed-document' ||
          entry.sha256 != row['sha256_original'] ||
          entry.sizeBytes != row['tamano_bytes']) {
        throw const BackupValidationException();
      }
    }
    if (expected.isNotEmpty) throw const BackupValidationException();
  }
}

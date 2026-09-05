import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

import '../../../database/app_database.dart';
import '../domain/backup_manifest.dart';
import 'database_snapshot_service.dart';

class BackupArchiveService {
  BackupArchiveService({DatabaseSnapshotService? snapshotService})
    : _snapshotService = snapshotService ?? const DatabaseSnapshotService();

  static const maxArchiveBytes = 512 * 1024 * 1024;
  static const maxUncompressedBytes = 512 * 1024 * 1024;
  static const maxManifestBytes = 1024 * 1024;
  static const maxEntries = 10;
  static const maxCompressionRatio = 500;

  static const _expectedTables = <String>{
    'tenants',
    'certificaciones',
    'clientes',
    'cobros',
    'compras',
    'documentos',
    'empresa_configuracion',
    'expedientes',
    'factura_lineas',
    'factura_asignaciones_presupuesto',
    'factura_documentos_emitidos',
    'facturas',
    'lineas_presupuesto',
    'presupuestos',
    'proveedores',
    'timeline_events',
    'movimientos_credito_cliente',
    'categorias_economicas',
    'configuracion_economica',
    'linea_presupuesto_costes_previstos',
    'planes_economicos',
    'plan_economico_partidas',
    'hechos_coste',
    'personas_laborales',
    'tarifas_persona',
    'partes_trabajo',
    'compromisos_economicos',
    'aplicaciones_compromiso_coste',
    'estimaciones_coste_restante',
  };

  final DatabaseSnapshotService _snapshotService;
  bool _operationInProgress = false;

  Future<BackupManifest> createBackup({
    required AppDatabase database,
    required String destinationPath,
    required String appVersion,
    required String appBuildNumber,
    DateTime? createdAtUtc,
  }) async {
    if (_operationInProgress) {
      throw const BackupOperationInProgressException();
    }
    _operationInProgress = true;

    Directory? snapshotDirectory;
    Directory? publicationDirectory;
    File? publishedFile;
    try {
      final destination = _validateDestination(destinationPath);
      if (await destination.exists()) {
        throw const BackupDestinationExistsException();
      }
      if (!await destination.parent.exists()) {
        throw const BackupDestinationDirectoryMissingException();
      }

      snapshotDirectory = await Directory.systemTemp.createTemp(
        'obraia-backup-snapshot-',
      );
      final snapshot = File(p.join(snapshotDirectory.path, 'obraia.sqlite'));
      await _snapshotService.createSnapshot(
        database: database,
        destinationPath: snapshot.path,
      );
      validateDatabaseFile(
        snapshot.path,
        maximumSchemaVersion: database.schemaVersion,
        expectedSchemaVersion: database.schemaVersion,
      );

      final databaseBytes = await snapshot.readAsBytes();
      final databaseEntry = BackupManifestEntry(
        path: BackupManifest.defaultDatabasePath,
        type: BackupManifestEntry.sqliteDatabaseType,
        sizeBytes: databaseBytes.length,
        sha256: sha256.convert(databaseBytes).toString(),
      );
      final manifest = BackupManifest(
        createdAtUtc: (createdAtUtc ?? DateTime.now()).toUtc(),
        appVersion: _requiredMetadata(appVersion, 'appVersion'),
        appBuildNumber: _requiredMetadata(appBuildNumber, 'appBuildNumber'),
        schemaVersion: database.schemaVersion,
        databasePath: databaseEntry.path,
        totalUncompressedBytes: databaseEntry.sizeBytes,
        entries: <BackupManifestEntry>[databaseEntry],
      );
      final manifestBytes = utf8.encode(jsonEncode(manifest.toJson()));

      final archive = Archive()
        ..addFile(ArchiveFile.bytes(BackupManifest.manifestPath, manifestBytes))
        ..addFile(ArchiveFile.bytes(databaseEntry.path, databaseBytes));
      final archiveBytes = ZipEncoder().encodeBytes(archive);
      if (archiveBytes.length > maxArchiveBytes) {
        throw const BackupSizeLimitException();
      }

      publicationDirectory = await destination.parent.createTemp(
        '.obraia-backup-',
      );
      final candidate = File(
        p.join(publicationDirectory.path, 'pending.obraia-backup'),
      );
      await candidate.writeAsBytes(archiveBytes, flush: true);
      await validateBackup(
        candidate.path,
        maximumSchemaVersion: database.schemaVersion,
      );

      if (await destination.exists()) {
        throw const BackupDestinationExistsException();
      }
      publishedFile = await candidate.rename(destination.path);
      final publishedManifest = await validateBackup(
        publishedFile.path,
        maximumSchemaVersion: database.schemaVersion,
      );
      return publishedManifest;
    } catch (_) {
      if (publishedFile != null && await publishedFile.exists()) {
        await publishedFile.delete();
      }
      rethrow;
    } finally {
      try {
        await _deleteDirectoryIfPresent(publicationDirectory);
      } finally {
        try {
          await _deleteDirectoryIfPresent(snapshotDirectory);
        } finally {
          _operationInProgress = false;
        }
      }
    }
  }

  Future<BackupManifest> validateBackup(
    String backupPath, {
    required int maximumSchemaVersion,
  }) async {
    try {
      if (backupPath.trim().isEmpty) {
        throw const BackupValidationException();
      }
      final file = File(backupPath);
      if (!await file.exists()) {
        throw const BackupValidationException();
      }
      final archiveLength = await file.length();
      if (archiveLength <= 0 || archiveLength > maxArchiveBytes) {
        throw const BackupSizeLimitException();
      }

      final encounteredPaths = <String>[];
      final archive = ZipDecoder().decodeBytes(
        await file.readAsBytes(),
        verify: true,
        callback: (entry) => encounteredPaths.add(entry.name),
      );
      if (encounteredPaths.length > maxEntries || archive.length > maxEntries) {
        throw const BackupSizeLimitException();
      }
      if (encounteredPaths.toSet().length != encounteredPaths.length) {
        throw const BackupValidationException();
      }

      var totalSize = 0;
      for (final entry in archive) {
        if (!entry.isFile || entry.isSymbolicLink || !_isSafePath(entry.name)) {
          throw const BackupValidationException();
        }
        if (entry.size < 0 || entry.size > maxUncompressedBytes) {
          throw const BackupSizeLimitException();
        }
        totalSize += entry.size;
        if (totalSize > maxUncompressedBytes) {
          throw const BackupSizeLimitException();
        }
      }
      if (archiveLength > 0 &&
          totalSize > archiveLength * maxCompressionRatio) {
        throw const BackupSizeLimitException();
      }

      final manifestFile = archive.findFile(BackupManifest.manifestPath);
      if (manifestFile == null || manifestFile.size > maxManifestBytes) {
        throw const BackupValidationException();
      }
      final manifestBytes = manifestFile.readBytes();
      if (manifestBytes == null) {
        throw const BackupValidationException();
      }
      final manifest = BackupManifest.fromJson(
        jsonDecode(utf8.decode(manifestBytes)),
      );
      if (manifest.schemaVersion > maximumSchemaVersion) {
        throw const BackupSchemaNotSupportedException();
      }
      if (manifest.databasePath != BackupManifest.defaultDatabasePath ||
          manifest.entries.length != 1) {
        throw const BackupValidationException();
      }
      final inventoryEntry = manifest.entries.single;
      if (inventoryEntry.path != manifest.databasePath ||
          inventoryEntry.type != BackupManifestEntry.sqliteDatabaseType) {
        throw const BackupValidationException();
      }

      final expectedArchivePaths = <String>{
        BackupManifest.manifestPath,
        ...manifest.entries.map((entry) => entry.path),
      };
      if (archive.length != expectedArchivePaths.length ||
          !archive.every(
            (entry) => expectedArchivePaths.contains(entry.name),
          )) {
        throw const BackupValidationException();
      }

      final databaseFile = archive.findFile(inventoryEntry.path);
      final databaseBytes = databaseFile?.readBytes();
      if (databaseFile == null ||
          databaseBytes == null ||
          databaseFile.size != inventoryEntry.sizeBytes ||
          databaseBytes.length != inventoryEntry.sizeBytes ||
          sha256.convert(databaseBytes).toString() != inventoryEntry.sha256) {
        throw const BackupValidationException();
      }

      final validationDirectory = await Directory.systemTemp.createTemp(
        'obraia-backup-validation-',
      );
      try {
        final databasePath = p.join(validationDirectory.path, 'obraia.sqlite');
        await File(databasePath).writeAsBytes(databaseBytes, flush: true);
        validateDatabaseFile(
          databasePath,
          maximumSchemaVersion: maximumSchemaVersion,
          expectedSchemaVersion: manifest.schemaVersion,
        );
      } finally {
        await _deleteDirectoryIfPresent(validationDirectory);
      }
      return manifest;
    } on BackupArchiveException {
      rethrow;
    } catch (_) {
      throw const BackupValidationException();
    }
  }

  Future<BackupManifest> extractValidatedDatabase({
    required String backupPath,
    required String destinationPath,
    required int maximumSchemaVersion,
  }) async {
    final destination = _validateDestination(destinationPath);
    if (await destination.exists()) {
      throw const BackupDestinationExistsException();
    }
    if (!await destination.parent.exists()) {
      throw const BackupDestinationDirectoryMissingException();
    }

    Directory? archiveStagingDirectory;
    var destinationCreatedByOperation = false;
    try {
      final source = File(backupPath);
      if (!await source.exists()) {
        throw const BackupValidationException();
      }
      final sourceLength = await source.length();
      if (sourceLength <= 0 || sourceLength > maxArchiveBytes) {
        throw const BackupSizeLimitException();
      }
      final archiveBytes = await source.readAsBytes();
      if (archiveBytes.length != sourceLength ||
          archiveBytes.length > maxArchiveBytes) {
        throw const BackupValidationException();
      }

      archiveStagingDirectory = await Directory.systemTemp.createTemp(
        'obraia-backup-input-',
      );
      final stableArchive = File(
        p.join(archiveStagingDirectory.path, 'input.obraia-backup'),
      );
      await stableArchive.writeAsBytes(archiveBytes, flush: true);
      final manifest = await validateBackup(
        stableArchive.path,
        maximumSchemaVersion: maximumSchemaVersion,
      );
      final archive = ZipDecoder().decodeBytes(archiveBytes);
      final databaseBytes = archive
          .findFile(manifest.databasePath)
          ?.readBytes();
      if (databaseBytes == null) {
        throw const BackupValidationException();
      }
      try {
        await destination.create(exclusive: true);
        destinationCreatedByOperation = true;
      } on FileSystemException {
        if (await destination.exists()) {
          throw const BackupDestinationExistsException();
        }
        rethrow;
      }
      await destination.writeAsBytes(databaseBytes, flush: true);
      validateDatabaseFile(
        destination.path,
        maximumSchemaVersion: maximumSchemaVersion,
        expectedSchemaVersion: manifest.schemaVersion,
      );
      return manifest;
    } catch (_) {
      if (destinationCreatedByOperation && await destination.exists()) {
        await destination.delete();
      }
      rethrow;
    } finally {
      await _deleteDirectoryIfPresent(archiveStagingDirectory);
    }
  }

  File _validateDestination(String destinationPath) {
    if (destinationPath.trim().isEmpty) {
      throw ArgumentError.value(
        destinationPath,
        'destinationPath',
        'La ruta de destino no puede estar vacía.',
      );
    }
    return File(destinationPath);
  }

  String _requiredMetadata(String value, String field) {
    if (value.trim().isEmpty) {
      throw ArgumentError.value(value, field, 'El valor no puede estar vacío.');
    }
    return value;
  }

  bool _isSafePath(String path) {
    if (path.isEmpty || path.contains('\\') || path.startsWith('/')) {
      return false;
    }
    final uri = Uri.tryParse(path);
    if (uri == null || uri.hasScheme) {
      return false;
    }
    final segments = path.split('/');
    return segments.every(
      (segment) => segment.isNotEmpty && segment != '.' && segment != '..',
    );
  }

  void validateDatabaseFile(
    String databasePath, {
    required int maximumSchemaVersion,
    required int expectedSchemaVersion,
  }) {
    Database? database;
    try {
      database = sqlite3.open(databasePath, mode: OpenMode.readOnly);
      final schemaVersion = database.userVersion;
      if (schemaVersion != expectedSchemaVersion) {
        throw const BackupValidationException();
      }
      if (schemaVersion <= 0 || schemaVersion > maximumSchemaVersion) {
        throw const BackupSchemaNotSupportedException();
      }

      final quickCheck = database.select('PRAGMA quick_check;');
      if (quickCheck.length != 1 || quickCheck.first.values.first != 'ok') {
        throw const BackupValidationException();
      }
      if (database.select('PRAGMA foreign_key_check;').isNotEmpty) {
        throw const BackupValidationException();
      }

      final tables = database
          .select('''
            SELECT name FROM sqlite_master
            WHERE type = 'table' AND name NOT LIKE 'sqlite_%'
          ''')
          .map((row) => row['name'])
          .whereType<String>()
          .toSet();
      final expectedTables = _expectedTables.difference({
        if (schemaVersion < 27) ...{
          'compromisos_economicos',
          'aplicaciones_compromiso_coste',
          'estimaciones_coste_restante',
        },
        if (schemaVersion < 26) ...{
          'personas_laborales',
          'tarifas_persona',
          'partes_trabajo',
        },
        if (schemaVersion < 25) 'hechos_coste',
        if (schemaVersion < 24) ...{
          'categorias_economicas',
          'configuracion_economica',
          'linea_presupuesto_costes_previstos',
          'planes_economicos',
          'plan_economico_partidas',
        },
        if (schemaVersion < 23) 'tenants',
        if (schemaVersion < 20) 'factura_asignaciones_presupuesto',
        if (schemaVersion < 21) 'factura_documentos_emitidos',
        if (schemaVersion < 22) 'movimientos_credito_cliente',
      });
      if (!tables.containsAll(expectedTables)) {
        throw const BackupValidationException();
      }
    } on BackupArchiveException {
      rethrow;
    } catch (_) {
      throw const BackupValidationException();
    } finally {
      database?.close();
    }
  }

  Future<void> _deleteDirectoryIfPresent(Directory? directory) async {
    if (directory != null && await directory.exists()) {
      await directory.delete(recursive: true);
    }
  }
}

abstract class BackupArchiveException implements Exception {
  const BackupArchiveException(this.message);

  final String message;

  @override
  String toString() => message;
}

class BackupOperationInProgressException extends BackupArchiveException {
  const BackupOperationInProgressException()
    : super('Ya hay una operación de copia de seguridad en curso.');
}

class BackupDestinationExistsException extends BackupArchiveException {
  const BackupDestinationExistsException()
    : super('Ya existe un archivo en el destino seleccionado.');
}

class BackupDestinationDirectoryMissingException
    extends BackupArchiveException {
  const BackupDestinationDirectoryMissingException()
    : super('La carpeta de destino no está disponible.');
}

class BackupSizeLimitException extends BackupArchiveException {
  const BackupSizeLimitException()
    : super('La copia de seguridad supera los límites admitidos.');
}

class BackupSchemaNotSupportedException extends BackupArchiveException {
  const BackupSchemaNotSupportedException()
    : super('La versión de la copia de seguridad no es compatible.');
}

class BackupValidationException extends BackupArchiveException {
  const BackupValidationException()
    : super('La copia de seguridad no es válida o está dañada.');
}

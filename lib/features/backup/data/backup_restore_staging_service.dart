import 'dart:io';

import 'package:drift/native.dart';
import 'package:path/path.dart' as p;

import '../../../database/app_database.dart';
import '../domain/backup_manifest.dart';
import 'backup_archive_service.dart';

typedef TemporaryDirectoryFactory = Future<Directory> Function();

class BackupRestoreStagingService {
  BackupRestoreStagingService({
    BackupArchiveService? archiveService,
    TemporaryDirectoryFactory? temporaryDirectoryFactory,
  }) : _archiveService = archiveService ?? BackupArchiveService(),
       _temporaryDirectoryFactory =
           temporaryDirectoryFactory ?? _createDefaultTemporaryDirectory;

  static const minimumSupportedSchemaVersion = 16;

  final BackupArchiveService _archiveService;
  final TemporaryDirectoryFactory _temporaryDirectoryFactory;
  bool _operationInProgress = false;

  Future<PreparedRestoreBackup> prepare({
    required String backupPath,
    required int currentSchemaVersion,
  }) async {
    if (_operationInProgress) {
      throw const BackupOperationInProgressException();
    }
    _operationInProgress = true;

    Directory? stagingDirectory;
    var ownershipTransferred = false;
    try {
      stagingDirectory = await _temporaryDirectoryFactory();
      final sourceFile = File(p.join(stagingDirectory.path, 'source.sqlite'));
      final manifest = await _archiveService.extractValidatedDatabase(
        backupPath: backupPath,
        destinationPath: sourceFile.path,
        maximumSchemaVersion: currentSchemaVersion,
      );
      if (manifest.schemaVersion < minimumSupportedSchemaVersion) {
        throw const BackupSchemaNotSupportedException();
      }

      final preparedFile = await sourceFile.copy(
        p.join(stagingDirectory.path, 'prepared.sqlite'),
      );
      if (manifest.schemaVersion < currentSchemaVersion) {
        await _migrateDatabase(preparedFile);
      }
      _archiveService.validateDatabaseFile(
        preparedFile.path,
        maximumSchemaVersion: currentSchemaVersion,
        expectedSchemaVersion: currentSchemaVersion,
      );

      final result = PreparedRestoreBackup._(
        directory: stagingDirectory,
        sourceDatabaseFile: sourceFile,
        preparedDatabaseFile: preparedFile,
        manifest: manifest,
        preparedSchemaVersion: currentSchemaVersion,
      );
      ownershipTransferred = true;
      return result;
    } finally {
      try {
        if (!ownershipTransferred &&
            stagingDirectory != null &&
            await stagingDirectory.exists()) {
          await stagingDirectory.delete(recursive: true);
        }
      } finally {
        _operationInProgress = false;
      }
    }
  }

  Future<void> _migrateDatabase(File databaseFile) async {
    final database = AppDatabase.forTesting(NativeDatabase(databaseFile));
    try {
      await database.customSelect('SELECT 1;').getSingle();
    } catch (_) {
      throw const BackupMigrationException();
    } finally {
      await database.close();
    }
  }
}

class PreparedRestoreBackup {
  PreparedRestoreBackup._({
    required this.directory,
    required this.sourceDatabaseFile,
    required this.preparedDatabaseFile,
    required this.manifest,
    required this.preparedSchemaVersion,
  });

  final Directory directory;
  final File sourceDatabaseFile;
  final File preparedDatabaseFile;
  final BackupManifest manifest;
  final int preparedSchemaVersion;
  bool _disposed = false;

  bool get wasMigrated => manifest.schemaVersion != preparedSchemaVersion;

  Future<void> dispose() async {
    if (_disposed) {
      return;
    }
    if (await directory.exists()) {
      await directory.delete(recursive: true);
    }
    _disposed = true;
  }
}

class BackupMigrationException extends BackupArchiveException {
  const BackupMigrationException()
    : super('No se pudo preparar la copia para la versión actual.');
}

Future<Directory> _createDefaultTemporaryDirectory() {
  return Directory.systemTemp.createTemp('obraia-restore-staging-');
}

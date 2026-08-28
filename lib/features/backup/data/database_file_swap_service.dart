import 'dart:io';

import 'package:path/path.dart' as p;

import 'backup_archive_service.dart';

typedef DatabaseLifecycleAction = Future<void> Function();
typedef DatabaseSwapFailureHook =
    Future<void> Function(DatabaseSwapStage stage);

enum DatabaseSwapStage {
  incomingValidated,
  activeDatabaseClosed,
  activeFilesMoved,
  incomingActivated,
  replacementValidated,
}

class DatabaseFileSwapService {
  DatabaseFileSwapService({BackupArchiveService? archiveService})
    : _archiveService = archiveService ?? BackupArchiveService();

  final BackupArchiveService _archiveService;
  bool _operationInProgress = false;

  Future<DatabaseSwapResult> replace({
    required String activeDatabasePath,
    required String preparedDatabasePath,
    required int currentSchemaVersion,
    required DatabaseLifecycleAction closeActiveDatabase,
    required DatabaseLifecycleAction openAndValidateActiveDatabase,
    DatabaseSwapFailureHook? failureHook,
  }) async {
    if (_operationInProgress) {
      throw const BackupOperationInProgressException();
    }
    _operationInProgress = true;

    Directory? exchangeDirectory;
    var activeDatabaseClosed = false;
    var incomingActivated = false;
    var succeeded = false;
    var rollbackFailed = false;
    final movedActiveFiles = <_MovedDatabaseFile>[];
    try {
      final activeDatabase = _requiredExistingFile(activeDatabasePath);
      final preparedDatabase = _requiredExistingFile(preparedDatabasePath);
      if (p.equals(activeDatabase.path, preparedDatabase.path)) {
        throw const DatabaseSwapValidationException();
      }

      _archiveService.validateDatabaseFile(
        preparedDatabase.path,
        maximumSchemaVersion: currentSchemaVersion,
        expectedSchemaVersion: currentSchemaVersion,
      );
      exchangeDirectory = await activeDatabase.parent.createTemp(
        '.obraia-database-swap-',
      );
      final incoming = await preparedDatabase.copy(
        p.join(exchangeDirectory.path, 'incoming.sqlite'),
      );
      _archiveService.validateDatabaseFile(
        incoming.path,
        maximumSchemaVersion: currentSchemaVersion,
        expectedSchemaVersion: currentSchemaVersion,
      );
      await failureHook?.call(DatabaseSwapStage.incomingValidated);

      activeDatabaseClosed = true;
      await closeActiveDatabase();
      await failureHook?.call(DatabaseSwapStage.activeDatabaseClosed);

      for (final source in _activeDatabaseFiles(activeDatabase)) {
        if (!await source.file.exists()) {
          continue;
        }
        final rollbackFile = File(
          p.join(exchangeDirectory.path, source.rollbackName),
        );
        await source.file.rename(rollbackFile.path);
        movedActiveFiles.add(
          _MovedDatabaseFile(
            originalPath: source.file.path,
            rollbackFile: rollbackFile,
          ),
        );
      }
      if (!movedActiveFiles.any(
        (moved) => p.equals(moved.originalPath, activeDatabase.path),
      )) {
        throw const DatabaseSwapValidationException();
      }
      await failureHook?.call(DatabaseSwapStage.activeFilesMoved);

      await incoming.rename(activeDatabase.path);
      incomingActivated = true;
      await failureHook?.call(DatabaseSwapStage.incomingActivated);

      await openAndValidateActiveDatabase();
      await failureHook?.call(DatabaseSwapStage.replacementValidated);
      succeeded = true;
      return DatabaseSwapResult._(
        rollbackDirectory: exchangeDirectory,
        activeDatabasePath: activeDatabase.path,
        rollbackFiles: movedActiveFiles
            .map((moved) => moved.rollbackFile)
            .toList(growable: false),
      );
    } catch (_) {
      if (activeDatabaseClosed) {
        try {
          await _rollback(
            activeDatabasePath: activeDatabasePath,
            incomingActivated: incomingActivated,
            movedActiveFiles: movedActiveFiles,
            closeActiveDatabase: closeActiveDatabase,
            openAndValidateActiveDatabase: openAndValidateActiveDatabase,
            exchangeDirectory: exchangeDirectory,
          );
        } catch (_) {
          rollbackFailed = true;
          throw const DatabaseRollbackFailedException();
        }
      }
      rethrow;
    } finally {
      try {
        if (!succeeded &&
            !rollbackFailed &&
            exchangeDirectory != null &&
            await exchangeDirectory.exists()) {
          await exchangeDirectory.delete(recursive: true);
        }
      } finally {
        _operationInProgress = false;
      }
    }
  }

  Future<void> _rollback({
    required String activeDatabasePath,
    required bool incomingActivated,
    required List<_MovedDatabaseFile> movedActiveFiles,
    required DatabaseLifecycleAction closeActiveDatabase,
    required DatabaseLifecycleAction openAndValidateActiveDatabase,
    required Directory? exchangeDirectory,
  }) async {
    await closeActiveDatabase();

    if (incomingActivated) {
      final failedActive = File(activeDatabasePath);
      if (await failedActive.exists()) {
        if (exchangeDirectory == null) {
          throw const DatabaseRollbackFailedException();
        }
        await failedActive.rename(
          p.join(exchangeDirectory.path, 'failed-incoming.sqlite'),
        );
      }
    }

    for (final moved in movedActiveFiles.reversed) {
      if (await File(moved.originalPath).exists() ||
          !await moved.rollbackFile.exists()) {
        throw const DatabaseRollbackFailedException();
      }
      await moved.rollbackFile.rename(moved.originalPath);
    }
    await openAndValidateActiveDatabase();
  }

  File _requiredExistingFile(String path) {
    if (path.trim().isEmpty || !File(path).existsSync()) {
      throw const DatabaseSwapValidationException();
    }
    return File(path);
  }

  List<_ActiveDatabaseFile> _activeDatabaseFiles(
    File database,
  ) => <_ActiveDatabaseFile>[
    _ActiveDatabaseFile(database, 'rollback.sqlite'),
    _ActiveDatabaseFile(File('${database.path}-wal'), 'rollback.sqlite-wal'),
    _ActiveDatabaseFile(File('${database.path}-shm'), 'rollback.sqlite-shm'),
  ];
}

class DatabaseSwapResult {
  DatabaseSwapResult._({
    required this.rollbackDirectory,
    required this.activeDatabasePath,
    required this.rollbackFiles,
  });

  final Directory rollbackDirectory;
  final String activeDatabasePath;
  final List<File> rollbackFiles;
}

class DatabaseSwapValidationException extends BackupArchiveException {
  const DatabaseSwapValidationException()
    : super('No se puede preparar el intercambio de la base de datos.');
}

class DatabaseRollbackFailedException extends BackupArchiveException {
  const DatabaseRollbackFailedException()
    : super('No se pudo recuperar la base de datos anterior.');
}

class _ActiveDatabaseFile {
  const _ActiveDatabaseFile(this.file, this.rollbackName);

  final File file;
  final String rollbackName;
}

class _MovedDatabaseFile {
  const _MovedDatabaseFile({
    required this.originalPath,
    required this.rollbackFile,
  });

  final String originalPath;
  final File rollbackFile;
}

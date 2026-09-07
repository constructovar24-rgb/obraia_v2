import 'package:sqlite3/sqlite3.dart';
import '../../../core/environment/environment_paths.dart';
import 'backup_archive_service.dart';
import 'document_restore_swap.dart';
import 'dart:io';

import '../../../database/database_lifecycle_controller.dart';
import '../../../database/app_database.dart';
import '../domain/backup_manifest.dart';
import 'backup_restore_staging_service.dart';
import 'database_file_swap_service.dart';
import 'recovery_backup_service.dart';

/// Coordinates the existing restore pieces under the single database owner.
/// It contains no UI concerns and is safe to exercise with temporary files.
class BackupRestoreCoordinator {
  BackupRestoreCoordinator({
    required this.databaseLifecycle,
    BackupRestoreStagingService? stagingService,
    RecoveryBackupService? recoveryBackupService,
    DatabaseFileSwapService? fileSwapService,
    this.swapFailureHook,
    this.documentPaths,
  }) : _stagingService = stagingService ?? BackupRestoreStagingService(),
       _recoveryBackupService =
           recoveryBackupService ??
           RecoveryBackupService(
             archiveService: BackupArchiveService(documentPaths: documentPaths),
           ),
       _fileSwapService = fileSwapService ?? DatabaseFileSwapService();

  final EnvironmentPaths? documentPaths;
  final DatabaseLifecycleController databaseLifecycle;
  final BackupRestoreStagingService _stagingService;
  final RecoveryBackupService _recoveryBackupService;
  final DatabaseFileSwapService _fileSwapService;
  final DatabaseSwapFailureHook? swapFailureHook;

  Future<BackupRestoreResult> restore({
    required String backupPath,
    AppDatabase? expectedDatabase,
    required Directory recoveryDirectory,
    required String appVersion,
    required String appBuildNumber,
  }) {
    return databaseLifecycle.runExclusiveMaintenance(() async {
      PreparedRestoreBackup? prepared;
      try {
        final activeDatabase = databaseLifecycle.activeDatabase;
        if (expectedDatabase != null &&
            !identical(expectedDatabase, activeDatabase)) {
          throw StateError("La sesión de restauración ya no está activa.");
        }
        final activeDatabasePath = await databaseLifecycle.activeDatabasePath;

        prepared = await _stagingService.prepare(
          backupPath: backupPath,
          currentSchemaVersion: activeDatabase.schemaVersion,
        );
        if (!prepared.manifest.documentPackageComplete) {
          throw const BackupValidationException();
        }
        if (prepared.manifest.environment != activeDatabase.environment) {
          throw const BackupEnvironmentMismatchException();
        }
        final incomingDb = sqlite3.open(
          prepared.preparedDatabaseFile.path,
          mode: OpenMode.readOnly,
        );
        try {
          final incomingTenants = incomingDb
              .select('SELECT id FROM tenants')
              .map((r) => r['id'])
              .toSet();
          final activeTenants =
              (await activeDatabase
                      .customSelect('SELECT id FROM tenants')
                      .get())
                  .map((r) => r.read<String>('id'))
                  .toSet();
          if (incomingTenants.length != activeTenants.length ||
              !incomingTenants.containsAll(activeTenants)) {
            throw StateError(
              'La copia pertenece a otra empresa. Restauración bloqueada.',
            );
          }
        } finally {
          incomingDb.close();
        }
        DocumentRestoreSwap? documents;
        if (prepared.manifest.entries.any(
          (e) => e.type == 'managed-document',
        )) {
          final paths =
              documentPaths ??
              await EnvironmentPaths.resolve(activeDatabase.environment);
          if (paths.environment != activeDatabase.environment) {
            throw const BackupEnvironmentMismatchException();
          }
          documents = DocumentRestoreSwap(
            paths,
            prepared.documentsDirectory,
            prepared.manifest,
          );
        }
        final recoveryBackup = await _recoveryBackupService.create(
          database: activeDatabase,
          recoveryDirectory: recoveryDirectory,
          appVersion: appVersion,
          appBuildNumber: appBuildNumber,
        );

        final swapResult = await _fileSwapService.replace(
          activeDatabasePath: activeDatabasePath,
          preparedDatabasePath: prepared.preparedDatabaseFile.path,
          currentSchemaVersion: activeDatabase.schemaVersion,
          closeActiveDatabase: databaseLifecycle.closeActiveDatabase,
          openAndValidateActiveDatabase:
              databaseLifecycle.openAndPublishActiveDatabase,
          failureHook: swapFailureHook,
          activateRelatedFiles: documents?.activate,
          rollbackRelatedFiles: documents?.rollback,
        );
        return BackupRestoreResult(
          incomingManifest: prepared.manifest,
          recoveryBackup: recoveryBackup,
          swapResult: swapResult,
        );
      } finally {
        await prepared?.dispose();
      }
    });
  }
}

class BackupRestoreResult {
  const BackupRestoreResult({
    required this.incomingManifest,
    required this.recoveryBackup,
    required this.swapResult,
  });

  final BackupManifest incomingManifest;
  final RecoveryBackupResult recoveryBackup;
  final DatabaseSwapResult swapResult;
}

class BackupEnvironmentMismatchException implements Exception {
  const BackupEnvironmentMismatchException();
  @override
  String toString() =>
      'La copia pertenece a otro entorno. Restauración bloqueada.';
}

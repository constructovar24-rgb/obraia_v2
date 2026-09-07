import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import '../../../../core/environment/environment_paths.dart';

import '../../../../database/app_database.dart';
import '../../data/automatic_backup_service.dart';
import '../../data/backup_archive_service.dart';
import '../../data/backup_restore_coordinator.dart';

class BackupController extends ChangeNotifier {
  BackupController(this._database, this._restore, {this.paths});
  final EnvironmentPaths? paths;
  final AppDatabase _database;
  final BackupRestoreCoordinator _restore;
  bool busy = false;
  String? lastBackupPath;
  String? automaticBackupError;
  bool _disposed = false;

  void _requireCurrentDatabase() {
    if (_disposed ||
        !identical(_database, _restore.databaseLifecycle.activeDatabase)) {
      throw StateError("La sesión de la copia ya no está activa.");
    }
  }

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  Future<Directory> _root(String name) async {
    final resolvedPaths =
        paths ?? await EnvironmentPaths.resolve(_database.environment);
    return Directory(p.join(resolvedPaths.backupDirectory.path, name));
  }

  Future<File>
  createManual() => _restore.databaseLifecycle.runExclusiveMaintenance(() async {
    _requireCurrentDatabase();
    busy = true;
    notifyListeners();
    try {
      final dir = await _root('manuales');
      await dir.create(recursive: true);
      final file = File(
        p.join(
          dir.path,
          'obraia-${DateTime.now().toUtc().millisecondsSinceEpoch}.obraia-backup',
        ),
      );
      await BackupArchiveService(documentPaths: paths).createBackup(
        database: _database,
        destinationPath: file.path,
        appVersion: '1.0.0',
        appBuildNumber: '1',
      );
      lastBackupPath = file.path;
      return file;
    } finally {
      busy = false;
      notifyListeners();
    }
  });

  Future<String> describeBackup(String path) async {
    final manifest = await BackupArchiveService().validateBackup(
      path,
      maximumSchemaVersion: _database.schemaVersion,
    );
    if (!manifest.documentPackageComplete) {
      throw const BackupValidationException();
    }
    return manifest.includesManagedDocuments
        ? 'Incluye la base de datos, los PDF congelados y ${manifest.entries.where((e) => e.type == "managed-document").length} archivos gestionados. No incluye archivos externos.'
        : 'Copia antigua: incluye solo la base de datos y los PDF conservados dentro de ella. No contiene un paquete de archivos externos.';
  }

  Future<void> restore(String path) async {
    _requireCurrentDatabase();
    busy = true;
    notifyListeners();
    try {
      await _restore.restore(
        backupPath: path,
        expectedDatabase: _database,
        recoveryDirectory: await _root('recuperacion'),
        appVersion: '1.0.0',
        appBuildNumber: '1',
      );
    } finally {
      busy = false;
      notifyListeners();
    }
  }

  Future<void> checkDaily() async {
    try {
      await _restore.databaseLifecycle.runExclusiveMaintenance(() async {
        _requireCurrentDatabase();
        await AutomaticBackupService(
          archiveService: BackupArchiveService(documentPaths: paths),
        ).createIfNeeded(
          database: _database,
          directory: await _root('automaticas'),
          appVersion: '1.0.0',
          appBuildNumber: '1',
        );
      });
    } catch (_) {
      automaticBackupError =
          'La copia automática no se pudo completar. Crea una copia manual y revisa los archivos si vuelve a fallar.';
      notifyListeners();
    }
  }
}

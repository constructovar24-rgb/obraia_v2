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
      await BackupArchiveService().createBackup(
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
        await AutomaticBackupService().createIfNeeded(
          database: _database,
          directory: await _root('automaticas'),
          appVersion: '1.0.0',
          appBuildNumber: '1',
        );
      });
    } catch (_) {}
  }
}

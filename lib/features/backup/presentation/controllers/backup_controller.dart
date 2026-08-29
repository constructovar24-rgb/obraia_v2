import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../../database/app_database.dart';
import '../../data/automatic_backup_service.dart';
import '../../data/backup_archive_service.dart';
import '../../data/backup_restore_coordinator.dart';

class BackupController extends ChangeNotifier {
  BackupController(this._database, this._restore);
  final AppDatabase _database;
  final BackupRestoreCoordinator _restore;
  bool busy = false;
  String? lastBackupPath;

  Future<Directory> _root(String name) async {
    final documents = await getApplicationDocumentsDirectory();
    return Directory(p.join(documents.path, 'copias_seguridad', name));
  }

  Future<File> createManual() async {
    busy = true;
    notifyListeners();
    try {
      final dir = await _root('manuales')
        ..create(recursive: true);
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
  }

  Future<void> restore(String path) async {
    busy = true;
    notifyListeners();
    try {
      await _restore.restore(
        backupPath: path,
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
      await AutomaticBackupService().createIfNeeded(
        database: _database,
        directory: await _root('automaticas'),
        appVersion: '1.0.0',
        appBuildNumber: '1',
      );
    } catch (_) {}
  }
}

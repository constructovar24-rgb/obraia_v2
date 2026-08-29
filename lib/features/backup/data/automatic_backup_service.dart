import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

import '../../../database/app_database.dart';
import 'backup_archive_service.dart';

class AutomaticBackupService {
  AutomaticBackupService({BackupArchiveService? archiveService})
    : _archiveService = archiveService ?? BackupArchiveService();

  static const retainedBackupCount = 7;
  final BackupArchiveService _archiveService;
  bool _inProgress = false;

  Future<AutomaticBackupResult> createIfNeeded({
    required AppDatabase database,
    required Directory directory,
    required String appVersion,
    required String appBuildNumber,
    DateTime? now,
  }) async {
    if (_inProgress) throw const BackupOperationInProgressException();
    _inProgress = true;
    try {
      await directory.create(recursive: true);
      final date = (now ?? DateTime.now()).toLocal();
      final marker = File(
        p.join(directory.path, '.automatic-backup-state.json'),
      );
      final day =
          '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      if (await marker.exists() &&
          (jsonDecode(await marker.readAsString())
                  as Map<String, dynamic>)['day'] ==
              day) {
        return const AutomaticBackupResult.skipped();
      }
      final file = File(
        p.join(
          directory.path,
          'obraia-auto-$day-${const Uuid().v4()}.obraia-backup',
        ),
      );
      await _archiveService.createBackup(
        database: database,
        destinationPath: file.path,
        appVersion: appVersion,
        appBuildNumber: appBuildNumber,
      );
      await marker.writeAsString(jsonEncode({'day': day}), flush: true);
      final files =
          directory
              .listSync()
              .whereType<File>()
              .where(
                (f) =>
                    p.basename(f.path).startsWith('obraia-auto-') &&
                    f.path.endsWith('.obraia-backup'),
              )
              .toList()
            ..sort((a, b) => p.basename(b.path).compareTo(p.basename(a.path)));
      for (final old in files.skip(retainedBackupCount)) {
        await old.delete();
      }
      return AutomaticBackupResult.created(file);
    } finally {
      _inProgress = false;
    }
  }
}

class AutomaticBackupResult {
  const AutomaticBackupResult.skipped() : file = null;
  const AutomaticBackupResult.created(File this.file);
  final File? file;
  bool get wasCreated => file != null;
}

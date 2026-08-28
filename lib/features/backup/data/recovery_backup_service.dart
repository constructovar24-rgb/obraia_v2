import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

import '../../../database/app_database.dart';
import '../domain/backup_manifest.dart';
import 'backup_archive_service.dart';

typedef RecoveryBackupIdFactory = String Function();

class RecoveryBackupService {
  RecoveryBackupService({
    BackupArchiveService? archiveService,
    RecoveryBackupIdFactory? idFactory,
  }) : _archiveService = archiveService ?? BackupArchiveService(),
       _idFactory = idFactory ?? const Uuid().v4;

  static const retainedBackupCount = 3;
  static final _managedFilenamePattern = RegExp(
    r'^obraia-recovery-\d{8}T\d{9}Z-'
    r'[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-'
    r'[89ab][0-9a-f]{3}-[0-9a-f]{12}\.obraia-backup$',
  );
  static final _identifierPattern = RegExp(
    r'^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-'
    r'[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
  );

  final BackupArchiveService _archiveService;
  final RecoveryBackupIdFactory _idFactory;
  bool _operationInProgress = false;

  Future<RecoveryBackupResult> create({
    required AppDatabase database,
    required Directory recoveryDirectory,
    required String appVersion,
    required String appBuildNumber,
    DateTime? createdAtUtc,
  }) async {
    if (_operationInProgress) {
      throw const BackupOperationInProgressException();
    }
    _operationInProgress = true;
    try {
      if (!await recoveryDirectory.exists()) {
        await recoveryDirectory.create(recursive: true);
      }
      final timestamp = (createdAtUtc ?? DateTime.now()).toUtc();
      final identifier = _idFactory();
      if (!_identifierPattern.hasMatch(identifier)) {
        throw const RecoveryBackupConfigurationException();
      }
      final destination = File(
        p.join(
          recoveryDirectory.path,
          'obraia-recovery-${_formatTimestamp(timestamp)}-$identifier.obraia-backup',
        ),
      );
      final manifest = await _archiveService.createBackup(
        database: database,
        destinationPath: destination.path,
        appVersion: appVersion,
        appBuildNumber: appBuildNumber,
        createdAtUtc: timestamp,
      );
      await _archiveService.validateBackup(
        destination.path,
        maximumSchemaVersion: database.schemaVersion,
      );
      final removedBackups = await _enforceRetention(recoveryDirectory);
      return RecoveryBackupResult(
        file: destination,
        manifest: manifest,
        removedBackupCount: removedBackups,
      );
    } finally {
      _operationInProgress = false;
    }
  }

  Future<int> _enforceRetention(Directory directory) async {
    final candidates = <File>[];
    await for (final entity in directory.list(followLinks: false)) {
      if (entity is File &&
          _managedFilenamePattern.hasMatch(p.basename(entity.path))) {
        candidates.add(entity);
      }
    }
    if (candidates.length <= retainedBackupCount) {
      return 0;
    }

    candidates.sort(
      (left, right) => p.basename(right.path).compareTo(p.basename(left.path)),
    );

    var removed = 0;
    for (final candidate in candidates.skip(retainedBackupCount)) {
      await candidate.delete();
      removed++;
    }
    return removed;
  }

  String _formatTimestamp(DateTime value) {
    String twoDigits(int number) => number.toString().padLeft(2, '0');
    String threeDigits(int number) => number.toString().padLeft(3, '0');

    final utc = value.toUtc();
    return '${utc.year.toString().padLeft(4, '0')}'
        '${twoDigits(utc.month)}'
        '${twoDigits(utc.day)}T'
        '${twoDigits(utc.hour)}'
        '${twoDigits(utc.minute)}'
        '${twoDigits(utc.second)}'
        '${threeDigits(utc.millisecond)}Z';
  }
}

class RecoveryBackupResult {
  const RecoveryBackupResult({
    required this.file,
    required this.manifest,
    required this.removedBackupCount,
  });

  final File file;
  final BackupManifest manifest;
  final int removedBackupCount;
}

class RecoveryBackupConfigurationException extends BackupArchiveException {
  const RecoveryBackupConfigurationException()
    : super('No se pudo configurar la copia automática de recuperación.');
}

import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

class PreMigrationRecoveryService {
  const PreMigrationRecoveryService();

  Future<File?> protectV22(File source) =>
      protectBeforeUpgrade(source, supportedVersions: const {22});

  Future<File?> protectBeforeUpgrade(
    File source, {
    Set<int> supportedVersions = const {22, 23, 24, 25, 26, 27},
  }) async {
    if (!await source.exists()) return null;

    Database? database;
    try {
      database = sqlite3.open(source.path, mode: OpenMode.readOnly);
      final version = database.userVersion;
      if (!supportedVersions.contains(version)) return null;
      _validate(database, expectedVersion: version);

      final recoveryDirectory = Directory(
        p.join(source.parent.path, 'migration-recovery'),
      );
      await recoveryDirectory.create(recursive: true);
      final stamp = DateTime.now().toUtc().microsecondsSinceEpoch;
      final recovery = File(
        p.join(recoveryDirectory.path, 'obraia-v$version-$stamp.sqlite'),
      );
      database.execute('VACUUM INTO ?', [recovery.path]);

      final recovered = sqlite3.open(recovery.path, mode: OpenMode.readOnly);
      try {
        _validate(recovered, expectedVersion: version);
      } finally {
        recovered.close();
      }
      return recovery;
    } finally {
      database?.close();
    }
  }

  void _validate(Database database, {required int expectedVersion}) {
    if (database.userVersion != expectedVersion) {
      throw const PreMigrationRecoveryException();
    }
    final integrity = database.select('PRAGMA integrity_check');
    if (integrity.length != 1 || integrity.first.values.first != 'ok') {
      throw const PreMigrationRecoveryException();
    }
    if (database.select('PRAGMA foreign_key_check').isNotEmpty) {
      throw const PreMigrationRecoveryException();
    }
  }
}

class PreMigrationRecoveryException implements Exception {
  const PreMigrationRecoveryException();
}

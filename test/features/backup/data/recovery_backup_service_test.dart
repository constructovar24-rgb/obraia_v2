import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/features/backup/data/backup_archive_service.dart';
import 'package:obraia_v2/features/backup/data/recovery_backup_service.dart';
import 'package:path/path.dart' as p;

void main() {
  late Directory temporaryDirectory;
  late Directory recoveryDirectory;
  late AppDatabase database;
  late int idSequence;
  late RecoveryBackupService service;

  setUp(() async {
    temporaryDirectory = await Directory.systemTemp.createTemp(
      'obraia recovery backup test ',
    );
    recoveryDirectory = Directory(
      p.join(temporaryDirectory.path, 'recovery backups'),
    );
    database = AppDatabase.forTesting(
      NativeDatabase(File(p.join(temporaryDirectory.path, 'source.sqlite'))),
    );
    await database.clientesDao.insertarCliente(
      ClientesCompanion.insert(id: 'cliente-1', nombre: 'Cliente protegido'),
    );
    idSequence = 0;
    service = RecoveryBackupService(
      idFactory: () {
        idSequence++;
        return '00000000-0000-4000-8000-${idSequence.toString().padLeft(12, '0')}';
      },
    );
  });

  tearDown(() async {
    await database.close();
    if (await temporaryDirectory.exists()) {
      await temporaryDirectory.delete(recursive: true);
    }
  });

  test('crea y valida una copia automática en una carpeta nueva', () async {
    final createdAt = DateTime.utc(2026, 8, 28, 15, 4, 5, 6);

    final result = await service.create(
      database: database,
      recoveryDirectory: recoveryDirectory,
      appVersion: '1.0.0',
      appBuildNumber: '1',
      createdAtUtc: createdAt,
    );

    expect(await recoveryDirectory.exists(), isTrue);
    expect(await result.file.exists(), isTrue);
    expect(
      p.basename(result.file.path),
      'obraia-recovery-20260828T150405006Z-00000000-0000-4000-8000-000000000001.obraia-backup',
    );
    expect(result.manifest.createdAtUtc, createdAt);
    expect(result.removedBackupCount, 0);

    final validated = await BackupArchiveService().validateBackup(
      result.file.path,
      maximumSchemaVersion: database.schemaVersion,
    );
    expect(validated.schemaVersion, database.schemaVersion);
  });

  test('conserva solo las tres copias automáticas más recientes', () async {
    for (var index = 0; index < 5; index++) {
      await service.create(
        database: database,
        recoveryDirectory: recoveryDirectory,
        appVersion: '1.0.0',
        appBuildNumber: '1',
        createdAtUtc: DateTime.utc(2026, 8, 28, 15, 0, index),
      );
    }

    final files =
        recoveryDirectory
            .listSync()
            .whereType<File>()
            .map((file) => p.basename(file.path))
            .toList()
          ..sort();
    expect(files, hasLength(3));
    expect(files, everyElement(startsWith('obraia-recovery-')));
    expect(files.any((name) => name.contains('T150000000Z')), isFalse);
    expect(files.any((name) => name.contains('T150001000Z')), isFalse);
    expect(files.any((name) => name.contains('T150004000Z')), isTrue);
  });

  test('nunca elimina archivos manuales o ajenos', () async {
    await recoveryDirectory.create(recursive: true);
    final manualBackup = File(
      p.join(recoveryDirectory.path, 'mi-copia-manual.obraia-backup'),
    );
    final unrelatedFile = File(p.join(recoveryDirectory.path, 'notas.txt'));
    await manualBackup.writeAsBytes(<int>[1], flush: true);
    await unrelatedFile.writeAsString('conservar', flush: true);

    for (var index = 0; index < 4; index++) {
      await service.create(
        database: database,
        recoveryDirectory: recoveryDirectory,
        appVersion: '1.0.0',
        appBuildNumber: '1',
        createdAtUtc: DateTime.utc(2026, 8, 28, 16, 0, index),
      );
    }

    expect(await manualBackup.readAsBytes(), <int>[1]);
    expect(await unrelatedFile.readAsString(), 'conservar');
  });

  test('rechaza un identificador inseguro sin crear la copia', () async {
    final invalidService = RecoveryBackupService(idFactory: () => '../fuera');

    await expectLater(
      invalidService.create(
        database: database,
        recoveryDirectory: recoveryDirectory,
        appVersion: '1.0.0',
        appBuildNumber: '1',
      ),
      throwsA(isA<RecoveryBackupConfigurationException>()),
    );

    expect(recoveryDirectory.listSync(), isEmpty);
  });
}

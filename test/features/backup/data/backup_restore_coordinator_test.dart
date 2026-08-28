import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/database/database_lifecycle_controller.dart';
import 'package:obraia_v2/features/backup/data/backup_archive_service.dart';
import 'package:obraia_v2/features/backup/data/backup_restore_coordinator.dart';
import 'package:obraia_v2/features/backup/data/database_file_swap_service.dart';
import 'package:path/path.dart' as p;

void main() {
  late Directory temporaryDirectory;
  late File activeFile;
  late AppDatabase initialDatabase;
  late DatabaseLifecycleController lifecycle;
  late BackupRestoreCoordinator coordinator;
  late File incomingBackup;

  setUp(() async {
    temporaryDirectory = await Directory.systemTemp.createTemp(
      'obraia restore coordinator test ',
    );
    activeFile = File(p.join(temporaryDirectory.path, 'obraia.sqlite'));
    initialDatabase = AppDatabase.forTesting(NativeDatabase(activeFile));
    await _insertClient(initialDatabase, 'Datos anteriores');
    lifecycle = DatabaseLifecycleController(
      initialDatabase: initialDatabase,
      databaseFactory: () => AppDatabase.forTesting(NativeDatabase(activeFile)),
      activeDatabasePathResolver: () async => activeFile.path,
    );
    incomingBackup = await _createBackup(
      temporaryDirectory,
      'Datos restaurados',
    );
    coordinator = BackupRestoreCoordinator(databaseLifecycle: lifecycle);
  });

  tearDown(() async {
    await lifecycle.close();
    if (await temporaryDirectory.exists()) {
      await temporaryDirectory.delete(recursive: true);
    }
  });

  test('restaura, publica una nueva base y conserva la recuperación', () async {
    var publications = 0;
    lifecycle.addListener(() => publications++);

    final result = await coordinator.restore(
      backupPath: incomingBackup.path,
      recoveryDirectory: Directory(p.join(temporaryDirectory.path, 'recovery')),
      appVersion: '1.0.0',
      appBuildNumber: '1',
    );

    expect(identical(lifecycle.activeDatabase, initialDatabase), isFalse);
    expect(await _clientName(lifecycle.activeDatabase), 'Datos restaurados');
    expect(publications, 1);
    expect(await result.recoveryBackup.file.exists(), isTrue);
    expect(await result.swapResult.rollbackDirectory.exists(), isTrue);
  });

  test('un fallo antes del intercambio conserva la base abierta', () async {
    await expectLater(
      coordinator.restore(
        backupPath: p.join(temporaryDirectory.path, 'ausente.obraia-backup'),
        recoveryDirectory: Directory(
          p.join(temporaryDirectory.path, 'recovery'),
        ),
        appVersion: '1.0.0',
        appBuildNumber: '1',
      ),
      throwsA(anything),
    );

    expect(identical(lifecycle.activeDatabase, initialDatabase), isTrue);
    expect(await _clientName(lifecycle.activeDatabase), 'Datos anteriores');
  });

  test(
    'un fallo posterior al intercambio recupera y publica la anterior',
    () async {
      coordinator = BackupRestoreCoordinator(
        databaseLifecycle: lifecycle,
        swapFailureHook: (stage) async {
          if (stage == DatabaseSwapStage.incomingActivated) {
            throw const _InjectedFailure();
          }
        },
      );

      await expectLater(
        coordinator.restore(
          backupPath: incomingBackup.path,
          recoveryDirectory: Directory(
            p.join(temporaryDirectory.path, 'recovery'),
          ),
          appVersion: '1.0.0',
          appBuildNumber: '1',
        ),
        throwsA(isA<_InjectedFailure>()),
      );

      expect(await _clientName(lifecycle.activeDatabase), 'Datos anteriores');
      expect(lifecycle.generation, 1);
    },
  );

  test(
    'bloquea una segunda restauración mientras la primera está activa',
    () async {
      final first = coordinator.restore(
        backupPath: incomingBackup.path,
        recoveryDirectory: Directory(
          p.join(temporaryDirectory.path, 'recovery'),
        ),
        appVersion: '1.0.0',
        appBuildNumber: '1',
      );

      await expectLater(
        coordinator.restore(
          backupPath: incomingBackup.path,
          recoveryDirectory: Directory(
            p.join(temporaryDirectory.path, 'recovery'),
          ),
          appVersion: '1.0.0',
          appBuildNumber: '1',
        ),
        throwsA(isA<DatabaseMaintenanceInProgressException>()),
      );
      await first;
    },
  );
}

Future<void> _insertClient(AppDatabase database, String name) {
  return database.clientesDao.insertarCliente(
    ClientesCompanion.insert(id: 'cliente-1', nombre: name),
  );
}

Future<String> _clientName(AppDatabase database) async {
  return (await database.clientesDao.observarClientes().first).single.nombre;
}

Future<File> _createBackup(Directory root, String clientName) async {
  final source = File(p.join(root.path, 'incoming.sqlite'));
  final database = AppDatabase.forTesting(NativeDatabase(source));
  try {
    await _insertClient(database, clientName);
    final backup = File(p.join(root.path, 'incoming.obraia-backup'));
    await BackupArchiveService().createBackup(
      database: database,
      destinationPath: backup.path,
      appVersion: '1.0.0',
      appBuildNumber: '1',
    );
    return backup;
  } finally {
    await database.close();
  }
}

class _InjectedFailure implements Exception {
  const _InjectedFailure();
}

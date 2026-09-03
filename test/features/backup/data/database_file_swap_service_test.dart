import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/features/backup/data/backup_archive_service.dart';
import 'package:obraia_v2/features/backup/data/database_file_swap_service.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

void main() {
  late Directory temporaryDirectory;
  late File activeDatabase;
  late File preparedDatabase;
  late _TestDatabaseLifecycle lifecycle;
  late DatabaseFileSwapService service;

  setUp(() async {
    temporaryDirectory = await Directory.systemTemp.createTemp(
      'obraia database swap test ',
    );
    activeDatabase = await _createDatabase(
      temporaryDirectory,
      'active.sqlite',
      'Datos anteriores',
    );
    preparedDatabase = await _createDatabase(
      temporaryDirectory,
      'prepared.sqlite',
      'Datos restaurados',
    );
    lifecycle = _TestDatabaseLifecycle(activeDatabase);
    await lifecycle.openAndValidate();
    service = DatabaseFileSwapService();
  });

  tearDown(() async {
    await lifecycle.close();
    if (await temporaryDirectory.exists()) {
      await temporaryDirectory.delete(recursive: true);
    }
  });

  test(
    'intercambia la base cerrada y conserva el rollback con sidecars',
    () async {
      final preparedBytes = await preparedDatabase.readAsBytes();
      final wal = File('${activeDatabase.path}-wal');
      final shm = File('${activeDatabase.path}-shm');
      await wal.writeAsBytes(<int>[1, 2, 3], flush: true);
      await shm.writeAsBytes(<int>[4, 5, 6], flush: true);

      final result = await service.replace(
        activeDatabasePath: activeDatabase.path,
        preparedDatabasePath: preparedDatabase.path,
        currentSchemaVersion: 23,
        closeActiveDatabase: lifecycle.close,
        openAndValidateActiveDatabase: lifecycle.openAndValidate,
      );

      expect(lifecycle.currentClientName, 'Datos restaurados');
      expect(await preparedDatabase.readAsBytes(), preparedBytes);
      expect(await wal.exists(), isFalse);
      expect(await shm.exists(), isFalse);
      expect(await result.rollbackDirectory.exists(), isTrue);
      expect(
        result.rollbackFiles.map((file) => p.basename(file.path)).toSet(),
        <String>{
          'rollback.sqlite',
          'rollback.sqlite-wal',
          'rollback.sqlite-shm',
        },
      );
      expect(
        await File(
          p.join(result.rollbackDirectory.path, 'rollback.sqlite-wal'),
        ).readAsBytes(),
        <int>[1, 2, 3],
      );
      expect(
        await _readClientName(
          File(p.join(result.rollbackDirectory.path, 'rollback.sqlite')),
        ),
        'Datos anteriores',
      );
    },
  );

  for (final failureStage in DatabaseSwapStage.values) {
    test(
      'recupera la base anterior tras fallar en ${failureStage.name}',
      () async {
        final wal = File('${activeDatabase.path}-wal');
        final shm = File('${activeDatabase.path}-shm');
        await wal.writeAsBytes(<int>[7, 8], flush: true);
        await shm.writeAsBytes(<int>[9, 10], flush: true);

        await expectLater(
          service.replace(
            activeDatabasePath: activeDatabase.path,
            preparedDatabasePath: preparedDatabase.path,
            currentSchemaVersion: 23,
            closeActiveDatabase: lifecycle.close,
            openAndValidateActiveDatabase: lifecycle.openAndValidate,
            failureHook: (stage) async {
              if (stage == failureStage) {
                throw const _InjectedFailure();
              }
            },
          ),
          throwsA(isA<_InjectedFailure>()),
        );

        expect(lifecycle.currentClientName, 'Datos anteriores');
        expect(await wal.exists(), isTrue);
        expect(await shm.exists(), isTrue);
        expect(_swapDirectories(temporaryDirectory), isEmpty);
      },
    );
  }

  test(
    'recupera la base anterior si falla la validación de la nueva',
    () async {
      lifecycle.rejectReplacement = true;

      await expectLater(
        service.replace(
          activeDatabasePath: activeDatabase.path,
          preparedDatabasePath: preparedDatabase.path,
          currentSchemaVersion: 23,
          closeActiveDatabase: lifecycle.close,
          openAndValidateActiveDatabase: lifecycle.openAndValidate,
        ),
        throwsA(isA<_RejectedReplacement>()),
      );

      expect(lifecycle.currentClientName, 'Datos anteriores');
      expect(_swapDirectories(temporaryDirectory), isEmpty);
    },
  );

  test('un preparado inválido no cierra ni modifica la base activa', () async {
    final invalidPrepared = File(
      p.join(temporaryDirectory.path, 'invalid.sqlite'),
    );
    await invalidPrepared.writeAsBytes(<int>[1, 2, 3], flush: true);
    final closeCallsBefore = lifecycle.closeCalls;

    await expectLater(
      service.replace(
        activeDatabasePath: activeDatabase.path,
        preparedDatabasePath: invalidPrepared.path,
        currentSchemaVersion: 23,
        closeActiveDatabase: lifecycle.close,
        openAndValidateActiveDatabase: lifecycle.openAndValidate,
      ),
      throwsA(isA<BackupValidationException>()),
    );

    expect(lifecycle.closeCalls, closeCallsBefore);
    expect(lifecycle.currentClientName, 'Datos anteriores');
    expect(_swapDirectories(temporaryDirectory), isEmpty);
  });

  test(
    'conserva los archivos de rollback si no logra reabrir la anterior',
    () async {
      lifecycle.rejectEveryOpen = true;

      await expectLater(
        service.replace(
          activeDatabasePath: activeDatabase.path,
          preparedDatabasePath: preparedDatabase.path,
          currentSchemaVersion: 23,
          closeActiveDatabase: lifecycle.close,
          openAndValidateActiveDatabase: lifecycle.openAndValidate,
          failureHook: (stage) async {
            if (stage == DatabaseSwapStage.incomingActivated) {
              throw const _InjectedFailure();
            }
          },
        ),
        throwsA(isA<DatabaseRollbackFailedException>()),
      );

      expect(await activeDatabase.exists(), isTrue);
      expect(await _readClientName(activeDatabase), 'Datos anteriores');
      final preservedDirectories = _swapDirectories(temporaryDirectory);
      expect(preservedDirectories, hasLength(1));
      expect(
        await File(
          p.join(preservedDirectories.single.path, 'failed-incoming.sqlite'),
        ).exists(),
        isTrue,
      );
    },
  );
}

Future<File> _createDatabase(
  Directory directory,
  String filename,
  String clientName,
) async {
  final file = File(p.join(directory.path, filename));
  final database = AppDatabase.forTesting(NativeDatabase(file));
  try {
    await database.clientesDao.insertarCliente(
      ClientesCompanion.insert(id: 'cliente-1', nombre: clientName),
    );
  } finally {
    await database.close();
  }
  return file;
}

Future<String> _readClientName(File databaseFile) async {
  final database = sqlite3.open(databaseFile.path, mode: OpenMode.readOnly);
  try {
    return database.select('SELECT nombre FROM clientes;').single['nombre']
        as String;
  } finally {
    database.close();
  }
}

List<Directory> _swapDirectories(Directory root) => root
    .listSync()
    .whereType<Directory>()
    .where(
      (directory) =>
          p.basename(directory.path).startsWith('.obraia-database-swap-'),
    )
    .toList(growable: false);

class _TestDatabaseLifecycle {
  _TestDatabaseLifecycle(this.databaseFile);

  final File databaseFile;
  Database? _database;
  bool rejectReplacement = false;
  bool rejectEveryOpen = false;
  int closeCalls = 0;

  String? get currentClientName {
    final database = _database;
    if (database == null) {
      return null;
    }
    return database.select('SELECT nombre FROM clientes;').single['nombre']
        as String;
  }

  Future<void> close() async {
    closeCalls++;
    _database?.close();
    _database = null;
  }

  Future<void> openAndValidate() async {
    final database = sqlite3.open(databaseFile.path, mode: OpenMode.readWrite);
    final name = database
        .select('SELECT nombre FROM clientes;')
        .single['nombre'];
    if (rejectEveryOpen || (rejectReplacement && name == 'Datos restaurados')) {
      database.close();
      if (rejectEveryOpen) {
        throw const _RejectedEveryOpen();
      }
      throw const _RejectedReplacement();
    }
    _database = database;
  }
}

class _InjectedFailure implements Exception {
  const _InjectedFailure();
}

class _RejectedReplacement implements Exception {
  const _RejectedReplacement();
}

class _RejectedEveryOpen implements Exception {
  const _RejectedEveryOpen();
}

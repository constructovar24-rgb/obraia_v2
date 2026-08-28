import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/features/backup/data/backup_archive_service.dart';
import 'package:obraia_v2/features/backup/domain/backup_manifest.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

void main() {
  late Directory temporaryDirectory;
  late AppDatabase sourceDatabase;
  late BackupArchiveService service;

  setUp(() async {
    temporaryDirectory = await Directory.systemTemp.createTemp(
      'obraia backup archive test ',
    );
    final sourceFile = File(
      p.join(temporaryDirectory.path, 'source database.sqlite'),
    );
    sourceDatabase = AppDatabase.forTesting(NativeDatabase(sourceFile));
    service = BackupArchiveService();

    await sourceDatabase.clientesDao.insertarCliente(
      ClientesCompanion.insert(id: 'cliente-1', nombre: 'Cliente de prueba'),
    );
  });

  tearDown(() async {
    await sourceDatabase.close();
    if (await temporaryDirectory.exists()) {
      await temporaryDirectory.delete(recursive: true);
    }
  });

  test('crea, publica y revalida un backup de formato 1', () async {
    final destination = File(
      p.join(
        temporaryDirectory.path,
        'copia manual con espacios.obraia-backup',
      ),
    );
    final createdAt = DateTime.utc(2026, 8, 28, 12, 30);

    final result = await service.createBackup(
      database: sourceDatabase,
      destinationPath: destination.path,
      appVersion: '1.0.0',
      appBuildNumber: '1',
      createdAtUtc: createdAt,
    );

    expect(await destination.exists(), isTrue);
    expect(result.createdAtUtc, createdAt);
    expect(result.appVersion, '1.0.0');
    expect(result.appBuildNumber, '1');
    expect(result.schemaVersion, sourceDatabase.schemaVersion);
    expect(result.databasePath, BackupManifest.defaultDatabasePath);
    expect(result.entries, hasLength(1));
    expect(result.entries.single.sizeBytes, greaterThan(0));
    expect(result.entries.single.sha256, hasLength(64));

    final validated = await service.validateBackup(
      destination.path,
      maximumSchemaVersion: sourceDatabase.schemaVersion,
    );
    expect(validated.toJson(), result.toJson());

    final archive = ZipDecoder().decodeBytes(await destination.readAsBytes());
    expect(archive.map((entry) => entry.name).toSet(), <String>{
      BackupManifest.manifestPath,
      BackupManifest.defaultDatabasePath,
    });
    final databaseBytes = archive
        .findFile(BackupManifest.defaultDatabasePath)!
        .readBytes()!;
    final extractedDatabase = File(
      p.join(temporaryDirectory.path, 'extracted.sqlite'),
    );
    await extractedDatabase.writeAsBytes(databaseBytes, flush: true);
    final sqliteDatabase = sqlite3.open(
      extractedDatabase.path,
      mode: OpenMode.readOnly,
    );
    try {
      expect(sqliteDatabase.userVersion, sourceDatabase.schemaVersion);
      expect(
        sqliteDatabase.select('SELECT nombre FROM clientes;').single['nombre'],
        'Cliente de prueba',
      );
    } finally {
      sqliteDatabase.close();
    }

    final stagingDirectories = temporaryDirectory
        .listSync()
        .whereType<Directory>();
    expect(
      stagingDirectories.where(
        (directory) => p.basename(directory.path).startsWith('.obraia-backup-'),
      ),
      isEmpty,
    );
  });

  test('no sobrescribe un archivo de destino existente', () async {
    final destination = File(
      p.join(temporaryDirectory.path, 'existente.obraia-backup'),
    );
    const originalBytes = <int>[79, 66, 82, 65, 73, 65];
    await destination.writeAsBytes(originalBytes, flush: true);

    await expectLater(
      service.createBackup(
        database: sourceDatabase,
        destinationPath: destination.path,
        appVersion: '1.0.0',
        appBuildNumber: '1',
      ),
      throwsA(isA<BackupDestinationExistsException>()),
    );

    expect(await destination.readAsBytes(), originalBytes);
  });

  test('no publica un backup si detecta relaciones huérfanas', () async {
    await sourceDatabase.customStatement(
      '''
      INSERT INTO expedientes (id, codigo, nombre, cliente, cliente_id)
      VALUES (?, ?, ?, ?, ?)
    ''',
      <Object?>[
        'expediente-huerfano',
        'EXP-H',
        'Expediente huérfano',
        'Cliente inexistente',
        'cliente-inexistente',
      ],
    );
    final destination = File(
      p.join(temporaryDirectory.path, 'no-debe-publicarse.obraia-backup'),
    );

    await expectLater(
      service.createBackup(
        database: sourceDatabase,
        destinationPath: destination.path,
        appVersion: '1.0.0',
        appBuildNumber: '1',
      ),
      throwsA(isA<BackupValidationException>()),
    );

    expect(await destination.exists(), isFalse);
    expect(
      temporaryDirectory.listSync().whereType<Directory>().where(
        (directory) => p.basename(directory.path).startsWith('.obraia-backup-'),
      ),
      isEmpty,
    );
  });

  test('rechaza un payload cuyo hash no coincide con el manifiesto', () async {
    final validBackup = File(
      p.join(temporaryDirectory.path, 'valido.obraia-backup'),
    );
    await service.createBackup(
      database: sourceDatabase,
      destinationPath: validBackup.path,
      appVersion: '1.0.0',
      appBuildNumber: '1',
    );

    final decoded = ZipDecoder().decodeBytes(await validBackup.readAsBytes());
    final databaseEntry = decoded.findFile(BackupManifest.defaultDatabasePath)!;
    final changedBytes = databaseEntry.readBytes()!.toList();
    changedBytes[changedBytes.length - 1] ^= 0xff;
    decoded.addFile(
      ArchiveFile.bytes(BackupManifest.defaultDatabasePath, changedBytes),
    );
    final corrupted = File(
      p.join(temporaryDirectory.path, 'corrupto.obraia-backup'),
    );
    await corrupted.writeAsBytes(
      ZipEncoder().encodeBytes(decoded),
      flush: true,
    );

    await expectLater(
      service.validateBackup(
        corrupted.path,
        maximumSchemaVersion: sourceDatabase.schemaVersion,
      ),
      throwsA(isA<BackupValidationException>()),
    );
  });

  test('rechaza una versión futura del formato', () async {
    final validBackup = File(
      p.join(temporaryDirectory.path, 'formato-actual.obraia-backup'),
    );
    await service.createBackup(
      database: sourceDatabase,
      destinationPath: validBackup.path,
      appVersion: '1.0.0',
      appBuildNumber: '1',
    );

    final decoded = ZipDecoder().decodeBytes(await validBackup.readAsBytes());
    final manifestEntry = decoded.findFile(BackupManifest.manifestPath)!;
    final manifestJson =
        jsonDecode(utf8.decode(manifestEntry.readBytes()!))
            as Map<String, Object?>;
    manifestJson['formatVersion'] = BackupManifest.currentFormatVersion + 1;
    decoded.addFile(
      ArchiveFile.string(BackupManifest.manifestPath, jsonEncode(manifestJson)),
    );
    final futureBackup = File(
      p.join(temporaryDirectory.path, 'formato-futuro.obraia-backup'),
    );
    await futureBackup.writeAsBytes(
      ZipEncoder().encodeBytes(decoded),
      flush: true,
    );

    await expectLater(
      service.validateBackup(
        futureBackup.path,
        maximumSchemaVersion: sourceDatabase.schemaVersion,
      ),
      throwsA(isA<BackupValidationException>()),
    );
  });

  test('rechaza un contenedor que supera el límite de entradas', () async {
    final oversizedArchive = Archive();
    for (var index = 0; index <= BackupArchiveService.maxEntries; index++) {
      oversizedArchive.addFile(
        ArchiveFile.bytes('entry-$index.bin', <int>[index]),
      );
    }
    final oversizedBackup = File(
      p.join(temporaryDirectory.path, 'demasiadas-entradas.obraia-backup'),
    );
    await oversizedBackup.writeAsBytes(
      ZipEncoder().encodeBytes(oversizedArchive),
      flush: true,
    );

    await expectLater(
      service.validateBackup(
        oversizedBackup.path,
        maximumSchemaVersion: sourceDatabase.schemaVersion,
      ),
      throwsA(isA<BackupSizeLimitException>()),
    );
  });

  test('rechaza rutas internas peligrosas', () async {
    final maliciousArchive = Archive()
      ..addFile(
        ArchiveFile.string(
          BackupManifest.manifestPath,
          jsonEncode(<String, Object?>{}),
        ),
      )
      ..addFile(ArchiveFile.bytes('../escape.sqlite', <int>[1, 2, 3]));
    final maliciousBackup = File(
      p.join(temporaryDirectory.path, 'ruta-peligrosa.obraia-backup'),
    );
    await maliciousBackup.writeAsBytes(
      ZipEncoder().encodeBytes(maliciousArchive),
      flush: true,
    );

    await expectLater(
      service.validateBackup(
        maliciousBackup.path,
        maximumSchemaVersion: sourceDatabase.schemaVersion,
      ),
      throwsA(isA<BackupValidationException>()),
    );
    expect(
      await File(
        p.join(temporaryDirectory.parent.path, 'escape.sqlite'),
      ).exists(),
      isFalse,
    );
  });
}

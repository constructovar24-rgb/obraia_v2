import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/core/environment/app_environment.dart';
import 'package:obraia_v2/core/environment/environment_paths.dart';
import 'package:obraia_v2/database/app_database.dart' as db;
import 'package:obraia_v2/database/database_lifecycle_controller.dart';
import 'package:obraia_v2/features/documentos/data/documento_repository.dart';
import 'package:obraia_v2/features/documentos/data/managed_document_store.dart';
import 'package:obraia_v2/features/documentos/domain/documento.dart';
import 'package:obraia_v2/features/backup/data/backup_archive_service.dart';
import 'package:obraia_v2/features/backup/data/backup_restore_coordinator.dart';
import 'package:obraia_v2/features/backup/data/backup_restore_staging_service.dart';
import 'package:obraia_v2/features/backup/data/database_file_swap_service.dart';

void main() {
  late Directory dir;
  late db.AppDatabase database;
  late EnvironmentPaths paths;
  late DocumentoRepository repository;
  late File backup;
  late Documento saved;
  late DatabaseLifecycleController lifecycle;
  setUp(() async {
    dir = await Directory.systemTemp.createTemp('obraia-prod5-backup-');
    paths = EnvironmentPaths(dir, AppEnvironment.development);
    final activeFile = File('${dir.path}/test.sqlite');
    database = db.AppDatabase.forTesting(NativeDatabase(activeFile));
    lifecycle = DatabaseLifecycleController(
      initialDatabase: database,
      databaseFactory: () =>
          db.AppDatabase.forTesting(NativeDatabase(activeFile)),
      activeDatabasePathResolver: () async => activeFile.path,
    );
    await database.expedientesDao.insertarExpediente(
      db.ExpedientesCompanion.insert(
        id: 'obra',
        codigo: 'TEST',
        nombre: 'Ficticia',
      ),
    );
    repository = DocumentoRepository(
      database.documentosDao,
      store: ManagedDocumentStore(paths),
    );
    final source = await File(
      '${dir.path}/original.txt',
    ).writeAsString('Original ficticio protegido');
    await repository.registrarDocumento(
      Documento(
        id: '',
        expedienteId: 'obra',
        titulo: 'Original',
        nombreArchivo: 'original.txt',
        rutaArchivo: source.path,
        mimeType: 'text/plain',
        tamanoBytes: 0,
        fecha: DateTime(2026),
        observaciones: null,
        tipo: DocumentoTipo.factura,
      ),
    );
    saved = (await repository.obtenerDocumentosPorExpediente('obra')).single;
    backup = File('${dir.path}/test.obraia-backup');
    await BackupArchiveService(documentPaths: paths).createBackup(
      database: database,
      destinationPath: backup.path,
      appVersion: 'test',
      appBuildNumber: '1',
    );
  });
  tearDown(() async {
    await lifecycle.close();
    await dir.delete(recursive: true);
  });
  Future<File> managed() => ManagedDocumentStore(paths).resolve(
    saved.rutaGestionada!,
    database.activeTenantId,
    saved.sha256Original!,
  );
  Future<void> restore({DatabaseSwapFailureHook? hook}) async {
    await BackupRestoreCoordinator(
      databaseLifecycle: lifecycle,
      documentPaths: paths,
      swapFailureHook: hook,
    ).restore(
      backupPath: backup.path,
      recoveryDirectory: Directory('${dir.path}/recovery'),
      appVersion: 'test',
      appBuildNumber: '1',
    );
  }

  Future<void> mutateArchive(void Function(Archive) mutate) async {
    final archive = ZipDecoder().decodeBytes(await backup.readAsBytes());
    mutate(archive);
    await backup.writeAsBytes(ZipEncoder().encodeBytes(archive));
  }

  test('paquete contiene SQLite, manifest v2 y originales con hash', () async {
    final manifest = await BackupArchiveService().validateBackup(
      backup.path,
      maximumSchemaVersion: 36,
    );
    expect(manifest.formatVersion, 2);
    expect(manifest.entries.length, 2);
    expect(manifest.entries.last.sha256, saved.sha256Original);
    final prepared = await BackupRestoreStagingService().prepare(
      backupPath: backup.path,
      currentSchemaVersion: 36,
    );
    try {
      expect(
        await File(
          '${prepared.documentsDirectory.path}/${saved.rutaGestionada}',
        ).readAsString(),
        'Original ficticio protegido',
      );
    } finally {
      await prepared.dispose();
    }
  });
  test('backup rechaza un original ausente', () async {
    await (await managed()).delete();
    await expectLater(
      BackupArchiveService(documentPaths: paths).createBackup(
        database: database,
        destinationPath: '${dir.path}/missing.obraia-backup',
        appVersion: 'test',
        appBuildNumber: '1',
      ),
      throwsA(isA<BackupValidationException>()),
    );
  });
  test('backup rechaza alteraciones del original', () async {
    await (await managed()).writeAsString('Alterado');
    await expectLater(
      BackupArchiveService(documentPaths: paths).createBackup(
        database: database,
        destinationPath: '${dir.path}/changed.obraia-backup',
        appVersion: 'test',
        appBuildNumber: '1',
      ),
      throwsA(isA<BackupValidationException>()),
    );
  });
  test('detecta paquete incompleto', () async {
    await mutateArchive((archive) => archive.removeFile(archive.files.last));
    await expectLater(
      BackupArchiveService().validateBackup(
        backup.path,
        maximumSchemaVersion: 36,
      ),
      throwsA(isA<BackupValidationException>()),
    );
  });
  test('detecta contenido corrupto', () async {
    await mutateArchive((archive) {
      final entry = archive.files.last;
      archive.removeFile(entry);
      archive.addFile(ArchiveFile.bytes(entry.name, [1, 2, 3]));
    });
    await expectLater(
      BackupArchiveService().validateBackup(
        backup.path,
        maximumSchemaVersion: 36,
      ),
      throwsA(isA<BackupValidationException>()),
    );
  });
  test('detecta manifest incoherente', () async {
    await mutateArchive((archive) {
      final entry = archive.findFile('manifest.json')!;
      final json =
          jsonDecode(utf8.decode(entry.readBytes()!)) as Map<String, dynamic>;
      json['entryCount'] = 99;
      archive.removeFile(entry);
      archive.addFile(
        ArchiveFile.bytes('manifest.json', utf8.encode(jsonEncode(json))),
      );
    });
    await expectLater(
      BackupArchiveService().validateBackup(
        backup.path,
        maximumSchemaVersion: 36,
      ),
      throwsA(isA<BackupValidationException>()),
    );
  });
  test('restore recupera DB y archivo ausente conjuntamente', () async {
    await (await managed()).delete();
    await database.customStatement("UPDATE documentos SET titulo='Posterior'");
    await restore();
    final restored = DocumentoRepository(
      lifecycle.activeDatabase.documentosDao,
      store: ManagedDocumentStore(paths),
    );
    expect((await restored.obtenerDocumento(saved.id))!.titulo, 'Original');
    expect(await restored.verificarDocumento(saved.id), 'Integridad correcta');
  });
  test(
    'fallo después de activar DB recupera datos y archivos anteriores',
    () async {
      await database.customStatement(
        "UPDATE documentos SET titulo='Posterior'",
      );
      await expectLater(
        restore(
          hook: (stage) async {
            if (stage == DatabaseSwapStage.incomingActivated) {
              throw StateError('Fallo inyectado');
            }
          },
        ),
        throwsStateError,
      );
      final restored = DocumentoRepository(
        lifecycle.activeDatabase.documentosDao,
        store: ManagedDocumentStore(paths),
      );
      expect((await restored.obtenerDocumento(saved.id))!.titulo, 'Posterior');
      expect(
        await restored.verificarDocumento(saved.id),
        'Integridad correcta',
      );
    },
  );
  test('bloquea restore de otro entorno sin modificar datos', () async {
    await mutateArchive((archive) {
      final entry = archive.findFile('manifest.json')!;
      final json =
          jsonDecode(utf8.decode(entry.readBytes()!)) as Map<String, dynamic>;
      json['environment'] = 'production';
      archive.removeFile(entry);
      archive.addFile(
        ArchiveFile.bytes('manifest.json', utf8.encode(jsonEncode(json))),
      );
    });
    await expectLater(
      restore(),
      throwsA(isA<BackupEnvironmentMismatchException>()),
    );
    expect(
      await repository.verificarDocumento(saved.id),
      'Integridad correcta',
    );
  });
  test(
    'copia antigua v1 sin originales conserva compatibilidad explícita',
    () async {
      final oldDb = db.AppDatabase.forTesting(NativeDatabase.memory());
      try {
        final old = File('${dir.path}/old.obraia-backup');
        await BackupArchiveService().createBackup(
          database: oldDb,
          destinationPath: old.path,
          appVersion: 'test',
          appBuildNumber: '1',
        );
        final archive = ZipDecoder().decodeBytes(await old.readAsBytes());
        final entry = archive.findFile('manifest.json')!;
        final json =
            jsonDecode(utf8.decode(entry.readBytes()!)) as Map<String, dynamic>;
        json['formatVersion'] = 1;
        archive.removeFile(entry);
        archive.addFile(
          ArchiveFile.bytes('manifest.json', utf8.encode(jsonEncode(json))),
        );
        await old.writeAsBytes(ZipEncoder().encodeBytes(archive));
        expect(
          (await BackupArchiveService().validateBackup(
            old.path,
            maximumSchemaVersion: 36,
          )).includesManagedDocuments,
          isFalse,
        );
      } finally {
        await oldDb.close();
      }
    },
  );
  test(
    'restore repara original alterado y marca la recuperación incompleta',
    () async {
      await (await managed()).writeAsString('Alterado ficticio');
      await restore();
      final restored = DocumentoRepository(
        lifecycle.activeDatabase.documentosDao,
        store: ManagedDocumentStore(paths),
      );
      expect(
        await restored.verificarDocumento(saved.id),
        'Integridad correcta',
      );
      final recovery = (await Directory(
        '${dir.path}/recovery',
      ).list().where((f) => f.path.endsWith('.obraia-backup')).toList()).single;
      final manifest = await BackupArchiveService().validateBackup(
        recovery.path,
        maximumSchemaVersion: 36,
      );
      expect(manifest.documentPackageComplete, isFalse);
      backup = File(recovery.path);
      await expectLater(restore(), throwsA(isA<BackupValidationException>()));
    },
  );
  test(
    'rollback devuelve original alterado si falla la activación de DB',
    () async {
      final target = await managed();
      await target.writeAsString('Alterado ficticio');
      await expectLater(
        restore(
          hook: (stage) async {
            if (stage == DatabaseSwapStage.incomingActivated) {
              throw StateError('Fallo inyectado');
            }
          },
        ),
        throwsStateError,
      );
      expect(await target.readAsString(), 'Alterado ficticio');
    },
  );
  test('restore rechaza otra empresa conservando documentos y DB', () async {
    final other = db.AppDatabase.forTesting(
      NativeDatabase.memory(),
      tenantId: 'otra-empresa-ficticia',
    );
    try {
      backup = File('${dir.path}/other.obraia-backup');
      await BackupArchiveService().createBackup(
        database: other,
        destinationPath: backup.path,
        appVersion: 'test',
        appBuildNumber: '1',
      );
      await expectLater(restore(), throwsStateError);
      expect(
        await repository.verificarDocumento(saved.id),
        'Integridad correcta',
      );
    } finally {
      await other.close();
    }
  });
}

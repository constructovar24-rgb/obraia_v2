import 'dart:async';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/core/environment/app_environment.dart';
import 'package:obraia_v2/core/environment/environment_paths.dart';
import 'package:obraia_v2/core/environment/environment_profile_store.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/database/database_lifecycle_controller.dart';
import 'package:obraia_v2/database/database_provider.dart';
import 'package:obraia_v2/features/backup/data/backup_archive_service.dart';
import 'package:obraia_v2/features/backup/data/backup_restore_coordinator.dart';
import 'package:obraia_v2/features/backup/domain/backup_manifest.dart';
import 'package:obraia_v2/features/environment/presentation/providers/environment_controller.dart';
import 'package:path/path.dart' as p;
import 'package:obraia_v2/features/backup/presentation/controllers/backup_controller.dart';

void main() {
  late Directory root;
  late EnvironmentProfileStore profile;
  late EnvironmentController controller;
  setUp(() async {
    root = await Directory.systemTemp.createTemp('obraia-prod1-');
    profile = EnvironmentProfileStore(root);
    controller = EnvironmentController(
      documentsDirectory: root,
      profileStore: profile,
      initialEnvironment: await profile.read(),
      detachSession: () async {},
    );
    await controller.lifecycle.activeDatabase.ensureReady();
  });
  tearDown(() async {
    await controller.close();
    controller.dispose();
    await root.delete(recursive: true);
  });

  test('rutas separadas y ruta legacy conservada sin mover archivos', () {
    final dev = EnvironmentPaths(root, AppEnvironment.development);
    final prod = EnvironmentPaths(root, AppEnvironment.production);
    expect(dev.databaseFile.path, p.join(root.path, 'obraia.sqlite'));
    expect(
      prod.databaseFile.path,
      p.join(root.path, 'OBRA IA', 'production', 'obraia_prod.sqlite'),
    );
    expect(dev.dataDirectory.path, isNot(prod.dataDirectory.path));
    expect(dev.backupDirectory.path, isNot(prod.backupDirectory.path));
    expect(dev.generatedDirectory.path, isNot(prod.generatedDirectory.path));
    expect(prod.databaseFile.existsSync(), isFalse);
  });

  test(
    'PROD nueva: schema 32, tenant neutral y todas las tablas funcionales vacías',
    () async {
      await controller.changeEnvironment(AppEnvironment.production);
      expect(controller.error, isNull);
      final db = controller.lifecycle.activeDatabase;
      final version = await db.customSelect('PRAGMA user_version').getSingle();
      expect(version.read<int>('user_version'), 32);
      expect(db.schemaVersion, 32);
      final tenant = await db.select(db.tenants).getSingle();
      expect(tenant.nombre, 'Empresa inicial');
      for (final table in db.allTables) {
        if ({
          'tenants',
          'categorias_economicas',
          'configuracion_economica',
        }.contains(table.actualTableName)) {
          continue;
        }
        final count = await db
            .customSelect(
              'SELECT COUNT(*) AS n FROM "${table.actualTableName}"',
            )
            .getSingle();
        expect(count.read<int>('n'), 0, reason: table.actualTableName);
      }
      expect(await db.select(db.categoriasEconomicas).get(), hasLength(9));
      expect(await db.select(db.configuracionEconomica).get(), hasLength(1));
    },
  );

  test(
    'DEV existente y PROD conservan bytes y datos independientes al alternar',
    () async {
      final dev = controller.paths.databaseFile;
      final old = controller.lifecycle.activeDatabase;
      await insertClient(old, 'dev-client', 'Prueba DEV');
      await controller.changeEnvironment(AppEnvironment.production);
      final devHash = sha256.convert(await dev.readAsBytes()).toString();
      await expectLater(old.ensureReady(), throwsA(anything));
      final prod = controller.paths.databaseFile;
      await insertClient(
        controller.lifecycle.activeDatabase,
        'prod-client',
        'Prueba PROD',
      );
      expect(await clientNames(controller.lifecycle.activeDatabase), [
        'Prueba PROD',
      ]);
      expect(sha256.convert(await dev.readAsBytes()).toString(), devHash);
      await controller.changeEnvironment(AppEnvironment.development);
      expect(controller.error, isNull);
      final prodHash = sha256.convert(await prod.readAsBytes()).toString();
      expect(await clientNames(controller.lifecycle.activeDatabase), [
        'Prueba DEV',
      ]);
      await insertClient(
        controller.lifecycle.activeDatabase,
        'dev-client-2',
        'Otra prueba DEV',
      );
      expect(sha256.convert(await prod.readAsBytes()).toString(), prodHash);
      await controller.changeEnvironment(AppEnvironment.production);
      expect(await clientNames(controller.lifecycle.activeDatabase), [
        'Prueba PROD',
      ]);
    },
  );

  test('perfil persiste tras cierre y reapertura; no vuelve a DEV', () async {
    await controller.changeEnvironment(AppEnvironment.production);
    await insertClient(
      controller.lifecycle.activeDatabase,
      'prod',
      'Persistente ficticio',
    );
    await controller.close();
    final reopened = EnvironmentController(
      documentsDirectory: root,
      profileStore: EnvironmentProfileStore(root),
      initialEnvironment: await EnvironmentProfileStore(root).read(),
      detachSession: () async {},
    );
    try {
      expect(reopened.environment, AppEnvironment.production);
      expect(await clientNames(reopened.lifecycle.activeDatabase), [
        'Persistente ficticio',
      ]);
    } finally {
      await reopened.close();
      reopened.dispose();
    }
  });

  test('perfil inválido bloquea arranque; ausencia significa DEV', () async {
    expect(await profile.read(), AppEnvironment.development);
    await profile.file.parent.create(recursive: true);
    await profile.file.writeAsString('desconocido');
    await expectLater(profile.read(), throwsFormatException);
  });

  test(
    'fallo de persistencia recupera DEV y no publica una sesión PROD',
    () async {
      await controller.close();
      controller.dispose();
      controller = EnvironmentController(
        documentsDirectory: root,
        profileStore: FailingProfileStore(root),
        initialEnvironment: AppEnvironment.development,
        detachSession: () async {},
      );
      await insertClient(
        controller.lifecycle.activeDatabase,
        'dev',
        'Conservar',
      );
      await controller.changeEnvironment(AppEnvironment.production);
      expect(controller.environment, AppEnvironment.development);
      expect(controller.available, isTrue);
      expect(controller.error, isNotNull);
      expect(await profile.read(), AppEnvironment.development);
      expect(await clientNames(controller.lifecycle.activeDatabase), [
        'Conservar',
      ]);
    },
  );

  test(
    'cambio espera a que termine una transacción y rechaza mantenimiento concurrente',
    () async {
      final started = Completer<void>();
      final finish = Completer<void>();
      final old = controller.lifecycle.activeDatabase;
      final transaction = old.transaction(() async {
        await insertClient(old, 'atomic', 'Transacción completa');
        started.complete();
        await finish.future;
      });
      await started.future;
      final change = controller.changeEnvironment(AppEnvironment.production);
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(controller.switching, isTrue);
      expect(controller.environment, AppEnvironment.development);
      await expectLater(
        controller.lifecycle.runExclusiveMaintenance(() async {}),
        throwsA(isA<DatabaseMaintenanceInProgressException>()),
      );
      finish.complete();
      await transaction;
      await change;
      expect(controller.error, isNull);
      await controller.changeEnvironment(AppEnvironment.development);
      expect(await clientNames(controller.lifecycle.activeDatabase), [
        'Transacción completa',
      ]);
    },
  );

  test(
    'providers publican nueva DB y tenant sin reutilizar la conexión cerrada',
    () async {
      final container = ProviderContainer(
        overrides: [
          databaseLifecycleControllerProvider.overrideWith(
            (ref) => controller.lifecycle,
          ),
        ],
      );
      try {
        final old = container.read(databaseProvider);
        final oldTenant = container.read(activeTenantIdProvider);
        await controller.changeEnvironment(AppEnvironment.production);
        expect(container.read(databaseProvider), isNot(same(old)));
        expect(container.read(activeTenantIdProvider), isNot(oldTenant));
        expect(
          container.read(databaseProvider).environment,
          AppEnvironment.production,
        );
      } finally {
        container.dispose();
      }
    },
  );

  for (final source in AppEnvironment.values) {
    test(
      'backup ${source.name} bloqueado en el otro entorno antes de recuperación/intercambio',
      () async {
        await controller.changeEnvironment(source);
        final backup = p.join(root.path, '${source.name}.obraia-backup');
        final manifest = await BackupArchiveService().createBackup(
          database: controller.lifecycle.activeDatabase,
          destinationPath: backup,
          appVersion: 'test',
          appBuildNumber: '1',
        );
        expect(manifest.environment, source);
        expect(
          (await BackupArchiveService().validateBackup(
            backup,
            maximumSchemaVersion: 32,
          )).environment,
          source,
        );
        final target = source == AppEnvironment.production
            ? AppEnvironment.development
            : AppEnvironment.production;
        await controller.changeEnvironment(target);
        final active = controller.lifecycle.activeDatabase;
        final generation = controller.lifecycle.generation;
        final recovery = Directory(
          p.join(controller.paths.backupDirectory.path, 'recuperacion'),
        );
        await expectLater(
          BackupRestoreCoordinator(
            databaseLifecycle: controller.lifecycle,
          ).restore(
            backupPath: backup,
            recoveryDirectory: recovery,
            appVersion: 'test',
            appBuildNumber: '1',
          ),
          throwsA(isA<BackupEnvironmentMismatchException>()),
        );
        expect(controller.lifecycle.activeDatabase, same(active));
        expect(controller.lifecycle.generation, generation);
        expect(recovery.existsSync(), isFalse);
        await active.ensureReady();
      },
    );
  }

  test(
    'backup legacy sin entorno es DEV; entorno desconocido se rechaza',
    () async {
      final backup = p.join(root.path, 'legacy.obraia-backup');
      final manifest = await BackupArchiveService().createBackup(
        database: controller.lifecycle.activeDatabase,
        destinationPath: backup,
        appVersion: 'test',
        appBuildNumber: '1',
      );
      final json = <String, Object?>{...manifest.toJson()}
        ..remove('environment');
      expect(
        BackupManifest.fromJson(json).environment,
        AppEnvironment.development,
      );
      json['environment'] = 'unknown';
      expect(() => BackupManifest.fromJson(json), throwsFormatException);
      json['environment'] = null;
      expect(() => BackupManifest.fromJson(json), throwsFormatException);
    },
  );

  test(
    'copias manuales y automáticas usan carpetas y metadatos del entorno; bloquean el cambio',
    () async {
      for (final environment in AppEnvironment.values) {
        await controller.changeEnvironment(environment);
        final backupController = BackupController(
          controller.lifecycle.activeDatabase,
          BackupRestoreCoordinator(databaseLifecycle: controller.lifecycle),
          paths: controller.paths,
        );
        final copy = backupController.createManual();
        final other = environment == AppEnvironment.development
            ? AppEnvironment.production
            : AppEnvironment.development;
        await expectLater(
          controller.changeEnvironment(other),
          throwsA(isA<DatabaseMaintenanceInProgressException>()),
        );
        final file = await copy;
        expect(
          p.isWithin(controller.paths.backupDirectory.path, file.path),
          isTrue,
        );
        expect(
          (await BackupArchiveService().validateBackup(
            file.path,
            maximumSchemaVersion: 32,
          )).environment,
          environment,
        );
        await backupController.checkDaily();
        final automatic = Directory(
          p.join(controller.paths.backupDirectory.path, 'automaticas'),
        );
        expect(
          automatic.listSync().whereType<File>().where(
            (f) => f.path.endsWith('.obraia-backup'),
          ),
          hasLength(1),
        );
        backupController.dispose();
      }
    },
  );

  test(
    'callback de restauración de la sesión antigua nunca restaura sobre la nueva',
    () async {
      final old = controller.lifecycle.activeDatabase;
      await controller.changeEnvironment(AppEnvironment.production);
      await expectLater(
        BackupRestoreCoordinator(
          databaseLifecycle: controller.lifecycle,
        ).restore(
          backupPath: 'no-se-debe-leer',
          expectedDatabase: old,
          recoveryDirectory: Directory(p.join(root.path, 'no-se-debe-crear')),
          appVersion: 'test',
          appBuildNumber: '1',
        ),
        throwsStateError,
      );
      expect(
        controller.lifecycle.activeDatabase.environment,
        AppEnvironment.production,
      );
    },
  );

  test(
    'aislamiento tenant permanece en PROD: no lee ni modifica clientes del otro tenant',
    () async {
      await controller.changeEnvironment(AppEnvironment.production);
      final db = controller.lifecycle.activeDatabase;
      final tenantA = db.activeTenantId;
      await insertClient(db, 'a', 'Tenant A ficticio');
      await db.customStatement(
        'INSERT INTO tenants (id, nombre, fecha_creacion, fecha_modificacion) VALUES (?, ?, ?, ?)',
        ['tenant-b', 'Tenant B ficticio', 1, 1],
      );
      db.tenantContext.activate('tenant-b');
      await insertClient(db, 'b', 'Tenant B ficticio');
      expect(await db.clientesDao.obtenerCliente('a'), isNull);
      await db.clientesDao.eliminarLogicamente('a');
      expect((await db.clientesDao.observarClientes().first).single.id, 'b');
      db.tenantContext.activate(tenantA);
      expect((await db.clientesDao.observarClientes().first).single.id, 'a');
      expect(await db.clientesDao.obtenerCliente('b'), isNull);
    },
  );

  test(
    'restauración dentro de PROD conserva el perfil y metadatos de recuperación PROD',
    () async {
      await controller.changeEnvironment(AppEnvironment.production);
      final backup = p.join(root.path, 'prod.obraia-backup');
      await insertClient(
        controller.lifecycle.activeDatabase,
        'saved',
        'Guardado',
      );
      await BackupArchiveService().createBackup(
        database: controller.lifecycle.activeDatabase,
        destinationPath: backup,
        appVersion: 'test',
        appBuildNumber: '1',
      );
      await insertClient(
        controller.lifecycle.activeDatabase,
        'later',
        'Posterior',
      );
      final result =
          await BackupRestoreCoordinator(
            databaseLifecycle: controller.lifecycle,
          ).restore(
            backupPath: backup,
            recoveryDirectory: Directory(
              p.join(controller.paths.backupDirectory.path, 'recuperacion'),
            ),
            appVersion: 'test',
            appBuildNumber: '1',
          );
      expect(await clientNames(controller.lifecycle.activeDatabase), [
        'Guardado',
      ]);
      expect(
        controller.lifecycle.activeDatabase.environment,
        AppEnvironment.production,
      );
      expect(
        result.recoveryBackup.manifest.environment,
        AppEnvironment.production,
      );
      expect(await profile.read(), AppEnvironment.production);
    },
  );
}

class FailingProfileStore extends EnvironmentProfileStore {
  FailingProfileStore(super.directory);
  @override
  Future<void> write(AppEnvironment environment) async =>
      throw const FileSystemException('Fallo simulado');
}

Future<void> insertClient(AppDatabase db, String id, String name) async {
  await db.ensureReady();
  await db.customStatement(
    'INSERT INTO clientes (id, tenant_id, nombre, fecha_creacion, fecha_modificacion) VALUES (?, ?, ?, ?, ?)',
    [id, db.activeTenantId, name, 1, 1],
  );
}

Future<List<String>> clientNames(AppDatabase db) async =>
    (await db.customSelect('SELECT nombre FROM clientes ORDER BY nombre').get())
        .map((row) => row.read<String>('nombre'))
        .toList();

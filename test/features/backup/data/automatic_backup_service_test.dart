import 'dart:io';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/features/backup/data/automatic_backup_service.dart';
import 'package:path/path.dart' as p;

void main() {
  test(
    'crea una sola copia por día y conserva las siete más recientes',
    () async {
      final root = await Directory.systemTemp.createTemp(
        'obraia auto backup test ',
      );
      final db = AppDatabase.forTesting(
        NativeDatabase(File(p.join(root.path, 'db.sqlite'))),
      );
      try {
        await db.clientesDao.insertarCliente(
          ClientesCompanion.insert(id: 'c', nombre: 'Temporal'),
        );
        final service = AutomaticBackupService();
        final dir = Directory(p.join(root.path, 'automaticas'));
        final first = await service.createIfNeeded(
          database: db,
          directory: dir,
          appVersion: '1',
          appBuildNumber: '1',
          now: DateTime(2026, 8, 1),
        );
        expect(first.wasCreated, isTrue);
        expect(
          (await service.createIfNeeded(
            database: db,
            directory: dir,
            appVersion: '1',
            appBuildNumber: '1',
            now: DateTime(2026, 8, 1),
          )).wasCreated,
          isFalse,
        );
        for (var day = 2; day <= 9; day++) {
          await service.createIfNeeded(
            database: db,
            directory: dir,
            appVersion: '1',
            appBuildNumber: '1',
            now: DateTime(2026, 8, day),
          );
        }
        await File(
          p.join(dir.path, 'manual.obraia-backup'),
        ).writeAsString('manual');
        expect(
          dir
              .listSync()
              .whereType<File>()
              .where((f) => p.basename(f.path).startsWith('obraia-auto-'))
              .length,
          7,
        );
        expect(
          await File(p.join(dir.path, 'manual.obraia-backup')).exists(),
          isTrue,
        );
      } finally {
        await db.close();
        await root.delete(recursive: true);
      }
    },
  );
}

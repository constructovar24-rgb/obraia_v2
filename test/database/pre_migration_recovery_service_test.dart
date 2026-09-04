import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/pre_migration_recovery_service.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

void main() {
  test(
    'crea recuperaciones v22 válidas, distintas y no sobrescritas',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'obraia-recovery-',
      );
      addTearDown(() => directory.delete(recursive: true));
      final source = File(p.join(directory.path, 'obraia.sqlite'));
      final raw = sqlite3.open(source.path);
      raw.execute(
        'CREATE TABLE dato (id TEXT PRIMARY KEY, valor TEXT NOT NULL)',
      );
      raw.execute("INSERT INTO dato VALUES ('id','conservar')");
      raw.userVersion = 22;
      raw.close();

      const service = PreMigrationRecoveryService();
      final first = await service.protectV22(source);
      await Future<void>.delayed(const Duration(milliseconds: 1));
      final second = await service.protectV22(source);

      expect(first, isNotNull);
      expect(second, isNotNull);
      expect(first!.path, isNot(second!.path));
      for (final recovery in [first, second]) {
        expect(await recovery.exists(), isTrue);
        final recovered = sqlite3.open(recovery.path, mode: OpenMode.readOnly);
        expect(recovered.userVersion, 22);
        expect(
          recovered.select('SELECT valor FROM dato').single['valor'],
          'conservar',
        );
        recovered.close();
      }
    },
  );

  test('no crea recuperación para una versión distinta de v22', () async {
    final directory = await Directory.systemTemp.createTemp(
      'obraia-no-recovery-',
    );
    addTearDown(() => directory.delete(recursive: true));
    final source = File(p.join(directory.path, 'obraia.sqlite'));
    final raw = sqlite3.open(source.path);
    raw.userVersion = 23;
    raw.close();

    expect(
      await const PreMigrationRecoveryService().protectV22(source),
      isNull,
    );
    expect(
      Directory(p.join(directory.path, 'migration-recovery')).existsSync(),
      isFalse,
    );
  });

  test('protege una base v23 antes de migrar a v24', () async {
    final directory = await Directory.systemTemp.createTemp(
      'obraia-pre-migration-v23-',
    );
    addTearDown(() => directory.delete(recursive: true));
    final source = File(p.join(directory.path, 'obraia.sqlite'));
    final raw = sqlite3.open(source.path);
    raw.execute('CREATE TABLE ejemplo (id TEXT PRIMARY KEY)');
    raw.execute("INSERT INTO ejemplo VALUES ('dato')");
    raw.userVersion = 23;
    raw.close();

    final recovery = await const PreMigrationRecoveryService()
        .protectBeforeUpgrade(source);

    expect(recovery, isNotNull);
    expect(p.basename(recovery!.path), startsWith('obraia-v23-'));
    final copy = sqlite3.open(recovery.path, mode: OpenMode.readOnly);
    expect(copy.userVersion, 23);
    expect(copy.select('SELECT id FROM ejemplo').single['id'], 'dato');
    copy.close();
  });
}

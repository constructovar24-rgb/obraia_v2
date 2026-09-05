import 'dart:io';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

void main() {
  test('migra v27 a v28 sin fabricar cierres ni estados legacy', () async {
    final directory = await Directory.systemTemp.createTemp(
      'obraia-v27-close-',
    );
    addTearDown(() => directory.delete(recursive: true));
    final file = File(p.join(directory.path, 'obraia.sqlite'));
    final current = AppDatabase.forTesting(NativeDatabase(file));
    await current.ensureReady();
    await current.expedientesDao.insertarExpediente(
      ExpedientesCompanion.insert(id: 'obra', codigo: 'OBR', nombre: 'Legacy'),
    );
    await current.close();
    final raw = sqlite3.open(file.path);
    raw.execute('DROP TABLE reaperturas_economicas_obra');
    raw.execute('DROP TABLE cierres_economicos_obra');
    raw.execute('DROP TABLE estados_economicos_obra');
    raw.userVersion = 27;
    raw.close();
    final migrated = AppDatabase.forTesting(NativeDatabase(file));
    addTearDown(migrated.close);
    await migrated.ensureReady();
    expect(migrated.schemaVersion, 29);
    expect(await migrated.cierreEconomicoDao.obtenerEstado('obra'), null);
    expect(await migrated.cierreEconomicoDao.obtenerCierres('obra'), isEmpty);
    expect(
      await migrated.customSelect('PRAGMA foreign_key_check').get(),
      isEmpty,
    );
  });
}

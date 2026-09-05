import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

void main() {
  test('migra v25 a v26 sin fabricar personas, tarifas ni partes', () async {
    final directory = await Directory.systemTemp.createTemp(
      'obraia-v25-labor-',
    );
    addTearDown(() => directory.delete(recursive: true));
    final file = File(p.join(directory.path, 'obraia.sqlite'));
    final current = AppDatabase.forTesting(NativeDatabase(file));
    await current.ensureReady();
    await current.expedientesDao.insertarExpediente(
      ExpedientesCompanion.insert(
        id: 'obra',
        codigo: 'OBR',
        nombre: 'Obra legacy',
      ),
    );
    await current.close();

    final raw = sqlite3.open(file.path);
    raw.execute('DROP TABLE partes_trabajo');
    raw.execute('DROP TABLE tarifas_persona');
    raw.execute('DROP TABLE personas_laborales');
    raw.userVersion = 25;
    raw.close();

    final migrated = AppDatabase.forTesting(NativeDatabase(file));
    addTearDown(migrated.close);
    await migrated.ensureReady();
    expect(migrated.schemaVersion, 29);
    expect(
      (await migrated.expedientesDao.obtenerExpediente('obra'))!.nombre,
      'Obra legacy',
    );
    expect(await migrated.manoObraDao.observarPersonas().first, isEmpty);
    expect(await migrated.manoObraDao.obtenerPartesObra('obra'), isEmpty);
    expect(
      await migrated.customSelect('PRAGMA foreign_key_check').get(),
      isEmpty,
    );
    await migrated.close();
    final reopened = AppDatabase.forTesting(NativeDatabase(file));
    addTearDown(reopened.close);
    await reopened.ensureReady();
    expect(reopened.schemaVersion, 29);
  });
}

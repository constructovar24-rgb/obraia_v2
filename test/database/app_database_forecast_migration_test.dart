import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

void main() {
  test('migra v26 a v27 sin fabricar compromisos ni estimaciones', () async {
    final directory = await Directory.systemTemp.createTemp(
      'obraia-v26-forecast-',
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
    raw.execute('DROP TABLE aplicaciones_compromiso_coste');
    raw.execute('DROP TABLE estimaciones_coste_restante');
    raw.execute('DROP TABLE compromisos_economicos');
    raw.userVersion = 26;
    raw.close();

    final migrated = AppDatabase.forTesting(NativeDatabase(file));
    addTearDown(migrated.close);
    await migrated.ensureReady();
    expect(migrated.schemaVersion, 30);
    expect(
      (await migrated.expedientesDao.obtenerExpediente('obra'))!.nombre,
      'Legacy',
    );
    expect(
      await migrated.previsionEconomicaDao.obtenerCompromisos('obra'),
      isEmpty,
    );
    expect(
      await migrated.previsionEconomicaDao.obtenerEstimaciones('obra'),
      isEmpty,
    );
    expect(
      await migrated.customSelect('PRAGMA foreign_key_check').get(),
      isEmpty,
    );
  });
}

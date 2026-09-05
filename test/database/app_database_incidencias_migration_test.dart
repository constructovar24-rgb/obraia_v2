import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:path/path.dart' as p;

void main() {
  test('migra v30 a v31 sin inventar incidencias legacy', () async {
    final directory = await Directory.systemTemp.createTemp('obraia_inc_');
    addTearDown(() => directory.delete(recursive: true));
    final file = File(p.join(directory.path, 'legacy.sqlite'));
    var db = AppDatabase.forTesting(NativeDatabase(file));
    await db.ensureReady();
    await db.expedientesDao.insertarExpediente(
      ExpedientesCompanion.insert(id: 'obra', codigo: 'OBR', nombre: 'Legacy'),
    );
    await db.close();

    final legacy = AppDatabase.forTesting(NativeDatabase(file));
    await legacy.customStatement('DROP TABLE incidencia_diario');
    await legacy.customStatement('DROP TABLE incidencia_documentos');
    await legacy.customStatement('DROP TABLE incidencias_obra');
    await legacy.customStatement('PRAGMA user_version = 30');
    await legacy.close();

    db = AppDatabase.forTesting(NativeDatabase(file));
    await db.ensureReady();
    expect(db.schemaVersion, 32);
    expect(await db.incidenciasObraDao.observarPorObra('obra').first, isEmpty);
    expect((await db.customSelect('PRAGMA foreign_key_check').get()), isEmpty);
    await db.close();
  });
}

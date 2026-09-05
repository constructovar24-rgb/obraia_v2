import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:path/path.dart' as p;

void main() {
  test('migra v28 a v29 sin inventar planificación legacy', () async {
    final directory = await Directory.systemTemp.createTemp('obraia_plan_');
    addTearDown(() => directory.delete(recursive: true));
    final file = File(p.join(directory.path, 'legacy.sqlite'));
    var db = AppDatabase.forTesting(NativeDatabase(file));
    await db.ensureReady();
    await db.expedientesDao.insertarExpediente(
      ExpedientesCompanion.insert(id: 'obra', codigo: 'OBR', nombre: 'Legacy'),
    );
    await db.close();

    final raw = NativeDatabase(file);
    final legacy = AppDatabase.forTesting(raw);
    await legacy.customStatement('DROP TABLE actuaciones_obra');
    for (final column in const [
      'estado_operativo',
      'fecha_inicio_prevista',
      'fecha_fin_prevista',
      'fecha_inicio_real',
      'fecha_fin_real',
    ]) {
      await legacy.customStatement(
        'ALTER TABLE expedientes DROP COLUMN $column',
      );
    }
    await legacy.customStatement('PRAGMA user_version = 28');
    await legacy.close();

    db = AppDatabase.forTesting(NativeDatabase(file));
    await db.ensureReady();
    expect(db.schemaVersion, 30);
    final row = await db.planificacionObraDao.obtenerPlanificacion('obra');
    expect(row!.estadoOperativo, 'pendiente');
    expect(row.fechaInicioPrevista, isNull);
    expect(row.fechaFinPrevista, isNull);
    expect(row.fechaInicioReal, isNull);
    expect(row.fechaFinReal, isNull);
    expect(await db.planificacionObraDao.obtenerActuaciones('obra'), isEmpty);
    expect((await db.customSelect('PRAGMA foreign_key_check').get()), isEmpty);
    await db.close();
  });
}

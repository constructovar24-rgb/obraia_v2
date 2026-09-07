import 'dart:io';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/features/presupuestos/data/presupuesto_repository.dart';
import 'package:obraia_v2/features/presupuestos/data/presupuesto_documental_repository.dart';
import 'package:obraia_v2/features/presupuestos/domain/estado_presupuesto.dart';
import '../features/presupuestos/data/prod2_test_support.dart';

void main() {
  test(
    'v32 a v33 conserva borradores, aceptados, duplicados y plan sin inventar documentos',
    () async {
      final dir = await Directory.systemTemp.createTemp(
        'obraia-prod2-migration-',
      );
      addTearDown(() => dir.delete(recursive: true));
      final file = File('${dir.path}/legacy.sqlite');
      var db = AppDatabase.forTesting(NativeDatabase(file));
      final accepted = await crearPropuestaPrueba(db);
      await PresupuestoRepository(db).aceptarPresupuesto(accepted);
      final draft = await crearPropuestaPrueba(db, suffix: '-draft');

      // Reconstruye el esquema anterior en una base temporal; no usa datos locales.
      final triggers = await db
          .customSelect(
            "SELECT name FROM sqlite_master WHERE type = 'trigger' AND (name LIKE 'presupuesto_%' OR name LIKE 'documento_presupuesto_%' OR name LIKE 'partida_presupuesto_congelado_%')",
          )
          .get();
      for (final trigger in triggers) {
        final name = trigger.read<String>('name');
        await db.customStatement('DROP TRIGGER "$name"');
      }
      await db.customStatement('DROP TABLE presupuesto_documentos_aceptados');
      await db.customStatement('DROP INDEX presupuestos_tenant_codigo_idx');
      await db.customStatement(
        'UPDATE presupuestos SET codigo = ? WHERE id = ?',
        ['EXP-P01', draft],
      );
      final tables = [
        'presupuestos',
        'lineas_presupuesto',
        'planes_economicos',
        'plan_economico_partidas',
        'clientes',
        'empresa_configuracion',
        'timeline_events',
      ];
      final before = <String, List<Map<String, dynamic>>>{};
      for (final table in tables) {
        before[table] =
            (await db.customSelect('SELECT * FROM $table ORDER BY rowid').get())
                .map((r) => r.data)
                .toList();
      }
      await db.customStatement('PRAGMA user_version = 32');
      await db.close();

      db = AppDatabase.forTesting(NativeDatabase(file));
      try {
        await db.ensureReady();
        expect(db.schemaVersion, 36);
        expect(
          (await db.customSelect('PRAGMA user_version').getSingle()).read<int>(
            'user_version',
          ),
          36,
        );
        for (final table in tables) {
          expect(
            (await db.customSelect('SELECT * FROM $table ORDER BY rowid').get())
                .map((r) => r.data)
                .toList(),
            before[table],
            reason: table,
          );
        }
        expect(
          await db.select(db.presupuestoDocumentosAceptados).get(),
          isEmpty,
        );
        expect(
          await db.customSelect('PRAGMA foreign_key_check').get(),
          isEmpty,
        );
        await expectLater(
          PresupuestoDocumentalRepository(db).obtenerPdf(accepted),
          throwsA(isA<EstadoPresupuestoException>()),
        );
        await expectLater(
          db.presupuestosDao.actualizarIvaPorcentaje(accepted, 10),
          throwsA(isA<EstadoPresupuestoException>()),
        );
        await expectLater(
          PresupuestoRepository(db).aceptarPresupuesto(draft),
          throwsA(isA<EstadoPresupuestoException>()),
        );
        await db.presupuestosDao.actualizarIvaPorcentaje(draft, 10);
        expect(
          (await db.presupuestosDao.obtenerPorId(draft))!.ivaPorcentaje,
          10,
        );
      } finally {
        await db.close();
      }
    },
  );
}

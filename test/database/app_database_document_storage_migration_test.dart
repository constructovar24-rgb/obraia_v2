import 'dart:io';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';

void main() {
  test(
    'v35 a v36 conserva históricos externos sin copiar ni fabricar protección',
    () async {
      final dir = await Directory.systemTemp.createTemp(
        'obraia-prod5-migration-',
      );
      final file = File('${dir.path}/migration.sqlite');
      var db = AppDatabase.forTesting(NativeDatabase(file));
      try {
        await db.expedientesDao.insertarExpediente(
          ExpedientesCompanion.insert(
            id: 'obra',
            codigo: 'TEST',
            nombre: 'Ficticia',
          ),
        );
        await db.documentosDao.insertarDocumento(
          DocumentosCompanion.insert(
            id: 'legacy',
            expedienteId: 'obra',
            titulo: 'Original histórico',
            nombreArchivo: 'historia.pdf',
            rutaArchivo: 'Z:/ficticio/historia.pdf',
            tamanoBytes: 123,
          ),
        );
        for (final column in [
          'ruta_gestionada',
          'sha256_original',
          'incorporado_utc',
        ]) {
          await db.customStatement(
            'ALTER TABLE documentos DROP COLUMN $column',
          );
        }
        final before = (await db.customSelect('SELECT * FROM documentos').get())
            .single
            .data;
        await db.customStatement('PRAGMA user_version=35');
        await db.close();
        db = AppDatabase.forTesting(NativeDatabase(file));
        await db.ensureReady();
        expect(db.schemaVersion, 36);
        final after = (await db.customSelect('SELECT * FROM documentos').get())
            .single
            .data;
        for (final entry in before.entries) {
          expect(after[entry.key], entry.value, reason: entry.key);
        }
        expect(after['ruta_gestionada'], isNull);
        expect(after['sha256_original'], isNull);
        expect(after['incorporado_utc'], isNull);
        expect(
          await db.customSelect('PRAGMA foreign_key_check').get(),
          isEmpty,
        );
      } finally {
        await db.close();
        await dir.delete(recursive: true);
      }
    },
  );
}

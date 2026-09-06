import 'dart:io';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/features/circuito_proveedor/data/circuito_proveedor_repository.dart';
import 'package:obraia_v2/features/circuito_proveedor/domain/circuito_proveedor.dart';
import 'package:obraia_v2/features/backup/data/backup_archive_service.dart';
import 'package:obraia_v2/features/backup/data/backup_restore_staging_service.dart';

void main() {
  test(
    '34 a 35 preserva todas las filas históricas; backup conserva control y reversión',
    () async {
      final dir = await Directory.systemTemp.createTemp(
        'obraia-prod4-migration-',
      );
      var db = AppDatabase.forTesting(
        NativeDatabase(File('${dir.path}/test.sqlite')),
      );
      try {
        await db.ensureReady();
        await db.proveedoresDao.insertarProveedor(
          ProveedoresCompanion.insert(id: 'p', nombre: 'Ficticio'),
        );
        final repo = CircuitoProveedorRepository(db);
        final id = await repo.crearFactura(
          FacturaRecibidaInput(
            proveedorId: 'p',
            numero: 'PRUEBA',
            fecha: DateTime(2025),
            baseCentimos: 1000,
            ivaCentimos: 210,
            asignaciones: [const AsignacionImporteInput(importeCentimos: 1000)],
          ),
        );
        await repo.consolidarFactura(id);
        await repo.verificarPago(id, motivo: 'Prueba');
        final pago = await repo.registrarPago(
          facturaId: id,
          fecha: DateTime(2025),
          importeCentimos: 100,
        );
        final triggers = await db
            .customSelect(
              "SELECT name FROM sqlite_master WHERE type='trigger' AND name LIKE 'prod4_%'",
            )
            .get();
        for (final t in triggers) {
          await db.customStatement('DROP TRIGGER "${t.read<String>('name')}"');
        }
        for (final t in [
          'reversiones_pagos_proveedor',
          'eventos_proveedor',
          'control_facturas_proveedor',
        ]) {
          await db.customStatement('DROP TABLE $t');
        }
        final tables =
            (await db
                    .customSelect(
                      "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%' ORDER BY name",
                    )
                    .get())
                .map((r) => r.read<String>('name'))
                .toList();
        final before = <String, List<Map<String, dynamic>>>{};
        for (final t in tables) {
          before[t] =
              (await db.customSelect('SELECT * FROM "$t" ORDER BY rowid').get())
                  .map((r) => r.data)
                  .toList();
        }
        await db.customStatement('PRAGMA user_version=34');
        await db.close();
        db = AppDatabase.forTesting(
          NativeDatabase(File('${dir.path}/test.sqlite')),
        );
        await db.ensureReady();
        expect(db.schemaVersion, 35);
        for (final t in tables) {
          expect(
            (await db.customSelect('SELECT * FROM "$t" ORDER BY rowid').get())
                .map((r) => r.data)
                .toList(),
            before[t],
            reason: t,
          );
        }
        expect(await db.select(db.controlFacturasProveedor).get(), isEmpty);
        expect(
          await db.customSelect('PRAGMA foreign_key_check').get(),
          isEmpty,
        );
        final current = CircuitoProveedorRepository(db);
        expect((await current.listarFichas()).single['pagado'], 100);
        await current.revertirPagoProveedor(
          pago,
          motivo: 'Error ficticio conservado',
        );
        final backup = File('${dir.path}/test.obraia-backup');
        await BackupArchiveService().createBackup(
          database: db,
          destinationPath: backup.path,
          appVersion: 'test',
          appBuildNumber: '1',
        );
        final prepared = await BackupRestoreStagingService().prepare(
          backupPath: backup.path,
          currentSchemaVersion: 35,
        );
        try {
          final restored = AppDatabase.forTesting(
            NativeDatabase(prepared.preparedDatabaseFile),
          );
          try {
            final ficha = (await CircuitoProveedorRepository(
              restored,
            ).listarFichas()).single;
            expect(ficha['pagado'], 0);
            expect((ficha['pagos'] as List).single['revertido'], true);
            expect(ficha['eventos'], isNotEmpty);
            expect(
              await restored.customSelect('PRAGMA foreign_key_check').get(),
              isEmpty,
            );
          } finally {
            await restored.close();
          }
        } finally {
          await prepared.dispose();
        }
      } finally {
        await db.close();
        await dir.delete(recursive: true);
      }
    },
  );
}

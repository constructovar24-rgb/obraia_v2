import 'dart:io';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/features/presupuestos/data/presupuesto_repository.dart';
import 'package:obraia_v2/features/facturas/data/factura_repository.dart';
import 'package:obraia_v2/features/facturas/data/rectificativa_repository.dart';
import 'package:obraia_v2/features/facturas/domain/rectificativa.dart';
import '../features/presupuestos/data/prod2_test_support.dart';
import '../support/fiscal_test_support.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'v33 a v34 conserva todas las filas, presupuesto, FAC/RECT, snapshots y PDFs sin configurar series',
    () async {
      final dir = await Directory.systemTemp.createTemp(
        'obraia-prod3-migration-',
      );
      addTearDown(() => dir.delete(recursive: true));
      final file = File('${dir.path}/legacy.sqlite');
      var db = AppDatabase.forTesting(NativeDatabase(file));
      final presupuestoId = await crearPropuestaPrueba(db);
      await PresupuestoRepository(db).aceptarPresupuesto(presupuestoId);
      await prepararFiscalPrueba(db);
      final factura = await FacturaRepository(db).convertirDesdePresupuesto(
        (await db.presupuestosDao.observarPorExpediente('obra').first).single,
      );
      await FacturaRepository(db).emitirFactura(factura);
      final linea = (await db.facturaLineasDao.obtenerPorFactura(
        factura,
      )).first;
      final rect = await RectificativaRepository(db).crear(
        facturaRectificadaId: factura,
        motivo: 'Ajuste ficticio',
        ajustes: [
          AjusteRectificativa(lineaRectificadaId: linea.id, baseDiferencia: -1),
        ],
      );
      await RectificativaRepository(db).emitir(rect);
      // Reconstrucción de v33 en temporal: solo se retiran las tablas nuevas.
      await db.customStatement('DROP TABLE eventos_serie_fiscal');
      await db.customStatement('DROP TABLE series_fiscales');
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
      await db.customStatement('PRAGMA user_version = 33');
      await db.close();
      db = AppDatabase.forTesting(NativeDatabase(file));
      try {
        await db.ensureReady();
        expect(db.schemaVersion, 35);
        expect(
          (await db.customSelect('PRAGMA user_version').getSingle()).read<int>(
            'user_version',
          ),
          35,
        );
        for (final t in tables) {
          expect(
            (await db.customSelect('SELECT * FROM "$t" ORDER BY rowid').get())
                .map((r) => r.data)
                .toList(),
            before[t],
            reason: t,
          );
        }
        expect(await db.select(db.seriesFiscales).get(), isEmpty);
        expect(await db.select(db.eventosSerieFiscal).get(), isEmpty);
        expect(
          await db.customSelect('PRAGMA foreign_key_check').get(),
          isEmpty,
        );
        expect(
          await FacturaRepository(db).obtenerPdfEmitido(factura),
          isNotEmpty,
        );
        expect(
          await RectificativaRepository(db).obtenerPdfEmitido(rect),
          isNotEmpty,
        );
      } finally {
        await db.close();
      }
    },
  );
}

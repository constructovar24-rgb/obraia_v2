import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:path/path.dart' as p;

void main() {
  test('migra v31 a v32 sin inventar documentos de proveedor legacy', () async {
    final directory = await Directory.systemTemp.createTemp('obraia_supply_');
    addTearDown(() => directory.delete(recursive: true));
    final file = File(p.join(directory.path, 'legacy.sqlite'));
    var db = AppDatabase.forTesting(NativeDatabase(file));
    await db.ensureReady();
    await db.expedientesDao.insertarExpediente(
      ExpedientesCompanion.insert(id: 'obra', codigo: 'OBR', nombre: 'Legacy'),
    );
    await db.close();
    final legacy = AppDatabase.forTesting(NativeDatabase(file));
    for (final table in const [
      'pagos_proveedor',
      'factura_recibida_compras',
      'asignaciones_factura_recibida',
      'factura_recibida_albaranes',
      'facturas_recibidas',
      'asignaciones_albaran_obra',
      'lineas_albaran_proveedor',
      'albaranes_proveedor',
    ]) {
      await legacy.customStatement('DROP TABLE $table');
    }
    await legacy.customStatement('PRAGMA user_version = 31');
    await legacy.close();
    db = AppDatabase.forTesting(NativeDatabase(file));
    await db.ensureReady();
    expect(db.schemaVersion, 32);
    expect(await db.select(db.albaranesProveedor).get(), isEmpty);
    expect(await db.select(db.facturasRecibidas).get(), isEmpty);
    expect(await db.select(db.pagosProveedor).get(), isEmpty);
    expect(await db.customSelect('PRAGMA foreign_key_check').get(), isEmpty);
    await db.close();
  });
}

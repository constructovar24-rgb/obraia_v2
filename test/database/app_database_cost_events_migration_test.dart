import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

void main() {
  test('migra v24 a v25 sin clasificar Compras legacy como coste', () async {
    final directory = await Directory.systemTemp.createTemp('obraia-v24-cost-');
    addTearDown(() => directory.delete(recursive: true));
    final file = File(p.join(directory.path, 'obraia.sqlite'));
    final current = AppDatabase.forTesting(NativeDatabase(file));
    await current.ensureReady();
    await current.expedientesDao.insertarExpediente(
      ExpedientesCompanion.insert(id: 'obra', codigo: 'OBR', nombre: 'Obra'),
    );
    await current.comprasDao.insertarCompra(
      ComprasCompanion.insert(
        id: 'legacy',
        expedienteId: 'obra',
        proveedorNombre: const Value('Proveedor'),
        concepto: const Value('Compra legacy'),
        baseImponible: const Value(100),
        importeTotal: const Value(121),
        estado: const Value('pagada'),
      ),
    );
    await current.close();

    final raw = sqlite3.open(file.path);
    raw.execute('PRAGMA foreign_keys = OFF');
    raw.execute('DROP TABLE hechos_coste');
    raw.execute('ALTER TABLE compras RENAME TO compras_v25');
    raw.execute('''
      CREATE TABLE compras (
        tenant_id TEXT NOT NULL REFERENCES tenants(id), id TEXT NOT NULL,
        expediente_id TEXT NOT NULL, proveedor_id TEXT NULL,
        proveedor_nombre TEXT NOT NULL DEFAULT '', fecha INTEGER NOT NULL,
        numero_factura TEXT NULL, concepto TEXT NOT NULL DEFAULT '',
        base_imponible REAL NOT NULL DEFAULT 0,
        iva_porcentaje REAL NOT NULL DEFAULT 21,
        importe_total REAL NOT NULL DEFAULT 0, estado TEXT NOT NULL DEFAULT '',
        observaciones TEXT NULL, eliminado INTEGER NOT NULL DEFAULT 0,
        fecha_creacion INTEGER NOT NULL, fecha_modificacion INTEGER NOT NULL,
        PRIMARY KEY (id), UNIQUE (tenant_id, id),
        FOREIGN KEY (tenant_id, expediente_id) REFERENCES expedientes (tenant_id, id),
        FOREIGN KEY (tenant_id, proveedor_id) REFERENCES proveedores (tenant_id, id)
      )
    ''');
    raw.execute('''
      INSERT INTO compras (
        tenant_id,id,expediente_id,proveedor_id,proveedor_nombre,fecha,
        numero_factura,concepto,base_imponible,iva_porcentaje,importe_total,
        estado,observaciones,eliminado,fecha_creacion,fecha_modificacion
      ) SELECT
        tenant_id,id,expediente_id,proveedor_id,proveedor_nombre,fecha,
        numero_factura,concepto,base_imponible,iva_porcentaje,importe_total,
        estado,observaciones,eliminado,fecha_creacion,fecha_modificacion
      FROM compras_v25
    ''');
    raw.execute('DROP TABLE compras_v25');
    raw.userVersion = 24;
    raw.close();

    final migrated = AppDatabase.forTesting(NativeDatabase(file));
    addTearDown(migrated.close);
    await migrated.ensureReady();
    expect(migrated.schemaVersion, 30);
    expect(
      (await migrated.comprasDao.obtenerPorId(
        'legacy',
      ))!.clasificacionEconomica,
      'provisional',
    );
    expect(await migrated.hechosCosteDao.obtenerPorExpediente('obra'), isEmpty);
    expect(
      await migrated.customSelect('PRAGMA foreign_key_check').get(),
      isEmpty,
    );
  });
}

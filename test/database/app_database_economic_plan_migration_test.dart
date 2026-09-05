import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

const _tenantId = '00000000-0000-4000-8000-000000000023';

void main() {
  test('migra v23 a v26 sin inventar planes ni costes legacy', () async {
    final directory = await Directory.systemTemp.createTemp('obraia-v23-v24-');
    addTearDown(() => directory.delete(recursive: true));
    final file = File(p.join(directory.path, 'obraia.sqlite'));
    await _crearV23(file);

    final database = AppDatabase.forTesting(
      NativeDatabase(file),
      tenantId: _tenantId,
    );
    addTearDown(database.close);
    await database.ensureReady();

    expect(database.schemaVersion, 27);
    expect(
      await database.select(database.categoriasEconomicas).get(),
      hasLength(9),
    );
    final configuraciones = await database
        .select(database.configuracionEconomica)
        .get();
    expect(configuraciones, hasLength(1));
    expect(configuraciones.single.porcentajeIndirectos, isNull);
    expect(await database.select(database.planesEconomicos).get(), isEmpty);
    expect(
      (await database.presupuestosDao.obtenerPorId(
        'presupuesto-legacy',
      ))!.estado,
      'Aceptado',
    );
    expect(
      await database.customSelect('PRAGMA foreign_key_check').get(),
      isEmpty,
    );
    final indices = await database
        .customSelect("SELECT name FROM sqlite_master WHERE type='index'")
        .get();
    expect(
      indices.map((row) => row.read<String>('name')),
      contains('planes_tenant_expediente_estado_idx'),
    );
  });
}

Future<void> _crearV23(File file) async {
  final database = AppDatabase.forTesting(
    NativeDatabase(file),
    tenantId: _tenantId,
  );
  await database.ensureReady();
  await database.customStatement(
    "INSERT INTO clientes (tenant_id,id,nombre) VALUES ('$_tenantId','cliente','Cliente')",
  );
  await database.customStatement(
    "INSERT INTO expedientes (tenant_id,id,codigo,nombre,cliente_id) VALUES ('$_tenantId','expediente','EXP','Obra','cliente')",
  );
  await database.customStatement(
    "INSERT INTO presupuestos (tenant_id,id,expediente_id,codigo,importe_total,estado) VALUES ('$_tenantId','presupuesto-legacy','expediente','PRE',100,'Aceptado')",
  );
  await database.close();

  final raw = sqlite3.open(file.path, mode: OpenMode.readWrite);
  try {
    raw.execute('PRAGMA foreign_keys = OFF');
    for (final table in <String>[
      'plan_economico_partidas',
      'planes_economicos',
      'linea_presupuesto_costes_previstos',
      'configuracion_economica',
      'categorias_economicas',
    ]) {
      raw.execute('DROP TABLE $table');
    }
    raw.userVersion = 23;
  } finally {
    raw.close();
  }
}

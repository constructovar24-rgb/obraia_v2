import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

void main() {
  for (final version in [16, 17, 18, 19]) {
    test('migra y conserva cobros desde esquema $version a 19', () async {
      final directory = await Directory.systemTemp.createTemp(
        'obraia-cobros-migration-$version-',
      );
      addTearDown(() => directory.delete(recursive: true));
      final file = File(p.join(directory.path, 'database.sqlite'));
      await _crearBaseActual(file);
      if (version < 19) _degradar(file, version);

      final database = AppDatabase.forTesting(NativeDatabase(file));
      addTearDown(database.close);
      final movimiento = (await database.cobrosDao.obtenerPorFactura(
        'factura',
      )).single;

      expect(database.schemaVersion, 19);
      expect(movimiento.importe, 25.5);
      expect(movimiento.esReversion, isFalse);
      expect(movimiento.cobroOrigenId, isNull);
      expect(movimiento.motivo, isEmpty);
      final versionPersistida = await database
          .customSelect('PRAGMA user_version')
          .getSingle();
      expect(versionPersistida.data.values.single, 19);
    });
  }
}

Future<void> _crearBaseActual(File file) async {
  final database = AppDatabase.forTesting(NativeDatabase(file));
  await database.clientesDao.insertarCliente(
    ClientesCompanion.insert(id: 'cliente', nombre: 'Cliente'),
  );
  await database.customStatement(
    'INSERT INTO facturas (id, cliente_id, total) VALUES (?, ?, ?)',
    ['factura', 'cliente', 121],
  );
  await database.customStatement(
    '''INSERT INTO cobros
       (id, factura_id, importe, metodo_pago, referencia, observaciones)
       VALUES (?, ?, ?, ?, ?, ?)''',
    ['cobro', 'factura', 25.5, 'Transferencia', 'REF', 'Conservar'],
  );
  await database.close();
}

void _degradar(File file, int version) {
  final raw = sqlite3.open(file.path, mode: OpenMode.readWrite);
  try {
    raw.execute('ALTER TABLE cobros DROP COLUMN motivo');
    raw.execute('ALTER TABLE cobros DROP COLUMN cobro_origen_id');
    raw.execute('ALTER TABLE cobros DROP COLUMN tipo_movimiento');
    if (version < 18) {
      raw.execute('DROP INDEX IF EXISTS facturas_numeracion_legal_unica');
      raw.execute('ALTER TABLE lineas_presupuesto DROP COLUMN unidad');
      for (final column in <String>[
        'anio_numeracion',
        'numero_legal',
        'fecha_emision',
        'cliente_nombre_historico',
        'cliente_nif_historico',
        'cliente_direccion_historica',
        'cliente_telefono_historico',
        'cliente_email_historico',
        'empresa_nombre_historico',
        'empresa_cif_historico',
        'empresa_direccion_historica',
        'empresa_codigo_postal_historico',
        'empresa_poblacion_historica',
        'empresa_provincia_historica',
        'empresa_telefono_historico',
        'empresa_email_historico',
        'empresa_web_historica',
        'expediente_origen_id_historico',
        'expediente_codigo_historico',
        'expediente_nombre_historico',
        'presupuesto_codigo_historico',
      ]) {
        raw.execute('ALTER TABLE facturas DROP COLUMN $column');
      }
    }
    if (version < 17) {
      raw.execute('ALTER TABLE facturas DROP COLUMN iva_porcentaje');
    }
    raw.userVersion = version;
  } finally {
    raw.close();
  }
}

import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

const _tenantId = '00000000-0000-4000-8000-000000000023';
const _tablasEmpresariales = <String>[
  'clientes',
  'proveedores',
  'empresa_configuracion',
  'expedientes',
  'presupuestos',
  'lineas_presupuesto',
  'certificaciones',
  'compras',
  'documentos',
  'timeline_events',
  'facturas',
  'factura_lineas',
  'factura_asignaciones_presupuesto',
  'factura_documentos_emitidos',
  'cobros',
  'movimientos_credito_cliente',
];

void main() {
  test('migra una base v22 poblada y preserva todos los dominios', () async {
    final directory = await Directory.systemTemp.createTemp('obraia-v22-full-');
    addTearDown(() => directory.delete(recursive: true));
    final file = File(p.join(directory.path, 'obraia.sqlite'));
    await _crearV22(file, poblada: true);

    final database = AppDatabase.forTesting(
      NativeDatabase(file),
      tenantId: _tenantId,
    );
    addTearDown(database.close);
    await database.ensureReady();

    expect(database.schemaVersion, 26);
    expect(await database.select(database.tenants).get(), hasLength(1));
    for (final tabla in _tablasEmpresariales) {
      final filas = await database
          .customSelect('SELECT tenant_id FROM $tabla')
          .get();
      expect(filas, isNotEmpty, reason: tabla);
      expect(
        filas.every((fila) => fila.read<String>('tenant_id') == _tenantId),
        isTrue,
        reason: tabla,
      );
    }
    final factura = await database
        .customSelect(
          "SELECT codigo, serie, numero_legal, total, cliente_nombre_historico FROM facturas WHERE id = 'fac'",
        )
        .getSingle();
    expect(factura.read<String>('codigo'), 'FAC-2026-0001');
    expect(factura.read<String>('serie'), 'FAC');
    expect(factura.read<int>('numero_legal'), 1);
    expect(factura.read<double>('total'), 121);
    expect(
      factura.read<String>('cliente_nombre_historico'),
      'Cliente histórico',
    );
    final rect = await database
        .customSelect(
          "SELECT serie, factura_rectificada_id, factura_raiz_id FROM facturas WHERE id = 'rect'",
        )
        .getSingle();
    expect(rect.read<String>('serie'), 'RECT');
    expect(rect.read<String>('factura_rectificada_id'), 'fac');
    expect(rect.read<String>('factura_raiz_id'), 'fac');
    expect(
      await database.customSelect('PRAGMA foreign_key_check').get(),
      isEmpty,
    );
  });

  test('migra una base v22 vacía y crea un único tenant neutral', () async {
    final directory = await Directory.systemTemp.createTemp(
      'obraia-v22-empty-',
    );
    addTearDown(() => directory.delete(recursive: true));
    final file = File(p.join(directory.path, 'obraia.sqlite'));
    await _crearV22(file, poblada: false);

    final database = AppDatabase.forTesting(
      NativeDatabase(file),
      tenantId: _tenantId,
    );
    addTearDown(database.close);
    await database.ensureReady();

    final tenants = await database.select(database.tenants).get();
    expect(tenants, hasLength(1));
    expect(tenants.single.nombre, 'Empresa inicial');
    expect(
      await database.customSelect('PRAGMA foreign_key_check').get(),
      isEmpty,
    );
  });

  test('una anomalia legacy aborta sin dejar migracion parcial', () async {
    final directory = await Directory.systemTemp.createTemp(
      'obraia-v22-failure-',
    );
    addTearDown(() => directory.delete(recursive: true));
    final file = File(p.join(directory.path, 'obraia.sqlite'));
    await _crearV22(file, poblada: false);
    final raw = sqlite3.open(file.path);
    raw.execute(
      "INSERT INTO empresa_configuracion (id,nombre_empresa) VALUES ('a','A'),('b','B')",
    );
    raw.close();

    final database = AppDatabase.forTesting(
      NativeDatabase(file),
      tenantId: _tenantId,
    );
    await expectLater(database.ensureReady(), throwsA(isA<StateError>()));
    await database.close();

    final checked = sqlite3.open(file.path, mode: OpenMode.readOnly);
    expect(checked.userVersion, 22);
    expect(
      checked.select(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='tenants'",
      ),
      isEmpty,
    );
    checked.close();
  });
}

Future<void> _crearV22(File file, {required bool poblada}) async {
  final database = AppDatabase.forTesting(
    NativeDatabase(file),
    tenantId: _tenantId,
  );
  await database.ensureReady();
  if (poblada) {
    await database.transaction(() async {
      for (final sql in <String>[
        "INSERT INTO empresa_configuracion (tenant_id,id,nombre_empresa,cif) VALUES ('$_tenantId','cfg','Empresa migrada','B123')",
        "INSERT INTO clientes (tenant_id,id,nombre) VALUES ('$_tenantId','cli','Cliente')",
        "INSERT INTO proveedores (tenant_id,id,nombre) VALUES ('$_tenantId','pro','Proveedor')",
        "INSERT INTO expedientes (tenant_id,id,codigo,nombre,cliente,cliente_id) VALUES ('$_tenantId','exp','EXP','Obra','','cli')",
        "INSERT INTO presupuestos (tenant_id,id,expediente_id,codigo,importe_total,estado) VALUES ('$_tenantId','pre','exp','PRE',100,'Aceptado')",
        "INSERT INTO lineas_presupuesto (tenant_id,id,presupuesto_id,concepto,cantidad,precio_unitario) VALUES ('$_tenantId','lpre','pre','Partida',1,100)",
        "INSERT INTO certificaciones (tenant_id,id,expediente_id,presupuesto_id,codigo,importe_total) VALUES ('$_tenantId','cert','exp','pre','CERT-1',50)",
        "INSERT INTO compras (tenant_id,id,expediente_id,proveedor_id,concepto,importe_total) VALUES ('$_tenantId','com','exp','pro','Material',30)",
        "INSERT INTO documentos (tenant_id,id,expediente_id,titulo,nombre_archivo,ruta_archivo,tamano_bytes) VALUES ('$_tenantId','doc','exp','Plano','plano.pdf','plano.pdf',2)",
        "INSERT INTO timeline_events (tenant_id,id,expediente_id,tipo,titulo,descripcion) VALUES ('$_tenantId','tim','exp','sistema','Inicio','Obra iniciada')",
        "INSERT INTO facturas (tenant_id,id,codigo,cliente_id,subtotal,iva,total,tipo_documento,serie,anio_numeracion,numero_legal,cliente_nombre_historico) VALUES ('$_tenantId','fac','FAC-2026-0001','cli',100,21,121,'factura','FAC',2026,1,'Cliente histórico')",
        "INSERT INTO factura_lineas (tenant_id,id,factura_id,descripcion,cantidad,precio_unitario,importe) VALUES ('$_tenantId','lfac','fac','Partida',1,100,100)",
        "INSERT INTO facturas (tenant_id,id,codigo,cliente_id,subtotal,iva,total,tipo_documento,serie,anio_numeracion,numero_legal,factura_rectificada_id,factura_raiz_id) VALUES ('$_tenantId','rect','RECT-2026-0001','cli',-10,-2.1,-12.1,'rectificativa','RECT',2026,1,'fac','fac')",
        "INSERT INTO factura_asignaciones_presupuesto (tenant_id,id,factura_id,factura_linea_id,presupuesto_id,linea_presupuesto_id,base_aplicada) VALUES ('$_tenantId','asi','fac','lfac','pre','lpre',100)",
        "INSERT INTO factura_documentos_emitidos (tenant_id,factura_id,pdf,sha256) VALUES ('$_tenantId','fac',X'0102','hash')",
        "INSERT INTO cobros (tenant_id,id,factura_id,importe) VALUES ('$_tenantId','cob','fac',20)",
        "INSERT INTO movimientos_credito_cliente (tenant_id,id,cliente_id,factura_raiz_origen_id,tipo_movimiento,importe,fecha,motivo) VALUES ('$_tenantId','cre','cli','fac','devolucion',5,0,'Prueba')",
      ]) {
        await database.customStatement(sql);
      }
    });
  }
  await database.close();

  final raw = sqlite3.open(file.path, mode: OpenMode.readWrite);
  try {
    raw.execute('PRAGMA foreign_keys = OFF');
    for (final tabla in _tablasEmpresariales.reversed) {
      final columnas = raw
          .select('PRAGMA table_info($tabla)')
          .map((fila) => fila['name'] as String)
          .where((nombre) => nombre != 'tenant_id')
          .toList();
      final lista = columnas.map((nombre) => '"$nombre"').join(',');
      raw.execute('CREATE TABLE "${tabla}_v22" AS SELECT $lista FROM "$tabla"');
      raw.execute('DROP TABLE "$tabla"');
      raw.execute('ALTER TABLE "${tabla}_v22" RENAME TO "$tabla"');
    }
    raw.execute('DROP TABLE tenants');
    raw.userVersion = 22;
  } finally {
    raw.close();
  }
}

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';

void main() {
  test('migra IVA legacy sin recalcular importes históricos', () async {
    final executor = NativeDatabase.memory(
      setup: (rawDatabase) {
        rawDatabase.execute('''
          CREATE TABLE facturas (
            id TEXT NOT NULL PRIMARY KEY,
            codigo TEXT NOT NULL DEFAULT '',
            cliente_id TEXT NOT NULL,
            fecha INTEGER NOT NULL,
            fecha_vencimiento INTEGER NOT NULL,
            estado TEXT NOT NULL DEFAULT 'borrador',
            subtotal REAL NOT NULL DEFAULT 0,
            iva REAL NOT NULL DEFAULT 0,
            total REAL NOT NULL DEFAULT 0,
            observaciones TEXT NOT NULL DEFAULT '',
            presupuesto_origen_id TEXT,
            fecha_creacion INTEGER NOT NULL,
            fecha_modificacion INTEGER NOT NULL
          )
        ''');
        rawDatabase.execute('''
          INSERT INTO facturas (
            id, cliente_id, fecha, fecha_vencimiento, subtotal, iva, total,
            fecha_creacion, fecha_modificacion
          ) VALUES
            ('con-base', 'c1', 0, 0, 80, 8, 88, 0, 0),
            ('sin-base', 'c1', 0, 0, 0, 3, 3, 0, 0)
        ''');
        rawDatabase.execute('''
          CREATE TABLE lineas_presupuesto (
            id TEXT NOT NULL PRIMARY KEY,
            presupuesto_id TEXT NOT NULL,
            concepto TEXT NOT NULL,
            cantidad REAL NOT NULL,
            precio_unitario REAL NOT NULL,
            importe REAL NOT NULL DEFAULT 0,
            orden INTEGER NOT NULL DEFAULT 0,
            fecha_creacion INTEGER NOT NULL DEFAULT 0,
            fecha_modificacion INTEGER NOT NULL DEFAULT 0
          )
        ''');
        rawDatabase.execute('''
          CREATE TABLE cobros (
            id TEXT NOT NULL PRIMARY KEY,
            factura_id TEXT NOT NULL REFERENCES facturas(id),
            fecha INTEGER NOT NULL DEFAULT 0,
            importe REAL NOT NULL DEFAULT 0,
            metodo_pago TEXT NOT NULL DEFAULT 'Transferencia',
            referencia TEXT NOT NULL DEFAULT '',
            observaciones TEXT NOT NULL DEFAULT '',
            fecha_creacion INTEGER NOT NULL DEFAULT 0,
            fecha_modificacion INTEGER NOT NULL DEFAULT 0
          )
        ''');
        rawDatabase.execute('''
          CREATE TABLE factura_lineas (
            id TEXT NOT NULL PRIMARY KEY,
            factura_id TEXT NOT NULL REFERENCES facturas(id),
            descripcion TEXT NOT NULL,
            cantidad REAL NOT NULL,
            unidad TEXT NOT NULL DEFAULT 'ud',
            precio_unitario REAL NOT NULL,
            descuento REAL NOT NULL DEFAULT 0,
            importe REAL NOT NULL DEFAULT 0
          )
        ''');
        rawDatabase.userVersion = 16;
      },
    );
    final database = AppDatabase.forTesting(executor);
    addTearDown(database.close);

    final rows = await database.customSelect('''
      SELECT id, subtotal, iva, total, iva_porcentaje,
        cliente_nombre_historico, numero_legal
      FROM facturas ORDER BY id
    ''').get();

    expect(rows[0].read<String>('id'), 'con-base');
    expect(rows[0].read<double>('iva_porcentaje'), 10);
    expect(rows[0].read<double>('subtotal'), 80);
    expect(rows[0].read<double>('iva'), 8);
    expect(rows[0].read<double>('total'), 88);
    expect(rows[1].read<String>('id'), 'sin-base');
    expect(rows[1].read<double>('iva_porcentaje'), 21);
    expect(rows[1].read<double>('subtotal'), 0);
    expect(rows[1].read<double>('iva'), 3);
    expect(rows[1].read<double>('total'), 3);
    expect(rows[0].read<String>('cliente_nombre_historico'), isEmpty);
    expect(rows[0].read<int?>('numero_legal'), isNull);
  });
}

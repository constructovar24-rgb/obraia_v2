import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/features/facturas/data/factura_linea_repository.dart';
import 'package:obraia_v2/features/facturas/data/factura_repository.dart';

void main() {
  late AppDatabase database;
  late FacturaRepository facturas;
  late FacturaLineaRepository lineas;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    facturas = FacturaRepository(database);
    lineas = FacturaLineaRepository(database);
    await database.clientesDao.insertarCliente(
      ClientesCompanion.insert(id: 'cliente-1', nombre: 'Cliente'),
    );
    await database.expedientesDao.insertarExpediente(
      ExpedientesCompanion.insert(
        id: 'expediente-1',
        codigo: 'EXP-1',
        nombre: 'Obra',
        clienteId: const Value('cliente-1'),
      ),
    );
  });

  tearDown(() => database.close());

  Future<String> crearPresupuesto(double ivaPorcentaje, String sufijo) async {
    final id = 'presupuesto-$sufijo';
    await database.presupuestosDao.insertarPresupuesto(
      PresupuestosCompanion.insert(
        id: id,
        expedienteId: 'expediente-1',
        codigo: Value('PRE-$sufijo'),
        importeTotal: const Value(100),
        ivaPorcentaje: Value(ivaPorcentaje),
        estado: const Value('Aceptado'),
      ),
    );
    await database.lineasPresupuestoDao.insertarLinea(
      LineasPresupuestoCompanion.insert(
        id: 'linea-$sufijo',
        presupuestoId: id,
        concepto: 'Trabajo',
        cantidad: 1,
        precioUnitario: 100,
      ),
    );
    return id;
  }

  test('factura manual nueva persiste IVA 21 %', () async {
    final id = await facturas.crearFactura(
      clienteId: 'cliente-1',
      fecha: DateTime(2026, 8, 27),
      fechaVencimiento: DateTime(2026, 9, 27),
    );

    final factura = await database.facturasDao.obtenerPorId(id);
    expect(factura?.ivaPorcentaje, 21);
    expect(factura?.iva, 0);
    expect(factura?.total, 0);
  });

  for (final ivaPorcentaje in [0.0, 4.0, 10.0, 21.0, 7.5]) {
    test('conversión conserva IVA $ivaPorcentaje %', () async {
      final presupuestoId = await crearPresupuesto(
        ivaPorcentaje,
        ivaPorcentaje.toString(),
      );
      final presupuesto =
          (await database.presupuestosDao.observarPresupuestos().first)
              .singleWhere((item) => item.id == presupuestoId);

      final facturaId = await facturas.convertirDesdePresupuesto(presupuesto);
      final factura = await database.facturasDao.obtenerPorId(facturaId);

      expect(factura?.ivaPorcentaje, ivaPorcentaje);
      expect(factura?.subtotal, 100);
      expect(factura?.iva, 100 * ivaPorcentaje / 100);
      expect(factura?.total, 100 + 100 * ivaPorcentaje / 100);
    });
  }

  test('alta, edición y eliminación conservan el IVA de la factura', () async {
    final presupuestoId = await crearPresupuesto(10, 'lineas');
    final presupuesto =
        (await database.presupuestosDao.observarPresupuestos().first)
            .singleWhere((item) => item.id == presupuestoId);
    final facturaId = await facturas.convertirDesdePresupuesto(presupuesto);

    await lineas.crearLinea(
      facturaId: facturaId,
      descripcion: 'Extra',
      cantidad: 1,
      unidad: 'ud',
      precioUnitario: 50,
      descuento: 0,
    );
    var factura = await database.facturasDao.obtenerPorId(facturaId);
    expect(factura?.ivaPorcentaje, 10);
    expect(factura?.iva, 15);

    final actuales = await database.facturaLineasDao.obtenerPorFactura(
      facturaId,
    );
    final original = actuales.firstWhere(
      (linea) => linea.descripcion == 'Trabajo',
    );
    final extra = actuales.firstWhere((linea) => linea.descripcion == 'Extra');
    await lineas.actualizarLinea(
      id: original.id,
      facturaId: facturaId,
      descripcion: 'Trabajo editado',
      cantidad: 2,
      unidad: 'ud',
      precioUnitario: 100,
      descuento: 0,
    );
    factura = await database.facturasDao.obtenerPorId(facturaId);
    expect(factura?.ivaPorcentaje, 10);
    expect(factura?.iva, 25);

    await lineas.eliminarLinea(extra.id, facturaId);
    factura = await database.facturasDao.obtenerPorId(facturaId);
    expect(factura?.ivaPorcentaje, 10);
    expect(factura?.iva, 20);
    expect(factura?.total, 220);
  });

  test('refacturación conserva el IVA del presupuesto', () async {
    final presupuestoId = await crearPresupuesto(7.5, 'refactura');
    final presupuesto =
        (await database.presupuestosDao.observarPresupuestos().first)
            .singleWhere((item) => item.id == presupuestoId);
    final primeraId = await facturas.convertirDesdePresupuesto(presupuesto);
    await facturas.anularFactura(primeraId);

    final segundaId = await facturas.convertirDesdePresupuesto(presupuesto);
    final segunda = await database.facturasDao.obtenerPorId(segundaId);

    expect(segunda?.ivaPorcentaje, 7.5);
    expect(segunda?.iva, 7.5);
    expect(segunda?.total, 107.5);
  });
}

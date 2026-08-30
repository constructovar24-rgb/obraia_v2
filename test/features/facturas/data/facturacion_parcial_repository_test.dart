import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/features/facturas/data/facturacion_parcial_repository.dart';
import 'package:obraia_v2/features/facturas/data/factura_repository.dart';
import 'package:obraia_v2/features/facturas/data/rectificativa_repository.dart';
import 'package:obraia_v2/features/facturas/domain/facturacion_parcial.dart';

void main() {
  late AppDatabase database;
  late FacturacionParcialRepository parciales;
  late FacturaRepository facturas;
  late RectificativaRepository rectificativas;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    parciales = FacturacionParcialRepository(database);
    facturas = FacturaRepository(database);
    rectificativas = RectificativaRepository(database);
    await database.clientesDao.insertarCliente(
      ClientesCompanion.insert(
        id: 'cliente',
        nombre: 'Cliente',
        nif: const Value('12345678Z'),
      ),
    );
    await database.empresaConfiguracionDao.insertarConfiguracion(
      const EmpresaConfiguracionCompanion(
        id: Value('empresa'),
        nombreEmpresa: Value('Empresa'),
        cif: Value('B12345678'),
      ),
    );
    await database.expedientesDao.insertarExpediente(
      ExpedientesCompanion.insert(
        id: 'expediente',
        codigo: 'EXP',
        nombre: 'Obra',
        clienteId: const Value('cliente'),
      ),
    );
    await database.presupuestosDao.insertarPresupuesto(
      PresupuestosCompanion.insert(
        id: 'presupuesto',
        expedienteId: 'expediente',
        codigo: const Value('PRE-1'),
        importeTotal: const Value(100),
        ivaPorcentaje: const Value(21),
        estado: const Value('Aceptado'),
      ),
    );
    await database.lineasPresupuestoDao.insertarLinea(
      LineasPresupuestoCompanion.insert(
        id: 'l1',
        presupuestoId: 'presupuesto',
        concepto: 'Partida A',
        cantidad: 3,
        precioUnitario: 10,
      ),
    );
    await database.lineasPresupuestoDao.insertarLinea(
      LineasPresupuestoCompanion.insert(
        id: 'l2',
        presupuestoId: 'presupuesto',
        concepto: 'Partida B',
        cantidad: 7,
        precioUnitario: 10,
      ),
    );
  });

  tearDown(() => database.close());

  Future<ResumenFacturacionPresupuesto> resumen() =>
      parciales.observarResumen('presupuesto').first;

  test('primera y segunda parcial reservan y se listan', () async {
    await parciales.crearPorPorcentaje(
      presupuestoId: 'presupuesto',
      porcentaje: 25,
    );
    await parciales.crearPorImporte(presupuestoId: 'presupuesto', importe: 15);

    final actual = await resumen();
    expect(actual.basePresupuestada, 100);
    expect(actual.reservado, 40);
    expect(actual.facturado, 0);
    expect(actual.pendiente, 60);
    expect(await parciales.observarFacturas('presupuesto').first, hasLength(2));
  });

  test('emitir mueve reserva a facturado y borrar libera reserva', () async {
    final emitidaId = await parciales.crearPorImporte(
      presupuestoId: 'presupuesto',
      importe: 30,
    );
    final borradorId = await parciales.crearPorImporte(
      presupuestoId: 'presupuesto',
      importe: 20,
    );
    await facturas.emitirFactura(emitidaId);
    var actual = await resumen();
    expect(actual.facturado, 30);
    expect(actual.reservado, 20);
    expect(actual.pendiente, 50);

    await facturas.eliminarFactura(borradorId);
    actual = await resumen();
    expect(actual.reservado, 0);
    expect(actual.pendiente, 70);
  });

  test('selecciona cantidad parcial e importe sin medición física', () async {
    await parciales.crearPorPartidas(
      presupuestoId: 'presupuesto',
      selecciones: const [
        SeleccionPartidaFactura(lineaPresupuestoId: 'l1', cantidad: 1.5),
        SeleccionPartidaFactura(lineaPresupuestoId: 'l2', importe: 12.5),
      ],
    );
    final asignaciones = await database.facturaAsignacionesPresupuestoDao
        .obtenerPorPresupuesto('presupuesto');
    expect(asignaciones, hasLength(2));
    expect(asignaciones.first.cantidadAplicada, 1.5);
    expect(
      asignaciones.map((a) => a.baseAplicada).reduce((a, b) => a + b),
      27.5,
    );
  });

  test(
    'rechaza sobrecantidad, sobreimporte y nueva factura sin pendiente',
    () async {
      await expectLater(
        parciales.crearPorPartidas(
          presupuestoId: 'presupuesto',
          selecciones: const [
            SeleccionPartidaFactura(lineaPresupuestoId: 'l1', cantidad: 4),
          ],
        ),
        throwsA(isA<FacturacionParcialException>()),
      );
      await expectLater(
        parciales.crearPorImporte(
          presupuestoId: 'presupuesto',
          importe: 100.01,
        ),
        throwsA(isA<FacturacionParcialException>()),
      );
      await parciales.crearPorImporte(
        presupuestoId: 'presupuesto',
        importe: 100,
      );
      expect((await resumen()).pendiente, 0);
      await expectLater(
        parciales.crearPorImporte(presupuestoId: 'presupuesto', importe: 0.01),
        throwsA(isA<FacturacionParcialException>()),
      );
    },
  );

  test('dos borradores compatibles y sobrerreserva incompatible', () async {
    await parciales.crearPorPartidas(
      presupuestoId: 'presupuesto',
      selecciones: const [
        SeleccionPartidaFactura(lineaPresupuestoId: 'l1', cantidad: 1),
      ],
    );
    await parciales.crearPorPartidas(
      presupuestoId: 'presupuesto',
      selecciones: const [
        SeleccionPartidaFactura(lineaPresupuestoId: 'l1', cantidad: 2),
      ],
    );
    await expectLater(
      parciales.crearPorPartidas(
        presupuestoId: 'presupuesto',
        selecciones: const [
          SeleccionPartidaFactura(lineaPresupuestoId: 'l1', cantidad: 0.01),
        ],
      ),
      throwsA(isA<FacturacionParcialException>()),
    );
  });

  test('reparto conserva el céntimo residual y suma exacta', () async {
    final id = await parciales.crearPorImporte(
      presupuestoId: 'presupuesto',
      importe: 33.33,
    );
    final asignaciones = await database.facturaAsignacionesPresupuestoDao
        .obtenerPorPresupuesto('presupuesto');
    expect(asignaciones.fold<double>(0, (s, a) => s + a.baseAplicada), 33.33);
    expect(
      asignaciones
          .singleWhere((a) => a.lineaPresupuestoId == 'l1')
          .baseAplicada,
      9.99,
    );
    expect(
      asignaciones
          .singleWhere((a) => a.lineaPresupuestoId == 'l2')
          .baseAplicada,
      23.34,
    );
    expect((await parciales.obtenerFactura(id))?.subtotal, 33.33);
  });

  test('varias facturas completan pendiente exactamente cero', () async {
    for (final importe in [10.01, 20.02, 69.97]) {
      await parciales.crearPorImporte(
        presupuestoId: 'presupuesto',
        importe: importe,
      );
    }
    final actual = await resumen();
    expect(actual.reservado, 100);
    expect(actual.pendienteCentimos, 0);
  });

  test('cancelar una emitida mediante RECT reabre el pendiente', () async {
    final id = await parciales.crearPorImporte(
      presupuestoId: 'presupuesto',
      importe: 40,
    );
    await facturas.emitirFactura(id);
    expect((await resumen()).facturado, 40);
    await expectLater(
      facturas.anularFactura(id),
      throwsA(isA<FacturaEmitidaRequiereRectificativaException>()),
    );
    final rectId = await rectificativas.crearCancelatoria(
      facturaId: id,
      motivo: 'Cancelación completa',
    );
    await rectificativas.emitir(rectId);
    final actual = await resumen();
    expect(actual.facturado, 0);
    expect(actual.pendiente, 100);
  });

  test('fallo de Timeline revierte factura, líneas y asignaciones', () async {
    await database.customStatement('''
      CREATE TRIGGER bloquear_timeline BEFORE INSERT ON timeline_events
      BEGIN SELECT RAISE(ABORT, 'fallo inyectado'); END
    ''');
    await expectLater(
      parciales.crearPorImporte(presupuestoId: 'presupuesto', importe: 10),
      throwsA(anything),
    );
    expect(await parciales.observarFacturas('presupuesto').first, isEmpty);
    expect(
      await database.facturaAsignacionesPresupuestoDao.obtenerPorPresupuesto(
        'presupuesto',
      ),
      isEmpty,
    );
  });

  test('altas concurrentes no pueden sobrerreservar', () async {
    final resultados = await Future.wait(
      [60.0, 60.0].map((importe) async {
        try {
          await parciales.crearPorImporte(
            presupuestoId: 'presupuesto',
            importe: importe,
          );
          return true;
        } catch (_) {
          return false;
        }
      }),
    );
    expect(resultados.where((ok) => ok), hasLength(1));
    expect((await resumen()).reservado, 60);
  });
}

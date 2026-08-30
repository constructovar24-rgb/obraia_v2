import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/features/cobros/data/cobro_repository.dart';
import 'package:obraia_v2/features/cobros/domain/factura_estado_economico.dart';
import 'package:obraia_v2/features/cobros/domain/metodos_pago.dart';
import 'package:obraia_v2/features/facturas/data/factura_linea_repository.dart';
import 'package:obraia_v2/features/facturas/data/factura_repository.dart';
import 'package:obraia_v2/features/facturas/domain/estado_factura.dart';
import 'package:obraia_v2/features/timeline/data/timeline_repository.dart';

void main() {
  late AppDatabase database;
  late FacturaRepository facturas;
  late FacturaLineaRepository lineas;
  late CobroRepository cobros;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    facturas = FacturaRepository(database);
    lineas = FacturaLineaRepository(database);
    cobros = CobroRepository(database);
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
  });

  tearDown(() => database.close());

  Future<String> crearFactura({
    bool emitir = true,
    DateTime? fecha,
    DateTime? vencimiento,
  }) async {
    final hoy = DateTime.now();
    final id = await facturas.crearFactura(
      clienteId: 'cliente',
      fecha: fecha ?? hoy,
      fechaVencimiento: vencimiento ?? hoy.add(const Duration(days: 30)),
    );
    await lineas.crearLinea(
      facturaId: id,
      descripcion: 'Trabajo',
      cantidad: 1,
      unidad: 'ud',
      precioUnitario: 100,
      descuento: 0,
    );
    if (emitir) await facturas.emitirFactura(id);
    return id;
  }

  Future<void> cobrar(String facturaId, double importe, {DateTime? fecha}) {
    return cobros.crearCobro(
      facturaId: facturaId,
      fecha: fecha ?? DateTime.now(),
      importe: importe,
      metodoPago: 'Transferencia',
      referencia: 'REF',
    );
  }

  test('rechaza alta sobre borrador, anulada y cobrada sin saldo', () async {
    final borrador = await crearFactura(emitir: false);
    await expectLater(
      cobrar(borrador, 10),
      throwsA(isA<FacturaNoCobrableException>()),
    );

    final anulada = await crearFactura();
    await database.facturasDao.actualizarEstado(anulada, 'anulada');
    await expectLater(
      cobrar(anulada, 10),
      throwsA(isA<FacturaNoCobrableException>()),
    );

    final cobrada = await crearFactura();
    await cobrar(cobrada, 121);
    await expectLater(
      cobrar(cobrada, 0.01),
      throwsA(isA<FacturaNoCobrableException>()),
    );
  });

  test('valida fechas de cobro y catálogo de métodos', () async {
    final hoy = DateTime.now();
    final facturaId = await crearFactura(
      fecha: hoy.subtract(const Duration(days: 2)),
    );
    await expectLater(
      cobrar(facturaId, 10, fecha: hoy.add(const Duration(days: 1))),
      throwsA(isA<FechaMovimientoCobroNoValidaException>()),
    );
    await expectLater(
      cobrar(facturaId, 10, fecha: hoy.subtract(const Duration(days: 3))),
      throwsA(isA<FechaMovimientoCobroNoValidaException>()),
    );
    await expectLater(
      cobros.crearCobro(
        facturaId: facturaId,
        fecha: hoy,
        importe: 10,
        metodoPago: 'Otro',
      ),
      throwsA(isA<MetodoPagoCobroNoValidoException>()),
    );
    expect(metodosPagoCobro, [
      'Transferencia',
      'Efectivo',
      'Tarjeta',
      'Domiciliacion',
      'Otro',
    ]);
    expect(metodoPagoCobroConocido('Legacy'), isFalse);
  });

  test('consolida varios parciales y saldo exacto a céntimos', () async {
    final facturaId = await crearFactura();
    await cobrar(facturaId, 40.005);
    await cobrar(facturaId, 30.004);
    await cobrar(facturaId, 50.985);

    final movimientos = await database.cobrosDao.obtenerPorFactura(facturaId);
    expect(
      movimientos.map((item) => item.importe),
      containsAll([40.01, 30, 50.99]),
    );
    expect(calcularTotalCobradoNeto(movimientos), 121);
    expect(
      (await database.facturasDao.obtenerPorId(facturaId))?.estado,
      EstadoFactura.cobrada,
    );
  });

  test(
    'reversión parcial y total reabre saldo y conserva movimientos',
    () async {
      final facturaId = await crearFactura();
      await cobrar(facturaId, 121);
      final original = (await database.cobrosDao.obtenerPorFactura(
        facturaId,
      )).single;

      await cobros.revertirCobro(
        cobroId: original.id,
        fecha: DateTime.now(),
        importe: 20.005,
        motivo: 'Devolución parcial',
      );
      expect(
        (await database.facturasDao.obtenerPorId(facturaId))?.estado,
        EstadoFactura.emitida,
      );
      expect(
        calcularTotalCobradoNeto(
          await database.cobrosDao.obtenerPorFactura(facturaId),
        ),
        100.99,
      );
      await expectLater(
        cobrar(facturaId, 20.02),
        throwsA(isA<CobroSuperaPendienteException>()),
      );

      await cobros.revertirCobro(
        cobroId: original.id,
        fecha: DateTime.now(),
        importe: 100.99,
        motivo: 'Devolución restante',
      );
      final movimientos = await database.cobrosDao.obtenerPorFactura(facturaId);
      expect(movimientos, hasLength(3));
      expect(calcularTotalCobradoNeto(movimientos), 0);
      await expectLater(
        facturas.anularFactura(facturaId),
        throwsA(isA<FacturaEmitidaRequiereRectificativaException>()),
      );
      expect(
        (await database.facturasDao.obtenerPorId(facturaId))?.estado,
        EstadoFactura.emitida,
      );
    },
  );

  test('reversión de cobrada vencida vuelve a vencida', () async {
    final hoy = DateTime.now();
    final facturaId = await crearFactura(
      fecha: hoy.subtract(const Duration(days: 30)),
      vencimiento: hoy.subtract(const Duration(days: 1)),
    );
    await cobrar(facturaId, 121);
    final original = (await database.cobrosDao.obtenerPorFactura(
      facturaId,
    )).single;
    await cobros.revertirCobro(
      cobroId: original.id,
      fecha: hoy,
      importe: 0.01,
      motivo: 'Retroceso',
    );
    expect(
      (await database.facturasDao.obtenerPorId(facturaId))?.estado,
      EstadoFactura.vencida,
    );
  });

  test('reversión no supera original ni admite fechas inválidas', () async {
    final hoy = DateTime.now();
    final facturaId = await crearFactura(
      fecha: hoy.subtract(const Duration(days: 2)),
    );
    await cobrar(facturaId, 50, fecha: hoy.subtract(const Duration(days: 1)));
    final original = (await database.cobrosDao.obtenerPorFactura(
      facturaId,
    )).single;
    await expectLater(
      cobros.revertirCobro(
        cobroId: original.id,
        fecha: hoy,
        importe: 50.01,
        motivo: 'Exceso',
      ),
      throwsA(isA<CobroNoReversibleException>()),
    );
    await expectLater(
      cobros.revertirCobro(
        cobroId: original.id,
        fecha: hoy.add(const Duration(days: 1)),
        importe: 10,
        motivo: 'Futura',
      ),
      throwsA(isA<FechaMovimientoCobroNoValidaException>()),
    );
  });

  test('foreign keys están activas y rechazan factura inexistente', () async {
    final pragma = await database
        .customSelect('PRAGMA foreign_keys')
        .getSingle();
    expect(pragma.data.values.single, 1);
    await expectLater(
      database.cobrosDao.insertarCobro(
        CobrosCompanion.insert(id: 'huérfano', facturaId: 'no-existe'),
      ),
      throwsA(anything),
    );
  });

  test('fallo de trazabilidad revierte cobro y estado', () async {
    await database.expedientesDao.insertarExpediente(
      ExpedientesCompanion.insert(id: 'exp', codigo: 'EXP', nombre: 'Obra'),
    );
    await database.presupuestosDao.insertarPresupuesto(
      PresupuestosCompanion.insert(
        id: 'pre',
        expedienteId: 'exp',
        titulo: const Value('Presupuesto'),
      ),
    );
    final facturaId = await crearFactura();
    await database.customStatement(
      'UPDATE facturas SET presupuesto_origen_id = ? WHERE id = ?',
      ['pre', facturaId],
    );
    final conFallo = CobroRepository(
      database,
      timelineRepository: _TimelineConFallo(database),
    );
    await expectLater(
      conFallo.crearCobro(
        facturaId: facturaId,
        fecha: DateTime.now(),
        importe: 121,
        metodoPago: 'Transferencia',
      ),
      throwsStateError,
    );
    expect(await database.cobrosDao.obtenerPorFactura(facturaId), isEmpty);
    expect(
      (await database.facturasDao.obtenerPorId(facturaId))?.estado,
      EstadoFactura.emitida,
    );

    await cobrar(facturaId, 121);
    final original = (await database.cobrosDao.obtenerPorFactura(
      facturaId,
    )).single;
    final eventosAntes = await database.timelineEventsDao.obtenerPorExpediente(
      'exp',
    );
    expect(eventosAntes, hasLength(1));
    expect(eventosAntes.single.descripcion, contains('Importe 121.00 €'));
    expect(eventosAntes.single.descripcion, contains('Método Transferencia'));
    await expectLater(
      conFallo.revertirCobro(
        cobroId: original.id,
        fecha: DateTime.now(),
        importe: 20,
        motivo: 'Fallo simulado',
      ),
      throwsStateError,
    );
    expect(await database.cobrosDao.obtenerPorFactura(facturaId), hasLength(1));
    expect(
      await database.timelineEventsDao.obtenerPorExpediente('exp'),
      hasLength(1),
    );
    expect(
      (await database.facturasDao.obtenerPorId(facturaId))?.estado,
      EstadoFactura.cobrada,
    );
    await cobros.revertirCobro(
      cobroId: original.id,
      fecha: DateTime.now(),
      importe: 20,
      motivo: 'Devolución acreditada',
    );
    final eventos = await database.timelineEventsDao.obtenerPorExpediente(
      'exp',
    );
    expect(eventos, hasLength(2));
    expect(
      eventos.any(
        (evento) =>
            evento.descripcion?.contains('Devolución acreditada') ?? false,
      ),
      isTrue,
    );
  });
}

class _TimelineConFallo extends TimelineRepository {
  _TimelineConFallo(AppDatabase database) : super(database.timelineEventsDao);

  @override
  Future<void> registrarCobroRegistrado({
    required String expedienteId,
    required String cobroId,
    required String titulo,
    String? descripcion,
    DateTime? fecha,
  }) {
    throw StateError('fallo de trazabilidad simulado');
  }

  @override
  Future<void> registrarCobroRevertido({
    required String expedienteId,
    required String reversionId,
    required String titulo,
    String? descripcion,
    DateTime? fecha,
  }) {
    throw StateError('fallo de trazabilidad simulado');
  }
}

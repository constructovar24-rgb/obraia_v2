import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/features/cobros/data/cobro_repository.dart';
import 'package:obraia_v2/features/creditos_cliente/data/credito_cliente_repository.dart';
import 'package:obraia_v2/features/creditos_cliente/domain/credito_cliente.dart';
import 'package:obraia_v2/features/facturas/data/factura_repository.dart';
import 'package:obraia_v2/features/timeline/data/timeline_repository.dart';
import 'package:obraia_v2/features/timeline/domain/timeline_event.dart';

void main() {
  late AppDatabase db;
  late CreditoClienteRepository creditos;
  late CobroRepository cobros;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    creditos = CreditoClienteRepository(db);
    cobros = CobroRepository(db);
    await db.clientesDao.insertarCliente(
      ClientesCompanion.insert(
        id: 'c1',
        nombre: 'Cliente',
        nif: const Value('NIF-1'),
      ),
    );
    await db.clientesDao.insertarCliente(
      ClientesCompanion.insert(
        id: 'c2',
        nombre: 'Otro',
        nif: const Value('NIF-2'),
      ),
    );
    await _factura(db, 'fac1', 'c1', 121);
    await _factura(db, 'fac2', 'c1', 80);
    await _factura(db, 'fac3', 'c2', 80);
  });
  tearDown(() => db.close());

  test(
    'RECT negativa genera crédito y devolución parcial/total es auditable',
    () async {
      await cobros.crearCobro(
        facturaId: 'fac1',
        fecha: DateTime.now(),
        importe: 121,
        metodoPago: 'Efectivo',
      );
      await _rect(db, 'rect1', 'fac1', -21);
      var resumen = await creditos.obtenerResumen('rect1');
      expect(resumen.netoDocumental, 100);
      expect(resumen.creditoDisponible, 21);
      expect(resumen.estado, EstadoEconomicoFamilia.saldoFavorPendiente);

      final devolucion = await creditos.registrarDevolucion(
        facturaRaizId: 'fac1',
        importe: 10,
        fecha: DateTime.now(),
        metodo: 'Efectivo',
        motivo: 'Devolución parcial',
      );
      resumen = await creditos.obtenerResumen('fac1');
      expect(resumen.creditoDisponible, 11);
      expect(
        resumen.estado,
        EstadoEconomicoFamilia.saldoFavorParcialmenteDispuesto,
      );

      await creditos.revertir(
        movimientoId: devolucion,
        importe: 4,
        fecha: DateTime.now(),
        motivo: 'Corrección parcial',
      );
      expect((await creditos.obtenerResumen('fac1')).creditoDisponible, 15);
      await expectLater(
        creditos.revertir(
          movimientoId: devolucion,
          importe: 7,
          fecha: DateTime.now(),
          motivo: 'Exceso acumulado',
        ),
        throwsA(isA<CreditoClienteException>()),
      );
    },
  );

  test(
    'compensación liquida destino sin crear cobro y puede revertirse',
    () async {
      await cobros.crearCobro(
        facturaId: 'fac1',
        fecha: DateTime.now(),
        importe: 121,
        metodoPago: 'Efectivo',
      );
      await _rect(db, 'rect1', 'fac1', -40);
      final id = await creditos.compensar(
        facturaRaizOrigenId: 'fac1',
        facturaRaizDestinoId: 'fac2',
        importe: 30,
        fecha: DateTime.now(),
        motivo: 'Compensación acordada',
      );
      expect((await creditos.obtenerResumen('fac1')).creditoDisponible, 10);
      expect((await creditos.obtenerResumen('fac2')).pendiente, 50);
      expect(await db.cobrosDao.obtenerPorFactura('fac2'), isEmpty);
      await creditos.revertir(
        movimientoId: id,
        importe: 10,
        fecha: DateTime.now(),
        motivo: 'Corrección parcial',
      );
      expect((await creditos.obtenerResumen('fac2')).pendiente, 60);
    },
  );

  test('bloquea identidad fiscal, mismo destino y excesos', () async {
    await cobros.crearCobro(
      facturaId: 'fac1',
      fecha: DateTime.now(),
      importe: 121,
      metodoPago: 'Efectivo',
    );
    await _rect(db, 'rect1', 'fac1', -30);
    await expectLater(
      creditos.compensar(
        facturaRaizOrigenId: 'fac1',
        facturaRaizDestinoId: 'fac1',
        importe: 1,
        fecha: DateTime.now(),
        motivo: 'No válido',
      ),
      throwsA(isA<CreditoClienteException>()),
    );
    await expectLater(
      creditos.compensar(
        facturaRaizOrigenId: 'fac1',
        facturaRaizDestinoId: 'fac3',
        importe: 1,
        fecha: DateTime.now(),
        motivo: 'No válido',
      ),
      throwsA(isA<CreditoClienteException>()),
    );
    await expectLater(
      creditos.registrarDevolucion(
        facturaRaizId: 'fac1',
        importe: 31,
        fecha: DateTime.now(),
        metodo: 'Efectivo',
        motivo: 'Exceso',
      ),
      throwsA(isA<CreditoClienteException>()),
    );
  });

  test(
    'anulación de RECT incompatible con crédito dispuesto queda bloqueada',
    () async {
      await cobros.crearCobro(
        facturaId: 'fac1',
        fecha: DateTime.now(),
        importe: 121,
        metodoPago: 'Efectivo',
      );
      await _rect(db, 'rect1', 'fac1', -30);
      await creditos.registrarDevolucion(
        facturaRaizId: 'fac1',
        importe: 20,
        fecha: DateTime.now(),
        metodo: 'Efectivo',
        motivo: 'Crédito dispuesto',
      );
      await expectLater(
        FacturaRepository(db).anularFactura('rect1'),
        throwsA(isA<CreditoClienteException>()),
      );
    },
  );

  test('nuevo cobro usa neto familiar y compensaciones recibidas', () async {
    await _rect(db, 'rect1', 'fac1', -21);
    await expectLater(
      cobros.crearCobro(
        facturaId: 'fac1',
        fecha: DateTime.now(),
        importe: 101,
        metodoPago: 'Efectivo',
      ),
      throwsA(isA<CobroSuperaPendienteException>()),
    );
    await cobros.crearCobro(
      facturaId: 'fac1',
      fecha: DateTime.now(),
      importe: 100,
      metodoPago: 'Efectivo',
    );
    await _factura(db, 'credito', 'c1', 50);
    await cobros.crearCobro(
      facturaId: 'credito',
      fecha: DateTime.now(),
      importe: 50,
      metodoPago: 'Efectivo',
    );
    await _rect(db, 'rectcredito', 'credito', -20);
    await creditos.compensar(
      facturaRaizOrigenId: 'credito',
      facturaRaizDestinoId: 'fac2',
      importe: 20,
      fecha: DateTime.now(),
      motivo: 'Aplicación',
    );
    await expectLater(
      cobros.crearCobro(
        facturaId: 'fac2',
        fecha: DateTime.now(),
        importe: 61,
        metodoPago: 'Efectivo',
      ),
      throwsA(isA<CobroSuperaPendienteException>()),
    );
  });

  test(
    'crédito dispuesto protege reversión de cobro y cambio documental',
    () async {
      await cobros.crearCobro(
        facturaId: 'fac1',
        fecha: DateTime.now(),
        importe: 121,
        metodoPago: 'Efectivo',
      );
      final movimientoCobro = (await db.cobrosDao.obtenerPorFactura(
        'fac1',
      )).single;
      await _rect(db, 'rect1', 'fac1', -30);
      await creditos.registrarDevolucion(
        facturaRaizId: 'fac1',
        importe: 20,
        fecha: DateTime.now(),
        metodo: 'Efectivo',
        motivo: 'Devolución',
      );
      await expectLater(
        cobros.revertirCobro(
          cobroId: movimientoCobro.id,
          fecha: DateTime.now(),
          importe: 15,
          motivo: 'Corrección',
        ),
        throwsA(isA<CreditoClienteException>()),
      );
      await expectLater(
        creditos.validarCreditoTrasCambio(
          facturaRaizId: 'fac1',
          nuevoNetoDocumental: 110,
        ),
        throwsA(isA<CreditoClienteException>()),
      );
    },
  );

  test('consumo concurrente no dispone dos veces el mismo crédito', () async {
    await cobros.crearCobro(
      facturaId: 'fac1',
      fecha: DateTime.now(),
      importe: 121,
      metodoPago: 'Efectivo',
    );
    await _rect(db, 'rect1', 'fac1', -20);
    final resultados = await Future.wait([
      creditos
          .registrarDevolucion(
            facturaRaizId: 'fac1',
            importe: 15,
            fecha: DateTime.now(),
            metodo: 'Efectivo',
            motivo: 'Primera',
          )
          .then<Object>((v) => v)
          .catchError((Object e) => e),
      creditos
          .compensar(
            facturaRaizOrigenId: 'fac1',
            facturaRaizDestinoId: 'fac2',
            importe: 15,
            fecha: DateTime.now(),
            motivo: 'Segunda',
          )
          .then<Object>((v) => v)
          .catchError((Object e) => e),
    ]);
    expect(resultados.whereType<String>(), hasLength(1));
    expect((await creditos.obtenerResumen('fac1')).creditoDispuesto, 15);
  });

  test('movimientos confirmados y cobros no se eliminan por negocio', () async {
    await cobros.crearCobro(
      facturaId: 'fac1',
      fecha: DateTime.now(),
      importe: 1,
      metodoPago: 'Efectivo',
    );
    final cobro = (await db.cobrosDao.obtenerPorFactura('fac1')).single;
    await expectLater(
      cobros.eliminarCobro(cobro.id),
      throwsA(isA<CobroConfirmadoNoEditableException>()),
    );
  });

  test('un fallo de Timeline revierte íntegramente la devolución', () async {
    await db.expedientesDao.insertarExpediente(
      ExpedientesCompanion.insert(
        id: 'exp',
        codigo: 'EXP',
        nombre: 'Obra',
        clienteId: const Value('c1'),
      ),
    );
    await db.presupuestosDao.insertarPresupuesto(
      PresupuestosCompanion.insert(
        id: 'pre',
        expedienteId: 'exp',
        estado: const Value('Aceptado'),
      ),
    );
    await db.customStatement(
      "UPDATE facturas SET presupuesto_origen_id = 'pre' WHERE id = 'fac1'",
    );
    await cobros.crearCobro(
      facturaId: 'fac1',
      fecha: DateTime.now(),
      importe: 121,
      metodoPago: 'Efectivo',
    );
    await _rect(db, 'rect1', 'fac1', -20);
    final repository = CreditoClienteRepository(
      db,
      timeline: _TimelineConFallo(db),
    );
    await expectLater(
      repository.registrarDevolucion(
        facturaRaizId: 'fac1',
        importe: 10,
        fecha: DateTime.now(),
        metodo: 'Efectivo',
        motivo: 'Debe revertirse',
      ),
      throwsA(isA<_FalloTimeline>()),
    );
    expect(await db.movimientosCreditoClienteDao.obtenerTodos(), isEmpty);
  });
}

class _FalloTimeline implements Exception {}

class _TimelineConFallo extends TimelineRepository {
  _TimelineConFallo(AppDatabase db) : super(db.timelineEventsDao);

  @override
  Future<void> registrarMovimientoCredito({
    required String expedienteId,
    required String movimientoId,
    required TimelineCreditoTipo tipo,
    required String titulo,
    required String descripcion,
    required DateTime fecha,
  }) => throw _FalloTimeline();
}

Future<void> _factura(
  AppDatabase db,
  String id,
  String clienteId,
  double total,
) => db.facturasDao.insertarFactura(
  FacturasCompanion.insert(
    id: id,
    clienteId: clienteId,
    codigo: Value('FAC-$id'),
    fecha: Value(DateTime.now()),
    fechaVencimiento: Value(DateTime.now().add(const Duration(days: 30))),
    estado: const Value('emitida'),
    subtotal: Value(total),
    iva: const Value(0),
    total: Value(total),
    anioNumeracion: const Value(2026),
    numeroLegal: Value(id.hashCode.abs()),
    fechaEmision: Value(DateTime.now()),
    clienteNombreHistorico: const Value('Cliente'),
    clienteNifHistorico: Value(clienteId == 'c1' ? 'NIF-1' : 'NIF-2'),
    empresaNombreHistorico: const Value('Empresa'),
    empresaCifHistorico: const Value('CIF'),
  ),
);

Future<void> _rect(
  AppDatabase db,
  String id,
  String raizId,
  double efecto,
) async {
  final raiz = (await db.facturasDao.obtenerPorId(raizId))!;
  await db.facturasDao.insertarFactura(
    FacturasCompanion.insert(
      id: id,
      clienteId: raiz.clienteId,
      codigo: Value('RECT-$id'),
      fecha: Value(DateTime.now()),
      fechaVencimiento: Value(DateTime.now()),
      estado: const Value('emitida'),
      subtotal: Value(efecto),
      iva: const Value(0),
      total: Value(efecto),
      tipoDocumento: const Value('rectificativa'),
      serie: const Value('RECT'),
      facturaRectificadaId: Value(raizId),
      facturaRaizId: Value(raizId),
      modalidadRectificacion: const Value('diferencias'),
      motivoRectificacion: const Value('Ajuste'),
      efectoBase: Value(efecto),
      efectoIva: const Value(0),
      efectoTotal: Value(efecto),
    ),
  );
}

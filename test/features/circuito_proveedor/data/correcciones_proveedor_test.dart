import 'package:obraia_v2/features/compras/data/compra_repository.dart';
import 'package:obraia_v2/features/compras/domain/compra.dart' as compra;
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/features/circuito_proveedor/data/circuito_proveedor_repository.dart';
import 'package:obraia_v2/features/circuito_proveedor/domain/circuito_proveedor.dart';

void main() {
  late AppDatabase db;
  late CircuitoProveedorRepository r;
  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    await db.ensureReady();
    r = CircuitoProveedorRepository(db);
    for (final id in ['a', 'b']) {
      await db.expedientesDao.insertarExpediente(
        ExpedientesCompanion.insert(
          id: id,
          codigo: id,
          nombre: 'Obra ficticia $id',
        ),
      );
    }
    await db.proveedoresDao.insertarProveedor(
      ProveedoresCompanion.insert(id: 'p', nombre: 'Proveedor ficticio'),
    );
  });
  tearDown(() => db.close());
  FacturaRecibidaInput input({
    String numero = 'F1',
    String? obra = 'a',
    int base = 10000,
    int iva = 2100,
    String tipo = 'factura',
    String? original,
    int year = 2026,
    String destino = 'sinAsignar',
  }) => FacturaRecibidaInput(
    proveedorId: 'p',
    numero: numero,
    fecha: DateTime(year, 1, 1),
    baseCentimos: base,
    ivaCentimos: iva,
    asignaciones: [
      AsignacionImporteInput(expedienteId: obra, importeCentimos: base),
    ],
    tipo: tipo,
    originalId: original,
    destino: destino,
  );
  Future<String> registrada({String? obra = 'a'}) async {
    final id = await r.crearFactura(input(obra: obra));
    await r.consolidarFactura(id);
    return id;
  }

  Future<int> coste(String obra) async =>
      (await db.hechosCosteDao.obtenerPorExpediente(
        obra,
      )).fold<int>(0, (s, h) => s + h.importeCosteCentimos);
  test(
    'creación borrador sin costes, edición y consolidación protegida',
    () async {
      final id = await r.crearFactura(input());
      expect(await coste('a'), 0);
      await r.editarBorrador(id, input(base: 20000));
      await r.consolidarFactura(id);
      expect(await coste('a'), 20000);
      await expectLater(r.editarBorrador(id, input()), throwsStateError);
      await expectLater(r.consolidarFactura(id), throwsStateError);
      await expectLater(
        db.circuitoProveedorDao.editarFactura(
          id,
          const FacturasRecibidasCompanion(
            baseCentimos: Value(1),
            totalCentimos: Value(2101),
          ),
        ),
        throwsA(anything),
      );
    },
  );
  test(
    'duplicados por proveedor y ejercicio, normalización y concurrencia',
    () async {
      await r.crearFactura(input(numero: ' F-1 '));
      await expectLater(r.crearFactura(input(numero: 'f1')), throwsStateError);
      await r.crearFactura(input(numero: 'F-1', year: 2027));
      final result = await Future.wait([
        for (var i = 0; i < 2; i++)
          r
              .crearFactura(input(numero: 'X'))
              .then((_) => true, onError: (_) => false),
      ]);
      expect(result.where((v) => v), hasLength(1));
    },
  );
  test('abono relacionado reduce coste y saldo sin tocar original', () async {
    final id = await registrada();
    final abono = await r.crearFactura(
      input(numero: 'AB1', tipo: 'abono', original: id, base: 2000, iva: 420),
    );
    await r.consolidarFactura(abono);
    expect(await coste('a'), 8000);
    final f = (await r.listarFichas()).firstWhere((f) => f['id'] == id);
    expect(f['abonos'], 2420);
    expect((await db.circuitoProveedorDao.factura(id))!.totalCentimos, 12100);
    await r.anularFactura(abono, motivo: 'Abono registrado por error');
    expect(await coste('a'), 10000);
  });
  test(
    'anulación preserva documento y revierte coste, doble bloqueada',
    () async {
      final id = await registrada();
      await r.anularFactura(id, motivo: 'Error ficticio');
      expect(await coste('a'), 0);
      expect(await db.circuitoProveedorDao.factura(id), isNotNull);
      await expectLater(
        r.anularFactura(id, motivo: 'Otra vez'),
        throwsStateError,
      );
      expect((await db.hechosCosteDao.obtenerPorExpediente('a')).length, 2);
    },
  );
  test('motivo obligatorio y rollback de anulación', () async {
    final id = await registrada();
    await expectLater(r.anularFactura(id, motivo: ''), throwsArgumentError);
    expect(await coste('a'), 10000);
  });
  test(
    'pago desconocido no es pendiente y exige verificación explícita',
    () async {
      final id = await registrada();
      final f = (await r.listarFichas()).single;
      expect(f['pendiente'], isNull);
      expect(f['estadoPago'], 'Pago no verificado');
      await expectLater(
        r.registrarPago(
          facturaId: id,
          fecha: DateTime.now(),
          importeCentimos: 1,
        ),
        throwsStateError,
      );
      await expectLater(r.verificarPago(id, motivo: ''), throwsArgumentError);
      await r.verificarPago(id, motivo: 'Justificantes ficticios revisados');
      expect((await r.listarFichas()).single['pendiente'], 12100);
    },
  );
  test(
    'pagos parciales múltiples completo y reversión, sin duplicar coste',
    () async {
      final id = await registrada();
      await r.verificarPago(id, motivo: 'Prueba');
      final pago = await r.registrarPago(
        facturaId: id,
        fecha: DateTime.now(),
        importeCentimos: 2100,
        metodo: 'Transferencia',
      );
      expect((await r.listarFichas()).single['pendiente'], 10000);
      await r.registrarPago(
        facturaId: id,
        fecha: DateTime.now(),
        importeCentimos: 10000,
      );
      expect((await r.listarFichas()).single['pendiente'], 0);
      expect(await coste('a'), 10000);
      await r.revertirPagoProveedor(pago, motivo: 'Importe erróneo');
      expect((await r.listarFichas()).single['pendiente'], 2100);
      await expectLater(
        r.revertirPagoProveedor(pago, motivo: 'Doble'),
        throwsStateError,
      );
      expect(await db.circuitoProveedorDao.pagos(id), hasLength(2));
      await expectLater(
        r.anularFactura(id, motivo: 'Pagada'),
        throwsStateError,
      );
    },
  );
  test(
    'sin obra y gasto general no inventan obra; asignación posterior canónica',
    () async {
      final id = await registrada(obra: null);
      expect(await db.select(db.hechosCoste).get(), isEmpty);
      await r.cambiarImputacion(
        id,
        asignaciones: [const AsignacionImporteInput(importeCentimos: 10000)],
        destino: 'general',
        motivo: 'Gasto general',
      );
      expect((await r.listarFichas()).single['destino'], 'general');
      await r.cambiarImputacion(
        id,
        asignaciones: [
          const AsignacionImporteInput(
            expedienteId: 'a',
            importeCentimos: 10000,
          ),
        ],
        destino: 'obra',
        motivo: 'Obra identificada',
      );
      expect(await coste('a'), 10000);
      await r.cambiarImputacion(
        id,
        asignaciones: [
          const AsignacionImporteInput(
            expedienteId: 'b',
            importeCentimos: 10000,
          ),
        ],
        destino: 'obra',
        motivo: 'Corrección de obra',
      );
      expect(await coste('a'), 0);
      expect(await coste('b'), 10000);
      await r.anularFactura(id, motivo: 'Error');
      expect(await coste('b'), 0);
    },
  );
  test('cambio desde compra reconciliada no duplica costes', () async {
    final id = await registrada();
    await r.cambiarImputacion(
      id,
      asignaciones: [
        const AsignacionImporteInput(expedienteId: 'b', importeCentimos: 10000),
      ],
      destino: 'obra',
      motivo: 'Corrección',
    );
    expect(await coste('a'), 0);
    expect(await coste('b'), 10000);
    await r.cambiarImputacion(
      id,
      asignaciones: [
        const AsignacionImporteInput(expedienteId: 'a', importeCentimos: 10000),
      ],
      destino: 'obra',
      motivo: 'Nueva evidencia',
    );
    expect(await coste('b'), 0);
    expect(await coste('a'), 10000);
  });
  test(
    'corrección conserva original y permite sustitución mismo número',
    () async {
      final id = await registrada();
      final nuevo = await r.corregirFactura(
        id,
        input(base: 12000),
        motivo: 'Importe mal transcrito',
      );
      expect((await db.circuitoProveedorDao.factura(id))!.baseCentimos, 10000);
      expect(
        (await db.circuitoProveedorDao.control(id))!.estadoDocumento,
        'anulada',
      );
      await r.consolidarFactura(nuevo);
      expect(await coste('a'), 12000);
      expect(await db.circuitoProveedorDao.todasFacturas(), hasLength(2));
    },
  );
  test('auditoría y pagos inmutables; Timeline con referencia', () async {
    final id = await registrada();
    expect(await db.circuitoProveedorDao.eventos(id), hasLength(2));
    expect(
      await db
          .customSelect(
            "SELECT * FROM timeline_events WHERE referencia_id = ?",
            variables: [Variable(id)],
          )
          .get(),
      isNotEmpty,
    );
    await expectLater(
      db.customStatement('DELETE FROM eventos_proveedor'),
      throwsA(anything),
    );
    await expectLater(
      db.customStatement('DELETE FROM facturas_recibidas'),
      throwsA(anything),
    );
  });
  test('fallo auditoría revierte factura, coste y estado', () async {
    final id = await r.crearFactura(input());
    await db.customStatement(
      "CREATE TRIGGER fallo_test BEFORE INSERT ON eventos_proveedor BEGIN SELECT RAISE(ABORT,'fallo ficticio'); END",
    );
    await expectLater(r.consolidarFactura(id), throwsA(anything));
    expect(await coste('a'), 0);
    expect(
      (await db.circuitoProveedorDao.control(id))!.estadoDocumento,
      'borrador',
    );
  });
  test('tenant no puede consultar ni operar factura ajena', () async {
    final id = await registrada();
    await db
        .into(db.tenants)
        .insert(
          TenantsCompanion.insert(
            id: 'otro',
            nombre: 'Ficticio',
            fechaCreacion: DateTime.now(),
            fechaModificacion: DateTime.now(),
          ),
        );
    db.tenantContext.activate('otro');
    expect(await r.listarFichas(), isEmpty);
    await expectLater(r.anularFactura(id, motivo: 'Ajena'), throwsStateError);
  });

  test(
    'reparto múltiple editable antes de consolidar y sin alterar importe global',
    () async {
      final id = await r.crearFactura(
        FacturaRecibidaInput(
          proveedorId: 'p',
          numero: 'MULTI',
          fecha: DateTime(2026),
          baseCentimos: 10000,
          ivaCentimos: 2100,
          asignaciones: [
            const AsignacionImporteInput(
              expedienteId: 'a',
              importeCentimos: 5000,
            ),
            const AsignacionImporteInput(
              expedienteId: 'b',
              importeCentimos: 5000,
            ),
          ],
        ),
      );
      await r.editarBorrador(
        id,
        FacturaRecibidaInput(
          proveedorId: 'p',
          numero: 'MULTI-COR',
          fecha: DateTime(2026),
          baseCentimos: 12000,
          ivaCentimos: 2520,
          asignaciones: [
            const AsignacionImporteInput(
              expedienteId: 'a',
              importeCentimos: 4000,
            ),
            const AsignacionImporteInput(
              expedienteId: 'b',
              importeCentimos: 8000,
            ),
          ],
        ),
      );
      await r.consolidarFactura(id);
      expect(await coste('a'), 4000);
      expect(await coste('b'), 8000);
    },
  );
  test(
    'corrección fallida revierte anulación y coste; borrador sustituto editable',
    () async {
      final id = await registrada();
      await expectLater(
        r.corregirFactura(id, input(base: -1), motivo: 'Error'),
        throwsA(anything),
      );
      expect(
        (await db.circuitoProveedorDao.control(id))!.estadoDocumento,
        'registrada',
      );
      expect(await coste('a'), 10000);
      final nuevo = await r.corregirFactura(
        id,
        input(base: 12000),
        motivo: 'Importe',
      );
      await r.editarBorrador(nuevo, input(base: 13000));
      await r.consolidarFactura(nuevo);
      expect(await coste('a'), 13000);
    },
  );
  test('pagos concurrentes no exceden saldo', () async {
    final id = await registrada();
    await r.verificarPago(id, motivo: 'Justificantes');
    final results = await Future.wait([
      for (var i = 0; i < 2; i++)
        r
            .registrarPago(
              facturaId: id,
              fecha: DateTime.now(),
              importeCentimos: 10000,
            )
            .then((_) => true, onError: (_) => false),
    ]);
    expect(results.where((r) => r), hasLength(1));
    expect((await r.listarFichas()).single['pendiente'], 2100);
  });
  test(
    'IVA no recuperable inválido revierte creación y cambio de imputación',
    () async {
      final id = await registrada();
      await expectLater(
        r.cambiarImputacion(
          id,
          destino: 'obra',
          motivo: 'Prueba',
          asignaciones: [
            const AsignacionImporteInput(
              expedienteId: 'b',
              importeCentimos: 10000,
              ivaNoRecuperableCentimos: 9999,
            ),
          ],
        ),
        throwsStateError,
      );
      expect(await coste('a'), 10000);
      expect(await coste('b'), 0);
    },
  );
  test(
    'compra consolidada conserva histórico y corrige pago sin tocar coste',
    () async {
      final compras = CompraRepository(db);
      await compras.registrarCompra(
        compra.Compra(
          id: 'c',
          expedienteId: 'a',
          proveedorNombre: 'Ficticio',
          fecha: DateTime(2026),
          concepto: 'Prueba',
          baseImponible: 10,
          ivaPorcentaje: 0,
          importeTotal: 10,
          estado: compra.CompraEstado.pendiente,
        ),
      );
      await compras.confirmarComoGasto(compraId: 'c');
      await compras.corregirEstadoPago(
        'c',
        compra.CompraEstado.noVerificado,
        motivo: 'Sin justificante',
      );
      expect((await db.comprasDao.obtenerPorId('c'))!.estado, 'noVerificado');
      expect(await coste('a'), 1000);
      await compras.corregirEstadoPago(
        'c',
        compra.CompraEstado.pagada,
        motivo: 'Justificante encontrado',
      );
      expect(await coste('a'), 1000);
      await expectLater(compras.eliminarCompra('c'), throwsStateError);
      await compras.revertirCoste('c', motivo: 'Gasto erróneo');
      expect(await coste('a'), 0);
      await expectLater(
        compras.revertirCoste('c', motivo: 'Doble'),
        throwsStateError,
      );
    },
  );
  test('compra vinculada exige operar desde factura recibida', () async {
    final id = await registrada();
    final a = (await db.circuitoProveedorDao.asignaciones(id)).single;
    final c = (await db.circuitoProveedorDao.reconciliacion(a.id))!.compraId;
    await expectLater(
      CompraRepository(db).revertirCoste(c, motivo: 'Error'),
      throwsStateError,
    );
    await expectLater(
      CompraRepository(
        db,
      ).corregirEstadoPago(c, compra.CompraEstado.pagada, motivo: 'Error'),
      throwsStateError,
    );
    expect(await coste('a'), 10000);
  });

  test('reimputaci?n a obra cerrada revierte todos los cambios', () async {
    final id = await registrada();
    await db.cierreEconomicoDao.guardarEstado(
      EstadosEconomicosObraCompanion.insert(
        tenantId: db.activeTenantId,
        expedienteId: 'b',
        estado: 'cerrado',
        fechaModificacion: DateTime.now(),
      ),
    );
    await expectLater(
      r.cambiarImputacion(
        id,
        destino: 'obra',
        motivo: 'Prueba cierre',
        asignaciones: [
          const AsignacionImporteInput(
            expedienteId: 'b',
            importeCentimos: 10000,
          ),
        ],
      ),
      throwsStateError,
    );
    expect(await coste('a'), 10000);
    expect(await coste('b'), 0);
    expect(
      (await db.circuitoProveedorDao.asignaciones(id)).single.expedienteId,
      'a',
    );
  });
}

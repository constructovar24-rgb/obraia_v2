import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/features/compras/data/compra_repository.dart';
import 'package:obraia_v2/features/compras/domain/compra.dart' as domain;
import 'package:obraia_v2/features/economia/data/hecho_coste_repository.dart';

void main() {
  late AppDatabase db;
  late CompraRepository compras;
  late HechoCosteRepository costes;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    await db.ensureReady();
    compras = CompraRepository(db);
    costes = HechoCosteRepository(db);
    await db.expedientesDao.insertarExpediente(
      ExpedientesCompanion.insert(id: 'obra', codigo: 'OBR', nombre: 'Obra'),
    );
  });
  tearDown(() => db.close());

  Future<void> crearCompra(String id, {double base = 100}) =>
      compras.registrarCompra(
        domain.Compra(
          id: id,
          expedienteId: 'obra',
          proveedorNombre: 'Proveedor',
          fecha: DateTime.utc(2026, 9, 4),
          concepto: 'Material',
          baseImponible: base,
          ivaPorcentaje: 21,
          importeTotal: base * 1.21,
          estado: domain.CompraEstado.pendiente,
        ),
      );

  test('provisional no suma y confirmar crea un único coste neto', () async {
    await crearCompra('c1');
    expect((await costes.obtenerResumen('obra')).totalCentimos, 0);
    final categoria =
        (await db.economiaPrevistaDao.observarCategorias().first).first;

    await compras.confirmarComoGasto(
      compraId: 'c1',
      categoriaEconomicaId: categoria.id,
    );
    await compras.confirmarComoGasto(
      compraId: 'c1',
      categoriaEconomicaId: categoria.id,
    );

    final resumen = await costes.obtenerResumen('obra');
    expect(resumen.totalCentimos, 10000);
    expect(resumen.porCategoriaCentimos[categoria.id], 10000);
    expect(resumen.numeroHechos, 1);
  });

  test('reversión neutraliza sin borrar y bloquea edición histórica', () async {
    await crearCompra('c1');
    await compras.confirmarComoGasto(compraId: 'c1');
    await expectLater(
      compras.actualizarCompra(
        domain.Compra(
          id: 'c1',
          expedienteId: 'obra',
          proveedorNombre: 'Otro',
          fecha: DateTime.utc(2026, 9, 4),
          concepto: 'Reescrito',
          baseImponible: 1,
          ivaPorcentaje: 21,
          importeTotal: 1.21,
          estado: domain.CompraEstado.pendiente,
        ),
      ),
      throwsStateError,
    );
    await compras.revertirCoste('c1', motivo: 'Factura incorrecta');
    final resumen = await costes.obtenerResumen('obra');
    expect(resumen.totalCentimos, 0);
    expect(resumen.sinAsignarCentimos, 0);
    expect(resumen.numeroHechos, 2);
  });

  test('ajustes positivos y negativos son movimientos auditables', () async {
    await costes.registrarAjuste(
      expedienteId: 'obra',
      fechaDevengo: DateTime.utc(2026, 9, 4),
      importeNetoCentimos: 250,
      descripcion: 'Regularización positiva',
    );
    await costes.registrarAjuste(
      expedienteId: 'obra',
      fechaDevengo: DateTime.utc(2026, 9, 4),
      importeNetoCentimos: -50,
      descripcion: 'Regularización negativa',
    );
    final resumen = await costes.obtenerResumen('obra');
    expect(resumen.totalCentimos, 200);
    expect(resumen.numeroHechos, 2);
  });

  test('fallo de Timeline revierte clasificación y hecho', () async {
    await crearCompra('c1');
    await db.customStatement('''
      CREATE TRIGGER bloquear_timeline BEFORE INSERT ON timeline_events
      BEGIN SELECT RAISE(ABORT, 'fallo timeline'); END
    ''');
    await expectLater(
      compras.confirmarComoGasto(compraId: 'c1'),
      throwsA(anything),
    );
    expect(
      (await db.comprasDao.obtenerPorId('c1'))!.clasificacionEconomica,
      'provisional',
    );
    expect(await db.hechosCosteDao.obtenerPorOrigen('compra', 'c1'), isEmpty);
  });

  test('cero es válido y dos Compras distintas no se deduplican', () async {
    await crearCompra('cero', base: 0);
    await crearCompra('otra', base: 12.34);
    await compras.confirmarComoGasto(compraId: 'cero');
    await compras.confirmarComoGasto(compraId: 'otra');
    final resumen = await costes.obtenerResumen('obra');
    expect(resumen.totalCentimos, 1234);
    expect(resumen.numeroHechos, 2);
  });

  test('una categoría de otro tenant es rechazada', () async {
    const tenantB = '00000000-0000-4000-8000-000000000025';
    await db
        .into(db.tenants)
        .insert(
          TenantsCompanion.insert(
            id: tenantB,
            nombre: 'Tenant B',
            fechaCreacion: DateTime.now().toUtc(),
            fechaModificacion: DateTime.now().toUtc(),
          ),
        );
    await db
        .into(db.categoriasEconomicas)
        .insert(
          CategoriasEconomicasCompanion.insert(
            tenantId: tenantB,
            id: 'categoria-b',
            codigo: 'b',
            nombre: 'Categoría B',
            fechaCreacion: DateTime.now().toUtc(),
            fechaModificacion: DateTime.now().toUtc(),
          ),
        );
    await crearCompra('c1');
    await expectLater(
      compras.confirmarComoGasto(
        compraId: 'c1',
        categoriaEconomicaId: 'categoria-b',
      ),
      throwsStateError,
    );
    expect((await costes.obtenerResumen('obra')).numeroHechos, 0);
  });
}

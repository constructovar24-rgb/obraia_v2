import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/features/economia/data/plan_economico_repository.dart';
import 'package:obraia_v2/features/economia/domain/plan_economico.dart';
import 'package:obraia_v2/features/presupuestos/data/linea_presupuesto_repository.dart';
import 'package:obraia_v2/features/presupuestos/data/presupuesto_repository.dart';

void main() {
  late AppDatabase database;
  late PlanEconomicoRepository economia;
  late PresupuestoRepository presupuestos;
  late LineaPresupuestoRepository lineas;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    await database.ensureReady();
    economia = PlanEconomicoRepository(database);
    presupuestos = PresupuestoRepository(database);
    lineas = LineaPresupuestoRepository(database);
  });

  tearDown(() => database.close());

  test(
    'bootstrap crea categorías neutrales y configuración sin porcentaje',
    () async {
      final categorias = await economia.observarCategorias().first;
      expect(
        categorias.map((item) => item.codigo),
        containsAll(<String>[
          'materiales',
          'mano_obra',
          'maquinaria',
          'subcontratas',
          'transporte',
          'alquileres',
          'tasas_licencias',
          'residuos',
          'otros_directos',
        ]),
      );
      expect(categorias, hasLength(9));
      expect(await economia.obtenerPorcentajeIndirectos(), isNull);
    },
  );

  test('aceptación congela plan completo, partidas y parámetros', () async {
    final presupuestoId = await _crearPresupuesto(database, presupuestos);
    final creadas = await database.lineasPresupuestoDao.obtenerPorPresupuesto(
      presupuestoId,
    );
    final categorias = await economia.observarCategorias().first;
    await economia.guardarPorcentajeIndirectos(10);
    await economia.guardarCosteLinea(
      lineaId: creadas[0].id,
      categoriaId: categorias[0].id,
      coste: 50,
    );
    await economia.guardarCosteLinea(
      lineaId: creadas[1].id,
      categoriaId: categorias[1].id,
      coste: 20,
    );

    await presupuestos.aceptarPresupuesto(presupuestoId);
    final plan = await economia.obtenerPlanPorPresupuesto(presupuestoId);
    expect(plan, isNotNull);
    expect(plan!.magnitudes.cobertura, CoberturaCostesPlan.completo);
    expect(plan.magnitudes.ventaNetaCentimos, 10000);
    expect(plan.magnitudes.costeDirectoCentimos, 7000);
    expect(plan.magnitudes.costesIndirectosCentimos, 700);
    expect(plan.magnitudes.beneficioPrevistoCentimos, 2300);
    expect(plan.magnitudes.margenPrevistoPorcentaje, 23);
    final partidas = await database.economiaPrevistaDao.obtenerPartidasPlan(
      plan.id,
    );
    expect(partidas, hasLength(2));
    expect(partidas.first.categoriaCodigoSnapshot, 'materiales');
    expect(partidas.first.costePrevistoCentimos, 5000);

    await economia.guardarPorcentajeIndirectos(25);
    await lineas.actualizarLinea(
      id: creadas.first.id,
      presupuestoId: presupuestoId,
      concepto: 'Modificada después',
      cantidad: 1,
      precioUnitario: 999,
    );
    final congelado = await economia.obtenerPlanPorPresupuesto(presupuestoId);
    final partidasCongeladas = await database.economiaPrevistaDao
        .obtenerPartidasPlan(plan.id);
    expect(congelado!.magnitudes.porcentajeIndirectos, 10);
    expect(congelado.magnitudes.ventaNetaCentimos, 10000);
    expect(partidasCongeladas.first.descripcion, 'Material');
    expect(partidasCongeladas.first.importeVentaCentimos, 6000);
  });

  test(
    'aceptación permite plan incompleto sin convertir desconocido en cero',
    () async {
      final presupuestoId = await _crearPresupuesto(database, presupuestos);
      final primera =
          (await database.lineasPresupuestoDao.obtenerPorPresupuesto(
            presupuestoId,
          )).first;
      final categoria = (await economia.observarCategorias().first).first;
      await economia.guardarPorcentajeIndirectos(10);
      await economia.guardarCosteLinea(
        lineaId: primera.id,
        categoriaId: categoria.id,
        coste: 0,
      );

      await presupuestos.aceptarPresupuesto(presupuestoId);
      final plan = await economia.obtenerPlanPorPresupuesto(presupuestoId);
      expect(plan!.magnitudes.cobertura, CoberturaCostesPlan.parcial);
      expect(plan.magnitudes.costeDirectoCentimos, isNull);
      expect(plan.magnitudes.beneficioPrevistoCentimos, isNull);
    },
  );

  test('fallo de Timeline revierte aceptación, plan y partidas', () async {
    final presupuestoId = await _crearPresupuesto(database, presupuestos);
    await database.customStatement('''
      CREATE TRIGGER impedir_plan_timeline
      BEFORE INSERT ON timeline_events
      BEGIN SELECT RAISE(ABORT, 'fallo'); END;
    ''');

    await expectLater(
      presupuestos.aceptarPresupuesto(presupuestoId),
      throwsA(anything),
    );
    expect(await economia.obtenerPlanPorPresupuesto(presupuestoId), isNull);
    expect(
      (await database.presupuestosDao.obtenerPorId(presupuestoId))!.estado,
      'Borrador',
    );
  });

  test('constraints impiden usar categoría de otro tenant', () async {
    const tenantB = '00000000-0000-4000-8000-000000000024';
    await database
        .into(database.tenants)
        .insert(
          TenantsCompanion.insert(
            id: tenantB,
            nombre: 'Tenant B',
            fechaCreacion: DateTime.now().toUtc(),
            fechaModificacion: DateTime.now().toUtc(),
          ),
        );
    await database
        .into(database.categoriasEconomicas)
        .insert(
          CategoriasEconomicasCompanion.insert(
            tenantId: tenantB,
            id: 'categoria-b',
            codigo: 'material-b',
            nombre: 'Material B',
            fechaCreacion: DateTime.now().toUtc(),
            fechaModificacion: DateTime.now().toUtc(),
          ),
        );
    final presupuestoId = await _crearPresupuesto(database, presupuestos);
    final linea = (await database.lineasPresupuestoDao.obtenerPorPresupuesto(
      presupuestoId,
    )).first;

    await expectLater(
      database
          .into(database.lineaPresupuestoCostesPrevistos)
          .insert(
            LineaPresupuestoCostesPrevistosCompanion.insert(
              tenantId: database.activeTenantId,
              id: 'coste-cruzado',
              lineaPresupuestoId: linea.id,
              categoriaEconomicaId: 'categoria-b',
              costePrevistoCentimos: 100,
              fechaCreacion: DateTime.now().toUtc(),
              fechaModificacion: DateTime.now().toUtc(),
            ),
          ),
      throwsA(anything),
    );
  });
}

Future<String> _crearPresupuesto(
  AppDatabase database,
  PresupuestoRepository presupuestos,
) async {
  await database.clientesDao.insertarCliente(
    ClientesCompanion.insert(id: 'cliente', nombre: 'Cliente'),
  );
  await database.expedientesDao.insertarExpediente(
    ExpedientesCompanion.insert(
      id: 'expediente',
      codigo: 'EXP',
      nombre: 'Obra',
      clienteId: const Value('cliente'),
    ),
  );
  await presupuestos.crearPresupuesto(
    expedienteId: 'expediente',
    fecha: DateTime(2026, 9, 4),
  );
  final presupuesto =
      (await presupuestos.observarPorExpediente('expediente').first).single;
  final lineas = LineaPresupuestoRepository(database);
  await lineas.crearLinea(
    presupuestoId: presupuesto.id,
    concepto: 'Material',
    cantidad: 2,
    precioUnitario: 30,
  );
  await lineas.crearLinea(
    presupuestoId: presupuesto.id,
    concepto: 'Trabajo',
    cantidad: 4,
    precioUnitario: 10,
  );
  return presupuesto.id;
}

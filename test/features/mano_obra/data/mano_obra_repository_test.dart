import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/features/mano_obra/data/mano_obra_repository.dart';
import 'package:obraia_v2/features/mano_obra/domain/mano_obra.dart';

void main() {
  late AppDatabase db;
  late ManoObraRepository repository;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    await db.ensureReady();
    repository = ManoObraRepository(db);
    await db.expedientesDao.insertarExpediente(
      ExpedientesCompanion.insert(id: 'obra', codigo: 'OBR', nombre: 'Obra'),
    );
  });
  tearDown(() => db.close());

  Future<String> persona(
    TipoPersonaLaboral tipo, {
    String nombre = 'Persona',
  }) => repository.guardarPersona(nombre: nombre, tipo: tipo);

  test(
    'titular y empleado generan coste económico sin afectar venta',
    () async {
      final titular = await persona(
        TipoPersonaLaboral.titular,
        nombre: 'Titular',
      );
      final empleado = await persona(
        TipoPersonaLaboral.empleado,
        nombre: 'Empleado',
      );
      for (final id in [titular, empleado]) {
        await repository.agregarTarifa(
          personaId: id,
          importeHoraCentimos: 2500,
          vigenteDesde: DateTime.utc(2026),
        );
        await repository.registrarParte(
          expedienteId: 'obra',
          personaId: id,
          fechaTrabajo: DateTime.utc(2026, 9, 4),
          horasDiezMilesimas: 80000,
          descripcionTrabajo: 'Jornada',
        );
      }
      final resumen = await repository.obtenerResumenObra('obra');
      expect(resumen.horasTotalesDiezMilesimas, 160000);
      expect(resumen.costeRealCentimos, 40000);
      expect(
        (await db
                .customSelect('SELECT count(*) AS total FROM facturas')
                .getSingle())
            .read<int>('total'),
        0,
      );
      expect(resumen.cobertura, CoberturaManoObra.completa);
    },
  );

  test(
    'hora fraccionaria redondea y la tarifa histórica queda congelada',
    () async {
      final id = await persona(TipoPersonaLaboral.empleado);
      await repository.agregarTarifa(
        personaId: id,
        importeHoraCentimos: 2337,
        vigenteDesde: DateTime.utc(2026, 1, 1),
        vigenteHasta: DateTime.utc(2026, 6, 30),
      );
      await repository.agregarTarifa(
        personaId: id,
        importeHoraCentimos: 3000,
        vigenteDesde: DateTime.utc(2026, 7, 1),
      );
      final parteId = await repository.registrarParte(
        expedienteId: 'obra',
        personaId: id,
        fechaTrabajo: DateTime.utc(2026, 6, 1),
        horasDiezMilesimas: 75000,
        descripcionTrabajo: '7,5 horas',
      );
      final parte = await db.manoObraDao.obtenerParte(parteId);
      expect(parte!.tarifaHoraSnapshotCentimos, 2337);
      expect(parte.costeSnapshotCentimos, 17528);
      expect(ManoObraRepository.calcularCosteCentimos(1, 5000), 1);
    },
  );

  test(
    'una tarifa nueva cierra la abierta sin alterar partes pasados',
    () async {
      final id = await persona(TipoPersonaLaboral.empleado);
      await repository.agregarTarifa(
        personaId: id,
        importeHoraCentimos: 2000,
        vigenteDesde: DateTime.utc(2026, 1, 1),
      );
      final parteId = await repository.registrarParte(
        expedienteId: 'obra',
        personaId: id,
        fechaTrabajo: DateTime.utc(2026, 6, 1),
        horasDiezMilesimas: 10000,
        descripcionTrabajo: 'Antes del cambio',
      );
      await repository.agregarTarifa(
        personaId: id,
        importeHoraCentimos: 3000,
        vigenteDesde: DateTime.utc(2026, 7, 1),
      );
      expect(
        (await db.manoObraDao.obtenerParte(parteId))!.costeSnapshotCentimos,
        2000,
      );
      expect(
        (await repository.obtenerTarifaAplicable(
          id,
          DateTime.utc(2026, 8, 1),
        ))!.importeHoraCentimos,
        3000,
      );
      expect(
        (await repository.obtenerTarifas(
          id,
        )).singleWhere((t) => t.importeHoraCentimos == 2000).vigenteHasta,
        isNotNull,
      );
    },
  );

  test(
    'falta de tarifa registra horas pero no coste y permite valorar después',
    () async {
      final id = await persona(TipoPersonaLaboral.colaboradorInterno);
      final parteId = await repository.registrarParte(
        expedienteId: 'obra',
        personaId: id,
        fechaTrabajo: DateTime.utc(2026, 9, 4),
        horasDiezMilesimas: 80000,
        descripcionTrabajo: 'Trabajo pendiente',
      );
      var parte = await db.manoObraDao.obtenerParte(parteId);
      expect(parte!.estado, 'pendienteValoracion');
      expect(parte.costeSnapshotCentimos, isA<Null>());
      expect(
        await db.hechosCosteDao.obtenerPorOrigen('parteTrabajo', parteId),
        isEmpty,
      );
      expect(
        (await repository.obtenerResumenObra('obra')).cobertura,
        CoberturaManoObra.sinValorar,
      );

      await repository.agregarTarifa(
        personaId: id,
        importeHoraCentimos: 2000,
        vigenteDesde: DateTime.utc(2026),
      );
      await repository.completarValoracion(parteId);
      parte = await db.manoObraDao.obtenerParte(parteId);
      expect(parte!.costeSnapshotCentimos, 16000);
      expect(
        await db.hechosCosteDao.obtenerPorOrigen('parteTrabajo', parteId),
        hasLength(1),
      );
      await expectLater(
        repository.completarValoracion(parteId),
        throwsStateError,
      );
    },
  );

  test(
    'reversión conserva historia, neutraliza coste y evita duplicado',
    () async {
      final id = await persona(TipoPersonaLaboral.empleado);
      await repository.agregarTarifa(
        personaId: id,
        importeHoraCentimos: 2000,
        vigenteDesde: DateTime.utc(2026),
      );
      final parteId = await repository.registrarParte(
        expedienteId: 'obra',
        personaId: id,
        fechaTrabajo: DateTime.utc(2026, 9, 4),
        horasDiezMilesimas: 20000,
        descripcionTrabajo: 'Original',
      );
      await repository.revertirParte(parteId, motivo: 'Corrección');
      final hechos = await db.hechosCosteDao.obtenerPorOrigen(
        'parteTrabajo',
        parteId,
      );
      expect(
        hechos.map((h) => h.importeCosteCentimos),
        containsAll([4000, -4000]),
      );
      expect((await db.manoObraDao.obtenerParte(parteId))!.estado, 'revertido');
      await expectLater(
        repository.revertirParte(parteId, motivo: 'Otra'),
        throwsStateError,
      );

      final reemplazo = await repository.registrarParte(
        expedienteId: 'obra',
        personaId: id,
        fechaTrabajo: DateTime.utc(2026, 9, 4),
        horasDiezMilesimas: 30000,
        descripcionTrabajo: 'Corregido',
      );
      expect(reemplazo, isNot(parteId));
      expect(hechos, hasLength(2));
      expect(
        (await repository.obtenerResumenObra('obra')).costeRealCentimos,
        6000,
      );
    },
  );

  test(
    'cobertura parcial y agregados por persona/periodo son explícitos',
    () async {
      final valorado = await persona(TipoPersonaLaboral.empleado, nombre: 'A');
      final pendiente = await persona(
        TipoPersonaLaboral.otroInterno,
        nombre: 'B',
      );
      await repository.agregarTarifa(
        personaId: valorado,
        importeHoraCentimos: 1000,
        vigenteDesde: DateTime.utc(2026),
      );
      for (final item in [(valorado, 10000), (pendiente, 20000)]) {
        await repository.registrarParte(
          expedienteId: 'obra',
          personaId: item.$1,
          fechaTrabajo: DateTime.utc(2026, 9, 4),
          horasDiezMilesimas: item.$2,
          descripcionTrabajo: 'Trabajo',
        );
      }
      final resumen = await repository.obtenerResumenObra('obra');
      expect(resumen.cobertura, CoberturaManoObra.parcial);
      expect(resumen.horasSinValorarDiezMilesimas, 20000);
      expect(resumen.costeSinPartidaCentimos, 1000);
      final porPersona = await repository.obtenerResumenPersona(
        valorado,
        desde: DateTime.utc(2026),
        hasta: DateTime.utc(2026, 12, 31),
      );
      expect(porPersona.horasDiezMilesimas, 10000);
      expect(porPersona.expedientes, {'obra'});
    },
  );

  test(
    'tenant A/B queda aislado y relaciones cruzadas son rechazadas',
    () async {
      final personaA = await persona(TipoPersonaLaboral.empleado);
      const tenantB = '00000000-0000-4000-8000-000000000026';
      final now = DateTime.now().toUtc();
      await db
          .into(db.tenants)
          .insert(
            TenantsCompanion.insert(
              id: tenantB,
              nombre: 'B',
              fechaCreacion: now,
              fechaModificacion: now,
            ),
          );
      db.tenantContext.activate(tenantB);
      await db.ensureReady();
      expect(await repository.observarPersonas().first, isEmpty);
      await expectLater(
        repository.agregarTarifa(
          personaId: personaA,
          importeHoraCentimos: 1000,
          vigenteDesde: now,
        ),
        throwsStateError,
      );
    },
  );

  test('fallo de Timeline revierte parte y hecho de forma atómica', () async {
    final id = await persona(TipoPersonaLaboral.empleado);
    await repository.agregarTarifa(
      personaId: id,
      importeHoraCentimos: 1000,
      vigenteDesde: DateTime.utc(2026),
    );
    await db.customStatement('''
      CREATE TRIGGER bloquear_timeline_mo BEFORE INSERT ON timeline_events
      BEGIN SELECT RAISE(ABORT, 'fallo timeline'); END
    ''');
    await expectLater(
      repository.registrarParte(
        expedienteId: 'obra',
        personaId: id,
        fechaTrabajo: DateTime.utc(2026, 9, 4),
        horasDiezMilesimas: 10000,
        descripcionTrabajo: 'Rollback',
      ),
      throwsA(anything),
    );
    expect(await db.manoObraDao.obtenerPartesObra('obra'), isEmpty);
    expect(await db.hechosCosteDao.obtenerPorExpediente('obra'), isEmpty);
  });
}

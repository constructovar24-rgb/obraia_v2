import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/features/economia/data/cierre_economico_repository.dart';
import 'package:obraia_v2/features/economia/domain/cierre_economico.dart';
import 'package:obraia_v2/features/planificacion/data/planificacion_obra_repository.dart';
import 'package:obraia_v2/features/planificacion/domain/planificacion_obra.dart';

void main() {
  late AppDatabase db;
  late PlanificacionObraRepository repository;
  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    await db.ensureReady();
    await db.expedientesDao.insertarExpediente(
      ExpedientesCompanion.insert(id: 'obra', codigo: 'OBR', nombre: 'Obra'),
    );
    repository = PlanificacionObraRepository(db);
  });
  tearDown(() => db.close());

  test('valida fechas previstas y reales sin inventarlas', () async {
    final end = DateTime(2026, 1, 1);
    final start = DateTime(2026, 2, 1);
    await expectLater(
      repository.guardarCalendario(
        expedienteId: 'obra',
        inicioPrevisto: start,
        finPrevisto: end,
      ),
      throwsA(isA<PlanificacionFechasInvalidasException>()),
    );
    await expectLater(
      repository.guardarCalendario(
        expedienteId: 'obra',
        inicioReal: start,
        finReal: end,
      ),
      throwsA(isA<PlanificacionFechasInvalidasException>()),
    );
    await repository.guardarCalendario(
      expedienteId: 'obra',
      inicioPrevisto: end,
      finPrevisto: start,
    );
    final planning = await repository.observarPlanificacion('obra').first;
    expect(planning!.inicioReal, isNull);
    expect(planning.finReal, isNull);
  });

  test('estado operativo cambia y sigue independiente del económico', () async {
    await repository.cambiarEstado(
      'obra',
      EstadoOperativoObra.finalizada,
      finReal: DateTime(2026, 9, 5),
    );
    expect(
      (await repository.observarPlanificacion('obra').first)!.estado,
      EstadoOperativoObra.finalizada,
    );
    expect(
      (await CierreEconomicoRepository(db).obtenerEstado('obra')).estado,
      EstadoEconomicoObra.abierto,
    );
  });

  test(
    'próximo paso sustituye pendiente y actuación completa/cancela',
    () async {
      await repository.guardarProximoPaso(
        expedienteId: 'obra',
        descripcion: 'Pedir material',
      );
      await repository.guardarProximoPaso(
        expedienteId: 'obra',
        descripcion: 'Entrar a obra',
      );
      await repository.crearActuacion(
        expedienteId: 'obra',
        descripcion: 'Hormigonar losa',
        orden: 1,
      );
      await repository.crearActuacion(
        expedienteId: 'obra',
        descripcion: 'Revisar acabado',
        orden: 2,
      );
      var rows = await repository.observarActuaciones('obra').first;
      expect(
        rows
            .where(
              (a) =>
                  a.tipo == TipoActuacionObra.proximoPaso &&
                  a.estado == EstadoActuacionObra.pendiente,
            )
            .single
            .descripcion,
        'Entrar a obra',
      );
      final milestone = rows.singleWhere(
        (a) => a.descripcion == 'Hormigonar losa',
      );
      final cancelled = rows.singleWhere(
        (a) => a.descripcion == 'Revisar acabado',
      );
      await repository.cambiarEstadoActuacion(
        milestone,
        EstadoActuacionObra.completado,
      );
      await repository.cambiarEstadoActuacion(
        cancelled,
        EstadoActuacionObra.cancelado,
      );
      rows = await repository.observarActuaciones('obra').first;
      expect(
        rows.singleWhere((a) => a.id == milestone.id).estado,
        EstadoActuacionObra.completado,
      );
      expect(
        rows.singleWhere((a) => a.id == cancelled.id).estado,
        EstadoActuacionObra.cancelado,
      );
    },
  );

  test('tenant isolation y atomicidad de Timeline', () async {
    await repository.crearActuacion(
      expedienteId: 'obra',
      descripcion: 'Visible A',
    );
    await db
        .into(db.tenants)
        .insert(
          TenantsCompanion.insert(
            id: 'tenant-b',
            nombre: 'B',
            fechaCreacion: DateTime.now(),
            fechaModificacion: DateTime.now(),
          ),
        );
    db.tenantContext.activate('tenant-b');
    expect(await repository.observarActuaciones('obra').first, isEmpty);
    db.tenantContext.activate('00000000-0000-4000-8000-000000000023');
    await db.customStatement('''
      CREATE TRIGGER bloquear_plan_timeline BEFORE INSERT ON timeline_events
      BEGIN SELECT RAISE(ABORT, 'fallo timeline'); END
    ''');
    await expectLater(
      repository.crearActuacion(
        expedienteId: 'obra',
        descripcion: 'Debe revertirse',
      ),
      throwsA(anything),
    );
    expect(
      (await repository.observarActuaciones('obra').first).where(
        (a) => a.descripcion == 'Debe revertirse',
      ),
      isEmpty,
    );
  });
}

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/features/diario_obra/data/diario_obra_repository.dart';
import 'package:obraia_v2/features/planificacion/data/planificacion_obra_repository.dart';

void main() {
  late AppDatabase db;
  late DiarioObraRepository repository;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    await db.ensureReady();
    await db.expedientesDao.insertarExpediente(
      ExpedientesCompanion.insert(id: 'obra', codigo: 'OBR', nombre: 'Obra'),
    );
    repository = DiarioObraRepository(db);
  });

  tearDown(() => db.close());

  test('crea, ordena, edita y anula sin generar hechos económicos', () async {
    final older = await repository.crear(
      expedienteId: 'obra',
      fechaTrabajo: DateTime(2026, 9, 3),
      trabajos: ' Excavación terminada ',
      observaciones: '  Sin novedad ',
    );
    final newer = await repository.crear(
      expedienteId: 'obra',
      fechaTrabajo: DateTime(2026, 9, 5),
      trabajos: 'Hormigonada la losa',
      incidenciaTexto: 'Retraso del suministro',
    );

    var entries = await repository.observarEntradas('obra').first;
    expect(entries.map((entry) => entry.id), [newer, older]);
    expect(entries.last.trabajos, 'Excavación terminada');
    expect(entries.last.observaciones, 'Sin novedad');

    await repository.editar(
      id: older,
      fechaTrabajo: DateTime(2026, 9, 4),
      trabajos: 'Excavación revisada',
      meteorologia: 'Nublado',
    );
    entries = await repository.observarEntradas('obra').first;
    expect(entries.last.trabajos, 'Excavación revisada');
    expect(entries.last.meteorologia, 'Nublado');
    expect(entries.last.fechaModificacion, isNotNull);

    await repository.anular(newer);
    entries = await repository.observarEntradas('obra').first;
    expect(entries.first.anulado, isTrue);
    expect((await db.select(db.hechosCoste).get()), isEmpty);
  });

  test('admite actuación opcional sin modificar su estado', () async {
    final planning = PlanificacionObraRepository(db);
    await planning.crearActuacion(
      expedienteId: 'obra',
      descripcion: 'Colocación de bloque',
    );
    final actionId =
        (await planning.observarActuaciones('obra').first).single.id;
    await repository.crear(
      expedienteId: 'obra',
      fechaTrabajo: DateTime(2026, 9, 5),
      trabajos: 'Ejecutados 28 m² de bloque H',
      actuacionId: actionId,
    );

    final entry = (await repository.observarEntradas('obra').first).single;
    expect(entry.actuacionId, actionId);
    expect(entry.actuacionDescripcion, 'Colocación de bloque');
    final action = (await planning.observarActuaciones('obra').first).single;
    expect(action.estado.name, 'pendiente');
  });

  test('aísla tenants y revierte Diario si falla Timeline', () async {
    await repository.crear(
      expedienteId: 'obra',
      fechaTrabajo: DateTime(2026, 9, 5),
      trabajos: 'Visible solo para A',
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
    expect(await repository.observarEntradas('obra').first, isEmpty);

    db.tenantContext.activate('00000000-0000-4000-8000-000000000023');
    await db.customStatement('''
      CREATE TRIGGER bloquear_diario_timeline BEFORE INSERT ON timeline_events
      BEGIN SELECT RAISE(ABORT, 'fallo timeline'); END
    ''');
    await expectLater(
      repository.crear(
        expedienteId: 'obra',
        fechaTrabajo: DateTime(2026, 9, 6),
        trabajos: 'Debe revertirse',
      ),
      throwsA(anything),
    );
    expect(
      (await repository.observarEntradas('obra').first).where(
        (entry) => entry.trabajos == 'Debe revertirse',
      ),
      isEmpty,
    );
  });
}

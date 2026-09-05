import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/features/diario_obra/data/diario_obra_repository.dart';
import 'package:obraia_v2/features/incidencias/data/incidencias_obra_repository.dart';
import 'package:obraia_v2/features/incidencias/domain/incidencia_obra.dart';

void main() {
  late AppDatabase db;
  late IncidenciasObraRepository repository;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    await db.ensureReady();
    await db.expedientesDao.insertarExpediente(
      ExpedientesCompanion.insert(id: 'obra', codigo: 'OBR', nombre: 'Obra'),
    );
    repository = IncidenciasObraRepository(db);
  });

  tearDown(() => db.close());

  test('crea, sigue, resuelve, reabre y cancela con fechas válidas', () async {
    final detected = DateTime(2026, 9, 5);
    final id = await repository.crear(
      expedienteId: 'obra',
      fechaDeteccion: detected,
      titulo: 'Fisura en muro',
      descripcion: 'Fisura vertical junto al encuentro',
      prioridad: PrioridadIncidenciaObra.alta,
    );
    await repository.cambiarEstado(id, EstadoIncidenciaObra.enSeguimiento);
    await expectLater(
      repository.cambiarEstado(
        id,
        EstadoIncidenciaObra.resuelta,
        fechaResolucion: DateTime(2026, 9, 4),
      ),
      throwsA(isA<IncidenciaFechaResolucionInvalida>()),
    );
    await repository.cambiarEstado(
      id,
      EstadoIncidenciaObra.resuelta,
      fechaResolucion: DateTime(2026, 9, 6),
      resolucion: 'Sellado y comprobado',
    );
    var row = (await repository.observarPorObra('obra').first).single;
    expect(row.estado, EstadoIncidenciaObra.resuelta);
    expect(row.resolucion, 'Sellado y comprobado');
    await repository.cambiarEstado(id, EstadoIncidenciaObra.abierta);
    await repository.cambiarEstado(id, EstadoIncidenciaObra.cancelada);
    row = (await repository.observarPorObra('obra').first).single;
    expect(row.estado, EstadoIncidenciaObra.cancelada);
    expect(row.fechaResolucion, isNull);
  });

  test('vincula el documento y Diario existentes sin duplicarlos', () async {
    await db.documentosDao.insertarDocumento(
      DocumentosCompanion.insert(
        id: 'foto',
        expedienteId: 'obra',
        titulo: 'Detalle de fisura',
        nombreArchivo: 'fisura.jpg',
        rutaArchivo: r'C:\evidencias\fisura.jpg',
        tamanoBytes: 100,
        tipo: const Value('fotografia'),
      ),
    );
    final diaryId = await DiarioObraRepository(db).crear(
      expedienteId: 'obra',
      fechaTrabajo: DateTime(2026, 9, 5),
      trabajos: 'Inspección del muro',
    );
    final id = await repository.crear(
      expedienteId: 'obra',
      fechaDeteccion: DateTime(2026, 9, 5),
      titulo: 'Fisura',
      descripcion: 'Detectada durante inspección',
      prioridad: PrioridadIncidenciaObra.media,
      documentoIds: const ['foto', 'foto'],
      entradaDiarioIds: [diaryId],
    );
    final row = (await repository.observarPorObra('obra').first).single;
    expect(row.documentoIds, ['foto']);
    expect(row.entradaDiarioIds, [diaryId]);
    expect(await db.select(db.documentos).get(), hasLength(1));
    expect(await db.select(db.diarioObra).get(), hasLength(1));
    expect((await db.incidenciasObraDao.obtener(id))!.expedienteId, 'obra');
  });

  test('aísla tenants y no cambia economía ni estado operativo', () async {
    await repository.crear(
      expedienteId: 'obra',
      fechaDeteccion: DateTime(2026, 9, 5),
      titulo: 'Incidencia A',
      descripcion: 'Solo tenant A',
      prioridad: PrioridadIncidenciaObra.baja,
    );
    final before = await db.planificacionObraDao.obtenerPlanificacion('obra');
    expect(await db.select(db.hechosCoste).get(), isEmpty);
    expect(before!.estadoOperativo, 'pendiente');

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
    expect(await repository.observarPorObra('obra').first, isEmpty);
  });

  test('revierte la incidencia si falla Timeline', () async {
    await db.customStatement('''
      CREATE TRIGGER bloquear_incidencia_timeline BEFORE INSERT ON timeline_events
      BEGIN SELECT RAISE(ABORT, 'fallo timeline'); END
    ''');
    await expectLater(
      repository.crear(
        expedienteId: 'obra',
        fechaDeteccion: DateTime(2026, 9, 5),
        titulo: 'Debe revertirse',
        descripcion: 'No debe persistir',
        prioridad: PrioridadIncidenciaObra.media,
      ),
      throwsA(anything),
    );
    expect(await repository.observarPorObra('obra').first, isEmpty);
  });
}

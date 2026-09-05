import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/features/economia/data/hecho_coste_repository.dart';
import 'package:obraia_v2/features/economia/data/prevision_economica_repository.dart';
import 'package:obraia_v2/features/economia/domain/prevision_economica.dart';

void main() {
  late AppDatabase db;
  late PrevisionEconomicaRepository repository;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    await db.ensureReady();
    await db.expedientesDao.insertarExpediente(
      ExpedientesCompanion.insert(id: 'obra', codigo: 'OBR', nombre: 'Obra'),
    );
    repository = PrevisionEconomicaRepository(db);
  });
  tearDown(() => db.close());

  Future<String> hecho(int amount) => HechoCosteRepository(db).registrarAjuste(
    expedienteId: 'obra',
    fechaDevengo: DateTime.utc(2026, 9, 5),
    importeNetoCentimos: amount,
    descripcion: 'Coste real',
  );

  test('consume parcialmente, bloquea sobreconsumo y completa', () async {
    final compromiso = await repository.crearCompromiso(
      expedienteId: 'obra',
      descripcion: 'Pedido de material',
      origenTipo: 'pedido',
      importeCentimos: 10000,
      fecha: DateTime.utc(2026, 9, 5),
    );
    final h1 = await hecho(4000);
    final h2 = await hecho(6000);
    await repository.aplicarHecho(
      compromisoId: compromiso,
      hechoCosteId: h1,
      importeCentimos: 4000,
    );
    expect(
      (await repository.obtenerCompromisos('obra')).single.pendienteCentimos,
      6000,
    );
    await expectLater(
      repository.aplicarHecho(
        compromisoId: compromiso,
        hechoCosteId: h2,
        importeCentimos: 6001,
      ),
      throwsStateError,
    );
    await repository.aplicarHecho(
      compromisoId: compromiso,
      hechoCosteId: h2,
      importeCentimos: 6000,
    );
    expect(
      (await repository.obtenerCompromisos('obra')).single.estado,
      EstadoCompromiso.cumplido,
    );
  });

  test(
    'reversión del hecho reabre el saldo sin borrar la aplicación',
    () async {
      final compromiso = await repository.crearCompromiso(
        expedienteId: 'obra',
        descripcion: 'Subcontrata',
        origenTipo: 'subcontrata',
        importeCentimos: 5000,
        fecha: DateTime.utc(2026, 9, 5),
      );
      final original = await hecho(5000);
      await repository.aplicarHecho(
        compromisoId: compromiso,
        hechoCosteId: original,
        importeCentimos: 5000,
      );
      await db.hechosCosteDao.insertar(
        HechosCosteCompanion.insert(
          tenantId: db.activeTenantId,
          id: 'reversion',
          expedienteId: 'obra',
          fechaDevengo: DateTime.utc(2026, 9, 6),
          importeNetoCentimos: -5000,
          ivaNoRecuperableCentimos: 0,
          importeCosteCentimos: -5000,
          descripcion: 'Reversión',
          origenTipo: 'ajusteManual',
          origenId: original,
          tipoMovimiento: 'reversion',
          hechoRevertidoId: Value(original),
          claveIdempotencia: 'rev:$original',
          fechaCreacion: DateTime.now().toUtc(),
        ),
      );
      final current = (await repository.obtenerCompromisos('obra')).single;
      expect(current.estado, EstadoCompromiso.activo);
      expect(current.pendienteCentimos, 5000);
      expect(
        await db.previsionEconomicaDao.obtenerAplicaciones(compromiso),
        hasLength(1),
      );
    },
  );

  test('sin estimación el coste final no se inventa como coste real', () async {
    await hecho(1200);
    final summary = await repository.obtenerResumen('obra');
    expect(summary.costeRealCentimos, 1200);
    expect(summary.cobertura, CoberturaForecast.noDisponible);
    expect(summary.costeFinalEstimadoCentimos, null);
  });

  test(
    'las revisiones conservan historial y solo suma la última versión',
    () async {
      final first = await repository.registrarEstimacion(
        expedienteId: 'obra',
        importeAdicionalCentimos: 9000,
        justificacion: 'Primera revisión',
        fecha: DateTime.utc(2026, 9, 5),
      );
      final series = (await repository.obtenerHistorialEstimaciones(
        'obra',
      )).single.serieId;
      await repository.registrarEstimacion(
        expedienteId: 'obra',
        serieId: series,
        importeAdicionalCentimos: 7000,
        justificacion: 'Segunda revisión',
        fecha: DateTime.utc(2026, 9, 6),
      );
      expect(first, isNotEmpty);
      expect(
        await repository.obtenerHistorialEstimaciones('obra'),
        hasLength(2),
      );
      expect(
        (await repository.obtenerResumen('obra')).estimacionAdicionalCentimos,
        7000,
      );
    },
  );

  test('un hecho de otra obra no puede consumir el compromiso', () async {
    await db.expedientesDao.insertarExpediente(
      ExpedientesCompanion.insert(id: 'otra', codigo: 'OTR', nombre: 'Otra'),
    );
    final compromiso = await repository.crearCompromiso(
      expedienteId: 'obra',
      descripcion: 'Pedido',
      origenTipo: 'pedido',
      importeCentimos: 100,
      fecha: DateTime.now(),
    );
    final other = await HechoCosteRepository(db).registrarAjuste(
      expedienteId: 'otra',
      fechaDevengo: DateTime.now(),
      importeNetoCentimos: 100,
      descripcion: 'Otro',
    );
    await expectLater(
      repository.aplicarHecho(
        compromisoId: compromiso,
        hechoCosteId: other,
        importeCentimos: 100,
      ),
      throwsStateError,
    );
  });

  test('fallo de Timeline revierte el alta del compromiso', () async {
    await db.customStatement('''
      CREATE TRIGGER bloquear_prevision_timeline BEFORE INSERT ON timeline_events
      BEGIN SELECT RAISE(ABORT, 'fallo timeline'); END
    ''');
    await expectLater(
      repository.crearCompromiso(
        expedienteId: 'obra',
        descripcion: 'No debe persistir',
        origenTipo: 'otro',
        importeCentimos: 100,
        fecha: DateTime.now(),
      ),
      throwsA(anything),
    );
    expect(await repository.obtenerCompromisos('obra'), isEmpty);
  });
}

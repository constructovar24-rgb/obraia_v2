import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/features/economia/data/cierre_economico_repository.dart';
import 'package:obraia_v2/features/economia/data/hecho_coste_repository.dart';
import 'package:obraia_v2/features/economia/domain/cierre_economico.dart';

void main() {
  late AppDatabase db;
  late CierreEconomicoRepository cierre;
  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    await db.ensureReady();
    await db.expedientesDao.insertarExpediente(
      ExpedientesCompanion.insert(id: 'obra', codigo: 'OBR', nombre: 'Obra'),
    );
    cierre = CierreEconomicoRepository(db);
  });
  tearDown(() => db.close());

  test(
    'legacy permanece abierto y cierre exige confirmar advertencias',
    () async {
      final state = await cierre.obtenerEstado('obra');
      expect(state.estado, EstadoEconomicoObra.abierto);
      expect(state.numeroCierres, 0);
      final check = await cierre.evaluarCierre('obra');
      expect(check.tieneBloqueos, isFalse);
      expect(check.tieneAdvertencias, isTrue);
      await expectLater(
        cierre.cerrar('obra', confirmarAdvertencias: false),
        throwsStateError,
      );
      expect(
        (await cierre.obtenerEstado('obra')).estado,
        EstadoEconomicoObra.abierto,
      );
    },
  );

  test('cierre congela unknown y pérdida no es bloqueo', () async {
    final id = await cierre.cerrar('obra', confirmarAdvertencias: true);
    final snapshot = (await cierre.obtenerHistorial('obra')).single;
    expect(snapshot.id, id);
    expect(snapshot.conAdvertencias, isTrue);
    expect(snapshot.resumen.ventaPlanificadaCentimos, null);
    expect(snapshot.resumen.costeFinalEstimadoCentimos, null);
    expect(
      (await cierre.obtenerEstado('obra')).estado,
      EstadoEconomicoObra.cerrado,
    );
  });

  test(
    'reapertura exige motivo y segundo cierre conserva ambos snapshots',
    () async {
      await cierre.cerrar('obra', confirmarAdvertencias: true);
      await expectLater(
        cierre.reabrir('obra', motivo: '  '),
        throwsArgumentError,
      );
      await cierre.reabrir('obra', motivo: 'Registrar ajuste final');
      expect(
        (await cierre.obtenerEstado('obra')).estado,
        EstadoEconomicoObra.abierto,
      );
      expect(
        (await cierre.obtenerReaperturas('obra')).single.motivo,
        'Registrar ajuste final',
      );
      await cierre.cerrar('obra', confirmarAdvertencias: true);
      final history = await cierre.obtenerHistorial('obra');
      expect(history.map((e) => e.numero), [2, 1]);
    },
  );

  test('obra cerrada bloquea nuevos hechos económicos', () async {
    await cierre.cerrar('obra', confirmarAdvertencias: true);
    await expectLater(
      HechoCosteRepository(db).registrarAjuste(
        expedienteId: 'obra',
        fechaDevengo: DateTime.now(),
        importeNetoCentimos: 100,
        descripcion: 'No permitido',
      ),
      throwsStateError,
    );
  });

  test('fallo de Timeline revierte snapshot y estado', () async {
    await db.customStatement('''
      CREATE TRIGGER bloquear_cierre_timeline BEFORE INSERT ON timeline_events
      BEGIN SELECT RAISE(ABORT, 'fallo timeline'); END
    ''');
    await expectLater(
      cierre.cerrar('obra', confirmarAdvertencias: true),
      throwsA(anything),
    );
    expect(await cierre.obtenerHistorial('obra'), isEmpty);
    expect(
      (await cierre.obtenerEstado('obra')).estado,
      EstadoEconomicoObra.abierto,
    );
  });

  test('fallo de Timeline revierte reapertura y conserva cierre', () async {
    await cierre.cerrar('obra', confirmarAdvertencias: true);
    await db.customStatement('''
      CREATE TRIGGER bloquear_reapertura_timeline BEFORE INSERT ON timeline_events
      BEGIN SELECT RAISE(ABORT, 'fallo timeline'); END
    ''');
    await expectLater(
      cierre.reabrir('obra', motivo: 'Corrección'),
      throwsA(anything),
    );
    expect(
      (await cierre.obtenerEstado('obra')).estado,
      EstadoEconomicoObra.cerrado,
    );
    expect(await cierre.obtenerReaperturas('obra'), isEmpty);
    expect(await cierre.obtenerHistorial('obra'), hasLength(1));
  });

  test('alertas tienen severidad determinista', () async {
    final alerts = await cierre.obtenerAlertas('obra');
    expect(alerts, isNotEmpty);
    expect(
      alerts.singleWhere((a) => a.codigo == 'forecast_incompleto').severidad,
      SeveridadAlertaEconomica.atencion,
    );
  });
}

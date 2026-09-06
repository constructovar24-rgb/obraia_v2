import '../../presupuestos/data/prod2_test_support.dart';
import 'package:obraia_v2/features/presupuestos/data/presupuesto_repository.dart';
import 'dart:io';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:crypto/crypto.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/core/environment/app_environment.dart';
import 'package:obraia_v2/features/fiscal/data/configuracion_fiscal_repository.dart';
import 'package:obraia_v2/features/fiscal/domain/configuracion_fiscal.dart';
import 'package:obraia_v2/features/facturas/data/factura_repository.dart';
import 'package:obraia_v2/features/facturas/data/rectificativa_repository.dart';
import 'package:obraia_v2/features/facturas/domain/rectificativa.dart';
import 'package:obraia_v2/features/backup/data/backup_archive_service.dart';
import 'package:obraia_v2/features/backup/data/backup_restore_staging_service.dart';
import '../../../support/factura_fiscal_test_support.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase db;
  late ConfiguracionFiscalRepository fiscal;
  final year = DateTime.now().year;
  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    await db.ensureReady();
    fiscal = ConfiguracionFiscalRepository(db);
  });
  tearDown(() => db.close());
  Future<void> preparar({int? ejercicio, int inicio = 40}) =>
      fiscal.configurarEjercicio(
        ejercicio: ejercicio ?? year,
        serieOrdinaria: 'OBR',
        inicialOrdinaria: inicio,
        serieRectificativa: 'AB',
        inicialRectificativa: 7,
        preparada: true,
      );

  test('sin configuración bloquea emisión, sin documento ni número', () async {
    final id = await crearFacturaFiscalPrueba(db);
    await expectLater(
      FacturaRepository(db).emitirFactura(id),
      throwsA(isA<ConfiguracionFiscalException>()),
    );
    expect((await db.facturasDao.obtenerPorId(id))!.numeroLegal, isNull);
    expect(await db.facturaDocumentosEmitidosDao.obtener(id), isNull);
  });
  test('guardar sin preparar bloquea emisión; confirmar habilita', () async {
    await fiscal.configurar(
      ejercicio: year,
      tipo: 'ordinaria',
      serie: ' obr ',
      numeroInicial: 40,
      preparada: false,
    );
    final id = await crearFacturaFiscalPrueba(db);
    await expectLater(
      FacturaRepository(db).emitirFactura(id),
      throwsA(isA<ConfiguracionFiscalException>()),
    );
    await preparar();
    await FacturaRepository(db).emitirFactura(id);
    expect((await db.facturasDao.obtenerPorId(id))!.codigo, 'OBR-$year-0040');
  });
  test('primera y segunda consecutivas, snapshot y PDF coherentes', () async {
    await preparar();
    for (final n in [40, 41]) {
      final id = await crearFacturaFiscalPrueba(db);
      await FacturaRepository(db).emitirFactura(id);
      final f = (await db.facturasDao.obtenerPorId(id))!;
      expect(f.serie, 'OBR');
      expect(f.codigo, 'OBR-$year-00$n');
      expect(f.numeroLegal, n);
      final pdf = (await db.facturaDocumentosEmitidosDao.obtener(id))!;
      expect(pdf.sha256, sha256.convert(pdf.pdf).toString());
      expect(f.clienteNombreHistorico, 'CLIENTE FICTICIO');
    }
    final c = (await fiscal.obtener(
      year,
    )).firstWhere((c) => c.tipo == 'ordinaria');
    expect(c.siguienteNumero, 42);
    expect(c.emisiones, 2);
    expect(c.utilizada, isTrue);
    expect(c.primerUso, isNotNull);
    expect(
      (await db.seriesFiscalesDao.historial(
        year,
      )).where((e) => e.accion == 'emision'),
      hasLength(2),
    );
  });
  test(
    'rectificativas usan configuración independiente y serie personalizada',
    () async {
      await preparar();
      final presupuestoId = await crearPropuestaPrueba(db);
      await PresupuestoRepository(db).aceptarPresupuesto(presupuestoId);
      final presupuesto =
          (await db.presupuestosDao.observarPorExpediente('obra').first).single;
      final id = await FacturaRepository(
        db,
      ).convertirDesdePresupuesto(presupuesto);
      await FacturaRepository(db).emitirFactura(id);
      final linea = (await db.facturaLineasDao.obtenerPorFactura(id)).first;
      final repo = RectificativaRepository(db);
      for (final n in [7, 8]) {
        final rect = await repo.crear(
          facturaRectificadaId: id,
          motivo: 'Ajuste ficticio',
          ajustes: [
            AjusteRectificativa(
              lineaRectificadaId: linea.id,
              baseDiferencia: -1,
            ),
          ],
        );
        await repo.emitir(rect);
        final f = (await db.facturasDao.obtenerPorId(rect))!;
        expect(f.serie, 'AB');
        expect(f.codigo, 'AB-$year-000$n');
        expect(await db.facturaDocumentosEmitidosDao.obtener(rect), isNotNull);
      }
      expect(
        (await db.seriesFiscalesDao.obtener(
          year,
          'ordinaria',
        ))!.siguienteNumero,
        41,
      );
      expect(
        (await db.seriesFiscalesDao.obtener(
          year,
          'rectificativa',
        ))!.siguienteNumero,
        9,
      );
    },
  );
  for (final cambio in ['retroceder', 'adelantar', 'serie', 'despreparar']) {
    test('tras primer uso bloquea $cambio', () async {
      await preparar();
      final id = await crearFacturaFiscalPrueba(db);
      await FacturaRepository(db).emitirFactura(id);
      await expectLater(
        fiscal.configurar(
          ejercicio: year,
          tipo: 'ordinaria',
          serie: cambio == 'serie' ? 'OTRA' : 'OBR',
          numeroInicial: cambio == 'retroceder'
              ? 1
              : cambio == 'adelantar'
              ? 50
              : 40,
          preparada: cambio != 'despreparar',
        ),
        throwsA(isA<ConfiguracionFiscalException>()),
      );
      expect(
        (await db.seriesFiscalesDao.obtener(
          year,
          'ordinaria',
        ))!.siguienteNumero,
        41,
      );
      await expectLater(
        db.customStatement('UPDATE series_fiscales SET siguiente_numero = 1'),
        throwsA(anything),
      );
      await expectLater(
        db.customStatement('DELETE FROM series_fiscales'),
        throwsA(anything),
      );
    });
  }
  test('series distintas por circuito; ejercicios independientes', () async {
    await preparar();
    await expectLater(
      fiscal.configurar(
        ejercicio: year,
        tipo: 'rectificativa',
        serie: 'OBR',
        numeroInicial: 1,
        preparada: true,
      ),
      throwsA(isA<ConfiguracionFiscalException>()),
    );
    final id = await crearFacturaFiscalPrueba(db, ejercicio: year + 1);
    await expectLater(
      FacturaRepository(db).emitirFactura(id),
      throwsA(isA<ConfiguracionFiscalException>()),
    );
    await preparar(ejercicio: year + 1, inicio: 1);
    await FacturaRepository(db).emitirFactura(id);
    expect(
      (await db.facturasDao.obtenerPorId(id))!.codigo,
      'OBR-${year + 1}-0001',
    );
    expect(
      (await db.seriesFiscalesDao.obtener(year, 'ordinaria'))!.siguienteNumero,
      40,
    );
  });
  test(
    'dos tenants pueden usar misma serie/año/número sin compartir secuencia',
    () async {
      await preparar();
      final a = db.activeTenantId;
      final id = await crearFacturaFiscalPrueba(db);
      const b = 'tenant-fiscal-b';
      await db
          .into(db.tenants)
          .insert(
            TenantsCompanion.insert(
              id: b,
              nombre: 'Ficticio B',
              fechaCreacion: DateTime.now(),
              fechaModificacion: DateTime.now(),
            ),
          );
      db.tenantContext.activate(b);
      expect(await fiscal.obtener(year), isEmpty);
      await expectLater(
        FacturaRepository(db).emitirFactura(id),
        throwsA(isA<ConfiguracionFiscalException>()),
      );
      await preparar();
      final otro = await crearFacturaFiscalPrueba(db);
      await FacturaRepository(db).emitirFactura(otro);
      db.tenantContext.activate(a);
      expect(
        (await db.seriesFiscalesDao.obtener(
          year,
          'ordinaria',
        ))!.siguienteNumero,
        40,
      );
      await FacturaRepository(db).emitirFactura(id);
      expect((await db.facturasDao.obtenerPorId(id))!.codigo, 'OBR-$year-0040');
    },
  );
  test('emisiones concurrentes reciben números consecutivos únicos', () async {
    await preparar();
    final ids = <String>[];
    for (var i = 0; i < 8; i++) {
      ids.add(await crearFacturaFiscalPrueba(db));
    }
    await Future.wait(ids.map(FacturaRepository(db).emitirFactura));
    final ns = <int>[];
    for (final id in ids) {
      ns.add((await db.facturasDao.obtenerPorId(id))!.numeroLegal!);
    }
    expect(ns.toSet(), hasLength(8));
    expect(ns..sort(), List.generate(8, (i) => 40 + i));
    final once = await crearFacturaFiscalPrueba(db);
    final attempts = await Future.wait(
      List.generate(2, (_) async {
        try {
          await FacturaRepository(db).emitirFactura(once);
          return true;
        } catch (_) {
          return false;
        }
      }),
    );
    expect(attempts.where((v) => v), hasLength(1));
    expect(
      (await db.seriesFiscalesDao.obtener(year, 'ordinaria'))!.siguienteNumero,
      49,
    );
  });
  for (final destino in [
    'factura_documentos_emitidos',
    'eventos_serie_fiscal',
  ]) {
    test('fallo en $destino revierte número, snapshot, PDF y estado', () async {
      await preparar();
      final id = await crearFacturaFiscalPrueba(db);
      await db.customStatement(
        "CREATE TRIGGER fallo_fiscal BEFORE INSERT ON $destino BEGIN SELECT RAISE(ABORT,'fallo de prueba'); END",
      );
      await expectLater(
        FacturaRepository(db).emitirFactura(id),
        throwsA(anything),
      );
      expect(
        (await db.seriesFiscalesDao.obtener(
          year,
          'ordinaria',
        ))!.siguienteNumero,
        40,
      );
      expect((await db.facturasDao.obtenerPorId(id))!.numeroLegal, isNull);
      expect(await db.facturaDocumentosEmitidosDao.obtener(id), isNull);
      await db.customStatement('DROP TRIGGER fallo_fiscal');
      await FacturaRepository(db).emitirFactura(id);
      expect((await db.facturasDao.obtenerPorId(id))!.numeroLegal, 40);
    });
  }
  test('referencia ocupada bloquea sin saltarla ni consumir número', () async {
    await preparar();
    final id = await crearFacturaFiscalPrueba(db);
    final otro = await crearFacturaFiscalPrueba(db);
    await db.customStatement('UPDATE facturas SET codigo=? WHERE id=?', [
      'OBR-$year-0040',
      otro,
    ]);
    await expectLater(
      FacturaRepository(db).emitirFactura(id),
      throwsA(isA<ConfiguracionFiscalException>()),
    );
    expect(
      (await db.seriesFiscalesDao.obtener(year, 'ordinaria'))!.siguienteNumero,
      40,
    );
  });
  test('histórico exige continuidad explícita y queda inmutable', () async {
    final id = await crearFacturaFiscalPrueba(db);
    await db.customStatement(
      "UPDATE facturas SET estado='emitida',serie='ANT',anio_numeracion=?,numero_legal=10,codigo=? WHERE id=?",
      [year, 'ANT-$year-0010', id],
    );
    await expectLater(
      fiscal.configurar(
        ejercicio: year,
        tipo: 'ordinaria',
        serie: 'ANT',
        numeroInicial: 10,
        preparada: true,
      ),
      throwsA(isA<ConfiguracionFiscalException>()),
    );
    await fiscal.configurar(
      ejercicio: year,
      tipo: 'ordinaria',
      serie: 'ANT',
      numeroInicial: 11,
      preparada: true,
    );
    final c = (await fiscal.obtener(year)).single;
    expect(c.documentosPrevios, 1);
    expect(c.utilizada, isTrue);
    await expectLater(
      fiscal.configurar(
        ejercicio: year,
        tipo: 'ordinaria',
        serie: 'ANT',
        numeroInicial: 12,
        preparada: true,
      ),
      throwsA(isA<ConfiguracionFiscalException>()),
    );
    final nuevo = await crearFacturaFiscalPrueba(db);
    await FacturaRepository(db).emitirFactura(nuevo);
    expect((await db.facturasDao.obtenerPorId(nuevo))!.numeroLegal, 11);
    expect((await db.facturasDao.obtenerPorId(id))!.codigo, 'ANT-$year-0010');
  });
  test('PROD en memoria requiere preparación igual que DEV', () async {
    final prod = AppDatabase.forTesting(
      NativeDatabase.memory(),
      environment: AppEnvironment.production,
    );
    try {
      final id = await crearFacturaFiscalPrueba(prod);
      expect(await ConfiguracionFiscalRepository(prod).obtener(year), isEmpty);
      await expectLater(
        FacturaRepository(prod).emitirFactura(id),
        throwsA(isA<ConfiguracionFiscalException>()),
      );
    } finally {
      await prod.close();
    }
  });
  test('backup y staging conservan contador, auditoría y PDF', () async {
    await preparar();
    final id = await crearFacturaFiscalPrueba(db);
    await FacturaRepository(db).emitirFactura(id);
    final original = (await db.facturaDocumentosEmitidosDao.obtener(id))!;
    final dir = await Directory.systemTemp.createTemp('obraia-prod3-backup-');
    try {
      final backup = File('${dir.path}/copy.obraia-backup');
      await BackupArchiveService().createBackup(
        database: db,
        destinationPath: backup.path,
        appVersion: "test",
        appBuildNumber: "1",
      );
      final prepared = await BackupRestoreStagingService().prepare(
        backupPath: backup.path,
        currentSchemaVersion: 34,
      );
      try {
        final restored = AppDatabase.forTesting(
          NativeDatabase(prepared.preparedDatabaseFile),
        );
        try {
          expect(
            (await restored.seriesFiscalesDao.obtener(
              year,
              'ordinaria',
            ))!.siguienteNumero,
            41,
          );
          expect(
            (await restored.facturaDocumentosEmitidosDao.obtener(id))!.pdf,
            orderedEquals(original.pdf),
          );
          expect(
            await restored.seriesFiscalesDao.historial(year),
            hasLength(3),
          );
        } finally {
          await restored.close();
        }
      } finally {
        await prepared.dispose();
      }
    } finally {
      await dir.delete(recursive: true);
    }
  });
  test(
    'configuración inválida y segundo circuito fallido no dejan cambios parciales',
    () async {
      for (final serie in ['', 'A/B', 'CON ESPACIO']) {
        await expectLater(
          fiscal.configurar(
            ejercicio: year,
            tipo: 'ordinaria',
            serie: serie,
            numeroInicial: 1,
            preparada: true,
          ),
          throwsA(isA<ConfiguracionFiscalException>()),
        );
      }
      await expectLater(
        fiscal.configurar(
          ejercicio: year,
          tipo: 'ordinaria',
          serie: 'OK',
          numeroInicial: 0,
          preparada: true,
        ),
        throwsA(isA<ConfiguracionFiscalException>()),
      );
      await expectLater(
        fiscal.configurarEjercicio(
          ejercicio: year,
          serieOrdinaria: 'IGUAL',
          inicialOrdinaria: 1,
          serieRectificativa: 'igual',
          inicialRectificativa: 1,
          preparada: true,
        ),
        throwsA(isA<ConfiguracionFiscalException>()),
      );
      expect(await fiscal.obtener(year), isEmpty);
      expect(await db.seriesFiscalesDao.historial(year), isEmpty);
    },
  );
  test(
    'dos conexiones no reutilizan números y permiten reintento tras contención',
    () async {
      final dir = await Directory.systemTemp.createTemp(
        'obraia-prod3-concurrency-',
      );
      final file = File('${dir.path}/test.sqlite');
      final a = AppDatabase.forTesting(NativeDatabase(file));
      AppDatabase? b;
      try {
        await a.ensureReady();
        await ConfiguracionFiscalRepository(a).configurar(
          ejercicio: year,
          tipo: 'ordinaria',
          serie: 'CON',
          numeroInicial: 1,
          preparada: true,
        );
        final ida = await crearFacturaFiscalPrueba(a),
            idb = await crearFacturaFiscalPrueba(a);
        b = AppDatabase.forTesting(NativeDatabase(file));
        await b.ensureReady();
        final repos = [FacturaRepository(a), FacturaRepository(b)],
            ids = [ida, idb];
        final ok = await Future.wait(
          List.generate(2, (i) async {
            try {
              await repos[i].emitirFactura(ids[i]);
              return true;
            } catch (_) {
              return false;
            }
          }),
        );
        expect(ok.any((v) => v), isTrue);
        for (var i = 0; i < 2; i++) {
          if (!ok[i]) await repos[i].emitirFactura(ids[i]);
        }
        final nums = [
          (await a.facturasDao.obtenerPorId(ida))!.numeroLegal!,
          (await a.facturasDao.obtenerPorId(idb))!.numeroLegal!,
        ]..sort();
        expect(nums, [1, 2]);
        expect(
          (await a.seriesFiscalesDao.obtener(
            year,
            'ordinaria',
          ))!.siguienteNumero,
          3,
        );
      } finally {
        await b?.close();
        await a.close();
        await dir.delete(recursive: true);
      }
    },
  );
}

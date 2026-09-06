import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/features/presupuestos/data/presupuesto_repository.dart';
import 'package:obraia_v2/features/presupuestos/data/linea_presupuesto_repository.dart';
import 'package:obraia_v2/features/presupuestos/data/presupuesto_documental_repository.dart';
import 'package:obraia_v2/features/presupuestos/domain/presupuesto_documento.dart';
import 'package:obraia_v2/features/presupuestos/domain/estado_presupuesto.dart';
import 'package:obraia_v2/features/presupuestos/services/presupuesto_pdf_service.dart';
import 'package:obraia_v2/features/facturas/data/facturacion_parcial_repository.dart';
import 'package:obraia_v2/features/backup/data/backup_archive_service.dart';
import 'package:obraia_v2/features/backup/data/backup_restore_staging_service.dart';
import 'prod2_test_support.dart';

void main() {
  late AppDatabase db;
  late PresupuestoRepository presupuestos;
  late PresupuestoDocumentalRepository documentos;
  late LineaPresupuestoRepository lineas;
  late String id;
  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    id = await crearPropuestaPrueba(db);
    presupuestos = PresupuestoRepository(db);
    documentos = PresupuestoDocumentalRepository(db);
    lineas = LineaPresupuestoRepository(db);
  });
  tearDown(() => db.close());

  test(
    'borrador usa cliente canónico, empresa y obra; PDF contiene sus identidades',
    () async {
      final doc = await documentos.preparar(id);
      expect(doc.cliente['nombre'], 'CLIENTE DEMO');
      expect(doc.cliente['nif'], '00000000T');
      expect(doc.cliente['direccion'], 'Calle Prueba 2');
      expect(doc.cliente['codigoPostal'], '08000');
      expect(doc.emisor['nombre'], 'EMISOR DEMO');
      expect(doc.emisor['nif'], 'B00000000');
      expect(doc.expedienteCodigo, 'EXP');
      expect(doc.baseCentimos, 8563);
      expect(doc.ivaCentimos, 1798);
      expect(doc.totalCentimos, 10361);
      final pdf = await PresupuestoPdfService(comprimir: false).generarPdf(doc);
      final texto = latin1.decode(pdf);
      expect(texto, contains('[(CLIENTE)]TJ'));
      expect(texto, contains('[(EMISOR)]TJ'));
      expect(texto, contains('00000000T'));
      expect(texto, isNot(contains('Cliente no especificado')));
      expect(await documentos.obtenerSnapshot(id), isNull);
    },
  );

  test(
    'cliente sin NIF ni dirección opcional puede generar y aceptar',
    () async {
      final opcional = await crearPropuestaPrueba(
        db,
        suffix: '-opcional',
        opcionales: false,
      );
      await presupuestos.aceptarPresupuesto(opcional);
      final doc = (await documentos.obtenerSnapshot(opcional))!;
      expect(doc.cliente['nif'], '');
      expect(doc.cliente['direccion'], '');
      expect((await documentos.obtenerPdf(opcional)).length, greaterThan(100));
    },
  );

  test(
    'aceptación conserva snapshot, PDF, hash, fecha y plan con los mismos importes',
    () async {
      await presupuestos.aceptarPresupuesto(id);
      final row = (await db.presupuestoDocumentosAceptadosDao.obtener(id))!;
      final doc = (await documentos.obtenerSnapshot(id))!;
      expect(row.sha256, sha256.convert(row.pdf).toString());
      expect(row.fechaCongelacion.toUtc(), doc.fechaCongelacion);
      expect(doc.aceptado, isTrue);
      expect(doc.partidas, hasLength(2));
      final plan = (await db.economiaPrevistaDao.obtenerPlanPorPresupuesto(
        id,
      ))!;
      expect(plan.ventaNetaCentimos, doc.baseCentimos);
      final partidas = await db.economiaPrevistaDao.obtenerPartidasPlan(
        plan.id,
      );
      expect(
        partidas.map((p) => p.importeVentaCentimos),
        doc.partidas.map((p) => p.importeCentimos),
      );
      expect(
        partidas.map((p) => p.descripcion),
        doc.partidas.map((p) => p.concepto),
      );
      expect(await documentos.obtenerPdf(id), orderedEquals(row.pdf));
    },
  );

  test(
    'cambios en Cliente y Empresa no alteran snapshot ni PDF recuperado',
    () async {
      await presupuestos.aceptarPresupuesto(id);
      final original = (await documentos.obtenerSnapshot(id))!.encode();
      final bytes = await documentos.obtenerPdf(id);
      await db.clientesDao.actualizarCliente(
        'cliente',
        const ClientesCompanion(
          nombre: Value('OTRO CLIENTE'),
          empresa: Value('OTRA EMPRESA'),
          direccion: Value('Otra calle'),
        ),
      );
      await db.empresaConfiguracionDao.actualizarConfiguracion(
        'empresa-${db.activeTenantId}',
        const EmpresaConfiguracionCompanion(
          nombreEmpresa: Value('OTRO EMISOR'),
          cif: Value('OTRO'),
        ),
      );
      expect((await documentos.obtenerSnapshot(id))!.encode(), original);
      expect(await documentos.obtenerPdf(id), orderedEquals(bytes));
    },
  );

  test(
    'logo configurado queda incluido sin depender del archivo posterior',
    () async {
      final dir = await Directory.systemTemp.createTemp('obraia-prod2-logo-');
      try {
        final file = File('${dir.path}/logo.png');
        final png = base64Decode(
          'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAADElEQVR4nGMQcVsAAAFsAPu/0d1iAAAAAElFTkSuQmCC',
        );
        await file.writeAsBytes(png);
        await db.empresaConfiguracionDao.actualizarConfiguracion(
          'empresa-${db.activeTenantId}',
          EmpresaConfiguracionCompanion(logoPath: Value(file.path)),
        );
        await presupuestos.aceptarPresupuesto(id);
        final pdf = await documentos.obtenerPdf(id);
        await file.delete();
        expect(
          (await documentos.obtenerSnapshot(id))!.logo,
          orderedEquals(png),
        );
        expect(await documentos.obtenerPdf(id), orderedEquals(pdf));
      } finally {
        await dir.delete(recursive: true);
      }
    },
  );

  for (final operation in [
    'añadir',
    'editar',
    'eliminar',
    'IVA',
    'total',
    'borrar presupuesto',
  ]) {
    test('aceptado bloquea $operation sin necesidad de facturas', () async {
      final partida = (await db.lineasPresupuestoDao.obtenerPorPresupuesto(
        id,
      )).first;
      await presupuestos.aceptarPresupuesto(id);
      switch (operation) {
        case 'añadir':
          await expectLater(
            lineas.crearLinea(
              presupuestoId: id,
              concepto: 'No',
              cantidad: 1,
              precioUnitario: 2,
            ),
            throwsA(anything),
          );
        case 'editar':
          await expectLater(
            lineas.actualizarLinea(
              id: partida.id,
              presupuestoId: id,
              concepto: 'No',
              cantidad: 1,
              precioUnitario: 2,
            ),
            throwsA(anything),
          );
        case 'eliminar':
          await expectLater(
            lineas.eliminarLinea(partida.id, id),
            throwsA(anything),
          );
        case 'IVA':
          await expectLater(
            presupuestos.actualizarIvaPorcentaje(id, 10),
            throwsA(anything),
          );
        case 'total':
          await expectLater(
            presupuestos.actualizarImporteTotal(id, 999),
            throwsA(anything),
          );
        case 'borrar presupuesto':
          expect(await presupuestos.eliminarSiNoFacturado(id), isFalse);
      }
      expect((await db.presupuestosDao.obtenerPorId(id))!.importeTotal, 85.63);
      expect(
        await db.lineasPresupuestoDao.obtenerPorPresupuesto(id),
        hasLength(2),
      );
    });
  }

  test('SQL protege cabecera, partidas y documento ya congelados', () async {
    await presupuestos.aceptarPresupuesto(id);
    for (final sql in [
      "UPDATE presupuestos SET descripcion = 'alterado' WHERE id = ?",
      "DELETE FROM presupuestos WHERE id = ?",
      "UPDATE lineas_presupuesto SET concepto = 'alterado' WHERE presupuesto_id = ?",
      "DELETE FROM presupuesto_documentos_aceptados WHERE presupuesto_id = ?",
      "UPDATE presupuesto_documentos_aceptados SET snapshot_json = '{}' WHERE presupuesto_id = ?",
    ]) {
      await expectLater(db.customStatement(sql, [id]), throwsA(anything));
    }
  });

  test('borrador continúa editable y cambia el documento', () async {
    final before = await documentos.obtenerPdf(id);
    final partida = (await db.lineasPresupuestoDao.obtenerPorPresupuesto(
      id,
    )).first;
    await lineas.actualizarLinea(
      id: partida.id,
      presupuestoId: id,
      concepto: 'Revisada',
      cantidad: 4,
      precioUnitario: 30,
    );
    await presupuestos.actualizarIvaPorcentaje(id, 10);
    final doc = await documentos.preparar(id);
    expect(doc.baseCentimos, 18000);
    expect(doc.ivaCentimos, 1800);
    expect(await documentos.obtenerPdf(id), isNot(orderedEquals(before)));
    await lineas.eliminarLinea(partida.id, id);
    expect((await documentos.preparar(id)).baseCentimos, 6000);
  });

  for (final fallo in ['PDF', 'snapshot', 'plan', 'timeline']) {
    test('fallo de $fallo revierte toda la aceptación', () async {
      if (fallo != 'PDF') {
        final table = switch (fallo) {
          'snapshot' => 'presupuesto_documentos_aceptados',
          'plan' => 'planes_economicos',
          _ => 'timeline_events',
        };
        await db.customStatement(
          "CREATE TRIGGER fallo_aceptacion BEFORE INSERT ON $table BEGIN SELECT RAISE(ABORT, 'fallo simulado'); END",
        );
      }
      final repo = fallo == 'PDF'
          ? PresupuestoRepository(db, pdfService: PdfFallido())
          : presupuestos;
      await expectLater(repo.aceptarPresupuesto(id), throwsA(anything));
      expect((await db.presupuestosDao.obtenerPorId(id))!.estado, 'Borrador');
      expect(await documentos.obtenerSnapshot(id), isNull);
      expect(
        await db.economiaPrevistaDao.obtenerPlanPorPresupuesto(id),
        isNull,
      );
      expect(
        (await db.timelineEventsDao.obtenerPorExpediente(
          'obra',
        )).where((e) => e.tipo == 'presupuestoAceptado'),
        isEmpty,
      );
    });
  }

  test(
    'dos aceptaciones concurrentes solo crean un documento, plan y evento',
    () async {
      final outcomes = await Future.wait(
        List.generate(2, (_) async {
          try {
            await presupuestos.aceptarPresupuesto(id);
            return true;
          } catch (_) {
            return false;
          }
        }),
      );
      expect(outcomes.where((v) => v), hasLength(1));
      expect(
        await db.select(db.presupuestoDocumentosAceptados).get(),
        hasLength(1),
      );
      expect(await db.select(db.planesEconomicos).get(), hasLength(1));
      expect(
        (await db.timelineEventsDao.obtenerPorExpediente(
          'obra',
        )).where((e) => e.tipo == 'presupuestoAceptado'),
        hasLength(1),
      );
    },
  );

  test(
    'referencias concurrentes no colisionan aunque dos expedientes compartan prefijo',
    () async {
      await db.expedientesDao.insertarExpediente(
        ExpedientesCompanion.insert(id: 'obra2', codigo: 'EXP', nombre: 'Otra'),
      );
      await Future.wait(
        List.generate(
          10,
          (i) => presupuestos.crearPresupuesto(
            expedienteId: i.isEven ? 'obra' : 'obra2',
            fecha: DateTime(2026, 9, 6),
          ),
        ),
      );
      final codes = await db.presupuestosDao.obtenerCodigosPorTenant();
      expect(codes.toSet(), hasLength(11));
      await expectLater(
        db.presupuestosDao.insertarPresupuesto(
          PresupuestosCompanion.insert(
            id: 'duplicado',
            expedienteId: 'obra',
            codigo: Value(codes.first),
          ),
        ),
        throwsA(anything),
      );
      await expectLater(
        presupuestos.crearPresupuesto(
          expedienteId: 'obra',
          fecha: DateTime(2026),
          estado: 'Aceptado',
        ),
        throwsA(isA<EstadoPresupuestoException>()),
      );
    },
  );

  test(
    'otro tenant no lee documento/PDF y puede reutilizar la referencia comercial',
    () async {
      await presupuestos.aceptarPresupuesto(id);
      final tenantA = db.activeTenantId;
      await db
          .into(db.tenants)
          .insert(
            TenantsCompanion.insert(
              id: 'tenant-b',
              nombre: 'Tenant B',
              fechaCreacion: DateTime.now(),
              fechaModificacion: DateTime.now(),
            ),
          );
      db.tenantContext.activate('tenant-b');
      expect(await documentos.obtenerSnapshot(id), isNull);
      await expectLater(documentos.obtenerPdf(id), throwsA(anything));
      final other = await crearPropuestaPrueba(db, suffix: '-b');
      final codigoA =
          (await db
                  .customSelect(
                    'SELECT codigo FROM presupuestos WHERE id = ?',
                    variables: [Variable(id)],
                  )
                  .getSingle())
              .read<String>('codigo');
      await db.customStatement(
        'UPDATE presupuestos SET codigo = ? WHERE id = ?',
        [codigoA, other],
      );
      await presupuestos.aceptarPresupuesto(other);
      expect((await documentos.obtenerSnapshot(other))!.tenantId, 'tenant-b');
      db.tenantContext.activate(tenantA);
      expect(await documentos.obtenerSnapshot(other), isNull);
    },
  );

  test('facturación parcial continúa trazando a partidas aceptadas', () async {
    await presupuestos.aceptarPresupuesto(id);
    final repo = FacturacionParcialRepository(db);
    final factura = await repo.crearPorPorcentaje(
      presupuestoId: id,
      porcentaje: 50,
    );
    final asignaciones = await db.facturaAsignacionesPresupuestoDao
        .observarPorPresupuesto(id)
        .first;
    expect(asignaciones.every((a) => a.facturaId == factura), isTrue);
    expect(asignaciones, isNotEmpty);
    expect((await repo.observarResumen(id).first).reservado, greaterThan(0));
    expect(await documentos.obtenerSnapshot(id), isNotNull);
  });

  test('backup SQLite conserva snapshot, PDF y hash', () async {
    await presupuestos.aceptarPresupuesto(id);
    final bytes = await documentos.obtenerPdf(id);
    final dir = await Directory.systemTemp.createTemp('obraia-prod2-backup-');
    try {
      final path = '${dir.path}/presupuesto.obraia-backup';
      await BackupArchiveService().createBackup(
        database: db,
        destinationPath: path,
        appVersion: 'test',
        appBuildNumber: '1',
      );
      final prepared = await BackupRestoreStagingService().prepare(
        backupPath: path,
        currentSchemaVersion: 34,
      );
      try {
        final copy = AppDatabase.forTesting(
          NativeDatabase(prepared.preparedDatabaseFile),
        );
        try {
          expect(
            await PresupuestoDocumentalRepository(copy).obtenerPdf(id),
            orderedEquals(bytes),
          );
          expect(
            await PresupuestoDocumentalRepository(copy).obtenerSnapshot(id),
            isNotNull,
          );
        } finally {
          await copy.close();
        }
      } finally {
        await prepared.dispose();
      }
    } finally {
      await dir.delete(recursive: true);
    }
  });

  test(
    'aceptado legacy queda protegido sin fabricar PDF ni snapshot',
    () async {
      await db.presupuestosDao.insertarPresupuesto(
        PresupuestosCompanion.insert(
          id: 'legacy',
          expedienteId: 'obra',
          estado: const Value('Aceptado'),
          codigo: const Value('LEGACY'),
        ),
      );
      expect(await documentos.obtenerSnapshot('legacy'), isNull);
      await expectLater(
        documentos.obtenerPdf('legacy'),
        throwsA(isA<EstadoPresupuestoException>()),
      );
      await expectLater(
        lineas.crearLinea(
          presupuestoId: 'legacy',
          concepto: 'No',
          cantidad: 1,
          precioUnitario: 1,
        ),
        throwsA(anything),
      );
    },
  );

  for (final caso in [
    'sin partidas',
    'cantidad inválida',
    'IVA inválido',
    'total incoherente',
  ]) {
    test('rechaza aceptar con $caso sin efectos parciales', () async {
      switch (caso) {
        case 'sin partidas':
          await db.delete(db.lineasPresupuesto).go();
        case 'cantidad inválida':
          await db.customStatement(
            'UPDATE lineas_presupuesto SET cantidad = 0',
          );
        case 'IVA inválido':
          await db.customStatement(
            'UPDATE presupuestos SET iva_porcentaje = 101',
          );
        case 'total incoherente':
          await db.presupuestosDao.actualizarImporteTotal(id, 1);
      }
      await expectLater(
        presupuestos.aceptarPresupuesto(id),
        throwsA(isA<EstadoPresupuestoException>()),
      );
      expect((await db.presupuestosDao.obtenerPorId(id))!.estado, 'Borrador');
      expect(await documentos.obtenerSnapshot(id), isNull);
      expect(
        await db.economiaPrevistaDao.obtenerPlanPorPresupuesto(id),
        isNull,
      );
    });
  }
  test('rechaza PDF alterado en una copia de prueba por su hash', () async {
    await presupuestos.aceptarPresupuesto(id);
    // Simula corrupción externa, quitando la protección solo en memoria.
    await db.customStatement('DROP TRIGGER documento_presupuesto_update');
    await db.customStatement(
      "UPDATE presupuesto_documentos_aceptados SET pdf = X'255044462D616C74657261646F'",
    );
    await expectLater(
      documentos.obtenerPdf(id),
      throwsA(isA<EstadoPresupuestoException>()),
    );
  });
  test('validaciones mínimas impiden aceptar sin cliente o emisor', () async {
    await db.customStatement(
      'UPDATE expedientes SET cliente_id = NULL WHERE id = ?',
      ['obra'],
    );
    await expectLater(
      presupuestos.aceptarPresupuesto(id),
      throwsA(isA<EstadoPresupuestoException>()),
    );
    await db.customStatement(
      'UPDATE expedientes SET cliente_id = ? WHERE id = ?',
      ['cliente', 'obra'],
    );
    await db.empresaConfiguracionDao.actualizarConfiguracion(
      'empresa-${db.activeTenantId}',
      const EmpresaConfiguracionCompanion(cif: Value('')),
    );
    await expectLater(
      presupuestos.aceptarPresupuesto(id),
      throwsA(isA<EstadoPresupuestoException>()),
    );
    expect(await documentos.obtenerSnapshot(id), isNull);
  });
}

class PdfFallido extends PresupuestoPdfService {
  @override
  Future<Uint8List> generarPdf(PresupuestoDocumento documento) async =>
      throw StateError('PDF fallido');
}

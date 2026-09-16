import 'dart:io';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/features/facturas/data/factura_repository.dart';
import 'package:obraia_v2/features/facturas/data/rectificativa_repository.dart';
import 'package:obraia_v2/features/facturas/domain/estado_factura.dart';
import 'package:obraia_v2/features/facturas/services/factura_pdf_service.dart';
import 'package:obraia_v2/features/fiscal/data/configuracion_fiscal_repository.dart';
import 'package:obraia_v2/features/presupuestos/data/presupuesto_documental_repository.dart';
import 'package:obraia_v2/features/presupuestos/data/presupuesto_repository.dart';

import '../../../support/fiscal_test_support.dart';
import '../../presupuestos/data/prod2_test_support.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase db;
  late String presupuestoId;
  late FacturaRepository facturas;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    presupuestoId = await crearPropuestaPrueba(db);
    await prepararFiscalPrueba(db);
    facturas = FacturaRepository(db);
  });
  tearDown(() => db.close());

  Future<void> cliente(String nombre, String apellidos, String empresa) =>
      db.clientesDao.actualizarCliente(
        'cliente',
        ClientesCompanion(
          nombre: Value(nombre),
          apellidos: Value(apellidos),
          empresa: Value(empresa),
        ),
      );

  Future<String> convertir() async {
    await PresupuestoRepository(db).aceptarPresupuesto(presupuestoId);
    return facturas.convertirDesdePresupuesto(
      (await db.presupuestosDao.observarPresupuestos().first).single,
    );
  }

  for (final caso in [
    (
      'empresa con contacto',
      'Contacto',
      'Ficticio',
      '  SOCIEDAD PILOTO FICTICIA SL  ',
      'SOCIEDAD PILOTO FICTICIA SL',
    ),
    (
      'empresa sin contacto',
      '',
      '',
      'SOCIEDAD PILOTO FICTICIA SL',
      'SOCIEDAD PILOTO FICTICIA SL',
    ),
    (
      'persona sin empresa',
      '  Persona  ',
      '  Ficticia  ',
      '  ',
      'Persona Ficticia',
    ),
  ]) {
    test(
      'PROD-6 conserva destinatario en presupuesto, FAC y RECT: ${caso.$1}',
      () async {
        await cliente(caso.$2, caso.$3, caso.$4);
        final id = await convertir();
        final snapshot = await PresupuestoDocumentalRepository(
          db,
        ).obtenerSnapshot(presupuestoId);
        expect(snapshot!.cliente['nombre'], caso.$5);
        final borrador = (await db.facturasDao.obtenerPorId(id))!;
        final pdfBorrador = await FacturaPdfService().generarPdf(
          factura: borrador,
          lineas: await db.facturaLineasDao.obtenerPorFactura(id),
          empresaConfiguracion: (await db.empresaConfiguracionDao
              .obtenerConfiguracion())!,
          cliente: await db.clientesDao.obtenerCliente('cliente'),
        );
        await facturas.emitirFactura(id);
        final emitida = (await db.facturasDao.obtenerPorId(id))!;
        expect(emitida.clienteNombreHistorico, caso.$5);
        expect(emitida.clienteNifHistorico, snapshot.cliente['nif']);
        expect(emitida.total, snapshot.totalCentimos / 100);
        final pdfOriginal = (await facturas.obtenerPdfEmitido(id))!;
        expect(pdfOriginal, isNotEmpty);

        // Artefactos ficticios opcionales para revisión visual; nunca abre la app.
        final output = Platform.environment['OBRAIA_PROD6_PDF_DIR'];
        if (output != null && caso.$1 == 'empresa con contacto') {
          final dir = await Directory(output).create(recursive: true);
          await File(
            '${dir.path}/factura-borrador.pdf',
          ).writeAsBytes(pdfBorrador);
          await File(
            '${dir.path}/factura-emitida.pdf',
          ).writeAsBytes(pdfOriginal);
        }

        await cliente('Otro contacto', 'Posterior', 'OTRA SOCIEDAD FICTICIA');
        expect(
          (await db.facturasDao.obtenerPorId(id))!.clienteNombreHistorico,
          caso.$5,
        );
        expect(
          await facturas.obtenerPdfEmitido(id),
          orderedEquals(pdfOriginal),
        );
        expect(
          (await PresupuestoDocumentalRepository(
            db,
          ).obtenerSnapshot(presupuestoId))!.cliente['nombre'],
          caso.$5,
        );
        final rectificativas = RectificativaRepository(db);
        final rectId = await rectificativas.crear(
          facturaRectificadaId: id,
          motivo: 'Prueba formal de identidad preservada',
          ajustes: const [],
          rectificacionFormal: true,
        );
        await rectificativas.emitir(rectId);
        expect(
          (await db.facturasDao.obtenerPorId(rectId))!.clienteNombreHistorico,
          caso.$5,
        );
        expect(await rectificativas.obtenerPdfEmitido(rectId), isNotEmpty);
        expect(
          await facturas.obtenerPdfEmitido(id),
          orderedEquals(pdfOriginal),
        );
      },
    );
  }

  test(
    'PROD-6 destinatario vacío bloquea sin consumir número ni PDF',
    () async {
      final id = await convertir();
      await cliente(' ', ' ', ' ');
      final fiscal = ConfiguracionFiscalRepository(db);
      final year = (await db.facturasDao.obtenerPorId(id))!.fecha.year;
      final antes = (await fiscal.obtener(
        year,
      )).firstWhere((c) => c.tipo == 'ordinaria');
      await expectLater(
        facturas.emitirFactura(id),
        throwsA(isA<FacturaEmisionException>()),
      );
      final despues = (await fiscal.obtener(
        year,
      )).firstWhere((c) => c.tipo == 'ordinaria');
      expect(despues.siguienteNumero, antes.siguienteNumero);
      expect(despues.emisiones, antes.emisiones);
      expect((await db.facturasDao.obtenerPorId(id))!.numeroLegal, isNull);
      expect(await facturas.obtenerPdfEmitido(id), isNull);
    },
  );

  test(
    'PROD-6 logo inválido bloquea emisión sin número ni PDF congelado',
    () async {
      final id = await convertir();
      final fiscal = ConfiguracionFiscalRepository(db);
      final year = (await db.facturasDao.obtenerPorId(id))!.fecha.year;
      final antes = (await fiscal.obtener(
        year,
      )).firstWhere((c) => c.tipo == 'ordinaria');
      await db.empresaConfiguracionDao.actualizarConfiguracion(
        (await db.empresaConfiguracionDao.obtenerConfiguracion())!.id,
        const EmpresaConfiguracionCompanion(
          logoPath: Value('Z:\\logo-inexistente.png'),
        ),
      );

      await expectLater(
        facturas.emitirFactura(id),
        throwsA(
          isA<FacturaEmisionException>().having(
            (error) => error.mensaje,
            'mensaje',
            contains('No se puede usar el logotipo configurado'),
          ),
        ),
      );

      final despues = (await fiscal.obtener(
        year,
      )).firstWhere((c) => c.tipo == 'ordinaria');
      expect(despues.siguienteNumero, antes.siguienteNumero);
      expect(despues.emisiones, antes.emisiones);
      final borrador = (await db.facturasDao.obtenerPorId(id))!;
      expect(borrador.estado, EstadoFactura.borrador);
      expect(borrador.numeroLegal, isNull);
      expect(await facturas.obtenerPdfEmitido(id), isNull);
    },
  );
}

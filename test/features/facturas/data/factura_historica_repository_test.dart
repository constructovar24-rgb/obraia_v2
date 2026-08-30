import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/features/facturas/data/factura_repository.dart';
import 'package:obraia_v2/features/facturas/domain/redondeo_monetario.dart';
import 'package:obraia_v2/features/facturas/domain/factura_linea.dart'
    as factura_domain;
import 'package:obraia_v2/features/facturas/domain/factura_totales.dart';
import 'package:obraia_v2/features/timeline/domain/timeline_event.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase database;
  late FacturaRepository facturas;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    facturas = FacturaRepository(database);
    await _prepararDatos(database);
  });

  tearDown(() => database.close());

  test('convierte en borrador sin número legal y conserva la unidad', () async {
    final facturaId = await facturas.convertirDesdePresupuesto(
      (await database.presupuestosDao.observarPresupuestos().first).single,
    );

    final factura = await database.facturasDao.obtenerPorId(facturaId);
    final linea = (await database.facturaLineasDao.obtenerPorFactura(
      facturaId,
    )).single;
    expect(factura?.codigo, isEmpty);
    expect(factura?.numeroLegal, isNull);
    expect(factura?.fechaEmision, isNull);
    expect(linea.unidad, 'm²');
  });

  test('emite con numeración y fotografía histórica inmutable', () async {
    final facturaId = await facturas.convertirDesdePresupuesto(
      (await database.presupuestosDao.observarPresupuestos().first).single,
    );
    await facturas.emitirFactura(facturaId);
    final emitida = await database.facturasDao.obtenerPorId(facturaId);
    expect(emitida?.codigo, 'FAC-2026-0001');
    expect(emitida?.numeroLegal, 1);
    expect(emitida?.clienteNombreHistorico, 'Cliente Original');
    expect(emitida?.empresaNombreHistorico, 'Empresa Original');
    expect(emitida?.expedienteCodigoHistorico, 'EXP-2026');
    expect(emitida?.presupuestoCodigoHistorico, 'PRE-2026');
    final documento = await database.facturaDocumentosEmitidosDao.obtener(
      facturaId,
    );
    expect(documento?.pdf, isNotEmpty);
    expect(documento?.sha256, sha256.convert(documento!.pdf).toString());
    expect(await facturas.obtenerPdfEmitido(facturaId), documento.pdf);
    final eventos = await database.timelineEventsDao.obtenerPorExpediente(
      'expediente',
    );
    expect(
      eventos.map((evento) => evento.tipo),
      contains(TimelineEventType.facturaEmitida.name),
    );

    await (database.update(database.clientes)
          ..where((table) => table.id.equals('cliente')))
        .write(const ClientesCompanion(nombre: Value('Cliente cambiado')));
    await database.empresaConfiguracionDao.actualizarConfiguracion(
      'empresa',
      const EmpresaConfiguracionCompanion(
        nombreEmpresa: Value('Empresa cambiada'),
      ),
    );
    await database.expedientesDao.actualizarExpediente(
      'expediente',
      const ExpedientesCompanion(codigo: Value('EXP-CAMBIADO')),
    );

    final historica = await database.facturasDao.obtenerPorId(facturaId);
    expect(historica?.clienteNombreHistorico, 'Cliente Original');
    expect(historica?.empresaNombreHistorico, 'Empresa Original');
    expect(historica?.expedienteCodigoHistorico, 'EXP-2026');
    expect(await facturas.obtenerPdfEmitido(facturaId), documento.pdf);
  });

  test('detecta un PDF ordinario histórico corrupto', () async {
    final facturaId = await facturas.convertirDesdePresupuesto(
      (await database.presupuestosDao.observarPresupuestos().first).single,
    );
    await facturas.emitirFactura(facturaId);
    await (database.update(
      database.facturaDocumentosEmitidos,
    )..where((table) => table.facturaId.equals(facturaId))).write(
      FacturaDocumentosEmitidosCompanion(
        pdf: Value(Uint8List.fromList([1, 2, 3])),
      ),
    );
    await expectLater(
      facturas.obtenerPdfEmitido(facturaId),
      throwsA(isA<FacturaPdfIntegridadException>()),
    );
  });

  test('una FAC legacy sin PDF no inventa ni archiva un original', () async {
    final facturaId = await facturas.convertirDesdePresupuesto(
      (await database.presupuestosDao.observarPresupuestos().first).single,
    );
    await facturas.emitirFactura(facturaId);
    await (database.delete(
      database.facturaDocumentosEmitidos,
    )..where((table) => table.facturaId.equals(facturaId))).go();
    expect(await facturas.obtenerPdfEmitido(facturaId), isNull);
    expect(
      await database.facturaDocumentosEmitidosDao.obtener(facturaId),
      isNull,
    );
  });

  test('fallo de Timeline revierte emisión, PDF y número FAC', () async {
    final facturaId = await facturas.convertirDesdePresupuesto(
      (await database.presupuestosDao.observarPresupuestos().first).single,
    );
    await database.customStatement('''
      CREATE TRIGGER bloquear_emision_timeline BEFORE INSERT ON timeline_events
      WHEN NEW.tipo = 'facturaEmitida'
      BEGIN SELECT RAISE(ABORT, 'fallo timeline'); END
    ''');
    await expectLater(facturas.emitirFactura(facturaId), throwsA(anything));
    final factura = await database.facturasDao.obtenerPorId(facturaId);
    expect(factura?.estado.name, 'borrador');
    expect(factura?.numeroLegal, isNull);
    expect(
      await database.facturaDocumentosEmitidosDao.obtener(facturaId),
      isNull,
    );
  });

  test('fallo documental revierte y no consume el número FAC', () async {
    final facturaId = await facturas.convertirDesdePresupuesto(
      (await database.presupuestosDao.observarPresupuestos().first).single,
    );
    await database.customStatement('''
      CREATE TRIGGER bloquear_pdf_fac BEFORE INSERT ON factura_documentos_emitidos
      BEGIN SELECT RAISE(ABORT, 'fallo PDF'); END
    ''');
    await expectLater(facturas.emitirFactura(facturaId), throwsA(anything));
    await database.customStatement('DROP TRIGGER bloquear_pdf_fac');
    await facturas.emitirFactura(facturaId);
    expect(
      (await database.facturasDao.obtenerPorId(facturaId))?.numeroLegal,
      1,
    );
  });

  test('emisiones FAC concurrentes reciben correlativos únicos', () async {
    final ids = <String>[];
    for (final suffix in ['a', 'b']) {
      final id = await facturas.crearFactura(
        clienteId: 'cliente',
        fecha: DateTime(2026, 8, 30),
        fechaVencimiento: DateTime(2026, 9, 30),
        subtotal: 10,
      );
      await database.facturaLineasDao.insertarLinea(
        FacturaLineasCompanion.insert(
          id: 'linea-$suffix',
          facturaId: id,
          descripcion: 'Trabajo $suffix',
          cantidad: 1,
          precioUnitario: 10,
          importe: const Value(10),
        ),
      );
      ids.add(id);
    }
    await Future.wait(ids.map(facturas.emitirFactura));
    final emitidas = await Future.wait(
      ids.map(database.facturasDao.obtenerPorId),
    );
    expect(emitidas.map((factura) => factura!.numeroLegal).toSet(), {1, 2});
    expect(emitidas.map((factura) => factura!.codigo).toSet(), hasLength(2));
  });

  test(
    'no emite ni inventa snapshot si faltan datos fiscales de empresa',
    () async {
      await database.empresaConfiguracionDao.actualizarConfiguracion(
        'empresa',
        const EmpresaConfiguracionCompanion(
          nombreEmpresa: Value(''),
          cif: Value(''),
        ),
      );
      final facturaId = await facturas.convertirDesdePresupuesto(
        (await database.presupuestosDao.observarPresupuestos().first).single,
      );

      await expectLater(
        facturas.emitirFactura(facturaId),
        throwsA(isA<FacturaEmisionException>()),
      );
      final factura = await database.facturasDao.obtenerPorId(facturaId);
      expect(factura?.numeroLegal, isNull);
      expect(factura?.fechaEmision, isNull);
      expect(factura?.empresaNombreHistorico, isEmpty);
      expect(factura?.empresaCifHistorico, isEmpty);
    },
  );

  test('redondea línea, IVA y total a dos decimales', () {
    expect(redondearMoneda(0.1 + 0.2), 0.3);
    final importe = calcularImporteLineaFactura(
      cantidad: 3,
      precioUnitario: 3.335,
      descuento: 0,
    );
    expect(importe, 10.01);
    final totales = calcularTotalesFactura([
      factura_domain.FacturaLinea(
        id: '1',
        facturaId: 'f',
        descripcion: 'A',
        cantidad: 1,
        unidad: 'ud',
        precioUnitario: 10.01,
        descuento: 0,
        importe: 10.01,
      ),
    ], ivaPorcentaje: 21);
    expect(totales.subtotal, 10.01);
    expect(totales.iva, 2.1);
    expect(totales.total, 12.11);
  });
}

Future<void> _prepararDatos(AppDatabase database) async {
  await database.clientesDao.insertarCliente(
    ClientesCompanion.insert(
      id: 'cliente',
      nombre: 'Cliente',
      apellidos: const Value('Original'),
      nif: const Value('B12345678'),
      direccion: const Value('Calle Fiscal 1'),
      telefono: const Value('600000000'),
      email: const Value('cliente@example.com'),
    ),
  );
  await database.empresaConfiguracionDao.insertarConfiguracion(
    const EmpresaConfiguracionCompanion(
      id: Value('empresa'),
      nombreEmpresa: Value('Empresa Original'),
      cif: Value('A12345678'),
      direccion: Value('Calle Empresa 1'),
      codigoPostal: Value('28001'),
      poblacion: Value('Madrid'),
      provincia: Value('Madrid'),
      telefono: Value('910000000'),
      email: Value('empresa@example.com'),
      web: Value('empresa.example.com'),
    ),
  );
  await database.expedientesDao.insertarExpediente(
    ExpedientesCompanion.insert(
      id: 'expediente',
      codigo: 'EXP-2026',
      nombre: 'Obra original',
      clienteId: const Value('cliente'),
    ),
  );
  await database.presupuestosDao.insertarPresupuesto(
    PresupuestosCompanion.insert(
      id: 'presupuesto',
      expedienteId: 'expediente',
      codigo: const Value('PRE-2026'),
      importeTotal: const Value(12.35),
      ivaPorcentaje: const Value(21),
      estado: const Value('Aceptado'),
    ),
  );
  await database.lineasPresupuestoDao.insertarLinea(
    LineasPresupuestoCompanion.insert(
      id: 'linea',
      presupuestoId: 'presupuesto',
      concepto: 'Medición',
      cantidad: 1,
      unidad: const Value('m²'),
      precioUnitario: 12.35,
    ),
  );
}

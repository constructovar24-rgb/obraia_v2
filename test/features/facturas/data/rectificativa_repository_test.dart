import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/features/cobros/data/cobro_repository.dart';
import 'package:obraia_v2/features/facturas/data/factura_repository.dart';
import 'package:obraia_v2/features/facturas/data/factura_linea_repository.dart';
import 'package:obraia_v2/features/facturas/data/facturacion_parcial_repository.dart';
import 'package:obraia_v2/features/facturas/data/rectificativa_repository.dart';
import 'package:obraia_v2/features/facturas/domain/estado_factura.dart';
import 'package:obraia_v2/features/facturas/domain/facturacion_parcial.dart';
import 'package:obraia_v2/features/facturas/domain/rectificativa.dart';
import 'package:obraia_v2/features/facturas/domain/tipo_documento_factura.dart';
import 'package:obraia_v2/features/timeline/domain/timeline_event.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase database;
  late FacturacionParcialRepository parciales;
  late FacturaRepository facturas;
  late RectificativaRepository rectificativas;
  late CobroRepository cobros;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    parciales = FacturacionParcialRepository(database);
    facturas = FacturaRepository(database);
    rectificativas = RectificativaRepository(database);
    cobros = CobroRepository(database);
    await database.empresaConfiguracionDao.insertarConfiguracion(
      EmpresaConfiguracionCompanion.insert(
        id: 'empresa',
        nombreEmpresa: const Value('Empresa Emisora'),
        cif: const Value('B12345678'),
      ),
    );
    await database.clientesDao.insertarCliente(
      ClientesCompanion.insert(
        id: 'cliente',
        nombre: 'Cliente',
        nif: const Value('12345678Z'),
      ),
    );
    await database.expedientesDao.insertarExpediente(
      ExpedientesCompanion.insert(
        id: 'expediente',
        codigo: 'EXP',
        nombre: 'Obra',
        clienteId: const Value('cliente'),
      ),
    );
    await database.presupuestosDao.insertarPresupuesto(
      PresupuestosCompanion.insert(
        id: 'presupuesto',
        expedienteId: 'expediente',
        codigo: const Value('PRE-1'),
        importeTotal: const Value(100),
        ivaPorcentaje: const Value(21),
        estado: const Value('Aceptado'),
      ),
    );
    await database.lineasPresupuestoDao.insertarLinea(
      LineasPresupuestoCompanion.insert(
        id: 'partida',
        presupuestoId: 'presupuesto',
        concepto: 'Partida',
        cantidad: 10,
        precioUnitario: 10,
      ),
    );
  });

  tearDown(() => database.close());

  Future<String> crearOriginal({double cantidad = 6}) async {
    final id = await parciales.crearPorPartidas(
      presupuestoId: 'presupuesto',
      selecciones: [
        SeleccionPartidaFactura(
          lineaPresupuestoId: 'partida',
          cantidad: cantidad,
        ),
      ],
    );
    await facturas.emitirFactura(id);
    return id;
  }

  Future<String> crearRectificativa(
    String objetivoId, {
    double base = -20,
    double? cantidad = -2,
    String motivo = 'Corrección de medición',
  }) async {
    final linea = (await database.facturaLineasDao.obtenerPorFactura(
      objetivoId,
    )).single;
    return rectificativas.crear(
      facturaRectificadaId: objetivoId,
      motivo: motivo,
      ajustes: [
        AjusteRectificativa(
          lineaRectificadaId: linea.id,
          baseDiferencia: base,
          cantidadDiferencia: cantidad,
        ),
      ],
    );
  }

  test(
    'presupuesto aceptado crea, emite y rectifica inmediatamente una parcial',
    () async {
      final originalId = await crearOriginal();
      final rectId = await crearRectificativa(originalId);
      var rect = (await database.facturasDao.obtenerPorId(rectId))!;
      expect(rect.tipoDocumento, TipoDocumentoFactura.rectificativa);
      expect(rect.serie, 'RECT');
      expect(rect.codigo, isEmpty);
      expect(rect.facturaRectificadaId, originalId);
      expect(rect.facturaRaizId, originalId);
      expect(rect.efectoBase, -20);
      expect(
        (await parciales.observarResumen('presupuesto').first).facturado,
        60,
      );

      await rectificativas.emitir(rectId);
      rect = (await database.facturasDao.obtenerPorId(rectId))!;
      expect(rect.codigo, 'RECT-${rect.fecha.year}-0001');
      expect(rect.estado, EstadoFactura.emitida);
      expect(
        (await parciales.observarResumen('presupuesto').first).facturado,
        40,
      );
      final documento = await database.facturaDocumentosEmitidosDao.obtener(
        rectId,
      );
      expect(documento?.pdf, isNotEmpty);
      expect(documento?.sha256, hasLength(64));
      final eventos = await database.timelineEventsDao.obtenerPorExpediente(
        'expediente',
      );
      expect(
        eventos.map((item) => item.tipo),
        containsAll([
          TimelineEventType.rectificativaCreada.name,
          TimelineEventType.rectificativaEmitida.name,
        ]),
      );
    },
  );

  test(
    'una factura histórica fiscalmente incompleta sigue bloqueada',
    () async {
      final originalId = await crearOriginal();
      await (database.update(
        database.facturas,
      )..where((table) => table.id.equals(originalId))).write(
        const FacturasCompanion(
          empresaNombreHistorico: Value(''),
          empresaCifHistorico: Value(''),
        ),
      );

      await expectLater(
        crearRectificativa(originalId),
        throwsA(isA<RectificativaException>()),
      );
      final original = (await database.facturasDao.obtenerPorId(originalId))!;
      expect(original.empresaNombreHistorico, isEmpty);
      expect(original.empresaCifHistorico, isEmpty);
    },
  );

  test('FAC y RECT mantienen correlativos independientes', () async {
    final originalId = await crearOriginal();
    final rect1 = await crearRectificativa(originalId, base: -10, cantidad: -1);
    await rectificativas.emitir(rect1);
    final rect2 = await crearRectificativa(originalId, base: -10, cantidad: -1);
    await rectificativas.emitir(rect2);
    final original = (await database.facturasDao.obtenerPorId(originalId))!;
    final segunda = (await database.facturasDao.obtenerPorId(rect2))!;
    expect(original.codigo, 'FAC-${original.fecha.year}-0001');
    expect(segunda.codigo, 'RECT-${segunda.fecha.year}-0002');
  });

  test('dos emisiones concurrentes reciben números RECT únicos', () async {
    final originalId = await crearOriginal();
    final ids = [
      await crearRectificativa(originalId, base: -10, cantidad: -1),
      await crearRectificativa(originalId, base: -10, cantidad: -1),
    ];
    await Future.wait(ids.map(rectificativas.emitir));
    final emitidas = await Future.wait(
      ids.map(database.facturasDao.obtenerPorId),
    );
    expect(emitidas.map((item) => item!.codigo).toSet(), hasLength(2));
    expect(emitidas.map((item) => item!.numeroLegal).toSet(), {1, 2});
  });

  test('bloquea borrador, motivo ausente y exceso acumulado', () async {
    final borrador = await parciales.crearPorImporte(
      presupuestoId: 'presupuesto',
      importe: 10,
    );
    await expectLater(
      crearRectificativa(borrador),
      throwsA(isA<RectificativaException>()),
    );
    final original = await crearOriginal();
    await expectLater(
      crearRectificativa(original, motivo: ''),
      throwsA(isA<RectificativaException>()),
    );
    await expectLater(
      crearRectificativa(original, base: -60.01, cantidad: -6),
      throwsA(isA<RectificativaException>()),
    );
  });

  test('conserva raíz y permite rectificar una rectificativa', () async {
    final original = await crearOriginal();
    final primera = await crearRectificativa(original, base: -20, cantidad: -2);
    await rectificativas.emitir(primera);
    final segunda = await crearRectificativa(primera, base: 5, cantidad: 0.5);
    final documento = (await database.facturasDao.obtenerPorId(segunda))!;
    expect(documento.facturaRectificadaId, primera);
    expect(documento.facturaRaizId, original);
  });

  test(
    'aplica diferencia positiva, IVA explícito y céntimos exactos',
    () async {
      final original = await crearOriginal();
      final linea = (await database.facturaLineasDao.obtenerPorFactura(
        original,
      )).single;
      final positiva = await rectificativas.crear(
        facturaRectificadaId: original,
        motivo: 'Incremento de medición',
        ajustes: [
          AjusteRectificativa(
            lineaRectificadaId: linea.id,
            baseDiferencia: 10.01,
            cantidadDiferencia: 1,
          ),
        ],
        ivaDiferencia: 2.1,
      );
      expect(
        (await parciales.observarResumen('presupuesto').first).reservado,
        10.01,
      );
      await rectificativas.emitir(positiva);
      final emitida = (await database.facturasDao.obtenerPorId(positiva))!;
      expect(emitida.efectoBase, 10.01);
      expect(emitida.efectoIva, 2.1);
      expect(emitida.efectoTotal, 12.11);
      expect(
        (await parciales.observarResumen('presupuesto').first).facturado,
        70.01,
      );
    },
  );

  test('una original cobrada genera crédito sin alterar cobros', () async {
    final original = await crearOriginal();
    final factura = (await database.facturasDao.obtenerPorId(original))!;
    await cobros.crearCobro(
      facturaId: original,
      fecha: factura.fecha,
      importe: factura.total,
      metodoPago: 'Transferencia',
    );
    final rect = await crearRectificativa(original);
    await rectificativas.emitir(rect);
    final saldo = await rectificativas.calcularSaldo(
      (await database.facturasDao.obtenerPorId(rect))!,
    );
    expect(saldo.saldoAFavor, 24.2);
    expect(await database.cobrosDao.obtenerPorFactura(original), hasLength(1));
    expect(
      (await database.facturasDao.obtenerPorId(rect))!.estado,
      EstadoFactura.emitida,
    );
  });

  test('admite rectificación formal con efecto cero', () async {
    final original = await crearOriginal();
    final id = await rectificativas.crear(
      facturaRectificadaId: original,
      motivo: 'Corrección formal del domicilio',
      ajustes: const [],
      rectificacionFormal: true,
    );
    final rect = (await database.facturasDao.obtenerPorId(id))!;
    expect(rect.efectoTotal, 0);
    await rectificativas.emitir(id);
    expect(
      (await database.facturasDao.obtenerPorId(id))!.estado,
      EstadoFactura.emitida,
    );
  });

  test('un fallo al guardar PDF revierte emisión y numeración', () async {
    final original = await crearOriginal();
    final id = await crearRectificativa(original);
    await database.customStatement('''
      CREATE TRIGGER bloquear_pdf BEFORE INSERT ON factura_documentos_emitidos
      BEGIN SELECT RAISE(ABORT, 'fallo PDF'); END
    ''');
    await expectLater(rectificativas.emitir(id), throwsA(anything));
    final rect = (await database.facturasDao.obtenerPorId(id))!;
    expect(rect.estado, EstadoFactura.borrador);
    expect(rect.codigo, isEmpty);
  });

  test(
    'original y rectificativa emitidas permanecen inmutables y vinculadas',
    () async {
      final original = await crearOriginal();
      final rectId = await crearRectificativa(original);
      await rectificativas.emitir(rectId);
      final lineaRect = (await database.facturaLineasDao.obtenerPorFactura(
        rectId,
      )).single;
      await expectLater(
        FacturaLineaRepository(database).actualizarLinea(
          id: lineaRect.id,
          facturaId: rectId,
          descripcion: 'No cambia',
          cantidad: 1,
          unidad: 'ud',
          precioUnitario: 1,
          descuento: 0,
        ),
        throwsA(isA<FacturaNoPermiteModificarLineasException>()),
      );
      await expectLater(
        database.facturasDao.eliminarFactura(original),
        throwsA(anything),
      );
    },
  );
}

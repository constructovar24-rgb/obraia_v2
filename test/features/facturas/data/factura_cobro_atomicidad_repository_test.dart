import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/features/cobros/data/cobro_repository.dart';
import 'package:obraia_v2/features/cobros/domain/factura_estado_economico.dart';
import 'package:obraia_v2/features/facturas/data/factura_linea_repository.dart';
import 'package:obraia_v2/features/facturas/data/factura_repository.dart';
import 'package:obraia_v2/features/facturas/domain/estado_factura.dart';
import 'package:obraia_v2/features/facturas/domain/factura_linea.dart'
    as factura_linea_domain;

void main() {
  late AppDatabase database;
  late FacturaRepository facturaRepository;
  late FacturaLineaRepository lineaRepository;
  late CobroRepository cobroRepository;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    facturaRepository = FacturaRepository(database);
    lineaRepository = FacturaLineaRepository(database);
    cobroRepository = CobroRepository(database);

    await database.clientesDao.insertarCliente(
      ClientesCompanion.insert(id: 'cliente-1', nombre: 'Cliente'),
    );
  });

  tearDown(() => database.close());

  Future<(String, factura_linea_domain.FacturaLinea)> crearFacturaEmitida({
    double precioUnitario = 100,
  }) async {
    final facturaId = await facturaRepository.crearFactura(
      clienteId: 'cliente-1',
      fecha: DateTime(2026, 8, 26),
      fechaVencimiento: DateTime(2026, 9, 26),
    );
    await lineaRepository.crearLinea(
      facturaId: facturaId,
      descripcion: 'Trabajo',
      cantidad: 1,
      unidad: 'ud',
      precioUnitario: precioUnitario,
      descuento: 0,
    );
    await facturaRepository.emitirFactura(facturaId);
    final linea = (await database.facturaLineasDao.obtenerPorFactura(
      facturaId,
    )).single;
    return (facturaId, linea);
  }

  Future<Object> capturar(Future<void> operacion) async {
    try {
      await operacion;
      return true;
    } catch (error) {
      return error;
    }
  }

  group('CobroRepository con Drift', () {
    test('rechaza 0, negativo, NaN e infinitos sin persistir', () async {
      final (facturaId, _) = await crearFacturaEmitida();

      for (final importe in [
        0.0,
        -1.0,
        double.nan,
        double.infinity,
        double.negativeInfinity,
      ]) {
        await expectLater(
          cobroRepository.crearCobro(
            facturaId: facturaId,
            fecha: DateTime(2026, 8, 26),
            importe: importe,
            metodoPago: 'Transferencia',
          ),
          throwsA(isA<ImporteCobroNoValidoException>()),
        );
      }

      expect(
        await database.cobrosDao.observarPorFactura(facturaId).first,
        isEmpty,
      );
    });

    test('crea un cobro válido y resincroniza el estado', () async {
      final (facturaId, _) = await crearFacturaEmitida();

      await cobroRepository.crearCobro(
        facturaId: facturaId,
        fecha: DateTime(2026, 8, 26),
        importe: 121,
        metodoPago: 'Transferencia',
      );

      final cobros = await database.cobrosDao
          .observarPorFactura(facturaId)
          .first;
      final factura = await database.facturasDao.obtenerPorId(facturaId);
      expect(cobros.single.importe, 121);
      expect(factura?.estado, EstadoFactura.cobrada);
    });

    test('dos altas concurrentes no pueden superar el total', () async {
      final (facturaId, _) = await crearFacturaEmitida();

      final resultados = await Future.wait([
        capturar(
          cobroRepository.crearCobro(
            facturaId: facturaId,
            fecha: DateTime(2026, 8, 26),
            importe: 80,
            metodoPago: 'Transferencia',
          ),
        ),
        capturar(
          cobroRepository.crearCobro(
            facturaId: facturaId,
            fecha: DateTime(2026, 8, 26),
            importe: 80,
            metodoPago: 'Transferencia',
          ),
        ),
      ]);

      expect(resultados.where((resultado) => resultado == true), hasLength(1));
      expect(
        resultados.whereType<CobroSuperaPendienteException>(),
        hasLength(1),
      );
      final cobros = await database.cobrosDao
          .observarPorFactura(facturaId)
          .first;
      expect(cobros.fold<double>(0, (suma, cobro) => suma + cobro.importe), 80);
    });

    test('un cobro confirmado no puede sobrescribirse', () async {
      final (facturaId, _) = await crearFacturaEmitida();
      await cobroRepository.crearCobro(
        facturaId: facturaId,
        fecha: DateTime(2026, 8, 26),
        importe: 30,
        metodoPago: 'Transferencia',
      );
      final cobro =
          (await database.cobrosDao.observarPorFactura(facturaId).first).single;

      for (final importe in [
        0.0,
        -1.0,
        double.nan,
        double.infinity,
        double.negativeInfinity,
      ]) {
        await expectLater(
          cobroRepository.actualizarCobro(
            id: cobro.id,
            fecha: cobro.fecha,
            importe: importe,
            metodoPago: cobro.metodoPago,
            referencia: cobro.referencia,
            observaciones: cobro.observaciones,
          ),
          throwsA(isA<CobroConfirmadoNoEditableException>()),
        );
      }

      final persistido = await database.cobrosDao.obtenerPorId(cobro.id);
      expect(persistido?.importe, 30);
    });

    test('ninguna edición concurrente sobrescribe cobros', () async {
      final (facturaId, _) = await crearFacturaEmitida();

      await cobroRepository.crearCobro(
        facturaId: facturaId,
        fecha: DateTime(2026, 8, 26),
        importe: 30,
        metodoPago: 'Transferencia',
      );
      await cobroRepository.crearCobro(
        facturaId: facturaId,
        fecha: DateTime(2026, 8, 26),
        importe: 30,
        metodoPago: 'Transferencia',
      );
      final actuales = await database.cobrosDao
          .observarPorFactura(facturaId)
          .first;

      final resultados = await Future.wait(
        actuales.map(
          (cobro) => capturar(
            cobroRepository.actualizarCobro(
              id: cobro.id,
              fecha: cobro.fecha,
              importe: 80,
              metodoPago: cobro.metodoPago,
              referencia: cobro.referencia,
              observaciones: cobro.observaciones,
            ),
          ),
        ),
      );

      expect(resultados.where((resultado) => resultado == true), isEmpty);
      expect(
        resultados.whereType<CobroConfirmadoNoEditableException>(),
        hasLength(2),
      );
      final finales = await database.cobrosDao
          .observarPorFactura(facturaId)
          .first;
      expect(
        finales.fold<double>(0, (suma, cobro) => suma + cobro.importe),
        60,
      );
    });

    test('cobro concurrente con anulación no deja anulada con cobro', () async {
      final (facturaId, _) = await crearFacturaEmitida();

      await Future.wait([
        capturar(
          cobroRepository.crearCobro(
            facturaId: facturaId,
            fecha: DateTime(2026, 8, 26),
            importe: 50,
            metodoPago: 'Transferencia',
          ),
        ),
        capturar(facturaRepository.anularFactura(facturaId)),
      ]);

      final factura = await database.facturasDao.obtenerPorId(facturaId);
      final cobros = await database.cobrosDao
          .observarPorFactura(facturaId)
          .first;
      expect(
        factura?.estado == EstadoFactura.anulada && cobros.isNotEmpty,
        isFalse,
      );
    });
  });

  group('FacturaLineaRepository con Drift', () {
    test('una emitida rechaza cualquier reducción de líneas', () async {
      final (facturaId, linea) = await crearFacturaEmitida(precioUnitario: 200);
      await cobroRepository.crearCobro(
        facturaId: facturaId,
        fecha: DateTime(2026, 8, 26),
        importe: 100,
        metodoPago: 'Transferencia',
      );

      await expectLater(
        lineaRepository.actualizarLinea(
          id: linea.id,
          facturaId: facturaId,
          descripcion: linea.descripcion,
          cantidad: 1,
          unidad: linea.unidad,
          precioUnitario: 100,
          descuento: 0,
        ),
        throwsA(isA<FacturaNoPermiteModificarLineasException>()),
      );

      final factura = await database.facturasDao.obtenerPorId(facturaId);
      expect(factura?.total, 242);
    });

    test('cobro y reducción competidores conservan la invariante', () async {
      final (facturaId, linea) = await crearFacturaEmitida();

      final resultados = await Future.wait([
        capturar(
          cobroRepository.crearCobro(
            facturaId: facturaId,
            fecha: DateTime(2026, 8, 26),
            importe: 100,
            metodoPago: 'Transferencia',
          ),
        ),
        capturar(
          lineaRepository.actualizarLinea(
            id: linea.id,
            facturaId: facturaId,
            descripcion: linea.descripcion,
            cantidad: 1,
            unidad: linea.unidad,
            precioUnitario: 50,
            descuento: 0,
          ),
        ),
      ]);

      expect(resultados.where((resultado) => resultado == true), hasLength(1));
      final factura = await database.facturasDao.obtenerPorId(facturaId);
      final cobros = await database.cobrosDao
          .observarPorFactura(facturaId)
          .first;
      final totalCobrado = cobros.fold<double>(
        0,
        (suma, cobro) => suma + cobro.importe,
      );
      expect(factura!.total >= normalizarImporteCobro(totalCobrado), isTrue);
    });

    test('un rechazo revierte línea, total, cobros y estado', () async {
      final (facturaId, linea) = await crearFacturaEmitida();
      await cobroRepository.crearCobro(
        facturaId: facturaId,
        fecha: DateTime(2026, 8, 26),
        importe: 100,
        metodoPago: 'Transferencia',
      );

      await expectLater(
        lineaRepository.actualizarLinea(
          id: linea.id,
          facturaId: facturaId,
          descripcion: 'No debe persistir',
          cantidad: 1,
          unidad: linea.unidad,
          precioUnitario: 50,
          descuento: 0,
        ),
        throwsA(isA<FacturaNoPermiteModificarLineasException>()),
      );

      final factura = await database.facturasDao.obtenerPorId(facturaId);
      final lineas = await database.facturaLineasDao.obtenerPorFactura(
        facturaId,
      );
      final cobros = await database.cobrosDao
          .observarPorFactura(facturaId)
          .first;
      expect(factura?.total, 121);
      expect(factura?.estado, EstadoFactura.emitida);
      expect(lineas.single.descripcion, 'Trabajo');
      expect(lineas.single.precioUnitario, 100);
      expect(cobros.single.importe, 100);
    });
  });

  test('actualizarTotales público no modifica una emitida', () async {
    final (facturaId, _) = await crearFacturaEmitida();
    await cobroRepository.crearCobro(
      facturaId: facturaId,
      fecha: DateTime(2026, 8, 26),
      importe: 100,
      metodoPago: 'Transferencia',
    );

    await expectLater(
      facturaRepository.actualizarTotales(facturaId: facturaId, subtotal: 50),
      throwsA(isA<FacturaDocumentoCongeladoException>()),
    );

    final factura = await database.facturasDao.obtenerPorId(facturaId);
    expect(factura?.total, 121);
  });
}

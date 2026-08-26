import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/features/cobros/data/cobro_repository.dart';
import 'package:obraia_v2/features/facturas/data/factura_linea_repository.dart';
import 'package:obraia_v2/features/facturas/data/factura_repository.dart';
import 'package:obraia_v2/features/facturas/domain/estado_factura.dart';
import 'package:obraia_v2/features/facturas/domain/factura_linea.dart'
    as factura_linea_domain;

void main() {
  late AppDatabase database;
  late FacturaRepository facturas;
  late FacturaLineaRepository lineas;
  late CobroRepository cobros;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    facturas = FacturaRepository(database);
    lineas = FacturaLineaRepository(database);
    cobros = CobroRepository(database);
    await database.clientesDao.insertarCliente(
      ClientesCompanion.insert(id: 'cliente-1', nombre: 'Cliente uno'),
    );
    await database.clientesDao.insertarCliente(
      ClientesCompanion.insert(id: 'cliente-2', nombre: 'Cliente dos'),
    );
  });

  tearDown(() => database.close());

  Future<(String, factura_linea_domain.FacturaLinea)> crearBorrador() async {
    final id = await facturas.crearFactura(
      clienteId: 'cliente-1',
      fecha: DateTime(2026, 1, 10),
      fechaVencimiento: DateTime(2026, 2, 10),
      observaciones: 'Original',
    );
    await lineas.crearLinea(
      facturaId: id,
      descripcion: 'Trabajo',
      cantidad: 1,
      unidad: 'ud',
      precioUnitario: 100,
      descuento: 0,
    );
    final linea = (await database.facturaLineasDao.obtenerPorFactura(
      id,
    )).single;
    return (id, linea);
  }

  Future<void> fijarEstado(String id, EstadoFactura estado) {
    return database.facturasDao.actualizarEstado(
      id,
      estadoFacturaToString(estado),
    );
  }

  Future<void> actualizarCabecera(
    String id, {
    String clienteId = 'cliente-1',
    DateTime? fecha,
    DateTime? vencimiento,
    String observaciones = 'Original',
  }) {
    return facturas.actualizarFactura(
      id: id,
      clienteId: clienteId,
      fecha: fecha ?? DateTime(2026, 1, 10),
      fechaVencimiento: vencimiento ?? DateTime(2026, 2, 10),
      observaciones: observaciones,
    );
  }

  group('borrador', () {
    test('permite cabecera, líneas y totales', () async {
      final (id, linea) = await crearBorrador();

      await actualizarCabecera(
        id,
        clienteId: 'cliente-2',
        fecha: DateTime(2026, 1, 11),
        vencimiento: DateTime(2026, 3, 1),
        observaciones: 'Corregida',
      );
      await lineas.actualizarLinea(
        id: linea.id,
        facturaId: id,
        descripcion: 'Trabajo corregido',
        cantidad: 2,
        unidad: 'ud',
        precioUnitario: 80,
        descuento: 0,
      );
      await lineas.crearLinea(
        facturaId: id,
        descripcion: 'Extra',
        cantidad: 1,
        unidad: 'ud',
        precioUnitario: 10,
        descuento: 0,
      );
      final extra = (await database.facturaLineasDao.obtenerPorFactura(
        id,
      )).last;
      await lineas.eliminarLinea(extra.id, id);
      await facturas.actualizarTotales(facturaId: id, subtotal: 160);

      final persistida = await database.facturasDao.obtenerPorId(id);
      expect(persistida?.clienteId, 'cliente-2');
      expect(persistida?.fecha, DateTime(2026, 1, 11));
      expect(persistida?.observaciones, 'Corregida');
      expect(persistida?.total, 193.6);
    });
  });

  group('documento emitido', () {
    for (final estado in [
      EstadoFactura.emitida,
      EstadoFactura.vencida,
      EstadoFactura.cobrada,
    ]) {
      test('${estado.name} bloquea cabecera, líneas y totales', () async {
        final (id, linea) = await crearBorrador();
        await fijarEstado(id, estado);

        await expectLater(
          actualizarCabecera(id, clienteId: 'cliente-2'),
          throwsA(isA<FacturaDocumentoCongeladoException>()),
        );
        await expectLater(
          actualizarCabecera(id, fecha: DateTime(2026, 1, 11)),
          throwsA(isA<FacturaDocumentoCongeladoException>()),
        );
        await expectLater(
          actualizarCabecera(id, observaciones: 'Cambiada'),
          throwsA(isA<FacturaDocumentoCongeladoException>()),
        );
        await expectLater(
          lineas.crearLinea(
            facturaId: id,
            descripcion: 'No',
            cantidad: 1,
            unidad: 'ud',
            precioUnitario: 1,
            descuento: 0,
          ),
          throwsA(isA<FacturaNoPermiteModificarLineasException>()),
        );
        await expectLater(
          lineas.actualizarLinea(
            id: linea.id,
            facturaId: id,
            descripcion: 'No',
            cantidad: 1,
            unidad: 'ud',
            precioUnitario: 1,
            descuento: 0,
          ),
          throwsA(isA<FacturaNoPermiteModificarLineasException>()),
        );
        await expectLater(
          lineas.eliminarLinea(linea.id, id),
          throwsA(isA<FacturaNoPermiteModificarLineasException>()),
        );
        await expectLater(
          facturas.actualizarTotales(facturaId: id, subtotal: 1),
          throwsA(isA<FacturaDocumentoCongeladoException>()),
        );

        final persistida = await database.facturasDao.obtenerPorId(id);
        expect(persistida?.clienteId, 'cliente-1');
        expect(persistida?.fecha, DateTime(2026, 1, 10));
        expect(persistida?.observaciones, 'Original');
        expect(
          await database.facturaLineasDao.obtenerPorFactura(id),
          hasLength(1),
        );
      });
    }
  });

  group('vencimiento', () {
    test('vencida con saldo y vencimiento futuro vuelve a emitida', () async {
      final (id, _) = await crearBorrador();
      await fijarEstado(id, EstadoFactura.vencida);
      final futuro = DateTime.now().add(const Duration(days: 30));

      await actualizarCabecera(id, vencimiento: futuro);

      expect(
        (await database.facturasDao.obtenerPorId(id))?.estado,
        EstadoFactura.emitida,
      );
    });

    test('emitida con saldo y vencimiento pasado pasa a vencida', () async {
      final (id, _) = await crearBorrador();
      await fijarEstado(id, EstadoFactura.emitida);
      final ayer = DateTime.now().subtract(const Duration(days: 1));

      await actualizarCabecera(id, vencimiento: ayer);

      expect(
        (await database.facturasDao.obtenerPorId(id))?.estado,
        EstadoFactura.vencida,
      );
    });

    test('cobrada conserva su estado al cambiar vencimiento', () async {
      final (id, _) = await crearBorrador();
      await fijarEstado(id, EstadoFactura.emitida);
      await cobros.crearCobro(
        facturaId: id,
        fecha: DateTime.now(),
        importe: 121,
        metodoPago: 'Transferencia',
      );

      await actualizarCabecera(
        id,
        vencimiento: DateTime.now().subtract(const Duration(days: 1)),
      );

      expect(
        (await database.facturasDao.obtenerPorId(id))?.estado,
        EstadoFactura.cobrada,
      );
    });

    test('rechaza vencimiento anterior a la fecha documental', () async {
      final (id, _) = await crearBorrador();
      await fijarEstado(id, EstadoFactura.emitida);

      await expectLater(
        actualizarCabecera(id, vencimiento: DateTime(2026, 1, 9)),
        throwsA(isA<FechaVencimientoFacturaNoValidaException>()),
      );
    });
  });

  group('anulada', () {
    test('rechaza cabecera, vencimiento, líneas y totales', () async {
      final (id, linea) = await crearBorrador();
      await fijarEstado(id, EstadoFactura.anulada);

      await expectLater(
        actualizarCabecera(id, vencimiento: DateTime(2026, 3, 1)),
        throwsA(isA<FacturaDocumentoCongeladoException>()),
      );
      await expectLater(
        lineas.eliminarLinea(linea.id, id),
        throwsA(isA<FacturaNoPermiteModificarLineasException>()),
      );
      await expectLater(
        facturas.actualizarTotales(facturaId: id, subtotal: 1),
        throwsA(isA<FacturaDocumentoCongeladoException>()),
      );
    });
  });
}

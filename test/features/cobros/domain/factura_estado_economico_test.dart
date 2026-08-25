import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/features/cobros/domain/cobro.dart';
import 'package:obraia_v2/features/cobros/domain/factura_estado_economico.dart';
import 'package:obraia_v2/features/facturas/domain/estado_factura.dart';

void main() {
  Cobro cobro(String id, double importe) => Cobro(
    id: id,
    facturaId: 'factura-1',
    fecha: DateTime(2026),
    importe: importe,
    metodoPago: 'Transferencia',
    referencia: '',
    observaciones: '',
  );

  FacturaEstadoEconomico resumen(EstadoFactura estado) =>
      calcularResumenEconomicoFactura(
        totalFactura: 1000,
        totalCobrado: 250,
        fechaVencimiento: DateTime(2026, 1, 1),
        estadoFactura: estado,
        fechaReferencia: DateTime(2026, 1, 10),
      );

  group('calcularResumenEconomicoFactura', () {
    test('excluye borradores y anuladas de poblaciones económicas', () {
      for (final estado in [EstadoFactura.borrador, EstadoFactura.anulada]) {
        final resultado = resumen(estado);

        expect(resultado.tieneSaldoPendiente, isFalse);
        expect(resultado.esPendienteDeCobro, isFalse);
        expect(resultado.esParcialmenteCobrada, isFalse);
        expect(resultado.estaVencida, isFalse);
        expect(resultado.venceEnProximos7Dias, isFalse);
      }
    });

    test('incluye emitidas y vencidas en poblaciones económicas', () {
      for (final estado in [EstadoFactura.emitida, EstadoFactura.vencida]) {
        final resultado = resumen(estado);

        expect(resultado.tieneSaldoPendiente, isTrue);
        expect(resultado.esParcialmenteCobrada, isTrue);
        expect(resultado.estaVencida, isTrue);
      }
    });
  });

  group('estadoFacturaAdmiteEliminarCobros', () {
    test('permite saneamiento de cobros legacy de anuladas', () {
      expect(estadoFacturaAdmiteEliminarCobros(EstadoFactura.anulada), isTrue);
    });

    test('mantiene borradores fuera de la eliminación de cobros', () {
      expect(
        estadoFacturaAdmiteEliminarCobros(EstadoFactura.borrador),
        isFalse,
      );
    });

    test('mantiene permitidas emitidas, vencidas y cobradas', () {
      for (final estado in [
        EstadoFactura.emitida,
        EstadoFactura.vencida,
        EstadoFactura.cobrada,
      ]) {
        expect(estadoFacturaAdmiteEliminarCobros(estado), isTrue);
      }
    });
  });
  group('importeSuperaMaximoEditableCobro', () {
    test('acepta el máximo exacto y rechaza un céntimo por encima', () {
      expect(
        importeSuperaMaximoEditableCobro(importe: 800, maximoImporte: 800),
        isFalse,
      );
      expect(
        importeSuperaMaximoEditableCobro(importe: 800.01, maximoImporte: 800),
        isTrue,
      );
    });

    test('respeta el epsilon económico', () {
      expect(
        importeSuperaMaximoEditableCobro(
          importe: 800 + facturaEstadoEconomicoEpsilon,
          maximoImporte: 800,
        ),
        isFalse,
      );
    });
  });

  group('calcularMaximoImporteEditableCobro', () {
    test('permite reutilizar el importe del único cobro', () {
      final maximo = calcularMaximoImporteEditableCobro(
        totalFactura: 1000,
        cobrosActuales: [cobro('a', 300)],
        cobroId: 'a',
      );

      expect(maximo, 1000);
    });

    test('resta únicamente los otros cobros', () {
      final maximo = calcularMaximoImporteEditableCobro(
        totalFactura: 1000,
        cobrosActuales: [cobro('a', 300), cobro('b', 200)],
        cobroId: 'a',
      );

      expect(maximo, 800);
    });

    test('excluye por ID cuando dos cobros tienen el mismo importe', () {
      final maximo = calcularMaximoImporteEditableCobro(
        totalFactura: 1000,
        cobrosActuales: [cobro('a', 300), cobro('b', 300), cobro('c', 100)],
        cobroId: 'a',
      );

      expect(maximo, 600);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/features/cobros/domain/cobro.dart';
import 'package:obraia_v2/features/cobros/domain/factura_estado_economico.dart';

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

import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/features/facturas/domain/estado_factura.dart';

void main() {
  group('estadoFacturaEsEfectiva', () {
    test('incluye emitidas, cobradas y vencidas', () {
      expect(estadoFacturaEsEfectiva(EstadoFactura.emitida), isTrue);
      expect(estadoFacturaEsEfectiva(EstadoFactura.cobrada), isTrue);
      expect(estadoFacturaEsEfectiva(EstadoFactura.vencida), isTrue);
    });

    test('excluye borradores y anuladas', () {
      expect(estadoFacturaEsEfectiva(EstadoFactura.borrador), isFalse);
      expect(estadoFacturaEsEfectiva(EstadoFactura.anulada), isFalse);
    });

    test('una cobrada es efectiva pero no admite nuevos cobros', () {
      expect(estadoFacturaEsEfectiva(EstadoFactura.cobrada), isTrue);
      expect(estadoFacturaAdmiteNuevosCobros(EstadoFactura.cobrada), isFalse);
    });
  });

  group('estadoFacturaAdmiteNuevosCobros', () {
    test('admite facturas emitidas y vencidas', () {
      expect(estadoFacturaAdmiteNuevosCobros(EstadoFactura.emitida), isTrue);
      expect(estadoFacturaAdmiteNuevosCobros(EstadoFactura.vencida), isTrue);
    });

    test('rechaza facturas borrador, cobradas y anuladas', () {
      expect(estadoFacturaAdmiteNuevosCobros(EstadoFactura.borrador), isFalse);
      expect(estadoFacturaAdmiteNuevosCobros(EstadoFactura.cobrada), isFalse);
      expect(estadoFacturaAdmiteNuevosCobros(EstadoFactura.anulada), isFalse);
    });
  });
}

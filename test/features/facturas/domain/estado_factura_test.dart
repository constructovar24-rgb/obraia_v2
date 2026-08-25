import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/features/facturas/domain/estado_factura.dart';

void main() {
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

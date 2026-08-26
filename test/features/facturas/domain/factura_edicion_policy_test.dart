import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/features/facturas/domain/estado_factura.dart';

void main() {
  const casos = <EstadoFactura, (bool, bool, bool)>{
    EstadoFactura.borrador: (true, true, true),
    EstadoFactura.emitida: (false, true, false),
    EstadoFactura.vencida: (false, true, false),
    EstadoFactura.cobrada: (false, true, false),
    EstadoFactura.anulada: (false, false, false),
  };

  group('permisos de edición documental', () {
    for (final entry in casos.entries) {
      test('${entry.key.name} aplica permisos', () {
        final (documento, vencimiento, lineas) = entry.value;
        expect(estadoFacturaPermiteEditarDocumento(entry.key), documento);
        expect(estadoFacturaPermiteEditarVencimiento(entry.key), vencimiento);
        expect(estadoFacturaPermiteEditarLineas(entry.key), lineas);
      });
    }
  });
}

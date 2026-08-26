import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/features/facturas/services/factura_pdf_service.dart';

void main() {
  test('la etiqueta PDF usa el porcentaje persistido', () {
    expect(facturaIvaEtiqueta(7.5), 'IVA (7,50%)');
    expect(facturaIvaEtiqueta(0), 'IVA (0%)');
  });
}

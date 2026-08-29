import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/features/facturas/domain/estado_factura.dart';
import 'package:obraia_v2/features/facturas/domain/factura.dart';
import 'package:obraia_v2/features/facturas/domain/tipo_documento_factura.dart';
import 'package:obraia_v2/features/facturas/services/factura_pdf_service.dart';

void main() {
  test('la etiqueta PDF usa el porcentaje persistido', () {
    expect(facturaIvaEtiqueta(7.5), 'IVA (7,50%)');
    expect(facturaIvaEtiqueta(0), 'IVA (0%)');
  });

  test('una rectificativa usa título documental específico', () {
    final factura = Factura(
      id: 'rect',
      codigo: 'RECT-2026-0001',
      clienteId: 'cliente',
      clienteNombre: 'Cliente',
      fecha: DateTime(2026),
      fechaVencimiento: DateTime(2026),
      estado: EstadoFactura.emitida,
      subtotal: -10,
      iva: -2.1,
      ivaPorcentaje: 21,
      total: -12.1,
      observaciones: '',
      tipoDocumento: TipoDocumentoFactura.rectificativa,
    );
    expect(facturaTituloPdf(factura), 'FACTURA RECTIFICATIVA');
  });
}

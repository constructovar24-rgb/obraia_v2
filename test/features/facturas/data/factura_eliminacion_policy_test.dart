import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/features/facturas/data/factura_repository.dart';
import 'package:obraia_v2/features/facturas/domain/estado_factura.dart';

void main() {
  group('facturaPuedeEliminarse', () {
    test('permite un borrador sin cobros', () {
      expect(
        facturaPuedeEliminarse(
          estado: EstadoFactura.borrador,
          tieneCobros: false,
        ),
        isTrue,
      );
    });

    test('rechaza un borrador con cobros legacy', () {
      expect(
        facturaPuedeEliminarse(
          estado: EstadoFactura.borrador,
          tieneCobros: true,
        ),
        isFalse,
      );
    });

    for (final estado in <EstadoFactura>[
      EstadoFactura.emitida,
      EstadoFactura.vencida,
      EstadoFactura.cobrada,
      EstadoFactura.anulada,
    ]) {
      test('rechaza ${estado.name} incluso sin cobros', () {
        expect(
          facturaPuedeEliminarse(estado: estado, tieneCobros: false),
          isFalse,
        );
      });
    }
  });

  test('las excepciones de eliminación conservan el contexto de dominio', () {
    const inexistente = FacturaNoEncontradaAlEliminarException(
      facturaId: 'factura-inexistente',
    );
    const estado = FacturaNoEliminablePorEstadoException(
      facturaId: 'factura-emitida',
      estado: EstadoFactura.emitida,
    );
    const cobros = FacturaNoEliminableConCobrosException(
      facturaId: 'factura-con-cobros',
    );

    expect(inexistente.facturaId, 'factura-inexistente');
    expect(estado.facturaId, 'factura-emitida');
    expect(estado.estado, EstadoFactura.emitida);
    expect(cobros.facturaId, 'factura-con-cobros');
  });
}

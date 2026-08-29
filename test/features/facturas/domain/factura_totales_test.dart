import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/features/facturas/domain/factura_linea.dart';
import 'package:obraia_v2/features/facturas/domain/factura_totales.dart';

void main() {
  FacturaLinea linea(String id, double importe) => FacturaLinea(
    id: id,
    facturaId: 'factura-1',
    descripcion: 'Misma descripcion',
    cantidad: 1,
    unidad: 'ud',
    precioUnitario: importe,
    descuento: 0,
    importe: importe,
  );

  group('invariante economica', () {
    test('acepta total mayor que cobrado', () {
      expect(
        totalFacturaCubreCobros(totalFactura: 800, totalCobrado: 600),
        isTrue,
      );
    });

    test('acepta total exactamente igual a cobrado', () {
      expect(
        totalFacturaCubreCobros(totalFactura: 600, totalCobrado: 600),
        isTrue,
      );
    });

    test('acepta diferencia que normaliza al mismo céntimo', () {
      expect(
        totalFacturaCubreCobros(totalFactura: 599.996, totalCobrado: 600),
        isTrue,
      );
    });

    test('rechaza total claramente inferior a cobrado', () {
      expect(
        totalFacturaCubreCobros(totalFactura: 599.99, totalCobrado: 600),
        isFalse,
      );
    });
  });

  group('simulacion previa por id', () {
    test('edicion que mantiene el total sobre el limite es valida', () {
      final simuladas = sustituirLineaPorId(
        lineas: [linea('a', 500), linea('b', 500)],
        nuevaLinea: linea('b', 200),
      );
      final total = calcularTotalesFactura(simuladas, ivaPorcentaje: 21).total;

      expect(total, 847);
      expect(
        totalFacturaCubreCobros(totalFactura: total, totalCobrado: 800),
        isTrue,
      );
    });

    test('edicion que deja el total bajo el limite se rechaza', () {
      final simuladas = sustituirLineaPorId(
        lineas: [linea('a', 500), linea('b', 500)],
        nuevaLinea: linea('b', 100),
      );

      expect(
        totalFacturaCubreCobros(
          totalFactura: calcularTotalesFactura(
            simuladas,
            ivaPorcentaje: 21,
          ).total,
          totalCobrado: 800,
        ),
        isFalse,
      );
    });

    test('eliminacion que mantiene el total sobre el limite es valida', () {
      final simuladas = eliminarLineaPorId(
        lineas: [linea('a', 800), linea('b', 200)],
        lineaId: 'b',
      );

      expect(
        totalFacturaCubreCobros(
          totalFactura: calcularTotalesFactura(
            simuladas,
            ivaPorcentaje: 21,
          ).total,
          totalCobrado: 900,
        ),
        isTrue,
      );
    });

    test('eliminacion que deja el total bajo el limite se rechaza', () {
      final simuladas = eliminarLineaPorId(
        lineas: [linea('a', 500), linea('b', 500)],
        lineaId: 'b',
      );

      expect(
        totalFacturaCubreCobros(
          totalFactura: calcularTotalesFactura(
            simuladas,
            ivaPorcentaje: 21,
          ).total,
          totalCobrado: 800,
        ),
        isFalse,
      );
    });

    test('edita por id aunque el resto de campos coincidan', () {
      final simuladas = sustituirLineaPorId(
        lineas: [linea('a', 100), linea('b', 100)],
        nuevaLinea: linea('b', 50),
      );

      expect(simuladas.map((item) => item.importe), [100, 50]);
    });

    test('elimina exclusivamente por id', () {
      final simuladas = eliminarLineaPorId(
        lineas: [linea('a', 100), linea('b', 100)],
        lineaId: 'b',
      );

      expect(simuladas.single.id, 'a');
    });

    test('una simulacion rechazada no muta las lineas actuales', () {
      final actuales = [linea('a', 500), linea('b', 500)];
      final simuladas = sustituirLineaPorId(
        lineas: actuales,
        nuevaLinea: linea('b', 100),
      );

      expect(
        totalFacturaCubreCobros(
          totalFactura: calcularTotalesFactura(
            simuladas,
            ivaPorcentaje: 21,
          ).total,
          totalCobrado: 800,
        ),
        isFalse,
      );
      expect(actuales.map((item) => item.importe), [500, 500]);
    });
  });
}

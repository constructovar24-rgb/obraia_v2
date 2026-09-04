import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/features/economia/domain/plan_economico.dart';

void main() {
  test('calcula indirectos, beneficio y margen en céntimos', () {
    final resultado = calcularMagnitudesPrevistas(
      ventaNetaCentimos: 200000,
      numeroPartidas: 2,
      costesPartidasCentimos: const [50000, 70000],
      porcentajeIndirectos: 10,
    );

    expect(resultado.cobertura, CoberturaCostesPlan.completo);
    expect(resultado.costeDirectoCentimos, 120000);
    expect(resultado.costesIndirectosCentimos, 12000);
    expect(resultado.costeTotalCentimos, 132000);
    expect(resultado.beneficioPrevistoCentimos, 68000);
    expect(resultado.margenPrevistoPorcentaje, 34);
  });

  test('distingue coste desconocido, parcial y cero conocido', () {
    final desconocido = calcularMagnitudesPrevistas(
      ventaNetaCentimos: 10000,
      numeroPartidas: 1,
      costesPartidasCentimos: const [null],
      porcentajeIndirectos: 10,
    );
    final parcial = calcularMagnitudesPrevistas(
      ventaNetaCentimos: 10000,
      numeroPartidas: 2,
      costesPartidasCentimos: const [0, null],
      porcentajeIndirectos: 10,
    );
    final cero = calcularMagnitudesPrevistas(
      ventaNetaCentimos: 10000,
      numeroPartidas: 1,
      costesPartidasCentimos: const [0],
      porcentajeIndirectos: 0,
    );

    expect(desconocido.cobertura, CoberturaCostesPlan.sinCostes);
    expect(desconocido.costeDirectoCentimos, isNull);
    expect(parcial.cobertura, CoberturaCostesPlan.parcial);
    expect(parcial.costeDirectoCentimos, isNull);
    expect(cero.cobertura, CoberturaCostesPlan.completo);
    expect(cero.costeDirectoCentimos, 0);
    expect(cero.beneficioPrevistoCentimos, 10000);
  });

  test('venta cero conserva beneficio pero no fabrica margen', () {
    final resultado = calcularMagnitudesPrevistas(
      ventaNetaCentimos: 0,
      numeroPartidas: 1,
      costesPartidasCentimos: const [1000],
      porcentajeIndirectos: 5,
    );

    expect(resultado.beneficioPrevistoCentimos, -1050);
    expect(resultado.margenPrevistoPorcentaje, isNull);
  });

  test('redondea indirectos una sola vez sobre el total directo', () {
    final resultado = calcularMagnitudesPrevistas(
      ventaNetaCentimos: 10000,
      numeroPartidas: 2,
      costesPartidasCentimos: const [1001, 1002],
      porcentajeIndirectos: 7.5,
    );

    expect(resultado.costesIndirectosCentimos, 150);
  });
}

import '../database/precios.dart';
import '../models/partida.dart';
import '../models/pool_budget.dart';

class PoolEngine {
  static PoolBudget calcular({
    required double largo,
    required double ancho,
    required double profundidad,
  }) {
    // Magnitudes principales
    final volumen = largo * ancho * profundidad;

    final superficieFondo = largo * ancho;

    final superficieParedes =
        (2 * largo * profundidad) +
        (2 * ancho * profundidad);

    final superficieInterior =
        superficieFondo + superficieParedes;

    final perimetro = (largo + ancho) * 2;

    // Mediciones de obra
    final excavacion =
        (largo + 1.0) *
        (ancho + 1.0) *
        (profundidad + 0.20);

    final hormigonLimpieza =
        superficieFondo * 0.10;

    final losaHormigon =
        superficieFondo * 0.20;

    final muroBloque =
        superficieParedes;

    final impermeabilizacion =
        superficieInterior;

    final gresite =
        superficieInterior;

    final coronacion =
        perimetro;

    final partidas = <Partida>[
      Partida(
        codigo: 'EX001',
        descripcion: 'Excavación en terreno',
        unidad: 'm³',
        cantidad: excavacion,
        precioUnitario: Precios.excavacion,
      ),
      Partida(
        codigo: 'HL001',
        descripcion: 'Hormigón de limpieza HM-20',
        unidad: 'm³',
        cantidad: hormigonLimpieza,
        precioUnitario: Precios.hormigonLimpieza,
      ),
      Partida(
        codigo: 'HA001',
        descripcion: 'Losa de hormigón armado 20 cm',
        unidad: 'm³',
        cantidad: losaHormigon,
        precioUnitario: Precios.hormigonEstructural,
      ),
      Partida(
        codigo: 'BL001',
        descripcion: 'Muro de bloque 20 cm',
        unidad: 'm²',
        cantidad: muroBloque,
        precioUnitario: Precios.bloque20,
      ),
      Partida(
        codigo: 'IM001',
        descripcion: 'Impermeabilización',
        unidad: 'm²',
        cantidad: impermeabilizacion,
        precioUnitario: 18,
      ),
      Partida(
        codigo: 'GR001',
        descripcion: 'Revestimiento de gresite',
        unidad: 'm²',
        cantidad: gresite,
        precioUnitario: 42,
      ),
      Partida(
        codigo: 'CO001',
        descripcion: 'Piedra de coronación',
        unidad: 'ml',
        cantidad: coronacion,
        precioUnitario: 38,
      ),
    ];

    return PoolBudget(
      volumen: volumen,
      superficie: superficieInterior,
      perimetro: perimetro,
      partidas: partidas,
    );
  }
}
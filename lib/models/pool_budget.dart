import 'partida.dart';

class PoolBudget {
  final double volumen;
  final double superficie;
  final double perimetro;
  final List<Partida> partidas;

  const PoolBudget({
    required this.volumen,
    required this.superficie,
    required this.perimetro,
    required this.partidas,
  });

  double get total {
    double suma = 0;

    for (final partida in partidas) {
      suma += partida.importe;
    }

    return suma;
  }
}
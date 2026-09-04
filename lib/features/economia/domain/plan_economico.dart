enum CoberturaCostesPlan { sinCostes, parcial, completo }

class MagnitudesPrevistas {
  const MagnitudesPrevistas({
    required this.ventaNetaCentimos,
    required this.cobertura,
    this.costeDirectoCentimos,
    this.porcentajeIndirectos,
    this.costesIndirectosCentimos,
    this.costeTotalCentimos,
    this.beneficioPrevistoCentimos,
    this.margenPrevistoPorcentaje,
  });

  final int ventaNetaCentimos;
  final int? costeDirectoCentimos;
  final double? porcentajeIndirectos;
  final int? costesIndirectosCentimos;
  final int? costeTotalCentimos;
  final int? beneficioPrevistoCentimos;
  final double? margenPrevistoPorcentaje;
  final CoberturaCostesPlan cobertura;
}

MagnitudesPrevistas calcularMagnitudesPrevistas({
  required int ventaNetaCentimos,
  required int numeroPartidas,
  required Iterable<int?> costesPartidasCentimos,
  required double? porcentajeIndirectos,
}) {
  final costes = costesPartidasCentimos.toList(growable: false);
  final informados = costes.whereType<int>().toList(growable: false);
  final cobertura = informados.isEmpty
      ? CoberturaCostesPlan.sinCostes
      : informados.length == numeroPartidas && porcentajeIndirectos != null
      ? CoberturaCostesPlan.completo
      : CoberturaCostesPlan.parcial;
  if (cobertura != CoberturaCostesPlan.completo) {
    return MagnitudesPrevistas(
      ventaNetaCentimos: ventaNetaCentimos,
      cobertura: cobertura,
      porcentajeIndirectos: porcentajeIndirectos,
    );
  }
  final directo = informados.fold<int>(0, (total, value) => total + value);
  final indirectos = (directo * porcentajeIndirectos! / 100).round();
  final total = directo + indirectos;
  final beneficio = ventaNetaCentimos - total;
  return MagnitudesPrevistas(
    ventaNetaCentimos: ventaNetaCentimos,
    costeDirectoCentimos: directo,
    porcentajeIndirectos: porcentajeIndirectos,
    costesIndirectosCentimos: indirectos,
    costeTotalCentimos: total,
    beneficioPrevistoCentimos: beneficio,
    margenPrevistoPorcentaje: ventaNetaCentimos == 0
        ? null
        : beneficio / ventaNetaCentimos * 100,
    cobertura: cobertura,
  );
}

class CategoriaEconomica {
  const CategoriaEconomica({
    required this.id,
    required this.codigo,
    required this.nombre,
    required this.orden,
    required this.activa,
  });
  final String id;
  final String codigo;
  final String nombre;
  final int orden;
  final bool activa;
}

class CostePrevistoLinea {
  const CostePrevistoLinea({
    required this.lineaPresupuestoId,
    required this.categoriaEconomicaId,
    required this.costeCentimos,
  });
  final String lineaPresupuestoId;
  final String categoriaEconomicaId;
  final int costeCentimos;
}

class PlanEconomico {
  const PlanEconomico({
    required this.id,
    required this.expedienteId,
    required this.presupuestoId,
    required this.fechaAceptacion,
    required this.magnitudes,
  });
  final String id;
  final String expedienteId;
  final String presupuestoId;
  final DateTime fechaAceptacion;
  final MagnitudesPrevistas magnitudes;
}

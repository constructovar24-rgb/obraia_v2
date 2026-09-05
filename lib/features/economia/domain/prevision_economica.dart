enum EstadoCompromiso { activo, cumplido, cancelado }

enum CoberturaForecast { noDisponible, parcial, completa }

class CompromisoEconomico {
  const CompromisoEconomico({
    required this.id,
    required this.expedienteId,
    required this.descripcion,
    required this.origenTipo,
    required this.importeComprometidoCentimos,
    required this.importeConsumidoCentimos,
    required this.estado,
    required this.fechaCompromiso,
    this.categoriaEconomicaId,
    this.planEconomicoId,
    this.planEconomicoPartidaId,
    this.origenId,
  });

  final String id;
  final String expedienteId;
  final String? categoriaEconomicaId;
  final String? planEconomicoId;
  final String? planEconomicoPartidaId;
  final String descripcion;
  final String origenTipo;
  final String? origenId;
  final int importeComprometidoCentimos;
  final int importeConsumidoCentimos;
  final EstadoCompromiso estado;
  final DateTime fechaCompromiso;

  int get pendienteCentimos =>
      (importeComprometidoCentimos - importeConsumidoCentimos).clamp(
        0,
        importeComprometidoCentimos,
      );
}

class EstimacionCosteRestante {
  const EstimacionCosteRestante({
    required this.id,
    required this.serieId,
    required this.version,
    required this.expedienteId,
    required this.importeAdicionalCentimos,
    required this.justificacion,
    required this.fechaEstimacion,
    this.categoriaEconomicaId,
    this.planEconomicoId,
    this.planEconomicoPartidaId,
  });
  final String id;
  final String serieId;
  final int version;
  final String expedienteId;
  final String? categoriaEconomicaId;
  final String? planEconomicoId;
  final String? planEconomicoPartidaId;
  final int importeAdicionalCentimos;
  final String justificacion;
  final DateTime fechaEstimacion;
}

class ResumenForecastObra {
  const ResumenForecastObra({
    required this.costeRealCentimos,
    required this.comprometidoPendienteCentimos,
    required this.estimacionAdicionalCentimos,
    required this.subtotalConocidoCentimos,
    required this.cobertura,
    required this.ventaPlanificadaCentimos,
    required this.costePlanificadoCentimos,
    required this.beneficioPlanificadoCentimos,
    required this.margenPlanificadoPorcentaje,
    required this.costeFinalEstimadoCentimos,
    required this.beneficioFinalEstimadoCentimos,
    required this.margenFinalEstimadoPorcentaje,
    required this.porCategoriaCentimos,
    required this.tieneCompromisosSobreconsumidos,
    required this.desgloseCategorias,
  });
  final int costeRealCentimos;
  final int comprometidoPendienteCentimos;
  final int estimacionAdicionalCentimos;
  final int subtotalConocidoCentimos;
  final CoberturaForecast cobertura;
  final int? ventaPlanificadaCentimos;
  final int? costePlanificadoCentimos;
  final int? beneficioPlanificadoCentimos;
  final double? margenPlanificadoPorcentaje;
  final int? costeFinalEstimadoCentimos;
  final int? beneficioFinalEstimadoCentimos;
  final double? margenFinalEstimadoPorcentaje;
  final Map<String?, int> porCategoriaCentimos;
  final bool tieneCompromisosSobreconsumidos;
  final List<DesgloseForecastCategoria> desgloseCategorias;

  int? get desviacionCosteCentimos =>
      costeFinalEstimadoCentimos == null || costePlanificadoCentimos == null
      ? null
      : costeFinalEstimadoCentimos! - costePlanificadoCentimos!;
  int? get desviacionBeneficioCentimos =>
      beneficioFinalEstimadoCentimos == null ||
          beneficioPlanificadoCentimos == null
      ? null
      : beneficioFinalEstimadoCentimos! - beneficioPlanificadoCentimos!;

  bool get forecastSuperaPlan =>
      costeFinalEstimadoCentimos != null &&
      costePlanificadoCentimos != null &&
      costeFinalEstimadoCentimos! > costePlanificadoCentimos!;
  bool get beneficioNegativo =>
      beneficioFinalEstimadoCentimos != null &&
      beneficioFinalEstimadoCentimos! < 0;
  bool get margenInferiorAlPlan =>
      margenFinalEstimadoPorcentaje != null &&
      margenPlanificadoPorcentaje != null &&
      margenFinalEstimadoPorcentaje! < margenPlanificadoPorcentaje!;
}

class DesgloseForecastCategoria {
  const DesgloseForecastCategoria({
    required this.categoriaId,
    required this.nombre,
    required this.previstoCentimos,
    required this.realCentimos,
    required this.comprometidoCentimos,
    required this.restanteCentimos,
  });

  final String? categoriaId;
  final String nombre;
  final int? previstoCentimos;
  final int realCentimos;
  final int comprometidoCentimos;
  final int restanteCentimos;
  int get finalConocidoCentimos =>
      realCentimos + comprometidoCentimos + restanteCentimos;
  int? get desviacionCentimos => previstoCentimos == null
      ? null
      : finalConocidoCentimos - previstoCentimos!;
}

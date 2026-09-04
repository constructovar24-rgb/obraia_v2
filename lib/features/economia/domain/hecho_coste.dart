enum TipoMovimientoCoste { alta, reversion, ajuste }

class HechoCoste {
  const HechoCoste({
    required this.id,
    required this.expedienteId,
    required this.fechaDevengo,
    required this.importeNetoCentimos,
    required this.ivaNoRecuperableCentimos,
    required this.importeCosteCentimos,
    required this.descripcion,
    required this.origenTipo,
    required this.origenId,
    required this.tipoMovimiento,
    this.categoriaEconomicaId,
    this.planEconomicoId,
    this.planEconomicoPartidaId,
    this.hechoRevertidoId,
  });

  final String id;
  final String expedienteId;
  final String? categoriaEconomicaId;
  final String? planEconomicoId;
  final String? planEconomicoPartidaId;
  final DateTime fechaDevengo;
  final int importeNetoCentimos;
  final int ivaNoRecuperableCentimos;
  final int importeCosteCentimos;
  final String descripcion;
  final String origenTipo;
  final String origenId;
  final TipoMovimientoCoste tipoMovimiento;
  final String? hechoRevertidoId;
}

class ResumenCosteReal {
  const ResumenCosteReal({
    required this.totalCentimos,
    required this.porCategoriaCentimos,
    required this.sinAsignarCentimos,
    required this.numeroHechos,
  });
  final int totalCentimos;
  final Map<String, int> porCategoriaCentimos;
  final int sinAsignarCentimos;
  final int numeroHechos;
}

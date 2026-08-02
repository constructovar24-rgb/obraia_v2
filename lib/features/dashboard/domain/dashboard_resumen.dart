class DashboardResumen {
  const DashboardResumen({
    required this.numeroExpedientes,
    required this.numeroPresupuestos,
    required this.presupuestosPendientesFacturar,
    required this.presupuestosFacturados,
    required this.totalPresupuestado,
    required this.numeroFacturas,
    required this.facturasPendientesCobro,
    required this.facturasParcialmenteCobradas,
    required this.facturasCobradas,
    required this.totalFacturado,
    required this.totalCobrado,
    required this.totalCobradoEsteMes,
    required this.totalFacturadoEsteMes,
    required this.pendienteTotal,
  });

  final int numeroExpedientes;
  final int numeroPresupuestos;
  final int presupuestosPendientesFacturar;
  final int presupuestosFacturados;
  final double totalPresupuestado;
  final int numeroFacturas;
  final int facturasPendientesCobro;
  final int facturasParcialmenteCobradas;
  final int facturasCobradas;
  final double totalFacturado;
  final double totalCobrado;
  final double totalCobradoEsteMes;
  final double totalFacturadoEsteMes;
  final double pendienteTotal;

  bool get isEmpty {
    return numeroExpedientes == 0 &&
        numeroPresupuestos == 0 &&
        numeroFacturas == 0 &&
        totalPresupuestado == 0 &&
        totalFacturado == 0 &&
        totalCobrado == 0;
  }
}

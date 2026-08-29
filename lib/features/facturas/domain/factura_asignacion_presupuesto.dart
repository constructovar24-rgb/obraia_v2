class FacturaAsignacionPresupuesto {
  const FacturaAsignacionPresupuesto({
    required this.id,
    required this.facturaId,
    required this.facturaLineaId,
    required this.presupuestoId,
    required this.lineaPresupuestoId,
    required this.cantidadAplicada,
    required this.baseAplicada,
    required this.certificacionOrigenId,
  });

  final String id;
  final String facturaId;
  final String facturaLineaId;
  final String presupuestoId;
  final String lineaPresupuestoId;
  final double? cantidadAplicada;
  final double baseAplicada;
  final String? certificacionOrigenId;
}

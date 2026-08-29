class LineaPresupuesto {
  final String id;
  final String presupuestoId;
  final String concepto;
  final double cantidad;
  final String unidad;
  final double precioUnitario;

  double get importe => cantidad * precioUnitario;

  const LineaPresupuesto({
    required this.id,
    required this.presupuestoId,
    required this.concepto,
    required this.cantidad,
    required this.unidad,
    required this.precioUnitario,
  });
}

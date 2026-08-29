class FacturaLinea {
  final String id;
  final String facturaId;
  final String? lineaRectificadaId;
  final String? lineaRaizId;
  final String descripcion;
  final double cantidad;
  final String unidad;
  final double precioUnitario;
  final double descuento;
  final double importe;

  const FacturaLinea({
    required this.id,
    required this.facturaId,
    this.lineaRectificadaId,
    this.lineaRaizId,
    required this.descripcion,
    required this.cantidad,
    required this.unidad,
    required this.precioUnitario,
    required this.descuento,
    required this.importe,
  });
}

class Cobro {
  final String id;
  final String facturaId;
  final DateTime fecha;
  final double importe;
  final String metodoPago;
  final String referencia;
  final String observaciones;

  const Cobro({
    required this.id,
    required this.facturaId,
    required this.fecha,
    required this.importe,
    required this.metodoPago,
    required this.referencia,
    required this.observaciones,
  });
}
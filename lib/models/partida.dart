class Partida {
  final String codigo;
  final String descripcion;
  final String unidad;
  final double cantidad;
  final double precioUnitario;

  const Partida({
    required this.codigo,
    required this.descripcion,
    required this.unidad,
    required this.cantidad,
    required this.precioUnitario,
  });

  double get importe => cantidad * precioUnitario;
}
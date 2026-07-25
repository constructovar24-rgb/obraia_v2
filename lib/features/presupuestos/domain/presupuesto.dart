class Presupuesto {
  final String id;
  final String expedienteId;
  final String codigo;
  final DateTime fecha;
  final String descripcion;
  final double importeTotal;
  final String estado;
  final bool eliminado;
  final DateTime fechaCreacion;
  final DateTime fechaModificacion;

  const Presupuesto({
    required this.id,
    required this.expedienteId,
    required this.codigo,
    required this.fecha,
    required this.descripcion,
    required this.importeTotal,
    required this.estado,
    required this.eliminado,
    required this.fechaCreacion,
    required this.fechaModificacion,
  });
}

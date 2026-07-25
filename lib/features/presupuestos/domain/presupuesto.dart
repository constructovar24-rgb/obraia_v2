class Presupuesto {
  final String id;
  final String expedienteId;
  final String codigo;
  final DateTime fecha;
  final String descripcion;
  final int estado;
  final bool eliminado;
  final DateTime fechaCreacion;
  final DateTime fechaModificacion;

  const Presupuesto({
    required this.id,
    required this.expedienteId,
    required this.codigo,
    required this.fecha,
    required this.descripcion,
    required this.estado,
    required this.eliminado,
    required this.fechaCreacion,
    required this.fechaModificacion,
  });
}

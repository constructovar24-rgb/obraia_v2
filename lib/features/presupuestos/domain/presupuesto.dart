class Presupuesto {
  final String id;
  final String expedienteId;
  final String titulo;
  final int estado;
  final bool eliminado;
  final DateTime fechaCreacion;
  final DateTime fechaModificacion;

  const Presupuesto({
    required this.id,
    required this.expedienteId,
    required this.titulo,
    required this.estado,
    required this.eliminado,
    required this.fechaCreacion,
    required this.fechaModificacion,
  });
}

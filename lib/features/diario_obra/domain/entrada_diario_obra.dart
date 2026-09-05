class EntradaDiarioObra {
  const EntradaDiarioObra({
    required this.id,
    required this.expedienteId,
    required this.fechaTrabajo,
    required this.trabajos,
    required this.anulado,
    required this.fechaCreacion,
    required this.fechaModificacion,
    this.observaciones,
    this.meteorologia,
    this.incidenciaTexto,
    this.actuacionId,
    this.actuacionDescripcion,
  });

  final String id;
  final String expedienteId;
  final DateTime fechaTrabajo;
  final String trabajos;
  final String? observaciones;
  final String? meteorologia;
  final String? incidenciaTexto;
  final String? actuacionId;
  final String? actuacionDescripcion;
  final bool anulado;
  final DateTime fechaCreacion;
  final DateTime fechaModificacion;
}

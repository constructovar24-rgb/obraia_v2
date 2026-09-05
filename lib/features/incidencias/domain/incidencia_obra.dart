enum EstadoIncidenciaObra { abierta, enSeguimiento, resuelta, cancelada }

enum PrioridadIncidenciaObra { baja, media, alta }

class IncidenciaObra {
  const IncidenciaObra({
    required this.id,
    required this.expedienteId,
    required this.fechaDeteccion,
    required this.titulo,
    required this.descripcion,
    required this.estado,
    required this.prioridad,
    required this.fechaCreacion,
    required this.fechaModificacion,
    this.fechaResolucion,
    this.resolucion,
    this.documentoIds = const [],
    this.entradaDiarioIds = const [],
  });

  final String id;
  final String expedienteId;
  final DateTime fechaDeteccion;
  final String titulo;
  final String descripcion;
  final EstadoIncidenciaObra estado;
  final PrioridadIncidenciaObra prioridad;
  final DateTime? fechaResolucion;
  final String? resolucion;
  final DateTime fechaCreacion;
  final DateTime fechaModificacion;
  final List<String> documentoIds;
  final List<String> entradaDiarioIds;
}

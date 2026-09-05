enum EstadoOperativoObra {
  pendiente,
  preparada,
  enEjecucion,
  pausada,
  finalizada,
  cancelada,
}

enum EstadoActuacionObra { pendiente, completado, cancelado }

enum TipoActuacionObra { proximoPaso, actuacion }

class PlanificacionObra {
  const PlanificacionObra({
    required this.expedienteId,
    required this.estado,
    this.inicioPrevisto,
    this.finPrevisto,
    this.inicioReal,
    this.finReal,
  });

  final String expedienteId;
  final EstadoOperativoObra estado;
  final DateTime? inicioPrevisto;
  final DateTime? finPrevisto;
  final DateTime? inicioReal;
  final DateTime? finReal;
}

class ActuacionObra {
  const ActuacionObra({
    required this.id,
    required this.expedienteId,
    required this.tipo,
    required this.descripcion,
    required this.estado,
    required this.orden,
    this.fechaPrevista,
    this.observaciones,
  });

  final String id;
  final String expedienteId;
  final TipoActuacionObra tipo;
  final String descripcion;
  final DateTime? fechaPrevista;
  final EstadoActuacionObra estado;
  final int orden;
  final String? observaciones;
}

class PlanificacionFechasInvalidasException implements Exception {
  const PlanificacionFechasInvalidasException(this.mensaje);
  final String mensaje;
  @override
  String toString() => mensaje;
}

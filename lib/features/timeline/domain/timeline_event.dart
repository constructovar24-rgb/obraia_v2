enum TimelineEventType {
  expedienteCreado,
  expedienteActualizado,
  presupuestoCreado,
  presupuestoActualizado,
  presupuestoAceptado,
  facturaCreada,
  facturaAnulada,
  cobroRegistrado,
  documentoSubido,
  fotografiaAnadida,
  notaCreada,
  compraRegistrada,
}

class TimelineEvent {
  final String id;
  final String expedienteId;
  final DateTime fecha;
  final TimelineEventType tipo;
  final String titulo;
  final String? descripcion;
  final String? referenciaId;

  const TimelineEvent({
    required this.id,
    required this.expedienteId,
    required this.fecha,
    required this.tipo,
    required this.titulo,
    this.descripcion,
    this.referenciaId,
  });
}

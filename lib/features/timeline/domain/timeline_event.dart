enum TimelineEventType {
  expedienteCreado,
  expedienteActualizado,
  presupuestoCreado,
  presupuestoActualizado,
  presupuestoAceptado,
  facturaCreada,
  facturaEmitida,
  facturaAnulada,
  rectificativaCreada,
  rectificativaEmitida,
  rectificativaAnulada,
  saldoFavorGenerado,
  cobroRegistrado,
  cobroEliminado,
  cobroRevertido,
  devolucionRegistrada,
  devolucionRevertida,
  compensacionAplicada,
  compensacionRecibida,
  compensacionRevertida,
  facturaBorradorEliminada,
  documentoSubido,
  fotografiaAnadida,
  notaCreada,
  compraRegistrada,
}

enum TimelineCreditoTipo {
  devolucionRegistrada,
  devolucionRevertida,
  compensacionAplicada,
  compensacionRecibida,
  compensacionRevertida,
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

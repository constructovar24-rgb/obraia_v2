enum CertificacionEstado {
  borrador,
  emitida,
  facturada,
}

class Certificacion {
  final String id;
  final String expedienteId;
  final String? presupuestoId;
  final String codigo;
  final DateTime fecha;
  final String descripcion;
  final double baseImponible;
  final double ivaPorcentaje;
  final double importeTotal;
  final CertificacionEstado estado;
  final String? observaciones;

  const Certificacion({
    required this.id,
    required this.expedienteId,
    required this.presupuestoId,
    required this.codigo,
    required this.fecha,
    required this.descripcion,
    required this.baseImponible,
    required this.ivaPorcentaje,
    required this.importeTotal,
    required this.estado,
    required this.observaciones,
  });
}

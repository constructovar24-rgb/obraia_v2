class LineaAlbaranInput {
  const LineaAlbaranInput({
    required this.descripcion,
    required this.cantidad,
    this.unidad,
    this.precioUnitarioCentimos,
    this.importeCentimos,
    this.observaciones,
    this.asignaciones = const [],
  });
  final String descripcion;
  final double cantidad;
  final String? unidad;
  final int? precioUnitarioCentimos;
  final int? importeCentimos;
  final String? observaciones;
  final List<AsignacionImporteInput> asignaciones;
}

class AsignacionImporteInput {
  const AsignacionImporteInput({
    this.expedienteId,
    required this.importeCentimos,
    this.ivaNoRecuperableCentimos = 0,
  });
  final String? expedienteId;
  final int importeCentimos;
  final int ivaNoRecuperableCentimos;
}

class AlbaranInput {
  const AlbaranInput({
    required this.proveedorId,
    required this.referencia,
    required this.fecha,
    required this.lineas,
    this.observaciones,
    this.documentoId,
  });
  final String proveedorId;
  final String referencia;
  final DateTime fecha;
  final List<LineaAlbaranInput> lineas;
  final String? observaciones;
  final String? documentoId;
}

class FacturaRecibidaInput {
  const FacturaRecibidaInput({
    required this.proveedorId,
    required this.numero,
    required this.fecha,
    required this.baseCentimos,
    required this.ivaCentimos,
    required this.asignaciones,
    this.vencimiento,
    this.documentoId,
    this.albaranIds = const [],
  });
  final String proveedorId;
  final String numero;
  final DateTime fecha;
  final DateTime? vencimiento;
  final int baseCentimos;
  final int ivaCentimos;
  final String? documentoId;
  final List<String> albaranIds;
  final List<AsignacionImporteInput> asignaciones;
}

class SenalesSuministrosObra {
  const SenalesSuministrosObra({
    required this.albaranesPendientesFactura,
    required this.imputacionesPendientesReconciliar,
    required this.facturaVencidaPendiente,
  });
  final int albaranesPendientesFactura;
  final int imputacionesPendientesReconciliar;
  final bool facturaVencidaPendiente;
}

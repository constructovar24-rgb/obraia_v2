enum EstadoEconomicoFactura {
  pendiente,
  parcialmenteCobrada,
  cobrada,
}

EstadoEconomicoFactura calcularEstadoEconomicoFactura({
  required double totalFactura,
  required double totalCobrado,
}) {
  const epsilon = 0.000001;

  if (totalCobrado <= epsilon) {
    return EstadoEconomicoFactura.pendiente;
  }

  if (totalCobrado + epsilon < totalFactura) {
    return EstadoEconomicoFactura.parcialmenteCobrada;
  }

  return EstadoEconomicoFactura.cobrada;
}

String estadoEconomicoFacturaToLabel(EstadoEconomicoFactura estado) {
  switch (estado) {
    case EstadoEconomicoFactura.pendiente:
      return 'Pendiente';
    case EstadoEconomicoFactura.parcialmenteCobrada:
      return 'Parcialmente cobrada';
    case EstadoEconomicoFactura.cobrada:
      return 'Cobrada';
  }
}

class FacturaEstadoEconomico {
  const FacturaEstadoEconomico({
    required this.totalFactura,
    required this.totalCobrado,
    required this.pendiente,
    required this.estado,
  });

  final double totalFactura;
  final double totalCobrado;
  final double pendiente;
  final EstadoEconomicoFactura estado;
}

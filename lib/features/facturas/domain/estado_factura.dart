enum EstadoFactura {
  borrador,
  emitida,
  cobrada,
  vencida,
  anulada,
}

const estadosFactura = [
  EstadoFactura.borrador,
  EstadoFactura.emitida,
  EstadoFactura.cobrada,
  EstadoFactura.vencida,
  EstadoFactura.anulada,
];

EstadoFactura estadoFacturaFromString(String value) {
  switch (value.toLowerCase()) {
    case 'emitida':
      return EstadoFactura.emitida;
    case 'cobrada':
      return EstadoFactura.cobrada;
    case 'vencida':
      return EstadoFactura.vencida;
    case 'anulada':
      return EstadoFactura.anulada;
    case 'borrador':
    default:
      return EstadoFactura.borrador;
  }
}

String estadoFacturaToString(EstadoFactura estado) {
  return estado.name;
}

String estadoFacturaToLabel(EstadoFactura estado) {
  switch (estado) {
    case EstadoFactura.borrador:
      return 'Borrador';
    case EstadoFactura.emitida:
      return 'Emitida';
    case EstadoFactura.cobrada:
      return 'Cobrada';
    case EstadoFactura.vencida:
      return 'Vencida';
    case EstadoFactura.anulada:
      return 'Anulada';
  }
}

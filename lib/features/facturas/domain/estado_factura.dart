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

bool estadoFacturaAdmiteNuevosCobros(EstadoFactura estado) {
  return estado == EstadoFactura.emitida || estado == EstadoFactura.vencida;
}

bool estadoFacturaAdmiteModificarCobros(EstadoFactura estado) {
  return estado == EstadoFactura.emitida ||
      estado == EstadoFactura.vencida ||
      estado == EstadoFactura.cobrada;
}

bool estadoFacturaPermiteEditarDocumento(EstadoFactura estado) {
  return estado == EstadoFactura.borrador;
}

bool estadoFacturaPermiteEditarVencimiento(EstadoFactura estado) {
  return estado != EstadoFactura.anulada;
}

bool estadoFacturaPermiteEditarLineas(EstadoFactura estado) {
  return estado == EstadoFactura.borrador;
}

const epsilonEstadoFactura = 0.000001;

EstadoFactura resolverEstadoDocumentalFactura({
  required EstadoFactura estadoActual,
  required double totalFactura,
  required double totalCobrado,
  required DateTime fechaVencimiento,
  DateTime? fechaReferencia,
}) {
  if (estadoActual == EstadoFactura.anulada) {
    return EstadoFactura.anulada;
  }
  if (estadoActual == EstadoFactura.borrador) {
    return EstadoFactura.borrador;
  }

  final saldo = totalFactura - totalCobrado;
  if (saldo <= epsilonEstadoFactura) {
    return EstadoFactura.cobrada;
  }

  final referencia = fechaReferencia ?? DateTime.now();
  final hoy = DateTime(referencia.year, referencia.month, referencia.day);
  final vencimiento = DateTime(
    fechaVencimiento.year,
    fechaVencimiento.month,
    fechaVencimiento.day,
  );
  if (vencimiento.isBefore(hoy)) {
    return EstadoFactura.vencida;
  }
  return EstadoFactura.emitida;
}

class DatosLineaEmision {
  const DatosLineaEmision({
    required this.cantidad,
    required this.precioUnitario,
  });
  final double cantidad;
  final double precioUnitario;
}

String? validarEmisionFactura({
  required EstadoFactura estadoActual,
  required bool clienteExiste,
  required Iterable<DatosLineaEmision> lineas,
  required double total,
  required DateTime fechaFactura,
  required DateTime fechaVencimiento,
}) {
  if (estadoActual != EstadoFactura.borrador) {
    return 'Solo puede emitirse una factura en borrador.';
  }
  if (!clienteExiste) return 'El cliente de la factura ya no existe.';
  if (lineas.isEmpty) return 'Añade al menos una línea antes de emitir.';
  if (total <= 0) return 'No puede emitirse una factura con total cero.';
  if (fechaVencimiento.isBefore(fechaFactura)) {
    return 'El vencimiento no puede ser anterior a la fecha de factura.';
  }
  if (lineas.any((linea) => linea.cantidad <= 0)) {
    return 'Todas las líneas deben tener cantidad mayor que cero.';
  }
  if (lineas.any((linea) => linea.precioUnitario < 0)) {
    return 'Ninguna línea puede tener precio negativo.';
  }
  return null;
}

bool estadoFacturaEsEfectiva(EstadoFactura estado) {
  return estado == EstadoFactura.emitida ||
      estado == EstadoFactura.cobrada ||
      estado == EstadoFactura.vencida;
}

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

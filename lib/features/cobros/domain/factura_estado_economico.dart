import '../../facturas/domain/estado_factura.dart';
import '../../facturas/domain/factura.dart' as factura_domain;

enum EstadoEconomicoFactura { pendiente, parcialmenteCobrada, cobrada }

const facturaEstadoEconomicoEpsilon = 0.000001;

EstadoEconomicoFactura calcularEstadoEconomicoFactura({
  required double totalFactura,
  required double totalCobrado,
}) {
  if (totalCobrado <= facturaEstadoEconomicoEpsilon) {
    return EstadoEconomicoFactura.pendiente;
  }

  if (totalCobrado + facturaEstadoEconomicoEpsilon < totalFactura) {
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
    this.esPendienteDeCobro = false,
    this.esParcialmenteCobrada = false,
    this.estaVencida = false,
    this.venceEnProximos7Dias = false,
  });

  final double totalFactura;
  final double totalCobrado;
  final double pendiente;
  final EstadoEconomicoFactura estado;
  final bool esPendienteDeCobro;
  final bool esParcialmenteCobrada;
  final bool estaVencida;
  final bool venceEnProximos7Dias;
}

class FacturaConEstadoEconomico {
  const FacturaConEstadoEconomico({
    required this.factura,
    required this.estadoEconomico,
  });

  final factura_domain.Factura factura;
  final FacturaEstadoEconomico estadoEconomico;
}

FacturaEstadoEconomico calcularResumenEconomicoFactura({
  required double totalFactura,
  required double totalCobrado,
  required DateTime fechaVencimiento,
  required EstadoFactura estadoFactura,
  required DateTime fechaReferencia,
}) {
  final pendiente = (totalFactura - totalCobrado)
      .clamp(0, double.infinity)
      .toDouble();
  final estadoEconomico = calcularEstadoEconomicoFactura(
    totalFactura: totalFactura,
    totalCobrado: totalCobrado,
  );
  final estaAnulada = estadoFactura == EstadoFactura.anulada;
  final tienePendiente = pendiente > facturaEstadoEconomicoEpsilon;
  final hoy = DateTime(
    fechaReferencia.year,
    fechaReferencia.month,
    fechaReferencia.day,
  );
  final vencimiento = DateTime(
    fechaVencimiento.year,
    fechaVencimiento.month,
    fechaVencimiento.day,
  );
  final limiteProximos7Dias = hoy.add(const Duration(days: 7));

  return FacturaEstadoEconomico(
    totalFactura: totalFactura,
    totalCobrado: totalCobrado,
    pendiente: pendiente,
    estado: estadoEconomico,
    esPendienteDeCobro:
        !estaAnulada &&
        estadoEconomico == EstadoEconomicoFactura.pendiente &&
        tienePendiente,
    esParcialmenteCobrada:
        !estaAnulada &&
        estadoEconomico == EstadoEconomicoFactura.parcialmenteCobrada &&
        tienePendiente,
    estaVencida: !estaAnulada && tienePendiente && vencimiento.isBefore(hoy),
    venceEnProximos7Dias:
        !estaAnulada &&
        tienePendiente &&
        !vencimiento.isBefore(hoy) &&
        !vencimiento.isAfter(limiteProximos7Dias),
  );
}

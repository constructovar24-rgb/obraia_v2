import '../../facturas/domain/estado_factura.dart';
import '../../facturas/domain/factura.dart' as factura_domain;
import '../../facturas/domain/redondeo_monetario.dart';
import 'cobro.dart';

enum EstadoEconomicoFactura { pendiente, parcialmenteCobrada, cobrada }

double normalizarImporteCobro(double importe) => redondearMoneda(importe);

double calcularTotalCobradoNeto(Iterable<Cobro> cobros) => redondearMoneda(
  cobros.fold<double>(0, (total, cobro) => total + cobro.importeNeto),
);

bool estadoFacturaAdmiteEliminarCobros(EstadoFactura estado) {
  return estadoFacturaAdmiteModificarCobros(estado) ||
      estado == EstadoFactura.anulada;
}

bool importeSuperaMaximoEditableCobro({
  required double importe,
  required double maximoImporte,
}) {
  return normalizarImporteCobro(importe) >
      normalizarImporteCobro(maximoImporte);
}

double calcularMaximoImporteEditableCobro({
  required double totalFactura,
  required Iterable<Cobro> cobrosActuales,
  required String cobroId,
}) {
  final otrosCobros = cobrosActuales
      .where((cobro) => cobro.id != cobroId)
      .fold<double>(0, (total, cobro) => total + cobro.importeNeto);

  return redondearMoneda(totalFactura - otrosCobros);
}

EstadoEconomicoFactura calcularEstadoEconomicoFactura({
  required double totalFactura,
  required double totalCobrado,
}) {
  final cobrado = redondearMoneda(totalCobrado);
  final total = redondearMoneda(totalFactura);
  if (cobrado <= 0) {
    return EstadoEconomicoFactura.pendiente;
  }

  if (cobrado < total) {
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
    this.tieneSaldoPendiente = false,
    this.esPendienteDeCobro = false,
    this.esParcialmenteCobrada = false,
    this.estaVencida = false,
    this.venceEnProximos7Dias = false,
  });

  final double totalFactura;
  final double totalCobrado;
  final double pendiente;
  final EstadoEconomicoFactura estado;
  final bool tieneSaldoPendiente;
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
  final pendiente = redondearMoneda(
    totalFactura - totalCobrado,
  ).clamp(0, double.infinity).toDouble();
  final estadoEconomico = calcularEstadoEconomicoFactura(
    totalFactura: totalFactura,
    totalCobrado: totalCobrado,
  );
  final esFacturaEfectiva = estadoFacturaEsEfectiva(estadoFactura);
  final tienePendiente = pendiente > 0;
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
    tieneSaldoPendiente: esFacturaEfectiva && tienePendiente,
    esPendienteDeCobro:
        esFacturaEfectiva &&
        estadoEconomico == EstadoEconomicoFactura.pendiente &&
        tienePendiente,
    esParcialmenteCobrada:
        esFacturaEfectiva &&
        estadoEconomico == EstadoEconomicoFactura.parcialmenteCobrada &&
        tienePendiente,
    estaVencida:
        esFacturaEfectiva && tienePendiente && vencimiento.isBefore(hoy),
    venceEnProximos7Dias:
        esFacturaEfectiva &&
        tienePendiente &&
        !vencimiento.isBefore(hoy) &&
        !vencimiento.isAfter(limiteProximos7Dias),
  );
}

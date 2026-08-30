import '../../facturas/domain/redondeo_monetario.dart';
import '../../facturas/domain/factura.dart';

bool facturasTienenMismaIdentidadFiscal(Factura origen, Factura destino) {
  if (origen.clienteId != destino.clienteId) return false;
  final nifOrigen = _normalizarIdentificadorFiscal(origen.clienteNifHistorico);
  final nifDestino = _normalizarIdentificadorFiscal(
    destino.clienteNifHistorico,
  );
  return nifOrigen.isNotEmpty && nifOrigen == nifDestino;
}

String _normalizarIdentificadorFiscal(String value) =>
    value.trim().toUpperCase().replaceAll(RegExp('[^A-Z0-9]'), '');

enum TipoMovimientoCreditoCliente {
  devolucion,
  compensacion,
  reversionDevolucion,
  reversionCompensacion,
}

enum EstadoEconomicoFamilia {
  pendiente,
  parcialmenteLiquidada,
  liquidada,
  saldoFavorPendiente,
  saldoFavorParcialmenteDispuesto,
  saldoFavorLiquidado,
}

class MovimientoCreditoCliente {
  const MovimientoCreditoCliente({
    required this.id,
    required this.clienteId,
    required this.facturaRaizOrigenId,
    required this.tipo,
    required this.importe,
    required this.fecha,
    required this.motivo,
    required this.referencia,
    required this.observaciones,
    this.movimientoOrigenId,
    this.facturaRaizDestinoId,
    this.metodo,
  });
  final String id;
  final String clienteId;
  final String facturaRaizOrigenId;
  final TipoMovimientoCreditoCliente tipo;
  final double importe;
  final DateTime fecha;
  final String? movimientoOrigenId;
  final String? facturaRaizDestinoId;
  final String? metodo;
  final String referencia;
  final String motivo;
  final String observaciones;
}

class CreditoClienteFamilia {
  const CreditoClienteFamilia({
    required this.clienteId,
    required this.facturaRaizId,
    required this.netoDocumental,
    required this.cobrosNetos,
    required this.compensacionesRecibidas,
    required this.totalLiquidado,
    required this.creditoGenerado,
    required this.devolucionesNetas,
    required this.compensacionesEmitidas,
    required this.creditoDispuesto,
    required this.creditoDisponible,
    required this.pendiente,
    required this.estado,
  });
  final String clienteId;
  final String facturaRaizId;
  final double netoDocumental;
  final double cobrosNetos;
  final double compensacionesRecibidas;
  final double totalLiquidado;
  final double creditoGenerado;
  final double devolucionesNetas;
  final double compensacionesEmitidas;
  final double creditoDispuesto;
  final double creditoDisponible;
  final double pendiente;
  final EstadoEconomicoFamilia estado;

  static EstadoEconomicoFamilia resolver({
    required int liquidado,
    required int pendiente,
    required int generado,
    required int dispuesto,
  }) {
    if (generado > 0) {
      if (dispuesto == 0) return EstadoEconomicoFamilia.saldoFavorPendiente;
      if (dispuesto < generado) {
        return EstadoEconomicoFamilia.saldoFavorParcialmenteDispuesto;
      }
      return EstadoEconomicoFamilia.saldoFavorLiquidado;
    }
    if (pendiente == 0) return EstadoEconomicoFamilia.liquidada;
    if (liquidado > 0) return EstadoEconomicoFamilia.parcialmenteLiquidada;
    return EstadoEconomicoFamilia.pendiente;
  }
}

class DestinoCompensacion {
  const DestinoCompensacion({
    required this.facturaRaizId,
    required this.codigo,
    required this.pendiente,
  });
  final String facturaRaizId;
  final String codigo;
  final double pendiente;
}

double creditoMoneda(int centimos) => centimosAMoneda(centimos);

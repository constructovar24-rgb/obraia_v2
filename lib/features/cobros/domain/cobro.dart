enum TipoMovimientoCobro { cobro, reversion }

TipoMovimientoCobro tipoMovimientoCobroFromString(String value) {
  return value == TipoMovimientoCobro.reversion.name
      ? TipoMovimientoCobro.reversion
      : TipoMovimientoCobro.cobro;
}

class Cobro {
  final String id;
  final String facturaId;
  final DateTime fecha;
  final double importe;
  final String metodoPago;
  final String referencia;
  final String observaciones;
  final TipoMovimientoCobro tipoMovimiento;
  final String? cobroOrigenId;
  final String motivo;

  const Cobro({
    required this.id,
    required this.facturaId,
    required this.fecha,
    required this.importe,
    required this.metodoPago,
    required this.referencia,
    required this.observaciones,
    this.tipoMovimiento = TipoMovimientoCobro.cobro,
    this.cobroOrigenId,
    this.motivo = '',
  });

  bool get esReversion => tipoMovimiento == TipoMovimientoCobro.reversion;

  double get importeNeto => esReversion ? -importe : importe;
}

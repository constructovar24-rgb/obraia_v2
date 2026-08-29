import 'factura.dart';

class AjusteRectificativa {
  const AjusteRectificativa({
    required this.lineaRectificadaId,
    required this.baseDiferencia,
    this.cantidadDiferencia,
  });

  final String lineaRectificadaId;
  final double baseDiferencia;
  final double? cantidadDiferencia;
}

class SaldoRectificacion {
  const SaldoRectificacion({
    required this.netoDocumental,
    required this.cobradoOriginal,
    required this.saldoAFavor,
  });

  final double netoDocumental;
  final double cobradoOriginal;
  final double saldoAFavor;
}

class RectificativaException implements Exception {
  const RectificativaException(this.mensaje);
  final String mensaje;

  @override
  String toString() => mensaje;
}

bool facturaPuedeOriginarRectificativa(Factura factura) =>
    factura.estado.name == 'emitida' ||
    factura.estado.name == 'vencida' ||
    factura.estado.name == 'cobrada';

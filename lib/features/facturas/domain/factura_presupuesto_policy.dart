import 'package:obraia_v2/features/cobros/domain/cobro.dart' as cobro_domain;
import 'package:obraia_v2/features/facturas/domain/estado_factura.dart';
import 'package:obraia_v2/features/facturas/domain/factura.dart'
    as factura_domain;

enum BloqueoConversionPresupuesto {
  presupuestoNoAceptado,
  facturaNoAnuladaExistente,
  facturaAnuladaConCobros,
}

bool estadoPresupuestoEsAceptado(String estado) {
  return estado.trim().toLowerCase() == 'aceptado';
}

bool facturaBloqueaConversion(factura_domain.Factura factura) {
  return factura.estado != EstadoFactura.anulada;
}

Iterable<factura_domain.Factura> facturasVinculadasAPresupuesto(
  Iterable<factura_domain.Factura> facturas,
  String presupuestoId,
) {
  return facturas.where(
    (factura) => factura.presupuestoOrigenId?.trim() == presupuestoId,
  );
}

BloqueoConversionPresupuesto? obtenerBloqueoConversionPresupuesto({
  required String estadoPresupuesto,
  required String presupuestoId,
  required Iterable<factura_domain.Factura> facturas,
  required Iterable<cobro_domain.Cobro> cobros,
}) {
  if (!estadoPresupuestoEsAceptado(estadoPresupuesto)) {
    return BloqueoConversionPresupuesto.presupuestoNoAceptado;
  }

  final vinculadas = facturasVinculadasAPresupuesto(
    facturas,
    presupuestoId,
  ).toList(growable: false);
  if (vinculadas.any(facturaBloqueaConversion)) {
    return BloqueoConversionPresupuesto.facturaNoAnuladaExistente;
  }

  final idsAnuladas = vinculadas
      .where((factura) => factura.estado == EstadoFactura.anulada)
      .map((factura) => factura.id)
      .toSet();
  if (cobros.any((cobro) => idsAnuladas.contains(cobro.facturaId))) {
    return BloqueoConversionPresupuesto.facturaAnuladaConCobros;
  }

  return null;
}

bool presupuestoEstaFacturadoActualmente({
  required String presupuestoId,
  required Iterable<factura_domain.Factura> facturas,
}) {
  return facturasVinculadasAPresupuesto(
    facturas,
    presupuestoId,
  ).any(facturaBloqueaConversion);
}

bool presupuestoEstaPendienteDeFacturar({
  required String estadoPresupuesto,
  required String presupuestoId,
  required Iterable<factura_domain.Factura> facturas,
  required Iterable<cobro_domain.Cobro> cobros,
}) {
  return obtenerBloqueoConversionPresupuesto(
        estadoPresupuesto: estadoPresupuesto,
        presupuestoId: presupuestoId,
        facturas: facturas,
        cobros: cobros,
      ) ==
      null;
}

import 'factura_linea.dart';
import 'redondeo_monetario.dart';

const double facturaIvaPorcentajeInicial = 21.0;

class FacturaTotales {
  const FacturaTotales({required this.subtotal, required this.iva});
  final double subtotal;
  final double iva;
  double get total => redondearMoneda(subtotal + iva);
}

FacturaTotales calcularTotalesFactura(
  Iterable<FacturaLinea> lineas, {
  required double ivaPorcentaje,
}) {
  final subtotal = redondearMoneda(
    lineas.fold<double>(0, (total, linea) => total + linea.importe),
  );
  final iva = redondearMoneda(subtotal * ivaPorcentaje / 100);
  return FacturaTotales(subtotal: subtotal, iva: iva);
}

bool totalFacturaCubreCobros({
  required double totalFactura,
  required double totalCobrado,
}) => redondearMoneda(totalFactura) >= redondearMoneda(totalCobrado);

List<FacturaLinea> sustituirLineaPorId({
  required Iterable<FacturaLinea> lineas,
  required FacturaLinea nuevaLinea,
}) {
  var encontrada = false;
  final resultado = lineas.map((linea) {
    if (linea.id != nuevaLinea.id) return linea;
    encontrada = true;
    return nuevaLinea;
  }).toList();
  if (!encontrada) {
    throw StateError('Linea de factura no encontrada: ${nuevaLinea.id}');
  }
  return resultado;
}

List<FacturaLinea> eliminarLineaPorId({
  required Iterable<FacturaLinea> lineas,
  required String lineaId,
}) {
  final lista = lineas.toList();
  final resultado = lista.where((linea) => linea.id != lineaId).toList();
  if (resultado.length == lista.length) {
    throw StateError('Linea de factura no encontrada: $lineaId');
  }
  return resultado;
}

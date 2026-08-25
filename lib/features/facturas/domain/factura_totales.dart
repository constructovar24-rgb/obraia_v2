import '../../cobros/domain/factura_estado_economico.dart';
import 'factura_linea.dart';

const double facturaIvaPorcentaje = 21.0;

class FacturaTotales {
  const FacturaTotales({required this.subtotal, required this.iva});
  final double subtotal;
  final double iva;
  double get total => subtotal + iva;
}

FacturaTotales calcularTotalesFactura(Iterable<FacturaLinea> lineas) {
  final subtotal = lineas.fold<double>(
    0,
    (total, linea) => total + linea.importe,
  );
  final iva = subtotal * facturaIvaPorcentaje / 100;
  return FacturaTotales(subtotal: subtotal, iva: iva);
}

bool totalFacturaCubreCobros({
  required double totalFactura,
  required double totalCobrado,
}) => totalFactura + facturaEstadoEconomicoEpsilon >= totalCobrado;

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

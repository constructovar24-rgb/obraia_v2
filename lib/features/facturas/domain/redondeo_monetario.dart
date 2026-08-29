/// Política monetaria única: cada importe de línea, el subtotal, el IVA y el
/// total se redondean a dos decimales; los medios céntimos se elevan al
/// céntimo siguiente. El margen evita que la representación binaria convierta
/// un valor decimal exacto como 10,005 en 10,004999….
double redondearMoneda(double valor) {
  const margenDecimal = 0.000000001;
  final escalado = valor * 100;
  final ajustado = escalado >= 0
      ? escalado + margenDecimal
      : escalado - margenDecimal;
  return ajustado.roundToDouble() / 100;
}

double calcularImporteLineaFactura({
  required double cantidad,
  required double precioUnitario,
  required double descuento,
}) => redondearMoneda(cantidad * precioUnitario * ((100 - descuento) / 100));

import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/features/facturas/domain/facturacion_parcial.dart';

void main() {
  const resumenConPendiente = ResumenFacturacionPresupuesto(
    basePresupuestadaCentimos: 1000000,
    facturadoCentimos: 0,
    reservadoCentimos: 0,
    pendienteCentimos: 1000000,
    tieneConsumoLegacySinDetalle: false,
  );

  test('un borrador informa aceptación pendiente aunque tenga saldo', () {
    expect(
      obtenerBloqueoCrearFacturaParcial(
        estadoPresupuesto: 'Borrador',
        resumen: resumenConPendiente,
      ),
      BloqueoCrearFacturaParcial.presupuestoNoAceptado,
    );
  });

  test('un presupuesto aceptado con saldo permite facturar', () {
    expect(
      obtenerBloqueoCrearFacturaParcial(
        estadoPresupuesto: 'Aceptado',
        resumen: resumenConPendiente,
      ),
      isNull,
    );
  });
}

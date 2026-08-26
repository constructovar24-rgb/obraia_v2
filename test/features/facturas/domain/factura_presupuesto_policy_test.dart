import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/features/cobros/domain/cobro.dart';
import 'package:obraia_v2/features/facturas/domain/estado_factura.dart';
import 'package:obraia_v2/features/facturas/domain/factura.dart';
import 'package:obraia_v2/features/facturas/domain/factura_presupuesto_policy.dart';

void main() {
  group('política presupuesto-factura', () {
    test('solo un presupuesto aceptado puede quedar disponible', () {
      for (final estado in ['borrador', 'presentado', 'rechazado', 'otro']) {
        expect(
          obtenerBloqueoConversionPresupuesto(
            estadoPresupuesto: estado,
            presupuestoId: 'p1',
            facturas: const [],
            cobros: const [],
          ),
          BloqueoConversionPresupuesto.presupuestoNoAceptado,
        );
      }
      expect(
        obtenerBloqueoConversionPresupuesto(
          estadoPresupuesto: ' ACEPTADO ',
          presupuestoId: 'p1',
          facturas: const [],
          cobros: const [],
        ),
        isNull,
      );
    });

    for (final estado in [
      EstadoFactura.borrador,
      EstadoFactura.emitida,
      EstadoFactura.vencida,
      EstadoFactura.cobrada,
    ]) {
      test('${estado.name} bloquea una nueva conversión', () {
        expect(
          obtenerBloqueoConversionPresupuesto(
            estadoPresupuesto: 'aceptado',
            presupuestoId: 'p1',
            facturas: [_factura('f1', estado)],
            cobros: const [],
          ),
          BloqueoConversionPresupuesto.facturaNoAnuladaExistente,
        );
        expect(
          presupuestoEstaFacturadoActualmente(
            presupuestoId: 'p1',
            facturas: [_factura('f1', estado)],
          ),
          isTrue,
        );
      });
    }

    test('una anulada saneada permite volver a facturar', () {
      final facturas = [_factura('f1', EstadoFactura.anulada)];
      expect(
        obtenerBloqueoConversionPresupuesto(
          estadoPresupuesto: 'aceptado',
          presupuestoId: 'p1',
          facturas: facturas,
          cobros: const [],
        ),
        isNull,
      );
      expect(
        presupuestoEstaFacturadoActualmente(
          presupuestoId: 'p1',
          facturas: facturas,
        ),
        isFalse,
      );
      expect(
        presupuestoEstaPendienteDeFacturar(
          estadoPresupuesto: 'aceptado',
          presupuestoId: 'p1',
          facturas: facturas,
          cobros: const [],
        ),
        isTrue,
      );
    });

    test('una anulada con cobros legacy exige saneamiento', () {
      expect(
        obtenerBloqueoConversionPresupuesto(
          estadoPresupuesto: 'aceptado',
          presupuestoId: 'p1',
          facturas: [_factura('f1', EstadoFactura.anulada)],
          cobros: [_cobro('c1', 'f1')],
        ),
        BloqueoConversionPresupuesto.facturaAnuladaConCobros,
      );
      expect(
        presupuestoEstaPendienteDeFacturar(
          estadoPresupuesto: 'aceptado',
          presupuestoId: 'p1',
          facturas: [_factura('f1', EstadoFactura.anulada)],
          cobros: [_cobro('c1', 'f1')],
        ),
        isFalse,
      );
    });

    test('múltiples anuladas saneadas permiten el siguiente ciclo', () {
      expect(
        obtenerBloqueoConversionPresupuesto(
          estadoPresupuesto: 'aceptado',
          presupuestoId: 'p1',
          facturas: [
            _factura('f1', EstadoFactura.anulada),
            _factura('f2', EstadoFactura.anulada),
          ],
          cobros: const [],
        ),
        isNull,
      );
    });

    test('el borrado del único borrador vuelve a liberar el presupuesto', () {
      final conBorrador = [
        _factura('f1', EstadoFactura.anulada),
        _factura('f2', EstadoFactura.borrador),
      ];
      expect(
        presupuestoEstaFacturadoActualmente(
          presupuestoId: 'p1',
          facturas: conBorrador,
        ),
        isTrue,
      );
      expect(
        obtenerBloqueoConversionPresupuesto(
          estadoPresupuesto: 'aceptado',
          presupuestoId: 'p1',
          facturas: [conBorrador.first],
          cobros: const [],
        ),
        isNull,
      );
    });

    test('facturas y cobros de otro presupuesto no interfieren', () {
      expect(
        obtenerBloqueoConversionPresupuesto(
          estadoPresupuesto: 'aceptado',
          presupuestoId: 'p1',
          facturas: [
            _factura('f2', EstadoFactura.emitida, presupuestoId: 'p2'),
          ],
          cobros: [_cobro('c2', 'f2')],
        ),
        isNull,
      );
    });
  });
}

Factura _factura(
  String id,
  EstadoFactura estado, {
  String presupuestoId = 'p1',
}) {
  return Factura(
    id: id,
    codigo: id,
    clienteId: 'c1',
    clienteNombre: 'Cliente',
    fecha: DateTime(2026, 1, 1),
    fechaVencimiento: DateTime(2026, 2, 1),
    estado: estado,
    subtotal: 100,
    iva: 21,
    total: 121,
    observaciones: '',
    presupuestoOrigenId: presupuestoId,
  );
}

Cobro _cobro(String id, String facturaId) {
  return Cobro(
    id: id,
    facturaId: facturaId,
    fecha: DateTime(2026, 1, 15),
    importe: 10,
    metodoPago: 'Transferencia',
    referencia: '',
    observaciones: '',
  );
}

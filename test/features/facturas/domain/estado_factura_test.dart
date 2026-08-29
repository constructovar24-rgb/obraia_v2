import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/features/facturas/domain/estado_factura.dart';

void main() {
  group('estadoFacturaEsEfectiva', () {
    test('incluye emitidas, cobradas y vencidas', () {
      expect(estadoFacturaEsEfectiva(EstadoFactura.emitida), isTrue);
      expect(estadoFacturaEsEfectiva(EstadoFactura.cobrada), isTrue);
      expect(estadoFacturaEsEfectiva(EstadoFactura.vencida), isTrue);
    });

    test('excluye borradores y anuladas', () {
      expect(estadoFacturaEsEfectiva(EstadoFactura.borrador), isFalse);
      expect(estadoFacturaEsEfectiva(EstadoFactura.anulada), isFalse);
    });

    test('una cobrada es efectiva pero no admite nuevos cobros', () {
      expect(estadoFacturaEsEfectiva(EstadoFactura.cobrada), isTrue);
      expect(estadoFacturaAdmiteNuevosCobros(EstadoFactura.cobrada), isFalse);
    });
  });

  group('estadoFacturaAdmiteNuevosCobros', () {
    test('admite facturas emitidas y vencidas', () {
      expect(estadoFacturaAdmiteNuevosCobros(EstadoFactura.emitida), isTrue);
      expect(estadoFacturaAdmiteNuevosCobros(EstadoFactura.vencida), isTrue);
    });

    test('rechaza facturas borrador, cobradas y anuladas', () {
      expect(estadoFacturaAdmiteNuevosCobros(EstadoFactura.borrador), isFalse);
      expect(estadoFacturaAdmiteNuevosCobros(EstadoFactura.cobrada), isFalse);
      expect(estadoFacturaAdmiteNuevosCobros(EstadoFactura.anulada), isFalse);
    });
  });
  group('estadoFacturaAdmiteModificarCobros', () {
    test('permite modificar cobros de emitidas, vencidas y cobradas', () {
      expect(estadoFacturaAdmiteModificarCobros(EstadoFactura.emitida), isTrue);
      expect(estadoFacturaAdmiteModificarCobros(EstadoFactura.vencida), isTrue);
      expect(estadoFacturaAdmiteModificarCobros(EstadoFactura.cobrada), isTrue);
    });

    test('protege borradores y anuladas', () {
      expect(
        estadoFacturaAdmiteModificarCobros(EstadoFactura.borrador),
        isFalse,
      );
      expect(
        estadoFacturaAdmiteModificarCobros(EstadoFactura.anulada),
        isFalse,
      );
    });
  });

  group('resolverEstadoDocumentalFactura', () {
    final hoy = DateTime(2026, 8, 25);

    EstadoFactura resolver({
      required EstadoFactura estado,
      required double saldo,
      required DateTime vencimiento,
    }) {
      return resolverEstadoDocumentalFactura(
        estadoActual: estado,
        totalFactura: 100,
        totalCobrado: 100 - saldo,
        fechaVencimiento: vencimiento,
        fechaReferencia: hoy,
      );
    }

    test(
      'mantiene borrador y anulada con prioridad e impide reabrir anulada',
      () {
        expect(
          resolver(
            estado: EstadoFactura.borrador,
            saldo: 0,
            vencimiento: DateTime(2026),
          ),
          EstadoFactura.borrador,
        );
        expect(
          resolver(
            estado: EstadoFactura.anulada,
            saldo: 50,
            vencimiento: DateTime(2026),
          ),
          EstadoFactura.anulada,
        );
      },
    );

    test('saldo dentro de epsilon queda cobrada', () {
      expect(
        resolver(estado: EstadoFactura.emitida, saldo: 0.004, vencimiento: hoy),
        EstadoFactura.cobrada,
      );
    });

    test('saldo reabierto vuelve a vencida o emitida según fecha', () {
      expect(
        resolver(
          estado: EstadoFactura.cobrada,
          saldo: 10,
          vencimiento: DateTime(2026, 8, 24),
        ),
        EstadoFactura.vencida,
      );
      expect(
        resolver(estado: EstadoFactura.cobrada, saldo: 10, vencimiento: hoy),
        EstadoFactura.emitida,
      );
      expect(
        resolver(
          estado: EstadoFactura.cobrada,
          saldo: 10,
          vencimiento: DateTime(2026, 8, 26),
        ),
        EstadoFactura.emitida,
      );
    });

    test('emitida vencida con saldo pasa a vencida automáticamente', () {
      expect(
        resolver(
          estado: EstadoFactura.emitida,
          saldo: 10,
          vencimiento: DateTime(2026, 8, 24),
        ),
        EstadoFactura.vencida,
      );
    });
  });
  group('validarEmisionFactura', () {
    String? validar({
      EstadoFactura estado = EstadoFactura.borrador,
      bool clienteExiste = true,
      List<DatosLineaEmision> lineas = const [
        DatosLineaEmision(cantidad: 1, precioUnitario: 100),
      ],
      double total = 100,
      DateTime? fecha,
      DateTime? vencimiento,
    }) => validarEmisionFactura(
      estadoActual: estado,
      clienteExiste: clienteExiste,
      lineas: lineas,
      total: total,
      fechaFactura: fecha ?? DateTime(2026, 8, 25),
      fechaVencimiento: vencimiento ?? DateTime(2026, 9, 25),
    );

    test('acepta un borrador válido', () => expect(validar(), isNull));
    test(
      'rechaza factura que no es borrador',
      () => expect(validar(estado: EstadoFactura.emitida), isNotNull),
    );
    test(
      'rechaza cliente inexistente',
      () => expect(validar(clienteExiste: false), isNotNull),
    );
    test(
      'rechaza factura sin líneas',
      () => expect(validar(lineas: const []), isNotNull),
    );
    test('rechaza total cero', () => expect(validar(total: 0), isNotNull));
    test(
      'rechaza vencimiento anterior',
      () => expect(validar(vencimiento: DateTime(2026, 8, 24)), isNotNull),
    );
    test(
      'rechaza cantidad no positiva',
      () => expect(
        validar(
          lineas: const [DatosLineaEmision(cantidad: 0, precioUnitario: 1)],
        ),
        isNotNull,
      ),
    );
    test(
      'rechaza precio negativo',
      () => expect(
        validar(
          lineas: const [DatosLineaEmision(cantidad: 1, precioUnitario: -1)],
        ),
        isNotNull,
      ),
    );
  });
}

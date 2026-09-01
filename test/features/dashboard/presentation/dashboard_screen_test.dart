import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/features/dashboard/domain/dashboard_resumen.dart';
import 'package:obraia_v2/features/dashboard/presentation/screens/dashboard_screen.dart';

void main() {
  testWidgets(
    'el dashboard embebido muestra datos reales sin cabecera duplicada',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      const resumen = DashboardResumen(
        numeroExpedientes: 3,
        numeroPresupuestos: 2,
        presupuestosPendientesFacturar: 0,
        presupuestosFacturados: 2,
        totalPresupuestado: 10000,
        numeroFacturas: 2,
        facturasPendientesCobro: 0,
        facturasParcialmenteCobradas: 0,
        facturasCobradas: 2,
        totalFacturado: 12100,
        totalCobrado: 12100,
        totalCobradoEsteMes: 12100,
        totalFacturadoEsteMes: 12100,
        saldoPendienteTotal: 0,
        facturasVencidasConteo: 0,
        facturasVencidasImporte: 0,
        facturasVencenProximos7Dias: 0,
        coberturaCobroPorcentaje: 100,
        conversionPresupuestosFacturasPorcentaje: 100,
        presupuestosBacklogComercialConteo: 0,
        presupuestosBacklogComercialImporte: 0,
        expedientesSinActividadConteo: 0,
      );
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: DashboardScreen(
              embedded: true,
              summaryStream: Stream.value(resumen),
            ),
          ),
        ),
      );
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 20));
      }

      expect(find.textContaining('estado actual de ObraIA'), findsOneWidget);
      expect(
        find.text('No hay alertas prioritarias ahora mismo'),
        findsOneWidget,
      );
      expect(find.widgetWithText(AppBar, 'Dashboard'), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 1));
      await tester.pump(const Duration(milliseconds: 1));
    },
  );
}

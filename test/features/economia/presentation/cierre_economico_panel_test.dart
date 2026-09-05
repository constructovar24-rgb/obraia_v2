import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/features/economia/domain/cierre_economico.dart';
import 'package:obraia_v2/features/economia/domain/prevision_economica.dart';
import 'package:obraia_v2/features/economia/presentation/providers/cierre_economico_providers.dart';
import 'package:obraia_v2/features/economia/presentation/widgets/cierre_economico_panel.dart';

void main() {
  testWidgets('muestra estado cerrado, reapertura e historial', (tester) async {
    final cierre = CierreEconomicoSnapshot(
      id: 'cierre',
      numero: 1,
      fechaCierre: DateTime(2026, 9, 5),
      resumen: _forecast,
      conAdvertencias: true,
      resumenPrecheck: 'Forecast incompleto',
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          estadoCierreEconomicoProvider.overrideWith(
            (ref, id) => Stream.value(
              EstadoCierreEconomico(
                estado: EstadoEconomicoObra.cerrado,
                numeroCierres: 1,
                ultimoCierre: cierre,
              ),
            ),
          ),
          precheckCierreEconomicoProvider.overrideWith(
            (ref, id) async => const PrecheckCierreEconomico([]),
          ),
          alertasEconomicasProvider.overrideWith((ref, id) async => const []),
          historialCierresProvider.overrideWith((ref, id) async => [cierre]),
          historialReaperturasProvider.overrideWith(
            (ref, id) async => const [],
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(body: CierreEconomicoPanel(expedienteId: 'obra')),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Cerrado'), findsOneWidget);
    expect(find.textContaining('Cierre #1'), findsOneWidget);
    expect(find.byKey(const ValueKey('reabrir-economia')), findsOneWidget);
    expect(tester.takeException(), null);
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 1));
  });
}

const _forecast = ResumenForecastObra(
  costeRealCentimos: 1000,
  comprometidoPendienteCentimos: 0,
  estimacionAdicionalCentimos: 0,
  subtotalConocidoCentimos: 1000,
  cobertura: CoberturaForecast.parcial,
  ventaPlanificadaCentimos: null,
  costePlanificadoCentimos: null,
  beneficioPlanificadoCentimos: null,
  margenPlanificadoPorcentaje: null,
  costeFinalEstimadoCentimos: null,
  beneficioFinalEstimadoCentimos: null,
  margenFinalEstimadoPorcentaje: null,
  porCategoriaCentimos: {},
  tieneCompromisosSobreconsumidos: false,
  desgloseCategorias: [],
);

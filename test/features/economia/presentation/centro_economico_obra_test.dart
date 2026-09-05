import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/database/database_provider.dart';
import 'package:obraia_v2/features/economia/domain/prevision_economica.dart';
import 'package:obraia_v2/features/economia/presentation/providers/prevision_economica_providers.dart';
import 'package:obraia_v2/features/economia/presentation/widgets/centro_economico_obra.dart';
import 'package:obraia_v2/features/mano_obra/domain/mano_obra.dart';
import 'package:obraia_v2/features/mano_obra/presentation/providers/mano_obra_providers.dart';

void main() {
  late AppDatabase database;
  setUp(() => database = AppDatabase.forTesting(NativeDatabase.memory()));
  tearDown(() => database.close());

  Widget app(ResumenForecastObra forecast) => ProviderScope(
    overrides: [
      databaseProvider.overrideWithValue(database),
      resumenForecastProvider.overrideWith((ref, id) async => forecast),
      resumenManoObraProvider.overrideWith((ref, id) => Stream.value(_labor)),
      compromisosEconomicosProvider.overrideWith((ref, id) async => const []),
      estimacionesCosteRestanteProvider.overrideWith(
        (ref, id) async => const [],
      ),
    ],
    child: const MaterialApp(
      home: DefaultTabController(
        length: 11,
        child: Scaffold(body: CentroEconomicoObra(expedienteId: 'obra')),
      ),
    ),
  );

  testWidgets('muestra pérdida, cobertura, categoría y navegación', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1180, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(app(_forecast()));
    await tester.pumpAndSettle();
    expect(find.text('Situación económica'), findsOneWidget);
    expect(find.text('Previsto al inicio'), findsOneWidget);
    expect(find.text('Previsión final'), findsOneWidget);
    expect(find.text('Materiales'), findsOneWidget);
    expect(find.text('Sin asignar'), findsOneWidget);
    expect(
      find.textContaining('Beneficio final estimado negativo.'),
      findsOneWidget,
    );
    expect(find.textContaining('Forecast incompleto.'), findsOneWidget);
    expect(find.text('Abrir mano de obra'), findsOneWidget);
    expect(tester.takeException(), null);
  });

  testWidgets('representa desconocido sin convertirlo en cero', (tester) async {
    await tester.pumpWidget(app(_forecast(unknown: true)));
    await tester.pumpAndSettle();
    expect(find.text('No disponible'), findsWidgets);
    expect(find.text('0,00 €'), findsNothing);
    expect(tester.takeException(), null);
  });
}

ResumenForecastObra _forecast({bool unknown = false}) => ResumenForecastObra(
  costeRealCentimos: 7000,
  comprometidoPendienteCentimos: 2000,
  estimacionAdicionalCentimos: 2500,
  subtotalConocidoCentimos: 11500,
  cobertura: CoberturaForecast.parcial,
  ventaPlanificadaCentimos: unknown ? null : 10000,
  costePlanificadoCentimos: unknown ? null : 8000,
  beneficioPlanificadoCentimos: unknown ? null : 2000,
  margenPlanificadoPorcentaje: unknown ? null : 20,
  costeFinalEstimadoCentimos: unknown ? null : 11500,
  beneficioFinalEstimadoCentimos: unknown ? null : -1500,
  margenFinalEstimadoPorcentaje: unknown ? null : -15,
  porCategoriaCentimos: const {null: 500, 'materiales': 11000},
  tieneCompromisosSobreconsumidos: false,
  desgloseCategorias: const [
    DesgloseForecastCategoria(
      categoriaId: 'materiales',
      nombre: 'Materiales',
      previstoCentimos: 8000,
      realCentimos: 6500,
      comprometidoCentimos: 2000,
      restanteCentimos: 2500,
    ),
    DesgloseForecastCategoria(
      categoriaId: null,
      nombre: 'Sin asignar',
      previstoCentimos: null,
      realCentimos: 500,
      comprometidoCentimos: 0,
      restanteCentimos: 0,
    ),
  ],
);

const _labor = ResumenManoObra(
  horasTotalesDiezMilesimas: 80000,
  horasValoradasDiezMilesimas: 60000,
  horasSinValorarDiezMilesimas: 20000,
  costeRealCentimos: 3000,
  costeSinPartidaCentimos: 0,
  costePorPersonaCentimos: {},
  horasPorPersonaDiezMilesimas: {},
  costePorPartidaCentimos: {},
  cobertura: CoberturaManoObra.parcial,
);

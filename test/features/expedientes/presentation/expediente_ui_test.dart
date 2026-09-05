import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/database/database_provider.dart';
import 'package:obraia_v2/features/expedientes/presentation/screens/expedientes_screen.dart';
import 'package:obraia_v2/features/expedientes/presentation/providers/expediente_workspace_providers.dart';
import 'package:obraia_v2/features/expedientes/presentation/widgets/expediente_resumen_tab.dart';
import 'package:obraia_v2/features/expedientes/presentation/widgets/expediente_workspace_tabs.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() => database.close());

  Widget app(Widget child) => ProviderScope(
    overrides: [databaseProvider.overrideWithValue(database)],
    child: MaterialApp(home: child),
  );

  testWidgets('el listado embebido usa el ancho disponible y su estado vacío', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1100, 760);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(app(const ExpedientesScreen(embedded: true)));
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 20));
    }

    expect(find.text('Todavía no hay expedientes'), findsOneWidget);
    expect(find.text('Nuevo expediente'), findsWidgets);
    expect(find.widgetWithText(AppBar, 'Expedientes'), findsNothing);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 1));
    await tester.pump(const Duration(milliseconds: 1));
  });

  testWidgets('la ficha de obra expone su navegación operativa completa', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: DefaultTabController(
          length: ExpedienteWorkspaceTabs.length,
          child: Scaffold(body: ExpedienteWorkspaceTabs()),
        ),
      ),
    );

    for (final label in ExpedienteWorkspaceTabs.labels) {
      expect(find.text(label), findsOneWidget);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'la ficha consolida el resumen real y acceso económico compacto',
    (tester) async {
      tester.view.physicalSize = const Size(1200, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(database),
            expedientePresupuestoResumenProvider.overrideWith(
              (ref, id) =>
                  Stream.value(const ExpedientePresupuestoResumen(2, 1000)),
            ),
            expedienteFacturaResumenProvider.overrideWith(
              (ref, id) => Stream.value(
                const ExpedienteFacturaResumen(1, 600, 250, 350),
              ),
            ),
            expedienteCompraResumenProvider.overrideWith(
              (ref, id) => Stream.value(const ExpedienteCompraResumen(0, 0)),
            ),
          ],
          child: MaterialApp(
            home: DefaultTabController(
              length: ExpedienteWorkspaceTabs.length,
              child: Scaffold(
                body: ExpedienteResumenTab(expedienteId: 'exp-1'),
              ),
            ),
          ),
        ),
      );
      for (var i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 30));
      }
      expect(find.text('Resumen administrativo'), findsOneWidget);
      expect(find.text('QUÉ TOCA AHORA'), findsOneWidget);
      expect(find.text('Actividad reciente'), findsOneWidget);
      expect(find.text('Aún no hay actividad registrada.'), findsOneWidget);
      expect(find.text('Compras y suministros'), findsOneWidget);
      expect(find.text('Planificación'), findsWidgets);
      expect(find.text('Registrar diario'), findsOneWidget);
      expect(find.text('Nueva incidencia'), findsOneWidget);
      expect(find.text('Ver economía'), findsOneWidget);
      expect(find.text('Facturado'), findsOneWidget);
      expect(find.text('Cobrado'), findsOneWidget);
      expect(find.text('Compras registradas'), findsOneWidget);
      expect(find.text('1 documentos'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 1));
      await tester.pump(const Duration(milliseconds: 1));
    },
  );
}

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/database/database_provider.dart';
import 'package:obraia_v2/features/expedientes/presentation/screens/expedientes_screen.dart';
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
      const MaterialApp(
        home: DefaultTabController(
          length: 8,
          child: Scaffold(body: ExpedienteWorkspaceTabs()),
        ),
      ),
    );

    for (final label in ExpedienteWorkspaceTabs.labels) {
      expect(find.text(label), findsOneWidget);
    }
    expect(tester.takeException(), isNull);
  });
}

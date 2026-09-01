import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/app/shell/app_shell.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildApp() {
    return MaterialApp(
      home: AppShell(
        pageBuilder: (section) =>
            Center(child: Text('Contenido ${section.label}')),
      ),
    );
  }

  testWidgets('mantiene navegación y cabecera al cambiar de sección', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('side-navigation-expanded')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('app-shell-header')), findsOneWidget);
    expect(find.text('Contenido Inicio'), findsOneWidget);
    expect(find.byKey(const ValueKey('global-search')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('navigation-expedientes')));
    await tester.pumpAndSettle();

    expect(find.text('Contenido Expedientes / Obras'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('side-navigation-expanded')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('app-shell-header')), findsOneWidget);
  });

  testWidgets('compacta la navegación en una ventana reducida', (tester) async {
    tester.view.physicalSize = const Size(700, 720);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('side-navigation-compact')),
      findsOneWidget,
    );
    expect(find.byTooltip('Expedientes / Obras'), findsOneWidget);
    expect(find.byTooltip('Búsqueda global'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/core/environment/app_environment.dart';
import 'package:obraia_v2/core/environment/environment_profile_store.dart';
import 'package:obraia_v2/database/database_provider.dart';
import 'package:obraia_v2/features/environment/presentation/providers/environment_controller.dart';
import 'package:obraia_v2/features/environment/presentation/widgets/environment_controls.dart';
import 'package:obraia_v2/features/environment/presentation/widgets/environment_session.dart';
import 'package:obraia_v2/screens/home_screen.dart';

void main() {
  testWidgets(
    'indicador visible; cancelar no cambia y confirmar solicita el otro entorno',
    (tester) async {
      final root = Directory.systemTemp.createTempSync('obraia-prod1-ui-');
      final controller = RecordingController(root);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            environmentControllerProvider.overrideWith((ref) => controller),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: Column(
                children: [EnvironmentIndicator(), EnvironmentSelector()],
              ),
            ),
          ),
        ),
      );
      expect(find.text('Entorno: Producción'), findsOneWidget);
      expect(find.text('Entorno actual: Producción'), findsOneWidget);
      await tester.tap(find.text('Cambiar entorno'));
      await tester.pumpAndSettle();
      expect(find.text('Cambiar a Desarrollo'), findsOneWidget);
      expect(controller.requested, isNull);
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();
      expect(controller.requested, isNull);
      await tester.tap(find.text('Cambiar entorno'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Confirmar cambio'));
      await tester.pumpAndSettle();
      expect(controller.requested, AppEnvironment.development);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 1));
      await runSessionOperation(tester, controller.close);
      controller.dispose();
      root.deleteSync(recursive: true);
    },
  );

  testWidgets(
    'sesión completa descarta providers y navegación antes de cerrar DB',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final root = Directory.systemTemp.createTempSync('obraia-prod1-session-');
      final controller = EnvironmentController(
        documentsDirectory: root,
        profileStore: EnvironmentProfileStore(root),
        initialEnvironment: AppEnvironment.development,
        detachSession: () async {
          await WidgetsBinding.instance.endOfFrame;
          expect(find.byType(HomeScreen), findsNothing);
        },
      );
      await tester.runAsync(controller.lifecycle.activeDatabase.ensureReady);
      await tester.pumpWidget(EnvironmentSession(controller: controller));
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pump();
      final oldContainer = ProviderScope.containerOf(
        tester.element(find.byType(HomeScreen)),
      );
      final cache = Provider<Object>((ref) => Object());
      final oldCache = oldContainer.read(cache);
      final oldDb = oldContainer.read(databaseProvider);
      await runSessionOperation(
        tester,
        () => controller.changeEnvironment(AppEnvironment.production),
      );
      await tester.pump();
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pump();
      expect(controller.error, isNull);
      expect(find.text('Entorno: Producción'), findsOneWidget);
      final newContainer = ProviderScope.containerOf(
        tester.element(find.byType(HomeScreen)),
      );
      expect(newContainer, isNot(same(oldContainer)));
      expect(newContainer.read(cache), isNot(same(oldCache)));
      expect(newContainer.read(databaseProvider), isNot(same(oldDb)));
      await tester.runAsync(
        () => expectLater(oldDb.ensureReady(), throwsA(anything)),
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      await runSessionOperation(tester, controller.close);
      controller.dispose();
      root.deleteSync(recursive: true);
    },
  );
}

class RecordingController extends EnvironmentController {
  RecordingController(Directory root)
    : super(
        documentsDirectory: root,
        profileStore: EnvironmentProfileStore(root),
        initialEnvironment: AppEnvironment.production,
        detachSession: () async {},
      );
  AppEnvironment? requested;
  @override
  Future<void> changeEnvironment(AppEnvironment target) async {
    requested = target;
  }
}

Future<void> runSessionOperation(
  WidgetTester tester,
  Future<void> Function() action,
) async {
  var done = false;
  Object? failure;
  StackTrace? stack;
  await tester.runAsync(() async {
    action().then(
      (_) {
        done = true;
      },
      onError: (Object error, StackTrace trace) {
        failure = error;
        stack = trace;
        done = true;
      },
    );
  });
  for (var i = 0; i < 400 && !done; i++) {
    await tester.pump(const Duration(milliseconds: 10));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 5)),
    );
  }
  expect(
    done,
    isTrue,
    reason: 'La operación debe finalizar sin conexiones pendientes.',
  );
  if (failure != null) Error.throwWithStackTrace(failure!, stack!);
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/core/environment/app_environment.dart';
import 'package:obraia_v2/features/environment/presentation/providers/environment_controller.dart';
import 'package:obraia_v2/features/fiscal/data/configuracion_fiscal_repository.dart';
import 'package:obraia_v2/features/fiscal/presentation/providers/configuracion_fiscal_providers.dart';
import 'package:obraia_v2/features/fiscal/presentation/screens/configuracion_fiscal_screen.dart';
import 'package:obraia_v2/features/facturas/data/factura_repository.dart';
import '../../../support/factura_fiscal_test_support.dart';
import '../../../support/fiscal_test_support.dart';

class EntornoPrueba extends ChangeNotifier implements EnvironmentController {
  @override
  AppEnvironment get environment => AppEnvironment.production;
  @override
  String? get error => null;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  for (final usada in [false, true]) {
    group(usada ? 'utilizada' : 'sin preparar', () {
      late AppDatabase db;
      late ConfiguracionFiscalRepository fiscal;
      setUp(() async {
        db = AppDatabase.forTesting(
          NativeDatabase.memory(),
          environment: AppEnvironment.production,
        );
        await db.ensureReady();
        fiscal = ConfiguracionFiscalRepository(db);
        if (usada) {
          await prepararFiscalPrueba(db);
          final id = await crearFacturaFiscalPrueba(db);
          await FacturaRepository(db).emitirFactura(id);
        }
      });
      tearDown(() => db.close());
      testWidgets('muestra entorno y estado; controla preparación y bloqueo', (
        tester,
      ) async {
        tester.view.physicalSize = const Size(1100, 1700);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final env = EntornoPrueba();
        addTearDown(env.dispose);
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              configuracionFiscalRepositoryProvider.overrideWithValue(fiscal),
              environmentControllerProvider.overrideWithValue(env),
            ],
            child: const MaterialApp(home: ConfiguracionFiscalScreen()),
          ),
        );
        Future<void> settle() async {
          for (var i = 0; i < 20; i++) {
            await tester.pump(const Duration(milliseconds: 10));
            await tester.runAsync(
              () => Future<void>.delayed(const Duration(milliseconds: 1)),
            );
          }
        }

        await settle();
        expect(find.text('Entorno: Producción'), findsOneWidget);
        if (usada) {
          expect(find.text('En uso · configuración protegida'), findsOneWidget);
          expect(
            tester
                .widget<TextField>(
                  find.byKey(const ValueKey('fiscal-ordinaria-serie')),
                )
                .enabled,
            isFalse,
          );
          expect(
            tester
                .widget<TextField>(
                  find.byKey(const ValueKey('fiscal-ordinaria-inicio')),
                )
                .enabled,
            isFalse,
          );
          expect(
            tester
                .widget<TextField>(
                  find.byKey(const ValueKey('fiscal-rectificativa-serie')),
                )
                .enabled,
            isTrue,
          );
        } else {
          expect(find.text('Sin configurar'), findsNWidgets(2));
          for (final entry in {
            'ordinaria-serie': 'DEMO',
            'ordinaria-inicio': '25',
            'rectificativa-serie': 'AJ',
            'rectificativa-inicio': '3',
          }.entries) {
            await tester.enterText(
              find.byKey(ValueKey('fiscal-${entry.key}')),
              entry.value,
            );
          }
          await tester.tap(find.text('Preparar numeración'));
          await settle();
          expect(find.text('Confirmar preparación'), findsOneWidget);
          expect(
            await tester.runAsync(() => fiscal.obtener(DateTime.now().year)),
            isEmpty,
          );
          await tester.tap(find.text('Confirmar preparación'));
          await settle();
          expect(find.text('Preparada para emitir'), findsNWidgets(2));
          final config = await tester.runAsync(
            () => fiscal.obtener(DateTime.now().year),
          );
          expect(
            config!.firstWhere((c) => c.tipo == 'ordinaria').siguienteNumero,
            25,
          );
          expect(await db.select(db.facturas).get(), isEmpty);
        }
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
        await settle();
      });
    });
  }
}

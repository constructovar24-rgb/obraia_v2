import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/database/database_provider.dart';
import 'package:obraia_v2/core/widgets/money_text.dart';
import 'package:obraia_v2/features/presupuestos/presentation/screens/presupuestos_screen.dart';

void main() {
  late AppDatabase database;
  setUp(() => database = AppDatabase.forTesting(NativeDatabase.memory()));
  tearDown(() => database.close());
  Widget app() => ProviderScope(
    overrides: [databaseProvider.overrideWithValue(database)],
    child: const MaterialApp(home: PresupuestosScreen()),
  );
  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 15; i++) {
      await tester.pump(const Duration(milliseconds: 30));
    }
  }

  Future<void> disposeApp(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 1));
    await tester.pump(const Duration(milliseconds: 1));
  }

  Future<void> seed() async {
    await database.clientesDao.insertarCliente(
      ClientesCompanion.insert(id: 'c1', nombre: 'Construcciones Tovar'),
    );
    await database.expedientesDao.insertarExpediente(
      ExpedientesCompanion.insert(
        id: 'e1',
        codigo: 'OBRA-01',
        nombre: 'Reforma',
        clienteId: const Value('c1'),
      ),
    );
    await database.presupuestosDao.insertarPresupuesto(
      PresupuestosCompanion.insert(
        id: 'p1',
        expedienteId: 'e1',
        codigo: const Value('PRE-001'),
        descripcion: const Value('Reforma integral'),
        importeTotal: const Value(1000),
        ivaPorcentaje: const Value(21),
        estado: const Value('Borrador'),
      ),
    );
    await database.presupuestosDao.insertarPresupuesto(
      PresupuestosCompanion.insert(
        id: 'p2',
        expedienteId: 'e1',
        codigo: const Value('PRE-002'),
        descripcion: const Value('Baño'),
        importeTotal: const Value(500),
        estado: const Value('Aceptado'),
      ),
    );
  }

  testWidgets('muestra estado vacío y funciona en ancho reducido', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(680, 760);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(app());
    await settle(tester);
    expect(find.text('Todavía no hay presupuestos'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await disposeApp(tester);
  });

  testWidgets('busca y filtra por estados existentes', (tester) async {
    await seed();
    await tester.pumpWidget(app());
    await settle(tester);
    await tester.enterText(
      find.byKey(const ValueKey('presupuestos-search')),
      'PRE-002',
    );
    await tester.pump();
    expect(find.byKey(const ValueKey('presupuesto-row-p2')), findsOneWidget);
    expect(find.byKey(const ValueKey('presupuesto-row-p1')), findsNothing);
    await tester.enterText(
      find.byKey(const ValueKey('presupuestos-search')),
      '',
    );
    await tester.tap(find.byKey(const ValueKey('presupuestos-filter')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Borrador').last);
    await tester.pump();
    expect(find.byKey(const ValueKey('presupuesto-row-p1')), findsOneWidget);
    expect(find.byKey(const ValueKey('presupuesto-row-p2')), findsNothing);
    await disposeApp(tester);
  });

  testWidgets('ofrece apertura y representa base IVA y total', (tester) async {
    await seed();
    await tester.pumpWidget(app());
    await settle(tester);
    expect(find.text(MoneyText.format(1000)), findsWidgets);
    expect(find.text('21% · ${MoneyText.format(210)}'), findsOneWidget);
    expect(find.text(MoneyText.format(1210)), findsOneWidget);
    final row = find.byKey(const ValueKey('presupuesto-row-p1'));
    expect(tester.widget<InkWell>(row).onTap, isNotNull);
    await disposeApp(tester);
  });
}

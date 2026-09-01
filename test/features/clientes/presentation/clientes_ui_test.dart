import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/database/database_provider.dart';
import 'package:obraia_v2/features/clientes/presentation/screens/clientes_screen.dart';

void main() {
  late AppDatabase database;

  setUp(() => database = AppDatabase.forTesting(NativeDatabase.memory()));
  tearDown(() => database.close());

  Widget app({Size size = const Size(1200, 820)}) {
    return ProviderScope(
      overrides: [databaseProvider.overrideWithValue(database)],
      child: const MaterialApp(home: ClientesScreen()),
    );
  }

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

  void useDesktopView(WidgetTester tester) {
    tester.view.physicalSize = const Size(1280, 960);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Future<void> addCliente({String id = 'cliente-1', String nombre = 'Ana'}) {
    return database.clientesDao.insertarCliente(
      ClientesCompanion.insert(
        id: id,
        nombre: nombre,
        apellidos: const Value('Tovar'),
        nif: const Value('12345678Z'),
        email: const Value('ana@obraia.test'),
      ),
    );
  }

  testWidgets('muestra estado vacío y se adapta a ancho reducido', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(680, 760);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(app());
    await settle(tester);
    expect(find.text('Todavía no hay clientes'), findsOneWidget);
    expect(find.text('Nuevo cliente'), findsWidgets);
    expect(tester.takeException(), isNull);
    await disposeApp(tester);
  });

  testWidgets('busca, abre ficha y navega al expediente relacionado', (
    tester,
  ) async {
    useDesktopView(tester);
    await addCliente();
    await database.expedientesDao.insertarExpediente(
      ExpedientesCompanion.insert(
        id: 'exp-1',
        codigo: 'EXP-001',
        nombre: 'Reforma vivienda',
        clienteId: const Value('cliente-1'),
      ),
    );
    await tester.pumpWidget(app());
    await settle(tester);
    await tester.enterText(
      find.byKey(const ValueKey('clientes-search')),
      '12345678',
    );
    await tester.pump();
    expect(find.text('Ana Tovar'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('cliente-row-cliente-1')));
    await settle(tester);
    expect(find.text('Datos y contacto'), findsOneWidget);
    expect(find.text('Expedientes y obras'), findsOneWidget);
    expect(find.text('EXP-001'), findsOneWidget);
    final expedienteRow = find.byKey(
      const ValueKey('cliente-expediente-exp-1'),
    );
    await tester.ensureVisible(expedienteRow);
    expect(tester.widget<ListTile>(expedienteRow).onTap, isNotNull);
    await disposeApp(tester);
  });

  testWidgets('alta y edición comparten formulario y persisten datos', (
    tester,
  ) async {
    useDesktopView(tester);
    await tester.pumpWidget(app());
    await settle(tester);
    await tester.tap(find.text('Nuevo cliente').first);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('cliente-nombre')),
      'Yolanda',
    );
    await tester.enterText(
      find.byKey(const ValueKey('cliente-email')),
      'yolanda@obraia.test',
    );
    await tester.ensureVisible(find.text('Guardar cliente'));
    await tester.tap(find.text('Guardar cliente'));
    await settle(tester);
    final creado = await database
        .customSelect('SELECT id, nombre FROM clientes WHERE eliminado = 0')
        .getSingle();
    final creadoId = creado.read<String>('id');
    expect(creado.read<String>('nombre'), 'Yolanda');
    await disposeApp(tester);
    await tester.pumpWidget(app());
    await settle(tester);
    await tester.tap(find.byKey(ValueKey('cliente-row-$creadoId')));
    await settle(tester);
    await tester.tap(find.byTooltip('Editar cliente'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('cliente-nombre')),
      'Yolanda García',
    );
    await tester.ensureVisible(find.text('Guardar cliente'));
    await tester.tap(find.text('Guardar cliente'));
    await settle(tester);
    expect(
      (await database
              .customSelect(
                'SELECT nombre FROM clientes WHERE id = ?',
                variables: [Variable.withString(creadoId)],
              )
              .getSingle())
          .read<String>('nombre'),
      'Yolanda García',
    );
    await disposeApp(tester);
  });

  testWidgets('eliminación exige confirmación explícita', (tester) async {
    useDesktopView(tester);
    await addCliente();
    await tester.pumpWidget(app());
    await settle(tester);
    await tester.tap(find.byKey(const ValueKey('cliente-row-cliente-1')));
    await settle(tester);
    await tester.tap(find.byTooltip('Eliminar cliente'));
    await tester.pumpAndSettle();
    expect(
      find.text(
        'Vas a eliminar a Ana Tovar.\n\nDejará de aparecer en el listado de clientes.',
      ),
      findsOneWidget,
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Eliminar'));
    await settle(tester);
    expect(find.text('Todavía no hay clientes'), findsOneWidget);
    await disposeApp(tester);
  });
}

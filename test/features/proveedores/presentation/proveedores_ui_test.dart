import 'dart:async';

import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/database/database_provider.dart';
import 'package:obraia_v2/features/proveedores/presentation/screens/proveedores_screen.dart';
import 'package:obraia_v2/features/proveedores/presentation/widgets/proveedor_form.dart';

void main() {
  late AppDatabase database;

  setUp(() => database = AppDatabase.forTesting(NativeDatabase.memory()));
  tearDown(() => database.close());

  Widget app({Widget home = const ProveedoresScreen()}) => ProviderScope(
    overrides: [databaseProvider.overrideWithValue(database)],
    child: MaterialApp(home: home),
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

  void useDesktopView(WidgetTester tester) {
    tester.view.physicalSize = const Size(1280, 960);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Future<void> addProveedor({
    String id = 'proveedor-1',
    String nombre = 'Áridos Tovar',
  }) {
    return database.proveedoresDao.insertarProveedor(
      ProveedoresCompanion.insert(
        id: id,
        nombre: nombre,
        personaContacto: const Value('Marta Ruiz'),
        nif: const Value('B12345678'),
        telefono: const Value('950000001'),
        email: const Value('compras@aridos.test'),
        poblacion: const Value('Almería'),
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
    expect(find.text('Todavía no hay proveedores'), findsOneWidget);
    expect(find.text('Nuevo proveedor'), findsWidgets);
    expect(tester.takeException(), isNull);
    await disposeApp(tester);
  });

  testWidgets('busca por datos de compra y abre la ficha profesional', (
    tester,
  ) async {
    useDesktopView(tester);
    await addProveedor();
    await tester.pumpWidget(app());
    await settle(tester);
    await tester.enterText(
      find.byKey(const ValueKey('proveedores-search')),
      'B12345678',
    );
    await tester.pump();
    expect(find.text('Áridos Tovar'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('proveedor-row-proveedor-1')));
    await settle(tester);
    expect(find.text('Datos fiscales'), findsOneWidget);
    expect(find.text('Contacto'), findsOneWidget);
    expect(find.text('compras@aridos.test'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('alta y edición comparten formulario y persisten datos', (
    tester,
  ) async {
    useDesktopView(tester);
    await tester.pumpWidget(app());
    await settle(tester);
    await tester.tap(find.text('Nuevo proveedor').first);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('proveedor-nombre')),
      'Hormigones Sur',
    );
    await tester.enterText(
      find.byKey(const ValueKey('proveedor-email')),
      'pedidos@hormigones.test',
    );
    await tester.ensureVisible(find.text('Guardar proveedor'));
    await tester.tap(find.text('Guardar proveedor'));
    await settle(tester);
    final creado = await database
        .customSelect('SELECT id, nombre FROM proveedores WHERE eliminado = 0')
        .getSingle();
    final creadoId = creado.read<String>('id');
    expect(creado.read<String>('nombre'), 'Hormigones Sur');
    await disposeApp(tester);
    await tester.pumpWidget(app());
    await settle(tester);
    await tester.tap(find.byKey(ValueKey('proveedor-row-$creadoId')));
    await settle(tester);
    await tester.tap(find.byTooltip('Editar proveedor'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('proveedor-nombre')),
      'Hormigones del Sur',
    );
    await tester.ensureVisible(find.text('Guardar proveedor'));
    await tester.tap(find.text('Guardar proveedor'));
    await settle(tester);
    expect(
      (await database
              .customSelect(
                'SELECT nombre FROM proveedores WHERE id = ?',
                variables: [Variable.withString(creadoId)],
              )
              .getSingle())
          .read<String>('nombre'),
      'Hormigones del Sur',
    );
    await disposeApp(tester);
  });

  testWidgets('eliminación exige confirmación explícita', (tester) async {
    useDesktopView(tester);
    await addProveedor();
    await tester.pumpWidget(app());
    await settle(tester);
    await tester.tap(find.byKey(const ValueKey('proveedor-row-proveedor-1')));
    await settle(tester);
    await tester.tap(find.byTooltip('Eliminar proveedor'));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Vas a eliminar a Áridos Tovar.'),
      findsOneWidget,
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Eliminar'));
    await settle(tester);
    expect(find.text('Todavía no hay proveedores'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('formulario valida y bloquea el doble envío', (tester) async {
    useDesktopView(tester);
    final pending = Completer<void>();
    var submissions = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProveedorForm(
            onCancel: () {},
            onSubmit: (_) {
              submissions++;
              return pending.future;
            },
          ),
        ),
      ),
    );
    await tester.ensureVisible(find.text('Guardar proveedor'));
    await tester.tap(find.text('Guardar proveedor'));
    await tester.pump();
    expect(find.text('Este campo es obligatorio'), findsOneWidget);
    expect(submissions, 0);
    await tester.enterText(
      find.byKey(const ValueKey('proveedor-nombre')),
      'Cerámicas Sol',
    );
    await tester.tap(find.text('Guardar proveedor'));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('proveedor-submit')));
    await tester.pump();
    expect(submissions, 1);
    expect(find.text('Guardando…'), findsOneWidget);
    pending.complete();
    await tester.pump();
  });
}

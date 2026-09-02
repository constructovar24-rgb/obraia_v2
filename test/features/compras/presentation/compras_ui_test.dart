import 'dart:async';
import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/database/database_provider.dart';
import 'package:obraia_v2/features/compras/presentation/screens/compras_screen.dart';
import 'package:obraia_v2/features/compras/presentation/widgets/compra_form.dart';
import 'package:obraia_v2/features/expedientes/domain/expediente.dart'
    as domain;
import 'package:obraia_v2/features/proveedores/domain/proveedor.dart';

void main() {
  late AppDatabase db;
  setUp(() => db = AppDatabase.forTesting(NativeDatabase.memory()));
  tearDown(() => db.close());
  Widget app() => ProviderScope(
    overrides: [databaseProvider.overrideWithValue(db)],
    child: const MaterialApp(home: ComprasScreen()),
  );
  Future<void> settle(WidgetTester t) async {
    for (var i = 0; i < 15; i++) {
      await t.pump(const Duration(milliseconds: 30));
    }
  }

  Future<void> disposeApp(WidgetTester t) async {
    await t.pumpWidget(const SizedBox());
    await t.pump(const Duration(milliseconds: 1));
    await t.pump(const Duration(milliseconds: 1));
  }

  void desktop(WidgetTester t, {Size size = const Size(1280, 900)}) {
    t.view.physicalSize = size;
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.resetPhysicalSize);
    addTearDown(t.view.resetDevicePixelRatio);
  }

  Future<void> seed() async {
    await db.expedientesDao.insertarExpediente(
      ExpedientesCompanion.insert(
        id: 'exp-1',
        codigo: 'OBR-001',
        nombre: 'Reforma centro',
      ),
    );
    await db.proveedoresDao.insertarProveedor(
      ProveedoresCompanion.insert(id: 'prov-1', nombre: 'Materiales Sur'),
    );
    await db.comprasDao.insertarCompra(
      ComprasCompanion.insert(
        id: 'compra-1',
        expedienteId: 'exp-1',
        proveedorId: const Value('prov-1'),
        proveedorNombre: const Value('Materiales Sur'),
        fecha: Value(DateTime(2026, 9, 3)),
        numeroFactura: const Value('FS-42'),
        concepto: const Value('Cemento y áridos'),
        baseImponible: const Value(100),
        ivaPorcentaje: const Value(21),
        importeTotal: const Value(121),
        estado: const Value('pendiente'),
        observaciones: const Value('Entrega en obra'),
      ),
    );
  }

  testWidgets('muestra vacío profesional en ancho reducido', (t) async {
    desktop(t, size: const Size(680, 760));
    await t.pumpWidget(app());
    await settle(t);
    expect(find.text('Todavía no hay compras'), findsOneWidget);
    expect(t.takeException(), isNull);
    await disposeApp(t);
  });

  testWidgets('busca, filtra y resume datos reales', (t) async {
    desktop(t);
    await seed();
    await t.pumpWidget(app());
    await settle(t);
    await t.enterText(find.byKey(const Key('compras-search')), 'Materiales');
    await t.pump();
    expect(find.text('Cemento y áridos'), findsOneWidget);
    expect(find.text('1 de 1 compras'), findsOneWidget);
    expect(find.textContaining('121.00'), findsWidgets);
    await t.tap(find.byKey(const Key('compras-filter')));
    await t.pumpAndSettle();
    await t.tap(find.text('Pagada').last);
    await t.pump();
    expect(find.text('No hay coincidencias'), findsOneWidget);
    await disposeApp(t);
  });

  testWidgets('detalle navega a proveedor y expediente', (t) async {
    desktop(t);
    await seed();
    await t.pumpWidget(app());
    await settle(t);
    await t.tap(find.byKey(const Key('compra-row-compra-1')));
    await settle(t);
    expect(find.text('Trazabilidad'), findsOneWidget);
    expect(find.text('Importes registrados'), findsOneWidget);
    expect(
      find.textContaining('no contiene un documento original'),
      findsOneWidget,
    );
    expect(
      t.widget<ListTile>(find.widgetWithText(ListTile, 'Materiales Sur')).onTap,
      isNotNull,
    );
    expect(
      t
          .widget<ListTile>(
            find.widgetWithText(ListTile, 'OBR-001 · Reforma centro'),
          )
          .onTap,
      isNotNull,
    );
    await disposeApp(t);
  });

  testWidgets('eliminación lógica exige confirmación', (t) async {
    desktop(t);
    await seed();
    await t.pumpWidget(app());
    await settle(t);
    await t.tap(find.byKey(const Key('compra-row-compra-1')));
    await settle(t);
    await t.tap(find.byTooltip('Eliminar compra'));
    await t.pumpAndSettle();
    expect(find.textContaining('Vas a eliminar el registro'), findsOneWidget);
    await t.tap(find.widgetWithText(FilledButton, 'Eliminar'));
    await settle(t);
    expect(find.text('Todavía no hay compras'), findsOneWidget);
    await disposeApp(t);
  });

  testWidgets('formulario valida y bloquea doble envío', (t) async {
    desktop(t);
    final pending = Completer<void>();
    var count = 0;
    const expediente = domain.Expediente(
      id: 'exp-1',
      codigo: 'OBR-1',
      nombre: 'Obra',
      estadoCiclo: domain.ExpedienteEstadoCiclo.activo,
    );
    const proveedor = Proveedor(
      id: 'p-1',
      nombre: 'Proveedor',
      personaContacto: null,
      nif: '',
      telefono: '',
      email: '',
      direccion: '',
      poblacion: '',
      provincia: '',
      codigoPostal: '',
      pais: 'España',
      observaciones: '',
    );
    await t.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CompraForm(
            expedienteId: 'exp-1',
            expedientes: const [expediente],
            proveedores: const [proveedor],
            onCancel: () {},
            onSubmit: (_) {
              count++;
              return pending.future;
            },
          ),
        ),
      ),
    );
    await t.ensureVisible(find.text('Guardar compra'));
    await t.tap(find.text('Guardar compra'));
    await t.pump();
    expect(find.text('El concepto es obligatorio'), findsOneWidget);
    await t.enterText(find.byKey(const Key('compra-concepto')), 'Material');
    await t.enterText(find.byKey(const Key('compra-base')), '100');
    await t.tap(find.byKey(const Key('compra-proveedor')));
    await t.pumpAndSettle();
    await t.tap(find.text('Proveedor').last);
    await t.pump();
    await t.tap(find.text('Guardar compra'));
    await t.pump();
    await t.tap(find.byKey(const Key('compra-submit')));
    await t.pump();
    expect(count, 1);
    expect(find.text('Guardando…'), findsOneWidget);
    pending.complete();
    await t.pump();
  });
}

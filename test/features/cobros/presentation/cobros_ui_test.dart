import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/database/database_provider.dart';
import 'package:obraia_v2/features/cobros/domain/factura_estado_economico.dart';
import 'package:obraia_v2/features/cobros/presentation/screens/cobros_screen.dart';
import 'package:obraia_v2/features/facturas/data/factura_repository.dart';
import 'package:obraia_v2/features/facturas/domain/estado_factura.dart';
import 'package:obraia_v2/features/facturas/domain/factura.dart'
    as factura_domain;

class _FakeFacturaRepository extends FacturaRepository {
  _FakeFacturaRepository(super.database, this.items);
  final List<FacturaConEstadoEconomico> items;

  @override
  Stream<List<FacturaConEstadoEconomico>>
  observarFacturasConEstadoEconomico() => Stream.value(items);
}

void main() {
  late AppDatabase database;
  setUp(() => database = AppDatabase.forTesting(NativeDatabase.memory()));
  tearDown(() => database.close());

  FacturaConEstadoEconomico item({
    required String id,
    required String codigo,
    required double cobrado,
    EstadoFactura estado = EstadoFactura.emitida,
  }) {
    final factura = factura_domain.Factura(
      id: id,
      codigo: codigo,
      clienteId: 'c1',
      clienteNombre: 'Cliente $id',
      expedienteCodigoHistorico: 'OBRA-$id',
      presupuestoCodigoHistorico: 'PRE-$id',
      fecha: DateTime(2026, 9, 1),
      fechaVencimiento: DateTime(2026, 10, 1),
      estado: estado,
      subtotal: 100,
      iva: 21,
      ivaPorcentaje: 21,
      total: 121,
      observaciones: '',
    );
    return FacturaConEstadoEconomico(
      factura: factura,
      estadoEconomico: calcularResumenEconomicoFactura(
        totalFactura: factura.total,
        totalCobrado: cobrado,
        fechaVencimiento: factura.fechaVencimiento,
        estadoFactura: estado,
        fechaReferencia: DateTime(2026, 9, 2),
      ),
    );
  }

  Widget app(List<FacturaConEstadoEconomico> items) => ProviderScope(
    overrides: [
      databaseProvider.overrideWithValue(database),
      facturaRepositoryProvider.overrideWithValue(
        _FakeFacturaRepository(database, items),
      ),
    ],
    child: const MaterialApp(home: CobrosScreen.global()),
  );

  Future<void> settle(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
  }

  testWidgets('muestra vacío profesional en ancho reducido', (tester) async {
    tester.view.physicalSize = const Size(680, 760);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(app(const []));
    await settle(tester);
    expect(find.text('No hay facturas en seguimiento'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('busca y filtra pendientes, parciales y cobradas', (
    tester,
  ) async {
    final items = [
      item(id: 'pendiente', codigo: 'FAC-001', cobrado: 0),
      item(id: 'parcial', codigo: 'FAC-002', cobrado: 50),
      item(
        id: 'cobrada',
        codigo: 'FAC-003',
        cobrado: 121,
        estado: EstadoFactura.cobrada,
      ),
    ];
    await tester.pumpWidget(app(items));
    await settle(tester);
    await tester.enterText(
      find.byKey(const ValueKey('cobros-search')),
      'FAC-002',
    );
    await tester.pump();
    expect(
      find.byKey(const ValueKey('cobros-factura-parcial')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('cobros-factura-pendiente')),
      findsNothing,
    );
    await tester.enterText(find.byKey(const ValueKey('cobros-search')), '');
    await tester.tap(find.byKey(const ValueKey('cobros-filter')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cobradas').last);
    await tester.pump();
    expect(
      find.byKey(const ValueKey('cobros-factura-cobrada')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('cobros-factura-parcial')), findsNothing);
  });

  testWidgets('muestra saldos, vencimiento y apertura de factura', (
    tester,
  ) async {
    await tester.pumpWidget(
      app([item(id: 'parcial', codigo: 'FAC-002', cobrado: 50)]),
    );
    await settle(tester);
    expect(find.textContaining('Vence 01/10/2026'), findsOneWidget);
    expect(find.textContaining('Total:'), findsOneWidget);
    expect(find.textContaining('Cobrado:'), findsOneWidget);
    expect(find.textContaining('Pendiente:'), findsOneWidget);
    expect(find.text('Parcialmente cobrada'), findsOneWidget);
    final row = find.byKey(const ValueKey('cobros-factura-parcial'));
    expect(tester.widget<InkWell>(row).onTap, isNotNull);
  });
}

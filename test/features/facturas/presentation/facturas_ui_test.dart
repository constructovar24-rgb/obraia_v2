import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/database/database_provider.dart';
import 'package:obraia_v2/features/cobros/domain/factura_estado_economico.dart';
import 'package:obraia_v2/features/facturas/data/factura_repository.dart';
import 'package:obraia_v2/features/facturas/domain/estado_factura.dart';
import 'package:obraia_v2/features/facturas/domain/factura.dart'
    as factura_domain;
import 'package:obraia_v2/features/facturas/domain/tipo_documento_factura.dart';
import 'package:obraia_v2/features/facturas/presentation/screens/facturas_screen.dart';

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

  factura_domain.Factura factura({
    required String id,
    required String codigo,
    required EstadoFactura estado,
    bool rect = false,
  }) => factura_domain.Factura(
    id: id,
    codigo: codigo,
    clienteId: 'c1',
    clienteNombre: 'Construcciones Tovar',
    clienteNombreHistorico: 'Construcciones Tovar',
    expedienteCodigoHistorico: 'OBRA-01',
    presupuestoCodigoHistorico: 'PRE-001',
    fecha: DateTime(2026, 9, 1),
    fechaVencimiento: DateTime(2026, 10, 1),
    estado: estado,
    subtotal: rect ? -100 : 1000,
    iva: rect ? -21 : 210,
    ivaPorcentaje: 21,
    total: rect ? -121 : 1210,
    observaciones: '',
    tipoDocumento: rect
        ? TipoDocumentoFactura.rectificativa
        : TipoDocumentoFactura.ordinaria,
    serie: rect ? 'RECT' : 'FAC',
    facturaRectificadaId: rect ? 'f1' : null,
    facturaRaizId: rect ? 'f1' : null,
    modalidadRectificacion: rect ? ModalidadRectificacion.diferencias : null,
    motivoRectificacion: rect ? 'Ajuste de medición' : '',
    efectoBase: rect ? -100 : 0,
    efectoIva: rect ? -21 : 0,
    efectoTotal: rect ? -121 : 0,
  );

  FacturaConEstadoEconomico item(
    factura_domain.Factura factura,
    double cobrado,
  ) => FacturaConEstadoEconomico(
    factura: factura,
    estadoEconomico: calcularResumenEconomicoFactura(
      totalFactura: factura.total,
      totalCobrado: cobrado,
      fechaVencimiento: factura.fechaVencimiento,
      estadoFactura: factura.estado,
      fechaReferencia: DateTime(2026, 9, 2),
    ),
  );

  Widget app(List<FacturaConEstadoEconomico> items) => ProviderScope(
    overrides: [
      databaseProvider.overrideWithValue(database),
      facturaRepositoryProvider.overrideWithValue(
        _FakeFacturaRepository(database, items),
      ),
    ],
    child: const MaterialApp(home: FacturasScreen()),
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
    expect(find.text('Todavía no hay facturas'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('busca y filtra documentos FAC y RECT', (tester) async {
    final fac = factura(
      id: 'f1',
      codigo: 'FAC-2026-0001',
      estado: EstadoFactura.emitida,
    );
    final rect = factura(
      id: 'r1',
      codigo: 'RECT-2026-0001',
      estado: EstadoFactura.emitida,
      rect: true,
    );
    await tester.pumpWidget(app([item(fac, 500), item(rect, 0)]));
    await settle(tester);
    await tester.enterText(
      find.byKey(const ValueKey('facturas-search')),
      'RECT-2026',
    );
    await tester.pump();
    expect(find.byKey(const ValueKey('factura-row-r1')), findsOneWidget);
    expect(find.byKey(const ValueKey('factura-row-f1')), findsNothing);
    await tester.enterText(find.byKey(const ValueKey('facturas-search')), '');
    await tester.tap(find.byKey(const ValueKey('facturas-tipo-filter')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Solo FAC').last);
    await tester.pump();
    expect(find.byKey(const ValueKey('factura-row-f1')), findsOneWidget);
    expect(find.byKey(const ValueKey('factura-row-r1')), findsNothing);
  });

  testWidgets('representa vencimiento, cobrado, pendiente y apertura', (
    tester,
  ) async {
    final fac = factura(
      id: 'f1',
      codigo: 'FAC-2026-0001',
      estado: EstadoFactura.emitida,
    );
    await tester.pumpWidget(app([item(fac, 500)]));
    await settle(tester);
    expect(find.textContaining('Vence 01/10/2026'), findsOneWidget);
    expect(find.textContaining('Total:'), findsWidgets);
    expect(find.textContaining('Cobrado:'), findsWidgets);
    expect(find.textContaining('Pendiente:'), findsWidgets);
    final row = find.byKey(const ValueKey('factura-row-f1'));
    expect(tester.widget<InkWell>(row).onTap, isNotNull);
  });
}

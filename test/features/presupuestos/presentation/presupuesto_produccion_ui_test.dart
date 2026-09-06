import 'package:obraia_v2/features/presupuestos/domain/presupuesto.dart'
    as domain;
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/database/database_provider.dart';
import 'package:obraia_v2/features/presupuestos/data/presupuesto_repository.dart';
import 'package:obraia_v2/features/presupuestos/presentation/screens/presupuesto_detail_screen.dart';
import '../data/prod2_test_support.dart';

void main() {
  for (final state in ['borrador', 'aceptado', 'legacy']) {
    group(state, () {
      late AppDatabase db;
      late domain.Presupuesto presupuesto;
      setUp(() async {
        db = AppDatabase.forTesting(NativeDatabase.memory());
        final id = await crearPropuestaPrueba(db);
        final repo = PresupuestoRepository(db);
        if (state == 'aceptado') await repo.aceptarPresupuesto(id);
        if (state == 'legacy') {
          await (db.update(db.presupuestos)..where((t) => t.id.equals(id)))
              .write(const PresupuestosCompanion(estado: Value('Aceptado')));
        }
        presupuesto = (await repo.observarPresupuesto(id).first)!;
      });

      testWidgets('expone solo las acciones permitidas', (tester) async {
        tester.view.physicalSize = const Size(1200, 2600);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await tester.pumpWidget(
          ProviderScope(
            overrides: [databaseProvider.overrideWithValue(db)],
            child: MaterialApp(
              home: PresupuestoDetailScreen(presupuesto: presupuesto),
            ),
          ),
        );
        for (var i = 0; i < 30; i++) {
          await tester.pump(const Duration(milliseconds: 30));
        }
        if (state == 'borrador') {
          expect(find.text('Añadir línea'), findsOneWidget);
          expect(find.text('Eliminar presupuesto'), findsOneWidget);
          expect(find.text('Aceptar presupuesto'), findsOneWidget);
          expect(find.text('Ver PDF borrador'), findsOneWidget);
        } else {
          expect(find.text('Añadir línea'), findsNothing);
          expect(find.text('Eliminar presupuesto'), findsNothing);
          expect(find.text('Aceptar presupuesto'), findsNothing);
          expect(find.text('Ver PDF definitivo'), findsOneWidget);
          expect(
            find.textContaining(
              state == 'legacy'
                  ? 'Aceptado histórico'
                  : 'Presupuesto aceptado protegido',
            ),
            findsOneWidget,
          );
          for (final tile in tester.widgetList<ListTile>(
            find.byType(ListTile),
          )) {
            expect(tile.onTap, isNull);
          }
        }
        expect(tester.takeException(), isNull);

        await tester.pumpWidget(const SizedBox());
        var closed = false;
        final closing = db.close().then((_) => closed = true);
        for (var i = 0; i < 100 && !closed; i++) {
          await tester.runAsync(
            () => Future<void>.delayed(const Duration(milliseconds: 1)),
          );
          await tester.pump(const Duration(milliseconds: 1));
        }
        expect(
          closed,
          isTrue,
          reason: "Database closes after draining both clocks",
        );
        await closing;
        await tester.pump(const Duration(milliseconds: 1));

        await tester.pump(const Duration(milliseconds: 1));
      });
    });
  }
}

import 'package:obraia_v2/features/presupuestos/domain/presupuesto.dart'
    as domain;
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/database/database_provider.dart';
import 'package:obraia_v2/features/expedientes/data/expediente_repository.dart';
import 'package:obraia_v2/features/presupuestos/data/presupuesto_repository.dart';
import 'package:obraia_v2/features/presupuestos/presentation/screens/presupuesto_detail_screen.dart';
import '../data/prod2_test_support.dart';

void main() {
  for (final state in [
    'borrador',
    'sin cliente',
    'cliente en blanco',
    'cargando obra',
    'aceptado',
    'legacy',
  ]) {
    group(state, () {
      late AppDatabase db;
      late domain.Presupuesto presupuesto;
      setUp(() async {
        db = AppDatabase.forTesting(NativeDatabase.memory());
        final id = await crearPropuestaPrueba(db);
        if (state == 'sin cliente') {
          await (db.update(db.expedientes)..where((t) => t.id.equals('obra')))
              .write(const ExpedientesCompanion(clienteId: Value(null)));
        }
        if (state == 'cliente en blanco') {
          await (db.update(db.clientes)..where((t) => t.id.equals('cliente')))
              .write(const ClientesCompanion(nombre: Value('   ')));
        }
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
            overrides: [
              databaseProvider.overrideWithValue(db),
              if (state == 'cargando obra')
                expedienteProvider(
                  presupuesto.expedienteId,
                ).overrideWith((ref) => const Stream.empty()),
            ],
            child: MaterialApp(
              home: PresupuestoDetailScreen(presupuesto: presupuesto),
            ),
          ),
        );
        for (var i = 0; i < 30; i++) {
          await tester.pump(const Duration(milliseconds: 30));
        }
        if (state == 'borrador' ||
            state == 'sin cliente' ||
            state == 'cliente en blanco') {
          expect(find.text('Añadir línea'), findsOneWidget);
          expect(find.text('Eliminar presupuesto'), findsOneWidget);
          expect(find.text('Aceptar presupuesto'), findsOneWidget);
          expect(find.text('Ver PDF borrador'), findsOneWidget);
          await tester.ensureVisible(find.text('Eliminar presupuesto'));
          await tester.tap(find.text('Eliminar presupuesto'));
          await tester.pumpAndSettle();
          final dialogo = find.byType(AlertDialog);
          expect(dialogo, findsOneWidget);
          final mensaje = find.descendant(
            of: dialogo,
            matching: find.textContaining('Referencia:'),
          );
          expect(mensaje, findsOneWidget);
          final texto = tester.widget<Text>(mensaje).data!;
          expect(texto, contains('Referencia: ${presupuesto.codigo}'));
          expect(
            texto,
            contains(
              state == 'borrador'
                  ? 'Cliente: CLIENTE DEMO\n'
                  : 'Cliente: Sin cliente asignado\n',
            ),
          );
          expect(texto, contains('Obra: EXP — Obra ficticia'));
          // 2,5 × 10,25 + 3 × 20 = 85,63; IVA 21% = 17,98.
          expect(texto, contains('Total con IVA: 103,61 €'));
          expect(texto, contains('Esta acción no se puede deshacer.'));
          await tester.tap(find.text('Cancelar'));
          await tester.pumpAndSettle();
          expect(dialogo, findsNothing);
          final conservado = await tester.runAsync(
            () => db.presupuestosDao.obtenerPorId(presupuesto.id),
          );
          expect(conservado, isNotNull);
          expect(conservado!.eliminado, isFalse);
          expect(find.text('Eliminar presupuesto'), findsOneWidget);
        } else if (state == 'cargando obra') {
          final eliminar = find.widgetWithText(
            OutlinedButton,
            'Eliminar presupuesto',
          );
          expect(tester.widget<OutlinedButton>(eliminar).onPressed, isNull);
          await tester.ensureVisible(eliminar);
          await tester.tap(eliminar);
          await tester.pump();
          expect(find.byType(AlertDialog), findsNothing);
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

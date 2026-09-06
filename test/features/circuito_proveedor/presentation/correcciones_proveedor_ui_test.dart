import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/features/circuito_proveedor/data/circuito_proveedor_repository.dart';
import 'package:obraia_v2/features/circuito_proveedor/domain/circuito_proveedor.dart';
import 'package:obraia_v2/features/circuito_proveedor/presentation/providers/circuito_proveedor_providers.dart';
import 'package:obraia_v2/features/circuito_proveedor/presentation/screens/facturas_proveedor_screen.dart';
import 'package:obraia_v2/features/compras/presentation/providers/compra_providers.dart';
import 'package:obraia_v2/features/proveedores/presentation/providers/proveedor_providers.dart';

void main() {
  for (final anulado in [false, true]) {
    testWidgets(
      'ficha muestra pago desconocido, destino e historial; anulada=$anulado',
      (tester) async {
        final db = AppDatabase.forTesting(NativeDatabase.memory());
        await db.ensureReady();
        await db.proveedoresDao.insertarProveedor(
          ProveedoresCompanion.insert(id: 'p', nombre: 'Ficticio'),
        );
        final repo = CircuitoProveedorRepository(db);
        final id = await repo.crearFactura(
          FacturaRecibidaInput(
            proveedorId: 'p',
            numero: 'FICT-UI',
            fecha: DateTime(2026),
            baseCentimos: 1000,
            ivaCentimos: 210,
            asignaciones: [const AsignacionImporteInput(importeCentimos: 1000)],
          ),
        );
        await repo.consolidarFactura(id);
        if (anulado) await repo.anularFactura(id, motivo: 'Prueba visual');
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              circuitoProveedorRepositoryProvider.overrideWithValue(repo),
              proveedoresProvider.overrideWith((ref) => Stream.value([])),
              expedientesCompraProvider.overrideWith((ref) => Stream.value([])),
            ],
            child: const MaterialApp(home: FacturasProveedorScreen()),
          ),
        );
        for (var i = 0; i < 30; i++) {
          await tester.runAsync(
            () => Future<void>.delayed(const Duration(milliseconds: 10)),
          );
          await tester.pump(const Duration(milliseconds: 20));
        }
        expect(find.textContaining('FICT-UI'), findsOneWidget);
        expect(find.textContaining('Sin obra asignada'), findsOneWidget);
        await tester.tap(find.byType(ExpansionTile));
        await tester.pumpAndSettle();
        expect(find.text('Registrar pago'), findsNothing);
        if (anulado) {
          expect(find.text('Cambiar imputación'), findsNothing);
          expect(find.textContaining('Factura anulada'), findsOneWidget);
        } else {
          expect(find.text('Verificar estado de pago'), findsOneWidget);
        }
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
        await db.close();
      },
    );
  }
}

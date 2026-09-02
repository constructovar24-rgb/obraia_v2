import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart' hide Cobro;
import 'package:obraia_v2/core/widgets/app_primary_button.dart';
import 'package:obraia_v2/features/cobros/data/cobro_repository.dart';
import 'package:obraia_v2/features/cobros/domain/cobro.dart';
import 'package:obraia_v2/features/cobros/presentation/screens/nueva_reversion_cobro_screen.dart';

void main() {
  testWidgets('doble activación registra una sola reversión', (tester) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = _CobroRepositoryControlado(database);
    final cobro = Cobro(
      id: 'cobro-710',
      facturaId: 'factura',
      fecha: DateTime(2026, 8, 30),
      importe: 710,
      metodoPago: 'Transferencia',
      referencia: '',
      observaciones: '',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [cobroRepositoryProvider.overrideWithValue(repository)],
        child: MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: FilledButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => NuevaReversionCobroScreen(cobro: cobro),
                  ),
                ),
                child: const Text('Abrir'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Motivo'),
      'Reversión de prueba para aceptación manual',
    );

    final boton = find.byType(AppPrimaryButton);
    await tester.tap(boton);
    await tester.tap(boton);
    expect(repository.llamadas, 1);
    await tester.pump();
    expect(find.text('Registrando...'), findsOneWidget);

    repository.resultado.complete('reversion-id');
    await tester.pumpAndSettle();
    expect(find.text('Abrir'), findsOneWidget);
    expect(
      find.text('La reversión supera el importe disponible o no es válida.'),
      findsNothing,
    );
  });
}

class _CobroRepositoryControlado extends CobroRepository {
  _CobroRepositoryControlado(super.database);

  final resultado = Completer<String>();
  int llamadas = 0;

  @override
  Future<double> obtenerImporteDisponibleParaReversion(String cobroId) async {
    return 710;
  }

  @override
  Future<String> revertirCobro({
    required String cobroId,
    required DateTime fecha,
    required double importe,
    required String motivo,
  }) {
    llamadas++;
    return resultado.future;
  }
}

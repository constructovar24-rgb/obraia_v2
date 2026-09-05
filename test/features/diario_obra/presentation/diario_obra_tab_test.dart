import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/features/diario_obra/data/diario_obra_repository.dart';
import 'package:obraia_v2/features/diario_obra/domain/entrada_diario_obra.dart';
import 'package:obraia_v2/features/diario_obra/presentation/providers/diario_obra_providers.dart';
import 'package:obraia_v2/features/diario_obra/presentation/widgets/diario_obra_tab.dart';
import 'package:obraia_v2/features/mano_obra/domain/mano_obra.dart';
import 'package:obraia_v2/features/mano_obra/presentation/providers/mano_obra_providers.dart';
import 'package:obraia_v2/features/planificacion/presentation/providers/planificacion_obra_providers.dart';

void main() {
  testWidgets('lista, crea y edita, muestra horas y evita doble guardado', (
    tester,
  ) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final repository = _FakeDiaryRepository(db);
    final date = DateTime(2026, 9, 5);
    final entry = EntradaDiarioObra(
      id: 'entry',
      expedienteId: 'obra',
      fechaTrabajo: date,
      trabajos: 'Hormigonada la losa',
      observaciones: 'Sin novedad',
      anulado: false,
      fechaCreacion: date,
      fechaModificacion: date,
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          diarioObraRepositoryProvider.overrideWithValue(repository),
          entradasDiarioObraProvider.overrideWith(
            (ref, id) => Stream.value([entry]),
          ),
          actuacionesObraProvider.overrideWith((ref, id) => Stream.value([])),
          partesTrabajoObraProvider.overrideWith(
            (ref, id) => Stream.value([
              ParteTrabajo(
                id: 'part',
                expedienteId: id,
                personaId: 'person',
                fechaTrabajo: date,
                horasDiezMilesimas: 75000,
                descripcionTrabajo: 'Hormigón',
                categoriaEconomicaId: 'labor',
                estado: EstadoParteTrabajo.valorado,
              ),
              ParteTrabajo(
                id: 'reverted',
                expedienteId: id,
                personaId: 'person',
                fechaTrabajo: date,
                horasDiezMilesimas: 20000,
                descripcionTrabajo: 'Revertido',
                categoriaEconomicaId: 'labor',
                estado: EstadoParteTrabajo.revertido,
              ),
            ]),
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(body: DiarioObraTab(expedienteId: 'obra')),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Hormigonada la losa'), findsOneWidget);
    expect(find.text('Horas registradas: 7.50 h'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('nueva-entrada-diario')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('trabajos-diario')),
      'Colocadas dos hiladas',
    );
    final save = find.byKey(const ValueKey('guardar-diario'));
    await tester.tap(save);
    await tester.tap(save);
    await tester.pump();
    expect(repository.createCalls, 1);
    repository.completeCreate();
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('editar-diario-entry')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('trabajos-diario')),
      'Losa revisada',
    );
    await tester.tap(find.byKey(const ValueKey('guardar-diario')));
    await tester.pumpAndSettle();
    expect(repository.editCalls, 1);
    expect(repository.lastEditedWork, 'Losa revisada');
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}

class _FakeDiaryRepository extends DiarioObraRepository {
  _FakeDiaryRepository(super.database);

  final Completer<String> _createCompleter = Completer<String>();
  int createCalls = 0;
  int editCalls = 0;
  String? lastEditedWork;

  @override
  Future<String> crear({
    required String expedienteId,
    required DateTime fechaTrabajo,
    required String trabajos,
    String? observaciones,
    String? meteorologia,
    String? incidenciaTexto,
    String? actuacionId,
  }) {
    createCalls++;
    return _createCompleter.future;
  }

  void completeCreate() => _createCompleter.complete('created');

  @override
  Future<void> editar({
    required String id,
    required DateTime fechaTrabajo,
    required String trabajos,
    String? observaciones,
    String? meteorologia,
    String? incidenciaTexto,
    String? actuacionId,
  }) async {
    editCalls++;
    lastEditedWork = trabajos;
  }
}

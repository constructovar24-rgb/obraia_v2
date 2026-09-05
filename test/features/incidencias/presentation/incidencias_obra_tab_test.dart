import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/features/diario_obra/presentation/providers/diario_obra_providers.dart';
import 'package:obraia_v2/features/documentos/presentation/providers/documento_providers.dart';
import 'package:obraia_v2/features/incidencias/data/incidencias_obra_repository.dart';
import 'package:obraia_v2/features/incidencias/domain/incidencia_obra.dart';
import 'package:obraia_v2/features/incidencias/presentation/providers/incidencias_obra_providers.dart';
import 'package:obraia_v2/features/incidencias/presentation/widgets/incidencias_obra_tab.dart';

void main() {
  testWidgets('lista, crea, resuelve y evita doble guardado', (tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final repository = _FakeIncidentsRepository(db);
    final date = DateTime(2026, 9, 5);
    final incident = IncidenciaObra(
      id: 'incident',
      expedienteId: 'obra',
      fechaDeteccion: date,
      titulo: 'Fisura detectada',
      descripcion: 'Fisura vertical en muro',
      estado: EstadoIncidenciaObra.abierta,
      prioridad: PrioridadIncidenciaObra.alta,
      fechaCreacion: date,
      fechaModificacion: date,
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          incidenciasObraRepositoryProvider.overrideWithValue(repository),
          incidenciasObraProvider.overrideWith(
            (ref, id) => Stream.value([incident]),
          ),
          documentosPorExpedienteProvider.overrideWith(
            (ref, id) => Stream.value([]),
          ),
          entradasDiarioObraProvider.overrideWith(
            (ref, id) => Stream.value([]),
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(body: IncidenciasObraTab(expedienteId: 'obra')),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Fisura detectada'), findsOneWidget);
    expect(find.text('Alta'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('nueva-incidencia')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('titulo-incidencia')),
      'Nueva incidencia',
    );
    await tester.enterText(
      find.byKey(const ValueKey('descripcion-incidencia')),
      'Descripción comprobable',
    );
    final save = find.byKey(const ValueKey('guardar-incidencia'));
    await tester.tap(save);
    await tester.tap(save);
    await tester.pump();
    expect(repository.createCalls, 1);
    repository.completeCreate();
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('estado-incidencia-incident')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Resuelta').last);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('resolucion-incidencia')),
      'Reparada',
    );
    await tester.tap(find.byKey(const ValueKey('confirmar-resolucion')));
    await tester.pumpAndSettle();
    expect(repository.stateCalls, 1);
    expect(repository.lastState, EstadoIncidenciaObra.resuelta);
    expect(repository.lastSolution, 'Reparada');
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}

class _FakeIncidentsRepository extends IncidenciasObraRepository {
  _FakeIncidentsRepository(super.database);

  final Completer<String> _createCompleter = Completer<String>();
  int createCalls = 0;
  int stateCalls = 0;
  EstadoIncidenciaObra? lastState;
  String? lastSolution;

  @override
  Future<String> crear({
    required String expedienteId,
    required DateTime fechaDeteccion,
    required String titulo,
    required String descripcion,
    required PrioridadIncidenciaObra prioridad,
    List<String> documentoIds = const [],
    List<String> entradaDiarioIds = const [],
  }) {
    createCalls++;
    return _createCompleter.future;
  }

  void completeCreate() => _createCompleter.complete('created');

  @override
  Future<void> cambiarEstado(
    String id,
    EstadoIncidenciaObra estado, {
    DateTime? fechaResolucion,
    String? resolucion,
  }) async {
    stateCalls++;
    lastState = estado;
    lastSolution = resolucion;
  }
}

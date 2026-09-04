import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/database/database_provider.dart';
import 'package:obraia_v2/features/mano_obra/data/mano_obra_repository.dart';
import 'package:obraia_v2/features/mano_obra/domain/mano_obra.dart';
import 'package:obraia_v2/features/mano_obra/presentation/widgets/mano_obra_tab.dart';

void main() {
  late AppDatabase database;
  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    await database.ensureReady();
    await database.expedientesDao.insertarExpediente(
      ExpedientesCompanion.insert(id: 'obra', codigo: 'OBR', nombre: 'Obra'),
    );
  });
  tearDown(() => database.close());

  Widget app() => ProviderScope(
    overrides: [databaseProvider.overrideWithValue(database)],
    child: const MaterialApp(
      home: Scaffold(body: ManoObraTab(expedienteId: 'obra')),
    ),
  );

  testWidgets(
    'muestra cobertura y exige una persona antes de registrar horas',
    (tester) async {
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
      expect(find.text('Mano de obra'), findsOneWidget);
      expect(find.textContaining('Cobertura: Sin horas'), findsOneWidget);
      expect(
        tester
            .widget<FilledButton>(
              find.widgetWithText(FilledButton, 'Registrar horas'),
            )
            .onPressed,
        isNull,
      );
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 1));
      await tester.pump(const Duration(milliseconds: 1));
    },
  );

  testWidgets('presenta coste valorado y tarifa interna sin precio de venta', (
    tester,
  ) async {
    final repository = ManoObraRepository(database);
    final persona = await repository.guardarPersona(
      nombre: 'Titular',
      tipo: TipoPersonaLaboral.titular,
    );
    await repository.agregarTarifa(
      personaId: persona,
      importeHoraCentimos: 2500,
      vigenteDesde: DateTime.utc(2026),
    );
    await repository.registrarParte(
      expedienteId: 'obra',
      personaId: persona,
      fechaTrabajo: DateTime.utc(2026, 9, 4),
      horasDiezMilesimas: 20000,
      descripcionTrabajo: 'Trabajo real',
    );
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    expect(find.textContaining('Coste real: 50.00 €'), findsOneWidget);
    expect(find.textContaining('tarifa congelada 25.00 €/h'), findsOneWidget);
    expect(find.textContaining('precio cobrado'), findsNothing);
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 1));
    await tester.pump(const Duration(milliseconds: 1));
  });
}

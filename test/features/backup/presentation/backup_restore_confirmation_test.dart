import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/features/backup/presentation/widgets/backup_restore_confirmation.dart';

void main() {
  Future<void> open(WidgetTester tester, void Function(bool?) result) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () async => result(
                await showBackupRestoreConfirmation(
                  context,
                  coverage: 'Paquete ficticio: SQLite y 1 original.',
                ),
              ),
              child: const Text('Abrir'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
  }

  testWidgets('cancelar devuelve false sin aceptar la restauración', (
    tester,
  ) async {
    bool? result;
    await open(tester, (value) => result = value);
    expect(find.textContaining('contadores fiscales'), findsOneWidget);
    expect(find.textContaining('no anula documentos'), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'Restaurar copia'),
          )
          .onPressed,
      isNull,
    );
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(result, isFalse);
  });

  testWidgets('exige reconocer el riesgo y permite retirar el reconocimiento', (
    tester,
  ) async {
    bool? result;
    await open(tester, (value) => result = value);
    final checkbox = find.byType(CheckboxListTile);
    await tester.ensureVisible(checkbox);
    await tester.tap(checkbox);
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'Restaurar copia'),
          )
          .onPressed,
      isNotNull,
    );
    await tester.tap(checkbox);
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'Restaurar copia'),
          )
          .onPressed,
      isNull,
    );
    expect(result, isNull);
    await tester.tap(checkbox);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Restaurar copia'));
    await tester.pumpAndSettle();
    expect(result, isTrue);
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    expect(tester.widget<CheckboxListTile>(checkbox).value, isFalse);
    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'Restaurar copia'),
          )
          .onPressed,
      isNull,
    );
  });

  testWidgets(
    'ventana pequeña permite leer, reconocer y cancelar sin overflow',
    (tester) async {
      tester.view.reset();
      tester.view.physicalSize = const Size(640, 480);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      bool? result;
      await open(tester, (value) => result = value);
      final checkbox = find.byType(CheckboxListTile);
      await tester.ensureVisible(checkbox);
      await tester.tap(checkbox);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();
      expect(result, isFalse);
    },
  );
}

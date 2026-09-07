import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/features/documentos/domain/documento.dart';
import 'package:obraia_v2/features/documentos/presentation/screens/editar_documento_screen.dart';

void main() {
  for (final protected in [false, true]) {
    testWidgets(
      protected
          ? 'original protegido identifica estado y bloquea ruta'
          : 'histórico identifica referencia externa',
      (tester) async {
        final document = Documento(
          id: 'doc',
          expedienteId: 'obra',
          titulo: 'Ficticio',
          nombreArchivo: 'original.txt',
          rutaArchivo: 'C:/ficticio/original.txt',
          mimeType: 'text/plain',
          tamanoBytes: 123,
          fecha: DateTime(2026),
          observaciones: null,
          tipo: DocumentoTipo.otro,
          rutaGestionada: protected ? 'gestionado' : null,
          sha256Original: protected ? 'hash' : null,
          incorporadoUtc: protected ? DateTime(2026) : null,
        );
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: EditarDocumentoScreen(documento: document),
            ),
          ),
        );
        expect(
          find.text(protected ? 'Protegido por OBRA IA' : 'Archivo externo'),
          findsOneWidget,
        );
        final fields = tester.widgetList<TextField>(find.byType(TextField));
        final pathField = fields.singleWhere(
          (field) => field.controller?.text == document.rutaArchivo,
        );
        expect(pathField.readOnly, protected);
        expect(tester.takeException(), isNull);
      },
    );
  }
}

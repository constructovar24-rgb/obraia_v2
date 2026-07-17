import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:obraia_v2/main.dart';

void main() {
  testWidgets('La aplicación inicia correctamente', (WidgetTester tester) async {
    await tester.pumpWidget(const ObraIAApp());

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
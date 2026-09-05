import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/features/que_toca_ahora/domain/recomendacion_operativa.dart';
import 'package:obraia_v2/features/que_toca_ahora/presentation/providers/que_toca_ahora_providers.dart';
import 'package:obraia_v2/features/que_toca_ahora/presentation/widgets/que_toca_ahora_panel.dart';

void main() {
  testWidgets('muestra explicación y navega a la acción sugerida', (
    tester,
  ) async {
    const recommendation = RecomendacionOperativa(
      reglaId: 'incidencia.alta_abierta',
      categoria: CategoriaRecomendacion.incidencia,
      prioridad: PrioridadRecomendacion.critica,
      titulo: 'Resolver incidencia prioritaria',
      explicacion: 'Hay una incidencia alta abierta.',
      accion: 'Abrir Incidencias',
      destino: 'incidencias',
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          recomendacionesExpedienteProvider.overrideWith(
            (ref, id) async => [recommendation],
          ),
        ],
        child: const MaterialApp(
          home: DefaultTabController(
            length: 14,
            child: Scaffold(
              body: Column(
                children: [
                  QueTocaAhoraPanel(expedienteId: 'obra'),
                  Expanded(
                    child: TabBarView(
                      children: [
                        SizedBox(),
                        SizedBox(),
                        SizedBox(),
                        SizedBox(),
                        SizedBox(),
                        SizedBox(),
                        SizedBox(),
                        SizedBox(),
                        SizedBox(),
                        SizedBox(),
                        SizedBox(),
                        SizedBox(),
                        SizedBox(),
                        Text('Incidencias destino'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Resolver incidencia prioritaria'), findsOneWidget);
    expect(find.text('Hay una incidencia alta abierta.'), findsOneWidget);
    await tester.tap(find.text('Abrir Incidencias'));
    await tester.pumpAndSettle();
    expect(find.text('Incidencias destino'), findsOneWidget);
  });
}

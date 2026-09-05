import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/features/planificacion/domain/planificacion_obra.dart';
import 'package:obraia_v2/features/planificacion/presentation/providers/planificacion_obra_providers.dart';
import 'package:obraia_v2/features/planificacion/presentation/widgets/planificacion_obra_tab.dart';

void main() {
  testWidgets('muestra estado, calendario, próximo paso y actuaciones', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          planificacionObraProvider.overrideWith(
            (ref, id) => Stream.value(
              PlanificacionObra(
                expedienteId: id,
                estado: EstadoOperativoObra.enEjecucion,
                inicioPrevisto: DateTime(2026, 9, 1),
                finPrevisto: DateTime(2026, 10, 1),
                inicioReal: DateTime(2026, 9, 2),
              ),
            ),
          ),
          actuacionesObraProvider.overrideWith(
            (ref, id) => Stream.value([
              ActuacionObra(
                id: 'next',
                expedienteId: id,
                tipo: TipoActuacionObra.proximoPaso,
                descripcion: 'Pedir material',
                estado: EstadoActuacionObra.pendiente,
                orden: 0,
              ),
              ActuacionObra(
                id: 'milestone',
                expedienteId: id,
                tipo: TipoActuacionObra.actuacion,
                descripcion: 'Hormigonar losa',
                estado: EstadoActuacionObra.pendiente,
                orden: 1,
              ),
            ]),
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(body: PlanificacionObraTab(expedienteId: 'obra')),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('En ejecución'), findsOneWidget);
    expect(find.text('Pedir material'), findsOneWidget);
    expect(find.text('Hormigonar losa'), findsOneWidget);
    expect(find.byKey(const ValueKey('editar-calendario')), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}

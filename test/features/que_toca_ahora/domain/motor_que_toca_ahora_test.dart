import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/features/que_toca_ahora/domain/motor_que_toca_ahora.dart';
import 'package:obraia_v2/features/que_toca_ahora/domain/recomendacion_operativa.dart';

void main() {
  const engine = MotorQueTocaAhora();
  final today = DateTime(2026, 9, 5);
  RecommendationContext context({
    bool budgets = true,
    bool accepted = true,
    bool draft = false,
    String state = 'enEjecucion',
    DateTime? start,
    String? next,
    int overdue = 0,
    int incidents = 0,
    int clientDue = 0,
    bool supplierDue = false,
    int notes = 0,
    int reconcile = 0,
    bool closed = false,
    int loss = 0,
  }) => RecommendationContext(
    expedienteId: 'obra',
    hoy: today,
    tienePresupuestos: budgets,
    tienePresupuestoAceptado: accepted,
    tienePresupuestoBorrador: draft,
    estadoOperativo: state,
    inicioPrevisto: start,
    proximoPaso: next,
    actuacionesVencidas: overdue,
    incidenciasAltasAbiertas: incidents,
    facturasClientePendientesCentimos: clientDue,
    facturaProveedorVencidaPendiente: supplierDue,
    albaranesPendientesFactura: notes,
    documentosPendientesReconciliar: reconcile,
    economiaCerrada: closed,
    perdidaPrevistaCentimos: loss,
  );
  Set<String> ids(RecommendationContext c) =>
      engine.calcular(c).map((e) => e.reglaId).toSet();

  test(
    'reglas comerciales, planificación y próximo paso son hechos explícitos',
    () {
      expect(
        ids(context(budgets: false, accepted: false)),
        contains('comercial.sin_presupuesto'),
      );
      expect(
        ids(context(accepted: false, draft: true)),
        contains('comercial.presupuesto_borrador'),
      );
      expect(
        ids(context(state: 'pendiente')),
        contains('planificacion.sin_inicio'),
      );
      expect(
        ids(context(state: 'preparada', start: DateTime(2026, 9, 4))),
        contains('planificacion.inicio_vencido'),
      );
      expect(
        ids(context(overdue: 1)),
        contains('planificacion.actuaciones_vencidas'),
      );
      expect(
        ids(context(next: 'Hormigonar losa')),
        contains('planificacion.proximo_paso_manual'),
      );
    },
  );

  test('incidencias, cobros, proveedores y economía respetan resolución', () {
    final all = ids(
      context(
        incidents: 1,
        clientDue: 72600,
        supplierDue: true,
        notes: 2,
        reconcile: 1,
        loss: 25000,
        state: 'finalizada',
      ),
    );
    expect(
      all,
      containsAll([
        'incidencia.alta_abierta',
        'cobros.saldo_pendiente',
        'proveedores.factura_vencida',
        'suministros.albaran_sin_factura',
        'economia.perdida_prevista',
        'cierre.obra_finalizada_abierta',
      ]),
    );
    final resolved = ids(
      context(
        incidents: 0,
        clientDue: 0,
        supplierDue: false,
        notes: 0,
        reconcile: 0,
        loss: 0,
        state: 'finalizada',
        closed: true,
      ),
    );
    expect(resolved, isNot(contains('incidencia.alta_abierta')));
    expect(resolved, isNot(contains('cierre.obra_finalizada_abierta')));
  });

  test('orden estable, explicable y cálculo sin mutación', () {
    final c = context(
      incidents: 1,
      loss: 1,
      clientDue: 1,
      next: 'Revisar replanteo',
    );
    final first = engine.calcular(c);
    final second = engine.calcular(c);
    expect(first.map((e) => e.reglaId), second.map((e) => e.reglaId));
    expect(
      first.take(2).every((e) => e.prioridad == PrioridadRecomendacion.critica),
      isTrue,
    );
    expect(
      first.every(
        (e) =>
            e.explicacion.isNotEmpty &&
            e.accion.isNotEmpty &&
            e.destino.isNotEmpty,
      ),
      isTrue,
    );
    expect(c.proximoPaso, 'Revisar replanteo');
  });

  test('legacy incompleto solo produce recomendaciones demostrables', () {
    final result = engine.calcular(
      RecommendationContext(expedienteId: 'legacy', hoy: today),
    );
    expect(result.map((e) => e.reglaId), ['comercial.sin_presupuesto']);
  });
}

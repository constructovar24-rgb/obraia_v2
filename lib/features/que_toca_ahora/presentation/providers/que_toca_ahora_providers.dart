import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../circuito_proveedor/presentation/providers/circuito_proveedor_providers.dart';
import '../../../economia/domain/cierre_economico.dart';
import '../../../economia/presentation/providers/cierre_economico_providers.dart';
import '../../../economia/presentation/providers/prevision_economica_providers.dart';
import '../../../expedientes/presentation/providers/expediente_workspace_providers.dart';
import '../../../incidencias/domain/incidencia_obra.dart';
import '../../../incidencias/presentation/providers/incidencias_obra_providers.dart';
import '../../../planificacion/domain/planificacion_obra.dart';
import '../../../planificacion/presentation/providers/planificacion_obra_providers.dart';
import '../../../presupuestos/presentation/providers/presupuesto_providers.dart';
import '../../domain/motor_que_toca_ahora.dart';
import '../../domain/recomendacion_operativa.dart';

final fechaActualRecomendacionesProvider = Provider<DateTime>(
  (ref) => DateTime.now(),
);
final recomendacionesExpedienteProvider =
    FutureProvider.family<List<RecomendacionOperativa>, String>((
      ref,
      expedienteId,
    ) async {
      final hoy = ref.watch(fechaActualRecomendacionesProvider);
      final presupuestos = await ref
          .watch(presupuestoRepositoryProvider)
          .observarPorExpediente(expedienteId)
          .first;
      final plan = await ref.watch(
        planificacionObraProvider(expedienteId).future,
      );
      final actuaciones = await ref.watch(
        actuacionesObraProvider(expedienteId).future,
      );
      final incidencias = await ref.watch(
        incidenciasObraProvider(expedienteId).future,
      );
      final facturas = await ref.watch(
        expedienteFacturaResumenProvider(expedienteId).future,
      );
      final cierre = await ref.watch(
        estadoCierreEconomicoProvider(expedienteId).future,
      );
      final forecast = await ref.watch(
        resumenForecastProvider(expedienteId).future,
      );
      final supply = await ref.watch(
        senalesSuministrosObraProvider(expedienteId).future,
      );
      final today = DateTime(hoy.year, hoy.month, hoy.day);
      final pendingActions = actuaciones.where(
        (a) =>
            a.tipo == TipoActuacionObra.actuacion &&
            a.estado == EstadoActuacionObra.pendiente,
      );
      final manual = actuaciones
          .where(
            (a) =>
                a.tipo == TipoActuacionObra.proximoPaso &&
                a.estado == EstadoActuacionObra.pendiente,
          )
          .firstOrNull;
      final accepted = presupuestos.any(
        (p) => p.estado.toLowerCase() == 'aceptado',
      );
      final draft = presupuestos.any(
        (p) => p.estado.toLowerCase() == 'borrador',
      );
      return const MotorQueTocaAhora().calcular(
        RecommendationContext(
          expedienteId: expedienteId,
          hoy: hoy,
          tienePresupuestos: presupuestos.isNotEmpty,
          tienePresupuestoAceptado: accepted,
          tienePresupuestoBorrador: draft,
          estadoOperativo:
              plan?.estado.name ?? EstadoOperativoObra.pendiente.name,
          inicioPrevisto: plan?.inicioPrevisto,
          proximoPaso: manual?.descripcion,
          actuacionesVencidas: pendingActions
              .where(
                (a) =>
                    a.fechaPrevista != null && a.fechaPrevista!.isBefore(today),
              )
              .length,
          incidenciasAltasAbiertas: incidencias
              .where(
                (i) =>
                    i.prioridad == PrioridadIncidenciaObra.alta &&
                    (i.estado == EstadoIncidenciaObra.abierta ||
                        i.estado == EstadoIncidenciaObra.enSeguimiento),
              )
              .length,
          facturasClientePendientesCentimos: (facturas.pendiente * 100).round(),
          facturaProveedorVencidaPendiente: supply.facturaVencidaPendiente,
          albaranesPendientesFactura: supply.albaranesPendientesFactura,
          documentosPendientesReconciliar:
              supply.imputacionesPendientesReconciliar,
          economiaCerrada: cierre.estado == EstadoEconomicoObra.cerrado,
          perdidaPrevistaCentimos:
              forecast.beneficioFinalEstimadoCentimos != null &&
                  forecast.beneficioFinalEstimadoCentimos! < 0
              ? -forecast.beneficioFinalEstimadoCentimos!
              : 0,
        ),
      );
    });

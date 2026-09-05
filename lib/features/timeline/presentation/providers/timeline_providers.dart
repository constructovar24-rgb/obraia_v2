import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../database/database_provider.dart';
import '../../data/timeline_repository.dart';
import '../../domain/timeline_event.dart';

class TimelineScope {
  const TimelineScope.global() : isGlobal = true, expedienteId = null;

  const TimelineScope.porExpediente(this.expedienteId) : isGlobal = false;

  final bool isGlobal;
  final String? expedienteId;

  @override
  bool operator ==(Object other) {
    return other is TimelineScope &&
        other.isGlobal == isGlobal &&
        other.expedienteId == expedienteId;
  }

  @override
  int get hashCode => Object.hash(isGlobal, expedienteId);
}

final timelineRepositoryProvider = Provider<TimelineRepository>((ref) {
  ref.watch(activeTenantIdProvider);
  final database = ref.watch(databaseProvider);
  return TimelineRepository(database.timelineEventsDao);
});

final timelineEventsProvider =
    StreamProvider.family<List<TimelineEvent>, String>((ref, expedienteId) {
      final timelineRepository = ref.watch(timelineRepositoryProvider);
      return timelineRepository.observarEventos(expedienteId);
    });

final timelineGlobalEventsProvider = StreamProvider<List<TimelineEvent>>((ref) {
  final timelineRepository = ref.watch(timelineRepositoryProvider);
  return timelineRepository.observarEventosGlobales();
});

final timelineFilterOptionsProvider = Provider<List<TimelineEventType>>((ref) {
  return TimelineEventType.values;
});

final timelineSelectedFilterProvider = StateProvider.autoDispose
    .family<TimelineEventType?, TimelineScope>((ref, scope) => null);

final _timelineBaseEventsProvider =
    Provider.family<AsyncValue<List<TimelineEvent>>, TimelineScope>((
      ref,
      scope,
    ) {
      if (scope.isGlobal) {
        return ref.watch(timelineGlobalEventsProvider);
      }

      return ref.watch(timelineEventsProvider(scope.expedienteId!));
    });

final timelineFilteredEventsProvider =
    Provider.family<AsyncValue<List<TimelineEvent>>, TimelineScope>((
      ref,
      scope,
    ) {
      final filtroSeleccionado = ref.watch(
        timelineSelectedFilterProvider(scope),
      );
      final eventosAsync = ref.watch(_timelineBaseEventsProvider(scope));

      return eventosAsync.whenData(
        (eventos) =>
            _filtrarEventos(eventos: eventos, filtro: filtroSeleccionado),
      );
    });

List<TimelineEvent> _filtrarEventos({
  required List<TimelineEvent> eventos,
  required TimelineEventType? filtro,
}) {
  if (filtro == null) {
    return eventos;
  }

  return eventos.where((evento) => evento.tipo == filtro).toList();
}

String timelineEventTypeLabel(TimelineEventType tipo) {
  switch (tipo) {
    case TimelineEventType.expedienteCreado:
      return 'Expediente creado';
    case TimelineEventType.expedienteActualizado:
      return 'Expediente actualizado';
    case TimelineEventType.presupuestoCreado:
      return 'Presupuesto creado';
    case TimelineEventType.presupuestoActualizado:
      return 'Presupuesto actualizado';
    case TimelineEventType.presupuestoAceptado:
      return 'Presupuesto aceptado';
    case TimelineEventType.facturaCreada:
      return 'Factura creada';
    case TimelineEventType.facturaEmitida:
      return 'Factura emitida';
    case TimelineEventType.facturaAnulada:
      return 'Factura anulada';
    case TimelineEventType.rectificativaCreada:
      return 'Rectificativa creada';
    case TimelineEventType.rectificativaEmitida:
      return 'Rectificativa emitida';
    case TimelineEventType.rectificativaAnulada:
      return 'Rectificativa anulada';
    case TimelineEventType.saldoFavorGenerado:
      return 'Saldo a favor generado';
    case TimelineEventType.cobroRegistrado:
      return 'Cobro registrado';
    case TimelineEventType.cobroEliminado:
      return 'Cobro eliminado';
    case TimelineEventType.cobroRevertido:
      return 'Cobro revertido';
    case TimelineEventType.devolucionRegistrada:
      return 'Devolución registrada';
    case TimelineEventType.devolucionRevertida:
      return 'Devolución revertida';
    case TimelineEventType.compensacionAplicada:
      return 'Compensación aplicada';
    case TimelineEventType.compensacionRecibida:
      return 'Compensación recibida';
    case TimelineEventType.compensacionRevertida:
      return 'Compensación revertida';
    case TimelineEventType.facturaBorradorEliminada:
      return 'Factura borrador eliminada';
    case TimelineEventType.documentoSubido:
      return 'Documento subido';
    case TimelineEventType.fotografiaAnadida:
      return 'Fotografia anadida';
    case TimelineEventType.notaCreada:
      return 'Nota creada';
    case TimelineEventType.compraRegistrada:
      return 'Compra registrada';
    case TimelineEventType.compraCosteConfirmado:
      return 'Compra confirmada como coste';
    case TimelineEventType.compraCosteRevertido:
      return 'Coste de compra revertido';
    case TimelineEventType.compraCosteAjustado:
      return 'Coste de compra ajustado';
    case TimelineEventType.horasTrabajoRegistradas:
      return 'Horas registradas';
    case TimelineEventType.costeLaboralConfirmado:
      return 'Coste laboral confirmado';
    case TimelineEventType.parteTrabajoRevertido:
      return 'Parte de trabajo revertido';
    case TimelineEventType.compromisoEconomicoCreado:
      return 'Compromiso económico creado';
    case TimelineEventType.compromisoEconomicoAjustado:
      return 'Compromiso económico ajustado';
    case TimelineEventType.compromisoEconomicoCancelado:
      return 'Compromiso económico cancelado';
    case TimelineEventType.compromisoEconomicoConsumido:
      return 'Compromiso económico consumido';
    case TimelineEventType.estimacionCosteRestanteActualizada:
      return 'Estimación de coste restante actualizada';
  }
}

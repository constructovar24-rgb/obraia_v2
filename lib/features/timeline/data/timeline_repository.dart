import '../../../database/dao/timeline_events_dao.dart';
import '../domain/timeline_event.dart';
import 'timeline_event_mapper.dart';
import 'package:uuid/uuid.dart';

class TimelineRepository {
  TimelineRepository(this._dao);

  final TimelineEventsDao _dao;
  final _uuid = const Uuid();

  Future<void> registrarEvento(TimelineEvent event) {
    return _dao.insertar(event.toCompanion());
  }

  Future<List<TimelineEvent>> obtenerEventosGlobales({
    int limit = TimelineEventsDao.defaultGlobalLimit,
  }) async {
    final rows = await _dao.obtenerRecientesGlobales(limit: limit);
    return rows.map((row) => row.toDomain()).toList();
  }

  Stream<List<TimelineEvent>> observarEventosGlobales({
    int limit = TimelineEventsDao.defaultGlobalLimit,
  }) {
    return _dao.observarRecientesGlobales(limit: limit).map(
      (rows) => rows.map((row) => row.toDomain()).toList(),
    );
  }

  Future<List<TimelineEvent>> obtenerEventos(String expedienteId) async {
    final rows = await _dao.obtenerPorExpediente(expedienteId);
    return rows.map((row) => row.toDomain()).toList();
  }

  Stream<List<TimelineEvent>> observarEventos(String expedienteId) {
    return _dao.observarPorExpediente(expedienteId).map(
      (rows) => rows.map((row) => row.toDomain()).toList(),
    );
  }

  Future<void> eliminarEventos(String expedienteId) {
    return _dao.eliminarPorExpediente(expedienteId);
  }

  Future<void> registrarExpedienteCreado({
    required String expedienteId,
    required String titulo,
    String? descripcion,
    DateTime? fecha,
  }) {
    return _registrar(
      expedienteId: expedienteId,
      tipo: TimelineEventType.expedienteCreado,
      titulo: titulo,
      descripcion: descripcion,
      fecha: fecha,
    );
  }

  Future<void> registrarExpedienteActualizado({
    required String expedienteId,
    required String titulo,
    String? descripcion,
    DateTime? fecha,
  }) {
    return _registrar(
      expedienteId: expedienteId,
      tipo: TimelineEventType.expedienteActualizado,
      titulo: titulo,
      descripcion: descripcion,
      fecha: fecha,
    );
  }

  Future<void> registrarPresupuestoCreado({
    required String expedienteId,
    required String presupuestoId,
    required String titulo,
    String? descripcion,
    DateTime? fecha,
  }) {
    return _registrar(
      expedienteId: expedienteId,
      tipo: TimelineEventType.presupuestoCreado,
      titulo: titulo,
      descripcion: descripcion,
      referenciaId: presupuestoId,
      fecha: fecha,
    );
  }

  Future<void> registrarPresupuestoAceptado({
    required String expedienteId,
    required String presupuestoId,
    required String titulo,
    String? descripcion,
    DateTime? fecha,
  }) {
    return _registrar(
      expedienteId: expedienteId,
      tipo: TimelineEventType.presupuestoAceptado,
      titulo: titulo,
      descripcion: descripcion,
      referenciaId: presupuestoId,
      fecha: fecha,
    );
  }

  Future<void> registrarFacturaCreada({
    required String expedienteId,
    required String facturaId,
    required String titulo,
    String? descripcion,
    DateTime? fecha,
  }) {
    return _registrarEventoNegocioUnico(
      expedienteId: expedienteId,
      tipo: TimelineEventType.facturaCreada,
      titulo: titulo,
      descripcion: descripcion,
      referenciaId: facturaId,
      fecha: fecha,
    );
  }

  Future<void> registrarFacturaAnulada({
    required String expedienteId,
    required String facturaId,
    required String titulo,
    String? descripcion,
    DateTime? fecha,
  }) {
    return _registrarEventoNegocioUnico(
      expedienteId: expedienteId,
      tipo: TimelineEventType.facturaAnulada,
      titulo: titulo,
      descripcion: descripcion,
      referenciaId: facturaId,
      fecha: fecha,
    );
  }

  Future<void> registrarCobroRegistrado({
    required String expedienteId,
    required String cobroId,
    required String titulo,
    String? descripcion,
    DateTime? fecha,
  }) {
    return _registrar(
      expedienteId: expedienteId,
      tipo: TimelineEventType.cobroRegistrado,
      titulo: titulo,
      descripcion: descripcion,
      referenciaId: cobroId,
      fecha: fecha,
    );
  }

  Future<void> registrarCompraRegistrada({
    required String expedienteId,
    required String compraId,
    required String titulo,
    String? descripcion,
    DateTime? fecha,
  }) {
    return _registrar(
      expedienteId: expedienteId,
      tipo: TimelineEventType.compraRegistrada,
      titulo: titulo,
      descripcion: descripcion,
      referenciaId: compraId,
      fecha: fecha,
    );
  }

  Future<void> _registrar({
    required String expedienteId,
    required TimelineEventType tipo,
    required String titulo,
    String? descripcion,
    String? referenciaId,
    DateTime? fecha,
  }) {
    final event = TimelineEvent(
      id: _uuid.v4(),
      expedienteId: expedienteId,
      fecha: fecha ?? DateTime.now(),
      tipo: tipo,
      titulo: titulo,
      descripcion: descripcion,
      referenciaId: referenciaId,
    );

    return registrarEvento(event);
  }

  Future<void> _registrarEventoNegocioUnico({
    required String expedienteId,
    required TimelineEventType tipo,
    required String titulo,
    String? descripcion,
    required String referenciaId,
    DateTime? fecha,
  }) async {
    final yaExiste = await _existeEventoPorReferencia(
      expedienteId: expedienteId,
      tipo: tipo,
      referenciaId: referenciaId,
    );
    if (yaExiste) {
      return;
    }

    await _registrar(
      expedienteId: expedienteId,
      tipo: tipo,
      titulo: titulo,
      descripcion: descripcion,
      referenciaId: referenciaId,
      fecha: fecha,
    );
  }

  Future<bool> _existeEventoPorReferencia({
    required String expedienteId,
    required TimelineEventType tipo,
    required String referenciaId,
  }) async {
    final eventos = await _dao.obtenerPorExpediente(expedienteId);

    for (final evento in eventos) {
      if (evento.tipo == tipo.name && evento.referenciaId == referenciaId) {
        return true;
      }
    }

    return false;
  }
}

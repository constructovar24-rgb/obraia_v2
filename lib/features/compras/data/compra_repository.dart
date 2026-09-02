import '../../../database/dao/compras_dao.dart';
import '../../timeline/data/timeline_repository.dart';
import '../domain/compra.dart';
import 'compra_mapper.dart';

class CompraRepository {
  CompraRepository(this._dao, this._timelineRepository);

  final ComprasDao _dao;
  final TimelineRepository _timelineRepository;

  Future<void> registrarCompra(Compra compra) async {
    await _dao.insertarCompra(compra.toCompanion());

    await _timelineRepository.registrarCompraRegistrada(
      expedienteId: compra.expedienteId,
      compraId: compra.id,
      titulo: 'Compra registrada',
      descripcion: compra.concepto,
      fecha: compra.fecha,
    );
  }

  Future<void> actualizarCompra(Compra compra) {
    return _dao.actualizarCompra(compra.id, compra.toCompanion());
  }

  Future<List<Compra>> obtenerCompras(String expedienteId) async {
    final rows = await _dao.obtenerPorExpediente(expedienteId);
    return rows.map((row) => row.toDomain()).toList();
  }

  Stream<List<Compra>> observarCompras(String expedienteId) {
    return _dao
        .observarPorExpediente(expedienteId)
        .map((rows) => rows.map((row) => row.toDomain()).toList());
  }

  Stream<List<Compra>> observarTodas() {
    return _dao.observarTodas().map(
      (rows) => rows.map((row) => row.toDomain()).toList(),
    );
  }

  Future<void> eliminarCompra(String compraId) {
    return _dao.eliminarLogicamente(compraId);
  }
}

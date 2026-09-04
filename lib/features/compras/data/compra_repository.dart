import '../../../database/app_database.dart' hide Compra;
import '../../economia/data/hecho_coste_repository.dart';
import '../../timeline/data/timeline_repository.dart';
import '../domain/compra.dart';
import 'compra_mapper.dart';

class CompraRepository {
  CompraRepository(this.database)
    : _timelineRepository = TimelineRepository(database.timelineEventsDao),
      _hechoCosteRepository = HechoCosteRepository(database);

  final AppDatabase database;
  final TimelineRepository _timelineRepository;
  final HechoCosteRepository _hechoCosteRepository;

  Future<void> registrarCompra(Compra compra) async {
    await database.transaction(() async {
      await database.comprasDao.insertarCompra(compra.toCompanion());
      await _timelineRepository.registrarCompraRegistrada(
        expedienteId: compra.expedienteId,
        compraId: compra.id,
        titulo: 'Compra registrada',
        descripcion: compra.concepto,
        fecha: compra.fecha,
      );
    });
  }

  Future<void> actualizarCompra(Compra compra) async {
    final actual = await database.comprasDao.obtenerPorId(compra.id);
    if (actual == null) throw StateError('La compra no existe.');
    if (actual.clasificacionEconomica != 'provisional') {
      throw StateError(
        'Una compra con impacto económico no puede editarse sin reversión.',
      );
    }
    await database.comprasDao.actualizarCompra(compra.id, compra.toCompanion());
  }

  Future<List<Compra>> obtenerCompras(String expedienteId) async {
    final rows = await database.comprasDao.obtenerPorExpediente(expedienteId);
    return rows.map((row) => row.toDomain()).toList();
  }

  Stream<List<Compra>> observarCompras(String expedienteId) {
    return database.comprasDao
        .observarPorExpediente(expedienteId)
        .map((rows) => rows.map((row) => row.toDomain()).toList());
  }

  Stream<List<Compra>> observarTodas() {
    return database.comprasDao.observarTodas().map(
      (rows) => rows.map((row) => row.toDomain()).toList(),
    );
  }

  Future<void> confirmarComoGasto({
    required String compraId,
    String? categoriaEconomicaId,
  }) => _hechoCosteRepository.confirmarCompra(
    compraId: compraId,
    categoriaEconomicaId: categoriaEconomicaId,
  );

  Future<void> revertirCoste(String compraId, {required String motivo}) =>
      _hechoCosteRepository.revertirCompra(compraId, motivo: motivo);

  Future<void> eliminarCompra(String compraId) =>
      database.transaction(() async {
        final compra = await database.comprasDao.obtenerPorId(compraId);
        if (compra == null) return;
        if (compra.clasificacionEconomica == 'incurrido') {
          await _hechoCosteRepository.revertirCompra(
            compraId,
            motivo: 'Reversión por eliminación lógica de la compra.',
          );
        }
        await database.comprasDao.eliminarLogicamente(compraId);
      });
}

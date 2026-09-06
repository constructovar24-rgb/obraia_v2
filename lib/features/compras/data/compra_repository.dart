import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../timeline/domain/timeline_event.dart';
import '../../../database/app_database.dart' hide Compra, TimelineEvent;
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

  Future<void> actualizarCompra(Compra compra) =>
      database.transaction(() async {
        final actual = await database.comprasDao.obtenerPorId(compra.id);
        if (actual == null) throw StateError('La compra no existe.');
        if (actual.clasificacionEconomica != 'provisional') {
          throw StateError(
            'Una compra con impacto económico no puede editarse sin reversión.',
          );
        }
        await database.comprasDao.actualizarCompra(
          compra.id,
          compra.toCompanion(),
        );
      });

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
      database.transaction(() async {
        if (await database.circuitoProveedorDao.compraVinculada(compraId)) {
          throw StateError(
            'Corrige el coste desde la factura recibida vinculada.',
          );
        }
        await _hechoCosteRepository.revertirCompra(compraId, motivo: motivo);
      });

  Future<void> eliminarCompra(String compraId) =>
      database.transaction(() async {
        final compra = await database.comprasDao.obtenerPorId(compraId);
        if (compra == null) return;
        if (compra.clasificacionEconomica != 'provisional') {
          throw StateError(
            'El gasto consolidado se conserva. Usa la reversión con motivo.',
          );
        }
        await database.comprasDao.eliminarLogicamente(compraId);
      });

  Future<void> corregirEstadoPago(
    String id,
    CompraEstado estado, {
    required String motivo,
  }) => database.transaction(() async {
    final actual = await database.comprasDao.obtenerPorId(id);
    if (actual == null ||
        actual.eliminado ||
        actual.clasificacionEconomica == 'anulada') {
      throw StateError('Compra no disponible.');
    }
    if (motivo.trim().isEmpty) throw ArgumentError('Indica el motivo.');
    if (estado == CompraEstado.anulada ||
        estado == CompraEstado.parcialmentePagada) {
      throw StateError(
        'La anulación afecta al coste; los pagos parciales se gestionan desde Facturas recibidas.',
      );
    }
    if (await database.circuitoProveedorDao.compraVinculada(id)) {
      throw StateError(
        'Gestiona los pagos desde la factura recibida vinculada.',
      );
    }
    await database.comprasDao.actualizarCompra(
      id,
      ComprasCompanion(estado: Value(estado.name)),
    );
    await _timelineRepository.registrarEvento(
      TimelineEvent(
        id: const Uuid().v4(),
        expedienteId: actual.expedienteId,
        fecha: DateTime.now().toUtc(),
        tipo: TimelineEventType.proveedorOperacion,
        titulo: 'Estado de pago de compra corregido',
        descripcion:
            'Operador local · ${actual.estado} → ${estado.name} · ${motivo.trim()}',
        referenciaId: id,
      ),
    );
  });
}

import 'package:drift/drift.dart';

import '../../features/creditos_cliente/domain/credito_cliente.dart' as domain;
import '../app_database.dart';
import '../tables/movimientos_credito_cliente.dart';

part 'movimientos_credito_cliente_dao.g.dart';

@DriftAccessor(tables: [MovimientosCreditoCliente])
class MovimientosCreditoClienteDao extends DatabaseAccessor<AppDatabase>
    with _$MovimientosCreditoClienteDaoMixin {
  MovimientosCreditoClienteDao(super.db);

  domain.MovimientoCreditoCliente _map(MovimientosCreditoClienteData row) =>
      domain.MovimientoCreditoCliente(
        id: row.id,
        clienteId: row.clienteId,
        facturaRaizOrigenId: row.facturaRaizOrigenId,
        tipo: domain.TipoMovimientoCreditoCliente.values.byName(
          row.tipoMovimiento,
        ),
        importe: row.importe,
        fecha: row.fecha,
        movimientoOrigenId: row.movimientoOrigenId,
        facturaRaizDestinoId: row.facturaRaizDestinoId,
        metodo: row.metodo,
        referencia: row.referencia,
        motivo: row.motivo,
        observaciones: row.observaciones,
      );

  Future<void> insertar(MovimientosCreditoClienteCompanion movimiento) =>
      into(movimientosCreditoCliente).insert(
        movimiento.copyWith(tenantId: Value(attachedDatabase.activeTenantId)),
      );

  Future<domain.MovimientoCreditoCliente?> obtener(String id) async {
    final row =
        await (select(movimientosCreditoCliente)..where(
              (t) =>
                  t.tenantId.equals(attachedDatabase.activeTenantId) &
                  t.id.equals(id),
            ))
            .getSingleOrNull();
    return row == null ? null : _map(row);
  }

  Future<List<domain.MovimientoCreditoCliente>> obtenerTodos() async =>
      (await (select(movimientosCreditoCliente)..where(
                (t) => t.tenantId.equals(attachedDatabase.activeTenantId),
              ))
              .get())
          .map(_map)
          .toList();

  Stream<List<domain.MovimientoCreditoCliente>> observarPorFamilia(
    String facturaRaizId,
  ) =>
      (select(movimientosCreditoCliente)
            ..where(
              (t) =>
                  t.tenantId.equals(attachedDatabase.activeTenantId) &
                  (t.facturaRaizOrigenId.equals(facturaRaizId) |
                      t.facturaRaizDestinoId.equals(facturaRaizId)),
            )
            ..orderBy([(t) => OrderingTerm.desc(t.fechaCreacion)]))
          .watch()
          .map((rows) => rows.map(_map).toList());
}

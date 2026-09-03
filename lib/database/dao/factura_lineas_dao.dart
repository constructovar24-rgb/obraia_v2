import 'package:drift/drift.dart';

import '../../features/facturas/domain/factura_linea.dart'
    as factura_linea_domain;
import '../app_database.dart';
import '../tables/factura_lineas.dart';

part 'factura_lineas_dao.g.dart';

@DriftAccessor(tables: [FacturaLineas])
class FacturaLineasDao extends DatabaseAccessor<AppDatabase>
    with _$FacturaLineasDaoMixin {
  FacturaLineasDao(super.db);

  factura_linea_domain.FacturaLinea _toDomain(FacturaLinea row) {
    return factura_linea_domain.FacturaLinea(
      id: row.id,
      facturaId: row.facturaId,
      lineaRectificadaId: row.lineaRectificadaId,
      lineaRaizId: row.lineaRaizId,
      descripcion: row.descripcion,
      cantidad: row.cantidad,
      unidad: row.unidad,
      precioUnitario: row.precioUnitario,
      descuento: row.descuento,
      importe: row.importe,
    );
  }

  Future<List<factura_linea_domain.FacturaLinea>> obtenerPorFactura(
    String facturaId,
  ) async {
    final rows =
        await (select(facturaLineas)..where(
              (t) =>
                  t.tenantId.equals(attachedDatabase.activeTenantId) &
                  t.facturaId.equals(facturaId),
            ))
            .get();

    return rows.map(_toDomain).toList();
  }

  Future<List<factura_linea_domain.FacturaLinea>> obtenerPorFacturas(
    Iterable<String> facturaIds,
  ) async {
    final ids = facturaIds.toList();
    if (ids.isEmpty) return const [];
    final rows =
        await (select(facturaLineas)..where(
              (t) =>
                  t.tenantId.equals(attachedDatabase.activeTenantId) &
                  t.facturaId.isIn(ids),
            ))
            .get();
    return rows.map(_toDomain).toList();
  }

  Stream<List<factura_linea_domain.FacturaLinea>> observarPorFactura(
    String facturaId,
  ) {
    return (select(facturaLineas)..where(
          (t) =>
              t.tenantId.equals(attachedDatabase.activeTenantId) &
              t.facturaId.equals(facturaId),
        ))
        .watch()
        .map((rows) => rows.map(_toDomain).toList());
  }

  Future<void> insertarLinea(FacturaLineasCompanion linea) async {
    await into(
      facturaLineas,
    ).insert(linea.copyWith(tenantId: Value(attachedDatabase.activeTenantId)));
  }

  Future<void> actualizarLinea(String id, FacturaLineasCompanion linea) async {
    await (update(facturaLineas)..where(
          (t) =>
              t.tenantId.equals(attachedDatabase.activeTenantId) &
              t.id.equals(id),
        ))
        .write(linea);
  }

  Future<void> eliminarLinea(String id) async {
    await (delete(facturaLineas)..where(
          (t) =>
              t.tenantId.equals(attachedDatabase.activeTenantId) &
              t.id.equals(id),
        ))
        .go();
  }

  Future<void> eliminarPorFactura(String facturaId) async {
    await (delete(facturaLineas)..where(
          (t) =>
              t.tenantId.equals(attachedDatabase.activeTenantId) &
              t.facturaId.equals(facturaId),
        ))
        .go();
  }
}

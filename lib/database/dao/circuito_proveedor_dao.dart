import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/circuito_proveedor.dart';

part 'circuito_proveedor_dao.g.dart';

@DriftAccessor(
  tables: [
    AlbaranesProveedor,
    LineasAlbaranProveedor,
    AsignacionesAlbaranObra,
    FacturasRecibidas,
    FacturaRecibidaAlbaranes,
    AsignacionesFacturaRecibida,
    FacturaRecibidaCompras,
    PagosProveedor,
  ],
)
class CircuitoProveedorDao extends DatabaseAccessor<AppDatabase>
    with _$CircuitoProveedorDaoMixin {
  CircuitoProveedorDao(super.db);
  String get _tenant => attachedDatabase.activeTenantId;

  Future<void> insertarAlbaran(AlbaranesProveedorCompanion value) =>
      into(albaranesProveedor).insert(value.copyWith(tenantId: Value(_tenant)));
  Future<void> insertarLinea(LineasAlbaranProveedorCompanion value) => into(
    lineasAlbaranProveedor,
  ).insert(value.copyWith(tenantId: Value(_tenant)));
  Future<void> insertarAsignacionAlbaran(
    AsignacionesAlbaranObraCompanion value,
  ) => into(
    asignacionesAlbaranObra,
  ).insert(value.copyWith(tenantId: Value(_tenant)));
  Future<void> insertarFactura(FacturasRecibidasCompanion value) =>
      into(facturasRecibidas).insert(value.copyWith(tenantId: Value(_tenant)));
  Future<void> vincularAlbaran(FacturaRecibidaAlbaranesCompanion value) => into(
    facturaRecibidaAlbaranes,
  ).insert(value.copyWith(tenantId: Value(_tenant)));
  Future<void> insertarAsignacionFactura(
    AsignacionesFacturaRecibidaCompanion value,
  ) => into(
    asignacionesFacturaRecibida,
  ).insert(value.copyWith(tenantId: Value(_tenant)));
  Future<void> vincularCompra(FacturaRecibidaComprasCompanion value) => into(
    facturaRecibidaCompras,
  ).insert(value.copyWith(tenantId: Value(_tenant)));
  Future<void> insertarPago(PagosProveedorCompanion value) =>
      into(pagosProveedor).insert(value.copyWith(tenantId: Value(_tenant)));

  Future<FacturasRecibida?> factura(String id) =>
      (select(facturasRecibidas)
            ..where((t) => t.tenantId.equals(_tenant) & t.id.equals(id)))
          .getSingleOrNull();
  Future<AlbaranesProveedorData?> albaran(String id) =>
      (select(albaranesProveedor)
            ..where((t) => t.tenantId.equals(_tenant) & t.id.equals(id)))
          .getSingleOrNull();
  Future<AsignacionesFacturaRecibidaData?> asignacionFactura(String id) =>
      (select(asignacionesFacturaRecibida)
            ..where((t) => t.tenantId.equals(_tenant) & t.id.equals(id)))
          .getSingleOrNull();
  Future<FacturaRecibidaCompra?> reconciliacion(String asignacionId) =>
      (select(facturaRecibidaCompras)..where(
            (t) =>
                t.tenantId.equals(_tenant) &
                t.asignacionId.equals(asignacionId),
          ))
          .getSingleOrNull();
  Future<int> totalPagado(String facturaId) async =>
      (await (select(pagosProveedor)..where(
                (t) =>
                    t.tenantId.equals(_tenant) & t.facturaId.equals(facturaId),
              ))
              .get())
          .fold<int>(0, (a, b) => a + b.importeCentimos);
  Future<void> actualizarEstadoFactura(String id, String estado) =>
      (update(
        facturasRecibidas,
      )..where((t) => t.tenantId.equals(_tenant) & t.id.equals(id))).write(
        FacturasRecibidasCompanion(
          estado: Value(estado),
          fechaModificacion: Value(DateTime.now().toUtc()),
        ),
      );
  Stream<List<AlbaranesProveedorData>> observarAlbaranesObra(
    String expedienteId,
  ) {
    final q =
        select(albaranesProveedor).join([
            innerJoin(
              lineasAlbaranProveedor,
              lineasAlbaranProveedor.tenantId.equalsExp(
                    albaranesProveedor.tenantId,
                  ) &
                  lineasAlbaranProveedor.albaranId.equalsExp(
                    albaranesProveedor.id,
                  ),
            ),
            innerJoin(
              asignacionesAlbaranObra,
              asignacionesAlbaranObra.tenantId.equalsExp(
                    lineasAlbaranProveedor.tenantId,
                  ) &
                  asignacionesAlbaranObra.lineaAlbaranId.equalsExp(
                    lineasAlbaranProveedor.id,
                  ),
            ),
          ])
          ..where(
            albaranesProveedor.tenantId.equals(_tenant) &
                asignacionesAlbaranObra.expedienteId.equals(expedienteId),
          )
          ..orderBy([OrderingTerm.desc(albaranesProveedor.fecha)]);
    return q.watch().map(
      (rows) => {
        for (final r in rows)
          r.readTable(albaranesProveedor).id: r.readTable(albaranesProveedor),
      }.values.toList(),
    );
  }

  Stream<List<AsignacionesFacturaRecibidaData>> observarAsignacionesFacturaObra(
    String expedienteId,
  ) =>
      (select(asignacionesFacturaRecibida)..where(
            (t) =>
                t.tenantId.equals(_tenant) &
                t.expedienteId.equals(expedienteId),
          ))
          .watch();

  Future<List<QueryRow>> senalesObra(String expedienteId) => customSelect(
    '''SELECT fr.fecha_vencimiento, fr.estado,
              CASE WHEN frc.compra_id IS NULL THEN 0 ELSE 1 END AS reconciliada
       FROM asignaciones_factura_recibida afr
       JOIN facturas_recibidas fr ON fr.tenant_id = afr.tenant_id AND fr.id = afr.factura_id
       LEFT JOIN factura_recibida_compras frc ON frc.tenant_id = afr.tenant_id AND frc.asignacion_id = afr.id
       WHERE afr.tenant_id = ? AND afr.expediente_id = ?''',
    variables: [Variable<String>(_tenant), Variable<String>(expedienteId)],
    readsFrom: {
      asignacionesFacturaRecibida,
      facturasRecibidas,
      facturaRecibidaCompras,
    },
  ).get();

  Future<int> albaranesPendientesObra(String expedienteId) async {
    final row = await customSelect(
      '''SELECT COUNT(DISTINCT ap.id) AS total
         FROM albaranes_proveedor ap
         JOIN lineas_albaran_proveedor lap ON lap.tenant_id = ap.tenant_id AND lap.albaran_id = ap.id
         JOIN asignaciones_albaran_obra aa ON aa.tenant_id = lap.tenant_id AND aa.linea_albaran_id = lap.id
         LEFT JOIN factura_recibida_albaranes fra ON fra.tenant_id = ap.tenant_id AND fra.albaran_id = ap.id
         WHERE ap.tenant_id = ? AND aa.expediente_id = ? AND ap.estado IN ('recibido','revisado') AND fra.factura_id IS NULL''',
      variables: [Variable<String>(_tenant), Variable<String>(expedienteId)],
      readsFrom: {
        albaranesProveedor,
        lineasAlbaranProveedor,
        asignacionesAlbaranObra,
        facturaRecibidaAlbaranes,
      },
    ).getSingle();
    return row.read<int>('total');
  }
}

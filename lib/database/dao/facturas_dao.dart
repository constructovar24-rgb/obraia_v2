import 'package:drift/drift.dart';

import '../../features/facturas/domain/estado_factura.dart';
import '../../features/facturas/domain/factura.dart' as factura_domain;
import '../../features/facturas/domain/tipo_documento_factura.dart';
import '../app_database.dart';
import '../tables/clientes.dart';
import '../tables/facturas.dart';
import '../tables/presupuestos.dart';

part 'facturas_dao.g.dart';

@DriftAccessor(tables: [Facturas, Clientes, Presupuestos])
class FacturasDao extends DatabaseAccessor<AppDatabase>
    with _$FacturasDaoMixin {
  FacturasDao(super.db);

  factura_domain.Factura _toDomain(Factura row, {String clienteNombre = ''}) {
    return factura_domain.Factura(
      id: row.id,
      codigo: row.codigo,
      anioNumeracion: row.anioNumeracion,
      numeroLegal: row.numeroLegal,
      tipoDocumento: tipoDocumentoFacturaFromString(row.tipoDocumento),
      serie: row.serie,
      facturaRectificadaId: row.facturaRectificadaId,
      facturaRaizId: row.facturaRaizId,
      modalidadRectificacion: modalidadRectificacionFromString(
        row.modalidadRectificacion,
      ),
      motivoRectificacion: row.motivoRectificacion,
      efectoBase: row.efectoBase,
      efectoIva: row.efectoIva,
      efectoTotal: row.efectoTotal,
      clienteId: row.clienteId,
      clienteNombre: clienteNombre,
      fecha: row.fecha,
      fechaVencimiento: row.fechaVencimiento,
      estado: estadoFacturaFromString(row.estado),
      subtotal: row.subtotal,
      iva: row.iva,
      ivaPorcentaje: row.ivaPorcentaje,
      total: row.total,
      observaciones: row.observaciones,
      presupuestoOrigenId: row.presupuestoOrigenId,
      fechaEmision: row.fechaEmision,
      clienteNombreHistorico: row.clienteNombreHistorico,
      clienteNifHistorico: row.clienteNifHistorico,
      clienteDireccionHistorica: row.clienteDireccionHistorica,
      clienteTelefonoHistorico: row.clienteTelefonoHistorico,
      clienteEmailHistorico: row.clienteEmailHistorico,
      empresaNombreHistorico: row.empresaNombreHistorico,
      empresaCifHistorico: row.empresaCifHistorico,
      empresaDireccionHistorica: row.empresaDireccionHistorica,
      empresaCodigoPostalHistorico: row.empresaCodigoPostalHistorico,
      empresaPoblacionHistorica: row.empresaPoblacionHistorica,
      empresaProvinciaHistorica: row.empresaProvinciaHistorica,
      empresaTelefonoHistorico: row.empresaTelefonoHistorico,
      empresaEmailHistorico: row.empresaEmailHistorico,
      empresaWebHistorica: row.empresaWebHistorica,
      expedienteOrigenIdHistorico: row.expedienteOrigenIdHistorico,
      expedienteCodigoHistorico: row.expedienteCodigoHistorico,
      expedienteNombreHistorico: row.expedienteNombreHistorico,
      presupuestoCodigoHistorico: row.presupuestoCodigoHistorico,
    );
  }

  Future<List<String>> obtenerCodigosPorCliente(String clienteId) async {
    final rows = await (select(
      facturas,
    )..where((t) => t.clienteId.equals(clienteId))).get();

    return rows.map((row) => row.codigo).toList();
  }

  Future<List<String>> obtenerCodigosPorPrefijo(String prefijo) async {
    final rows = await (select(
      facturas,
    )..where((t) => t.codigo.like('$prefijo%'))).get();

    return rows.map((row) => row.codigo).toList();
  }

  Future<int> obtenerMayorNumeroLegal(int anio, {String serie = 'FAC'}) async {
    final result = await customSelect(
      'SELECT MAX(numero_legal) AS maximo FROM facturas '
      'WHERE anio_numeracion = ? AND serie = ?',
      variables: [Variable<int>(anio), Variable<String>(serie)],
    ).getSingle();
    return result.readNullable<int>('maximo') ?? 0;
  }

  Stream<List<factura_domain.Factura>> observarFacturas() {
    final tableFacturas = attachedDatabase.facturas;
    final tableClientes = attachedDatabase.clientes;

    final query = select(tableFacturas).join([
      leftOuterJoin(
        tableClientes,
        tableClientes.id.equalsExp(tableFacturas.clienteId),
      ),
    ])..orderBy([OrderingTerm.desc(tableFacturas.fecha)]);

    return query.watch().map((rows) {
      return rows.map((row) {
        final factura = row.readTable(tableFacturas);
        final cliente = row.readTableOrNull(tableClientes);
        final clienteNombre = cliente == null
            ? ''
            : '${cliente.nombre} ${cliente.apellidos}'.trim();

        return _toDomain(factura, clienteNombre: clienteNombre);
      }).toList();
    });
  }

  Stream<List<factura_domain.Factura>> observarPorCliente(String clienteId) {
    final tableFacturas = attachedDatabase.facturas;
    final tableClientes = attachedDatabase.clientes;

    final query =
        select(tableFacturas).join([
            leftOuterJoin(
              tableClientes,
              tableClientes.id.equalsExp(tableFacturas.clienteId),
            ),
          ])
          ..where(tableFacturas.clienteId.equals(clienteId))
          ..orderBy([OrderingTerm.desc(tableFacturas.fecha)]);

    return query.watch().map((rows) {
      return rows.map((row) {
        final factura = row.readTable(tableFacturas);
        final cliente = row.readTableOrNull(tableClientes);
        final clienteNombre = cliente == null
            ? ''
            : '${cliente.nombre} ${cliente.apellidos}'.trim();

        return _toDomain(factura, clienteNombre: clienteNombre);
      }).toList();
    });
  }

  Stream<List<factura_domain.Factura>> observarPorExpediente(
    String expedienteId,
  ) {
    final tableFacturas = attachedDatabase.facturas;
    final tableClientes = attachedDatabase.clientes;
    final tablePresupuestos = attachedDatabase.presupuestos;

    final query =
        select(tableFacturas).join([
            innerJoin(
              tablePresupuestos,
              tablePresupuestos.id.equalsExp(tableFacturas.presupuestoOrigenId),
            ),
            leftOuterJoin(
              tableClientes,
              tableClientes.id.equalsExp(tableFacturas.clienteId),
            ),
          ])
          ..where(tablePresupuestos.expedienteId.equals(expedienteId))
          ..orderBy([OrderingTerm.desc(tableFacturas.fecha)]);

    return query.watch().map((rows) {
      return rows.map((row) {
        final factura = row.readTable(tableFacturas);
        final cliente = row.readTableOrNull(tableClientes);
        final clienteNombre = cliente == null
            ? ''
            : '${cliente.nombre} ${cliente.apellidos}'.trim();

        return _toDomain(factura, clienteNombre: clienteNombre);
      }).toList();
    });
  }

  Future<factura_domain.Factura?> obtenerPorId(String id) async {
    final tableFacturas = attachedDatabase.facturas;
    final tableClientes = attachedDatabase.clientes;

    final row = await (select(tableFacturas).join([
      leftOuterJoin(
        tableClientes,
        tableClientes.id.equalsExp(tableFacturas.clienteId),
      ),
    ])..where(tableFacturas.id.equals(id))).getSingleOrNull();

    if (row == null) {
      return null;
    }

    final factura = row.readTable(tableFacturas);
    final cliente = row.readTableOrNull(tableClientes);
    final clienteNombre = cliente == null
        ? ''
        : '${cliente.nombre} ${cliente.apellidos}'.trim();

    return _toDomain(factura, clienteNombre: clienteNombre);
  }

  Future<List<factura_domain.Factura>> obtenerPorPresupuestoOrigen(
    String presupuestoId,
  ) async {
    final rows =
        await (select(facturas)
              ..where((t) => t.presupuestoOrigenId.equals(presupuestoId))
              ..orderBy([(t) => OrderingTerm.desc(t.fechaCreacion)]))
            .get();
    return rows.map((row) => _toDomain(row)).toList();
  }

  Future<List<factura_domain.Factura>> obtenerRectificativasDe(
    String facturaId,
  ) async {
    final rows =
        await (select(facturas)
              ..where((t) => t.facturaRectificadaId.equals(facturaId))
              ..orderBy([(t) => OrderingTerm.asc(t.fechaCreacion)]))
            .get();
    return rows.map((row) => _toDomain(row)).toList();
  }

  Stream<List<factura_domain.Factura>> observarRectificativasDe(
    String facturaId,
  ) =>
      (select(facturas)
            ..where((t) => t.facturaRectificadaId.equals(facturaId))
            ..orderBy([(t) => OrderingTerm.asc(t.fechaCreacion)]))
          .watch()
          .map((rows) => rows.map((row) => _toDomain(row)).toList());

  Future<List<factura_domain.Factura>> obtenerCadenaPorRaiz(
    String raizId,
  ) async {
    final rows =
        await (select(facturas)..where(
              (t) => t.id.equals(raizId) | t.facturaRaizId.equals(raizId),
            ))
            .get();
    return rows.map((row) => _toDomain(row)).toList();
  }

  Stream<List<factura_domain.Factura>> observarPorPresupuestoOrigen(
    String presupuestoId,
  ) =>
      (select(facturas)
            ..where((t) => t.presupuestoOrigenId.equals(presupuestoId))
            ..orderBy([(t) => OrderingTerm.desc(t.fechaCreacion)]))
          .watch()
          .map((rows) => rows.map((row) => _toDomain(row)).toList());

  Future<bool> tieneFacturaPorExpediente(String expedienteId) async {
    final tableFacturas = attachedDatabase.facturas;
    final tablePresupuestos = attachedDatabase.presupuestos;

    final row =
        await (select(tableFacturas).join([
                innerJoin(
                  tablePresupuestos,
                  tablePresupuestos.id.equalsExp(
                    tableFacturas.presupuestoOrigenId,
                  ),
                ),
              ])
              ..where(tablePresupuestos.expedienteId.equals(expedienteId))
              ..limit(1))
            .getSingleOrNull();

    return row != null;
  }

  Future<void> insertarFactura(FacturasCompanion factura) async {
    await into(facturas).insert(factura);
  }

  Future<void> actualizarTotales({
    required String facturaId,
    required double subtotal,
    required double iva,
    required double total,
  }) async {
    await (update(facturas)..where((t) => t.id.equals(facturaId))).write(
      FacturasCompanion(
        subtotal: Value(subtotal),
        iva: Value(iva),
        total: Value(total),
        fechaModificacion: Value(DateTime.now()),
      ),
    );
  }

  Future<void> actualizarEstado(String facturaId, String estado) async {
    await (update(facturas)..where((t) => t.id.equals(facturaId))).write(
      FacturasCompanion(
        estado: Value(estado),
        fechaModificacion: Value(DateTime.now()),
      ),
    );
  }

  Future<void> actualizarEmision(
    String facturaId,
    FacturasCompanion companion,
  ) async {
    await (update(
      facturas,
    )..where((t) => t.id.equals(facturaId))).write(companion);
  }

  Future<void> actualizarFactura({
    required String id,
    required String clienteId,
    required DateTime fecha,
    required DateTime fechaVencimiento,
    required String estado,
    required String observaciones,
  }) async {
    await (update(facturas)..where((t) => t.id.equals(id))).write(
      FacturasCompanion(
        clienteId: Value(clienteId),
        fecha: Value(fecha),
        fechaVencimiento: Value(fechaVencimiento),
        estado: Value(estado),
        observaciones: Value(observaciones),
        fechaModificacion: Value(DateTime.now()),
      ),
    );
  }

  Future<void> eliminarFactura(String id) async {
    await (delete(facturas)..where((t) => t.id.equals(id))).go();
  }
}

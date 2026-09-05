// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../database/app_database.dart';
import '../../compras/data/compra_repository.dart';
import '../../compras/domain/compra.dart' as domain;
import '../../economia/data/hecho_coste_repository.dart';
import '../../facturas/domain/redondeo_monetario.dart';
import '../domain/circuito_proveedor.dart';

class CircuitoProveedorRepository {
  CircuitoProveedorRepository(this.database)
    : _compras = CompraRepository(database),
      _costes = HechoCosteRepository(database);
  final AppDatabase database;
  final CompraRepository _compras;
  final HechoCosteRepository _costes;
  static const _uuid = Uuid();

  Future<String> crearAlbaran(AlbaranInput input) =>
      database.transaction(() async {
        if (input.referencia.trim().isEmpty || input.lineas.isEmpty)
          throw ArgumentError('El albarán requiere referencia y líneas.');
        final id = _uuid.v4();
        final now = DateTime.now().toUtc();
        await database.circuitoProveedorDao.insertarAlbaran(
          AlbaranesProveedorCompanion.insert(
            tenantId: database.activeTenantId,
            id: id,
            proveedorId: input.proveedorId,
            referenciaProveedor: input.referencia.trim(),
            fecha: input.fecha,
            observaciones: Value(input.observaciones?.trim()),
            documentoId: Value(input.documentoId),
            fechaCreacion: now,
            fechaModificacion: now,
          ),
        );
        for (final line in input.lineas) {
          if (line.descripcion.trim().isEmpty || line.cantidad <= 0)
            throw ArgumentError('Línea de albarán no válida.');
          final lineId = _uuid.v4();
          await database.circuitoProveedorDao.insertarLinea(
            LineasAlbaranProveedorCompanion.insert(
              tenantId: database.activeTenantId,
              id: lineId,
              albaranId: id,
              descripcionOriginal: line.descripcion.trim(),
              cantidad: line.cantidad,
              unidad: Value(line.unidad),
              precioUnitarioCentimos: Value(line.precioUnitarioCentimos),
              importeCentimos: Value(line.importeCentimos),
              observaciones: Value(line.observaciones),
            ),
          );
          if (line.importeCentimos != null &&
              line.asignaciones.fold<int>(0, (s, a) => s + a.importeCentimos) >
                  line.importeCentimos!)
            throw StateError('El reparto supera el importe de la línea.');
          for (final a in line.asignaciones) {
            await database.circuitoProveedorDao.insertarAsignacionAlbaran(
              AsignacionesAlbaranObraCompanion.insert(
                tenantId: database.activeTenantId,
                id: _uuid.v4(),
                lineaAlbaranId: lineId,
                expedienteId: Value(a.expedienteId),
                importeCentimos: Value(a.importeCentimos),
              ),
            );
          }
        }
        return id;
      });

  Future<String> crearFactura(
    FacturaRecibidaInput input,
  ) => database.transaction(() async {
    if (input.numero.trim().isEmpty ||
        input.baseCentimos < 0 ||
        input.ivaCentimos < 0)
      throw ArgumentError('Factura no válida.');
    if (input.asignaciones.fold<int>(0, (s, a) => s + a.importeCentimos) !=
        input.baseCentimos)
      throw StateError(
        'La base debe quedar totalmente asignada, incluida la parte general.',
      );
    final id = _uuid.v4();
    final now = DateTime.now().toUtc();
    await database.circuitoProveedorDao.insertarFactura(
      FacturasRecibidasCompanion.insert(
        tenantId: database.activeTenantId,
        id: id,
        proveedorId: input.proveedorId,
        numeroNormalizado: _normalizar(input.numero),
        numeroProveedor: input.numero.trim(),
        fechaFactura: input.fecha,
        fechaVencimiento: Value(input.vencimiento),
        baseCentimos: input.baseCentimos,
        ivaCentimos: input.ivaCentimos,
        totalCentimos: input.baseCentimos + input.ivaCentimos,
        documentoId: Value(input.documentoId),
        fechaCreacion: now,
        fechaModificacion: now,
      ),
    );
    for (final albaranId in input.albaranIds.toSet()) {
      final albaran = await database.circuitoProveedorDao.albaran(albaranId);
      if (albaran == null || albaran.proveedorId != input.proveedorId) {
        throw StateError(
          'El albarán no corresponde al proveedor de la factura.',
        );
      }
      await database.circuitoProveedorDao.vincularAlbaran(
        FacturaRecibidaAlbaranesCompanion.insert(
          tenantId: database.activeTenantId,
          facturaId: id,
          albaranId: albaranId,
        ),
      );
    }
    for (final a in input.asignaciones) {
      await database.circuitoProveedorDao.insertarAsignacionFactura(
        AsignacionesFacturaRecibidaCompanion.insert(
          tenantId: database.activeTenantId,
          id: _uuid.v4(),
          facturaId: id,
          expedienteId: Value(a.expedienteId),
          baseCentimos: a.importeCentimos,
          ivaNoRecuperableCentimos: Value(a.ivaNoRecuperableCentimos),
        ),
      );
    }
    return id;
  });

  Future<void> reconocerAsignacion({
    required String asignacionId,
    String? compraExistenteId,
  }) => database.transaction(() async {
    if (await database.circuitoProveedorDao.reconciliacion(asignacionId) !=
        null)
      return;
    final a = await database.circuitoProveedorDao.asignacionFactura(
      asignacionId,
    );
    if (a == null || a.expedienteId == null)
      throw StateError('La asignación de obra no existe.');
    final factura = await database.circuitoProveedorDao.factura(a.facturaId);
    if (factura == null || factura.estado == 'cancelada')
      throw StateError('Factura no disponible.');
    var compraId = compraExistenteId;
    if (compraId == null) {
      compraId = _uuid.v4();
      await _compras.registrarCompra(
        domain.Compra(
          id: compraId,
          expedienteId: a.expedienteId!,
          proveedorId: factura.proveedorId,
          proveedorNombre: '',
          fecha: factura.fechaFactura,
          numeroFactura: factura.numeroProveedor,
          concepto: 'Factura proveedor ${factura.numeroProveedor}',
          baseImponible: a.baseCentimos / 100,
          ivaPorcentaje: 0,
          importeTotal: (a.baseCentimos + a.ivaNoRecuperableCentimos) / 100,
          estado: domain.CompraEstado.pendiente,
        ),
      );
    } else {
      final compra = await database.comprasDao.obtenerPorId(compraId);
      if (compra == null ||
          compra.expedienteId != a.expedienteId ||
          (compra.proveedorId != null &&
              compra.proveedorId != factura.proveedorId) ||
          monedaACentimos(compra.baseImponible) != a.baseCentimos)
        throw StateError(
          'La compra no corresponde a esta factura, obra e importe.',
        );
    }
    await database.circuitoProveedorDao.vincularCompra(
      FacturaRecibidaComprasCompanion.insert(
        tenantId: database.activeTenantId,
        facturaId: factura.id,
        asignacionId: asignacionId,
        compraId: compraId,
      ),
    );
    await _costes.confirmarCompra(
      compraId: compraId,
      ivaNoRecuperableCentimos: a.ivaNoRecuperableCentimos,
    );
  });

  Future<String> registrarPago({
    required String facturaId,
    required DateTime fecha,
    required int importeCentimos,
    String? metodo,
    String? referencia,
    String? observaciones,
  }) => database.transaction(() async {
    final factura = await database.circuitoProveedorDao.factura(facturaId);
    if (factura == null || factura.estado == 'cancelada')
      throw StateError('Factura no disponible.');
    if (importeCentimos <= 0) throw ArgumentError.value(importeCentimos);
    final pagado = await database.circuitoProveedorDao.totalPagado(facturaId);
    if (pagado + importeCentimos > factura.totalCentimos)
      throw StateError('El pago supera el saldo pendiente.');
    final id = _uuid.v4();
    await database.circuitoProveedorDao.insertarPago(
      PagosProveedorCompanion.insert(
        tenantId: database.activeTenantId,
        id: id,
        facturaId: facturaId,
        fecha: fecha,
        importeCentimos: importeCentimos,
        metodo: Value(metodo),
        referencia: Value(referencia),
        observaciones: Value(observaciones),
        fechaCreacion: DateTime.now().toUtc(),
      ),
    );
    await database.circuitoProveedorDao.actualizarEstadoFactura(
      facturaId,
      pagado + importeCentimos == factura.totalCentimos
          ? 'pagada'
          : 'parcialmentePagada',
    );
    return id;
  });

  Stream<List<AlbaranesProveedorData>> observarAlbaranesObra(
    String expedienteId,
  ) => database.circuitoProveedorDao.observarAlbaranesObra(expedienteId);
  Stream<List<AsignacionesFacturaRecibidaData>> observarFacturasObra(
    String expedienteId,
  ) => database.circuitoProveedorDao.observarAsignacionesFacturaObra(
    expedienteId,
  );
  static String _normalizar(String value) =>
      value.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
}

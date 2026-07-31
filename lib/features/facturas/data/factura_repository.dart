import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/database/database_provider.dart';
import 'package:obraia_v2/features/facturas/domain/estado_factura.dart';
import 'package:obraia_v2/features/facturas/domain/factura.dart' as factura_domain;
import 'package:obraia_v2/features/presupuestos/domain/presupuesto.dart'
  as presupuesto_domain;
import 'package:uuid/uuid.dart';

final facturaRepositoryProvider = Provider<FacturaRepository>((ref) {
  final database = ref.read(databaseProvider);
  return FacturaRepository(database);
});

class PresupuestoYaConvertidoException implements Exception {
  const PresupuestoYaConvertidoException({
    required this.presupuestoId,
    required this.facturaId,
  });

  final String presupuestoId;
  final String facturaId;
}

class FacturaRepository {
  final AppDatabase database;

  FacturaRepository(this.database);

  Stream<List<factura_domain.Factura>> observarFacturas() {
    return database.facturasDao.observarFacturas();
  }

  Stream<List<factura_domain.Factura>> observarPorCliente(String clienteId) {
    return database.facturasDao.observarPorCliente(clienteId);
  }

  Stream<List<factura_domain.Factura>> observarPorExpediente(
    String expedienteId,
  ) {
    return database.facturasDao.observarPorExpediente(expedienteId);
  }

  Future<factura_domain.Factura?> obtenerPorId(String facturaId) {
    return database.facturasDao.obtenerPorId(facturaId);
  }

  Future<String> _generarCodigoFactura() async {
    final year = DateTime.now().year;
    final prefijo = 'FAC-$year-';

    final codigosExistentes = await database.facturasDao
        .obtenerCodigosPorPrefijo(prefijo);

    var maxCorrelativo = 0;

    for (final codigo in codigosExistentes) {
      if (!codigo.startsWith(prefijo)) {
        continue;
      }

      final valor = int.tryParse(codigo.substring(prefijo.length));
      if (valor != null && valor > maxCorrelativo) {
        maxCorrelativo = valor;
      }
    }

    final siguiente = maxCorrelativo + 1;
    final correlativo = siguiente.toString().padLeft(4, '0');
    return '$prefijo$correlativo';
  }

  Future<String> crearFactura({
    required String clienteId,
    required DateTime fecha,
    required DateTime fechaVencimiento,
    EstadoFactura estado = EstadoFactura.borrador,
    double subtotal = 0,
    double iva = 0,
    double total = 0,
    String observaciones = '',
    String? presupuestoOrigenId,
  }) async {
    final facturaId = const Uuid().v4();
    final codigo = await _generarCodigoFactura();

    await database.facturasDao.insertarFactura(
      FacturasCompanion.insert(
        id: facturaId,
        codigo: Value(codigo),
        clienteId: clienteId,
        fecha: Value(fecha),
        fechaVencimiento: Value(fechaVencimiento),
        estado: Value(estadoFacturaToString(estado)),
        subtotal: Value(subtotal),
        iva: Value(iva),
        total: Value(total),
        observaciones: Value(observaciones),
        presupuestoOrigenId: presupuestoOrigenId == null
            ? const Value.absent()
            : Value(presupuestoOrigenId),
      ),
    );

    return facturaId;
  }

  Future<String> convertirDesdePresupuesto(
    presupuesto_domain.Presupuesto presupuesto,
  ) async {
    final facturaExistenteId = await database.facturasDao
        .obtenerIdPorPresupuestoOrigen(presupuesto.id);
    if (facturaExistenteId != null) {
      throw PresupuestoYaConvertidoException(
        presupuestoId: presupuesto.id,
        facturaId: facturaExistenteId,
      );
    }

    final expediente = await database.expedientesDao.obtenerExpediente(
      presupuesto.expedienteId,
    );

    final clienteId = expediente?.clienteId;
    if (clienteId == null || clienteId.trim().isEmpty) {
      throw Exception(
        'El presupuesto no tiene cliente asociado en su expediente.',
      );
    }

    final lineas = await database.lineasPresupuestoDao.obtenerPorPresupuesto(
      presupuesto.id,
    );

    final subtotal = presupuesto.importeTotal;
    final iva = subtotal * presupuesto.ivaPorcentaje / 100;
    final total = subtotal + iva;
    final fechaFactura = DateTime.now();
    final fechaVencimiento = fechaFactura.add(const Duration(days: 30));

    late final String facturaId;

    await database.transaction(() async {
      facturaId = await crearFactura(
        clienteId: clienteId,
        fecha: fechaFactura,
        fechaVencimiento: fechaVencimiento,
        estado: EstadoFactura.borrador,
        subtotal: subtotal,
        iva: iva,
        total: total,
        observaciones: presupuesto.descripcion,
        presupuestoOrigenId: presupuesto.id,
      );

      for (final linea in lineas) {
        await database.facturaLineasDao.insertarLinea(
          FacturaLineasCompanion.insert(
            id: const Uuid().v4(),
            facturaId: facturaId,
            descripcion: linea.concepto,
            cantidad: linea.cantidad,
            unidad: const Value('ud'),
            precioUnitario: linea.precioUnitario,
            descuento: const Value(0),
            importe: Value(linea.importe),
          ),
        );
      }
    });

    return facturaId;
  }

  Future<void> actualizarTotales({
    required String facturaId,
    required double subtotal,
    required double iva,
  }) {
    final total = subtotal + iva;

    return database.facturasDao.actualizarTotales(
      facturaId: facturaId,
      subtotal: subtotal,
      iva: iva,
      total: total,
    );
  }

  Future<void> actualizarEstado(String facturaId, EstadoFactura estado) {
    return database.facturasDao.actualizarEstado(
      facturaId,
      estadoFacturaToString(estado),
    );
  }

  Future<void> actualizarFactura({
    required String id,
    required String clienteId,
    required DateTime fecha,
    required DateTime fechaVencimiento,
    required EstadoFactura estado,
    required String observaciones,
  }) {
    return database.facturasDao.actualizarFactura(
      id: id,
      clienteId: clienteId,
      fecha: fecha,
      fechaVencimiento: fechaVencimiento,
      estado: estadoFacturaToString(estado),
      observaciones: observaciones,
    );
  }

  Future<void> eliminarFactura(String facturaId) async {
    await database.transaction(() async {
      await database.cobrosDao.eliminarPorFactura(facturaId);
      await database.facturaLineasDao.eliminarPorFactura(facturaId);
      await database.facturasDao.eliminarFactura(facturaId);
    });
  }
}

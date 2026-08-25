import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/database/database_provider.dart';
import 'package:obraia_v2/features/facturas/data/factura_repository.dart';
import 'package:obraia_v2/features/facturas/domain/factura_linea.dart'
    as factura_linea_domain;
import 'package:obraia_v2/features/facturas/domain/factura_totales.dart';
import 'package:uuid/uuid.dart';

final facturaLineaRepositoryProvider = Provider<FacturaLineaRepository>((ref) {
  final database = ref.read(databaseProvider);
  return FacturaLineaRepository(database);
});

class TotalFacturaInferiorACobrosException implements Exception {
  const TotalFacturaInferiorACobrosException({
    required this.facturaId,
    required this.nuevoTotalFactura,
    required this.totalCobrado,
  });

  final String facturaId;
  final double nuevoTotalFactura;
  final double totalCobrado;
}

class FacturaLineaRepository {
  final AppDatabase database;

  FacturaLineaRepository(this.database);

  double _calcularImporte({
    required double cantidad,
    required double precioUnitario,
    required double descuento,
  }) {
    final bruto = cantidad * precioUnitario;
    final factorDescuento = (100 - descuento) / 100;
    return bruto * factorDescuento;
  }

  Future<double> _obtenerTotalCobrado(String facturaId) async {
    final cobros = await database.cobrosDao.observarPorFactura(facturaId).first;
    return cobros.fold<double>(0, (total, cobro) => total + cobro.importe);
  }

  Future<void> _validarTotales(String facturaId, FacturaTotales totales) async {
    final totalCobrado = await _obtenerTotalCobrado(facturaId);
    if (!totalFacturaCubreCobros(
      totalFactura: totales.total,
      totalCobrado: totalCobrado,
    )) {
      throw TotalFacturaInferiorACobrosException(
        facturaId: facturaId,
        nuevoTotalFactura: totales.total,
        totalCobrado: totalCobrado,
      );
    }
  }

  Future<void> _persistirTotales(
    String facturaId,
    FacturaTotales totales,
  ) async {
    final facturaRepository = FacturaRepository(database);
    await facturaRepository.actualizarTotales(
      facturaId: facturaId,
      subtotal: totales.subtotal,
      iva: totales.iva,
    );
  }

  Future<void> crearLinea({
    required String facturaId,
    required String descripcion,
    required double cantidad,
    required String unidad,
    required double precioUnitario,
    required double descuento,
  }) async {
    final importe = _calcularImporte(
      cantidad: cantidad,
      precioUnitario: precioUnitario,
      descuento: descuento,
    );
    final lineas = await database.facturaLineasDao.obtenerPorFactura(facturaId);
    final nuevaLinea = factura_linea_domain.FacturaLinea(
      id: const Uuid().v4(),
      facturaId: facturaId,
      descripcion: descripcion,
      cantidad: cantidad,
      unidad: unidad,
      precioUnitario: precioUnitario,
      descuento: descuento,
      importe: importe,
    );
    final totales = calcularTotalesFactura([...lineas, nuevaLinea]);
    await _validarTotales(facturaId, totales);

    await database.facturaLineasDao.insertarLinea(
      FacturaLineasCompanion.insert(
        id: nuevaLinea.id,
        facturaId: facturaId,
        descripcion: descripcion,
        cantidad: cantidad,
        unidad: Value(unidad),
        precioUnitario: precioUnitario,
        descuento: Value(descuento),
        importe: Value(importe),
      ),
    );

    await _persistirTotales(facturaId, totales);
  }

  Future<void> actualizarLinea({
    required String id,
    required String facturaId,
    required String descripcion,
    required double cantidad,
    required String unidad,
    required double precioUnitario,
    required double descuento,
  }) async {
    final importe = _calcularImporte(
      cantidad: cantidad,
      precioUnitario: precioUnitario,
      descuento: descuento,
    );
    final lineas = await database.facturaLineasDao.obtenerPorFactura(facturaId);
    final nuevaLinea = factura_linea_domain.FacturaLinea(
      id: id,
      facturaId: facturaId,
      descripcion: descripcion,
      cantidad: cantidad,
      unidad: unidad,
      precioUnitario: precioUnitario,
      descuento: descuento,
      importe: importe,
    );
    final totales = calcularTotalesFactura(
      sustituirLineaPorId(lineas: lineas, nuevaLinea: nuevaLinea),
    );
    await _validarTotales(facturaId, totales);

    await database.facturaLineasDao.actualizarLinea(
      id,
      FacturaLineasCompanion(
        descripcion: Value(descripcion),
        cantidad: Value(cantidad),
        unidad: Value(unidad),
        precioUnitario: Value(precioUnitario),
        descuento: Value(descuento),
        importe: Value(importe),
      ),
    );

    await _persistirTotales(facturaId, totales);
  }

  Future<void> eliminarLinea(String id, String facturaId) async {
    final lineas = await database.facturaLineasDao.obtenerPorFactura(facturaId);
    final totales = calcularTotalesFactura(
      eliminarLineaPorId(lineas: lineas, lineaId: id),
    );
    await _validarTotales(facturaId, totales);

    await database.facturaLineasDao.eliminarLinea(id);
    await _persistirTotales(facturaId, totales);
  }

  Stream<List<factura_linea_domain.FacturaLinea>> observarPorFactura(
    String facturaId,
  ) {
    return database.facturaLineasDao.observarPorFactura(facturaId);
  }
}

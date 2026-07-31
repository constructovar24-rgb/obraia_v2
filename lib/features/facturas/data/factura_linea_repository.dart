import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/database/database_provider.dart';
import 'package:obraia_v2/features/facturas/data/factura_repository.dart';
import 'package:obraia_v2/features/facturas/domain/factura_linea.dart'
    as factura_linea_domain;
import 'package:uuid/uuid.dart';

final facturaLineaRepositoryProvider =
    Provider<FacturaLineaRepository>((ref) {
      final database = ref.read(databaseProvider);
      return FacturaLineaRepository(database);
    });

class FacturaLineaRepository {
  final AppDatabase database;
  static const double _ivaPorcentaje = 21.0;

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

  Future<void> _recalcularTotales(String facturaId) async {
    final lineas = await database.facturaLineasDao.obtenerPorFactura(facturaId);

    final subtotal = lineas.fold<double>(
      0,
      (sum, linea) => sum + linea.importe,
    );
    final iva = subtotal * _ivaPorcentaje / 100;

    final facturaRepository = FacturaRepository(database);
    await facturaRepository.actualizarTotales(
      facturaId: facturaId,
      subtotal: subtotal,
      iva: iva,
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

    await database.facturaLineasDao.insertarLinea(
      FacturaLineasCompanion.insert(
        id: const Uuid().v4(),
        facturaId: facturaId,
        descripcion: descripcion,
        cantidad: cantidad,
        unidad: Value(unidad),
        precioUnitario: precioUnitario,
        descuento: Value(descuento),
        importe: Value(importe),
      ),
    );

    await _recalcularTotales(facturaId);
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

    await _recalcularTotales(facturaId);
  }

  Future<void> eliminarLinea(String id, String facturaId) async {
    await database.facturaLineasDao.eliminarLinea(id);
    await _recalcularTotales(facturaId);
  }

  Stream<List<factura_linea_domain.FacturaLinea>> observarPorFactura(
    String facturaId,
  ) {
    return database.facturaLineasDao.observarPorFactura(facturaId);
  }
}

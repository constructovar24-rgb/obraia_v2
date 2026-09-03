import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/database/database_provider.dart';
import 'package:obraia_v2/features/cobros/domain/factura_estado_economico.dart';
import 'package:obraia_v2/features/facturas/data/factura_repository.dart';
import 'package:obraia_v2/features/facturas/domain/estado_factura.dart';
import 'package:obraia_v2/features/facturas/domain/factura_linea.dart'
    as factura_linea_domain;
import 'package:obraia_v2/features/facturas/domain/factura_totales.dart';
import 'package:obraia_v2/features/facturas/domain/redondeo_monetario.dart';
import 'package:uuid/uuid.dart';

final facturaLineaRepositoryProvider = Provider<FacturaLineaRepository>((ref) {
  ref.watch(activeTenantIdProvider);
  final database = ref.watch(databaseProvider);
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

class FacturaNoEncontradaAlModificarLineasException implements Exception {
  const FacturaNoEncontradaAlModificarLineasException({
    required this.facturaId,
  });

  final String facturaId;
}

class FacturaNoPermiteModificarLineasException implements Exception {
  const FacturaNoPermiteModificarLineasException({
    required this.facturaId,
    required this.estado,
  });

  final String facturaId;
  final EstadoFactura estado;
}

class FacturaParcialNoPermiteModificarLineasException implements Exception {
  const FacturaParcialNoPermiteModificarLineasException(this.facturaId);
  final String facturaId;
}

class FacturaLineaRepository {
  final AppDatabase database;

  FacturaLineaRepository(this.database);

  Future<bool> esFacturaParcial(String facturaId) =>
      database.facturaAsignacionesPresupuestoDao.existePorFactura(facturaId);

  double _calcularImporte({
    required double cantidad,
    required double precioUnitario,
    required double descuento,
  }) {
    return calcularImporteLineaFactura(
      cantidad: cantidad,
      precioUnitario: precioUnitario,
      descuento: descuento,
    );
  }

  Future<double> _obtenerTotalCobrado(String facturaId) async {
    final cobros = await database.cobrosDao.observarPorFactura(facturaId).first;
    return calcularTotalCobradoNeto(cobros);
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
    await database.transaction(() async {
      final factura = await database.facturasDao.obtenerPorId(facturaId);
      if (factura == null) {
        throw FacturaNoEncontradaAlModificarLineasException(
          facturaId: facturaId,
        );
      }
      if (factura.esRectificativa) {
        throw FacturaNoPermiteModificarLineasException(
          facturaId: facturaId,
          estado: factura.estado,
        );
      }
      await _validarFacturaEditable(facturaId, factura.estado);

      final importe = _calcularImporte(
        cantidad: cantidad,
        precioUnitario: precioUnitario,
        descuento: descuento,
      );
      final lineas = await database.facturaLineasDao.obtenerPorFactura(
        facturaId,
      );
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
      final totales = calcularTotalesFactura([
        ...lineas,
        nuevaLinea,
      ], ivaPorcentaje: factura.ivaPorcentaje);
      await _validarTotales(facturaId, totales);

      await database.facturaLineasDao.insertarLinea(
        FacturaLineasCompanion.insert(
          tenantId: Value(database.activeTenantId),
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
    });
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
    await database.transaction(() async {
      final factura = await database.facturasDao.obtenerPorId(facturaId);
      if (factura == null) {
        throw FacturaNoEncontradaAlModificarLineasException(
          facturaId: facturaId,
        );
      }
      if (factura.esRectificativa) {
        throw FacturaNoPermiteModificarLineasException(
          facturaId: facturaId,
          estado: factura.estado,
        );
      }
      await _validarFacturaEditable(facturaId, factura.estado);

      final importe = _calcularImporte(
        cantidad: cantidad,
        precioUnitario: precioUnitario,
        descuento: descuento,
      );
      final lineas = await database.facturaLineasDao.obtenerPorFactura(
        facturaId,
      );
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
        ivaPorcentaje: factura.ivaPorcentaje,
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
    });
  }

  Future<void> eliminarLinea(String id, String facturaId) async {
    await database.transaction(() async {
      final factura = await database.facturasDao.obtenerPorId(facturaId);
      if (factura == null) {
        throw FacturaNoEncontradaAlModificarLineasException(
          facturaId: facturaId,
        );
      }
      if (factura.esRectificativa) {
        throw FacturaNoPermiteModificarLineasException(
          facturaId: facturaId,
          estado: factura.estado,
        );
      }
      await _validarFacturaEditable(facturaId, factura.estado);

      final lineas = await database.facturaLineasDao.obtenerPorFactura(
        facturaId,
      );
      final totales = calcularTotalesFactura(
        eliminarLineaPorId(lineas: lineas, lineaId: id),
        ivaPorcentaje: factura.ivaPorcentaje,
      );
      await _validarTotales(facturaId, totales);

      await database.facturaLineasDao.eliminarLinea(id);
      await _persistirTotales(facturaId, totales);
    });
  }

  Future<void> _validarFacturaEditable(
    String facturaId,
    EstadoFactura estado,
  ) async {
    if (!estadoFacturaPermiteEditarLineas(estado)) {
      throw FacturaNoPermiteModificarLineasException(
        facturaId: facturaId,
        estado: estado,
      );
    }
    if (await database.facturaAsignacionesPresupuestoDao.existePorFactura(
      facturaId,
    )) {
      throw FacturaParcialNoPermiteModificarLineasException(facturaId);
    }
  }

  Stream<List<factura_linea_domain.FacturaLinea>> observarPorFactura(
    String facturaId,
  ) {
    return database.facturaLineasDao.observarPorFactura(facturaId);
  }
}

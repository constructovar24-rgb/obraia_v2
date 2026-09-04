import 'package:drift/drift.dart';

import '../../../database/app_database.dart' as db;
import '../domain/compra.dart';

typedef CompraData = db.Compra;

extension CompraDataMapper on CompraData {
  Compra toDomain() {
    return Compra(
      id: id,
      expedienteId: expedienteId,
      proveedorId: proveedorId,
      proveedorNombre: proveedorNombre,
      fecha: fecha,
      numeroFactura: numeroFactura,
      concepto: concepto,
      baseImponible: baseImponible,
      ivaPorcentaje: ivaPorcentaje,
      importeTotal: importeTotal,
      estado: CompraEstado.values.byName(estado),
      clasificacionEconomica: CompraClasificacionEconomica.values.byName(
        clasificacionEconomica,
      ),
      observaciones: observaciones,
    );
  }
}

extension CompraMapper on Compra {
  db.ComprasCompanion toCompanion() {
    return db.ComprasCompanion(
      id: Value(id),
      expedienteId: Value(expedienteId),
      proveedorId: Value(proveedorId),
      proveedorNombre: Value(proveedorNombre),
      fecha: Value(fecha),
      numeroFactura: Value(numeroFactura),
      concepto: Value(concepto),
      baseImponible: Value(baseImponible),
      ivaPorcentaje: Value(ivaPorcentaje),
      importeTotal: Value(importeTotal),
      estado: Value(estado.name),
      clasificacionEconomica: Value(clasificacionEconomica.name),
      observaciones: Value(observaciones),
    );
  }
}

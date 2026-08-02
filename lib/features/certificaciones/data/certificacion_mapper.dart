import 'package:drift/drift.dart';

import '../../../database/app_database.dart' as db;
import '../domain/certificacion.dart';

typedef CertificacionData = db.Certificacione;

CertificacionEstado _estadoFromDb(String estado) {
  switch (estado) {
    case 'borrador':
      return CertificacionEstado.borrador;
    case 'emitida':
      return CertificacionEstado.emitida;
    case 'facturada':
      return CertificacionEstado.facturada;
    default:
      return CertificacionEstado.borrador;
  }
}

extension CertificacionDataMapper on CertificacionData {
  Certificacion toDomain() {
    return Certificacion(
      id: id,
      expedienteId: expedienteId,
      presupuestoId: presupuestoId,
      codigo: codigo,
      fecha: fecha,
      descripcion: descripcion,
      baseImponible: baseImponible,
      ivaPorcentaje: ivaPorcentaje,
      importeTotal: importeTotal,
      estado: _estadoFromDb(estado),
      observaciones: observaciones,
    );
  }
}

extension CertificacionMapper on Certificacion {
  db.CertificacionesCompanion toCompanion() {
    return db.CertificacionesCompanion(
      id: Value(id),
      expedienteId: Value(expedienteId),
      presupuestoId: Value(presupuestoId),
      codigo: Value(codigo),
      fecha: Value(fecha),
      descripcion: Value(descripcion),
      baseImponible: Value(baseImponible),
      ivaPorcentaje: Value(ivaPorcentaje),
      importeTotal: Value(importeTotal),
      estado: Value(estado.name),
      observaciones: Value(observaciones),
    );
  }
}

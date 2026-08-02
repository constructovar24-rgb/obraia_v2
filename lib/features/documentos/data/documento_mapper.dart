import 'package:drift/drift.dart';

import '../../../database/app_database.dart' as db;
import '../domain/documento.dart';

typedef DocumentoData = db.Documento;

DocumentoTipo _tipoFromDb(String tipo) {
  switch (tipo) {
    case 'contrato':
      return DocumentoTipo.contrato;
    case 'licencia':
      return DocumentoTipo.licencia;
    case 'plano':
      return DocumentoTipo.plano;
    case 'fotografia':
      return DocumentoTipo.fotografia;
    case 'factura':
      return DocumentoTipo.factura;
    case 'presupuesto':
      return DocumentoTipo.presupuesto;
    default:
      return DocumentoTipo.otro;
  }
}

extension DocumentoDataMapper on DocumentoData {
  Documento toDomain() {
    return Documento(
      id: id,
      expedienteId: expedienteId,
      titulo: titulo,
      nombreArchivo: nombreArchivo,
      rutaArchivo: rutaArchivo,
      mimeType: mimeType,
      tamanoBytes: tamanoBytes,
      fecha: fecha,
      observaciones: observaciones,
      tipo: _tipoFromDb(tipo),
    );
  }
}

extension DocumentoMapper on Documento {
  db.DocumentosCompanion toCompanion() {
    return db.DocumentosCompanion(
      id: Value(id),
      expedienteId: Value(expedienteId),
      titulo: Value(titulo),
      nombreArchivo: Value(nombreArchivo),
      rutaArchivo: Value(rutaArchivo),
      mimeType: Value(mimeType),
      tamanoBytes: Value(tamanoBytes),
      fecha: Value(fecha),
      observaciones: Value(observaciones),
      tipo: Value(tipo.name),
    );
  }
}
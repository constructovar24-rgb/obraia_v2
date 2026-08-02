import 'package:uuid/uuid.dart';

import '../../../database/dao/certificaciones_dao.dart';
import '../domain/certificacion.dart';
import 'certificacion_mapper.dart';

class CertificacionRepository {
  CertificacionRepository(this._dao);

  final CertificacionesDao _dao;

  Future<void> registrarCertificacion(Certificacion certificacion) async {
    final certificacionConId = Certificacion(
      id: const Uuid().v4(),
      expedienteId: certificacion.expedienteId,
      presupuestoId: certificacion.presupuestoId,
      codigo: certificacion.codigo,
      fecha: certificacion.fecha,
      descripcion: certificacion.descripcion,
      baseImponible: certificacion.baseImponible,
      ivaPorcentaje: certificacion.ivaPorcentaje,
      importeTotal: certificacion.importeTotal,
      estado: certificacion.estado,
      observaciones: certificacion.observaciones,
    );

    await _dao.insertarCertificacion(certificacionConId.toCompanion());
  }

  Future<List<Certificacion>> obtenerCertificacionesPorExpediente(
    String expedienteId,
  ) async {
    final rows = await _dao.obtenerPorExpediente(expedienteId);
    return rows.map((row) => row.toDomain()).toList();
  }

  Stream<List<Certificacion>> observarCertificacionesPorExpediente(
    String expedienteId,
  ) {
    return _dao.observarPorExpediente(expedienteId).map(
      (rows) => rows.map((row) => row.toDomain()).toList(),
    );
  }

  Stream<Certificacion?> observarCertificacion(String id) {
    return _dao.observarCertificacion(id).map(
      (row) => row?.toDomain(),
    );
  }

  Future<Certificacion?> obtenerCertificacion(String id) async {
    final row = await _dao.obtenerCertificacion(id);
    return row?.toDomain();
  }

  Future<void> actualizarCertificacion(Certificacion certificacion) {
    return _dao.actualizarCertificacion(
      certificacion.id,
      certificacion.toCompanion(),
    );
  }

  Future<void> eliminarCertificacion(String certificacionId) {
    return _dao.eliminarLogicamente(certificacionId);
  }
}

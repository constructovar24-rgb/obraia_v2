import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/certificaciones.dart';

part 'certificaciones_dao.g.dart';

@DriftAccessor(tables: [Certificaciones])
class CertificacionesDao extends DatabaseAccessor<AppDatabase>
    with _$CertificacionesDaoMixin {
  CertificacionesDao(super.db);

  Future<void> insertarCertificacion(CertificacionesCompanion certificacion) async {
    await into(certificaciones).insert(certificacion);
  }

  Stream<List<Certificacione>> observarPorExpediente(String expedienteId) {
    return (select(certificaciones)
          ..where(
            (t) => t.expedienteId.equals(expedienteId) & t.eliminado.equals(false),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.fecha)]))
        .watch();
  }

  Future<List<Certificacione>> obtenerPorExpediente(String expedienteId) {
    return (select(certificaciones)
          ..where(
            (t) => t.expedienteId.equals(expedienteId) & t.eliminado.equals(false),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.fecha)]))
        .get();
  }

  Stream<Certificacione?> observarCertificacion(String id) {
    return (select(certificaciones)..where((t) => t.id.equals(id))).watchSingleOrNull();
  }

  Future<Certificacione?> obtenerCertificacion(String id) {
    return (select(certificaciones)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<void> actualizarCertificacion(
    String id,
    CertificacionesCompanion certificacion,
  ) async {
    await (update(certificaciones)..where((t) => t.id.equals(id))).write(certificacion);
  }

  Future<void> eliminarLogicamente(String id) async {
    await (update(certificaciones)..where((t) => t.id.equals(id))).write(
      const CertificacionesCompanion(
        eliminado: Value(true),
      ),
    );
  }
}

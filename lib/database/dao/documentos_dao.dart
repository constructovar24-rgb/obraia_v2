import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/documentos.dart';

part 'documentos_dao.g.dart';

@DriftAccessor(tables: [Documentos])
class DocumentosDao extends DatabaseAccessor<AppDatabase>
    with _$DocumentosDaoMixin {
  DocumentosDao(super.db);

  Future<void> insertarDocumento(DocumentosCompanion documento) async {
    await into(documentos).insert(documento);
  }

  Stream<List<Documento>> observarPorExpediente(String expedienteId) {
    return (select(documentos)
          ..where(
            (t) => t.expedienteId.equals(expedienteId) & t.eliminado.equals(false),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.fechaCreacion)]))
        .watch();
  }

  Future<List<Documento>> obtenerPorExpediente(String expedienteId) {
    return (select(documentos)
          ..where(
            (t) => t.expedienteId.equals(expedienteId) & t.eliminado.equals(false),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.fechaCreacion)]))
        .get();
  }

  Stream<Documento?> observarDocumento(String id) {
    return (select(documentos)..where((t) => t.id.equals(id))).watchSingleOrNull();
  }

  Future<Documento?> obtenerDocumento(String id) {
    return (select(documentos)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<void> actualizarDocumento(
    String id,
    DocumentosCompanion documento,
  ) async {
    await (update(documentos)..where((t) => t.id.equals(id))).write(documento);
  }

  Future<void> eliminarLogicamente(String id) async {
    await (update(documentos)..where((t) => t.id.equals(id))).write(
      const DocumentosCompanion(
        eliminado: Value(true),
      ),
    );
  }
}
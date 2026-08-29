import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/factura_documentos_emitidos.dart';

part 'factura_documentos_emitidos_dao.g.dart';

@DriftAccessor(tables: [FacturaDocumentosEmitidos])
class FacturaDocumentosEmitidosDao extends DatabaseAccessor<AppDatabase>
    with _$FacturaDocumentosEmitidosDaoMixin {
  FacturaDocumentosEmitidosDao(super.db);

  Future<void> insertar({
    required String facturaId,
    required Uint8List pdf,
    required String sha256,
  }) => into(facturaDocumentosEmitidos).insert(
    FacturaDocumentosEmitidosCompanion.insert(
      facturaId: facturaId,
      pdf: pdf,
      sha256: sha256,
    ),
  );

  Future<FacturaDocumentosEmitido?> obtener(String facturaId) => (select(
    facturaDocumentosEmitidos,
  )..where((t) => t.facturaId.equals(facturaId))).getSingleOrNull();
}

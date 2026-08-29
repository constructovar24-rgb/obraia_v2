import 'package:drift/drift.dart';

import '../../features/cobros/domain/cobro.dart' as cobro_domain;
import '../app_database.dart';
import '../tables/cobros.dart';

part 'cobros_dao.g.dart';

@DriftAccessor(tables: [Cobros])
class CobrosDao extends DatabaseAccessor<AppDatabase> with _$CobrosDaoMixin {
  CobrosDao(super.db);

  cobro_domain.Cobro _toDomain(Cobro row) {
    return cobro_domain.Cobro(
      id: row.id,
      facturaId: row.facturaId,
      fecha: row.fecha,
      importe: row.importe,
      metodoPago: row.metodoPago,
      referencia: row.referencia,
      observaciones: row.observaciones,
      tipoMovimiento: cobro_domain.tipoMovimientoCobroFromString(
        row.tipoMovimiento,
      ),
      cobroOrigenId: row.cobroOrigenId,
      motivo: row.motivo,
    );
  }

  Stream<List<cobro_domain.Cobro>> observarPorFactura(String facturaId) {
    return (select(cobros)
          ..where((t) => t.facturaId.equals(facturaId))
          ..orderBy([(t) => OrderingTerm.desc(t.fecha)]))
        .watch()
        .map((rows) => rows.map(_toDomain).toList());
  }

  Stream<List<cobro_domain.Cobro>> observarCobros() {
    return (select(cobros)..orderBy([(t) => OrderingTerm.desc(t.fecha)]))
        .watch()
        .map((rows) => rows.map(_toDomain).toList());
  }

  Future<cobro_domain.Cobro?> obtenerPorId(String id) async {
    final row = await (select(
      cobros,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (row == null) {
      return null;
    }
    return _toDomain(row);
  }

  Future<void> insertarCobro(CobrosCompanion cobro) async {
    await into(cobros).insert(cobro);
  }

  Future<List<cobro_domain.Cobro>> obtenerPorFactura(String facturaId) async {
    final rows =
        await (select(cobros)
              ..where((t) => t.facturaId.equals(facturaId))
              ..orderBy([(t) => OrderingTerm.desc(t.fecha)]))
            .get();
    return rows.map(_toDomain).toList();
  }

  Future<void> actualizarCobro({
    required String id,
    required DateTime fecha,
    required double importe,
    required String metodoPago,
    required String referencia,
    required String observaciones,
  }) async {
    await (update(cobros)..where((t) => t.id.equals(id))).write(
      CobrosCompanion(
        fecha: Value(fecha),
        importe: Value(importe),
        metodoPago: Value(metodoPago),
        referencia: Value(referencia),
        observaciones: Value(observaciones),
        fechaModificacion: Value(DateTime.now()),
      ),
    );
  }

  Future<void> eliminarCobro(String id) async {
    await (delete(cobros)..where((t) => t.id.equals(id))).go();
  }

  Future<void> eliminarPorFactura(String facturaId) async {
    await (delete(cobros)..where((t) => t.facturaId.equals(facturaId))).go();
  }
}

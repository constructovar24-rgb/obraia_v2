import 'package:drift/drift.dart';

import 'facturas.dart';

class FacturaLineas extends Table {
  TextColumn get id => text()();

  TextColumn get facturaId => text().references(Facturas, #id)();

  TextColumn get lineaRectificadaId =>
      text().nullable().references(FacturaLineas, #id)();

  TextColumn get lineaRaizId =>
      text().nullable().references(FacturaLineas, #id)();

  TextColumn get descripcion => text()();

  RealColumn get cantidad => real()();

  TextColumn get unidad => text().withDefault(const Constant('ud'))();

  RealColumn get precioUnitario => real()();

  RealColumn get descuento => real().withDefault(const Constant(0))();

  RealColumn get importe => real().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

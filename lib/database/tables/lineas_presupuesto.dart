import 'package:drift/drift.dart';

import 'presupuestos.dart';

class LineasPresupuesto extends Table {
  TextColumn get id => text()();

  TextColumn get presupuestoId => text().references(Presupuestos, #id)();

  TextColumn get concepto => text()();

  RealColumn get cantidad => real()();

  RealColumn get precioUnitario => real()();

  @override
  Set<Column> get primaryKey => {id};
}

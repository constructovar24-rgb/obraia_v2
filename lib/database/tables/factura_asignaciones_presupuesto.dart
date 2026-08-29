import 'package:drift/drift.dart';

import 'certificaciones.dart';
import 'factura_lineas.dart';
import 'facturas.dart';
import 'lineas_presupuesto.dart';
import 'presupuestos.dart';

class FacturaAsignacionesPresupuesto extends Table {
  TextColumn get id => text()();
  TextColumn get facturaId => text().references(Facturas, #id)();
  TextColumn get facturaLineaId => text().references(FacturaLineas, #id)();
  TextColumn get presupuestoId => text().references(Presupuestos, #id)();
  TextColumn get lineaPresupuestoId =>
      text().references(LineasPresupuesto, #id)();
  RealColumn get cantidadAplicada => real().nullable()();
  RealColumn get baseAplicada => real()();
  TextColumn get certificacionOrigenId =>
      text().nullable().references(Certificaciones, #id)();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {facturaLineaId},
  ];
}

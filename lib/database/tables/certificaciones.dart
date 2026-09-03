// ignore_for_file: unused_import

import 'package:drift/drift.dart';

import 'expedientes.dart';
import 'presupuestos.dart';
import 'tenants.dart';

class Certificaciones extends Table {
  TextColumn get tenantId => text()
      .clientDefault(() => defaultTenantIdForTesting)
      .references(Tenants, #id)();

  TextColumn get id => text()();

  TextColumn get expedienteId => text()();

  TextColumn get presupuestoId => text().nullable()();

  TextColumn get codigo => text().withDefault(const Constant(''))();

  DateTimeColumn get fecha => dateTime().withDefault(currentDateAndTime)();

  TextColumn get descripcion => text().withDefault(const Constant(''))();

  RealColumn get baseImponible => real().withDefault(const Constant(0))();

  RealColumn get ivaPorcentaje => real().withDefault(const Constant(0))();

  RealColumn get importeTotal => real().withDefault(const Constant(0))();

  TextColumn get estado => text().withDefault(const Constant('borrador'))();

  TextColumn get observaciones => text().nullable()();

  BoolColumn get eliminado => boolean().withDefault(const Constant(false))();

  DateTimeColumn get fechaCreacion =>
      dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get fechaModificacion =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {tenantId, id},
  ];

  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (tenant_id, expediente_id) REFERENCES expedientes (tenant_id, id)',
    'FOREIGN KEY (tenant_id, presupuesto_id) REFERENCES presupuestos (tenant_id, id)',
  ];
}

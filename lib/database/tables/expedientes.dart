// ignore_for_file: unused_import

import 'package:drift/drift.dart';

import 'clientes.dart';
import 'tenants.dart';

class Expedientes extends Table {
  TextColumn get tenantId => text()
      .clientDefault(() => defaultTenantIdForTesting)
      .references(Tenants, #id)();

  TextColumn get id => text()();

  TextColumn get codigo => text()();

  TextColumn get nombre => text()();

  // Cliente / Promotor
  TextColumn get cliente => text().withDefault(const Constant(''))();

  TextColumn get clienteId => text().nullable()();

  // Datos de ubicación
  TextColumn get direccion => text().withDefault(const Constant(''))();

  TextColumn get poblacion => text().withDefault(const Constant(''))();

  TextColumn get provincia => text().withDefault(const Constant(''))();

  TextColumn get codigoPostal => text().withDefault(const Constant(''))();

  TextColumn get pais => text().withDefault(const Constant('España'))();

  // Estado del expediente
  IntColumn get estado => integer().withDefault(const Constant(0))();

  TextColumn get estadoOperativo =>
      text().withDefault(const Constant('pendiente'))();

  DateTimeColumn get fechaInicioPrevista => dateTime().nullable()();
  DateTimeColumn get fechaFinPrevista => dateTime().nullable()();
  DateTimeColumn get fechaInicioReal => dateTime().nullable()();
  DateTimeColumn get fechaFinReal => dateTime().nullable()();

  BoolColumn get eliminado => boolean().withDefault(const Constant(false))();

  // Fechas
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
    'FOREIGN KEY (tenant_id, cliente_id) REFERENCES clientes (tenant_id, id)',
  ];
}

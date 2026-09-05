// ignore_for_file: unused_import

import 'package:drift/drift.dart';

import 'expedientes.dart';
import 'tenants.dart';

class IncidenciasObra extends Table {
  TextColumn get tenantId => text().references(Tenants, #id)();
  TextColumn get id => text()();
  TextColumn get expedienteId => text()();
  DateTimeColumn get fechaDeteccion => dateTime()();
  TextColumn get titulo => text()();
  TextColumn get descripcion => text()();
  TextColumn get estado => text().withDefault(const Constant('abierta'))();
  TextColumn get prioridad => text().withDefault(const Constant('media'))();
  DateTimeColumn get fechaResolucion => dateTime().nullable()();
  TextColumn get resolucion => text().nullable()();
  DateTimeColumn get fechaCreacion =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get fechaModificacion =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {tenantId, id};

  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (tenant_id, expediente_id) REFERENCES expedientes (tenant_id, id)',
    "CHECK (estado IN ('abierta', 'enSeguimiento', 'resuelta', 'cancelada'))",
    "CHECK (prioridad IN ('baja', 'media', 'alta'))",
    'CHECK (length(trim(titulo)) > 0)',
    'CHECK (length(trim(descripcion)) > 0)',
    'CHECK (fecha_resolucion IS NULL OR fecha_resolucion >= fecha_deteccion)',
    "CHECK ((estado = 'resuelta' AND fecha_resolucion IS NOT NULL) OR estado != 'resuelta')",
  ];
}

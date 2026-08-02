// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'certificaciones_dao.dart';

// ignore_for_file: type=lint
mixin _$CertificacionesDaoMixin on DatabaseAccessor<AppDatabase> {
  $ClientesTable get clientes => attachedDatabase.clientes;
  $ExpedientesTable get expedientes => attachedDatabase.expedientes;
  $PresupuestosTable get presupuestos => attachedDatabase.presupuestos;
  $CertificacionesTable get certificaciones => attachedDatabase.certificaciones;
  CertificacionesDaoManager get managers => CertificacionesDaoManager(this);
}

class CertificacionesDaoManager {
  final _$CertificacionesDaoMixin _db;
  CertificacionesDaoManager(this._db);
  $$ClientesTableTableManager get clientes =>
      $$ClientesTableTableManager(_db.attachedDatabase, _db.clientes);
  $$ExpedientesTableTableManager get expedientes =>
      $$ExpedientesTableTableManager(_db.attachedDatabase, _db.expedientes);
  $$PresupuestosTableTableManager get presupuestos =>
      $$PresupuestosTableTableManager(_db.attachedDatabase, _db.presupuestos);
  $$CertificacionesTableTableManager get certificaciones =>
      $$CertificacionesTableTableManager(
        _db.attachedDatabase,
        _db.certificaciones,
      );
}

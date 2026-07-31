// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'empresa_configuracion_dao.dart';

// ignore_for_file: type=lint
mixin _$EmpresaConfiguracionDaoMixin on DatabaseAccessor<AppDatabase> {
  $EmpresaConfiguracionTable get empresaConfiguracion =>
      attachedDatabase.empresaConfiguracion;
  EmpresaConfiguracionDaoManager get managers =>
      EmpresaConfiguracionDaoManager(this);
}

class EmpresaConfiguracionDaoManager {
  final _$EmpresaConfiguracionDaoMixin _db;
  EmpresaConfiguracionDaoManager(this._db);
  $$EmpresaConfiguracionTableTableManager get empresaConfiguracion =>
      $$EmpresaConfiguracionTableTableManager(
        _db.attachedDatabase,
        _db.empresaConfiguracion,
      );
}

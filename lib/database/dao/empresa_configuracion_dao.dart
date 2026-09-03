import 'package:drift/drift.dart';

import '../../features/configuracion/domain/empresa_configuracion.dart'
    as empresa_domain;
import '../app_database.dart';
import '../tables/empresa_configuracion.dart';

part 'empresa_configuracion_dao.g.dart';

@DriftAccessor(tables: [EmpresaConfiguracion])
class EmpresaConfiguracionDao extends DatabaseAccessor<AppDatabase>
    with _$EmpresaConfiguracionDaoMixin {
  EmpresaConfiguracionDao(super.db);

  Stream<empresa_domain.EmpresaConfiguracion?> observarConfiguracion() {
    return (select(empresaConfiguracion)
          ..where((t) => t.tenantId.equals(attachedDatabase.activeTenantId))
          ..limit(1))
        .watchSingleOrNull()
        .map((row) => row == null ? null : _toDomain(row));
  }

  Future<empresa_domain.EmpresaConfiguracion?> obtenerConfiguracion() async {
    final row =
        await (select(empresaConfiguracion)
              ..where((t) => t.tenantId.equals(attachedDatabase.activeTenantId))
              ..limit(1))
            .getSingleOrNull();
    if (row == null) {
      return null;
    }

    return _toDomain(row);
  }

  Future<void> insertarConfiguracion(
    EmpresaConfiguracionCompanion companion,
  ) async {
    await into(empresaConfiguracion).insert(
      companion.copyWith(tenantId: Value(attachedDatabase.activeTenantId)),
    );
  }

  Future<void> actualizarConfiguracion(
    String id,
    EmpresaConfiguracionCompanion companion,
  ) async {
    await (update(empresaConfiguracion)..where(
          (t) =>
              t.tenantId.equals(attachedDatabase.activeTenantId) &
              t.id.equals(id),
        ))
        .write(companion);
  }

  empresa_domain.EmpresaConfiguracion _toDomain(EmpresaConfiguracionData row) {
    return empresa_domain.EmpresaConfiguracion(
      id: row.id,
      nombreEmpresa: row.nombreEmpresa,
      cif: row.cif,
      direccion: row.direccion,
      codigoPostal: row.codigoPostal,
      poblacion: row.poblacion,
      provincia: row.provincia,
      telefono: row.telefono,
      email: row.email,
      web: row.web,
      logoPath: row.logoPath,
    );
  }
}

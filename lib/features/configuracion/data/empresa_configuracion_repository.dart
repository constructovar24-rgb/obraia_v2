import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../database/app_database.dart';
import '../../../../database/database_provider.dart';
import '../domain/empresa_configuracion.dart' as empresa_domain;

final empresaConfiguracionRepositoryProvider =
    Provider<EmpresaConfiguracionRepository>((ref) {
      ref.watch(activeTenantIdProvider);
      final database = ref.watch(databaseProvider);
      return EmpresaConfiguracionRepository(database);
    });

class EmpresaConfiguracionRepository {
  final AppDatabase database;

  EmpresaConfiguracionRepository(this.database);

  Stream<empresa_domain.EmpresaConfiguracion?> observarConfiguracion() {
    return database.empresaConfiguracionDao.observarConfiguracion();
  }

  Future<empresa_domain.EmpresaConfiguracion>
  obtenerOCrearConfiguracion() async {
    final existente = await database.empresaConfiguracionDao
        .obtenerConfiguracion();
    if (existente != null) {
      return existente;
    }

    await database.empresaConfiguracionDao.insertarConfiguracion(
      EmpresaConfiguracionCompanion(
        id: Value(const Uuid().v4()),
        nombreEmpresa: const Value(''),
        cif: const Value(''),
        direccion: const Value(''),
        codigoPostal: const Value(''),
        poblacion: const Value(''),
        provincia: const Value(''),
        telefono: const Value(''),
        email: const Value(''),
        web: const Value(''),
        logoPath: const Value(null),
      ),
    );

    return (await database.empresaConfiguracionDao.obtenerConfiguracion())!;
  }

  Future<void> guardarConfiguracion({
    required String nombreEmpresa,
    required String cif,
    required String direccion,
    required String codigoPostal,
    required String poblacion,
    required String provincia,
    required String telefono,
    required String email,
    required String web,
    String? logoPath,
  }) async {
    final configuracion = await obtenerOCrearConfiguracion();

    await database.empresaConfiguracionDao.actualizarConfiguracion(
      configuracion.id,
      EmpresaConfiguracionCompanion(
        nombreEmpresa: Value(nombreEmpresa),
        cif: Value(cif),
        direccion: Value(direccion),
        codigoPostal: Value(codigoPostal),
        poblacion: Value(poblacion),
        provincia: Value(provincia),
        telefono: Value(telefono),
        email: Value(email),
        web: Value(web),
        logoPath: Value(logoPath),
      ),
    );
  }
}

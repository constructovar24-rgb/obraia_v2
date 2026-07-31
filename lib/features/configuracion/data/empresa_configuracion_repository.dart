import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../database/app_database.dart';
import '../../../../database/database_provider.dart';
import '../domain/empresa_configuracion.dart' as empresa_domain;

const String _empresaConfiguracionId = 'empresa_principal';

final empresaConfiguracionRepositoryProvider =
    Provider<EmpresaConfiguracionRepository>((ref) {
      final database = ref.read(databaseProvider);
      return EmpresaConfiguracionRepository(database);
    });

class EmpresaConfiguracionRepository {
  final AppDatabase database;

  EmpresaConfiguracionRepository(this.database);

  Stream<empresa_domain.EmpresaConfiguracion?> observarConfiguracion() {
    return database.empresaConfiguracionDao.observarConfiguracion();
  }

  Future<empresa_domain.EmpresaConfiguracion> obtenerOCrearConfiguracion() async {
    final existente = await database.empresaConfiguracionDao.obtenerConfiguracion();
    if (existente != null) {
      return existente;
    }

    await database.empresaConfiguracionDao.insertarConfiguracion(
      const EmpresaConfiguracionCompanion(
        id: Value(_empresaConfiguracionId),
        nombreEmpresa: Value(''),
        cif: Value(''),
        direccion: Value(''),
        codigoPostal: Value(''),
        poblacion: Value(''),
        provincia: Value(''),
        telefono: Value(''),
        email: Value(''),
        web: Value(''),
        logoPath: Value(null),
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

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/database/database_provider.dart';
import 'package:obraia_v2/features/expedientes/domain/expediente.dart'
    as expediente_domain;

final expedienteRepositoryProvider = Provider<ExpedienteRepository>((ref) {
  final database = ref.read(databaseProvider);
  return ExpedienteRepository(database);
});

class ExpedienteRepository {
  final AppDatabase database;

  ExpedienteRepository(this.database);

  Future<void> crearExpediente({
    required String codigo,
    required String nombre,
    String? clienteId,
    String? cliente,
  }) {
    return database.crearExpediente(
      codigo: codigo,
      nombre: nombre,
      clienteId: clienteId,
      cliente: cliente,
    );
  }

  Stream<List<expediente_domain.Expediente>> observarExpedientes() {
    return database.expedientesDao.observarExpedientes();
  }

  Future<expediente_domain.Expediente?> obtenerExpediente(String id) {
    return database.expedientesDao.obtenerExpediente(id);
  }

  Future<void> actualizarExpediente({
    required String id,
    required String codigo,
    required String nombre,
    String? clienteId,
    String? cliente,
    required String direccion,
    required String poblacion,
    required String provincia,
    required String codigoPostal,
  }) {
    return database.actualizarExpediente(
      id: id,
      codigo: codigo,
      nombre: nombre,
      clienteId: clienteId,
      cliente: cliente,
      direccion: direccion,
      poblacion: poblacion,
      provincia: provincia,
      codigoPostal: codigoPostal,
    );
  }
}
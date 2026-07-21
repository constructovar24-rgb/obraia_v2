import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/database/database_provider.dart';

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
  }) {
    return database.crearExpediente(
      codigo: codigo,
      nombre: nombre,
    );
  }

  Stream<List<Expediente>> observarExpedientes() {
    return database.observarExpedientes();
  }

  Future<Expediente?> obtenerExpediente(String id) {
    return database.obtenerExpediente(id);
  }

  Future<void> actualizarExpediente({
    required String id,
    required String codigo,
    required String nombre,
    required String cliente,
    required String direccion,
    required String poblacion,
    required String provincia,
    required String codigoPostal,
  }) {
    return database.actualizarExpediente(
      id: id,
      codigo: codigo,
      nombre: nombre,
      cliente: cliente,
      direccion: direccion,
      poblacion: poblacion,
      provincia: provincia,
      codigoPostal: codigoPostal,
    );
  }
}
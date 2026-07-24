import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/database/database_provider.dart';
import 'package:obraia_v2/features/clientes/domain/cliente.dart' as cliente_domain;
import 'package:uuid/uuid.dart';

final clienteRepositoryProvider = Provider<ClienteRepository>((ref) {
  final database = ref.read(databaseProvider);
  return ClienteRepository(database);
});

class ClienteRepository {
  final AppDatabase database;

  ClienteRepository(this.database);

  Future<void> crearCliente({
    required String nombre,
    required String apellidos,
    required String nif,
    required String telefono,
    required String email,
    required String direccion,
    required String poblacion,
    required String provincia,
    required String codigoPostal,
    required String pais,
    required String empresa,
    required String observaciones,
  }) {
    return database.clientesDao.insertarCliente(
      ClientesCompanion(
        id: Value(const Uuid().v4()),
        nombre: Value(nombre),
        apellidos: Value(apellidos),
        nif: Value(nif),
        telefono: Value(telefono),
        email: Value(email),
        direccion: Value(direccion),
        poblacion: Value(poblacion),
        provincia: Value(provincia),
        codigoPostal: Value(codigoPostal),
        pais: Value(pais),
        empresa: Value(empresa),
        observaciones: Value(observaciones),
      ),
    );
  }

  Stream<List<cliente_domain.Cliente>> observarClientes() {
    return database.clientesDao.observarClientes();
  }

  Future<cliente_domain.Cliente?> obtenerCliente(String id) {
    return database.clientesDao.obtenerCliente(id);
  }

  Future<void> actualizarCliente({
    required String id,
    required String nombre,
    required String apellidos,
    required String nif,
    required String telefono,
    required String email,
    required String direccion,
    required String poblacion,
    required String provincia,
    required String codigoPostal,
    required String pais,
    required String empresa,
    required String observaciones,
  }) {
    return database.clientesDao.actualizarCliente(
      id,
      ClientesCompanion(
        nombre: Value(nombre),
        apellidos: Value(apellidos),
        nif: Value(nif),
        telefono: Value(telefono),
        email: Value(email),
        direccion: Value(direccion),
        poblacion: Value(poblacion),
        provincia: Value(provincia),
        codigoPostal: Value(codigoPostal),
        pais: Value(pais),
        empresa: Value(empresa),
        observaciones: Value(observaciones),
        fechaModificacion: Value(DateTime.now()),
      ),
    );
  }

  Future<void> eliminarCliente(String id) {
    return database.clientesDao.eliminarLogicamente(id);
  }
}

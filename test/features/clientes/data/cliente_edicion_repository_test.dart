import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/features/clientes/data/cliente_repository.dart';

void main() {
  test('editar cliente persiste el nombre nuevo al volver a leerlo', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final repository = ClienteRepository(database);
    try {
      await database.clientesDao.insertarCliente(
        ClientesCompanion.insert(
          id: 'cliente-1',
          nombre: 'PRUEBA BACKUP OBRA IA',
        ),
      );
      await repository.actualizarCliente(
        id: 'cliente-1',
        nombre: 'PRUEBA MODIFICADA DESPUÉS BACKUP',
        apellidos: '',
        nif: '',
        telefono: '',
        email: '',
        direccion: '',
        poblacion: '',
        provincia: '',
        codigoPostal: '',
        pais: '',
        empresa: '',
        observaciones: '',
      );
      expect(
        (await repository.obtenerCliente('cliente-1'))!.nombre,
        'PRUEBA MODIFICADA DESPUÉS BACKUP',
      );
    } finally {
      await database.close();
    }
  });
}

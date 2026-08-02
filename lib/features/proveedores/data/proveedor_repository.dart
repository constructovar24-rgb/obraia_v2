import 'package:uuid/uuid.dart';

import '../../../database/dao/proveedores_dao.dart';
import '../domain/proveedor.dart';
import 'proveedor_mapper.dart';

class ProveedorRepository {
  ProveedorRepository(this._dao);

  final ProveedoresDao _dao;

  Future<void> registrarProveedor(Proveedor proveedor) async {
    final proveedorConId = Proveedor(
      id: const Uuid().v4(),
      nombre: proveedor.nombre,
      personaContacto: proveedor.personaContacto,
      nif: proveedor.nif,
      telefono: proveedor.telefono,
      email: proveedor.email,
      direccion: proveedor.direccion,
      poblacion: proveedor.poblacion,
      provincia: proveedor.provincia,
      codigoPostal: proveedor.codigoPostal,
      pais: proveedor.pais,
      observaciones: proveedor.observaciones,
    );

    await _dao.insertarProveedor(proveedorConId.toCompanion());
  }

  Future<List<Proveedor>> obtenerProveedores() async {
    final rows = await _dao.obtenerProveedores();
    return rows.map((row) => row.toDomain()).toList();
  }

  Stream<List<Proveedor>> observarProveedores() {
    return _dao.observarProveedores().map(
      (rows) => rows.map((row) => row.toDomain()).toList(),
    );
  }

  Future<void> actualizarProveedor(Proveedor proveedor) {
    return _dao.actualizarProveedor(proveedor.id, proveedor.toCompanion());
  }

  Future<void> eliminarProveedor(String proveedorId) {
    return _dao.eliminarLogicamente(proveedorId);
  }
}

import 'package:drift/drift.dart';

import '../../../database/app_database.dart' as db;
import '../domain/proveedor.dart';

typedef ProveedorData = db.Proveedore;

extension ProveedorDataMapper on ProveedorData {
  Proveedor toDomain() {
    return Proveedor(
      id: id,
      nombre: nombre,
      personaContacto: personaContacto,
      nif: nif,
      telefono: telefono,
      email: email,
      direccion: direccion,
      poblacion: poblacion,
      provincia: provincia,
      codigoPostal: codigoPostal,
      pais: pais,
      observaciones: observaciones,
    );
  }
}

extension ProveedorMapper on Proveedor {
  db.ProveedoresCompanion toCompanion() {
    return db.ProveedoresCompanion(
      id: Value(id),
      nombre: Value(nombre),
      personaContacto: Value(personaContacto),
      nif: Value(nif),
      telefono: Value(telefono),
      email: Value(email),
      direccion: Value(direccion),
      poblacion: Value(poblacion),
      provincia: Value(provincia),
      codigoPostal: Value(codigoPostal),
      pais: Value(pais),
      observaciones: Value(observaciones),
    );
  }
}

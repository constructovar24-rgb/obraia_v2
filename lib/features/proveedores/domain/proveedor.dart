class Proveedor {
  final String id;
  final String nombre;
  final String? personaContacto;
  final String nif;
  final String telefono;
  final String email;
  final String direccion;
  final String poblacion;
  final String provincia;
  final String codigoPostal;
  final String pais;
  final String observaciones;

  const Proveedor({
    required this.id,
    required this.nombre,
    required this.personaContacto,
    required this.nif,
    required this.telefono,
    required this.email,
    required this.direccion,
    required this.poblacion,
    required this.provincia,
    required this.codigoPostal,
    required this.pais,
    required this.observaciones,
  });
}

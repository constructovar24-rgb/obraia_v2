class Cliente {
  final String id;
  final String nombre;
  final String apellidos;
  final String nif;
  final String telefono;
  final String email;
  final String direccion;
  final String poblacion;
  final String provincia;
  final String codigoPostal;
  final String pais;
  final String empresa;
  final String observaciones;
  final int estado;
  final bool eliminado;
  final DateTime fechaCreacion;
  final DateTime fechaModificacion;

  const Cliente({
    required this.id,
    required this.nombre,
    required this.apellidos,
    required this.nif,
    required this.telefono,
    required this.email,
    required this.direccion,
    required this.poblacion,
    required this.provincia,
    required this.codigoPostal,
    required this.pais,
    required this.empresa,
    required this.observaciones,
    required this.estado,
    required this.eliminado,
    required this.fechaCreacion,
    required this.fechaModificacion,
  });
}

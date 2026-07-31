class EmpresaConfiguracion {
  final String id;
  final String nombreEmpresa;
  final String cif;
  final String direccion;
  final String codigoPostal;
  final String poblacion;
  final String provincia;
  final String telefono;
  final String email;
  final String web;
  final String? logoPath;

  const EmpresaConfiguracion({
    required this.id,
    required this.nombreEmpresa,
    required this.cif,
    required this.direccion,
    required this.codigoPostal,
    required this.poblacion,
    required this.provincia,
    required this.telefono,
    required this.email,
    required this.web,
    required this.logoPath,
  });

  EmpresaConfiguracion copyWith({
    String? id,
    String? nombreEmpresa,
    String? cif,
    String? direccion,
    String? codigoPostal,
    String? poblacion,
    String? provincia,
    String? telefono,
    String? email,
    String? web,
    String? logoPath,
  }) {
    return EmpresaConfiguracion(
      id: id ?? this.id,
      nombreEmpresa: nombreEmpresa ?? this.nombreEmpresa,
      cif: cif ?? this.cif,
      direccion: direccion ?? this.direccion,
      codigoPostal: codigoPostal ?? this.codigoPostal,
      poblacion: poblacion ?? this.poblacion,
      provincia: provincia ?? this.provincia,
      telefono: telefono ?? this.telefono,
      email: email ?? this.email,
      web: web ?? this.web,
      logoPath: logoPath ?? this.logoPath,
    );
  }
}

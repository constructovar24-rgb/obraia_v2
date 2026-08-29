class EstadoPresupuestoException implements Exception {
  const EstadoPresupuestoException(this.mensaje);

  final String mensaje;

  @override
  String toString() => mensaje;
}

bool estadoPresupuestoEsBorrador(String estado) {
  return estado.trim().toLowerCase() == 'borrador';
}

bool estadoPresupuestoEsAceptado(String estado) {
  return estado.trim().toLowerCase() == 'aceptado';
}

bool puedeAceptarPresupuesto(String estado) {
  return estadoPresupuestoEsBorrador(estado);
}

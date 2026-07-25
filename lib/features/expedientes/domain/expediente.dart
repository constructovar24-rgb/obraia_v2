class Expediente {
  final String id;
  final String codigo;
  final String nombre;
  final String? clienteId;
  final String? clienteNombre;

  const Expediente({
    required this.id,
    required this.codigo,
    required this.nombre,
    this.clienteId,
    this.clienteNombre,
  });
}
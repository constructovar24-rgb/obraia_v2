import 'estado_factura.dart';

class Factura {
  final String id;
  final String codigo;
  final String clienteId;
  final String clienteNombre;
  final DateTime fecha;
  final DateTime fechaVencimiento;
  final EstadoFactura estado;
  final double subtotal;
  final double iva;
  final double ivaPorcentaje;
  final double total;
  final String observaciones;
  final String? presupuestoOrigenId;

  const Factura({
    required this.id,
    required this.codigo,
    required this.clienteId,
    required this.clienteNombre,
    required this.fecha,
    required this.fechaVencimiento,
    required this.estado,
    required this.subtotal,
    required this.iva,
    required this.ivaPorcentaje,
    required this.total,
    required this.observaciones,
    this.presupuestoOrigenId,
  });
}

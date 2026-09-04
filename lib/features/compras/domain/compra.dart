enum CompraEstado { pendiente, pagada, anulada }

enum CompraClasificacionEconomica { provisional, incurrido, anulada }

class Compra {
  final String id;
  final String expedienteId;
  final String? proveedorId;
  final String proveedorNombre;
  final DateTime fecha;
  final String? numeroFactura;
  final String concepto;
  final double baseImponible;
  final double ivaPorcentaje;
  final double importeTotal;
  final CompraEstado estado;
  final CompraClasificacionEconomica clasificacionEconomica;
  final String? observaciones;

  const Compra({
    required this.id,
    required this.expedienteId,
    this.proveedorId,
    required this.proveedorNombre,
    required this.fecha,
    this.numeroFactura,
    required this.concepto,
    required this.baseImponible,
    required this.ivaPorcentaje,
    required this.importeTotal,
    required this.estado,
    this.clasificacionEconomica = CompraClasificacionEconomica.provisional,
    this.observaciones,
  });
}

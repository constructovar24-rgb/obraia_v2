import 'estado_factura.dart';

class Factura {
  final String id;
  final String codigo;
  final int? anioNumeracion;
  final int? numeroLegal;
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
  final DateTime? fechaEmision;
  final String clienteNombreHistorico;
  final String clienteNifHistorico;
  final String clienteDireccionHistorica;
  final String clienteTelefonoHistorico;
  final String clienteEmailHistorico;
  final String empresaNombreHistorico;
  final String empresaCifHistorico;
  final String empresaDireccionHistorica;
  final String empresaCodigoPostalHistorico;
  final String empresaPoblacionHistorica;
  final String empresaProvinciaHistorica;
  final String empresaTelefonoHistorico;
  final String empresaEmailHistorico;
  final String empresaWebHistorica;
  final String expedienteOrigenIdHistorico;
  final String expedienteCodigoHistorico;
  final String expedienteNombreHistorico;
  final String presupuestoCodigoHistorico;

  const Factura({
    required this.id,
    required this.codigo,
    this.anioNumeracion,
    this.numeroLegal,
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
    this.fechaEmision,
    this.clienteNombreHistorico = '',
    this.clienteNifHistorico = '',
    this.clienteDireccionHistorica = '',
    this.clienteTelefonoHistorico = '',
    this.clienteEmailHistorico = '',
    this.empresaNombreHistorico = '',
    this.empresaCifHistorico = '',
    this.empresaDireccionHistorica = '',
    this.empresaCodigoPostalHistorico = '',
    this.empresaPoblacionHistorica = '',
    this.empresaProvinciaHistorica = '',
    this.empresaTelefonoHistorico = '',
    this.empresaEmailHistorico = '',
    this.empresaWebHistorica = '',
    this.expedienteOrigenIdHistorico = '',
    this.expedienteCodigoHistorico = '',
    this.expedienteNombreHistorico = '',
    this.presupuestoCodigoHistorico = '',
  });

  bool get tieneInstantaneaHistorica => fechaEmision != null;
}

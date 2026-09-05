enum PrioridadRecomendacion { critica, alta, media, baja }

enum CategoriaRecomendacion {
  comercial,
  planificacion,
  ejecucion,
  incidencia,
  suministros,
  facturacion,
  cobros,
  proveedores,
  economia,
  cierre,
}

class RecomendacionOperativa {
  const RecomendacionOperativa({
    required this.reglaId,
    required this.categoria,
    required this.prioridad,
    required this.titulo,
    required this.explicacion,
    required this.accion,
    required this.destino,
    this.entidadId,
    this.fechaObjetivo,
  });
  final String reglaId;
  final CategoriaRecomendacion categoria;
  final PrioridadRecomendacion prioridad;
  final String titulo;
  final String explicacion;
  final String accion;
  final String destino;
  final String? entidadId;
  final DateTime? fechaObjetivo;
}

class RecommendationContext {
  const RecommendationContext({
    required this.expedienteId,
    required this.hoy,
    this.tienePresupuestos = false,
    this.tienePresupuestoAceptado = false,
    this.tienePresupuestoBorrador = false,
    this.estadoOperativo = 'pendiente',
    this.inicioPrevisto,
    this.proximoPaso,
    this.actuacionesVencidas = 0,
    this.incidenciasAltasAbiertas = 0,
    this.facturasClientePendientesCentimos = 0,
    this.facturaProveedorVencidaPendiente = false,
    this.albaranesPendientesFactura = 0,
    this.documentosPendientesReconciliar = 0,
    this.economiaCerrada = false,
    this.perdidaPrevistaCentimos = 0,
  });
  final String expedienteId;
  final DateTime hoy;
  final bool tienePresupuestos;
  final bool tienePresupuestoAceptado;
  final bool tienePresupuestoBorrador;
  final String estadoOperativo;
  final DateTime? inicioPrevisto;
  final String? proximoPaso;
  final int actuacionesVencidas;
  final int incidenciasAltasAbiertas;
  final int facturasClientePendientesCentimos;
  final bool facturaProveedorVencidaPendiente;
  final int albaranesPendientesFactura;
  final int documentosPendientesReconciliar;
  final bool economiaCerrada;
  final int perdidaPrevistaCentimos;
}

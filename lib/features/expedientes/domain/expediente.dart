enum ExpedienteEstadoCiclo {
  activo,
  archivado,
}

const _expedienteEstadoActivoDb = 0;
const _expedienteEstadoArchivadoDb = 1;

ExpedienteEstadoCiclo expedienteEstadoCicloFromDbValue(int? value) {
  switch (value) {
    case _expedienteEstadoArchivadoDb:
      return ExpedienteEstadoCiclo.archivado;
    case _expedienteEstadoActivoDb:
    default:
      // Defensive fallback for null or unknown legacy values.
      return ExpedienteEstadoCiclo.activo;
  }
}

int expedienteEstadoCicloToDbValue(ExpedienteEstadoCiclo estado) {
  switch (estado) {
    case ExpedienteEstadoCiclo.archivado:
      return _expedienteEstadoArchivadoDb;
    case ExpedienteEstadoCiclo.activo:
      return _expedienteEstadoActivoDb;
  }
}

class Expediente {
  final String id;
  final String codigo;
  final String nombre;
  final ExpedienteEstadoCiclo estadoCiclo;
  final String? clienteId;
  final String? clienteNombre;

  const Expediente({
    required this.id,
    required this.codigo,
    required this.nombre,
    required this.estadoCiclo,
    this.clienteId,
    this.clienteNombre,
  });
}

enum ExpedienteAtencionNivel {
  correcto,
  aviso,
  critico,
}

enum ExpedienteAtencionIndicador {
  sinAccionesPendientes,
  sinPresupuestos,
  presupuestoPendienteAceptacion,
  presupuestoAceptadoSinFactura,
  facturaPendienteCobro,
}

class ExpedienteAtencionEstado {
  const ExpedienteAtencionEstado({
    required this.nivel,
    required this.mensajePrincipal,
    this.detalle,
    required this.indicadorPrincipal,
  });

  final ExpedienteAtencionNivel nivel;
  final String mensajePrincipal;
  final String? detalle;
  final ExpedienteAtencionIndicador indicadorPrincipal;

  bool get requiereAtencion => nivel != ExpedienteAtencionNivel.correcto;
}
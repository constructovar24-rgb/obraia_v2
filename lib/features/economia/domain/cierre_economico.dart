import 'prevision_economica.dart';

enum EstadoEconomicoObra { abierto, cerrado }

enum SeveridadControlCierre { informacion, advertencia, bloqueo }

enum SeveridadAlertaEconomica { informacion, atencion, critica }

class ControlCierreEconomico {
  const ControlCierreEconomico(this.codigo, this.mensaje, this.severidad);
  final String codigo;
  final String mensaje;
  final SeveridadControlCierre severidad;
}

class AlertaEconomica {
  const AlertaEconomica(this.codigo, this.mensaje, this.severidad);
  final String codigo;
  final String mensaje;
  final SeveridadAlertaEconomica severidad;
}

class PrecheckCierreEconomico {
  const PrecheckCierreEconomico(this.controles);
  final List<ControlCierreEconomico> controles;
  bool get tieneBloqueos =>
      controles.any((c) => c.severidad == SeveridadControlCierre.bloqueo);
  bool get tieneAdvertencias =>
      controles.any((c) => c.severidad == SeveridadControlCierre.advertencia);
}

class EstadoCierreEconomico {
  const EstadoCierreEconomico({
    required this.estado,
    required this.numeroCierres,
    this.ultimoCierre,
  });
  final EstadoEconomicoObra estado;
  final int numeroCierres;
  final CierreEconomicoSnapshot? ultimoCierre;
}

class CierreEconomicoSnapshot {
  const CierreEconomicoSnapshot({
    required this.id,
    required this.numero,
    required this.fechaCierre,
    required this.resumen,
    required this.conAdvertencias,
    required this.resumenPrecheck,
  });
  final String id;
  final int numero;
  final DateTime fechaCierre;
  final ResumenForecastObra resumen;
  final bool conAdvertencias;
  final String resumenPrecheck;
}

class ReaperturaEconomica {
  const ReaperturaEconomica({
    required this.id,
    required this.cierreId,
    required this.fecha,
    required this.motivo,
  });
  final String id;
  final String cierreId;
  final DateTime fecha;
  final String motivo;
}

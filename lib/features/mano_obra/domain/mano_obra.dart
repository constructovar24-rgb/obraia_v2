enum TipoPersonaLaboral { titular, empleado, colaboradorInterno, otroInterno }

enum EstadoParteTrabajo { pendienteValoracion, valorado, revertido }

enum CoberturaManoObra { sinHoras, completa, parcial, sinValorar }

class PersonaLaboral {
  const PersonaLaboral({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.activa,
    this.observaciones,
  });
  final String id;
  final String nombre;
  final TipoPersonaLaboral tipo;
  final bool activa;
  final String? observaciones;
}

class TarifaPersona {
  const TarifaPersona({
    required this.id,
    required this.personaId,
    required this.importeHoraCentimos,
    required this.vigenteDesde,
    this.vigenteHasta,
    this.nota,
  });
  final String id;
  final String personaId;
  final int importeHoraCentimos;
  final DateTime vigenteDesde;
  final DateTime? vigenteHasta;
  final String? nota;
}

class ParteTrabajo {
  const ParteTrabajo({
    required this.id,
    required this.expedienteId,
    required this.personaId,
    required this.fechaTrabajo,
    required this.horasDiezMilesimas,
    required this.descripcionTrabajo,
    required this.categoriaEconomicaId,
    required this.estado,
    this.planEconomicoId,
    this.planEconomicoPartidaId,
    this.tarifaOrigenId,
    this.tarifaHoraSnapshotCentimos,
    this.costeSnapshotCentimos,
    this.hechoCosteId,
  });
  final String id;
  final String expedienteId;
  final String personaId;
  final DateTime fechaTrabajo;
  final int horasDiezMilesimas;
  final String descripcionTrabajo;
  final String categoriaEconomicaId;
  final String? planEconomicoId;
  final String? planEconomicoPartidaId;
  final String? tarifaOrigenId;
  final int? tarifaHoraSnapshotCentimos;
  final int? costeSnapshotCentimos;
  final EstadoParteTrabajo estado;
  final String? hechoCosteId;
  double get horas => horasDiezMilesimas / 10000;
}

class ResumenPersonaManoObra {
  const ResumenPersonaManoObra({
    required this.personaId,
    required this.horasDiezMilesimas,
    required this.costeCentimos,
    required this.expedientes,
  });
  final String personaId;
  final int horasDiezMilesimas;
  final int costeCentimos;
  final Set<String> expedientes;
}

class ResumenManoObra {
  const ResumenManoObra({
    required this.horasTotalesDiezMilesimas,
    required this.horasValoradasDiezMilesimas,
    required this.horasSinValorarDiezMilesimas,
    required this.costeRealCentimos,
    required this.costeSinPartidaCentimos,
    required this.costePorPersonaCentimos,
    required this.horasPorPersonaDiezMilesimas,
    required this.costePorPartidaCentimos,
    required this.cobertura,
  });
  final int horasTotalesDiezMilesimas;
  final int horasValoradasDiezMilesimas;
  final int horasSinValorarDiezMilesimas;
  final int costeRealCentimos;
  final int costeSinPartidaCentimos;
  final Map<String, int> costePorPersonaCentimos;
  final Map<String, int> horasPorPersonaDiezMilesimas;
  final Map<String, int> costePorPartidaCentimos;
  final CoberturaManoObra cobertura;
}

class PartidaManoObra {
  const PartidaManoObra({
    required this.planId,
    required this.id,
    required this.descripcion,
  });
  final String planId;
  final String id;
  final String descripcion;
}

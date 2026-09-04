import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../database/app_database.dart' hide TimelineEvent;
import '../../timeline/data/timeline_repository.dart';
import '../../timeline/domain/timeline_event.dart';
import '../domain/mano_obra.dart';

class ManoObraRepository {
  ManoObraRepository(this.database)
    : _timeline = TimelineRepository(database.timelineEventsDao);

  final AppDatabase database;
  final TimelineRepository _timeline;
  static const _uuid = Uuid();
  static const categoriaCodigo = 'mano_obra';

  Stream<List<PersonaLaboral>> observarPersonas() => database.manoObraDao
      .observarPersonas()
      .map((rows) => rows.map(_persona).toList(growable: false));

  Future<String> guardarPersona({
    String? id,
    required String nombre,
    required TipoPersonaLaboral tipo,
    bool activa = true,
    String? observaciones,
  }) async {
    if (nombre.trim().isEmpty) throw ArgumentError.value(nombre, 'nombre');
    final ahora = DateTime.now().toUtc();
    final personaId = id ?? _uuid.v4();
    final existente = id == null
        ? null
        : await database.manoObraDao.obtenerPersona(id);
    if (id != null && existente == null) {
      throw StateError('La persona no está disponible en el tenant activo.');
    }
    final value = PersonasLaboralesCompanion.insert(
      tenantId: database.activeTenantId,
      id: personaId,
      nombre: nombre.trim(),
      tipo: tipo.name,
      activa: Value(activa),
      observaciones: Value(_nullable(observaciones)),
      fechaCreacion: existente?.fechaCreacion ?? ahora,
      fechaModificacion: ahora,
    );
    if (existente == null) {
      await database.manoObraDao.insertarPersona(value);
    } else if (await database.manoObraDao.actualizarPersona(personaId, value) !=
        1) {
      throw StateError('No se pudo actualizar la persona.');
    }
    return personaId;
  }

  Future<List<TarifaPersona>> obtenerTarifas(String personaId) async =>
      (await database.manoObraDao.obtenerTarifas(
        personaId,
      )).map(_tarifa).toList(growable: false);

  Future<List<PartidaManoObra>> obtenerPartidasObra(String expedienteId) async {
    final plan = await database.economiaPrevistaDao.obtenerPlanPorExpediente(
      expedienteId,
    );
    if (plan == null) return const [];
    return (await database.economiaPrevistaDao.obtenerPartidasPlan(plan.id))
        .map(
          (p) => PartidaManoObra(
            planId: plan.id,
            id: p.id,
            descripcion: p.descripcion,
          ),
        )
        .toList(growable: false);
  }

  Future<TarifaPersona?> obtenerTarifaAplicable(
    String personaId,
    DateTime fecha,
  ) async {
    final row = await database.manoObraDao.obtenerTarifaAplicable(
      personaId,
      fecha,
    );
    return row == null ? null : _tarifa(row);
  }

  Future<String> agregarTarifa({
    required String personaId,
    required int importeHoraCentimos,
    required DateTime vigenteDesde,
    DateTime? vigenteHasta,
    String? nota,
  }) => database.transaction(() async {
    if (importeHoraCentimos < 0) throw ArgumentError.value(importeHoraCentimos);
    if (vigenteHasta != null && vigenteHasta.isBefore(vigenteDesde)) {
      throw ArgumentError('La vigencia final precede a la inicial.');
    }
    if (await database.manoObraDao.obtenerPersona(personaId) == null) {
      throw StateError('La persona no está disponible en el tenant activo.');
    }
    final existentes = await database.manoObraDao.obtenerTarifas(personaId);
    final abiertasAnteriores = existentes
        .where(
          (tarifa) =>
              tarifa.vigenteHasta == null &&
              tarifa.vigenteDesde.isBefore(vigenteDesde),
        )
        .toList(growable: false);
    if (abiertasAnteriores.length > 1) {
      throw StateError('Existen varias tarifas abiertas ambiguas.');
    }
    final anteriorACerrar = abiertasAnteriores.firstOrNull;
    for (final tarifa in existentes) {
      if (tarifa.id == anteriorACerrar?.id) continue;
      if (_solapan(
        vigenteDesde,
        vigenteHasta,
        tarifa.vigenteDesde,
        tarifa.vigenteHasta,
      )) {
        throw StateError('La vigencia se solapa con otra tarifa.');
      }
    }
    if (anteriorACerrar != null) {
      final finAnterior = vigenteDesde.subtract(
        const Duration(microseconds: 1),
      );
      if (await database.manoObraDao.cerrarTarifa(
            anteriorACerrar.id,
            finAnterior,
          ) !=
          1) {
        throw StateError('No se pudo cerrar la tarifa anterior.');
      }
    }
    final id = _uuid.v4();
    await database.manoObraDao.insertarTarifa(
      TarifasPersonaCompanion.insert(
        tenantId: database.activeTenantId,
        id: id,
        personaId: personaId,
        importeHoraCentimos: importeHoraCentimos,
        vigenteDesde: vigenteDesde,
        vigenteHasta: Value(vigenteHasta),
        nota: Value(_nullable(nota)),
        fechaCreacion: DateTime.now().toUtc(),
      ),
    );
    return id;
  });

  Future<String> registrarParte({
    required String expedienteId,
    required String personaId,
    required DateTime fechaTrabajo,
    required int horasDiezMilesimas,
    required String descripcionTrabajo,
    String? planEconomicoId,
    String? planEconomicoPartidaId,
  }) => database.transaction(() async {
    if (horasDiezMilesimas <= 0) {
      throw ArgumentError.value(horasDiezMilesimas);
    }
    if (descripcionTrabajo.trim().isEmpty) {
      throw ArgumentError.value(descripcionTrabajo);
    }
    if (await database.manoObraDao.obtenerPersona(personaId) == null) {
      throw StateError('La persona no está disponible.');
    }
    final categoria = await database.economiaPrevistaDao
        .obtenerCategoriaPorCodigo(categoriaCodigo);
    if (categoria == null) {
      throw StateError('No existe la categoría económica de mano de obra.');
    }
    final id = _uuid.v4();
    final tarifa = await database.manoObraDao.obtenerTarifaAplicable(
      personaId,
      fechaTrabajo,
    );
    final ahora = DateTime.now().toUtc();
    if (tarifa == null) {
      await database.manoObraDao.insertarParte(
        PartesTrabajoCompanion.insert(
          tenantId: database.activeTenantId,
          id: id,
          expedienteId: expedienteId,
          personaId: personaId,
          fechaTrabajo: fechaTrabajo,
          horasDiezMilesimas: horasDiezMilesimas,
          descripcionTrabajo: descripcionTrabajo.trim(),
          categoriaEconomicaId: categoria.id,
          planEconomicoId: Value(planEconomicoId),
          planEconomicoPartidaId: Value(planEconomicoPartidaId),
          estado: EstadoParteTrabajo.pendienteValoracion.name,
          fechaCreacion: ahora,
          fechaModificacion: ahora,
        ),
      );
      await _evento(
        expedienteId,
        ahora,
        TimelineEventType.horasTrabajoRegistradas,
        'Horas registradas pendientes de valorar',
        descripcionTrabajo.trim(),
        id,
      );
      return id;
    }
    await _insertarParteValorado(
      id: id,
      expedienteId: expedienteId,
      personaId: personaId,
      fechaTrabajo: fechaTrabajo,
      horas: horasDiezMilesimas,
      descripcion: descripcionTrabajo.trim(),
      categoriaId: categoria.id,
      planId: planEconomicoId,
      partidaId: planEconomicoPartidaId,
      tarifa: tarifa,
      ahora: ahora,
    );
    return id;
  });

  Future<void> completarValoracion(String parteId) =>
      database.transaction(() async {
        final parte = await database.manoObraDao.obtenerParte(parteId);
        if (parte == null) {
          throw StateError('El parte no está disponible.');
        }
        if (parte.estado != EstadoParteTrabajo.pendienteValoracion.name) {
          throw StateError('El parte ya fue valorado.');
        }
        final tarifa = await database.manoObraDao.obtenerTarifaAplicable(
          parte.personaId,
          parte.fechaTrabajo,
        );
        if (tarifa == null) {
          throw StateError('Sigue sin existir una tarifa aplicable.');
        }
        final hechoId = _uuid.v4();
        final coste = calcularCosteCentimos(
          parte.horasDiezMilesimas,
          tarifa.importeHoraCentimos,
        );
        final ahora = DateTime.now().toUtc();
        await _insertarHecho(
          hechoId,
          parte.id,
          parte.expedienteId,
          parte.categoriaEconomicaId,
          parte.planEconomicoId,
          parte.planEconomicoPartidaId,
          parte.fechaTrabajo,
          coste,
          parte.descripcionTrabajo,
          ahora,
        );
        if (await database.manoObraDao.actualizarParte(
              parte.id,
              PartesTrabajoCompanion(
                tarifaOrigenId: Value(tarifa.id),
                tarifaHoraSnapshotCentimos: Value(tarifa.importeHoraCentimos),
                costeSnapshotCentimos: Value(coste),
                estado: Value(EstadoParteTrabajo.valorado.name),
                hechoCosteId: Value(hechoId),
                fechaModificacion: Value(ahora),
              ),
            ) !=
            1) {
          throw StateError('No se pudo valorar el parte.');
        }
        await _evento(
          parte.expedienteId,
          ahora,
          TimelineEventType.costeLaboralConfirmado,
          'Coste laboral confirmado',
          parte.descripcionTrabajo,
          hechoId,
        );
      });

  Future<void> revertirParte(String parteId, {required String motivo}) =>
      database.transaction(() async {
        final parte = await database.manoObraDao.obtenerParte(parteId);
        if (parte == null ||
            parte.estado != EstadoParteTrabajo.valorado.name ||
            parte.hechoCosteId == null) {
          throw StateError('El parte no tiene un coste vigente.');
        }
        if (motivo.trim().isEmpty) {
          throw ArgumentError.value(motivo);
        }
        final movimientos = await database.hechosCosteDao.obtenerPorOrigen(
          'parteTrabajo',
          parte.id,
        );
        if (movimientos.any((h) => h.tipoMovimiento == 'reversion')) {
          throw StateError('El parte ya está revertido.');
        }
        final originales = movimientos
            .where((h) => h.tipoMovimiento == 'alta')
            .toList();
        if (originales.length != 1) {
          throw StateError('Falta el hecho original.');
        }
        final alta = originales.single;
        final ahora = DateTime.now().toUtc();
        final reversionId = _uuid.v4();
        await database.hechosCosteDao.insertar(
          HechosCosteCompanion.insert(
            tenantId: database.activeTenantId,
            id: reversionId,
            expedienteId: alta.expedienteId,
            categoriaEconomicaId: Value(alta.categoriaEconomicaId),
            planEconomicoId: Value(alta.planEconomicoId),
            planEconomicoPartidaId: Value(alta.planEconomicoPartidaId),
            fechaDevengo: ahora,
            importeNetoCentimos: -alta.importeNetoCentimos,
            ivaNoRecuperableCentimos: -alta.ivaNoRecuperableCentimos,
            importeCosteCentimos: -alta.importeCosteCentimos,
            descripcion: motivo.trim(),
            origenTipo: 'parteTrabajo',
            origenId: parte.id,
            tipoMovimiento: 'reversion',
            hechoRevertidoId: Value(alta.id),
            claveIdempotencia: 'parteTrabajo:${parte.id}:reversion',
            fechaCreacion: ahora,
          ),
        );
        if (await database.manoObraDao.actualizarParte(
              parte.id,
              PartesTrabajoCompanion(
                estado: Value(EstadoParteTrabajo.revertido.name),
                fechaModificacion: Value(ahora),
              ),
            ) !=
            1) {
          throw StateError('No se pudo revertir el parte.');
        }
        await _evento(
          parte.expedienteId,
          ahora,
          TimelineEventType.parteTrabajoRevertido,
          'Parte de trabajo revertido',
          motivo.trim(),
          reversionId,
        );
      });

  Stream<List<ParteTrabajo>> observarPartesObra(String expedienteId) => database
      .manoObraDao
      .observarPartesObra(expedienteId)
      .map((rows) => rows.map(_parte).toList(growable: false));

  Future<ResumenManoObra> obtenerResumenObra(String expedienteId) async =>
      _resumir(await database.manoObraDao.obtenerPartesObra(expedienteId));

  Stream<ResumenManoObra> observarResumenObra(String expedienteId) =>
      database.manoObraDao.observarPartesObra(expedienteId).map(_resumir);

  Future<ResumenPersonaManoObra> obtenerResumenPersona(
    String personaId, {
    required DateTime desde,
    required DateTime hasta,
  }) async {
    final rows = await database.manoObraDao.obtenerPartesPersonaPeriodo(
      personaId,
      desde,
      hasta,
    );
    final vigentes = rows.where((p) => p.estado != 'revertido').toList();
    return ResumenPersonaManoObra(
      personaId: personaId,
      horasDiezMilesimas: vigentes.fold(0, (s, p) => s + p.horasDiezMilesimas),
      costeCentimos: vigentes.fold(
        0,
        (s, p) => s + (p.costeSnapshotCentimos ?? 0),
      ),
      expedientes: Set.unmodifiable(
        vigentes.map((p) => p.expedienteId).toSet(),
      ),
    );
  }

  static int calcularCosteCentimos(int horasDiezMilesimas, int tarifaCentimos) {
    if (horasDiezMilesimas < 0 || tarifaCentimos < 0) throw ArgumentError();
    return (horasDiezMilesimas * tarifaCentimos + 5000) ~/ 10000;
  }

  Future<void> _insertarParteValorado({
    required String id,
    required String expedienteId,
    required String personaId,
    required DateTime fechaTrabajo,
    required int horas,
    required String descripcion,
    required String categoriaId,
    required String? planId,
    required String? partidaId,
    required TarifasPersonaData tarifa,
    required DateTime ahora,
  }) async {
    final hechoId = _uuid.v4();
    final coste = calcularCosteCentimos(horas, tarifa.importeHoraCentimos);
    await _insertarHecho(
      hechoId,
      id,
      expedienteId,
      categoriaId,
      planId,
      partidaId,
      fechaTrabajo,
      coste,
      descripcion,
      ahora,
    );
    await database.manoObraDao.insertarParte(
      PartesTrabajoCompanion.insert(
        tenantId: database.activeTenantId,
        id: id,
        expedienteId: expedienteId,
        personaId: personaId,
        fechaTrabajo: fechaTrabajo,
        horasDiezMilesimas: horas,
        descripcionTrabajo: descripcion,
        categoriaEconomicaId: categoriaId,
        planEconomicoId: Value(planId),
        planEconomicoPartidaId: Value(partidaId),
        tarifaOrigenId: Value(tarifa.id),
        tarifaHoraSnapshotCentimos: Value(tarifa.importeHoraCentimos),
        costeSnapshotCentimos: Value(coste),
        estado: EstadoParteTrabajo.valorado.name,
        hechoCosteId: Value(hechoId),
        fechaCreacion: ahora,
        fechaModificacion: ahora,
      ),
    );
    await _evento(
      expedienteId,
      ahora,
      TimelineEventType.costeLaboralConfirmado,
      'Horas y coste laboral registrados',
      descripcion,
      hechoId,
    );
  }

  Future<void> _insertarHecho(
    String hechoId,
    String parteId,
    String expedienteId,
    String categoriaId,
    String? planId,
    String? partidaId,
    DateTime fecha,
    int coste,
    String descripcion,
    DateTime ahora,
  ) => database.hechosCosteDao.insertar(
    HechosCosteCompanion.insert(
      tenantId: database.activeTenantId,
      id: hechoId,
      expedienteId: expedienteId,
      categoriaEconomicaId: Value(categoriaId),
      planEconomicoId: Value(planId),
      planEconomicoPartidaId: Value(partidaId),
      fechaDevengo: fecha,
      importeNetoCentimos: coste,
      ivaNoRecuperableCentimos: 0,
      importeCosteCentimos: coste,
      descripcion: descripcion,
      origenTipo: 'parteTrabajo',
      origenId: parteId,
      tipoMovimiento: 'alta',
      claveIdempotencia: 'parteTrabajo:$parteId:alta',
      fechaCreacion: ahora,
    ),
  );

  Future<void> _evento(
    String expedienteId,
    DateTime fecha,
    TimelineEventType tipo,
    String titulo,
    String descripcion,
    String referenciaId,
  ) => _timeline.registrarEvento(
    TimelineEvent(
      id: _uuid.v4(),
      expedienteId: expedienteId,
      fecha: fecha,
      tipo: tipo,
      titulo: titulo,
      descripcion: descripcion,
      referenciaId: referenciaId,
    ),
  );

  ResumenManoObra _resumir(List<PartesTrabajoData> rows) {
    final vigentes = rows.where((p) => p.estado != 'revertido');
    var horas = 0, valoradas = 0, coste = 0, sinPartida = 0;
    final costePersona = <String, int>{},
        horasPersona = <String, int>{},
        costePartida = <String, int>{};
    for (final parte in vigentes) {
      horas += parte.horasDiezMilesimas;
      horasPersona[parte.personaId] =
          (horasPersona[parte.personaId] ?? 0) + parte.horasDiezMilesimas;
      final importe = parte.costeSnapshotCentimos;
      if (importe == null) continue;
      valoradas += parte.horasDiezMilesimas;
      coste += importe;
      costePersona[parte.personaId] =
          (costePersona[parte.personaId] ?? 0) + importe;
      if (parte.planEconomicoPartidaId == null) {
        sinPartida += importe;
      } else {
        costePartida[parte.planEconomicoPartidaId!] =
            (costePartida[parte.planEconomicoPartidaId!] ?? 0) + importe;
      }
    }
    final pendientes = horas - valoradas;
    final cobertura = horas == 0
        ? CoberturaManoObra.sinHoras
        : valoradas == 0
        ? CoberturaManoObra.sinValorar
        : pendientes == 0
        ? CoberturaManoObra.completa
        : CoberturaManoObra.parcial;
    return ResumenManoObra(
      horasTotalesDiezMilesimas: horas,
      horasValoradasDiezMilesimas: valoradas,
      horasSinValorarDiezMilesimas: pendientes,
      costeRealCentimos: coste,
      costeSinPartidaCentimos: sinPartida,
      costePorPersonaCentimos: Map.unmodifiable(costePersona),
      horasPorPersonaDiezMilesimas: Map.unmodifiable(horasPersona),
      costePorPartidaCentimos: Map.unmodifiable(costePartida),
      cobertura: cobertura,
    );
  }

  static PersonaLaboral _persona(PersonasLaborale r) => PersonaLaboral(
    id: r.id,
    nombre: r.nombre,
    tipo: TipoPersonaLaboral.values.byName(r.tipo),
    activa: r.activa,
    observaciones: r.observaciones,
  );
  static TarifaPersona _tarifa(TarifasPersonaData r) => TarifaPersona(
    id: r.id,
    personaId: r.personaId,
    importeHoraCentimos: r.importeHoraCentimos,
    vigenteDesde: r.vigenteDesde,
    vigenteHasta: r.vigenteHasta,
    nota: r.nota,
  );
  static ParteTrabajo _parte(PartesTrabajoData r) => ParteTrabajo(
    id: r.id,
    expedienteId: r.expedienteId,
    personaId: r.personaId,
    fechaTrabajo: r.fechaTrabajo,
    horasDiezMilesimas: r.horasDiezMilesimas,
    descripcionTrabajo: r.descripcionTrabajo,
    categoriaEconomicaId: r.categoriaEconomicaId,
    planEconomicoId: r.planEconomicoId,
    planEconomicoPartidaId: r.planEconomicoPartidaId,
    tarifaOrigenId: r.tarifaOrigenId,
    tarifaHoraSnapshotCentimos: r.tarifaHoraSnapshotCentimos,
    costeSnapshotCentimos: r.costeSnapshotCentimos,
    estado: EstadoParteTrabajo.values.byName(r.estado),
    hechoCosteId: r.hechoCosteId,
  );
  static String? _nullable(String? value) =>
      value == null || value.trim().isEmpty ? null : value.trim();
  static bool _solapan(DateTime a, DateTime? af, DateTime b, DateTime? bf) =>
      (bf == null || !a.isAfter(bf)) && (af == null || !b.isAfter(af));
}

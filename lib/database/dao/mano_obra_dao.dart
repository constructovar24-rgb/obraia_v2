import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/partes_trabajo.dart';
import '../tables/personas_laborales.dart';
import '../tables/tarifas_persona.dart';

part 'mano_obra_dao.g.dart';

@DriftAccessor(tables: [PersonasLaborales, TarifasPersona, PartesTrabajo])
class ManoObraDao extends DatabaseAccessor<AppDatabase>
    with _$ManoObraDaoMixin {
  ManoObraDao(super.db);
  String get _tenantId => attachedDatabase.activeTenantId;

  Stream<List<PersonasLaborale>> observarPersonas() =>
      (select(personasLaborales)
            ..where((t) => t.tenantId.equals(_tenantId))
            ..orderBy([(t) => OrderingTerm.asc(t.nombre)]))
          .watch();
  Future<PersonasLaborale?> obtenerPersona(String id) =>
      (select(personasLaborales)
            ..where((t) => t.tenantId.equals(_tenantId) & t.id.equals(id)))
          .getSingleOrNull();
  Future<void> insertarPersona(PersonasLaboralesCompanion value) => into(
    personasLaborales,
  ).insert(value.copyWith(tenantId: Value(_tenantId)));
  Future<int> actualizarPersona(String id, PersonasLaboralesCompanion value) =>
      (update(personasLaborales)
            ..where((t) => t.tenantId.equals(_tenantId) & t.id.equals(id)))
          .write(value.copyWith(tenantId: Value(_tenantId)));

  Future<List<TarifasPersonaData>> obtenerTarifas(String personaId) =>
      (select(tarifasPersona)
            ..where(
              (t) =>
                  t.tenantId.equals(_tenantId) & t.personaId.equals(personaId),
            )
            ..orderBy([(t) => OrderingTerm.desc(t.vigenteDesde)]))
          .get();
  Future<TarifasPersonaData?> obtenerTarifaAplicable(
    String personaId,
    DateTime fecha,
  ) =>
      (select(tarifasPersona)
            ..where(
              (t) =>
                  t.tenantId.equals(_tenantId) &
                  t.personaId.equals(personaId) &
                  t.vigenteDesde.isSmallerOrEqualValue(fecha) &
                  (t.vigenteHasta.isNull() |
                      t.vigenteHasta.isBiggerOrEqualValue(fecha)),
            )
            ..orderBy([(t) => OrderingTerm.desc(t.vigenteDesde)])
            ..limit(1))
          .getSingleOrNull();
  Future<void> insertarTarifa(TarifasPersonaCompanion value) =>
      into(tarifasPersona).insert(value.copyWith(tenantId: Value(_tenantId)));
  Future<int> cerrarTarifa(String id, DateTime vigenteHasta) =>
      (update(tarifasPersona)
            ..where((t) => t.tenantId.equals(_tenantId) & t.id.equals(id)))
          .write(TarifasPersonaCompanion(vigenteHasta: Value(vigenteHasta)));

  Stream<List<PartesTrabajoData>> observarPartesObra(String expedienteId) =>
      (select(partesTrabajo)
            ..where(
              (t) =>
                  t.tenantId.equals(_tenantId) &
                  t.expedienteId.equals(expedienteId),
            )
            ..orderBy([(t) => OrderingTerm.desc(t.fechaTrabajo)]))
          .watch();
  Future<List<PartesTrabajoData>> obtenerPartesObra(String expedienteId) =>
      (select(partesTrabajo)..where(
            (t) =>
                t.tenantId.equals(_tenantId) &
                t.expedienteId.equals(expedienteId),
          ))
          .get();
  Future<List<PartesTrabajoData>> obtenerPartesPersonaPeriodo(
    String personaId,
    DateTime desde,
    DateTime hasta,
  ) =>
      (select(partesTrabajo)..where(
            (t) =>
                t.tenantId.equals(_tenantId) &
                t.personaId.equals(personaId) &
                t.fechaTrabajo.isBiggerOrEqualValue(desde) &
                t.fechaTrabajo.isSmallerOrEqualValue(hasta),
          ))
          .get();
  Future<PartesTrabajoData?> obtenerParte(String id) =>
      (select(partesTrabajo)
            ..where((t) => t.tenantId.equals(_tenantId) & t.id.equals(id)))
          .getSingleOrNull();
  Future<void> insertarParte(PartesTrabajoCompanion value) =>
      into(partesTrabajo).insert(value.copyWith(tenantId: Value(_tenantId)));
  Future<int> actualizarParte(String id, PartesTrabajoCompanion value) =>
      (update(partesTrabajo)
            ..where((t) => t.tenantId.equals(_tenantId) & t.id.equals(id)))
          .write(value);
}

import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/series_fiscales.dart';
part 'series_fiscales_dao.g.dart';

@DriftAccessor(tables: [SeriesFiscales, EventosSerieFiscal])
class SeriesFiscalesDao extends DatabaseAccessor<AppDatabase>
    with _$SeriesFiscalesDaoMixin {
  SeriesFiscalesDao(super.db);
  String get _tenant => attachedDatabase.activeTenantId;
  Future<SerieFiscalRow?> obtener(int ejercicio, String tipo) =>
      (select(seriesFiscales)..where(
            (t) =>
                t.tenantId.equals(_tenant) &
                t.ejercicio.equals(ejercicio) &
                t.tipo.equals(tipo),
          ))
          .getSingleOrNull();
  Future<List<SerieFiscalRow>> listar(int ejercicio) =>
      (select(seriesFiscales)..where(
            (t) => t.tenantId.equals(_tenant) & t.ejercicio.equals(ejercicio),
          ))
          .get();
  Future<void> guardar(SeriesFiscalesCompanion value) => into(
    seriesFiscales,
  ).insertOnConflictUpdate(value.copyWith(tenantId: Value(_tenant)));
  Future<int> avanzar(SerieFiscalRow actual) =>
      (update(seriesFiscales)..where(
            (t) =>
                t.tenantId.equals(_tenant) &
                t.ejercicio.equals(actual.ejercicio) &
                t.tipo.equals(actual.tipo) &
                t.siguienteNumero.equals(actual.siguienteNumero) &
                t.preparada.equals(true),
          ))
          .write(
            SeriesFiscalesCompanion(
              siguienteNumero: Value(actual.siguienteNumero + 1),
              emisiones: Value(actual.emisiones + 1),
              primerUso: Value(actual.primerUso ?? DateTime.now().toUtc()),
            ),
          );
  Future<void> registrar(EventosSerieFiscalCompanion value) =>
      into(eventosSerieFiscal).insert(value.copyWith(tenantId: Value(_tenant)));
  Future<List<EventoSerieFiscalRow>> historial(int ejercicio) =>
      (select(eventosSerieFiscal)
            ..where(
              (t) => t.tenantId.equals(_tenant) & t.ejercicio.equals(ejercicio),
            )
            ..orderBy([(t) => OrderingTerm.asc(t.fecha)]))
          .get();
  Future<List<Factura>> documentosSerie(int ejercicio, String serie) =>
      (select(attachedDatabase.facturas)..where(
            (t) =>
                t.tenantId.equals(_tenant) &
                t.anioNumeracion.equals(ejercicio) &
                t.serie.equals(serie),
          ))
          .get();
  Future<bool> numeroOcupado(int ejercicio, String serie, int numero) async =>
      (await (select(attachedDatabase.facturas)
                ..where(
                  (t) =>
                      t.tenantId.equals(_tenant) &
                      t.anioNumeracion.equals(ejercicio) &
                      t.serie.equals(serie) &
                      t.numeroLegal.equals(numero),
                )
                ..limit(1))
              .get())
          .isNotEmpty;
  Future<bool> codigoOcupado(String codigo) async =>
      (await (select(attachedDatabase.facturas)
                ..where(
                  (t) => t.tenantId.equals(_tenant) & t.codigo.equals(codigo),
                )
                ..limit(1))
              .get())
          .isNotEmpty;
}

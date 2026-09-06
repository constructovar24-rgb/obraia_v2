import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../database/app_database.dart';
import '../../facturas/domain/estado_factura.dart';
import '../domain/configuracion_fiscal.dart';

class ConfiguracionFiscalRepository {
  ConfiguracionFiscalRepository(this.database);
  final AppDatabase database;

  Future<List<ConfiguracionSerieFiscal>> obtener(int ejercicio) async =>
      (await database.seriesFiscalesDao.listar(ejercicio))
          .map(
            (r) => ConfiguracionSerieFiscal(
              ejercicio: r.ejercicio,
              tipo: r.tipo,
              serie: r.serie,
              numeroInicial: r.numeroInicial,
              siguienteNumero: r.siguienteNumero,
              documentosPrevios: r.documentosPrevios,
              preparada: r.preparada,
              emisiones: r.emisiones,
              primerUso: r.primerUso,
            ),
          )
          .toList();

  Future<void> configurar({
    required int ejercicio,
    required String tipo,
    required String serie,
    required int numeroInicial,
    required bool preparada,
  }) => database.transaction(() async {
    final normalizada = serie.trim().toUpperCase();
    if (ejercicio < 1900 ||
        ejercicio > 9999 ||
        !['ordinaria', 'rectificativa'].contains(tipo) ||
        !RegExp(r'^[A-Z0-9_-]{1,20}$').hasMatch(normalizada) ||
        numeroInicial < 1 ||
        numeroInicial >= 2147483647) {
      throw const ConfiguracionFiscalException(
        'Revisa ejercicio, serie (letras, números, guion o guion bajo; máximo 20) y número inicial positivo.',
      );
    }
    final actual = await database.seriesFiscalesDao.obtener(ejercicio, tipo);
    if (actual != null &&
        (actual.emisiones > 0 ||
            (actual.preparada && actual.documentosPrevios > 0))) {
      if (actual.serie == normalizada &&
          actual.numeroInicial == numeroInicial &&
          actual.preparada == preparada) {
        return;
      }
      throw const ConfiguracionFiscalException(
        'Esta serie ya se ha utilizado. Su configuración no puede cambiarse.',
      );
    }
    final otras = await database.seriesFiscalesDao.listar(ejercicio);
    if (otras.any((r) => r.tipo != tipo && r.serie == normalizada)) {
      throw const ConfiguracionFiscalException(
        'Ordinarias y rectificativas necesitan series distintas dentro del ejercicio.',
      );
    }
    final historicas = await database.seriesFiscalesDao.documentosSerie(
      ejercicio,
      normalizada,
    );
    if (historicas.any(
      (f) =>
          f.tipoDocumento != tipo ||
          f.numeroLegal == null ||
          f.numeroLegal! >= numeroInicial,
    )) {
      throw const ConfiguracionFiscalException(
        'La serie tiene documentos históricos incompatibles o números ya utilizados. Revisa la continuidad antes de prepararla.',
      );
    }
    final referencia = NumeroFiscal(ejercicio, normalizada, numeroInicial);
    if (await database.seriesFiscalesDao.codigoOcupado(referencia.codigo)) {
      throw const ConfiguracionFiscalException(
        'La referencia inicial ya existe. No se renumerará el histórico.',
      );
    }
    await database.seriesFiscalesDao.guardar(
      SeriesFiscalesCompanion.insert(
        tenantId: database.activeTenantId,
        ejercicio: ejercicio,
        tipo: tipo,
        serie: normalizada,
        numeroInicial: numeroInicial,
        siguienteNumero: numeroInicial,
        documentosPrevios: Value(historicas.length),
        preparada: Value(preparada),
        fechaConfiguracion: DateTime.now().toUtc(),
      ),
    );
    await _evento(ejercicio, tipo, 'configuracion', {
      'anterior': actual?.toJson(),
      'serie': normalizada,
      'numeroInicial': numeroInicial,
      'preparada': preparada,
    });
  });

  /// Both circuits are prepared atomically; used by the settings screen.
  Future<void> configurarEjercicio({
    required int ejercicio,
    required String serieOrdinaria,
    required int inicialOrdinaria,
    required String serieRectificativa,
    required int inicialRectificativa,
    required bool preparada,
  }) => database.transaction(() async {
    for (final c in [
      ('ordinaria', serieOrdinaria, inicialOrdinaria),
      ('rectificativa', serieRectificativa, inicialRectificativa),
    ]) {
      final actual = await database.seriesFiscalesDao.obtener(ejercicio, c.$1);
      await configurar(
        ejercicio: ejercicio,
        tipo: c.$1,
        serie: c.$2,
        numeroInicial: c.$3,
        preparada:
            actual != null &&
                (actual.emisiones > 0 ||
                    (actual.preparada && actual.documentosPrevios > 0))
            ? actual.preparada
            : preparada,
      );
    }
  });

  /// No standalone reservation: consumption requires a completed invoice and PDF.
  Future<void> ejecutarEmision(
    String facturaId,
    String tipo,
    Future<void> Function(NumeroFiscal numero) emitir,
  ) => database.transaction(() async {
    final factura = await database.facturasDao.obtenerPorId(facturaId);
    if (factura == null ||
        factura.estado != EstadoFactura.borrador ||
        (factura.esRectificativa ? 'rectificativa' : 'ordinaria') != tipo) {
      throw const ConfiguracionFiscalException(
        'Solo se numera una factura en borrador del circuito correspondiente.',
      );
    }
    final config = await database.seriesFiscalesDao.obtener(
      factura.fecha.year,
      tipo,
    );
    if (config == null || !config.preparada) {
      throw ConfiguracionFiscalException(
        'Prepara la numeración $tipo del ejercicio ${factura.fecha.year} en Configuración → Numeración fiscal antes de emitir.',
      );
    }
    if (config.siguienteNumero >= 2147483647) {
      throw const ConfiguracionFiscalException(
        'La secuencia está agotada. Requiere revisión antes de emitir.',
      );
    }
    final numero = NumeroFiscal(
      config.ejercicio,
      config.serie,
      config.siguienteNumero,
    );
    if (await database.seriesFiscalesDao.codigoOcupado(numero.codigo) ||
        await database.seriesFiscalesDao.numeroOcupado(
          numero.ejercicio,
          numero.serie,
          numero.numero,
        )) {
      throw const ConfiguracionFiscalException(
        'La próxima referencia fiscal ya existe. Emisión bloqueada sin consumir número.',
      );
    }
    if (await database.seriesFiscalesDao.avanzar(config) != 1) {
      throw const ConfiguracionFiscalException(
        'La secuencia ha cambiado. Vuelve a comprobar la emisión.',
      );
    }
    await emitir(numero);
    final emitida = await database.facturasDao.obtenerPorId(facturaId);
    if (emitida == null ||
        emitida.estado == EstadoFactura.borrador ||
        emitida.numeroLegal != numero.numero ||
        emitida.anioNumeracion != numero.ejercicio ||
        emitida.serie != numero.serie ||
        emitida.codigo != numero.codigo ||
        await database.facturaDocumentosEmitidosDao.obtener(facturaId) ==
            null) {
      throw const ConfiguracionFiscalException(
        'No se completó el documento fiscal. No se ha consumido número.',
      );
    }
    await _evento(config.ejercicio, tipo, 'emision', {
      'facturaId': facturaId,
      'serie': numero.serie,
      'numero': numero.numero,
      'codigo': numero.codigo,
    });
  });

  Future<void> _evento(
    int ejercicio,
    String tipo,
    String accion,
    Map<String, Object?> detalle,
  ) => database.seriesFiscalesDao.registrar(
    EventosSerieFiscalCompanion.insert(
      tenantId: database.activeTenantId,
      id: const Uuid().v4(),
      ejercicio: ejercicio,
      tipo: tipo,
      accion: accion,
      detalleJson: jsonEncode(detalle),
      fecha: DateTime.now().toUtc(),
    ),
  );
}

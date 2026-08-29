import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/database/database_provider.dart';
import 'package:obraia_v2/features/clientes/domain/cliente.dart'
    as cliente_domain;
import 'package:obraia_v2/features/cobros/domain/cobro.dart' as cobro_domain;
import 'package:obraia_v2/features/cobros/domain/factura_estado_economico.dart';
import 'package:obraia_v2/features/facturas/domain/estado_factura.dart';
import 'package:obraia_v2/features/facturas/domain/factura_presupuesto_policy.dart';
import 'package:obraia_v2/features/facturas/domain/factura_totales.dart';
import 'package:obraia_v2/features/facturas/domain/redondeo_monetario.dart';
import 'package:obraia_v2/features/facturas/domain/factura.dart'
    as factura_domain;
import 'package:obraia_v2/features/presupuestos/domain/presupuesto.dart'
    as presupuesto_domain;
import 'package:obraia_v2/features/timeline/data/timeline_repository.dart';
import 'package:uuid/uuid.dart';

final facturaRepositoryProvider = Provider<FacturaRepository>((ref) {
  final database = ref.read(databaseProvider);
  return FacturaRepository(database);
});

class PresupuestoYaConvertidoException implements Exception {
  const PresupuestoYaConvertidoException({
    required this.presupuestoId,
    required this.facturaId,
  });

  final String presupuestoId;
  final String facturaId;
}

class PresupuestoNoAceptadoException implements Exception {
  const PresupuestoNoAceptadoException();
}

class FacturaAnuladaConCobrosLegacyException implements Exception {
  const FacturaAnuladaConCobrosLegacyException();
}

class CreacionManualConPresupuestoOrigenException implements Exception {
  const CreacionManualConPresupuestoOrigenException();
}

class FacturaEmisionException implements Exception {
  const FacturaEmisionException(this.mensaje);
  final String mensaje;
}

class FacturaAnulacionConCobrosException implements Exception {
  const FacturaAnulacionConCobrosException();
}

class ActualizacionTotalesIncompatibleConCobrosException implements Exception {
  const ActualizacionTotalesIncompatibleConCobrosException({
    required this.facturaId,
    required this.nuevoTotalFactura,
    required this.totalCobrado,
  });

  final String facturaId;
  final double nuevoTotalFactura;
  final double totalCobrado;
}

class FacturaNoEncontradaAlActualizarTotalesException implements Exception {
  const FacturaNoEncontradaAlActualizarTotalesException({
    required this.facturaId,
  });

  final String facturaId;
}

class FacturaDocumentoCongeladoException implements Exception {
  const FacturaDocumentoCongeladoException({
    required this.facturaId,
    required this.estado,
  });

  final String facturaId;
  final EstadoFactura estado;
}

class FechaVencimientoFacturaNoValidaException implements Exception {
  const FechaVencimientoFacturaNoValidaException({required this.facturaId});

  final String facturaId;
}

class FacturaNoEncontradaAlEliminarException implements Exception {
  const FacturaNoEncontradaAlEliminarException({required this.facturaId});

  final String facturaId;
}

class FacturaNoEliminablePorEstadoException implements Exception {
  const FacturaNoEliminablePorEstadoException({
    required this.facturaId,
    required this.estado,
  });

  final String facturaId;
  final EstadoFactura estado;
}

class FacturaNoEliminableConCobrosException implements Exception {
  const FacturaNoEliminableConCobrosException({required this.facturaId});

  final String facturaId;
}

bool facturaPuedeEliminarse({
  required EstadoFactura estado,
  required bool tieneCobros,
}) {
  return estado == EstadoFactura.borrador && !tieneCobros;
}

class FacturaRepository {
  final AppDatabase database;
  final TimelineRepository _timelineRepository;

  FacturaRepository(this.database)
    : _timelineRepository = TimelineRepository(database.timelineEventsDao);

  Stream<List<factura_domain.Factura>> observarFacturas() {
    return database.facturasDao.observarFacturas().asyncMap((facturas) async {
      final cambio = await _reconciliarFacturas(facturas);
      return cambio ? database.facturasDao.observarFacturas().first : facturas;
    });
  }

  Stream<List<factura_domain.Factura>> observarFacturadoEnMes(DateTime mes) {
    return observarFacturas().map(
      (facturas) => facturas.where((factura) {
        return estadoFacturaEsEfectiva(factura.estado) &&
            factura.fecha.year == mes.year &&
            factura.fecha.month == mes.month;
      }).toList(),
    );
  }

  Stream<List<FacturaConEstadoEconomico>>
  observarFacturadoEnMesConEstadoEconomico(DateTime mes) {
    return _observarConEstadoEconomico(observarFacturadoEnMes(mes));
  }

  Stream<List<FacturaConEstadoEconomico>> observarFacturasConEstadoEconomico() {
    return _observarConEstadoEconomico(observarFacturas());
  }

  Stream<List<FacturaConEstadoEconomico>> observarPorClienteConEstadoEconomico(
    String clienteId,
  ) {
    return _observarConEstadoEconomico(observarPorCliente(clienteId));
  }

  Stream<List<FacturaConEstadoEconomico>>
  observarPorExpedienteConEstadoEconomico(String expedienteId) {
    return _observarConEstadoEconomico(observarPorExpediente(expedienteId));
  }

  Stream<List<FacturaConEstadoEconomico>> _observarConEstadoEconomico(
    Stream<List<factura_domain.Factura>> facturasStream,
  ) {
    return Stream<List<FacturaConEstadoEconomico>>.multi((controller) {
      List<factura_domain.Factura>? facturas;
      Map<String, double>? cobradoPorFactura;

      void emitirSiCompleto() {
        final facturasActuales = facturas;
        final cobrosActuales = cobradoPorFactura;
        if (facturasActuales == null || cobrosActuales == null) {
          return;
        }

        final fechaReferencia = DateTime.now();
        controller.add(
          facturasActuales.map((factura) {
            final totalCobrado = cobrosActuales[factura.id] ?? 0;
            return FacturaConEstadoEconomico(
              factura: factura,
              estadoEconomico: calcularResumenEconomicoFactura(
                totalFactura: factura.total,
                totalCobrado: totalCobrado,
                fechaVencimiento: factura.fechaVencimiento,
                estadoFactura: factura.estado,
                fechaReferencia: fechaReferencia,
              ),
            );
          }).toList(),
        );
      }

      final facturasSubscription = facturasStream.listen((data) {
        facturas = data;
        emitirSiCompleto();
      }, onError: controller.addError);
      final cobrosSubscription = database.cobrosDao.observarCobros().listen((
        cobros,
      ) {
        final agrupados = <String, double>{};
        for (final cobro in cobros) {
          agrupados.update(
            cobro.facturaId,
            (total) => total + cobro.importe,
            ifAbsent: () => cobro.importe,
          );
        }
        cobradoPorFactura = agrupados;
        emitirSiCompleto();
      }, onError: controller.addError);

      controller.onCancel = () async {
        await facturasSubscription.cancel();
        await cobrosSubscription.cancel();
      };
    });
  }

  Stream<List<factura_domain.Factura>> observarPorCliente(String clienteId) {
    return observarFacturas().map(
      (facturas) =>
          facturas.where((factura) => factura.clienteId == clienteId).toList(),
    );
  }

  Stream<List<factura_domain.Factura>> observarPorExpediente(
    String expedienteId,
  ) {
    return observarFacturas().asyncMap((facturas) async {
      final presupuestos = await database.presupuestosDao
          .observarPresupuestos()
          .first;
      final ids = presupuestos
          .where((p) => p.expedienteId == expedienteId)
          .map((p) => p.id)
          .toSet();
      return facturas
          .where(
            (f) =>
                f.presupuestoOrigenId != null &&
                ids.contains(f.presupuestoOrigenId),
          )
          .toList();
    });
  }

  Future<factura_domain.Factura?> obtenerPorId(String facturaId) async {
    final factura = await database.facturasDao.obtenerPorId(facturaId);
    if (factura == null) return null;
    await _reconciliarFactura(factura);
    return database.facturasDao.obtenerPorId(facturaId);
  }

  Future<(int, int, String)> _generarCodigoFactura(int year) async {
    final prefijo = 'FAC-$year-';
    final siguiente =
        await database.facturasDao.obtenerMayorNumeroLegal(year) + 1;
    final correlativo = siguiente.toString().padLeft(4, '0');
    return (year, siguiente, '$prefijo$correlativo');
  }

  Future<String> crearFactura({
    required String clienteId,
    required DateTime fecha,
    required DateTime fechaVencimiento,
    EstadoFactura estado = EstadoFactura.borrador,
    double subtotal = 0,
    String observaciones = '',
    String? presupuestoOrigenId,
  }) async {
    if (presupuestoOrigenId != null && presupuestoOrigenId.trim().isNotEmpty) {
      throw const CreacionManualConPresupuestoOrigenException();
    }

    return _insertarFactura(
      clienteId: clienteId,
      fecha: fecha,
      fechaVencimiento: fechaVencimiento,
      subtotal: subtotal,
      ivaPorcentaje: facturaIvaPorcentajeInicial,
      observaciones: observaciones,
    );
  }

  Future<String> _insertarFactura({
    required String clienteId,
    required DateTime fecha,
    required DateTime fechaVencimiento,
    required double subtotal,
    required double ivaPorcentaje,
    required String observaciones,
    String? presupuestoOrigenId,
  }) async {
    final facturaId = const Uuid().v4();
    final subtotalRedondeado = redondearMoneda(subtotal);
    final ivaRedondeado = redondearMoneda(
      subtotalRedondeado * ivaPorcentaje / 100,
    );
    await database.facturasDao.insertarFactura(
      FacturasCompanion.insert(
        id: facturaId,
        clienteId: clienteId,
        fecha: Value(fecha),
        fechaVencimiento: Value(fechaVencimiento),
        estado: const Value('borrador'),
        subtotal: Value(subtotalRedondeado),
        iva: Value(ivaRedondeado),
        ivaPorcentaje: Value(ivaPorcentaje),
        total: Value(redondearMoneda(subtotalRedondeado + ivaRedondeado)),
        observaciones: Value(observaciones),
        presupuestoOrigenId: presupuestoOrigenId == null
            ? const Value.absent()
            : Value(presupuestoOrigenId),
      ),
    );

    return facturaId;
  }

  Future<String> convertirDesdePresupuesto(
    presupuesto_domain.Presupuesto presupuesto,
  ) async {
    late final String facturaId;

    await database.transaction(() async {
      final presupuestos = await database.presupuestosDao
          .observarPresupuestos()
          .first;
      final presupuestoPersistido = presupuestos
          .where((actual) => actual.id == presupuesto.id)
          .firstOrNull;
      if (presupuestoPersistido == null) {
        throw Exception('El presupuesto ya no existe.');
      }

      final facturas = await database.facturasDao.observarFacturas().first;
      final cobros = await database.cobrosDao.observarCobros().first;
      final bloqueo = obtenerBloqueoConversionPresupuesto(
        estadoPresupuesto: presupuestoPersistido.estado,
        presupuestoId: presupuestoPersistido.id,
        facturas: facturas,
        cobros: cobros,
      );
      if (bloqueo == BloqueoConversionPresupuesto.presupuestoNoAceptado) {
        throw const PresupuestoNoAceptadoException();
      }
      if (bloqueo == BloqueoConversionPresupuesto.facturaAnuladaConCobros) {
        throw const FacturaAnuladaConCobrosLegacyException();
      }
      if (bloqueo == BloqueoConversionPresupuesto.facturaNoAnuladaExistente) {
        final bloqueante = facturasVinculadasAPresupuesto(
          facturas,
          presupuestoPersistido.id,
        ).firstWhere(facturaBloqueaConversion);
        throw PresupuestoYaConvertidoException(
          presupuestoId: presupuestoPersistido.id,
          facturaId: bloqueante.id,
        );
      }

      final lineas = await database.lineasPresupuestoDao.obtenerPorPresupuesto(
        presupuestoPersistido.id,
      );
      final expediente = await database.expedientesDao.obtenerExpediente(
        presupuestoPersistido.expedienteId,
      );
      final clienteId = expediente?.clienteId;
      if (clienteId == null || clienteId.trim().isEmpty) {
        throw Exception(
          'El presupuesto no tiene cliente asociado en su expediente.',
        );
      }

      final subtotal = redondearMoneda(
        lineas.fold<double>(0, (total, linea) => total + linea.importe),
      );
      final fechaFactura = DateTime.now();
      facturaId = await _insertarFactura(
        clienteId: clienteId,
        fecha: fechaFactura,
        fechaVencimiento: fechaFactura.add(const Duration(days: 30)),
        subtotal: subtotal,
        ivaPorcentaje: presupuestoPersistido.ivaPorcentaje,
        observaciones: presupuestoPersistido.descripcion,
        presupuestoOrigenId: presupuestoPersistido.id,
      );

      for (final linea in lineas) {
        await database.facturaLineasDao.insertarLinea(
          FacturaLineasCompanion.insert(
            id: const Uuid().v4(),
            facturaId: facturaId,
            descripcion: linea.concepto,
            cantidad: linea.cantidad,
            unidad: Value(linea.unidad),
            precioUnitario: linea.precioUnitario,
            descuento: const Value(0),
            importe: Value(linea.importe),
          ),
        );
      }

      await _timelineRepository.registrarFacturaCreada(
        expedienteId: presupuestoPersistido.expedienteId,
        facturaId: facturaId,
        titulo: 'Factura creada',
        descripcion:
            'Generada desde presupuesto ${presupuestoPersistido.codigo}',
      );
    });

    return facturaId;
  }

  Stream<BloqueoConversionPresupuesto?> observarBloqueoConversion(
    String presupuestoId,
  ) {
    return Stream<BloqueoConversionPresupuesto?>.multi((controller) {
      List<presupuesto_domain.Presupuesto>? presupuestos;
      List<factura_domain.Factura>? facturas;
      List<cobro_domain.Cobro>? cobros;

      void emitirSiCompleto() {
        if (presupuestos == null || facturas == null || cobros == null) return;
        final presupuesto = presupuestos!
            .where((actual) => actual.id == presupuestoId)
            .firstOrNull;
        if (presupuesto == null) {
          controller.add(BloqueoConversionPresupuesto.presupuestoNoAceptado);
          return;
        }
        controller.add(
          obtenerBloqueoConversionPresupuesto(
            estadoPresupuesto: presupuesto.estado,
            presupuestoId: presupuestoId,
            facturas: facturas!,
            cobros: cobros!,
          ),
        );
      }

      final subs = <StreamSubscription<dynamic>>[
        database.presupuestosDao.observarPresupuestos().listen((data) {
          presupuestos = data;
          emitirSiCompleto();
        }, onError: controller.addError),
        database.facturasDao.observarFacturas().listen((data) {
          facturas = data;
          emitirSiCompleto();
        }, onError: controller.addError),
        database.cobrosDao.observarCobros().listen((data) {
          cobros = data;
          emitirSiCompleto();
        }, onError: controller.addError),
      ];
      controller.onCancel = () async {
        for (final sub in subs) {
          await sub.cancel();
        }
      };
    }).distinct();
  }

  Future<void> actualizarTotales({
    required String facturaId,
    required double subtotal,
  }) async {
    await database.transaction(() async {
      final factura = await database.facturasDao.obtenerPorId(facturaId);
      if (factura == null) {
        throw FacturaNoEncontradaAlActualizarTotalesException(
          facturaId: facturaId,
        );
      }
      if (!estadoFacturaPermiteEditarDocumento(factura.estado)) {
        throw FacturaDocumentoCongeladoException(
          facturaId: facturaId,
          estado: factura.estado,
        );
      }

      final cobros = await database.cobrosDao
          .observarPorFactura(facturaId)
          .first;
      final totalCobrado = cobros.fold<double>(
        0,
        (suma, cobro) => suma + cobro.importe,
      );
      final subtotalRedondeado = redondearMoneda(subtotal);
      final iva = redondearMoneda(
        subtotalRedondeado * factura.ivaPorcentaje / 100,
      );
      final total = redondearMoneda(subtotalRedondeado + iva);
      if (!totalFacturaCubreCobros(
        totalFactura: total,
        totalCobrado: totalCobrado,
      )) {
        throw ActualizacionTotalesIncompatibleConCobrosException(
          facturaId: facturaId,
          nuevoTotalFactura: total,
          totalCobrado: totalCobrado,
        );
      }

      await database.facturasDao.actualizarTotales(
        facturaId: facturaId,
        subtotal: subtotalRedondeado,
        iva: iva,
        total: total,
      );
      final actualizada = await database.facturasDao.obtenerPorId(facturaId);
      if (actualizada != null) await _reconciliarFactura(actualizada);
    });
  }

  Future<void> actualizarEstado(String facturaId, EstadoFactura estado) async {
    if (estado == EstadoFactura.emitida) {
      await emitirFactura(facturaId);
      return;
    }
    if (estado == EstadoFactura.anulada) {
      await anularFactura(facturaId);
      return;
    }
    throw StateError(
      'El estado documental no puede seleccionarse manualmente.',
    );
  }

  Future<void> actualizarFactura({
    required String id,
    required String clienteId,
    required DateTime fecha,
    required DateTime fechaVencimiento,
    required String observaciones,
  }) async {
    await database.transaction(() async {
      final facturaActual = await database.facturasDao.obtenerPorId(id);
      if (facturaActual == null) {
        throw FacturaNoEncontradaAlActualizarTotalesException(facturaId: id);
      }
      if (!estadoFacturaPermiteEditarVencimiento(facturaActual.estado)) {
        throw FacturaDocumentoCongeladoException(
          facturaId: id,
          estado: facturaActual.estado,
        );
      }
      final fechaDocumento = DateTime(
        facturaActual.fecha.year,
        facturaActual.fecha.month,
        facturaActual.fecha.day,
      );
      final vencimiento = DateTime(
        fechaVencimiento.year,
        fechaVencimiento.month,
        fechaVencimiento.day,
      );
      if (vencimiento.isBefore(fechaDocumento)) {
        throw FechaVencimientoFacturaNoValidaException(facturaId: id);
      }
      if (!estadoFacturaPermiteEditarDocumento(facturaActual.estado) &&
          (clienteId != facturaActual.clienteId ||
              fecha != facturaActual.fecha ||
              observaciones != facturaActual.observaciones)) {
        throw FacturaDocumentoCongeladoException(
          facturaId: id,
          estado: facturaActual.estado,
        );
      }

      await database.facturasDao.actualizarFactura(
        id: id,
        clienteId: clienteId,
        fecha: fecha,
        fechaVencimiento: fechaVencimiento,
        estado: estadoFacturaToString(facturaActual.estado),
        observaciones: observaciones,
      );
      final actualizada = await database.facturasDao.obtenerPorId(id);
      if (actualizada != null) {
        await _reconciliarFactura(actualizada);
      }
    });
  }

  Future<void> emitirFactura(String facturaId) async {
    await database.transaction(() async {
      final factura = await database.facturasDao.obtenerPorId(facturaId);
      if (factura == null) {
        throw const FacturaEmisionException('La factura no existe.');
      }
      final cliente = await database.clientesDao.obtenerCliente(
        factura.clienteId,
      );
      final lineas = await database.facturaLineasDao.obtenerPorFactura(
        facturaId,
      );
      final motivo = validarEmisionFactura(
        estadoActual: factura.estado,
        clienteExiste: cliente != null && !cliente.eliminado,
        lineas: lineas.map(
          (linea) => DatosLineaEmision(
            cantidad: linea.cantidad,
            precioUnitario: linea.precioUnitario,
          ),
        ),
        total: factura.total,
        fechaFactura: factura.fecha,
        fechaVencimiento: factura.fechaVencimiento,
      );
      if (motivo != null) {
        throw FacturaEmisionException(motivo);
      }
      final cobros = await database.cobrosDao
          .observarPorFactura(facturaId)
          .first;
      final cobrado = cobros.fold<double>(
        0,
        (suma, cobro) => suma + cobro.importe,
      );
      final estado = resolverEstadoDocumentalFactura(
        estadoActual: EstadoFactura.emitida,
        totalFactura: factura.total,
        totalCobrado: cobrado,
        fechaVencimiento: factura.fechaVencimiento,
      );
      final (anio, numero, codigo) = await _generarCodigoFactura(
        factura.fecha.year,
      );
      final empresa = await database.empresaConfiguracionDao
          .obtenerConfiguracion();
      final presupuesto = factura.presupuestoOrigenId == null
          ? null
          : (await database.presupuestosDao.observarPresupuestos().first)
                .where((item) => item.id == factura.presupuestoOrigenId)
                .firstOrNull;
      final expediente = presupuesto == null
          ? null
          : await database.expedientesDao.obtenerExpediente(
              presupuesto.expedienteId,
            );

      await database.facturasDao.actualizarEmision(
        facturaId,
        FacturasCompanion(
          codigo: Value(codigo),
          anioNumeracion: Value(anio),
          numeroLegal: Value(numero),
          estado: Value(estadoFacturaToString(estado)),
          fechaEmision: Value(DateTime.now()),
          clienteNombreHistorico: Value(
            '${cliente!.nombre} ${cliente.apellidos}'.trim(),
          ),
          clienteNifHistorico: Value(cliente.nif),
          clienteDireccionHistorica: Value(_direccionCliente(cliente)),
          clienteTelefonoHistorico: Value(cliente.telefono),
          clienteEmailHistorico: Value(cliente.email),
          empresaNombreHistorico: Value(empresa?.nombreEmpresa ?? ''),
          empresaCifHistorico: Value(empresa?.cif ?? ''),
          empresaDireccionHistorica: Value(empresa?.direccion ?? ''),
          empresaCodigoPostalHistorico: Value(empresa?.codigoPostal ?? ''),
          empresaPoblacionHistorica: Value(empresa?.poblacion ?? ''),
          empresaProvinciaHistorica: Value(empresa?.provincia ?? ''),
          empresaTelefonoHistorico: Value(empresa?.telefono ?? ''),
          empresaEmailHistorico: Value(empresa?.email ?? ''),
          empresaWebHistorica: Value(empresa?.web ?? ''),
          expedienteOrigenIdHistorico: Value(expediente?.id ?? ''),
          expedienteCodigoHistorico: Value(expediente?.codigo ?? ''),
          expedienteNombreHistorico: Value(expediente?.nombre ?? ''),
          presupuestoCodigoHistorico: Value(presupuesto?.codigo ?? ''),
          fechaModificacion: Value(DateTime.now()),
        ),
      );
    });
  }

  String _direccionCliente(cliente_domain.Cliente cliente) {
    return [
      cliente.direccion.trim(),
      [
        cliente.codigoPostal.trim(),
        cliente.poblacion.trim(),
        cliente.provincia.trim(),
      ].where((part) => part.isNotEmpty).join(' '),
    ].where((part) => part.isNotEmpty).join(' · ');
  }

  Future<void> anularFactura(String facturaId) async {
    await database.transaction(() async {
      final factura = await database.facturasDao.obtenerPorId(facturaId);
      if (factura == null || factura.estado == EstadoFactura.anulada) return;
      final cobros = await database.cobrosDao
          .observarPorFactura(facturaId)
          .first;
      if (cobros.isNotEmpty) throw const FacturaAnulacionConCobrosException();
      await _actualizarEstadoConEvento(
        facturaId: facturaId,
        nuevoEstado: EstadoFactura.anulada,
      );
    });
  }

  Future<bool> _reconciliarFacturas(
    List<factura_domain.Factura> facturas,
  ) async {
    var cambio = false;
    await database.transaction(() async {
      for (final factura in facturas) {
        cambio = await _reconciliarFactura(factura) || cambio;
      }
    });
    return cambio;
  }

  Future<bool> _reconciliarFactura(factura_domain.Factura factura) async {
    final cobros = await database.cobrosDao
        .observarPorFactura(factura.id)
        .first;
    final cobrado = cobros.fold<double>(
      0,
      (suma, cobro) => suma + cobro.importe,
    );
    final estado = resolverEstadoDocumentalFactura(
      estadoActual: factura.estado,
      totalFactura: factura.total,
      totalCobrado: cobrado,
      fechaVencimiento: factura.fechaVencimiento,
    );
    if (estado == factura.estado) return false;
    await database.facturasDao.actualizarEstado(
      factura.id,
      estadoFacturaToString(estado),
    );
    return true;
  }

  Future<void> eliminarFactura(String facturaId) async {
    await database.transaction(() async {
      final factura = await database.facturasDao.obtenerPorId(facturaId);
      if (factura == null) {
        throw FacturaNoEncontradaAlEliminarException(facturaId: facturaId);
      }
      final cobros = await database.cobrosDao
          .observarPorFactura(facturaId)
          .first;
      if (factura.estado != EstadoFactura.borrador) {
        throw FacturaNoEliminablePorEstadoException(
          facturaId: facturaId,
          estado: factura.estado,
        );
      }
      if (cobros.isNotEmpty) {
        throw FacturaNoEliminableConCobrosException(facturaId: facturaId);
      }
      final expedienteId = await _obtenerExpedienteIdDesdePresupuestoOrigen(
        factura.presupuestoOrigenId,
      );
      await database.facturaLineasDao.eliminarPorFactura(facturaId);
      await database.facturasDao.eliminarFactura(facturaId);
      if (expedienteId != null && expedienteId.trim().isNotEmpty) {
        await _timelineRepository.registrarFacturaBorradorEliminada(
          expedienteId: expedienteId,
          facturaId: factura.id,
          titulo: 'Factura borrador eliminada',
          descripcion: factura.codigo,
        );
      }
    });
  }

  Future<void> _actualizarEstadoConEvento({
    required String facturaId,
    required EstadoFactura nuevoEstado,
  }) async {
    final facturaActual = await database.facturasDao.obtenerPorId(facturaId);

    await database.facturasDao.actualizarEstado(
      facturaId,
      estadoFacturaToString(nuevoEstado),
    );

    if (_esTransicionRealAAnulada(
      estadoAnterior: facturaActual?.estado,
      estadoNuevo: nuevoEstado,
    )) {
      await _registrarFacturaAnuladaSiAplica(
        facturaId: facturaId,
        facturaCodigo: facturaActual?.codigo,
        presupuestoOrigenId: facturaActual?.presupuestoOrigenId,
      );
    }
  }

  bool _esTransicionRealAAnulada({
    required EstadoFactura? estadoAnterior,
    required EstadoFactura estadoNuevo,
  }) {
    if (estadoNuevo != EstadoFactura.anulada) {
      return false;
    }

    if (estadoAnterior == null) {
      return false;
    }

    return estadoAnterior != EstadoFactura.anulada;
  }

  Future<void> _registrarFacturaAnuladaSiAplica({
    required String facturaId,
    required String? facturaCodigo,
    required String? presupuestoOrigenId,
  }) async {
    final expedienteId = await _obtenerExpedienteIdDesdePresupuestoOrigen(
      presupuestoOrigenId,
    );
    if (expedienteId == null || expedienteId.trim().isEmpty) {
      return;
    }

    await _timelineRepository.registrarFacturaAnulada(
      expedienteId: expedienteId,
      facturaId: facturaId,
      titulo: 'Factura anulada',
      descripcion: facturaCodigo,
    );
  }

  Future<String?> _obtenerExpedienteIdDesdePresupuestoOrigen(
    String? presupuestoOrigenId,
  ) async {
    if (presupuestoOrigenId == null || presupuestoOrigenId.trim().isEmpty) {
      return null;
    }

    final presupuestos = await database.presupuestosDao
        .observarPresupuestos()
        .first;

    for (final presupuesto in presupuestos) {
      if (presupuesto.id == presupuestoOrigenId) {
        return presupuesto.expedienteId;
      }
    }

    return null;
  }
}

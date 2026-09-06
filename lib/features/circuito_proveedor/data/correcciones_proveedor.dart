part of 'circuito_proveedor_repository.dart';

extension CorreccionesProveedor on CircuitoProveedorRepository {
  Future<ControlFacturasProveedorData> _control(String id) async {
    final actual = await database.circuitoProveedorDao.control(id);
    if (actual != null) return actual;
    final f = await database.circuitoProveedorDao.factura(id);
    if (f == null) throw StateError('Factura no disponible.');
    final asignaciones = await database.circuitoProveedorDao.asignaciones(id);
    await database.circuitoProveedorDao.guardarControl(
      ControlFacturasProveedorCompanion.insert(
        tenantId: database.activeTenantId,
        facturaId: id,
        estadoDocumento: Value(
          f.estado == 'cancelada' ? 'anulada' : 'registrada',
        ),
        pagoVerificado: const Value(true),
        destino: Value(
          asignaciones.any((a) => a.expedienteId != null)
              ? 'obra'
              : 'sinAsignar',
        ),
      ),
    );
    return (await database.circuitoProveedorDao.control(id))!;
  }

  Future<void> _auditar(
    String id,
    String accion,
    String motivo, {
    Map<String, Object?> detalle = const {},
  }) async {
    if (motivo.trim().isEmpty) throw ArgumentError('Indica el motivo.');
    final now = DateTime.now().toUtc();
    await database.circuitoProveedorDao.evento(
      EventosProveedorCompanion.insert(
        tenantId: database.activeTenantId,
        id: CircuitoProveedorRepository._uuid.v4(),
        facturaId: id,
        accion: accion,
        motivo: motivo.trim(),
        actor: 'operador local',
        detalleJson: jsonEncode(detalle),
        fecha: now,
      ),
    );
    final obras = (await database.circuitoProveedorDao.asignaciones(
      id,
    )).map((a) => a.expedienteId).whereType<String>().toSet();
    for (final obra in obras) {
      await TimelineRepository(database.timelineEventsDao).registrarEvento(
        TimelineEvent(
          id: CircuitoProveedorRepository._uuid.v4(),
          expedienteId: obra,
          fecha: now,
          tipo: TimelineEventType.proveedorOperacion,
          titulo: accion,
          descripcion: motivo,
          referenciaId: id,
        ),
      );
    }
  }

  Future<void> _duplicado(
    FacturaRecibidaInput input, {
    String? excluir,
    String? sustituida,
  }) async {
    final numero = CircuitoProveedorRepository._normalizar(input.numero);
    if (numero.isEmpty) {
      throw ArgumentError('Indica un número de documento válido.');
    }
    final anteriores = <String>{};
    var parent = input.tipo == 'factura'
        ? (sustituida ?? input.originalId)
        : null;
    while (parent != null && anteriores.add(parent)) {
      final c = await database.circuitoProveedorDao.control(parent);
      if (c?.estadoDocumento != 'anulada') {
        throw StateError('La factura sustituida debe estar anulada.');
      }
      parent = c?.originalId;
    }
    for (final f in await database.circuitoProveedorDao.todasFacturas()) {
      if (f.id != excluir &&
          !anteriores.contains(f.id) &&
          f.proveedorId == input.proveedorId &&
          f.fechaFactura.year == input.fecha.year &&
          CircuitoProveedorRepository._normalizar(f.numeroProveedor) ==
              numero) {
        throw StateError(
          'Ya existe este número del proveedor en ese ejercicio, incluso si está anulado.',
        );
      }
    }
  }

  Future<void> consolidarFactura(
    String id, {
    String motivo = 'Registro confirmado',
  }) => database.transaction(() async {
    final c = await _control(id);
    if (c.estadoDocumento != 'borrador') {
      throw StateError('Solo se consolida un borrador.');
    }
    final f = (await database.circuitoProveedorDao.factura(id))!;
    if (c.tipo == 'abono' && c.originalId != null) {
      final original = await database.circuitoProveedorDao.factura(
        c.originalId!,
      );
      final oc = await _control(c.originalId!);
      if (original == null ||
          original.proveedorId != f.proveedorId ||
          oc.tipo != 'factura' ||
          oc.estadoDocumento != 'registrada') {
        throw StateError(
          'El original no es una factura registrada de este proveedor.',
        );
      }
    }
    await database.circuitoProveedorDao.guardarControl(
      c.toCompanion(true).copyWith(estadoDocumento: const Value('registrada')),
    );
    for (final a in await database.circuitoProveedorDao.asignaciones(id)) {
      if (a.expedienteId != null) {
        if (c.tipo == 'abono') {
          await _movimiento(id, a, -1, 'alta', null, 'Abono recibido');
        } else {
          await reconocerAsignacion(asignacionId: a.id);
        }
      }
    }
    await _auditar(id, 'Factura consolidada', motivo);
    if (c.originalId != null) await _recalcularPago(c.originalId!);
  });
  Future<void> editarBorrador(
    String id,
    FacturaRecibidaInput input,
  ) => database.transaction(() async {
    final c = await _control(id);
    if (c.estadoDocumento != 'borrador') {
      throw StateError(
        'El documento consolidado se corrige mediante anulación o abono.',
      );
    }
    await _duplicado(
      input,
      excluir: id,
      sustituida: c.tipo == 'factura' ? c.originalId : null,
    );
    if (input.baseCentimos < 0 || input.ivaCentimos < 0) {
      throw ArgumentError(
        'Usa magnitudes positivas; el tipo abono determina el signo.',
      );
    }
    final asignaciones = await database.circuitoProveedorDao.asignaciones(id);
    if (asignaciones.length != input.asignaciones.length) {
      throw StateError(
        'Para cambiar un reparto múltiple utiliza la corrección de imputación.',
      );
    }
    if (input.asignaciones.fold<int>(0, (s, a) => s + a.importeCentimos) !=
            input.baseCentimos ||
        input.asignaciones.any(
          (a) => a.importeCentimos < 0 || a.ivaNoRecuperableCentimos < 0,
        ) ||
        input.asignaciones.fold<int>(
              0,
              (s, a) => s + a.ivaNoRecuperableCentimos,
            ) >
            input.ivaCentimos) {
      throw StateError('Revisa la base asignada.');
    }
    final old = (await database.circuitoProveedorDao.factura(id))!;
    await database.circuitoProveedorDao.editarFactura(
      id,
      FacturasRecibidasCompanion(
        proveedorId: Value(input.proveedorId),
        numeroProveedor: Value(input.numero.trim()),
        numeroNormalizado: Value(
          '${input.fecha.year}|${CircuitoProveedorRepository._normalizar(input.numero)}${c.tipo == 'factura' && c.originalId != null ? '|correccion:${c.originalId}' : ''}',
        ),
        fechaFactura: Value(input.fecha),
        fechaVencimiento: Value(input.vencimiento),
        baseCentimos: Value(input.baseCentimos),
        ivaCentimos: Value(input.ivaCentimos),
        totalCentimos: Value(input.baseCentimos + input.ivaCentimos),
        documentoId: Value(input.documentoId),
        fechaModificacion: Value(DateTime.now().toUtc()),
      ),
    );
    for (var i = 0; i < asignaciones.length; i++) {
      final a = input.asignaciones[i];
      await database.circuitoProveedorDao.editarAsignacion(
        asignaciones[i].id,
        AsignacionesFacturaRecibidaCompanion(
          expedienteId: Value(a.expedienteId),
          baseCentimos: Value(a.importeCentimos),
          ivaNoRecuperableCentimos: Value(a.ivaNoRecuperableCentimos),
        ),
      );
    }
    await database.circuitoProveedorDao.guardarControl(
      c
          .toCompanion(true)
          .copyWith(
            destino: Value(
              input.asignaciones.any((a) => a.expedienteId != null)
                  ? 'obra'
                  : input.destino,
            ),
          ),
    );
    await _auditar(
      id,
      'Borrador corregido',
      'Corrección antes de consolidar',
      detalle: {
        'anterior': old.toJson(),
        'asignacionesAnteriores': asignaciones.map((a) => a.toJson()).toList(),
      },
    );
  });
  Future<int> _abonos(String id) async {
    var total = 0;
    for (final f in await database.circuitoProveedorDao.todasFacturas()) {
      final c = await database.circuitoProveedorDao.control(f.id);
      if (c?.originalId == id &&
          c?.tipo == 'abono' &&
          c?.estadoDocumento == 'registrada') {
        total += f.totalCentimos;
      }
    }
    return total;
  }

  Future<void> _recalcularPago(String id) async {
    final f = await database.circuitoProveedorDao.factura(id);
    if (f == null || f.estado == 'cancelada') return;
    final pagado = await database.circuitoProveedorDao.totalPagado(id);
    final neto = f.totalCentimos - await _abonos(id);
    await database.circuitoProveedorDao.actualizarEstadoFactura(
      id,
      pagado >= neto
          ? 'pagada'
          : pagado > 0
          ? 'parcialmentePagada'
          : 'pendiente',
    );
    final c = await database.circuitoProveedorDao.control(id);
    final estado = c?.pagoVerificado == false
        ? 'noVerificado'
        : pagado >= neto
        ? 'pagada'
        : pagado > 0
        ? 'parcialmentePagada'
        : 'pendiente';
    for (final a in await database.circuitoProveedorDao.asignaciones(id)) {
      final link = await database.circuitoProveedorDao.reconciliacion(a.id);
      if (link != null) {
        await database.comprasDao.actualizarCompra(
          link.compraId,
          ComprasCompanion(estado: Value(estado)),
        );
      }
    }
  }

  Future<void> verificarPago(String id, {required String motivo}) =>
      database.transaction(() async {
        final c = await _control(id);
        if (c.estadoDocumento == 'anulada') {
          throw StateError('Documento anulado.');
        }
        await _auditar(id, 'Pago verificado', motivo);
        await database.circuitoProveedorDao.guardarControl(
          c.toCompanion(true).copyWith(pagoVerificado: const Value(true)),
        );
        await _recalcularPago(id);
      });
  Future<void> revertirPagoProveedor(String pagoId, {required String motivo}) =>
      database.transaction(() async {
        final pago = await database.circuitoProveedorDao.pago(pagoId);
        if (pago == null) throw StateError('Pago no disponible.');
        if ((await database.circuitoProveedorDao.reversionesPago()).any(
          (r) => r.pagoId == pagoId,
        )) {
          throw StateError('El pago ya está revertido.');
        }
        await database.circuitoProveedorDao.revertirPago(
          ReversionesPagosProveedorCompanion.insert(
            tenantId: database.activeTenantId,
            pagoId: pagoId,
            motivo: motivo.trim(),
            actor: 'operador local',
            fecha: DateTime.now().toUtc(),
          ),
        );
        await _auditar(
          pago.facturaId,
          'Pago revertido',
          motivo,
          detalle: {'pago': pago.toJson()},
        );
        await _recalcularPago(pago.facturaId);
      });
  Future<void> anularFactura(
    String id, {
    required String motivo,
  }) => database.transaction(() async {
    final c = await _control(id);
    if (c.estadoDocumento == 'anulada') {
      throw StateError('El documento ya está anulado.');
    }
    if (await database.circuitoProveedorDao.totalPagado(id) != 0) {
      throw StateError(
        'Revierte antes los pagos erróneos. Una operación realmente pagada se corrige con el documento recibido del proveedor.',
      );
    }
    if (await _abonos(id) != 0) {
      throw StateError(
        'Existen abonos relacionados: revisa primero esos documentos.',
      );
    }
    await _auditar(id, 'Factura anulada', motivo);
    if (c.estadoDocumento == 'registrada') await _revertirCostes(id, motivo);
    await database.circuitoProveedorDao.guardarControl(
      c.toCompanion(true).copyWith(estadoDocumento: const Value('anulada')),
    );
    await database.circuitoProveedorDao.actualizarEstadoFactura(
      id,
      'cancelada',
    );
    if (c.originalId != null) await _recalcularPago(c.originalId!);
  });
  Future<void> _revertirCostes(String id, String motivo) async {
    for (final a in await database.circuitoProveedorDao.asignaciones(id)) {
      final link = await database.circuitoProveedorDao.reconciliacion(a.id);
      if (link != null) {
        final compra = await database.comprasDao.obtenerPorId(link.compraId);
        if (compra?.clasificacionEconomica == 'incurrido') {
          await _costes.revertirCompra(link.compraId, motivo: motivo);
        }
      }
    }
    final facts = await database.hechosCosteDao.obtenerPorOrigen(
      'facturaProveedor',
      id,
    );
    final revertidos = facts
        .map((f) => f.hechoRevertidoId)
        .whereType<String>()
        .toSet();
    for (final f in facts.where(
      (f) => f.tipoMovimiento != 'reversion' && !revertidos.contains(f.id),
    )) {
      await database.cierreEconomicoDao.exigirEconomiaAbierta(f.expedienteId);
      await database.hechosCosteDao.insertar(
        HechosCosteCompanion.insert(
          tenantId: database.activeTenantId,
          id: CircuitoProveedorRepository._uuid.v4(),
          expedienteId: f.expedienteId,
          fechaDevengo: DateTime.now(),
          importeNetoCentimos: -f.importeNetoCentimos,
          ivaNoRecuperableCentimos: -f.ivaNoRecuperableCentimos,
          importeCosteCentimos: -f.importeCosteCentimos,
          descripcion: motivo,
          origenTipo: 'facturaProveedor',
          origenId: id,
          tipoMovimiento: 'reversion',
          hechoRevertidoId: Value(f.id),
          claveIdempotencia: 'proveedor:reversion:${f.id}',
          fechaCreacion: DateTime.now().toUtc(),
        ),
      );
    }
  }

  Future<void> _movimiento(
    String id,
    AsignacionesFacturaRecibidaData a,
    int signo,
    String tipo,
    String? original,
    String motivo,
  ) async {
    if (a.expedienteId == null) return;
    await database.cierreEconomicoDao.exigirEconomiaAbierta(a.expedienteId!);
    final key = CircuitoProveedorRepository._uuid.v4();
    await database.hechosCosteDao.insertar(
      HechosCosteCompanion.insert(
        tenantId: database.activeTenantId,
        id: key,
        expedienteId: a.expedienteId!,
        fechaDevengo: (await database.circuitoProveedorDao.factura(
          id,
        ))!.fechaFactura,
        importeNetoCentimos: signo * a.baseCentimos,
        ivaNoRecuperableCentimos: signo * a.ivaNoRecuperableCentimos,
        importeCosteCentimos:
            signo * (a.baseCentimos + a.ivaNoRecuperableCentimos),
        descripcion: motivo,
        origenTipo: 'facturaProveedor',
        origenId: id,
        tipoMovimiento: tipo,
        hechoRevertidoId: Value(original),
        claveIdempotencia: 'proveedor:$key',
        fechaCreacion: DateTime.now().toUtc(),
      ),
    );
  }

  Future<void> cambiarImputacion(
    String id, {
    required List<AsignacionImporteInput> asignaciones,
    required String destino,
    required String motivo,
  }) => database.transaction(() async {
    final c = await _control(id);
    if (c.estadoDocumento == 'anulada') throw StateError('Documento anulado.');
    final f = (await database.circuitoProveedorDao.factura(id))!;
    final old = await database.circuitoProveedorDao.asignaciones(id);
    if (asignaciones.fold<int>(0, (s, a) => s + a.ivaNoRecuperableCentimos) >
            f.ivaCentimos ||
        asignaciones.length != old.length ||
        asignaciones.fold<int>(0, (s, a) => s + a.importeCentimos) !=
            f.baseCentimos) {
      throw StateError(
        'Conserva el número de tramos y la base total del reparto.',
      );
    }
    if (!['obra', 'general', 'sinAsignar'].contains(destino) ||
        (destino == 'obra'
            ? asignaciones.every((a) => a.expedienteId == null)
            : asignaciones.any((a) => a.expedienteId != null))) {
      throw StateError('Revisa el destino del gasto.');
    }
    if (c.estadoDocumento == 'registrada') await _revertirCostes(id, motivo);
    await _auditar(
      id,
      'Cambio de imputación',
      motivo,
      detalle: {
        'anterior': old.map((a) => a.toJson()).toList(),
        'destinoAnterior': c.destino,
      },
    );
    for (var i = 0; i < old.length; i++) {
      final a = asignaciones[i];
      if (a.importeCentimos < 0 || a.ivaNoRecuperableCentimos < 0) {
        throw ArgumentError('Reparto no válido.');
      }
      await database.circuitoProveedorDao.editarAsignacion(
        old[i].id,
        AsignacionesFacturaRecibidaCompanion(
          expedienteId: Value(a.expedienteId),
          baseCentimos: Value(a.importeCentimos),
          ivaNoRecuperableCentimos: Value(a.ivaNoRecuperableCentimos),
        ),
      );
      if (c.estadoDocumento == 'registrada') {
        await _movimiento(
          id,
          (await database.circuitoProveedorDao.asignacionFactura(old[i].id))!,
          c.tipo == 'abono' ? -1 : 1,
          'alta',
          null,
          motivo,
        );
      }
    }
    await database.circuitoProveedorDao.guardarControl(
      c.toCompanion(true).copyWith(destino: Value(destino)),
    );
    await _auditar(id, 'Imputación aplicada', motivo);
  });

  Future<List<Map<String, dynamic>>> listarFichas() async {
    final result = <Map<String, dynamic>>[];
    final revers = (await database.circuitoProveedorDao.reversionesPago())
        .map((p) => p.pagoId)
        .toSet();
    for (final f in await database.circuitoProveedorDao.todasFacturas()) {
      final c = await database.circuitoProveedorDao.control(f.id);
      final asignaciones = await database.circuitoProveedorDao.asignaciones(
        f.id,
      );
      final pagos = await database.circuitoProveedorDao.pagos(f.id);
      final pagado = await database.circuitoProveedorDao.totalPagado(f.id);
      final abonos = await _abonos(f.id);
      final proveedor = await database.proveedoresDao.obtenerProveedor(
        f.proveedorId,
      );
      result.add({
        'id': f.id,
        'proveedorId': f.proveedorId,
        'proveedor': proveedor?.nombre ?? f.proveedorId,
        'numero': f.numeroProveedor,
        'fecha': f.fechaFactura,
        'base': f.baseCentimos,
        'iva': f.ivaCentimos,
        'total': f.totalCentimos,
        'documentoId': f.documentoId,
        'originalId': c?.originalId,
        'tipo': c?.tipo ?? 'factura',
        'estado':
            c?.estadoDocumento ??
            (f.estado == 'cancelada' ? 'anulada' : 'registrada'),
        'verificado': c?.pagoVerificado ?? true,
        'estadoPago': c?.pagoVerificado == false
            ? 'Pago no verificado'
            : f.estado,
        'pagado': pagado,
        'abonos': abonos,
        'pendiente': c?.estadoDocumento == 'anulada' || f.estado == 'cancelada'
            ? 0
            : c?.pagoVerificado == false
            ? null
            : f.totalCentimos - abonos - pagado,
        'destino':
            c?.destino ??
            (asignaciones.any((a) => a.expedienteId != null)
                ? 'obra'
                : 'sinAsignar'),
        'asignaciones': asignaciones
            .map(
              (a) => {
                'obra': a.expedienteId,
                'base': a.baseCentimos,
                'ivaNoRecuperable': a.ivaNoRecuperableCentimos,
              },
            )
            .toList(),
        'pagos': pagos
            .map(
              (p) => {
                'id': p.id,
                'importe': p.importeCentimos,
                'fecha': p.fecha,
                'metodo': p.metodo,
                'revertido': revers.contains(p.id),
              },
            )
            .toList(),
        'eventos': (await database.circuitoProveedorDao.eventos(f.id))
            .map(
              (e) =>
                  '${e.fecha.toLocal()} · ${e.accion} · ${e.motivo} · ${e.actor}',
            )
            .toList(),
      });
    }
    return result;
  }

  Future<String> corregirFactura(
    String id,
    FacturaRecibidaInput input, {
    required String motivo,
  }) => database.transaction(() async {
    final c = await _control(id);
    if (c.tipo != 'factura' || c.estadoDocumento != 'registrada') {
      throw StateError('Solo se sustituye una factura registrada.');
    }
    await anularFactura(id, motivo: motivo);
    final nueva = await crearFactura(
      FacturaRecibidaInput(
        proveedorId: input.proveedorId,
        numero: input.numero,
        fecha: input.fecha,
        baseCentimos: input.baseCentimos,
        ivaCentimos: input.ivaCentimos,
        asignaciones: input.asignaciones,
        vencimiento: input.vencimiento,
        documentoId: input.documentoId,
        originalId: id,
        pagoVerificado: c.pagoVerificado,
        destino: input.destino,
      ),
    );
    await _auditar(
      nueva,
      'Corrección de factura',
      motivo,
      detalle: {'originalId': id},
    );
    await _auditar(
      id,
      'Factura sustituida',
      motivo,
      detalle: {'sustitutaId': nueva},
    );
    return nueva;
  });
}

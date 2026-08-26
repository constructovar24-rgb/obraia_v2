import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/database/database_provider.dart';
import 'package:obraia_v2/features/cobros/domain/cobro.dart' as cobro_domain;
import 'package:obraia_v2/features/facturas/domain/estado_factura.dart';
import 'package:obraia_v2/features/facturas/domain/factura_presupuesto_policy.dart';
import 'package:obraia_v2/features/facturas/domain/factura.dart'
    as factura_domain;
import 'package:obraia_v2/features/presupuestos/domain/presupuesto.dart'
    as presupuesto_domain;
import 'package:obraia_v2/features/expedientes/domain/expediente.dart'
    as expediente_domain;
import 'package:obraia_v2/features/timeline/data/timeline_repository.dart';
import 'package:obraia_v2/features/timeline/domain/timeline_event.dart'
    as timeline_domain;
import 'package:uuid/uuid.dart';

final expedienteRepositoryProvider = Provider<ExpedienteRepository>((ref) {
  final database = ref.read(databaseProvider);
  return ExpedienteRepository(database);
});

final expedienteGestionAccionProvider =
    StreamProvider.family<ExpedienteGestionAccion, String>((ref, expedienteId) {
      final repository = ref.read(expedienteRepositoryProvider);
      return repository.observarAccionGestionExpediente(expedienteId);
    });

final expedienteAtencionEstadoProvider =
    StreamProvider.family<expediente_domain.ExpedienteAtencionEstado, String>((
      ref,
      expedienteId,
    ) {
      final repository = ref.read(expedienteRepositoryProvider);
      return repository.observarEstadoAtencionExpediente(expedienteId);
    });

enum ExpedienteGestionAccion { eliminar, archivar }

class ExpedienteRepository {
  static const int _sinActividadDias = 60;

  final AppDatabase database;
  final TimelineRepository _timelineRepository;
  final Uuid _uuid;

  ExpedienteRepository(this.database)
    : _timelineRepository = TimelineRepository(database.timelineEventsDao),
      _uuid = const Uuid();

  Future<void> crearExpediente({
    required String codigo,
    required String nombre,
    String? clienteId,
    String? cliente,
  }) async {
    final expedienteId = _uuid.v4();

    await database.expedientesDao.insertarExpediente(
      ExpedientesCompanion.insert(
        id: expedienteId,
        codigo: codigo,
        nombre: nombre,
        cliente: Value(cliente ?? ''),
        clienteId: clienteId == null ? const Value.absent() : Value(clienteId),
      ),
    );

    await _timelineRepository.registrarExpedienteCreado(
      expedienteId: expedienteId,
      titulo: codigo,
      descripcion: nombre,
    );
  }

  Stream<List<expediente_domain.Expediente>> observarExpedientes() {
    return database.expedientesDao.observarExpedientes();
  }

  Stream<List<expediente_domain.Expediente>> observarExpedientesArchivados() {
    return database.expedientesDao.observarExpedientesArchivados();
  }

  Stream<List<expediente_domain.Expediente>> observarSinActividad() {
    return Stream<List<expediente_domain.Expediente>>.multi((controller) {
      List<expediente_domain.Expediente>? expedientes;
      List<timeline_domain.TimelineEvent>? eventos;

      void emitirSiCompleto() {
        final expedientesActuales = expedientes;
        final eventosActuales = eventos;
        if (expedientesActuales == null || eventosActuales == null) {
          return;
        }

        final ahora = DateTime.now();
        final hoy = DateTime(ahora.year, ahora.month, ahora.day);
        final limiteSinActividad = hoy.subtract(
          const Duration(days: _sinActividadDias),
        );
        final ultimoEventoPorExpediente = <String, DateTime>{};

        for (final evento in eventosActuales) {
          final expedienteId = evento.expedienteId.trim();
          if (expedienteId.isEmpty) {
            continue;
          }

          final fechaEvento = DateTime(
            evento.fecha.year,
            evento.fecha.month,
            evento.fecha.day,
          );
          final fechaActual = ultimoEventoPorExpediente[expedienteId];
          if (fechaActual == null || fechaEvento.isAfter(fechaActual)) {
            ultimoEventoPorExpediente[expedienteId] = fechaEvento;
          }
        }

        controller.add(
          expedientesActuales
              .where((expediente) {
                final ultimoEvento = ultimoEventoPorExpediente[expediente.id];
                return ultimoEvento == null ||
                    !ultimoEvento.isAfter(limiteSinActividad);
              })
              .toList(growable: false),
        );
      }

      final subscriptions = <StreamSubscription<dynamic>>[
        observarExpedientes().listen((data) {
          expedientes = data;
          emitirSiCompleto();
        }, onError: controller.addError),
        _timelineRepository.observarTodosLosEventosGlobales().listen((data) {
          eventos = data;
          emitirSiCompleto();
        }, onError: controller.addError),
      ];

      controller.onCancel = () async {
        for (final subscription in subscriptions) {
          await subscription.cancel();
        }
      };
    });
  }

  Future<expediente_domain.Expediente?> obtenerExpediente(String id) {
    return database.expedientesDao.obtenerExpediente(id);
  }

  Stream<expediente_domain.ExpedienteAtencionEstado>
  observarEstadoAtencionExpediente(String expedienteId) {
    return _expedienteSnapshot(expedienteId)
        .map(
          (snapshot) => _evaluarEstadoAtencionSecuencial(
            presupuestos: snapshot.presupuestos,
            facturas: snapshot.facturas,
            cobros: snapshot.cobros,
          ),
        )
        .distinct(_esMismoEstadoSinNullable);
  }

  Future<void> actualizarExpediente({
    required String id,
    required String codigo,
    required String nombre,
    String? clienteId,
    String? cliente,
    required String direccion,
    required String poblacion,
    required String provincia,
    required String codigoPostal,
  }) async {
    await database.actualizarExpediente(
      id: id,
      codigo: codigo,
      nombre: nombre,
      clienteId: clienteId,
      cliente: cliente,
      direccion: direccion,
      poblacion: poblacion,
      provincia: provincia,
      codigoPostal: codigoPostal,
    );

    await _timelineRepository.registrarExpedienteActualizado(
      expedienteId: id,
      titulo: codigo,
      descripcion: nombre,
    );
  }

  Future<ExpedienteGestionAccion> obtenerAccionGestionExpediente(
    String expedienteId,
  ) async {
    final tieneActividad = await _tieneActividadRelacionada(expedienteId);

    return tieneActividad
        ? ExpedienteGestionAccion.archivar
        : ExpedienteGestionAccion.eliminar;
  }

  Stream<ExpedienteGestionAccion> observarAccionGestionExpediente(
    String expedienteId,
  ) {
    return _expedienteSnapshot(
      expedienteId,
    ).map(_evaluarAccionGestionDesdeSnapshot).distinct();
  }

  Future<void> gestionarExpediente(
    String expedienteId,
    ExpedienteGestionAccion accion,
  ) async {
    switch (accion) {
      case ExpedienteGestionAccion.eliminar:
        await eliminarExpediente(expedienteId);
        break;
      case ExpedienteGestionAccion.archivar:
        await archivarExpediente(expedienteId);
        break;
    }
  }

  Future<void> eliminarExpediente(String id) {
    return database.expedientesDao.eliminarLogicamente(id);
  }

  Future<void> archivarExpediente(String id) {
    return database.expedientesDao.archivarExpediente(id);
  }

  Future<void> restaurarExpediente(String id) {
    return database.expedientesDao.restaurarExpediente(id);
  }

  Future<bool> _tieneActividadRelacionada(String expedienteId) async {
    if (await database.presupuestosDao.tienePresupuestoPorExpediente(
      expedienteId,
    )) {
      return true;
    }

    if (await database.facturasDao.tieneFacturaPorExpediente(expedienteId)) {
      return true;
    }

    if (await database.comprasDao.tieneCompraPorExpediente(expedienteId)) {
      return true;
    }

    if (await database.documentosDao.tieneDocumentoPorExpediente(
      expedienteId,
    )) {
      return true;
    }

    if (await database.certificacionesDao.tieneCertificacionPorExpediente(
      expedienteId,
    )) {
      return true;
    }

    return false;
  }

  expediente_domain.ExpedienteAtencionEstado _evaluarEstadoAtencionSecuencial({
    required List<presupuesto_domain.Presupuesto> presupuestos,
    required List<factura_domain.Factura> facturas,
    required List<cobro_domain.Cobro> cobros,
  }) {
    if (presupuestos.isEmpty) {
      return const expediente_domain.ExpedienteAtencionEstado(
        nivel: expediente_domain.ExpedienteAtencionNivel.aviso,
        mensajePrincipal: 'Requiere atencion: crea el primer presupuesto',
        detalle: 'Sin presupuestos registrados en este expediente.',
        indicadorPrincipal:
            expediente_domain.ExpedienteAtencionIndicador.sinPresupuestos,
      );
    }

    for (final presupuesto in presupuestos) {
      if (_esPresupuestoPendienteAceptacion(presupuesto.estado)) {
        return expediente_domain.ExpedienteAtencionEstado(
          nivel: expediente_domain.ExpedienteAtencionNivel.aviso,
          mensajePrincipal: 'Presupuesto pendiente de aceptacion',
          detalle: presupuesto.codigo,
          indicadorPrincipal: expediente_domain
              .ExpedienteAtencionIndicador
              .presupuestoPendienteAceptacion,
        );
      }
    }

    final presupuestosConFactura = facturas
        .where(facturaBloqueaConversion)
        .where((factura) {
          final presupuestoId = factura.presupuestoOrigenId;
          return presupuestoId != null && presupuestoId.trim().isNotEmpty;
        })
        .map((factura) => factura.presupuestoOrigenId!)
        .toSet();

    for (final presupuesto in presupuestos) {
      if (_esPresupuestoAceptado(presupuesto.estado) &&
          !presupuestosConFactura.contains(presupuesto.id)) {
        return expediente_domain.ExpedienteAtencionEstado(
          nivel: expediente_domain.ExpedienteAtencionNivel.aviso,
          mensajePrincipal: 'Presupuesto aceptado sin factura',
          detalle: presupuesto.codigo,
          indicadorPrincipal: expediente_domain
              .ExpedienteAtencionIndicador
              .presupuestoAceptadoSinFactura,
        );
      }
    }

    final facturaIds = facturas.map((factura) => factura.id).toSet();
    final totalCobradoPorFactura = <String, double>{};
    for (final cobro in cobros) {
      if (!facturaIds.contains(cobro.facturaId)) {
        continue;
      }

      totalCobradoPorFactura.update(
        cobro.facturaId,
        (prev) => prev + cobro.importe,
        ifAbsent: () => cobro.importe,
      );
    }

    const epsilon = 0.000001;
    for (final factura in facturas) {
      if (!estadoFacturaEsEfectiva(factura.estado)) {
        continue;
      }

      final totalCobrado = totalCobradoPorFactura[factura.id] ?? 0;
      final pendiente = (factura.total - totalCobrado)
          .clamp(0, double.infinity)
          .toDouble();

      if (pendiente > epsilon) {
        return expediente_domain.ExpedienteAtencionEstado(
          nivel: expediente_domain.ExpedienteAtencionNivel.critico,
          mensajePrincipal: 'Factura pendiente de cobro',
          detalle: factura.codigo,
          indicadorPrincipal: expediente_domain
              .ExpedienteAtencionIndicador
              .facturaPendienteCobro,
        );
      }
    }

    return const expediente_domain.ExpedienteAtencionEstado(
      nivel: expediente_domain.ExpedienteAtencionNivel.correcto,
      mensajePrincipal: 'Sin acciones pendientes',
      detalle: 'El expediente no presenta incidencias administrativas.',
      indicadorPrincipal:
          expediente_domain.ExpedienteAtencionIndicador.sinAccionesPendientes,
    );
  }

  bool _esPresupuestoPendienteAceptacion(String estado) {
    return estado.trim().toLowerCase() == 'presentado';
  }

  bool _esPresupuestoAceptado(String estado) {
    return estado.trim().toLowerCase() == 'aceptado';
  }

  Stream<_ExpedienteSnapshot> _expedienteSnapshot(String expedienteId) {
    return Stream.multi((controller) {
      List<presupuesto_domain.Presupuesto>? presupuestos;
      List<factura_domain.Factura>? facturas;
      List<cobro_domain.Cobro>? cobros;
      List<dynamic>? compras;
      List<dynamic>? documentos;
      List<dynamic>? certificaciones;

      void emitirSiCompleto() {
        if (presupuestos == null ||
            facturas == null ||
            cobros == null ||
            compras == null ||
            documentos == null ||
            certificaciones == null) {
          return;
        }

        controller.add(
          _ExpedienteSnapshot(
            presupuestos: presupuestos!,
            facturas: facturas!,
            cobros: cobros!,
            compras: compras!,
            documentos: documentos!,
            certificaciones: certificaciones!,
          ),
        );
      }

      final subscriptions = <StreamSubscription<dynamic>>[
        database.presupuestosDao.observarPorExpediente(expedienteId).listen((
          data,
        ) {
          presupuestos = data;
          emitirSiCompleto();
        }),
        database.facturasDao.observarPorExpediente(expedienteId).listen((data) {
          facturas = data;
          emitirSiCompleto();
        }),
        database.cobrosDao.observarCobros().listen((data) {
          cobros = data;
          emitirSiCompleto();
        }),
        database.comprasDao.observarPorExpediente(expedienteId).listen((data) {
          compras = data;
          emitirSiCompleto();
        }),
        database.documentosDao.observarPorExpediente(expedienteId).listen((
          data,
        ) {
          documentos = data;
          emitirSiCompleto();
        }),
        database.certificacionesDao.observarPorExpediente(expedienteId).listen((
          data,
        ) {
          certificaciones = data;
          emitirSiCompleto();
        }),
      ];

      controller.onCancel = () async {
        for (final subscription in subscriptions) {
          await subscription.cancel();
        }
      };
    });
  }

  ExpedienteGestionAccion _evaluarAccionGestionDesdeSnapshot(
    _ExpedienteSnapshot snapshot,
  ) {
    final tieneActividad =
        snapshot.presupuestos.isNotEmpty ||
        snapshot.facturas.isNotEmpty ||
        snapshot.compras.isNotEmpty ||
        snapshot.documentos.isNotEmpty ||
        snapshot.certificaciones.isNotEmpty;

    return tieneActividad
        ? ExpedienteGestionAccion.archivar
        : ExpedienteGestionAccion.eliminar;
  }

  bool _esMismoEstadoSinNullable(
    expediente_domain.ExpedienteAtencionEstado actual,
    expediente_domain.ExpedienteAtencionEstado siguiente,
  ) {
    return _esMismoEstado(actual, siguiente);
  }

  bool _esMismoEstado(
    expediente_domain.ExpedienteAtencionEstado? actual,
    expediente_domain.ExpedienteAtencionEstado siguiente,
  ) {
    if (actual == null) {
      return false;
    }

    return actual.nivel == siguiente.nivel &&
        actual.mensajePrincipal == siguiente.mensajePrincipal &&
        actual.detalle == siguiente.detalle &&
        actual.indicadorPrincipal == siguiente.indicadorPrincipal;
  }
}

class _ExpedienteSnapshot {
  final List<presupuesto_domain.Presupuesto> presupuestos;
  final List<factura_domain.Factura> facturas;
  final List<cobro_domain.Cobro> cobros;
  final List<dynamic> compras;
  final List<dynamic> documentos;
  final List<dynamic> certificaciones;

  const _ExpedienteSnapshot({
    required this.presupuestos,
    required this.facturas,
    required this.cobros,
    required this.compras,
    required this.documentos,
    required this.certificaciones,
  });
}

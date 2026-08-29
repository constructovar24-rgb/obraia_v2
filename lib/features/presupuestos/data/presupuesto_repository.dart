import 'package:drift/drift.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/features/facturas/domain/estado_factura.dart';
import 'package:obraia_v2/features/facturas/domain/factura_asignacion_presupuesto.dart';
import 'package:obraia_v2/features/facturas/domain/factura_presupuesto_policy.dart';
import 'package:obraia_v2/features/facturas/domain/redondeo_monetario.dart';
import 'package:obraia_v2/features/facturas/domain/factura.dart'
    as factura_domain;
import 'package:obraia_v2/features/presupuestos/domain/presupuesto.dart'
    as presupuesto_domain;
import 'package:obraia_v2/features/timeline/data/timeline_repository.dart';
import 'package:uuid/uuid.dart';

class PresupuestoRepository {
  static const int _backlogComercialAntiguedadDias = 60;

  final AppDatabase database;
  final TimelineRepository _timelineRepository;

  PresupuestoRepository(this.database)
    : _timelineRepository = TimelineRepository(database.timelineEventsDao);

  Stream<List<presupuesto_domain.Presupuesto>> observarPorExpediente(
    String expedienteId,
  ) {
    return database.presupuestosDao.observarPorExpediente(expedienteId);
  }

  Stream<List<presupuesto_domain.Presupuesto>> observarPresupuestos() {
    return database.presupuestosDao.observarPresupuestos();
  }

  Stream<presupuesto_domain.Presupuesto?> observarPresupuesto(String id) {
    return observarPresupuestos().map((presupuestos) {
      for (final presupuesto in presupuestos) {
        if (presupuesto.id == id) {
          return presupuesto;
        }
      }
      return null;
    });
  }

  Stream<List<presupuesto_domain.Presupuesto>> observarPendientesFacturar() {
    return Stream<List<presupuesto_domain.Presupuesto>>.multi((controller) {
      List<presupuesto_domain.Presupuesto>? presupuestos;
      List<factura_domain.Factura>? facturas;
      List<FacturaAsignacionPresupuesto>? asignaciones;

      void emitirSiCompleto() {
        if (presupuestos == null || facturas == null || asignaciones == null) {
          return;
        }
        controller.add(
          presupuestos!
              .where((presupuesto) {
                if (!estadoPresupuestoEsAceptado(presupuesto.estado)) {
                  return false;
                }
                final vinculadas = facturas!
                    .where(
                      (factura) =>
                          factura.presupuestoOrigenId == presupuesto.id &&
                          factura.estado != EstadoFactura.anulada,
                    )
                    .toList();
                final idsConDetalle = asignaciones!
                    .map((item) => item.facturaId)
                    .toSet();
                final consumido = vinculadas.fold<int>(0, (suma, factura) {
                  if (!idsConDetalle.contains(factura.id)) {
                    return suma + monedaACentimos(factura.subtotal);
                  }
                  return suma +
                      asignaciones!
                          .where((item) => item.facturaId == factura.id)
                          .fold<int>(
                            0,
                            (subtotal, item) =>
                                subtotal + monedaACentimos(item.baseAplicada),
                          );
                });
                return consumido < monedaACentimos(presupuesto.importeTotal);
              })
              .toList(growable: false),
        );
      }

      final presupuestosSubscription = observarPresupuestos().listen((data) {
        presupuestos = data;
        emitirSiCompleto();
      }, onError: controller.addError);
      final facturasSubscription = database.facturasDao
          .observarFacturas()
          .listen((data) {
            facturas = data;
            emitirSiCompleto();
          }, onError: controller.addError);
      final asignacionesSubscription = database
          .facturaAsignacionesPresupuestoDao
          .observarTodas()
          .listen((data) {
            asignaciones = data;
            emitirSiCompleto();
          }, onError: controller.addError);

      controller.onCancel = () async {
        await presupuestosSubscription.cancel();
        await facturasSubscription.cancel();
        await asignacionesSubscription.cancel();
      };
    });
  }

  Stream<List<presupuesto_domain.Presupuesto>> observarBacklogComercial() {
    return _observarSinFacturaValida(
      (presupuesto) =>
          _esEstadoPresentado(presupuesto.estado) &&
          _tieneAntiguedadMinima(
            presupuesto.fecha,
            dias: _backlogComercialAntiguedadDias,
          ),
    );
  }

  Stream<List<presupuesto_domain.Presupuesto>> _observarSinFacturaValida(
    bool Function(presupuesto_domain.Presupuesto presupuesto) incluir,
  ) {
    return Stream<List<presupuesto_domain.Presupuesto>>.multi((controller) {
      List<presupuesto_domain.Presupuesto>? presupuestos;
      List<factura_domain.Factura>? facturas;

      void emitirSiCompleto() {
        final presupuestosActuales = presupuestos;
        final facturasActuales = facturas;
        if (presupuestosActuales == null || facturasActuales == null) {
          return;
        }

        final presupuestosConFacturaValida = facturasActuales
            .where(facturaBloqueaConversion)
            .map((factura) => factura.presupuestoOrigenId?.trim())
            .whereType<String>()
            .where((presupuestoId) => presupuestoId.isNotEmpty)
            .toSet();

        controller.add(
          presupuestosActuales
              .where(
                (presupuesto) =>
                    incluir(presupuesto) &&
                    !presupuestosConFacturaValida.contains(presupuesto.id),
              )
              .toList(growable: false),
        );
      }

      final presupuestosSubscription = observarPresupuestos().listen((data) {
        presupuestos = data;
        emitirSiCompleto();
      }, onError: controller.addError);
      final facturasSubscription = database.facturasDao
          .observarFacturas()
          .listen((data) {
            facturas = data;
            emitirSiCompleto();
          }, onError: controller.addError);

      controller.onCancel = () async {
        await presupuestosSubscription.cancel();
        await facturasSubscription.cancel();
      };
    });
  }

  Future<String> _generarCodigoPresupuesto(String expedienteId) async {
    final expediente = await database.expedientesDao.obtenerExpediente(
      expedienteId,
    );
    if (expediente == null) {
      throw Exception('No se encontró el expediente para generar el código');
    }

    final codigoExpediente = expediente.codigo.trim();
    final codigosExistentes = await database.presupuestosDao
        .obtenerCodigosPorExpediente(expedienteId);

    final prefijo = '$codigoExpediente-P';
    var maxCorrelativo = 0;

    for (final codigo in codigosExistentes) {
      if (!codigo.startsWith(prefijo)) {
        continue;
      }

      final sufijo = codigo.substring(prefijo.length);
      final valor = int.tryParse(sufijo);
      if (valor != null && valor > maxCorrelativo) {
        maxCorrelativo = valor;
      }
    }

    final siguiente = maxCorrelativo + 1;
    final secuencia = siguiente.toString().padLeft(2, '0');
    return '$codigoExpediente-P$secuencia';
  }

  Future<void> crearPresupuesto({
    required String expedienteId,
    required DateTime fecha,
    String descripcion = '',
    double importeTotal = 0,
    String estado = 'Borrador',
  }) async {
    final codigo = await _generarCodigoPresupuesto(expedienteId);
    final presupuestoId = const Uuid().v4();

    await database.presupuestosDao.insertarPresupuesto(
      PresupuestosCompanion.insert(
        id: presupuestoId,
        expedienteId: expedienteId,
        titulo: Value(codigo),
        codigo: Value(codigo),
        fecha: Value(fecha),
        descripcion: Value(descripcion),
        importeTotal: Value(importeTotal),
        estado: Value(estado),
      ),
    );

    await _timelineRepository.registrarPresupuestoCreado(
      expedienteId: expedienteId,
      presupuestoId: presupuestoId,
      titulo: codigo,
    );

    if (_esEstadoAceptado(estado)) {
      await _timelineRepository.registrarPresupuestoAceptado(
        expedienteId: expedienteId,
        presupuestoId: presupuestoId,
        titulo: codigo,
      );
    }
  }

  bool _esEstadoAceptado(String estado) {
    return estado.trim().toLowerCase() == 'aceptado';
  }

  bool _esEstadoPresentado(String estado) {
    return estado.trim().toLowerCase() == 'presentado';
  }

  bool _tieneAntiguedadMinima(DateTime fecha, {required int dias}) {
    final ahora = DateTime.now();
    final hoy = DateTime(ahora.year, ahora.month, ahora.day);
    final fechaNormalizada = DateTime(fecha.year, fecha.month, fecha.day);
    return hoy.difference(fechaNormalizada).inDays >= dias;
  }

  Future<void> actualizarImporteTotal(
    String presupuestoId,
    double importeTotal,
  ) {
    return database.presupuestosDao.actualizarImporteTotal(
      presupuestoId,
      importeTotal,
    );
  }

  Future<void> actualizarIvaPorcentaje(
    String presupuestoId,
    double ivaPorcentaje,
  ) {
    return database.presupuestosDao.actualizarIvaPorcentaje(
      presupuestoId,
      ivaPorcentaje,
    );
  }

  Future<bool> eliminarSiNoFacturado(String presupuestoId) async {
    final tieneFacturaAsociada = await database.presupuestosDao
        .tieneFacturaAsociada(presupuestoId);

    if (tieneFacturaAsociada) {
      return false;
    }

    await database.presupuestosDao.eliminarLogicamente(presupuestoId);
    return true;
  }
}

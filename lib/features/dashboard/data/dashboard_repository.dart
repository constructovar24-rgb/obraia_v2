import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../cobros/domain/cobro.dart' as cobro_domain;
import '../../cobros/domain/factura_estado_economico.dart';
import '../../expedientes/domain/expediente.dart' as expediente_domain;
import '../../facturas/domain/factura.dart' as factura_domain;
import '../../facturas/domain/estado_factura.dart';
import '../../facturas/domain/factura_presupuesto_policy.dart';
import '../../presupuestos/domain/presupuesto.dart' as presupuesto_domain;
import '../../cobros/data/cobro_repository.dart';
import '../../expedientes/data/expediente_repository.dart';
import '../../facturas/data/factura_repository.dart';
import '../../presupuestos/data/presupuesto_repository.dart';
import '../../presupuestos/presentation/providers/presupuesto_providers.dart';
import '../domain/dashboard_resumen.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository(
    expedienteRepository: ref.read(expedienteRepositoryProvider),
    presupuestoRepository: ref.read(presupuestoRepositoryProvider),
    facturaRepository: ref.read(facturaRepositoryProvider),
    cobroRepository: ref.read(cobroRepositoryProvider),
  );
});

class DashboardRepository {
  DashboardRepository({
    required this.expedienteRepository,
    required this.presupuestoRepository,
    required this.facturaRepository,
    required this.cobroRepository,
  });

  final ExpedienteRepository expedienteRepository;
  final PresupuestoRepository presupuestoRepository;
  final FacturaRepository facturaRepository;
  final CobroRepository cobroRepository;

  Stream<DashboardResumen> observarResumen() {
    return Stream<DashboardResumen>.multi((controller) {
      List<expediente_domain.Expediente>? expedientes;
      List<expediente_domain.Expediente>? expedientesSinActividad;
      List<presupuesto_domain.Presupuesto>? presupuestos;
      List<presupuesto_domain.Presupuesto>? presupuestosPendientesFacturar;
      List<presupuesto_domain.Presupuesto>? presupuestosBacklogComercial;
      List<factura_domain.Factura>? facturas;
      List<factura_domain.Factura>? facturadoEsteMes;
      List<cobro_domain.Cobro>? cobros;
      List<cobro_domain.Cobro>? cobradoEsteMes;

      void emitirSiCompleto() {
        if (expedientes == null ||
            expedientesSinActividad == null ||
            presupuestos == null ||
            presupuestosPendientesFacturar == null ||
            presupuestosBacklogComercial == null ||
            facturas == null ||
            facturadoEsteMes == null ||
            cobros == null ||
            cobradoEsteMes == null) {
          return;
        }

        final numeroExpedientes = expedientes!.length;

        final numeroPresupuestos = presupuestos!.length;
        final totalPresupuestado = presupuestos!.fold<double>(
          0,
          (sum, presupuesto) => sum + presupuesto.importeTotal,
        );
        final now = DateTime.now();

        final presupuestosConFactura = facturas!
            .where(facturaBloqueaConversion)
            .where((factura) {
              final presupuestoId = factura.presupuestoOrigenId;
              return presupuestoId != null && presupuestoId.trim().isNotEmpty;
            })
            .map((factura) => factura.presupuestoOrigenId!)
            .toSet();

        final presupuestosFacturados = presupuestos!
            .where(
              (presupuesto) => presupuestosConFactura.contains(presupuesto.id),
            )
            .length;
        final presupuestosPendientesFacturarConteo =
            presupuestosPendientesFacturar!.length;

        final facturasEfectivas = facturas!
            .where((factura) => estadoFacturaEsEfectiva(factura.estado))
            .toList();
        final numeroFacturas = facturasEfectivas.length;
        final totalFacturado = facturasEfectivas.fold<double>(
          0,
          (sum, factura) => sum + factura.total,
        );
        final expedientesSinActividadConteo = expedientesSinActividad!.length;

        final presupuestosBacklogComercialConteo =
            presupuestosBacklogComercial!.length;
        final presupuestosBacklogComercialImporte =
            presupuestosBacklogComercial!.fold<double>(
              0,
              (sum, presupuesto) => sum + presupuesto.importeTotal,
            );

        final totalFacturadoEsteMes = facturadoEsteMes!.fold<double>(
          0,
          (sum, factura) => sum + factura.total,
        );

        final cobradoPorFactura = <String, double>{};
        for (final cobro in cobros!) {
          cobradoPorFactura.update(
            cobro.facturaId,
            (prev) => prev + cobro.importe,
            ifAbsent: () => cobro.importe,
          );
        }

        var facturasPendientesCobro = 0;
        var facturasParcialmenteCobradas = 0;
        var facturasCobradas = 0;
        var facturasVencidasConteo = 0;
        var facturasVencidasImporte = 0.0;
        var facturasVencenProximos7Dias = 0;
        var saldoPendienteTotal = 0.0;

        for (final factura in facturas!) {
          final resumenEconomico = calcularResumenEconomicoFactura(
            totalFactura: factura.total,
            totalCobrado: cobradoPorFactura[factura.id] ?? 0,
            fechaVencimiento: factura.fechaVencimiento,
            estadoFactura: factura.estado,
            fechaReferencia: now,
          );

          if (resumenEconomico.estaVencida) {
            facturasVencidasConteo += 1;
            facturasVencidasImporte += resumenEconomico.pendiente;
          }
          if (resumenEconomico.venceEnProximos7Dias) {
            facturasVencenProximos7Dias += 1;
          }
          if (resumenEconomico.tieneSaldoPendiente) {
            saldoPendienteTotal += resumenEconomico.pendiente;
          }
          if (resumenEconomico.esPendienteDeCobro) {
            facturasPendientesCobro += 1;
          }
          if (resumenEconomico.esParcialmenteCobrada) {
            facturasParcialmenteCobradas += 1;
          }
          if (estadoFacturaEsEfectiva(factura.estado) &&
              resumenEconomico.estado == EstadoEconomicoFactura.cobrada) {
            facturasCobradas += 1;
          }
        }

        final totalCobrado = cobros!.fold<double>(
          0,
          (sum, cobro) => sum + cobro.importe,
        );
        final totalCobradoEsteMes = cobradoEsteMes!.fold<double>(
          0,
          (sum, cobro) => sum + cobro.importe,
        );

        final coberturaCobroPorcentaje = totalFacturado == 0
            ? 0.0
            : (totalCobrado / totalFacturado) * 100;
        final conversionPresupuestosFacturasPorcentaje = numeroPresupuestos == 0
            ? 0.0
            : (presupuestosFacturados / numeroPresupuestos) * 100;

        controller.add(
          DashboardResumen(
            numeroExpedientes: numeroExpedientes,
            numeroPresupuestos: numeroPresupuestos,
            presupuestosPendientesFacturar:
                presupuestosPendientesFacturarConteo,
            presupuestosFacturados: presupuestosFacturados,
            totalPresupuestado: totalPresupuestado,
            numeroFacturas: numeroFacturas,
            facturasPendientesCobro: facturasPendientesCobro,
            facturasParcialmenteCobradas: facturasParcialmenteCobradas,
            facturasCobradas: facturasCobradas,
            totalFacturado: totalFacturado,
            totalCobrado: totalCobrado,
            totalCobradoEsteMes: totalCobradoEsteMes,
            totalFacturadoEsteMes: totalFacturadoEsteMes,
            saldoPendienteTotal: saldoPendienteTotal,
            facturasVencidasConteo: facturasVencidasConteo,
            facturasVencidasImporte: facturasVencidasImporte,
            facturasVencenProximos7Dias: facturasVencenProximos7Dias,
            coberturaCobroPorcentaje: coberturaCobroPorcentaje,
            conversionPresupuestosFacturasPorcentaje:
                conversionPresupuestosFacturasPorcentaje,
            presupuestosBacklogComercialConteo:
                presupuestosBacklogComercialConteo,
            presupuestosBacklogComercialImporte:
                presupuestosBacklogComercialImporte,
            expedientesSinActividadConteo: expedientesSinActividadConteo,
          ),
        );
      }

      final subs = <StreamSubscription<dynamic>>[
        expedienteRepository.observarExpedientes().listen((data) {
          expedientes = data;
          emitirSiCompleto();
        }, onError: controller.addError),
        expedienteRepository.observarSinActividad().listen((data) {
          expedientesSinActividad = data;
          emitirSiCompleto();
        }, onError: controller.addError),
        presupuestoRepository.observarPresupuestos().listen((data) {
          presupuestos = data;
          emitirSiCompleto();
        }, onError: controller.addError),
        presupuestoRepository.observarPendientesFacturar().listen((data) {
          presupuestosPendientesFacturar = data;
          emitirSiCompleto();
        }, onError: controller.addError),
        presupuestoRepository.observarBacklogComercial().listen((data) {
          presupuestosBacklogComercial = data;
          emitirSiCompleto();
        }, onError: controller.addError),
        facturaRepository.observarFacturas().listen((data) {
          facturas = data;
          emitirSiCompleto();
        }, onError: controller.addError),
        facturaRepository.observarFacturadoEnMes(DateTime.now()).listen((data) {
          facturadoEsteMes = data;
          emitirSiCompleto();
        }, onError: controller.addError),
        cobroRepository.observarCobrosOperativos().listen((data) {
          cobros = data;
          emitirSiCompleto();
        }, onError: controller.addError),
        cobroRepository.observarCobrosEnMesConFactura(DateTime.now()).listen((
          data,
        ) {
          cobradoEsteMes = data;
          emitirSiCompleto();
        }, onError: controller.addError),
      ];

      controller.onCancel = () async {
        for (final sub in subs) {
          await sub.cancel();
        }
      };
    });
  }
}

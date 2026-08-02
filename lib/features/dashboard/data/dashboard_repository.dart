import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../cobros/domain/cobro.dart' as cobro_domain;
import '../../cobros/domain/factura_estado_economico.dart';
import '../../expedientes/domain/expediente.dart' as expediente_domain;
import '../../facturas/domain/factura.dart' as factura_domain;
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
      List<presupuesto_domain.Presupuesto>? presupuestos;
      List<factura_domain.Factura>? facturas;
      List<cobro_domain.Cobro>? cobros;

      void emitirSiCompleto() {
        if (expedientes == null ||
            presupuestos == null ||
            facturas == null ||
            cobros == null) {
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
            .where((factura) {
              final presupuestoId = factura.presupuestoOrigenId;
              return presupuestoId != null && presupuestoId.trim().isNotEmpty;
            })
            .map((factura) => factura.presupuestoOrigenId!)
            .toSet();

        final presupuestosFacturados = presupuestos!
            .where((presupuesto) => presupuestosConFactura.contains(presupuesto.id))
            .length;
        final presupuestosPendientesFacturar =
            numeroPresupuestos - presupuestosFacturados;

        final numeroFacturas = facturas!.length;
        final totalFacturado = facturas!.fold<double>(
          0,
          (sum, factura) => sum + factura.total,
        );
        final totalFacturadoEsteMes = facturas!
            .where(
              (factura) =>
                  factura.fecha.year == now.year &&
                  factura.fecha.month == now.month,
            )
            .fold<double>(0, (sum, factura) => sum + factura.total);

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

        for (final factura in facturas!) {
          final totalCobradoFactura = cobradoPorFactura[factura.id] ?? 0;
          final estadoEconomico = calcularEstadoEconomicoFactura(
            totalFactura: factura.total,
            totalCobrado: totalCobradoFactura,
          );

          switch (estadoEconomico) {
            case EstadoEconomicoFactura.pendiente:
              facturasPendientesCobro += 1;
              break;
            case EstadoEconomicoFactura.parcialmenteCobrada:
              facturasParcialmenteCobradas += 1;
              break;
            case EstadoEconomicoFactura.cobrada:
              facturasCobradas += 1;
              break;
          }
        }

        final totalCobrado = cobros!.fold<double>(
          0,
          (sum, cobro) => sum + cobro.importe,
        );
        final totalCobradoEsteMes = cobros!
            .where(
              (cobro) =>
                  cobro.fecha.year == now.year && cobro.fecha.month == now.month,
            )
            .fold<double>(0, (sum, cobro) => sum + cobro.importe);

        final pendienteTotal =
            (totalFacturado - totalCobrado).clamp(0, double.infinity).toDouble();

        controller.add(
          DashboardResumen(
            numeroExpedientes: numeroExpedientes,
            numeroPresupuestos: numeroPresupuestos,
            presupuestosPendientesFacturar: presupuestosPendientesFacturar,
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
            pendienteTotal: pendienteTotal,
          ),
        );
      }

      final subs = <StreamSubscription<dynamic>>[
        expedienteRepository.observarExpedientes().listen(
          (data) {
            expedientes = data;
            emitirSiCompleto();
          },
          onError: controller.addError,
        ),
        presupuestoRepository.observarPresupuestos().listen(
          (data) {
            presupuestos = data;
            emitirSiCompleto();
          },
          onError: controller.addError,
        ),
        facturaRepository.observarFacturas().listen(
          (data) {
            facturas = data;
            emitirSiCompleto();
          },
          onError: controller.addError,
        ),
        cobroRepository.observarCobros().listen(
          (data) {
            cobros = data;
            emitirSiCompleto();
          },
          onError: controller.addError,
        ),
      ];

      controller.onCancel = () async {
        for (final sub in subs) {
          await sub.cancel();
        }
      };
    });
  }
}

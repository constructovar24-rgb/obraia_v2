import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../facturas/data/factura_repository.dart';
import '../../../compras/presentation/providers/compra_providers.dart';
import '../../../presupuestos/presentation/providers/presupuesto_providers.dart';

class ExpedientePresupuestoResumen {
  const ExpedientePresupuestoResumen(this.cantidad, this.total);
  final int cantidad;
  final double total;
}

class ExpedienteFacturaResumen {
  const ExpedienteFacturaResumen(
    this.cantidad,
    this.facturado,
    this.cobrado,
    this.pendiente,
  );
  final int cantidad;
  final double facturado;
  final double cobrado;
  final double pendiente;
}

class ExpedienteCompraResumen {
  const ExpedienteCompraResumen(this.cantidad, this.total);
  final int cantidad;
  final double total;
}

final expedientePresupuestoResumenProvider =
    StreamProvider.family<ExpedientePresupuestoResumen, String>((ref, id) {
      return ref
          .watch(presupuestoRepositoryProvider)
          .observarPorExpediente(id)
          .map(
            (items) => ExpedientePresupuestoResumen(
              items.length,
              items.fold(0, (sum, item) => sum + item.importeTotal),
            ),
          );
    });

final expedienteFacturaResumenProvider =
    StreamProvider.family<ExpedienteFacturaResumen, String>((ref, id) {
      return ref
          .watch(facturaRepositoryProvider)
          .observarPorExpedienteConEstadoEconomico(id)
          .map(
            (items) => ExpedienteFacturaResumen(
              items.length,
              items.fold(
                0,
                (sum, item) => sum + item.estadoEconomico.totalFactura,
              ),
              items.fold(
                0,
                (sum, item) => sum + item.estadoEconomico.totalCobrado,
              ),
              items.fold(
                0,
                (sum, item) => sum + item.estadoEconomico.pendiente,
              ),
            ),
          );
    });

final expedienteCompraResumenProvider =
    StreamProvider.family<ExpedienteCompraResumen, String>((ref, id) {
      return ref
          .watch(compraRepositoryProvider)
          .observarCompras(id)
          .map(
            (items) => ExpedienteCompraResumen(
              items.length,
              items.fold(0, (sum, item) => sum + item.importeTotal),
            ),
          );
    });

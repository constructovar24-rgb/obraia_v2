import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obraia_v2/database/database_provider.dart';
import 'package:obraia_v2/features/cobros/data/cobro_repository.dart';
import 'package:obraia_v2/features/dashboard/data/dashboard_repository.dart';
import 'package:obraia_v2/features/expedientes/data/expediente_repository.dart';
import 'package:obraia_v2/features/facturas/presentation/providers/factura_providers.dart';
import 'package:obraia_v2/features/presupuestos/presentation/providers/presupuesto_providers.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  ref.watch(activeTenantIdProvider);
  return DashboardRepository(
    expedienteRepository: ref.watch(expedienteRepositoryProvider),
    presupuestoRepository: ref.watch(presupuestoRepositoryProvider),
    facturaRepository: ref.watch(facturaRepositoryProvider),
    cobroRepository: ref.watch(cobroRepositoryProvider),
  );
});

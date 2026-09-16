import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obraia_v2/database/database_provider.dart';
import 'package:obraia_v2/features/clientes/presentation/providers/cliente_providers.dart';
import 'package:obraia_v2/features/expedientes/data/expediente_repository.dart';
import 'package:obraia_v2/features/facturas/presentation/providers/factura_providers.dart';
import 'package:obraia_v2/features/presupuestos/presentation/providers/presupuesto_providers.dart';
import 'package:obraia_v2/features/search/data/search_repository.dart';

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  ref.watch(activeTenantIdProvider);
  return SearchRepository(
    clienteRepository: ref.watch(clienteRepositoryProvider),
    expedienteRepository: ref.watch(expedienteRepositoryProvider),
    presupuestoRepository: ref.watch(presupuestoRepositoryProvider),
    facturaRepository: ref.watch(facturaRepositoryProvider),
  );
});

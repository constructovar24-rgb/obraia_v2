import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../database/database_provider.dart';
import '../../data/credito_cliente_repository.dart';
import '../../domain/credito_cliente.dart';

final creditoClienteRepositoryProvider = Provider<CreditoClienteRepository>(
  (ref) => CreditoClienteRepository(ref.watch(databaseProvider)),
);

final creditoFamiliaProvider =
    StreamProvider.family<CreditoClienteFamilia, String>(
      (ref, facturaId) => ref
          .watch(creditoClienteRepositoryProvider)
          .observarResumen(facturaId),
    );

final movimientosCreditoProvider =
    StreamProvider.family<List<MovimientoCreditoCliente>, String>(
      (ref, raizId) => ref
          .watch(creditoClienteRepositoryProvider)
          .observarMovimientos(raizId),
    );

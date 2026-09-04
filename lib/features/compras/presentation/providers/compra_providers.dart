import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../database/database_provider.dart';
import '../../../expedientes/data/expediente_repository.dart';
import '../../../expedientes/domain/expediente.dart';
import '../../data/compra_repository.dart';
import '../../domain/compra.dart';

final compraRepositoryProvider = Provider<CompraRepository>((ref) {
  ref.watch(activeTenantIdProvider);
  final database = ref.watch(databaseProvider);
  return CompraRepository(database);
});

final comprasProvider = StreamProvider.family<List<Compra>, String>((
  ref,
  expedienteId,
) {
  final compraRepository = ref.watch(compraRepositoryProvider);
  return compraRepository.observarCompras(expedienteId);
});

final comprasGlobalesProvider = StreamProvider<List<Compra>>((ref) {
  return ref.watch(compraRepositoryProvider).observarTodas();
});

final expedientesCompraProvider = StreamProvider<List<Expediente>>((ref) {
  return ref.watch(expedienteRepositoryProvider).observarExpedientes();
});

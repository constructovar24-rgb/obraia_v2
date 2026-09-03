import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../database/database_provider.dart';
import '../../data/proveedor_repository.dart';
import '../../domain/proveedor.dart';

final proveedorRepositoryProvider = Provider<ProveedorRepository>((ref) {
  ref.watch(activeTenantIdProvider);
  final database = ref.watch(databaseProvider);
  return ProveedorRepository(database.proveedoresDao);
});

final proveedoresProvider = StreamProvider<List<Proveedor>>((ref) {
  final proveedorRepository = ref.watch(proveedorRepositoryProvider);
  return proveedorRepository.observarProveedores();
});

final proveedorProvider = StreamProvider.family<Proveedor?, String>((ref, id) {
  return ref.watch(proveedorRepositoryProvider).observarProveedores().map((
    proveedores,
  ) {
    for (final proveedor in proveedores) {
      if (proveedor.id == id) return proveedor;
    }
    return null;
  });
});

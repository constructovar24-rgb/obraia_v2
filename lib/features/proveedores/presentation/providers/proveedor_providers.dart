import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../database/database_provider.dart';
import '../../data/proveedor_repository.dart';
import '../../domain/proveedor.dart';

final proveedorRepositoryProvider = Provider<ProveedorRepository>((ref) {
  final database = ref.read(databaseProvider);
  return ProveedorRepository(database.proveedoresDao);
});

final proveedoresProvider = StreamProvider<List<Proveedor>>((ref) {
  final proveedorRepository = ref.read(proveedorRepositoryProvider);
  return proveedorRepository.observarProveedores();
});

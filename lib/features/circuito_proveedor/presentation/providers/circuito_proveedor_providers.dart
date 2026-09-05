import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../database/app_database.dart';
import '../../../../database/database_provider.dart';
import '../../data/circuito_proveedor_repository.dart';

final circuitoProveedorRepositoryProvider = Provider<CircuitoProveedorRepository>((ref) {
  ref.watch(activeTenantIdProvider);
  return CircuitoProveedorRepository(ref.watch(databaseProvider));
});

final albaranesObraProvider = StreamProvider.family<List<AlbaranesProveedorData>, String>((ref, expedienteId) => ref.watch(circuitoProveedorRepositoryProvider).observarAlbaranesObra(expedienteId));
final facturasRecibidasObraProvider = StreamProvider.family<List<AsignacionesFacturaRecibidaData>, String>((ref, expedienteId) => ref.watch(circuitoProveedorRepositoryProvider).observarFacturasObra(expedienteId));

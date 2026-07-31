import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../database/database_provider.dart';
import '../../data/linea_presupuesto_repository.dart';
import '../../data/presupuesto_repository.dart';

final presupuestoRepositoryProvider = Provider<PresupuestoRepository>((ref) {
  final database = ref.read(databaseProvider);
  return PresupuestoRepository(database);
});

final lineaPresupuestoRepositoryProvider =
    Provider<LineaPresupuestoRepository>((ref) {
      final database = ref.read(databaseProvider);
      return LineaPresupuestoRepository(database);
    });
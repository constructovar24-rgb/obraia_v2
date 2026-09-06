import 'dart:typed_data';
import '../../data/presupuesto_documental_repository.dart';
import '../../domain/presupuesto_documento.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../database/database_provider.dart';
import '../../data/linea_presupuesto_repository.dart';
import '../../data/presupuesto_repository.dart';

final presupuestoRepositoryProvider = Provider<PresupuestoRepository>((ref) {
  ref.watch(activeTenantIdProvider);
  final database = ref.watch(databaseProvider);
  return PresupuestoRepository(database);
});

final lineaPresupuestoRepositoryProvider = Provider<LineaPresupuestoRepository>(
  (ref) {
    ref.watch(activeTenantIdProvider);
    final database = ref.watch(databaseProvider);
    return LineaPresupuestoRepository(database);
  },
);

final presupuestoDocumentalRepositoryProvider =
    Provider<PresupuestoDocumentalRepository>((ref) {
      ref.watch(activeTenantIdProvider);
      return PresupuestoDocumentalRepository(ref.watch(databaseProvider));
    });
final presupuestoPdfProvider = FutureProvider.autoDispose
    .family<Uint8List, String>(
      (ref, id) =>
          ref.watch(presupuestoDocumentalRepositoryProvider).obtenerPdf(id),
    );
final presupuestoSnapshotProvider = FutureProvider.autoDispose
    .family<PresupuestoDocumento?, String>(
      (ref, id) => ref
          .watch(presupuestoDocumentalRepositoryProvider)
          .obtenerSnapshot(id),
    );
final aceptandoPresupuestoProvider = StateProvider.autoDispose
    .family<bool, String>((ref, id) => false);

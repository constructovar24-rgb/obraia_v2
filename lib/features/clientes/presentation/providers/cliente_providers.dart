import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../database/database_provider.dart';
import '../../../expedientes/data/expediente_repository.dart';
import '../../../expedientes/domain/expediente.dart';
import '../../data/cliente_repository.dart';
import '../../domain/cliente.dart';

final clienteRepositoryProvider = Provider<ClienteRepository>((ref) {
  return ClienteRepository(ref.watch(databaseProvider));
});

final clientesProvider = StreamProvider<List<Cliente>>((ref) {
  return ref.watch(clienteRepositoryProvider).observarClientes();
});

final clienteProvider = StreamProvider.family<Cliente?, String>((ref, id) {
  return ref.watch(clienteRepositoryProvider).observarCliente(id);
});

final expedientesClienteProvider =
    StreamProvider.family<List<Expediente>, String>((ref, clienteId) {
      return ref
          .watch(expedienteRepositoryProvider)
          .observarPorCliente(clienteId);
    });

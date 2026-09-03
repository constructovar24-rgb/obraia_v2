import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../clientes/data/cliente_repository.dart';
import '../../../clientes/domain/cliente.dart';

final clientesEdicionExpedienteProvider = StreamProvider<List<Cliente>>((ref) {
  return ref.watch(clienteRepositoryProvider).observarClientes();
});

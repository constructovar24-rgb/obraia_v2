import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../database/database_provider.dart';
import '../../../clientes/data/cliente_repository.dart';
import '../../../clientes/domain/cliente.dart' as cliente_domain;
import '../../data/expediente_repository.dart';

class ClienteTab extends ConsumerStatefulWidget {
  const ClienteTab({
    super.key,
    required this.expedienteId,
  });

  final String expedienteId;

  @override
  ConsumerState<ClienteTab> createState() => _ClienteTabState();
}

class _ClienteTabState extends ConsumerState<ClienteTab> {
  late final Future<cliente_domain.Cliente?> _clienteFuture;

  @override
  void initState() {
    super.initState();
    _clienteFuture = _cargarCliente();
  }

  Future<cliente_domain.Cliente?> _cargarCliente() async {
    final db = ref.read(databaseProvider);
    final expedienteRepository = ExpedienteRepository(db);
    final clienteRepository = ClienteRepository(db);

    final expediente = await expedienteRepository.obtenerExpediente(
      widget.expedienteId,
    );

    final clienteId = expediente?.clienteId;
    if (clienteId == null || clienteId.isEmpty) {
      return null;
    }

    return clienteRepository.obtenerCliente(clienteId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<cliente_domain.Cliente?>(
      future: _clienteFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SelectableText(
                'ERROR:\n\n${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        final cliente = snapshot.data;
        if (cliente == null) {
          return const Center(
            child: Text('No hay cliente asociado'),
          );
        }

        final nombreCompleto = '${cliente.nombre} ${cliente.apellidos}'.trim();

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (nombreCompleto.isNotEmpty)
              _InfoRow(
                etiqueta: 'Nombre',
                valor: nombreCompleto,
              ),
            if (cliente.nif.trim().isNotEmpty)
              _InfoRow(
                etiqueta: 'CIF/NIF',
                valor: cliente.nif,
              ),
            if (cliente.telefono.trim().isNotEmpty)
              _InfoRow(
                etiqueta: 'Teléfono',
                valor: cliente.telefono,
              ),
            if (cliente.email.trim().isNotEmpty)
              _InfoRow(
                etiqueta: 'Email',
                valor: cliente.email,
              ),
            if (cliente.direccion.trim().isNotEmpty)
              _InfoRow(
                etiqueta: 'Dirección',
                valor: cliente.direccion,
              ),
          ],
        );
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.etiqueta,
    required this.valor,
  });

  final String etiqueta;
  final String valor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            etiqueta,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 4),
          Text(
            valor,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class DatosGeneralesScreen extends StatelessWidget {
  const DatosGeneralesScreen({
    super.key,
    required this.id,
    required this.codigoExpediente,
  });

  final String id;
  final String codigoExpediente;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Datos generales'),
      ),
      body: DatosGeneralesTab(
        id: id,
        codigoExpediente: codigoExpediente,
      ),
    );
  }
}

class DatosGeneralesTab extends StatelessWidget {
  const DatosGeneralesTab({
    super.key,
    required this.id,
    required this.codigoExpediente,
  });

  final String id;
  final String codigoExpediente;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ID: $id',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Expediente: $codigoExpediente',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
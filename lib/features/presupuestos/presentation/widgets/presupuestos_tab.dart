import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/presupuesto_repository.dart';
import '../../domain/presupuesto.dart' as presupuesto_domain;
import '../screens/nuevo_presupuesto_screen.dart';
import '../screens/presupuesto_detail_screen.dart';

class PresupuestosTab extends ConsumerStatefulWidget {
  const PresupuestosTab({
    super.key,
    required this.expedienteId,
  });

  final String expedienteId;

  @override
  ConsumerState<PresupuestosTab> createState() => _PresupuestosTabState();
}

class _PresupuestosTabState extends ConsumerState<PresupuestosTab> {
  late final PresupuestoRepository _repository;
  late final Stream<List<presupuesto_domain.Presupuesto>> _stream;

  @override
  void initState() {
    super.initState();
    _repository = ref.read(presupuestoRepositoryProvider);
    _stream = _repository.observarPorExpediente(widget.expedienteId);
  }

  @override
  Widget build(BuildContext context) {
    void abrirNuevoPresupuesto() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => NuevoPresupuestoScreen(
            expedienteId: widget.expedienteId,
          ),
        ),
      );
    }

    String formatearFecha(DateTime fecha) {
      final day = fecha.day.toString().padLeft(2, '0');
      final month = fecha.month.toString().padLeft(2, '0');
      final year = fecha.year.toString();
      return '$day/$month/$year';
    }

    String formatearImporte(double importe) {
      return '${importe.toStringAsFixed(2)} €';
    }

    return StreamBuilder<List<presupuesto_domain.Presupuesto>>(
      stream: _stream,
      builder: (context, snapshot) {
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

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final presupuestos = snapshot.data ?? const [];

        if (presupuestos.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Expanded(
                  child: Center(
                    child: Text(
                      'Todavía no hay presupuestos.',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: abrirNuevoPresupuesto,
                    child: const Text('Nuevo presupuesto'),
                  ),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: presupuestos.length,
                  itemBuilder: (context, index) {
                    final presupuesto = presupuestos[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: const Icon(Icons.request_quote_outlined),
                        title: Text(
                          presupuesto.codigo,
                        ),
                        subtitle: Text(
                          '${formatearFecha(presupuesto.fecha)}\nEstado: ${presupuesto.estado}\nImporte: ${formatearImporte(presupuesto.importeTotal)}\n${presupuesto.descripcion}',
                        ),
                        isThreeLine: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PresupuestoDetailScreen(
                                presupuesto: presupuesto,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: abrirNuevoPresupuesto,
                  child: const Text('Nuevo presupuesto'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import '../models/pool_budget.dart';

class PoolResultScreen extends StatelessWidget {
  final PoolBudget presupuesto;

  const PoolResultScreen({
    super.key,
    required this.presupuesto,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Presupuesto"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    dato(
                      "Volumen",
                      "${presupuesto.volumen.toStringAsFixed(2)} m³",
                    ),
                    dato(
                      "Superficie interior",
                      "${presupuesto.superficie.toStringAsFixed(2)} m²",
                    ),
                    dato(
                      "Perímetro",
                      "${presupuesto.perimetro.toStringAsFixed(2)} m",
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Partidas",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            ...presupuesto.partidas.map(
              (p) => Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${p.codigo} - ${p.descripcion}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "Cantidad: ${p.cantidad.toStringAsFixed(2)} ${p.unidad}",
                      ),

                      Text(
                        "Precio unitario: ${p.precioUnitario.toStringAsFixed(2)} €/ ${p.unidad}",
                      ),

                      const SizedBox(height: 6),

                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Importe: ${p.importe.toStringAsFixed(2)} €",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "TOTAL",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${presupuesto.total.toStringAsFixed(2)} €",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dato(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            titulo,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(valor),
        ],
      ),
    );
  }
}
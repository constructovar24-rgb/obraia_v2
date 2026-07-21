import 'package:flutter/material.dart';

import '../engines/pool_engine.dart';
import 'pool_result_screen.dart';

class PresupuestoScreen extends StatefulWidget {
  const PresupuestoScreen({super.key});

  @override
  State<PresupuestoScreen> createState() => _PresupuestoScreenState();
}

class _PresupuestoScreenState extends State<PresupuestoScreen> {
  final largoController = TextEditingController();
  final anchoController = TextEditingController();
  final profundidadController = TextEditingController();

  @override
  void dispose() {
    largoController.dispose();
    anchoController.dispose();
    profundidadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OBRA IA"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text(
              "Presupuesto de piscina",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),
            TextField(
              controller: largoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Largo (m)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: anchoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Ancho (m)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: profundidadController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Profundidad (m)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  final largo = double.tryParse(
                    largoController.text.replaceAll(',', '.'),
                  );

                  final ancho = double.tryParse(
                    anchoController.text.replaceAll(',', '.'),
                  );

                  final profundidad = double.tryParse(
                    profundidadController.text.replaceAll(',', '.'),
                  );

                  if (largo == null || largo <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Introduce un largo mayor que 0.',
                        ),
                      ),
                    );
                    return;
                  }

                  if (ancho == null || ancho <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Introduce un ancho mayor que 0.',
                        ),
                      ),
                    );
                    return;
                  }

                  if (profundidad == null || profundidad <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Introduce una profundidad mayor que 0.',
                        ),
                      ),
                    );
                    return;
                  }

                  final presupuesto = PoolEngine.calcular(
                    largo: largo,
                    ancho: ancho,
                    profundidad: profundidad,
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PoolResultScreen(
                        presupuesto: presupuesto,
                      ),
                    ),
                  );
                },
                child: const Text(
                  "Calcular presupuesto",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
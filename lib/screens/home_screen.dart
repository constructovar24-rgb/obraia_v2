import 'package:flutter/material.dart';
import 'presupuesto_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OBRA IA"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 10),

          const Text(
            "Bienvenido",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 25),

          ElevatedButton.icon(
            icon: const Icon(Icons.calculate),
            label: const Text("Presupuestos"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PresupuestoScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: 15),

          ElevatedButton.icon(
            icon: const Icon(Icons.people),
            label: const Text("Clientes"),
            onPressed: () {},
          ),

          const SizedBox(height: 15),

          ElevatedButton.icon(
            icon: const Icon(Icons.home_repair_service),
            label: const Text("Obras"),
            onPressed: () {},
          ),

          const SizedBox(height: 15),

          ElevatedButton.icon(
            icon: const Icon(Icons.attach_money),
            label: const Text("Base de precios"),
            onPressed: () {},
          ),

          const SizedBox(height: 15),

          ElevatedButton.icon(
            icon: const Icon(Icons.smart_toy),
            label: const Text("IA"),
            onPressed: () {},
          ),

          const SizedBox(height: 15),

          ElevatedButton.icon(
            icon: const Icon(Icons.settings),
            label: const Text("Configuración"),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

import 'presupuesto_menu_screen.dart';
import '../features/expedientes/presentation/screens/expedientes_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OBRA IA'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bienvenido',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '¿Qué quieres hacer hoy?',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: [
                  _HomeButton(
                    icon: Icons.folder_copy,
                    titulo: 'Expedientes',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ExpedientesScreen(),
                        ),
                      );
                    },
                  ),
                  _HomeButton(
                    icon: Icons.calculate,
                    titulo: 'Presupuestos',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PresupuestoMenuScreen(),
                        ),
                      );
                    },
                  ),
                  _HomeButton(
                    icon: Icons.people,
                    titulo: 'Contactos',
                    onTap: () {},
                  ),
                  _HomeButton(
                    icon: Icons.home_repair_service,
                    titulo: 'Obras',
                    onTap: () {},
                  ),
                  _HomeButton(
                    icon: Icons.attach_money,
                    titulo: 'Base de precios',
                    onTap: () {},
                  ),
                  _HomeButton(
                    icon: Icons.smart_toy,
                    titulo: 'IA',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeButton extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final VoidCallback onTap;

  const _HomeButton({
    required this.icon,
    required this.titulo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 42,
            ),
            const SizedBox(height: 15),
            Text(
              titulo,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
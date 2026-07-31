import 'package:flutter/material.dart';

import '../core/widgets/app_page_header.dart';
import 'presupuesto_screen.dart';

class PresupuestoMenuScreen extends StatelessWidget {
  const PresupuestoMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppPageHeader(title: 'Presupuestos'),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          children: [
            _MenuCard(
              icon: Icons.pool,
              titulo: 'Piscinas',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PresupuestoScreen(),
                  ),
                );
              },
            ),
            const _MenuCardDisabled(
              icon: Icons.view_agenda,
              titulo: 'Muros',
            ),
            const _MenuCardDisabled(
              icon: Icons.grid_view,
              titulo: 'Pavimentos',
            ),
            const _MenuCardDisabled(
              icon: Icons.format_paint,
              titulo: 'Pintura',
            ),
            const _MenuCardDisabled(
              icon: Icons.home_work,
              titulo: 'Reformas',
            ),
            const _MenuCardDisabled(
              icon: Icons.more_horiz,
              titulo: 'Próximamente',
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.titulo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 44),
            const SizedBox(height: 15),
            Text(
              titulo,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuCardDisabled extends StatelessWidget {
  final IconData icon;
  final String titulo;

  const _MenuCardDisabled({
    required this.icon,
    required this.titulo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 44,
            color: Colors.grey,
          ),
          const SizedBox(height: 15),
          Text(
            titulo,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Próximamente',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
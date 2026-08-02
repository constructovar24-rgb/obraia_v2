import 'package:flutter/material.dart';

import '../core/shortcuts/app_shortcuts.dart';
import '../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../features/facturas/presentation/screens/facturas_screen.dart';
import '../features/timeline/presentation/timeline_page.dart';
import 'presupuesto_menu_screen.dart';
import '../features/expedientes/presentation/screens/expedientes_screen.dart';
import '../features/clientes/presentation/screens/clientes_screen.dart';
import '../features/proveedores/presentation/screens/proveedores_screen.dart';
import '../features/search/presentation/screens/search_screen.dart';
import '../features/configuracion/presentation/screens/empresa_configuracion_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _abrirTimelineGlobal(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: Text('Notificaciones'),
          ),
          body: TimelinePage.global(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppShortcutScope(
      onBack: () => Navigator.maybePop(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('OBRA IA'),
          centerTitle: true,
          actions: [
            IconButton(
              tooltip: 'Notificaciones',
              icon: const Icon(Icons.notifications_none),
              onPressed: () => _abrirTimelineGlobal(context),
            ),
          ],
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
                      titulo: 'Clientes',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ClientesScreen(),
                          ),
                        );
                      },
                    ),
                    _HomeButton(
                      icon: Icons.local_shipping,
                      titulo: 'Proveedores',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ProveedoresScreen(),
                          ),
                        );
                      },
                    ),
                    _HomeButton(
                      icon: Icons.manage_search,
                      titulo: 'Búsqueda global',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SearchScreen(),
                          ),
                        );
                      },
                    ),
                    _HomeButton(
                      icon: Icons.receipt_long,
                      titulo: 'Facturas',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const FacturasScreen(),
                          ),
                        );
                      },
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
                      titulo: 'Dashboard',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DashboardScreen(),
                          ),
                        );
                      },
                    ),
                    _HomeButton(
                      icon: Icons.settings,
                      titulo: 'Configuración',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EmpresaConfiguracionScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
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
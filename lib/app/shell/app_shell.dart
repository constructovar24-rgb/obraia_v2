import 'package:flutter/material.dart';

import '../../core/ui/app_spacing.dart';
import '../../features/clientes/presentation/screens/clientes_screen.dart';
import '../../features/cobros/presentation/screens/cobros_screen.dart';
import '../../features/configuracion/presentation/screens/empresa_configuracion_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/expedientes/presentation/screens/expedientes_screen.dart';
import '../../features/facturas/presentation/screens/facturas_screen.dart';
import '../../features/presupuestos/presentation/screens/presupuestos_screen.dart';
import '../../features/proveedores/presentation/screens/proveedores_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/timeline/presentation/timeline_page.dart';
import 'app_section_id.dart';
import 'side_navigation.dart';

typedef AppShellPageBuilder = Widget Function(AppSectionId section);

class AppShell extends StatefulWidget {
  const AppShell({
    super.key,
    this.initialSection = AppSectionId.inicio,
    this.pageBuilder,
  });

  final AppSectionId initialSection;
  final AppShellPageBuilder? pageBuilder;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final _contentNavigatorKey = GlobalKey<NavigatorState>();
  late AppSectionId _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialSection;
  }

  void _select(AppSectionId section) {
    if (section == _selected) {
      _contentNavigatorKey.currentState?.popUntil((route) => route.isFirst);
      return;
    }
    setState(() => _selected = section);
    _contentNavigatorKey.currentState?.pushAndRemoveUntil(
      _pageRoute(section),
      (route) => false,
    );
  }

  MaterialPageRoute<void> _pageRoute(AppSectionId section) {
    return MaterialPageRoute<void>(
      settings: RouteSettings(name: '/${section.name}'),
      builder: (_) => widget.pageBuilder?.call(section) ?? _buildPage(section),
    );
  }

  void _openSearch() => _contentNavigatorKey.currentState?.push(
    MaterialPageRoute<void>(builder: (_) => const SearchScreen()),
  );

  void _openTimeline() => _contentNavigatorKey.currentState?.push(
    MaterialPageRoute<void>(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Actividad y notificaciones')),
        body: TimelinePage.global(),
      ),
    ),
  );

  Widget _buildPage(AppSectionId section) {
    switch (section) {
      case AppSectionId.inicio:
        return const DashboardScreen(embedded: true);
      case AppSectionId.expedientes:
        return const ExpedientesScreen(embedded: true);
      case AppSectionId.clientes:
        return const ClientesScreen();
      case AppSectionId.presupuestos:
        return const PresupuestosScreen();
      case AppSectionId.facturas:
        return const FacturasScreen();
      case AppSectionId.cobros:
        return CobrosScreen.delMesActual();
      case AppSectionId.proveedores:
        return const ProveedoresScreen();
      case AppSectionId.configuracion:
        return const EmpresaConfiguracionScreen();
      case AppSectionId.administracion:
        return Scaffold(
          appBar: AppBar(title: const Text('Centro administrativo')),
          body: TimelinePage.global(),
        );
      case AppSectionId.compras:
      case AppSectionId.certificaciones:
      case AppSectionId.documentos:
        return _ModuleAccessPage(section: section);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final expandedNavigation = constraints.maxWidth >= 1040;
        final compactHeader = constraints.maxWidth < 760;
        return Scaffold(
          body: Row(
            children: [
              SideNavigation(
                selected: _selected,
                expanded: expandedNavigation,
                onSelected: _select,
              ),
              Expanded(
                child: Column(
                  children: [
                    _ShellHeader(
                      section: _selected,
                      compact: compactHeader,
                      onSearch: _openSearch,
                      onNotifications: _openTimeline,
                      onSettings: () => _select(AppSectionId.configuracion),
                    ),
                    Expanded(
                      child: Navigator(
                        key: _contentNavigatorKey,
                        initialRoute: '/${_selected.name}',
                        onGenerateRoute: (_) => _pageRoute(_selected),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ShellHeader extends StatelessWidget {
  const _ShellHeader({
    required this.section,
    required this.compact,
    required this.onSearch,
    required this.onNotifications,
    required this.onSettings,
  });

  final AppSectionId section;
  final bool compact;
  final VoidCallback onSearch;
  final VoidCallback onNotifications;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: colors.surface,
      child: Container(
        key: const ValueKey('app-shell-header'),
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: colors.outlineVariant)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.label,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  if (!compact)
                    Text(
                      'OBRA IA  /  ${section.label}',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
            if (!compact)
              SizedBox(
                width: 300,
                child: OutlinedButton.icon(
                  key: const ValueKey('global-search'),
                  onPressed: onSearch,
                  icon: const Icon(Icons.search, size: 19),
                  label: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Buscar en OBRA IA'),
                  ),
                ),
              )
            else
              IconButton(
                key: const ValueKey('global-search'),
                tooltip: 'Búsqueda global',
                onPressed: onSearch,
                icon: const Icon(Icons.search),
              ),
            const SizedBox(width: AppSpacing.sm),
            IconButton(
              tooltip: 'Actividad y notificaciones',
              onPressed: onNotifications,
              icon: const Icon(Icons.notifications_none_outlined),
            ),
            IconButton(
              tooltip: 'Configuración',
              onPressed: onSettings,
              icon: const Icon(Icons.settings_outlined),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModuleAccessPage extends StatelessWidget {
  const _ModuleAccessPage({required this.section});

  final AppSectionId section;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(section.icon, size: 44, color: colors.primary),
              const SizedBox(height: AppSpacing.md),
              Text(
                section.label,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Este módulo se gestiona actualmente desde la ficha de cada expediente. La navegación global queda preparada sin inventar información ni ampliar su funcionalidad.',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: colors.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

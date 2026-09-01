import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/shortcuts/app_shortcuts.dart';
import '../../../../core/ui/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../domain/cliente.dart';
import '../providers/cliente_providers.dart';
import 'cliente_detail_screen.dart';
import 'nuevo_cliente_screen.dart';

class ClientesScreen extends ConsumerStatefulWidget {
  const ClientesScreen({super.key});
  @override
  ConsumerState<ClientesScreen> createState() => _ClientesScreenState();
}

class _ClientesScreenState extends ConsumerState<ClientesScreen> {
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();
  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _nuevo() => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const NuevoClienteScreen()),
  );
  void _abrir(Cliente cliente) => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => ClienteDetailScreen(cliente: cliente)),
  );

  @override
  Widget build(BuildContext context) {
    final clientesAsync = ref.watch(clientesProvider);
    return AppShortcutScope(
      onBack: () => Navigator.maybePop(context),
      onNew: _nuevo,
      onFind: _searchFocus.requestFocus,
      child: Scaffold(
        body: clientesAsync.when(
          loading: () => const AppLoading(message: 'Cargando clientes…'),
          error: (error, _) => AppErrorState(
            message: 'No se pudieron cargar los clientes.\n\n$error',
          ),
          data: (clientes) => _content(clientes),
        ),
      ),
    );
  }

  Widget _content(List<Cliente> clientes) => LayoutBuilder(
    builder: (context, constraints) {
      final compact = constraints.maxWidth < 720;
      final query = _searchController.text.trim().toLowerCase();
      final filtered = clientes
          .where(
            (c) => [
              c.nombre,
              c.apellidos,
              c.empresa,
              c.nif,
              c.telefono,
              c.email,
              c.poblacion,
            ].any((v) => v.toLowerCase().contains(query)),
          )
          .toList();
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Padding(
            padding: EdgeInsets.all(compact ? AppSpacing.md : AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppCard(
                  highlighted: true,
                  child: compact
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _heading(clientes.length),
                            const SizedBox(height: AppSpacing.md),
                            AppPrimaryButton(
                              label: 'Nuevo cliente',
                              icon: Icons.add,
                              onPressed: _nuevo,
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(child: _heading(clientes.length)),
                            AppPrimaryButton(
                              label: 'Nuevo cliente',
                              icon: Icons.add,
                              onPressed: _nuevo,
                              expand: false,
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  key: const ValueKey('clientes-search'),
                  controller: _searchController,
                  focusNode: _searchFocus,
                  decoration: const InputDecoration(
                    labelText: 'Buscar clientes',
                    hintText:
                        'Nombre, empresa, NIF, teléfono, email o población',
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: Icon(Icons.filter_list_outlined),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: AppSpacing.md),
                if (clientes.isEmpty)
                  Expanded(
                    child: AppEmptyState(
                      icon: Icons.people_outline,
                      title: 'Todavía no hay clientes',
                      subtitle:
                          'Crea el primer cliente para vincularlo a sus expedientes.',
                      actionLabel: 'Nuevo cliente',
                      onAction: _nuevo,
                    ),
                  )
                else if (filtered.isEmpty)
                  const Expanded(
                    child: AppEmptyState(
                      icon: Icons.search_off,
                      title: 'No hay coincidencias',
                      subtitle:
                          'Prueba con otro nombre, NIF o dato de contacto.',
                    ),
                  )
                else ...[
                  Text(
                    '${filtered.length} ${filtered.length == 1 ? 'cliente' : 'clientes'}',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Expanded(
                    child: AppCard(
                      padding: EdgeInsets.zero,
                      child: ListView.separated(
                        itemCount: filtered.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (_, index) =>
                            _row(filtered[index], compact),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    },
  );

  Widget _heading(int count) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Clientes', style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: AppSpacing.xs),
      Text(
        '$count registrados · consulta, contacto y relación con obras',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    ],
  );

  Widget _row(Cliente cliente, bool compact) {
    final name = '${cliente.nombre} ${cliente.apellidos}'.trim();
    final contact = cliente.email.isNotEmpty
        ? cliente.email
        : cliente.telefono.isNotEmpty
        ? cliente.telefono
        : 'Sin contacto';
    return InkWell(
      key: ValueKey('cliente-row-${cliente.id}'),
      onTap: () => _abrir(cliente),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            CircleAvatar(
              child: Text(
                name.isEmpty ? '?' : name.characters.first.toUpperCase(),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: Theme.of(context).textTheme.titleSmall),
                  Text(
                    cliente.empresa.isEmpty ? 'Particular' : cliente.empresa,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (!compact)
              Expanded(
                flex: 2,
                child: Text(cliente.nif.isEmpty ? 'Sin NIF/CIF' : cliente.nif),
              ),
            if (!compact)
              Expanded(
                flex: 3,
                child: Text(
                  contact,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

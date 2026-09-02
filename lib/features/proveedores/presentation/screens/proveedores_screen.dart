import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/shortcuts/app_shortcuts.dart';
import '../../../../core/ui/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/app_page_header.dart';
import '../../domain/proveedor.dart';
import '../providers/proveedor_providers.dart';
import 'nuevo_proveedor_screen.dart';
import 'proveedor_detail_screen.dart';

class ProveedoresScreen extends ConsumerStatefulWidget {
  const ProveedoresScreen({super.key});

  @override
  ConsumerState<ProveedoresScreen> createState() => _ProveedoresScreenState();
}

class _ProveedoresScreenState extends ConsumerState<ProveedoresScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _abrirNuevoProveedor() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NuevoProveedorScreen()),
    );
  }

  List<Proveedor> _filtrar(List<Proveedor> proveedores) {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return proveedores;
    return proveedores.where((proveedor) {
      return [
        proveedor.nombre,
        proveedor.nif,
        proveedor.personaContacto ?? '',
        proveedor.telefono,
        proveedor.email,
        proveedor.poblacion,
        proveedor.provincia,
      ].any((value) => value.toLowerCase().contains(query));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final proveedoresAsync = ref.watch(proveedoresProvider);
    return AppShortcutScope(
      onBack: () => Navigator.maybePop(context),
      onNew: _abrirNuevoProveedor,
      child: Scaffold(
        appBar: AppPageHeader(
          title: 'Proveedores',
          subtitle: 'Directorio fiscal y de contacto para aprovisionamiento',
          actions: [
            AppPageHeaderAction(
              icon: Icons.add,
              tooltip: 'Nuevo proveedor',
              onPressed: _abrirNuevoProveedor,
            ),
          ],
        ),
        body: proveedoresAsync.when(
          loading: () => const AppLoading(message: 'Cargando proveedores...'),
          error: (error, _) => AppErrorState(message: 'ERROR:\n\n$error'),
          data: (proveedores) {
            if (proveedores.isEmpty) {
              return AppEmptyState(
                icon: Icons.local_shipping_outlined,
                title: 'Todavía no hay proveedores',
                subtitle: 'Añade el primero para empezar a trabajar.',
                actionLabel: 'Nuevo proveedor',
                onAction: _abrirNuevoProveedor,
              );
            }
            final filtrados = _filtrar(proveedores);
            return Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  AppCard(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: TextField(
                      key: const Key('proveedores-search'),
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        labelText:
                            'Buscar por nombre, NIF/CIF, contacto o localidad',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${filtrados.length} de ${proveedores.length} proveedores',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Expanded(
                    child: filtrados.isEmpty
                        ? const AppEmptyState(
                            icon: Icons.search_off_outlined,
                            title: 'No hay coincidencias',
                            subtitle:
                                'Prueba con otro nombre, contacto o localidad.',
                          )
                        : AppCard(
                            padding: EdgeInsets.zero,
                            child: ListView.separated(
                              itemCount: filtrados.length,
                              separatorBuilder: (_, _) =>
                                  const Divider(height: 1),
                              itemBuilder: (context, index) =>
                                  _ProveedorRow(proveedor: filtrados[index]),
                            ),
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ProveedorRow extends StatelessWidget {
  const _ProveedorRow({required this.proveedor});

  final Proveedor proveedor;

  @override
  Widget build(BuildContext context) {
    final contacto = proveedor.personaContacto?.trim();
    final localidad = [
      proveedor.poblacion.trim(),
      proveedor.provincia.trim(),
    ].where((value) => value.isNotEmpty).join(', ');
    return InkWell(
      key: Key('proveedor-row-${proveedor.id}'),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProveedorDetailScreen(proveedor: proveedor),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + AppSpacing.xs,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final identity = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  proveedor.nombre,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  proveedor.nif.trim().isEmpty ? 'Sin NIF/CIF' : proveedor.nif,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            );
            final contact = Text(
              [
                    if (contacto?.isNotEmpty == true) contacto!,
                    if (proveedor.telefono.trim().isNotEmpty)
                      proveedor.telefono,
                    if (proveedor.email.trim().isNotEmpty) proveedor.email,
                  ].isEmpty
                  ? 'Sin datos de contacto'
                  : [
                      if (contacto?.isNotEmpty == true) contacto!,
                      if (proveedor.telefono.trim().isNotEmpty)
                        proveedor.telefono,
                      if (proveedor.email.trim().isNotEmpty) proveedor.email,
                    ].join(' · '),
              overflow: TextOverflow.ellipsis,
            );
            if (constraints.maxWidth < 720) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  identity,
                  const SizedBox(height: AppSpacing.sm),
                  contact,
                  if (localidad.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(localidad),
                  ],
                ],
              );
            }
            return Row(
              children: [
                Expanded(flex: 3, child: identity),
                Expanded(flex: 4, child: contact),
                Expanded(
                  flex: 2,
                  child: Text(localidad.isEmpty ? 'Sin localidad' : localidad),
                ),
                const SizedBox(width: AppSpacing.sm),
                const Icon(Icons.chevron_right),
              ],
            );
          },
        ),
      ),
    );
  }
}

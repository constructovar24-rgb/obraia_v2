import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/shortcuts/app_shortcuts.dart';
import '../../../../core/ui/app_spacing.dart';
import '../../../../core/ui/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_section.dart';
import '../../../../core/widgets/app_page_header.dart';
import '../providers/proveedor_providers.dart';
import 'nuevo_proveedor_screen.dart';

class ProveedoresScreen extends ConsumerWidget {
  const ProveedoresScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final proveedoresAsync = ref.watch(proveedoresProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = AppTypography.textTheme(colorScheme);

    void abrirNuevoProveedor() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const NuevoProveedorScreen(),
        ),
      );
    }

    return AppShortcutScope(
      onBack: () => Navigator.maybePop(context),
      onNew: abrirNuevoProveedor,
      child: Scaffold(
        appBar: AppPageHeader(
          title: 'Proveedores',
          showBackButton: true,
          onBackPressed: () => Navigator.maybePop(context),
        ),
        floatingActionButton: AppPrimaryButton(
          label: 'Nuevo proveedor',
          icon: Icons.add,
          onPressed: abrirNuevoProveedor,
          expand: false,
        ),
        body: proveedoresAsync.when(
          loading: () => const AppLoading(
            message: 'Cargando proveedores...',
          ),
          error: (error, _) => AppErrorState(
            message: 'ERROR:\n\n$error',
          ),
          data: (proveedores) {
            if (proveedores.isEmpty) {
              return AppEmptyState(
                icon: Icons.local_shipping_outlined,
                title: 'Todavía no hay proveedores',
                subtitle: 'Añade el primero para empezar a trabajar.',
                actionLabel: 'Nuevo proveedor',
                onAction: abrirNuevoProveedor,
              );
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 900;
                final horizontalPadding = isWide ? AppSpacing.xl : AppSpacing.md;

                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1180),
                    child: SizedBox(
                      height: constraints.maxHeight,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                              horizontalPadding,
                              AppSpacing.md,
                              horizontalPadding,
                              AppSpacing.sm,
                            ),
                            child: AppCard(
                              padding: const EdgeInsets.all(AppSpacing.xl),
                              highlighted: true,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 52,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      color: colorScheme.primaryContainer,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.local_shipping,
                                      color: colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Proveedores',
                                          style: textTheme.headlineMedium,
                                        ),
                                        const SizedBox(height: AppSpacing.xs),
                                        Text(
                                          'Consulta y abre cada ficha de proveedor desde una vista más clara y ordenada.',
                                          style: textTheme.bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  AppPrimaryButton(
                                    label: 'Nuevo proveedor',
                                    icon: Icons.add,
                                    onPressed: abrirNuevoProveedor,
                                    expand: false,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                horizontalPadding,
                                AppSpacing.sm,
                                horizontalPadding,
                                AppSpacing.lg,
                              ),
                              child: AppSection(
                                title: 'Listado de proveedores',
                                subtitle:
                                    'Selecciona un proveedor para ver su detalle.',
                                actionLabel: 'Nuevo proveedor',
                                onAction: abrirNuevoProveedor,
                                child: ListView.separated(
                                  itemCount: proveedores.length,
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: AppSpacing.sm),
                                  itemBuilder: (context, index) {
                                    final proveedor = proveedores[index];
                                    final subtitleParts = <String>[
                                      if (proveedor.personaContacto
                                              ?.trim()
                                              .isNotEmpty ??
                                          false)
                                        proveedor.personaContacto!.trim(),
                                      if (proveedor.telefono.trim().isNotEmpty)
                                        proveedor.telefono.trim(),
                                    ];

                                    return AppCard(
                                      child: ListTile(
                                        contentPadding: const EdgeInsets.all(
                                          AppSpacing.md,
                                        ),
                                        leading: CircleAvatar(
                                          backgroundColor:
                                              colorScheme.primaryContainer,
                                          foregroundColor:
                                              colorScheme.onPrimaryContainer,
                                          child: const Icon(Icons.person),
                                        ),
                                        title: Text(
                                          proveedor.nombre,
                                          style: textTheme.titleMedium,
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.only(
                                            top: AppSpacing.xs,
                                          ),
                                          child: Text(
                                            subtitleParts.isEmpty
                                                ? 'Sin datos de contacto'
                                                : subtitleParts.join(' · '),
                                            style: textTheme.bodyMedium,
                                          ),
                                        ),
                                        trailing: const Icon(
                                          Icons.chevron_right,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

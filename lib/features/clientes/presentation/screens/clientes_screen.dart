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
import '../../../../core/widgets/app_page_header.dart';
import '../../../../database/database_provider.dart';
import '../../data/cliente_repository.dart';
import 'cliente_detail_screen.dart';
import 'nuevo_cliente_screen.dart';

class ClientesScreen extends ConsumerWidget {
  const ClientesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.read(databaseProvider);
    final repository = ClienteRepository(db);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = AppTypography.textTheme(colorScheme);

    void abrirNuevoCliente() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const NuevoClienteScreen(),
        ),
      );
    }

    return AppShortcutScope(
      onBack: () {
        Navigator.maybePop(context);
      },
      onNew: abrirNuevoCliente,
      child: Scaffold(
        appBar: const AppPageHeader(title: 'Clientes'),
        body: StreamBuilder(
          stream: repository.observarClientes(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return AppErrorState(
                message: 'ERROR:\n\n${snapshot.error}',
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const AppLoading(
                message: 'Cargando clientes...',
              );
            }

            final clientes = snapshot.data ?? [];

            if (clientes.isEmpty) {
              return AppEmptyState(
                icon: Icons.people_outline,
                title: 'Todavía no hay clientes',
                subtitle: 'Añade el primero para empezar a trabajar.',
                actionLabel: 'Nuevo cliente',
                onAction: abrirNuevoCliente,
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
                                      Icons.people,
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
                                          'Clientes',
                                          style: textTheme.headlineMedium,
                                        ),
                                        const SizedBox(height: AppSpacing.xs),
                                        Text(
                                          'Consulta y abre cada ficha de cliente con una vista más limpia y ordenada.',
                                          style: textTheme.bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  AppPrimaryButton(
                                    label: 'Nuevo cliente',
                                    icon: Icons.add,
                                    onPressed: abrirNuevoCliente,
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
                              child: ListView.separated(
                                itemCount: clientes.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: AppSpacing.sm),
                                itemBuilder: (context, index) {
                                  final cliente = clientes[index];

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
                                        '${cliente.nombre} ${cliente.apellidos}'.trim(),
                                        style: textTheme.titleMedium,
                                      ),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.only(
                                          top: AppSpacing.xs,
                                        ),
                                        child: Text(
                                          cliente.email.isNotEmpty
                                              ? cliente.email
                                              : cliente.telefono.isNotEmpty
                                                  ? cliente.telefono
                                                  : 'Sin datos',
                                          style: textTheme.bodyMedium,
                                        ),
                                      ),
                                      trailing: const Icon(Icons.chevron_right),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => ClienteDetailScreen(
                                              cliente: cliente,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
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

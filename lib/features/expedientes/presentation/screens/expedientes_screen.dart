import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/shortcuts/app_shortcuts.dart';
import '../../../../core/widgets/app_page_header.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/ui/app_spacing.dart';
import '../../../../core/ui/app_typography.dart';
import '../../../../database/database_provider.dart';
import '../../domain/expediente.dart' as expediente_domain;
import '../../data/expediente_repository.dart';
import 'expediente_detail_screen.dart';
import 'nuevo_expediente_screen.dart';

class ExpedientesScreen extends ConsumerStatefulWidget {
  const ExpedientesScreen({super.key});

  @override
  ConsumerState<ExpedientesScreen> createState() => _ExpedientesScreenState();
}

class _ExpedientesScreenState extends ConsumerState<ExpedientesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  late final ExpedienteRepository _repository;
  late final Stream<List<expediente_domain.Expediente>> _expedientesStream;

  @override
  void initState() {
    super.initState();
    debugPrint('******** INIT EXPEDIENTES ********');
    _repository = ExpedienteRepository(ref.read(databaseProvider));
    _expedientesStream = _repository.observarExpedientes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _abrirNuevoExpediente() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const NuevoExpedienteScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('******** BUILD EXPEDIENTES ********');
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = AppTypography.textTheme(colorScheme);

    return AppShortcutScope(
      onBack: () {
        Navigator.maybePop(context);
      },
      onFind: () {
        _searchFocusNode.requestFocus();
      },
      onNew: _abrirNuevoExpediente,
      child: Scaffold(
        appBar: const AppPageHeader(
          title: 'Expedientes',
          showBackButton: true,
        ),
        body: StreamBuilder(
          stream: _expedientesStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return AppErrorState(
                message: 'ERROR:\n\n${snapshot.error}',
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const AppLoading(
                message: 'Cargando expedientes...',
              );
            }

            final expedientes = snapshot.data ?? [];
            final query = _searchController.text.trim().toLowerCase();
            final expedientesFiltrados = query.isEmpty
                ? expedientes
                : expedientes.where((expediente) {
                    final codigo = expediente.codigo.toLowerCase();
                    final nombre = expediente.nombre.toLowerCase();
                    final cliente = (expediente.clienteNombre ?? '').toLowerCase();

                    return codigo.contains(query) ||
                        nombre.contains(query) ||
                        cliente.contains(query);
                  }).toList();

            return LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 900;
                final horizontalPadding = isWide ? AppSpacing.xl : AppSpacing.md;
                final content = Column(
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
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
                                    Icons.folder_copy_outlined,
                                    color: colorScheme.onPrimaryContainer,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Expedientes',
                                        style: textTheme.headlineMedium,
                                      ),
                                      const SizedBox(height: AppSpacing.xs),
                                      Text(
                                        'Consulta, filtra y accede a cada expediente desde una vista más clara.',
                                        style: textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            if (isWide)
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      focusNode: _searchFocusNode,
                                      controller: _searchController,
                                      decoration: const InputDecoration(
                                        labelText: 'Buscar expedientes',
                                        prefixIcon: Icon(Icons.search),
                                        border: OutlineInputBorder(),
                                      ),
                                      onChanged: (_) => setState(() {}),
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  AppPrimaryButton(
                                    label: 'Nuevo expediente',
                                    icon: Icons.add,
                                    onPressed: _abrirNuevoExpediente,
                                    expand: false,
                                  ),
                                ],
                              )
                            else ...[
                              TextField(
                                focusNode: _searchFocusNode,
                                controller: _searchController,
                                decoration: const InputDecoration(
                                  labelText: 'Buscar expedientes',
                                  prefixIcon: Icon(Icons.search),
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (_) => setState(() {}),
                              ),
                              const SizedBox(height: AppSpacing.md),
                              AppPrimaryButton(
                                label: 'Nuevo expediente',
                                icon: Icons.add,
                                onPressed: _abrirNuevoExpediente,
                              ),
                            ],
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
                        child: expedientesFiltrados.isEmpty
                            ? query.isEmpty
                                ? AppEmptyState(
                                    icon: Icons.folder_outlined,
                                    title: 'Todavía no hay expedientes',
                                    message:
                                        'Crea el primero para empezar a trabajar.',
                                    actionLabel: 'Nuevo expediente',
                                    onAction: _abrirNuevoExpediente,
                                  )
                                : AppEmptyState(
                                    icon: Icons.search_off,
                                    title:
                                        'No hay expedientes que coincidan',
                                    message:
                                        'Prueba con otro código, nombre o cliente.',
                                  )
                            : ListView.separated(
                                itemCount: expedientesFiltrados.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: AppSpacing.sm),
                                itemBuilder: (context, index) {
                                  final expediente = expedientesFiltrados[index];

                                  return AppCard(
                                    padding: EdgeInsets.zero,
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.all(
                                        AppSpacing.md,
                                      ),
                                      leading: CircleAvatar(
                                        backgroundColor:
                                            colorScheme.primaryContainer,
                                        foregroundColor:
                                            colorScheme.onPrimaryContainer,
                                        child: const Icon(Icons.folder),
                                      ),
                                      title: Text(
                                        expediente.nombre,
                                        style: textTheme.titleMedium,
                                      ),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.only(
                                          top: AppSpacing.xs,
                                        ),
                                        child: Text(
                                          expediente.clienteNombre?.isNotEmpty ==
                                                  true
                                              ? '${expediente.codigo} · ${expediente.clienteNombre}'
                                              : expediente.codigo,
                                          style: textTheme.bodyMedium,
                                        ),
                                      ),
                                      trailing: const Icon(
                                        Icons.chevron_right,
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                ExpedienteDetailScreen(
                                              id: expediente.id,
                                              codigo: expediente.codigo,
                                              nombre: expediente.nombre,
                                              clienteNombre:
                                                  expediente.clienteNombre,
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
                );

                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1180),
                    child: content,
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
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/shortcuts/app_shortcuts.dart';
import '../../../../core/ui/app_spacing.dart';
import '../../../../core/ui/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/app_page_header.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../database/database_provider.dart';
import '../../data/expediente_repository.dart';
import '../../domain/expediente.dart' as expediente_domain;
import 'expediente_detail_screen.dart';
import 'nuevo_expediente_screen.dart';

part 'expedientes_archivados_screen.dart';

enum ExpedientesInitialFilterType { todos, sinActividad }

class ExpedientesInitialFilter {
  const ExpedientesInitialFilter._(this.type);

  const ExpedientesInitialFilter.todos()
    : this._(ExpedientesInitialFilterType.todos);

  const ExpedientesInitialFilter.sinActividad()
    : this._(ExpedientesInitialFilterType.sinActividad);

  final ExpedientesInitialFilterType type;
}

class ExpedientesScreen extends ConsumerStatefulWidget {
  const ExpedientesScreen({
    super.key,
    this.mostrarArchivados = false,
    this.initialFilter = const ExpedientesInitialFilter.todos(),
  });

  final bool mostrarArchivados;
  final ExpedientesInitialFilter initialFilter;

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
    if (widget.mostrarArchivados) {
      _expedientesStream = _repository.observarExpedientesArchivados();
      return;
    }

    switch (widget.initialFilter.type) {
      case ExpedientesInitialFilterType.todos:
        _expedientesStream = _repository.observarExpedientes();
        break;
      case ExpedientesInitialFilterType.sinActividad:
        _expedientesStream = _repository.observarSinActividad();
        break;
    }
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

  void _abrirExpedientesArchivados() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ExpedientesArchivadosScreen(),
      ),
    );
  }

  Future<void> _restaurarExpediente(String expedienteId) async {
    final confirmado = await ConfirmDialog.show(
      context,
      title: 'Restaurar expediente',
      message:
          'El expediente volverá a estado activo y aparecerá en la vista principal.',
      confirmLabel: 'Restaurar',
    );

    if (!confirmado || !mounted) {
      return;
    }

    await _repository.restaurarExpediente(expedienteId);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('******** BUILD EXPEDIENTES ********');
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = AppTypography.textTheme(colorScheme);
    final esArchivados = widget.mostrarArchivados;
    final esSinActividad =
        !esArchivados &&
        widget.initialFilter.type ==
            ExpedientesInitialFilterType.sinActividad;

    return AppShortcutScope(
      onBack: () => Navigator.maybePop(context),
      onFind: () {
        _searchFocusNode.requestFocus();
      },
      onNew: esArchivados ? null : _abrirNuevoExpediente,
      child: Scaffold(
        appBar: AppPageHeader(
          title: esArchivados
              ? 'Expedientes archivados'
              : esSinActividad
              ? 'Expedientes sin actividad'
              : 'Expedientes',
          showBackButton: true,
          actions: esArchivados
              ? const []
              : [
                  AppPageHeaderAction(
                    icon: Icons.archive_outlined,
                    tooltip: 'Ver archivados',
                    onPressed: _abrirExpedientesArchivados,
                  ),
                ],
        ),
        body: StreamBuilder<List<expediente_domain.Expediente>>(
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

                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1180),
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
                                        esArchivados
                                            ? Icons.archive_outlined
                                            : Icons.folder_copy_outlined,
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
                                            esArchivados
                                                ? 'Expedientes archivados'
                                                : esSinActividad
                                                ? 'Expedientes sin actividad'
                                                : 'Expedientes',
                                            style: textTheme.headlineMedium,
                                          ),
                                          const SizedBox(height: AppSpacing.xs),
                                          Text(
                                            esArchivados
                                                ? 'Consulta y restaura los expedientes archivados desde una vista independiente.'
                                                : esSinActividad
                                                ? 'Expedientes sin eventos en los últimos 60 días.'
                                                : 'Consulta, filtra y accede a cada expediente desde una vista más clara.',
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
                                      if (!esArchivados)
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
                                  if (!esArchivados) ...[
                                    const SizedBox(height: AppSpacing.md),
                                    AppPrimaryButton(
                                      label: 'Nuevo expediente',
                                      icon: Icons.add,
                                      onPressed: _abrirNuevoExpediente,
                                    ),
                                  ],
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
                                        icon: esArchivados
                                            ? Icons.archive_outlined
                                            : Icons.folder_outlined,
                                        title: esArchivados
                                            ? 'Todavía no hay expedientes archivados'
                                            : esSinActividad
                                            ? 'No hay expedientes sin actividad'
                                            : 'Todavía no hay expedientes',
                                        message: esArchivados
                                            ? 'Los expedientes archivados aparecerán aquí para poder revisarlos o restaurarlos.'
                                            : esSinActividad
                                            ? 'Todos los expedientes activos tienen eventos en los últimos 60 días.'
                                            : 'Crea el primero para empezar a trabajar.',
                                        actionLabel: esArchivados || esSinActividad
                                            ? null
                                            : 'Nuevo expediente',
                                        onAction: esArchivados || esSinActividad
                                            ? null
                                            : _abrirNuevoExpediente,
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
                                      final expediente =
                                          expedientesFiltrados[index];

                                      return AppCard(
                                        padding: EdgeInsets.zero,
                                        child: ListTile(
                                          contentPadding:
                                              const EdgeInsets.all(
                                            AppSpacing.md,
                                          ),
                                          leading: CircleAvatar(
                                            backgroundColor:
                                                colorScheme.primaryContainer,
                                            foregroundColor:
                                                colorScheme.onPrimaryContainer,
                                            child: Icon(
                                              esArchivados
                                                  ? Icons.archive_outlined
                                                  : Icons.folder,
                                            ),
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
                                              expediente.clienteNombre
                                                          ?.isNotEmpty ==
                                                      true
                                                  ? '${expediente.codigo} · ${expediente.clienteNombre}'
                                                  : expediente.codigo,
                                              style: textTheme.bodyMedium,
                                            ),
                                          ),
                                          trailing: esArchivados
                                              ? Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    IconButton(
                                                      tooltip:
                                                          'Restaurar expediente',
                                                      icon: const Icon(
                                                        Icons.unarchive_outlined,
                                                      ),
                                                      onPressed: () {
                                                        _restaurarExpediente(
                                                          expediente.id,
                                                        );
                                                      },
                                                    ),
                                                    const Icon(
                                                      Icons.chevron_right,
                                                    ),
                                                  ],
                                                )
                                              : const Icon(
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
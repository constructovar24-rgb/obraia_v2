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
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../core/widgets/entity_summary_card.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../data/expediente_repository.dart';
import '../../domain/expediente.dart' as expediente_domain;
import '../../../certificaciones/domain/certificacion.dart';
import '../../../certificaciones/presentation/providers/certificacion_providers.dart';
import '../../../certificaciones/presentation/screens/nueva_certificacion_screen.dart';
import '../../../certificaciones/presentation/screens/editar_certificacion_screen.dart';
import '../../../documentos/domain/documento.dart';
import '../../../documentos/presentation/providers/documento_providers.dart';
import '../../../documentos/presentation/screens/editar_documento_screen.dart';
import '../../../documentos/presentation/screens/nuevo_documento_screen.dart';
import '../../../facturas/presentation/widgets/facturas_tab.dart';
import '../../../compras/presentation/widgets/compras_tab.dart';
import '../../../timeline/presentation/timeline_page.dart';
import 'cliente_tab.dart';
import 'datos_generales_screen.dart';
import 'editar_expediente_screen.dart';
import '../../../presupuestos/presentation/widgets/presupuestos_tab.dart';
import '../widgets/expediente_workspace_tabs.dart';

class ExpedienteDetailScreen extends ConsumerWidget {
  const ExpedienteDetailScreen({
    super.key,
    required this.id,
    required this.codigo,
    required this.nombre,
    this.clienteNombre,
  });

  final String id;
  final String codigo;
  final String nombre;
  final String? clienteNombre;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expedienteAsync = ref.watch(expedienteProvider(id));
    final expediente = expedienteAsync.value;
    final codigoActual = expediente?.codigo ?? codigo;
    final nombreActual = expediente?.nombre ?? nombre;
    final clienteActual = expediente?.clienteNombre ?? clienteNombre;
    final hasCliente = clienteActual != null && clienteActual.isNotEmpty;
    final atencionEstadoAsync = ref.watch(expedienteAtencionEstadoProvider(id));
    final accionGestionAsync = ref.watch(expedienteGestionAccionProvider(id));

    List<AppPageHeaderAction> construirAcciones() {
      final acciones = <AppPageHeaderAction>[
        if (expediente != null)
          AppPageHeaderAction(
            icon: Icons.edit_outlined,
            tooltip: 'Editar expediente',
            semanticLabel: 'Editar expediente',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      EditarExpedienteScreen(expediente: expediente),
                ),
              );
            },
          ),
      ];

      final accion = accionGestionAsync.value;
      if (accion != null) {
        final tituloAccion = _tituloAccion(accion);
        acciones.add(
          AppPageHeaderAction(
            icon: _iconoAccion(accion),
            tooltip: tituloAccion,
            semanticLabel: tituloAccion,
            onPressed: () {
              _confirmarYGestionarExpediente(
                context: context,
                ref: ref,
                accion: accion,
              );
            },
          ),
        );
      }

      return acciones;
    }

    return DefaultTabController(
      length: ExpedienteWorkspaceTabs.length,
      child: AppShortcutScope(
        onBack: () => Navigator.maybePop(context),
        child: Scaffold(
          appBar: AppPageHeader(
            showBackButton: true,
            title: 'Expediente',
            actions: construirAcciones(),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(hasCliente ? 196 : 172),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                    child: EntitySummaryCard(
                      title: codigoActual,
                      subtitle: nombreActual,
                      details: hasCliente
                          ? [
                              Text(
                                'Cliente: $clienteActual',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ]
                          : null,
                      statusWidget: StatusChip(
                        label: _labelEstadoCiclo(expediente?.estadoCiclo),
                        type: _tipoEstadoCiclo(expediente?.estadoCiclo),
                      ),
                    ),
                  ),
                  const ExpedienteWorkspaceTabs(),
                ],
              ),
            ),
          ),
          body: Column(
            children: [
              _ExpedienteAtencionPanel(estadoAsync: atencionEstadoAsync),
              Expanded(
                child: TabBarView(
                  children: [
                    PresupuestosTab(expedienteId: id),
                    ComprasTab(expedienteId: id),
                    _CertificacionesTab(expedienteId: id),
                    FacturasTab(expedienteId: id),
                    _DocumentosTab(expedienteId: id),
                    TimelinePage(expedienteId: id),
                    ClienteTab(expedienteId: id),
                    DatosGeneralesTab(id: id, codigoExpediente: codigoActual),
                    // const Center(child: Text('En desarrollo')), // Contenido de Notas (oculto temporalmente).
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _labelEstadoCiclo(expediente_domain.ExpedienteEstadoCiclo? estado) {
    switch (estado) {
      case expediente_domain.ExpedienteEstadoCiclo.activo:
        return 'Activo';
      case expediente_domain.ExpedienteEstadoCiclo.archivado:
        return 'Archivado';
      case null:
        return 'Sin estado';
    }
  }

  StatusType _tipoEstadoCiclo(expediente_domain.ExpedienteEstadoCiclo? estado) {
    switch (estado) {
      case expediente_domain.ExpedienteEstadoCiclo.activo:
        return StatusType.success;
      case expediente_domain.ExpedienteEstadoCiclo.archivado:
        return StatusType.neutral;
      case null:
        return StatusType.neutral;
    }
  }

  IconData _iconoAccion(ExpedienteGestionAccion accion) {
    switch (accion) {
      case ExpedienteGestionAccion.eliminar:
        return Icons.delete_outline;
      case ExpedienteGestionAccion.archivar:
        return Icons.archive_outlined;
    }
  }

  String _tituloAccion(ExpedienteGestionAccion accion) {
    switch (accion) {
      case ExpedienteGestionAccion.eliminar:
        return 'Eliminar expediente';
      case ExpedienteGestionAccion.archivar:
        return 'Archivar expediente';
    }
  }

  Future<void> _confirmarYGestionarExpediente({
    required BuildContext context,
    required WidgetRef ref,
    required ExpedienteGestionAccion accion,
  }) async {
    final tituloAccion = _tituloAccion(accion);
    final confirmado = await ConfirmDialog.show(
      context,
      title: tituloAccion,
      message: accion == ExpedienteGestionAccion.eliminar
          ? 'Se eliminará este expediente. Esta acción no se puede deshacer.'
          : 'Se archivará este expediente. Podrás recuperarlo más adelante.',
      confirmLabel: tituloAccion,
    );

    if (!confirmado) {
      return;
    }

    await ref
        .read(expedienteRepositoryProvider)
        .gestionarExpediente(id, accion);

    if (!context.mounted) {
      return;
    }

    Navigator.maybePop(context);
  }
}

class _ExpedienteAtencionPanel extends StatelessWidget {
  const _ExpedienteAtencionPanel({required this.estadoAsync});

  final AsyncValue<expediente_domain.ExpedienteAtencionEstado> estadoAsync;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: estadoAsync.when(
        loading: () =>
            const SizedBox(height: 4, child: LinearProgressIndicator()),
        error: (error, stackTrace) =>
            AppCard(child: Text('No se pudo cargar el panel de atencion.')),
        data: (estado) {
          final theme = Theme.of(context);
          final colorScheme = theme.colorScheme;

          final (icono, color) = switch (estado.nivel) {
            expediente_domain.ExpedienteAtencionNivel.correcto => (
              Icons.check_circle_outline,
              colorScheme.primary,
            ),
            expediente_domain.ExpedienteAtencionNivel.aviso => (
              Icons.warning_amber_outlined,
              colorScheme.tertiary,
            ),
            expediente_domain.ExpedienteAtencionNivel.critico => (
              Icons.error_outline,
              colorScheme.error,
            ),
          };

          return AppCard(
            highlighted: estado.requiereAtencion,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icono, color: color),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        estado.mensajePrincipal,
                        style: theme.textTheme.titleMedium,
                      ),
                      if (estado.detalle != null && estado.detalle!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.xs),
                          child: Text(
                            'Revisar: ${estado.detalle}',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CertificacionesTab extends ConsumerWidget {
  const _CertificacionesTab({required this.expedienteId});

  final String expedienteId;

  String _formatearFecha(DateTime fecha) {
    final day = fecha.day.toString().padLeft(2, '0');
    final month = fecha.month.toString().padLeft(2, '0');
    final year = fecha.year.toString();
    return '$day/$month/$year';
  }

  String _formatearEstado(CertificacionEstado estado) {
    switch (estado) {
      case CertificacionEstado.borrador:
        return 'Borrador';
      case CertificacionEstado.emitida:
        return 'Emitida';
      case CertificacionEstado.facturada:
        return 'Facturada';
    }
  }

  String _formatearImporte(double importe) {
    return '${importe.toStringAsFixed(2)} €';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = AppTypography.textTheme(colorScheme);
    final certificacionesAsync = ref.watch(
      certificacionesPorExpedienteProvider(expedienteId),
    );

    void abrirNuevaCertificacion() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => NuevaCertificacionScreen(expedienteId: expedienteId),
        ),
      );
    }

    return certificacionesAsync.when(
      loading: () => const AppLoading(message: 'Cargando certificaciones...'),
      error: (error, stackTrace) => AppErrorState(message: 'ERROR:\n\n$error'),
      data: (certificaciones) {
        if (certificaciones.isEmpty) {
          return AppEmptyState(
            icon: Icons.assignment_turned_in_outlined,
            title: 'Todavía no hay certificaciones',
            subtitle:
                'Crea la primera certificación para empezar a gestionar avances del expediente.',
            actionLabel: 'Nueva certificación',
            onAction: abrirNuevaCertificacion,
          );
        }

        return Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              AppCard(
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
                        Icons.assignment_turned_in_outlined,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Certificaciones',
                            style: textTheme.headlineMedium,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Consulta y edita cada certificación asociada al expediente.',
                            style: textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    AppPrimaryButton(
                      label: 'Nueva certificación',
                      icon: Icons.add,
                      onPressed: abrirNuevaCertificacion,
                      expand: false,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: ListView.separated(
                  itemCount: certificaciones.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final certificacion = certificaciones[index];

                    return AppCard(
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(AppSpacing.md),
                        leading: CircleAvatar(
                          backgroundColor: colorScheme.primaryContainer,
                          foregroundColor: colorScheme.onPrimaryContainer,
                          child: const Icon(
                            Icons.assignment_turned_in_outlined,
                          ),
                        ),
                        title: Text(
                          certificacion.codigo,
                          style: textTheme.titleMedium,
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.xs),
                          child: Text(
                            'Estado: ${_formatearEstado(certificacion.estado)}\n'
                            'Importe: ${_formatearImporte(certificacion.importeTotal)}\n'
                            'Fecha: ${_formatearFecha(certificacion.fecha)}',
                            style: textTheme.bodyMedium,
                          ),
                        ),
                        isThreeLine: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditarCertificacionScreen(
                                certificacion: certificacion,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DocumentosTab extends ConsumerWidget {
  const _DocumentosTab({required this.expedienteId});

  final String expedienteId;

  String _formatearFecha(DateTime fecha) {
    final day = fecha.day.toString().padLeft(2, '0');
    final month = fecha.month.toString().padLeft(2, '0');
    final year = fecha.year.toString();
    return '$day/$month/$year';
  }

  String _formatearTipo(DocumentoTipo tipo) {
    switch (tipo) {
      case DocumentoTipo.contrato:
        return 'Contrato';
      case DocumentoTipo.licencia:
        return 'Licencia';
      case DocumentoTipo.plano:
        return 'Plano';
      case DocumentoTipo.fotografia:
        return 'Fotografía';
      case DocumentoTipo.factura:
        return 'Factura';
      case DocumentoTipo.presupuesto:
        return 'Presupuesto';
      case DocumentoTipo.otro:
        return 'Otro';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = AppTypography.textTheme(colorScheme);
    final documentosAsync = ref.watch(
      documentosPorExpedienteProvider(expedienteId),
    );

    void abrirNuevoDocumento() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => NuevoDocumentoScreen(expedienteId: expedienteId),
        ),
      );
    }

    return documentosAsync.when(
      loading: () => const AppLoading(message: 'Cargando documentos...'),
      error: (error, stackTrace) => AppErrorState(message: 'ERROR:\n\n$error'),
      data: (documentos) {
        if (documentos.isEmpty) {
          return AppEmptyState(
            icon: Icons.insert_drive_file_outlined,
            title: 'Todavía no hay documentos',
            subtitle:
                'Añade el primer documento para tenerlo disponible en el expediente.',
            actionLabel: 'Nuevo documento',
            onAction: abrirNuevoDocumento,
          );
        }

        return Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              AppCard(
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
                        Icons.insert_drive_file_outlined,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Documentos', style: textTheme.headlineMedium),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Consulta y edita cada documento asociado al expediente.',
                            style: textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    AppPrimaryButton(
                      label: 'Nuevo documento',
                      icon: Icons.add,
                      onPressed: abrirNuevoDocumento,
                      expand: false,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: ListView.separated(
                  itemCount: documentos.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final documento = documentos[index];

                    return AppCard(
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(AppSpacing.md),
                        leading: CircleAvatar(
                          backgroundColor: colorScheme.primaryContainer,
                          foregroundColor: colorScheme.onPrimaryContainer,
                          child: const Icon(Icons.insert_drive_file_outlined),
                        ),
                        title: Text(
                          documento.titulo,
                          style: textTheme.titleMedium,
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.xs),
                          child: Text(
                            'Tipo: ${_formatearTipo(documento.tipo)}\n'
                            'Archivo: ${documento.nombreArchivo}\n'
                            'Fecha: ${_formatearFecha(documento.fecha)}',
                            style: textTheme.bodyMedium,
                          ),
                        ),
                        isThreeLine: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  EditarDocumentoScreen(documento: documento),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/shortcuts/app_shortcuts.dart';
import '../../../../core/ui/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/app_page_header.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../expedientes/domain/expediente.dart';
import '../../../expedientes/presentation/screens/expediente_detail_screen.dart';
import '../../../expedientes/presentation/screens/nuevo_expediente_screen.dart';
import '../../domain/cliente.dart';
import '../providers/cliente_providers.dart';
import 'editar_cliente_screen.dart';

class ClienteDetailScreen extends ConsumerWidget {
  const ClienteDetailScreen({super.key, required this.cliente});
  final Cliente cliente;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clienteAsync = ref.watch(clienteProvider(cliente.id));
    final expedientesAsync = ref.watch(expedientesClienteProvider(cliente.id));
    return AppShortcutScope(
      onBack: () => Navigator.maybePop(context),
      child: Scaffold(
        appBar: AppPageHeader(
          title: 'Ficha de cliente',
          subtitle: 'Resumen, contacto y expedientes relacionados',
          showBackButton: true,
          actions: [
            AppPageHeaderAction(
              icon: Icons.edit_outlined,
              tooltip: 'Editar cliente',
              onPressed: () {
                final current = clienteAsync.value ?? cliente;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditarClienteScreen(cliente: current),
                  ),
                );
              },
            ),
            AppPageHeaderAction(
              icon: Icons.delete_outline,
              tooltip: 'Eliminar cliente',
              onPressed: () =>
                  _eliminar(context, ref, expedientesAsync.value ?? const []),
            ),
          ],
        ),
        body: clienteAsync.when(
          loading: () => _body(context, cliente, expedientesAsync),
          error: (error, _) =>
              AppErrorState(message: 'No se pudo cargar el cliente.\n\n$error'),
          data: (current) => current == null
              ? const AppEmptyState(
                  icon: Icons.person_off_outlined,
                  title: 'Cliente no disponible',
                  subtitle:
                      'El cliente se ha eliminado o ya no está disponible.',
                )
              : _body(context, current, expedientesAsync),
        ),
      ),
    );
  }

  Widget _body(
    BuildContext context,
    Cliente current,
    AsyncValue<List<Expediente>> expedientesAsync,
  ) => LayoutBuilder(
    builder: (context, constraints) {
      final wide = constraints.maxWidth >= 940;
      final main = Column(
        children: [
          _summary(context, current),
          const SizedBox(height: AppSpacing.md),
          _Section(title: 'Datos y contacto', child: _contact(current)),
        ],
      );
      final related = _Section(
        title: 'Expedientes y obras',
        action: AppPrimaryButton(
          label: 'Nuevo expediente',
          icon: Icons.add,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NuevoExpedienteScreen(clienteInicial: current),
            ),
          ),
          expand: false,
        ),
        child: expedientesAsync.when(
          loading: () => const AppLoading(message: 'Cargando expedientes…'),
          error: (error, _) =>
              Text('No se pudieron cargar los expedientes: $error'),
          data: (items) => _expedientes(context, items),
        ),
      );
      return SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1180),
            child: wide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 4, child: main),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(flex: 5, child: related),
                    ],
                  )
                : Column(
                    children: [
                      main,
                      const SizedBox(height: AppSpacing.md),
                      related,
                    ],
                  ),
          ),
        ),
      );
    },
  );

  Widget _summary(BuildContext context, Cliente c) => AppCard(
    highlighted: true,
    child: Row(
      children: [
        CircleAvatar(
          radius: 30,
          child: const Icon(Icons.person_outline, size: 30),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${c.nombre} ${c.apellidos}'.trim(),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              if (c.empresa.isNotEmpty) Text(c.empresa),
              const SizedBox(height: AppSpacing.xs),
              Text(c.nif.isEmpty ? 'Sin NIF/CIF' : 'NIF/CIF · ${c.nif}'),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _contact(Cliente c) => Column(
    children: [
      _datum(Icons.phone_outlined, 'Teléfono', c.telefono),
      _datum(Icons.email_outlined, 'Correo electrónico', c.email),
      _datum(Icons.home_outlined, 'Dirección', c.direccion),
      _datum(
        Icons.location_on_outlined,
        'Localidad',
        [
          c.codigoPostal,
          c.poblacion,
          c.provincia,
          c.pais,
        ].where((v) => v.isNotEmpty).join(', '),
      ),
      _datum(Icons.notes_outlined, 'Observaciones', c.observaciones),
    ],
  );
  Widget _datum(IconData icon, String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.md),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(value.isEmpty ? 'No informado' : value),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _expedientes(BuildContext context, List<Expediente> items) {
    if (items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
        child: AppEmptyState(
          icon: Icons.folder_open_outlined,
          title: 'Sin expedientes relacionados',
          subtitle: 'Crea una obra vinculada directamente a este cliente.',
        ),
      );
    }
    return Column(
      children: items
          .map(
            (e) => Material(
              color: Colors.transparent,
              child: ListTile(
                key: ValueKey('cliente-expediente-${e.id}'),
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.folder_outlined),
                title: Text(e.codigo),
                subtitle: Text(e.nombre),
                trailing: Text(
                  e.estadoCiclo == ExpedienteEstadoCiclo.activo
                      ? 'Activo'
                      : 'Archivado',
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ExpedienteDetailScreen(
                      id: e.id,
                      codigo: e.codigo,
                      nombre: e.nombre,
                      clienteNombre: e.clienteNombre,
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Future<void> _eliminar(
    BuildContext context,
    WidgetRef ref,
    List<Expediente> expedientes,
  ) async {
    final name = '${cliente.nombre} ${cliente.apellidos}'.trim();
    final consequence = expedientes.isEmpty
        ? 'Dejará de aparecer en el listado de clientes.'
        : 'Tiene ${expedientes.length} expediente(s) asociado(s). Los expedientes se conservarán, pero el cliente dejará de estar disponible.';
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Eliminar cliente',
      message: 'Vas a eliminar a $name.\n\n$consequence',
      confirmLabel: 'Eliminar',
    );
    if (!confirmed || !context.mounted) {
      return;
    }
    try {
      await ref.read(clienteRepositoryProvider).eliminarCliente(cliente.id);
      if (context.mounted) Navigator.pop(context);
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo eliminar el cliente: $error')),
        );
      }
    }
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child, this.action});
  final String title;
  final Widget child;
  final Widget? action;
  @override
  Widget build(BuildContext context) => AppCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(title, style: Theme.of(context).textTheme.titleLarge),
            ),
            ?action,
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        child,
      ],
    ),
  );
}

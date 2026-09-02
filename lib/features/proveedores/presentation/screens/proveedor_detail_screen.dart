import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/shortcuts/app_shortcuts.dart';
import '../../../../core/ui/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_page_header.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../domain/proveedor.dart';
import '../providers/proveedor_providers.dart';
import 'editar_proveedor_screen.dart';

class ProveedorDetailScreen extends ConsumerWidget {
  const ProveedorDetailScreen({super.key, required this.proveedor});
  final Proveedor proveedor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final proveedorAsync = ref.watch(proveedorProvider(proveedor.id));
    final current = proveedorAsync.value ?? proveedor;
    return AppShortcutScope(
      onBack: () => Navigator.maybePop(context),
      child: Scaffold(
        appBar: AppPageHeader(
          title: 'Ficha de proveedor',
          subtitle: 'Identificación fiscal, contacto y datos operativos',
          showBackButton: true,
          actions: [
            AppPageHeaderAction(
              icon: Icons.edit_outlined,
              tooltip: 'Editar proveedor',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditarProveedorScreen(proveedor: current),
                ),
              ),
            ),
            AppPageHeaderAction(
              icon: Icons.delete_outline,
              tooltip: 'Eliminar proveedor',
              onPressed: () => _eliminar(context, ref, current),
            ),
          ],
        ),
        body: proveedorAsync.when(
          loading: () => _body(context, current),
          error: (error, _) => AppErrorState(
            message: 'No se pudo cargar el proveedor.\n\n$error',
          ),
          data: (value) => value == null
              ? const AppEmptyState(
                  icon: Icons.local_shipping_outlined,
                  title: 'Proveedor no disponible',
                  subtitle: 'Se ha eliminado o ya no está disponible.',
                )
              : _body(context, value),
        ),
      ),
    );
  }

  Widget _body(BuildContext context, Proveedor current) => LayoutBuilder(
    builder: (context, constraints) {
      final sections = <Widget>[
        if (_fiscal(current).isNotEmpty)
          _Section(title: 'Datos fiscales', children: _fiscal(current)),
        if (_contact(current).isNotEmpty)
          _Section(title: 'Contacto', children: _contact(current)),
        if (_hasText(current.observaciones))
          _Section(
            title: 'Información interna',
            children: [
              _Datum(
                icon: Icons.notes_outlined,
                label: 'Observaciones',
                value: current.observaciones.trim(),
              ),
            ],
          ),
      ];
      final wide = constraints.maxWidth >= 940 && sections.length > 1;
      return SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1180),
            child: Column(
              children: [
                _summary(context, current),
                if (sections.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.md),
                  if (wide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var i = 0; i < sections.length; i++) ...[
                          Expanded(child: sections[i]),
                          if (i < sections.length - 1)
                            const SizedBox(width: AppSpacing.md),
                        ],
                      ],
                    )
                  else
                    Column(
                      children: [
                        for (var i = 0; i < sections.length; i++) ...[
                          sections[i],
                          if (i < sections.length - 1)
                            const SizedBox(height: AppSpacing.md),
                        ],
                      ],
                    ),
                ],
              ],
            ),
          ),
        ),
      );
    },
  );

  Widget _summary(BuildContext context, Proveedor current) => AppCard(
    highlighted: true,
    child: Row(
      children: [
        const CircleAvatar(
          radius: 30,
          child: Icon(Icons.local_shipping_outlined, size: 30),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                current.nombre.trim(),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              if (_hasText(current.personaContacto))
                Text(current.personaContacto!.trim()),
              const SizedBox(height: AppSpacing.xs),
              Text(
                _hasText(current.nif)
                    ? 'NIF/CIF · ${current.nif.trim()}'
                    : 'Sin NIF/CIF',
              ),
            ],
          ),
        ),
      ],
    ),
  );

  List<Widget> _fiscal(Proveedor current) {
    final location = [
      current.codigoPostal,
      current.poblacion,
      current.provincia,
      current.pais,
    ].where(_hasText).map((value) => value.trim()).join(', ');
    return [
      if (_hasText(current.nif))
        _Datum(
          icon: Icons.badge_outlined,
          label: 'NIF / CIF',
          value: current.nif.trim(),
        ),
      if (_hasText(current.direccion))
        _Datum(
          icon: Icons.home_outlined,
          label: 'Dirección',
          value: current.direccion.trim(),
        ),
      if (location.isNotEmpty)
        _Datum(
          icon: Icons.location_on_outlined,
          label: 'Localidad',
          value: location,
        ),
    ];
  }

  List<Widget> _contact(Proveedor current) => [
    if (_hasText(current.personaContacto))
      _Datum(
        icon: Icons.person_outline,
        label: 'Persona de contacto',
        value: current.personaContacto!.trim(),
      ),
    if (_hasText(current.telefono))
      _Datum(
        icon: Icons.phone_outlined,
        label: 'Teléfono',
        value: current.telefono.trim(),
      ),
    if (_hasText(current.email))
      _Datum(
        icon: Icons.email_outlined,
        label: 'Correo electrónico',
        value: current.email.trim(),
      ),
  ];

  bool _hasText(String? value) => value != null && value.trim().isNotEmpty;

  Future<void> _eliminar(
    BuildContext context,
    WidgetRef ref,
    Proveedor current,
  ) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Eliminar proveedor',
      message:
          'Vas a eliminar a ${current.nombre.trim()}.\n\n'
          'Dejará de aparecer en el directorio. Esta acción no elimina otros datos de la aplicación.',
      confirmLabel: 'Eliminar',
    );
    if (!confirmed || !context.mounted) return;
    try {
      await ref.read(proveedorRepositoryProvider).eliminarProveedor(current.id);
      if (context.mounted) Navigator.pop(context);
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo eliminar el proveedor: $error')),
        );
      }
    }
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => AppCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.lg),
        for (var i = 0; i < children.length; i++) ...[
          children[i],
          if (i < children.length - 1) const SizedBox(height: AppSpacing.md),
        ],
      ],
    ),
  );
}

class _Datum extends StatelessWidget {
  const _Datum({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: 20),
      const SizedBox(width: AppSpacing.sm),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            Text(value),
          ],
        ),
      ),
    ],
  );
}

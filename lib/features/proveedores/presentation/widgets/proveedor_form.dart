import 'package:flutter/material.dart';

import '../../../../core/ui/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../domain/proveedor.dart';

class ProveedorFormData {
  const ProveedorFormData({
    required this.nombre,
    required this.personaContacto,
    required this.nif,
    required this.telefono,
    required this.email,
    required this.direccion,
    required this.poblacion,
    required this.provincia,
    required this.codigoPostal,
    required this.pais,
    required this.observaciones,
  });

  final String nombre;
  final String? personaContacto;
  final String nif;
  final String telefono;
  final String email;
  final String direccion;
  final String poblacion;
  final String provincia;
  final String codigoPostal;
  final String pais;
  final String observaciones;
}

class ProveedorForm extends StatefulWidget {
  const ProveedorForm({
    super.key,
    this.proveedor,
    required this.onSubmit,
    required this.onCancel,
  });

  final Proveedor? proveedor;
  final Future<void> Function(ProveedorFormData data) onSubmit;
  final VoidCallback onCancel;

  @override
  State<ProveedorForm> createState() => _ProveedorFormState();
}

class _ProveedorFormState extends State<ProveedorForm> {
  final _formKey = GlobalKey<FormState>();
  late final Map<String, TextEditingController> _controllers;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final proveedor = widget.proveedor;
    _controllers = {
      'nombre': proveedor?.nombre ?? '',
      'personaContacto': proveedor?.personaContacto ?? '',
      'nif': proveedor?.nif ?? '',
      'telefono': proveedor?.telefono ?? '',
      'email': proveedor?.email ?? '',
      'direccion': proveedor?.direccion ?? '',
      'poblacion': proveedor?.poblacion ?? '',
      'provincia': proveedor?.provincia ?? '',
      'codigoPostal': proveedor?.codigoPostal ?? '',
      'pais': proveedor?.pais ?? 'España',
      'observaciones': proveedor?.observaciones ?? '',
    }.map((key, value) => MapEntry(key, TextEditingController(text: value)));
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (_saving || !_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      String value(String key) => _controllers[key]!.text.trim();
      await widget.onSubmit(
        ProveedorFormData(
          nombre: value('nombre'),
          personaContacto: value('personaContacto').isEmpty
              ? null
              : value('personaContacto'),
          nif: value('nif'),
          telefono: value('telefono'),
          email: value('email'),
          direccion: value('direccion'),
          poblacion: value('poblacion'),
          provincia: value('provincia'),
          codigoPostal: value('codigoPostal'),
          pais: value('pais'),
          observaciones: value('observaciones'),
        ),
      );
    } catch (error) {
      if (mounted) {
        setState(() => _error = 'No se pudo guardar el proveedor: $error');
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final wide = constraints.maxWidth >= 820;
      return Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1060),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Section(
                    title: 'Identificación fiscal',
                    subtitle: 'Datos principales del proveedor y su empresa.',
                    child: _Fields(
                      wide: wide,
                      children: [
                        _field(
                          'nombre',
                          'Nombre / razón social',
                          required: true,
                        ),
                        _field('nif', 'NIF / CIF'),
                        _field('personaContacto', 'Persona de contacto'),
                        _field('pais', 'País'),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _Section(
                    title: 'Contacto',
                    subtitle:
                        'Canales habituales para pedidos y administración.',
                    child: _Fields(
                      wide: wide,
                      children: [
                        _field(
                          'telefono',
                          'Teléfono',
                          keyboardType: TextInputType.phone,
                        ),
                        _field(
                          'email',
                          'Correo electrónico',
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            final email = value?.trim() ?? '';
                            return email.isNotEmpty && !email.contains('@')
                                ? 'Introduce un correo válido'
                                : null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _Section(
                    title: 'Domicilio fiscal',
                    subtitle:
                        'Dirección utilizada para identificar al proveedor.',
                    child: Column(
                      children: [
                        _field('direccion', 'Dirección'),
                        const SizedBox(height: AppSpacing.md),
                        _Fields(
                          wide: wide,
                          children: [
                            _field('codigoPostal', 'Código postal'),
                            _field('poblacion', 'Localidad'),
                            _field('provincia', 'Provincia'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _Section(
                    title: 'Información interna',
                    subtitle: 'Notas operativas disponibles para el equipo.',
                    child: _field(
                      'observaciones',
                      'Observaciones',
                      maxLines: 4,
                    ),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      _error!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _saving ? null : widget.onCancel,
                        child: const Text('Cancelar'),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      AppPrimaryButton(
                        key: const Key('proveedor-submit'),
                        label: _saving ? 'Guardando…' : 'Guardar proveedor',
                        icon: Icons.save_outlined,
                        onPressed: _submit,
                        loading: _saving,
                        expand: false,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );

  Widget _field(
    String key,
    String label, {
    bool required = false,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) => TextFormField(
    key: ValueKey('proveedor-$key'),
    controller: _controllers[key],
    maxLines: maxLines,
    keyboardType: keyboardType,
    decoration: InputDecoration(labelText: required ? '$label *' : label),
    validator:
        validator ??
        (required
            ? (value) => value == null || value.trim().isEmpty
                  ? 'Este campo es obligatorio'
                  : null
            : null),
  );
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.subtitle,
    required this.child,
  });
  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) => AppCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.xxs),
        Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: AppSpacing.lg),
        child,
      ],
    ),
  );
}

class _Fields extends StatelessWidget {
  const _Fields({required this.wide, required this.children});
  final bool wide;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => wide
      ? Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: children
              .map((child) => SizedBox(width: 470, child: child))
              .toList(),
        )
      : Column(
          children: [
            for (var i = 0; i < children.length; i++) ...[
              children[i],
              if (i < children.length - 1)
                const SizedBox(height: AppSpacing.md),
            ],
          ],
        );
}

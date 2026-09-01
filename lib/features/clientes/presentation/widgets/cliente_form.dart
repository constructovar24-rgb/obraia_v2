import 'package:flutter/material.dart';

import '../../../../core/ui/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../domain/cliente.dart';

class ClienteFormData {
  const ClienteFormData({
    required this.nombre,
    required this.apellidos,
    required this.nif,
    required this.telefono,
    required this.email,
    required this.direccion,
    required this.poblacion,
    required this.provincia,
    required this.codigoPostal,
    required this.pais,
    required this.empresa,
    required this.observaciones,
  });
  final String nombre,
      apellidos,
      nif,
      telefono,
      email,
      direccion,
      poblacion,
      provincia,
      codigoPostal,
      pais,
      empresa,
      observaciones;
}

class ClienteForm extends StatefulWidget {
  const ClienteForm({
    super.key,
    this.cliente,
    required this.onSubmit,
    required this.onCancel,
  });
  final Cliente? cliente;
  final Future<void> Function(ClienteFormData data) onSubmit;
  final VoidCallback onCancel;
  @override
  State<ClienteForm> createState() => _ClienteFormState();
}

class _ClienteFormState extends State<ClienteForm> {
  final _formKey = GlobalKey<FormState>();
  late final Map<String, TextEditingController> _c;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final x = widget.cliente;
    _c = {
      'nombre': x?.nombre ?? '',
      'apellidos': x?.apellidos ?? '',
      'nif': x?.nif ?? '',
      'telefono': x?.telefono ?? '',
      'email': x?.email ?? '',
      'direccion': x?.direccion ?? '',
      'poblacion': x?.poblacion ?? '',
      'provincia': x?.provincia ?? '',
      'codigoPostal': x?.codigoPostal ?? '',
      'pais': x?.pais ?? 'España',
      'empresa': x?.empresa ?? '',
      'observaciones': x?.observaciones ?? '',
    }.map((key, value) => MapEntry(key, TextEditingController(text: value)));
  }

  @override
  void dispose() {
    for (final controller in _c.values) {
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
      String v(String key) => _c[key]!.text.trim();
      await widget.onSubmit(
        ClienteFormData(
          nombre: v('nombre'),
          apellidos: v('apellidos'),
          nif: v('nif'),
          telefono: v('telefono'),
          email: v('email'),
          direccion: v('direccion'),
          poblacion: v('poblacion'),
          provincia: v('provincia'),
          codigoPostal: v('codigoPostal'),
          pais: v('pais'),
          empresa: v('empresa'),
          observaciones: v('observaciones'),
        ),
      );
    } catch (error) {
      if (mounted) {
        setState(() => _error = 'No se pudo guardar el cliente: $error');
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
                    title: 'Identificación',
                    subtitle: 'Datos principales para reconocer al cliente.',
                    child: _Fields(
                      wide: wide,
                      children: [
                        _field(
                          'nombre',
                          'Nombre / razón social',
                          required: true,
                        ),
                        _field('apellidos', 'Apellidos'),
                        _field('empresa', 'Empresa'),
                        _field('nif', 'NIF / CIF'),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _Section(
                    title: 'Contacto',
                    subtitle: 'Canales habituales de comunicación.',
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
                    title: 'Dirección',
                    subtitle: 'Domicilio y localización del cliente.',
                    child: Column(
                      children: [
                        _field('direccion', 'Dirección'),
                        const SizedBox(height: AppSpacing.md),
                        _Fields(
                          wide: wide,
                          children: [
                            _field('codigoPostal', 'Código postal'),
                            _field('poblacion', 'Población'),
                            _field('provincia', 'Provincia'),
                            _field('pais', 'País'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _Section(
                    title: 'Información interna',
                    subtitle: 'Notas disponibles para el equipo.',
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
                        label: _saving ? 'Guardando…' : 'Guardar cliente',
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
    key: ValueKey('cliente-$key'),
    controller: _c[key],
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
  final String title, subtitle;
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

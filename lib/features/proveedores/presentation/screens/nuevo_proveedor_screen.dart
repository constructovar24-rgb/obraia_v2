import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/shortcuts/app_shortcuts.dart';
import '../../../../core/widgets/app_page_header.dart';
import '../../domain/proveedor.dart';
import '../providers/proveedor_providers.dart';
import '../widgets/proveedor_form.dart';

class NuevoProveedorScreen extends ConsumerWidget {
  const NuevoProveedorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => AppShortcutScope(
    onBack: () => Navigator.maybePop(context),
    child: Scaffold(
      appBar: const AppPageHeader(
        title: 'Nuevo proveedor',
        subtitle:
            'Completa los datos disponibles; solo el nombre es obligatorio.',
        showBackButton: true,
      ),
      body: ProveedorForm(
        onCancel: () => Navigator.maybePop(context),
        onSubmit: (data) async {
          await ref
              .read(proveedorRepositoryProvider)
              .registrarProveedor(
                Proveedor(
                  id: '',
                  nombre: data.nombre,
                  personaContacto: data.personaContacto,
                  nif: data.nif,
                  telefono: data.telefono,
                  email: data.email,
                  direccion: data.direccion,
                  poblacion: data.poblacion,
                  provincia: data.provincia,
                  codigoPostal: data.codigoPostal,
                  pais: data.pais,
                  observaciones: data.observaciones,
                ),
              );
          if (context.mounted) Navigator.pop(context);
        },
      ),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/shortcuts/app_shortcuts.dart';
import '../../../../core/widgets/app_page_header.dart';
import '../../domain/proveedor.dart';
import '../providers/proveedor_providers.dart';
import '../widgets/proveedor_form.dart';

class EditarProveedorScreen extends ConsumerWidget {
  const EditarProveedorScreen({super.key, required this.proveedor});

  final Proveedor proveedor;

  @override
  Widget build(BuildContext context, WidgetRef ref) => AppShortcutScope(
    onBack: () => Navigator.maybePop(context),
    child: Scaffold(
      appBar: const AppPageHeader(
        title: 'Editar proveedor',
        subtitle: 'Actualiza la información fiscal y de contacto disponible.',
        showBackButton: true,
      ),
      body: ProveedorForm(
        proveedor: proveedor,
        onCancel: () => Navigator.maybePop(context),
        onSubmit: (data) async {
          await ref
              .read(proveedorRepositoryProvider)
              .actualizarProveedor(
                Proveedor(
                  id: proveedor.id,
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/shortcuts/app_shortcuts.dart';
import '../../../../core/widgets/app_page_header.dart';
import '../providers/cliente_providers.dart';
import '../widgets/cliente_form.dart';

class NuevoClienteScreen extends ConsumerWidget {
  const NuevoClienteScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => AppShortcutScope(
    onBack: () => Navigator.maybePop(context),
    child: Scaffold(
      appBar: const AppPageHeader(
        title: 'Nuevo cliente',
        subtitle:
            'Completa los datos disponibles; solo el nombre es obligatorio.',
        showBackButton: true,
      ),
      body: ClienteForm(
        onCancel: () => Navigator.maybePop(context),
        onSubmit: (data) async {
          await ref
              .read(clienteRepositoryProvider)
              .crearCliente(
                nombre: data.nombre,
                apellidos: data.apellidos,
                nif: data.nif,
                telefono: data.telefono,
                email: data.email,
                direccion: data.direccion,
                poblacion: data.poblacion,
                provincia: data.provincia,
                codigoPostal: data.codigoPostal,
                pais: data.pais,
                empresa: data.empresa,
                observaciones: data.observaciones,
              );
          if (context.mounted) Navigator.pop(context);
        },
      ),
    ),
  );
}

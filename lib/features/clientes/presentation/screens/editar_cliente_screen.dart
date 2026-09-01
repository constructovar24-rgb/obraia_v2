import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/shortcuts/app_shortcuts.dart';
import '../../../../core/widgets/app_page_header.dart';
import '../../domain/cliente.dart';
import '../providers/cliente_providers.dart';
import '../widgets/cliente_form.dart';

class EditarClienteScreen extends ConsumerWidget {
  const EditarClienteScreen({super.key, required this.cliente});
  final Cliente cliente;
  @override
  Widget build(BuildContext context, WidgetRef ref) => AppShortcutScope(
    onBack: () => Navigator.maybePop(context),
    child: Scaffold(
      appBar: const AppPageHeader(
        title: 'Editar cliente',
        subtitle: 'Actualiza la información disponible del cliente.',
        showBackButton: true,
      ),
      body: ClienteForm(
        cliente: cliente,
        onCancel: () => Navigator.maybePop(context),
        onSubmit: (data) async {
          await ref
              .read(clienteRepositoryProvider)
              .actualizarCliente(
                id: cliente.id,
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

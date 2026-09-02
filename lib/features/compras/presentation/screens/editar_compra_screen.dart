import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/shortcuts/app_shortcuts.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/app_page_header.dart';
import '../../../proveedores/presentation/providers/proveedor_providers.dart';
import '../../domain/compra.dart';
import '../providers/compra_providers.dart';
import '../widgets/compra_form.dart';

class EditarCompraScreen extends ConsumerWidget {
  const EditarCompraScreen({super.key, required this.compra});
  final Compra compra;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expedientes = ref.watch(expedientesCompraProvider);
    final proveedores = ref.watch(proveedoresProvider);
    return AppShortcutScope(
      onBack: () => Navigator.maybePop(context),
      child: Scaffold(
        appBar: const AppPageHeader(
          title: 'Editar compra',
          subtitle: 'Actualiza los datos del apunte de gasto',
          showBackButton: true,
        ),
        body: expedientes.when(
          loading: () => const AppLoading(message: 'Cargando expedientes…'),
          error: (e, _) => AppErrorState(
            message: 'No se pudieron cargar los expedientes.\n\n$e',
          ),
          data: (expedientes) => proveedores.when(
            loading: () => const AppLoading(message: 'Cargando proveedores…'),
            error: (e, _) => AppErrorState(
              message: 'No se pudieron cargar los proveedores.\n\n$e',
            ),
            data: (proveedores) => CompraForm(
              compra: compra,
              expedientes: expedientes,
              proveedores: proveedores,
              onCancel: () => Navigator.maybePop(context),
              onSubmit: (data) async {
                await ref
                    .read(compraRepositoryProvider)
                    .actualizarCompra(
                      Compra(
                        id: compra.id,
                        expedienteId: data.expedienteId,
                        proveedorId: data.proveedorId,
                        proveedorNombre: data.proveedorNombre,
                        fecha: data.fecha,
                        numeroFactura: data.numeroFactura,
                        concepto: data.concepto,
                        baseImponible: data.baseImponible,
                        ivaPorcentaje: data.ivaPorcentaje,
                        importeTotal: data.importeTotal,
                        estado: data.estado,
                        observaciones: data.observaciones,
                      ),
                    );
                if (context.mounted) Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
    );
  }
}

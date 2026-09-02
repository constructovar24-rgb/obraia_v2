import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/shortcuts/app_shortcuts.dart';
import '../../../../core/ui/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_page_header.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../core/widgets/money_text.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../expedientes/presentation/screens/expediente_detail_screen.dart';
import '../../../proveedores/presentation/providers/proveedor_providers.dart';
import '../../../proveedores/presentation/screens/proveedor_detail_screen.dart';
import '../../domain/compra.dart';
import '../providers/compra_providers.dart';
import 'compras_screen.dart';
import 'editar_compra_screen.dart';

class CompraDetailScreen extends ConsumerWidget {
  const CompraDetailScreen({super.key, required this.compra});
  final Compra compra;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final obras = ref.watch(expedientesCompraProvider).value ?? const [];
    final proveedores = ref.watch(proveedoresProvider).value ?? const [];
    final obra = obras.where((e) => e.id == compra.expedienteId).firstOrNull;
    final proveedor = proveedores
        .where((p) => p.id == compra.proveedorId)
        .firstOrNull;
    return AppShortcutScope(
      onBack: () => Navigator.maybePop(context),
      child: Scaffold(
        appBar: AppPageHeader(
          title: 'Detalle de compra',
          subtitle: 'Apunte de gasto registrado',
          showBackButton: true,
          actions: [
            AppPageHeaderAction(
              icon: Icons.edit_outlined,
              tooltip: 'Editar compra',
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => EditarCompraScreen(compra: compra),
                ),
              ),
            ),
            AppPageHeaderAction(
              icon: Icons.delete_outline,
              tooltip: 'Eliminar compra',
              onPressed: () => _delete(context, ref),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Column(
                children: [
                  AppCard(
                    highlighted: true,
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 28,
                          child: Icon(Icons.shopping_cart_outlined),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                compra.concepto,
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall,
                              ),
                              Text(
                                compra.numeroFactura?.trim().isNotEmpty == true
                                    ? 'Factura indicada · ${compra.numeroFactura}'
                                    : 'Sin número de factura indicado',
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              StatusChip(
                                label: compraEstadoLabel(compra.estado),
                                type: compraEstadoType(compra.estado),
                              ),
                            ],
                          ),
                        ),
                        MoneyText(
                          compra.importeTotal,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final relation = AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Trazabilidad',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Material(
                              color: Colors.transparent,
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const Icon(
                                  Icons.local_shipping_outlined,
                                ),
                                title: Text(compra.proveedorNombre),
                                subtitle: Text(
                                  proveedor == null
                                      ? 'Proveedor histórico o no disponible'
                                      : 'Abrir ficha de proveedor',
                                ),
                                trailing: proveedor == null
                                    ? null
                                    : const Icon(Icons.chevron_right),
                                onTap: proveedor == null
                                    ? null
                                    : () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ProveedorDetailScreen(
                                            proveedor: proveedor,
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const Icon(Icons.folder_outlined),
                                title: Text(
                                  obra == null
                                      ? 'Obra no disponible'
                                      : '${obra.codigo} · ${obra.nombre}',
                                ),
                                subtitle: const Text('Expediente vinculado'),
                                trailing: obra == null
                                    ? null
                                    : const Icon(Icons.chevron_right),
                                onTap: obra == null
                                    ? null
                                    : () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              ExpedienteDetailScreen(
                                                id: obra.id,
                                                codigo: obra.codigo,
                                                nombre: obra.nombre,
                                                clienteNombre:
                                                    obra.clienteNombre,
                                              ),
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      );
                      final economic = AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Importes registrados',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            _money('Base imponible', compra.baseImponible),
                            _text(
                              'IVA indicado',
                              '${compra.ivaPorcentaje.toStringAsFixed(2)} %',
                            ),
                            _money('Importe total', compra.importeTotal),
                            _text('Fecha', compraFecha(compra.fecha)),
                            if (compra.observaciones?.trim().isNotEmpty == true)
                              _text(
                                'Observaciones',
                                compra.observaciones!.trim(),
                              ),
                          ],
                        ),
                      );
                      return constraints.maxWidth >= 850
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: relation),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(child: economic),
                              ],
                            )
                          : Column(
                              children: [
                                relation,
                                const SizedBox(height: AppSpacing.md),
                                economic,
                              ],
                            );
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const AppCard(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline),
                        SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            'Este registro no contiene un documento original ni movimientos de pago. El estado mostrado es el valor manual actualmente guardado.',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _money(String label, double value) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.md),
    child: Row(
      children: [
        Expanded(child: Text(label)),
        MoneyText(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    ),
  );
  Widget _text(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.md),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Text(label)),
        Flexible(child: Text(value, textAlign: TextAlign.end)),
      ],
    ),
  );
  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Eliminar compra',
      message:
          'Vas a eliminar el registro “${compra.concepto}”.\n\nDejará de aparecer en la obra y en el centro de Compras. La eliminación es lógica.',
      confirmLabel: 'Eliminar',
    );
    if (!confirmed || !context.mounted) {
      return;
    }
    try {
      await ref.read(compraRepositoryProvider).eliminarCompra(compra.id);
      if (context.mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo eliminar la compra: $e')),
        );
      }
    }
  }
}

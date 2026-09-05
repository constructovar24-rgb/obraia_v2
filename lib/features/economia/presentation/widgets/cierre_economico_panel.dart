import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/ui/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/cierre_economico.dart';
import '../providers/cierre_economico_providers.dart';

class CierreEconomicoPanel extends ConsumerWidget {
  const CierreEconomicoPanel({super.key, required this.expedienteId});
  final String expedienteId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(estadoCierreEconomicoProvider(expedienteId));
    final alerts = ref.watch(alertasEconomicasProvider(expedienteId));
    final history = ref.watch(historialCierresProvider(expedienteId));
    final reopenings = ref.watch(historialReaperturasProvider(expedienteId));
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Control económico',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              state.when(
                loading: () => const SizedBox.square(
                  dimension: 24,
                  child: CircularProgressIndicator(),
                ),
                error: (_, _) => const Text('No disponible'),
                data: (value) => Chip(
                  label: Text(
                    value.estado == EstadoEconomicoObra.cerrado
                        ? 'Cerrado'
                        : 'Abierto',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ...alerts.valueOrNull?.map(
                (alert) => Material(
                  type: MaterialType.transparency,
                  child: ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      alert.severidad == SeveridadAlertaEconomica.critica
                          ? Icons.error_outline
                          : Icons.warning_amber_outlined,
                    ),
                    title: Text(alert.mensaje),
                    subtitle: Text(alert.severidad.name),
                  ),
                ),
              ) ??
              const [],
          if (state.valueOrNull case final current?) ...[
            if (current.ultimoCierre != null)
              Text(
                'Último cierre: ${_date(current.ultimoCierre!.fechaCierre)}',
              ),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                key: ValueKey(
                  current.estado == EstadoEconomicoObra.cerrado
                      ? 'reabrir-economia'
                      : 'cerrar-economia',
                ),
                onPressed: () => current.estado == EstadoEconomicoObra.cerrado
                    ? _reopen(context, ref)
                    : _close(context, ref),
                icon: Icon(
                  current.estado == EstadoEconomicoObra.cerrado
                      ? Icons.lock_open
                      : Icons.lock_outline,
                ),
                label: Text(
                  current.estado == EstadoEconomicoObra.cerrado
                      ? 'Reabrir economía'
                      : 'Cerrar economía',
                ),
              ),
            ),
          ],
          const Divider(height: AppSpacing.lg),
          Text(
            'Historial de cierres',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          ...history.valueOrNull?.map(
                (item) => Material(
                  type: MaterialType.transparency,
                  child: ExpansionTile(
                    title: Text(
                      'Cierre #${item.numero} · ${_date(item.fechaCierre)}',
                    ),
                    subtitle: Text(
                      item.conAdvertencias
                          ? 'Con advertencias'
                          : 'Sin advertencias',
                    ),
                    children: [
                      ListTile(
                        title: Text(
                          'Cobertura: ${item.resumen.cobertura.name}',
                        ),
                        subtitle: Text(item.resumenPrecheck),
                      ),
                    ],
                  ),
                ),
              ) ??
              const [Text('No existen cierres económicos.')],
          if ((reopenings.valueOrNull ?? const []).isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text('Reaperturas', style: Theme.of(context).textTheme.titleMedium),
            ...reopenings.valueOrNull!.map(
              (item) => Text('${_date(item.fecha)} · ${item.motivo}'),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _close(BuildContext context, WidgetRef ref) async {
    final check = await ref
        .read(cierreEconomicoRepositoryProvider)
        .evaluarCierre(expedienteId);
    if (!context.mounted) return;
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Cerrar economía'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: check.controles
                  .map(
                    (item) => Text('${item.severidad.name}: ${item.mensaje}'),
                  )
                  .toList(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: check.tieneBloqueos
                    ? null
                    : () => Navigator.pop(context, true),
                child: Text(
                  check.tieneAdvertencias
                      ? 'Cerrar con advertencias'
                      : 'Cerrar economía',
                ),
              ),
            ],
          ),
        ) ??
        false;
    if (!confirmed) return;
    await ref
        .read(cierreEconomicoRepositoryProvider)
        .cerrar(expedienteId, confirmarAdvertencias: check.tieneAdvertencias);
    _refresh(ref);
  }

  Future<void> _reopen(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final reason = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reabrir economía'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Motivo obligatorio'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                Navigator.pop(context, controller.text.trim());
              }
            },
            child: const Text('Reabrir'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (reason == null) return;
    await ref
        .read(cierreEconomicoRepositoryProvider)
        .reabrir(expedienteId, motivo: reason);
    _refresh(ref);
  }

  void _refresh(WidgetRef ref) {
    ref.invalidate(estadoCierreEconomicoProvider(expedienteId));
    ref.invalidate(precheckCierreEconomicoProvider(expedienteId));
    ref.invalidate(alertasEconomicasProvider(expedienteId));
    ref.invalidate(historialCierresProvider(expedienteId));
    ref.invalidate(historialReaperturasProvider(expedienteId));
  }

  String _date(DateTime value) =>
      '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/money_text.dart';
import '../providers/prevision_economica_providers.dart';

class PrevisionEconomicaPanel extends ConsumerWidget {
  const PrevisionEconomicaPanel({super.key, required this.expedienteId});
  final String expedienteId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resumen = ref.watch(resumenForecastProvider(expedienteId));
    final compromisos = ref.watch(compromisosEconomicosProvider(expedienteId));
    final estimaciones = ref.watch(
      estimacionesCosteRestanteProvider(expedienteId),
    );
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            runSpacing: AppSpacing.sm,
            children: [
              Text(
                'Previsión económica',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Wrap(
                spacing: AppSpacing.sm,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _nuevoCompromiso(context, ref),
                    icon: const Icon(Icons.add),
                    label: const Text('Compromiso'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => _nuevaEstimacion(context, ref),
                    icon: const Icon(Icons.edit_note),
                    label: const Text('Estimación'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          resumen.when(
            loading: () => const LinearProgressIndicator(),
            error: (error, _) => Text('Previsión no disponible: $error'),
            data: (value) => Wrap(
              spacing: AppSpacing.lg,
              runSpacing: AppSpacing.sm,
              children: [
                _Amount('Coste real', value.costeRealCentimos),
                _Amount(
                  'Coste previsto original',
                  value.costePlanificadoCentimos,
                ),
                _Amount(
                  'Comprometido pendiente',
                  value.comprometidoPendienteCentimos,
                ),
                _Amount(
                  'Estimación adicional',
                  value.estimacionAdicionalCentimos,
                ),
                _Amount('Coste final', value.costeFinalEstimadoCentimos),
                _Amount(
                  'Beneficio final',
                  value.beneficioFinalEstimadoCentimos,
                ),
                _Amount(
                  'Beneficio previsto',
                  value.beneficioPlanificadoCentimos,
                ),
                SizedBox(
                  width: 170,
                  child: Text(
                    value.margenFinalEstimadoPorcentaje == null
                        ? 'Margen: No disponible'
                        : 'Margen estimado: ${value.margenFinalEstimadoPorcentaje!.toStringAsFixed(2)} %',
                  ),
                ),
                Text('Cobertura: ${value.cobertura.name}'),
              ],
            ),
          ),
          const Divider(height: AppSpacing.lg),
          Text('Compromisos', style: Theme.of(context).textTheme.titleMedium),
          ...compromisos.valueOrNull?.map(
                (item) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(item.descripcion),
                  subtitle: Text(
                    '${item.estado.name} · pendiente ${(item.pendienteCentimos / 100).toStringAsFixed(2)} €',
                  ),
                  trailing: item.estado.name == 'cancelado'
                      ? null
                      : PopupMenuButton<String>(
                          onSelected: (action) => _editarCompromiso(
                            context,
                            ref,
                            item.id,
                            action,
                            item.importeComprometidoCentimos,
                          ),
                          itemBuilder: (_) => const [
                            PopupMenuItem(
                              value: 'ajustar',
                              child: Text('Ajustar'),
                            ),
                            PopupMenuItem(
                              value: 'cancelar',
                              child: Text('Cancelar'),
                            ),
                          ],
                        ),
                ),
              ) ??
              const [Text('Sin compromisos registrados.')],
          const Divider(height: AppSpacing.lg),
          Text(
            'Historial de estimaciones (${estimaciones.valueOrNull?.length ?? 0} versiones)',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          ...estimaciones.valueOrNull?.map(
                (item) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(item.justificacion),
                  subtitle: Text('Versión ${item.version}'),
                  trailing: MoneyText(item.importeAdicionalCentimos / 100),
                ),
              ) ??
              const [Text('Sin estimaciones registradas.')],
        ],
      ),
    );
  }

  Future<void> _nuevoCompromiso(BuildContext context, WidgetRef ref) async {
    final input = await _InputDialog.open(context, 'Nuevo compromiso');
    if (input == null) return;
    await ref
        .read(previsionEconomicaRepositoryProvider)
        .crearCompromiso(
          expedienteId: expedienteId,
          descripcion: input.$1,
          origenTipo: 'otro',
          importeCentimos: input.$2,
          fecha: DateTime.now().toUtc(),
        );
    _refresh(ref);
  }

  Future<void> _nuevaEstimacion(BuildContext context, WidgetRef ref) async {
    final input = await _InputDialog.open(context, 'Estimación restante');
    if (input == null) return;
    await ref
        .read(previsionEconomicaRepositoryProvider)
        .registrarEstimacion(
          expedienteId: expedienteId,
          importeAdicionalCentimos: input.$2,
          justificacion: input.$1,
          fecha: DateTime.now().toUtc(),
        );
    _refresh(ref);
  }

  Future<void> _editarCompromiso(
    BuildContext context,
    WidgetRef ref,
    String id,
    String action,
    int current,
  ) async {
    final repository = ref.read(previsionEconomicaRepositoryProvider);
    if (action == 'cancelar') {
      await repository.cancelarCompromiso(
        id,
        motivo: 'Cancelado desde la obra',
      );
    } else {
      final input = await _InputDialog.open(
        context,
        'Ajustar compromiso',
        initialCents: current,
      );
      if (input == null) return;
      await repository.ajustarCompromiso(
        id: id,
        nuevoImporteCentimos: input.$2,
        motivo: input.$1,
      );
    }
    _refresh(ref);
  }

  void _refresh(WidgetRef ref) {
    ref.invalidate(resumenForecastProvider(expedienteId));
    ref.invalidate(compromisosEconomicosProvider(expedienteId));
    ref.invalidate(estimacionesCosteRestanteProvider(expedienteId));
  }
}

class _Amount extends StatelessWidget {
  const _Amount(this.label, this.cents);
  final String label;
  final int? cents;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 170,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        if (cents == null)
          const Text('No disponible')
        else
          MoneyText(cents! / 100),
      ],
    ),
  );
}

class _InputDialog extends StatefulWidget {
  const _InputDialog(this.title, this.initialCents);
  final String title;
  final int? initialCents;
  static Future<(String, int)?> open(
    BuildContext context,
    String title, {
    int? initialCents,
  }) => showDialog(
    context: context,
    builder: (_) => _InputDialog(title, initialCents),
  );
  @override
  State<_InputDialog> createState() => _InputDialogState();
}

class _InputDialogState extends State<_InputDialog> {
  late final TextEditingController amount;
  final description = TextEditingController();
  @override
  void initState() {
    super.initState();
    amount = TextEditingController(
      text: widget.initialCents == null
          ? ''
          : (widget.initialCents! / 100).toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    amount.dispose();
    description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.title),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: description,
          decoration: const InputDecoration(labelText: 'Descripción o motivo'),
        ),
        TextField(
          controller: amount,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(labelText: 'Importe (€)'),
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancelar'),
      ),
      FilledButton(
        onPressed: () {
          final value = double.tryParse(amount.text.replaceAll(',', '.'));
          if (value == null || value < 0 || description.text.trim().isEmpty) {
            return;
          }
          Navigator.pop(context, (
            description.text.trim(),
            (value * 100).round(),
          ));
        },
        child: const Text('Guardar'),
      ),
    ],
  );
}

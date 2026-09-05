import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../mano_obra/domain/mano_obra.dart';
import '../../../mano_obra/presentation/providers/mano_obra_providers.dart';
import '../../../planificacion/domain/planificacion_obra.dart';
import '../../../planificacion/presentation/providers/planificacion_obra_providers.dart';
import '../../domain/entrada_diario_obra.dart';
import '../providers/diario_obra_providers.dart';

class DiarioObraTab extends ConsumerWidget {
  const DiarioObraTab({super.key, required this.expedienteId});
  final String expedienteId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(entradasDiarioObraProvider(expedienteId));
    final parts =
        ref.watch(partesTrabajoObraProvider(expedienteId)).valueOrNull ??
        const <ParteTrabajo>[];
    final actions =
        ref.watch(actuacionesObraProvider(expedienteId)).valueOrNull ??
        const <ActuacionObra>[];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Diario de obra',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              FilledButton.icon(
                key: const ValueKey('nueva-entrada-diario'),
                onPressed: () => _openEditor(context, ref, actions),
                icon: const Icon(Icons.add),
                label: const Text('Nueva entrada'),
              ),
            ],
          ),
        ),
        Expanded(
          child: entries.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) =>
                Center(child: Text('No se pudo cargar el diario: $error')),
            data: (items) => items.isEmpty
                ? const Center(
                    child: Text('Todavía no hay entradas de diario.'),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      0,
                      AppSpacing.md,
                      AppSpacing.md,
                    ),
                    itemCount: items.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) => _EntryCard(
                      entry: items[index],
                      hours: _hoursFor(parts, items[index].fechaTrabajo),
                      onEdit: () => _openEditor(
                        context,
                        ref,
                        actions,
                        entry: items[index],
                      ),
                      onCancel: () => _cancel(context, ref, items[index]),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> _openEditor(
    BuildContext context,
    WidgetRef ref,
    List<ActuacionObra> actions, {
    EntradaDiarioObra? entry,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (_) => _DiaryEditor(
        expedienteId: expedienteId,
        entry: entry,
        actions: actions
            .where((a) => a.tipo == TipoActuacionObra.actuacion)
            .toList(),
      ),
    );
  }

  Future<void> _cancel(
    BuildContext context,
    WidgetRef ref,
    EntradaDiarioObra entry,
  ) async {
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Anular entrada'),
            content: const Text(
              'La entrada se conservará en el historial como anulada.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Volver'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Anular'),
              ),
            ],
          ),
        ) ??
        false;
    if (confirmed) {
      await ref.read(diarioObraRepositoryProvider).anular(entry.id);
    }
  }

  int _hoursFor(List<ParteTrabajo> parts, DateTime date) => parts
      .where(
        (part) =>
            part.estado != EstadoParteTrabajo.revertido &&
            _sameDay(part.fechaTrabajo, date),
      )
      .fold(0, (total, part) => total + part.horasDiezMilesimas);
}

class _EntryCard extends StatelessWidget {
  const _EntryCard({
    required this.entry,
    required this.hours,
    required this.onEdit,
    required this.onCancel,
  });
  final EntradaDiarioObra entry;
  final int hours;
  final VoidCallback onEdit;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) => AppCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                _date(entry.fechaTrabajo),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            if (entry.anulado) const Chip(label: Text('Anulada')),
            if (!entry.anulado) ...[
              IconButton(
                key: ValueKey('editar-diario-${entry.id}'),
                tooltip: 'Editar',
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined),
              ),
              IconButton(
                key: ValueKey('anular-diario-${entry.id}'),
                tooltip: 'Anular',
                onPressed: onCancel,
                icon: const Icon(Icons.block_outlined),
              ),
            ],
          ],
        ),
        Text(
          entry.trabajos,
          style: TextStyle(
            decoration: entry.anulado ? TextDecoration.lineThrough : null,
          ),
        ),
        if (entry.observaciones != null)
          Text('Observaciones: ${entry.observaciones}'),
        if (entry.incidenciaTexto != null)
          Text('Incidencias: ${entry.incidenciaTexto}'),
        if (entry.meteorologia != null)
          Text('Meteorología: ${entry.meteorologia}'),
        if (entry.actuacionDescripcion != null)
          Text('Actuación: ${entry.actuacionDescripcion}'),
        Text('Horas registradas: ${(hours / 10000).toStringAsFixed(2)} h'),
      ],
    ),
  );
}

class _DiaryEditor extends ConsumerStatefulWidget {
  const _DiaryEditor({
    required this.expedienteId,
    required this.entry,
    required this.actions,
  });
  final String expedienteId;
  final EntradaDiarioObra? entry;
  final List<ActuacionObra> actions;
  @override
  ConsumerState<_DiaryEditor> createState() => _DiaryEditorState();
}

class _DiaryEditorState extends ConsumerState<_DiaryEditor> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController work = TextEditingController(
    text: widget.entry?.trabajos,
  );
  late final TextEditingController notes = TextEditingController(
    text: widget.entry?.observaciones,
  );
  late final TextEditingController weather = TextEditingController(
    text: widget.entry?.meteorologia,
  );
  late final TextEditingController issue = TextEditingController(
    text: widget.entry?.incidenciaTexto,
  );
  late DateTime date = widget.entry?.fechaTrabajo ?? DateTime.now();
  late String? actionId = widget.entry?.actuacionId;
  bool saving = false;

  @override
  void dispose() {
    work.dispose();
    notes.dispose();
    weather.dispose();
    issue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.entry == null ? 'Nueva entrada' : 'Editar entrada'),
    content: SizedBox(
      width: 560,
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Fecha de trabajo'),
                subtitle: Text(_date(date)),
                trailing: const Icon(Icons.calendar_today_outlined),
                onTap: () async {
                  final selected = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    initialDate: date,
                  );
                  if (selected != null) setState(() => date = selected);
                },
              ),
              TextFormField(
                key: const ValueKey('trabajos-diario'),
                controller: work,
                minLines: 3,
                maxLines: 7,
                decoration: const InputDecoration(
                  labelText: 'Trabajos realizados',
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Describe los trabajos realizados.'
                    : null,
              ),
              TextField(
                controller: notes,
                decoration: const InputDecoration(
                  labelText: 'Observaciones (opcional)',
                ),
              ),
              TextField(
                controller: issue,
                decoration: const InputDecoration(
                  labelText: 'Incidencias o impedimentos (opcional)',
                ),
              ),
              TextField(
                controller: weather,
                decoration: const InputDecoration(
                  labelText: 'Meteorología manual (opcional)',
                ),
              ),
              DropdownButtonFormField<String?>(
                initialValue: actionId,
                decoration: const InputDecoration(
                  labelText: 'Actuación relacionada (opcional)',
                ),
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('Sin actuación'),
                  ),
                  ...widget.actions.map(
                    (a) => DropdownMenuItem<String?>(
                      value: a.id,
                      child: Text(a.descripcion),
                    ),
                  ),
                ],
                onChanged: (value) => setState(() => actionId = value),
              ),
            ],
          ),
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: saving ? null : () => Navigator.pop(context),
        child: const Text('Cancelar'),
      ),
      FilledButton(
        key: const ValueKey('guardar-diario'),
        onPressed: saving ? null : _save,
        child: Text(saving ? 'Guardando…' : 'Guardar'),
      ),
    ],
  );

  Future<void> _save() async {
    if (saving) return;
    if (!(formKey.currentState?.validate() ?? false)) return;
    setState(() => saving = true);
    final repository = ref.read(diarioObraRepositoryProvider);
    try {
      if (widget.entry == null) {
        await repository.crear(
          expedienteId: widget.expedienteId,
          fechaTrabajo: date,
          trabajos: work.text,
          observaciones: notes.text,
          meteorologia: weather.text,
          incidenciaTexto: issue.text,
          actuacionId: actionId,
        );
      } else {
        await repository.editar(
          id: widget.entry!.id,
          fechaTrabajo: date,
          trabajos: work.text,
          observaciones: notes.text,
          meteorologia: weather.text,
          incidenciaTexto: issue.text,
          actuacionId: actionId,
        );
      }
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) setState(() => saving = false);
      rethrow;
    }
  }
}

bool _sameDay(DateTime left, DateTime right) =>
    left.year == right.year &&
    left.month == right.month &&
    left.day == right.day;
String _date(DateTime value) =>
    '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';

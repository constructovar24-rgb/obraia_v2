import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/planificacion_obra.dart';
import '../providers/planificacion_obra_providers.dart';

class PlanificacionObraTab extends ConsumerWidget {
  const PlanificacionObraTab({super.key, required this.expedienteId});
  final String expedienteId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planning = ref.watch(planificacionObraProvider(expedienteId));
    final actions = ref.watch(actuacionesObraProvider(expedienteId));
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        planning.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Text('No se pudo cargar: $error'),
          data: (value) => value == null
              ? const Text('La obra no existe.')
              : _PlanningCard(expedienteId: expedienteId, value: value),
        ),
        const SizedBox(height: AppSpacing.md),
        actions.when(
          loading: () => const LinearProgressIndicator(),
          error: (error, _) =>
              Text('No se pudieron cargar las actuaciones: $error'),
          data: (items) =>
              _ActionsCard(expedienteId: expedienteId, items: items),
        ),
      ],
    );
  }
}

class _PlanningCard extends ConsumerWidget {
  const _PlanningCard({required this.expedienteId, required this.value});
  final String expedienteId;
  final PlanificacionObra value;

  @override
  Widget build(BuildContext context, WidgetRef ref) => AppCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Estado y calendario',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppSpacing.sm),
        DropdownButtonFormField<EstadoOperativoObra>(
          key: const ValueKey('estado-operativo'),
          initialValue: value.estado,
          decoration: const InputDecoration(labelText: 'Situación actual'),
          items: EstadoOperativoObra.values
              .map(
                (state) =>
                    DropdownMenuItem(value: state, child: Text(_state(state))),
              )
              .toList(),
          onChanged: (state) async {
            if (state == null) return;
            DateTime? end = value.finReal;
            if (state == EstadoOperativoObra.finalizada && end == null) {
              end = await showDatePicker(
                context: context,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                initialDate: DateTime.now(),
                helpText: 'Fecha real de finalización',
              );
              if (end == null) return;
            }
            await ref
                .read(planificacionObraRepositoryProvider)
                .cambiarEstado(expedienteId, state, finReal: end);
          },
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.sm,
          children: [
            _date('Inicio previsto', value.inicioPrevisto),
            _date('Fin previsto', value.finPrevisto),
            _date('Inicio real', value.inicioReal),
            _date('Fin real', value.finReal),
          ],
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            key: const ValueKey('editar-calendario'),
            onPressed: () => _editCalendar(context, ref),
            icon: const Icon(Icons.edit_calendar_outlined),
            label: const Text('Editar calendario'),
          ),
        ),
      ],
    ),
  );

  Future<void> _editCalendar(BuildContext context, WidgetRef ref) async {
    final dates = [
      value.inicioPrevisto,
      value.finPrevisto,
      value.inicioReal,
      value.finReal,
    ];
    final result = await showDialog<List<DateTime?>>(
      context: context,
      builder: (context) => _CalendarDialog(initial: dates),
    );
    if (result == null) return;
    await ref
        .read(planificacionObraRepositoryProvider)
        .guardarCalendario(
          expedienteId: expedienteId,
          inicioPrevisto: result[0],
          finPrevisto: result[1],
          inicioReal: result[2],
          finReal: result[3],
        );
  }
}

class _ActionsCard extends ConsumerWidget {
  const _ActionsCard({required this.expedienteId, required this.items});
  final String expedienteId;
  final List<ActuacionObra> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final next = items
        .where(
          (a) =>
              a.tipo == TipoActuacionObra.proximoPaso &&
              a.estado == EstadoActuacionObra.pendiente,
        )
        .firstOrNull;
    final milestones = items
        .where((a) => a.tipo == TipoActuacionObra.actuacion)
        .toList();
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Próximo paso', style: Theme.of(context).textTheme.titleLarge),
          Text(next?.descripcion ?? 'No definido'),
          if (next?.fechaPrevista != null) Text(_format(next!.fechaPrevista!)),
          if (next != null)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                key: const ValueKey('completar-proximo-paso'),
                onPressed: () => ref
                    .read(planificacionObraRepositoryProvider)
                    .cambiarEstadoActuacion(
                      next,
                      EstadoActuacionObra.completado,
                    ),
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Marcar completado'),
              ),
            ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              key: const ValueKey('definir-proximo-paso'),
              onPressed: () => _newItem(context, ref, true),
              icon: const Icon(Icons.next_plan_outlined),
              label: const Text('Definir próximo paso'),
            ),
          ),
          const Divider(),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Próximas actuaciones',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              IconButton(
                key: const ValueKey('nueva-actuacion'),
                tooltip: 'Nueva actuación',
                onPressed: () => _newItem(context, ref, false),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          if (milestones.isEmpty) const Text('No hay actuaciones previstas.'),
          ...milestones.map(
            (item) => Material(
              type: MaterialType.transparency,
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(item.descripcion),
                subtitle: Text(
                  '${_stateAction(item.estado)}${item.fechaPrevista == null ? '' : ' · ${_format(item.fechaPrevista!)}'}',
                ),
                trailing: item.estado != EstadoActuacionObra.pendiente
                    ? null
                    : PopupMenuButton<EstadoActuacionObra>(
                        onSelected: (state) => ref
                            .read(planificacionObraRepositoryProvider)
                            .cambiarEstadoActuacion(item, state),
                        itemBuilder: (_) => const [
                          PopupMenuItem(
                            value: EstadoActuacionObra.completado,
                            child: Text('Completar'),
                          ),
                          PopupMenuItem(
                            value: EstadoActuacionObra.cancelado,
                            child: Text('Cancelar'),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _newItem(BuildContext context, WidgetRef ref, bool next) async {
    final result = await showDialog<_NewItem>(
      context: context,
      builder: (_) =>
          _ItemDialog(title: next ? 'Próximo paso' : 'Nueva actuación'),
    );
    if (result == null) return;
    final repository = ref.read(planificacionObraRepositoryProvider);
    if (next) {
      await repository.guardarProximoPaso(
        expedienteId: expedienteId,
        descripcion: result.description,
        fechaPrevista: result.date,
      );
    } else {
      await repository.crearActuacion(
        expedienteId: expedienteId,
        descripcion: result.description,
        fechaPrevista: result.date,
        orden: items.length,
      );
    }
  }
}

class _ItemDialog extends StatefulWidget {
  const _ItemDialog({required this.title});
  final String title;
  @override
  State<_ItemDialog> createState() => _ItemDialogState();
}

class _ItemDialogState extends State<_ItemDialog> {
  final controller = TextEditingController();
  DateTime? date;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.title),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Descripción'),
        ),
        TextButton(
          onPressed: () async {
            final value = await showDatePicker(
              context: context,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              initialDate: date ?? DateTime.now(),
            );
            if (value != null) setState(() => date = value);
          },
          child: Text(date == null ? 'Añadir fecha prevista' : _format(date!)),
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
          if (controller.text.trim().isNotEmpty) {
            Navigator.pop(context, _NewItem(controller.text.trim(), date));
          }
        },
        child: const Text('Guardar'),
      ),
    ],
  );
}

class _CalendarDialog extends StatefulWidget {
  const _CalendarDialog({required this.initial});
  final List<DateTime?> initial;
  @override
  State<_CalendarDialog> createState() => _CalendarDialogState();
}

class _CalendarDialogState extends State<_CalendarDialog> {
  late final List<DateTime?> dates = [...widget.initial];
  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Calendario de obra'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        4,
        (index) => ListTile(
          title: Text(
            const [
              'Inicio previsto',
              'Fin previsto',
              'Inicio real',
              'Fin real',
            ][index],
          ),
          subtitle: Text(
            dates[index] == null ? 'Sin fecha' : _format(dates[index]!),
          ),
          onTap: () async {
            final value = await showDatePicker(
              context: context,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              initialDate: dates[index] ?? DateTime.now(),
            );
            if (value != null) setState(() => dates[index] = value);
          },
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancelar'),
      ),
      FilledButton(
        onPressed: () => Navigator.pop(context, dates),
        child: const Text('Guardar'),
      ),
    ],
  );
}

class _NewItem {
  const _NewItem(this.description, this.date);
  final String description;
  final DateTime? date;
}

Widget _date(String label, DateTime? value) => SizedBox(
  width: 220,
  child: ListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(label),
    subtitle: Text(value == null ? 'Sin fecha' : _format(value)),
  ),
);
String _format(DateTime value) =>
    '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';
String _state(EstadoOperativoObra value) => switch (value) {
  EstadoOperativoObra.pendiente => 'Pendiente / programación',
  EstadoOperativoObra.preparada => 'Preparada',
  EstadoOperativoObra.enEjecucion => 'En ejecución',
  EstadoOperativoObra.pausada => 'Pausada',
  EstadoOperativoObra.finalizada => 'Finalizada',
  EstadoOperativoObra.cancelada => 'Cancelada',
};
String _stateAction(EstadoActuacionObra value) => switch (value) {
  EstadoActuacionObra.pendiente => 'Pendiente',
  EstadoActuacionObra.completado => 'Completada',
  EstadoActuacionObra.cancelado => 'Cancelada',
};

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/ui/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../diario_obra/domain/entrada_diario_obra.dart';
import '../../../diario_obra/presentation/providers/diario_obra_providers.dart';
import '../../../documentos/domain/documento.dart';
import '../../../documentos/presentation/providers/documento_providers.dart';
import '../../domain/incidencia_obra.dart';
import '../providers/incidencias_obra_providers.dart';

class IncidenciasObraTab extends ConsumerWidget {
  const IncidenciasObraTab({super.key, required this.expedienteId});

  final String expedienteId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rows = ref.watch(incidenciasObraProvider(expedienteId));
    final documents =
        ref.watch(documentosPorExpedienteProvider(expedienteId)).valueOrNull ??
        const <Documento>[];
    final diary =
        ref.watch(entradasDiarioObraProvider(expedienteId)).valueOrNull ??
        const <EntradaDiarioObra>[];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Incidencias',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              FilledButton.icon(
                key: const ValueKey('nueva-incidencia'),
                onPressed: () => _openEditor(context, documents, diary),
                icon: const Icon(Icons.add),
                label: const Text('Nueva incidencia'),
              ),
            ],
          ),
        ),
        Expanded(
          child: rows.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(
              child: Text('No se pudieron cargar las incidencias: $error'),
            ),
            data: (items) => items.isEmpty
                ? const Center(child: Text('No hay incidencias registradas.'))
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
                    itemBuilder: (context, index) {
                      final row = items[index];
                      return _IncidentCard(
                        incident: row,
                        evidenceNames: documents
                            .where((doc) => row.documentoIds.contains(doc.id))
                            .map((doc) => doc.titulo)
                            .toList(),
                        diaryCount: row.entradaDiarioIds.length,
                        onEdit: () => _openEditor(
                          context,
                          documents,
                          diary,
                          incident: row,
                        ),
                        onState: (state) =>
                            _changeState(context, ref, row, state),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> _openEditor(
    BuildContext context,
    List<Documento> documents,
    List<EntradaDiarioObra> diary, {
    IncidenciaObra? incident,
  }) => showDialog<void>(
    context: context,
    builder: (_) => _IncidentEditor(
      expedienteId: expedienteId,
      incident: incident,
      documents: documents,
      diary: diary.where((entry) => !entry.anulado).toList(),
    ),
  );

  Future<void> _changeState(
    BuildContext context,
    WidgetRef ref,
    IncidenciaObra incident,
    EstadoIncidenciaObra state,
  ) async {
    String? solution;
    if (state == EstadoIncidenciaObra.resuelta) {
      var proposedSolution = '';
      solution = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Resolver incidencia'),
          content: TextField(
            key: const ValueKey('resolucion-incidencia'),
            maxLines: 3,
            onChanged: (value) => proposedSolution = value,
            decoration: const InputDecoration(
              labelText: 'Resolución o solución (opcional)',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Volver'),
            ),
            FilledButton(
              key: const ValueKey('confirmar-resolucion'),
              onPressed: () => Navigator.pop(context, proposedSolution),
              child: const Text('Resolver'),
            ),
          ],
        ),
      );
      if (solution == null) return;
    }
    await ref
        .read(incidenciasObraRepositoryProvider)
        .cambiarEstado(incident.id, state, resolucion: solution);
  }
}

class _IncidentCard extends StatelessWidget {
  const _IncidentCard({
    required this.incident,
    required this.evidenceNames,
    required this.diaryCount,
    required this.onEdit,
    required this.onState,
  });

  final IncidenciaObra incident;
  final List<String> evidenceNames;
  final int diaryCount;
  final VoidCallback onEdit;
  final ValueChanged<EstadoIncidenciaObra> onState;

  @override
  Widget build(BuildContext context) => AppCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                incident.titulo,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Chip(label: Text(_priority(incident.prioridad))),
            const SizedBox(width: 8),
            Chip(label: Text(_state(incident.estado))),
            IconButton(
              key: ValueKey('editar-incidencia-${incident.id}'),
              tooltip: 'Editar',
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined),
            ),
            PopupMenuButton<EstadoIncidenciaObra>(
              key: ValueKey('estado-incidencia-${incident.id}'),
              tooltip: 'Cambiar estado',
              onSelected: onState,
              itemBuilder: (_) => EstadoIncidenciaObra.values
                  .where((state) => state != incident.estado)
                  .map(
                    (state) =>
                        PopupMenuItem(value: state, child: Text(_state(state))),
                  )
                  .toList(),
            ),
          ],
        ),
        Text(_date(incident.fechaDeteccion)),
        Text(incident.descripcion),
        if (incident.resolucion != null)
          Text('Resolución: ${incident.resolucion}'),
        Text(
          'Evidencias: ${evidenceNames.length} · Jornadas relacionadas: $diaryCount',
        ),
        if (evidenceNames.isNotEmpty) Text(evidenceNames.join(' · ')),
      ],
    ),
  );
}

class _IncidentEditor extends ConsumerStatefulWidget {
  const _IncidentEditor({
    required this.expedienteId,
    required this.incident,
    required this.documents,
    required this.diary,
  });

  final String expedienteId;
  final IncidenciaObra? incident;
  final List<Documento> documents;
  final List<EntradaDiarioObra> diary;

  @override
  ConsumerState<_IncidentEditor> createState() => _IncidentEditorState();
}

class _IncidentEditorState extends ConsumerState<_IncidentEditor> {
  final formKey = GlobalKey<FormState>();
  late final title = TextEditingController(text: widget.incident?.titulo);
  late final description = TextEditingController(
    text: widget.incident?.descripcion,
  );
  late DateTime date = widget.incident?.fechaDeteccion ?? DateTime.now();
  late PrioridadIncidenciaObra priority =
      widget.incident?.prioridad ?? PrioridadIncidenciaObra.media;
  late final selectedDocuments = {...?widget.incident?.documentoIds};
  late final selectedDiary = {...?widget.incident?.entradaDiarioIds};
  bool saving = false;

  @override
  void dispose() {
    title.dispose();
    description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(
      widget.incident == null ? 'Nueva incidencia' : 'Editar incidencia',
    ),
    content: SizedBox(
      width: 620,
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Fecha de detección'),
                subtitle: Text(_date(date)),
                trailing: const Icon(Icons.calendar_today_outlined),
                onTap: _selectDate,
              ),
              TextFormField(
                key: const ValueKey('titulo-incidencia'),
                controller: title,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: _required,
              ),
              TextFormField(
                key: const ValueKey('descripcion-incidencia'),
                controller: description,
                minLines: 3,
                maxLines: 6,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: _required,
              ),
              DropdownButtonFormField<PrioridadIncidenciaObra>(
                initialValue: priority,
                decoration: const InputDecoration(labelText: 'Prioridad'),
                items: PrioridadIncidenciaObra.values
                    .map(
                      (value) => DropdownMenuItem(
                        value: value,
                        child: Text(_priority(value)),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => priority = value!),
              ),
              if (widget.documents.isNotEmpty)
                ExpansionTile(
                  title: Text('Evidencias (${selectedDocuments.length})'),
                  children: widget.documents
                      .map(
                        (document) => CheckboxListTile(
                          value: selectedDocuments.contains(document.id),
                          title: Text(document.titulo),
                          subtitle: Text(document.nombreArchivo),
                          onChanged: (checked) => setState(() {
                            checked == true
                                ? selectedDocuments.add(document.id)
                                : selectedDocuments.remove(document.id);
                          }),
                        ),
                      )
                      .toList(),
                ),
              if (widget.diary.isNotEmpty)
                ExpansionTile(
                  title: Text('Diario (${selectedDiary.length})'),
                  children: widget.diary
                      .map(
                        (entry) => CheckboxListTile(
                          value: selectedDiary.contains(entry.id),
                          title: Text(_date(entry.fechaTrabajo)),
                          subtitle: Text(
                            entry.trabajos,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onChanged: (checked) => setState(() {
                            checked == true
                                ? selectedDiary.add(entry.id)
                                : selectedDiary.remove(entry.id);
                          }),
                        ),
                      )
                      .toList(),
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
        key: const ValueKey('guardar-incidencia'),
        onPressed: saving ? null : _save,
        child: Text(saving ? 'Guardando…' : 'Guardar'),
      ),
    ],
  );

  Future<void> _selectDate() async {
    final selected = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDate: date,
    );
    if (selected != null) setState(() => date = selected);
  }

  Future<void> _save() async {
    if (saving || !(formKey.currentState?.validate() ?? false)) return;
    setState(() => saving = true);
    final repository = ref.read(incidenciasObraRepositoryProvider);
    try {
      if (widget.incident == null) {
        await repository.crear(
          expedienteId: widget.expedienteId,
          fechaDeteccion: date,
          titulo: title.text,
          descripcion: description.text,
          prioridad: priority,
          documentoIds: selectedDocuments.toList(),
          entradaDiarioIds: selectedDiary.toList(),
        );
      } else {
        await repository.editar(
          id: widget.incident!.id,
          fechaDeteccion: date,
          titulo: title.text,
          descripcion: description.text,
          prioridad: priority,
          documentoIds: selectedDocuments.toList(),
          entradaDiarioIds: selectedDiary.toList(),
        );
      }
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) setState(() => saving = false);
      rethrow;
    }
  }
}

String? _required(String? value) =>
    value == null || value.trim().isEmpty ? 'Campo obligatorio.' : null;
String _date(DateTime value) =>
    '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';
String _state(EstadoIncidenciaObra value) => switch (value) {
  EstadoIncidenciaObra.abierta => 'Abierta',
  EstadoIncidenciaObra.enSeguimiento => 'En seguimiento',
  EstadoIncidenciaObra.resuelta => 'Resuelta',
  EstadoIncidenciaObra.cancelada => 'Cancelada',
};
String _priority(PrioridadIncidenciaObra value) => switch (value) {
  PrioridadIncidenciaObra.baja => 'Baja',
  PrioridadIncidenciaObra.media => 'Media',
  PrioridadIncidenciaObra.alta => 'Alta',
};

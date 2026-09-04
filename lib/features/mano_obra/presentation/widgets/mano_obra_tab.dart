import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/confirm_dialog.dart';
import '../../domain/mano_obra.dart';
import '../providers/mano_obra_providers.dart';

class ManoObraTab extends ConsumerWidget {
  const ManoObraTab({super.key, required this.expedienteId});
  final String expedienteId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personas = ref.watch(personasLaboralesProvider);
    final partes = ref.watch(partesTrabajoObraProvider(expedienteId));
    final resumen = ref.watch(resumenManoObraProvider(expedienteId));
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'Mano de obra',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              OutlinedButton.icon(
                onPressed: () => _gestionarPersonas(
                  context,
                  ref,
                  personas.value ?? const [],
                ),
                icon: const Icon(Icons.people_outline),
                label: const Text('Personas y tarifas'),
              ),
              FilledButton.icon(
                onPressed:
                    (personas.value ?? const []).where((p) => p.activa).isEmpty
                    ? null
                    : () => _nuevoParte(context, ref, personas.value!),
                icon: const Icon(Icons.add),
                label: const Text('Registrar horas'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          resumen.when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('No se pudo calcular el resumen: $e'),
            data: (r) => Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Wrap(
                  spacing: 24,
                  runSpacing: 8,
                  children: [
                    Text('Horas: ${_horas(r.horasTotalesDiezMilesimas)}'),
                    Text('Coste real: ${_euros(r.costeRealCentimos)}'),
                    Text(
                      'Horas sin valorar: ${_horas(r.horasSinValorarDiezMilesimas)}',
                    ),
                    Text('Cobertura: ${_cobertura(r.cobertura)}'),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: partes.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) =>
                  Center(child: Text('No se pudieron cargar los partes: $e')),
              data: (items) => items.isEmpty
                  ? const Center(
                      child: Text(
                        'Todavía no hay horas registradas en esta obra.',
                      ),
                    )
                  : ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final p = items[index];
                        final persona = (personas.value ?? const [])
                            .where((x) => x.id == p.personaId)
                            .firstOrNull;
                        return ListTile(
                          leading: Icon(
                            p.estado == EstadoParteTrabajo.pendienteValoracion
                                ? Icons.schedule
                                : p.estado == EstadoParteTrabajo.revertido
                                ? Icons.undo
                                : Icons.check_circle_outline,
                          ),
                          title: Text(
                            '${persona?.nombre ?? 'Persona'} · ${_horas(p.horasDiezMilesimas)} h',
                          ),
                          subtitle: Text(
                            '${_fecha(p.fechaTrabajo)} · ${p.descripcionTrabajo}\n${_estado(p)}',
                          ),
                          isThreeLine: true,
                          trailing:
                              p.estado == EstadoParteTrabajo.pendienteValoracion
                              ? TextButton(
                                  onPressed: () =>
                                      _completar(context, ref, p.id),
                                  child: const Text('Valorar'),
                                )
                              : p.estado == EstadoParteTrabajo.valorado
                              ? TextButton(
                                  onPressed: () =>
                                      _revertir(context, ref, p.id),
                                  child: const Text('Revertir'),
                                )
                              : null,
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _gestionarPersonas(
    BuildContext context,
    WidgetRef ref,
    List<PersonaLaboral> personas,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Personas y tarifas internas'),
        content: SizedBox(
          width: 620,
          height: 420,
          child: Column(
            children: [
              const Text(
                'La tarifa interna es coste económico; no es el precio cobrado al cliente.',
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView(
                  children: personas
                      .map(
                        (persona) => ListTile(
                          title: Text(persona.nombre),
                          subtitle: Text(
                            '${_tipo(persona.tipo)} · ${persona.activa ? 'Activa' : 'Inactiva'}',
                          ),
                          trailing: Wrap(
                            children: [
                              IconButton(
                                tooltip: 'Editar persona',
                                onPressed: () async {
                                  Navigator.pop(dialogContext);
                                  await _editarPersona(context, ref, persona);
                                },
                                icon: const Icon(Icons.edit_outlined),
                              ),
                              IconButton(
                                tooltip: 'Historial de tarifas',
                                onPressed: () async {
                                  Navigator.pop(dialogContext);
                                  await _tarifas(context, ref, persona);
                                },
                                icon: const Icon(Icons.euro_outlined),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cerrar'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await _editarPersona(context, ref, null);
            },
            child: const Text('Nueva persona'),
          ),
        ],
      ),
    );
  }

  Future<void> _editarPersona(
    BuildContext context,
    WidgetRef ref,
    PersonaLaboral? persona,
  ) async {
    final nombre = TextEditingController(text: persona?.nombre);
    final observaciones = TextEditingController(text: persona?.observaciones);
    var tipo = persona?.tipo ?? TipoPersonaLaboral.empleado;
    var activa = persona?.activa ?? true;
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (_, setState) => AlertDialog(
          title: Text(persona == null ? 'Nueva persona' : 'Editar persona'),
          content: SizedBox(
            width: 460,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombre,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                ),
                DropdownButtonFormField<TipoPersonaLaboral>(
                  initialValue: tipo,
                  decoration: const InputDecoration(labelText: 'Tipo'),
                  items: TipoPersonaLaboral.values
                      .map(
                        (t) =>
                            DropdownMenuItem(value: t, child: Text(_tipo(t))),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => tipo = v!),
                ),
                TextField(
                  controller: observaciones,
                  decoration: const InputDecoration(labelText: 'Observaciones'),
                ),
                SwitchListTile(
                  value: activa,
                  onChanged: (v) => setState(() => activa = v),
                  title: const Text('Activa'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
    if (ok != true || !context.mounted) return;
    try {
      await ref
          .read(manoObraRepositoryProvider)
          .guardarPersona(
            id: persona?.id,
            nombre: nombre.text,
            tipo: tipo,
            activa: activa,
            observaciones: observaciones.text,
          );
    } catch (e) {
      if (context.mounted) _error(context, e);
    }
  }

  Future<void> _tarifas(
    BuildContext context,
    WidgetRef ref,
    PersonaLaboral persona,
  ) async {
    final repository = ref.read(manoObraRepositoryProvider);
    final historial = await repository.obtenerTarifas(persona.id);
    if (!context.mounted) return;
    final importe = TextEditingController();
    final nota = TextEditingController();
    final agregar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Tarifas de ${persona.nombre}'),
        content: SizedBox(
          width: 520,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Coste interno por hora. No se usa como precio de venta.',
              ),
              ...historial.map(
                (t) => ListTile(
                  title: Text('${_euros(t.importeHoraCentimos)}/h'),
                  subtitle: Text(
                    'Desde ${_fecha(t.vigenteDesde)}${t.vigenteHasta == null ? '' : ' hasta ${_fecha(t.vigenteHasta!)}'}',
                  ),
                ),
              ),
              TextField(
                controller: importe,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Nueva tarifa €/h',
                ),
              ),
              TextField(
                controller: nota,
                decoration: const InputDecoration(labelText: 'Nota opcional'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cerrar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Añadir desde hoy'),
          ),
        ],
      ),
    );
    if (agregar != true || !context.mounted) return;
    final value = double.tryParse(importe.text.replaceAll(',', '.'));
    if (value == null || value < 0) {
      return _error(context, 'Introduce una tarifa válida.');
    }
    try {
      await repository.agregarTarifa(
        personaId: persona.id,
        importeHoraCentimos: (value * 100).round(),
        vigenteDesde: DateUtils.dateOnly(DateTime.now()),
        nota: nota.text,
      );
    } catch (e) {
      if (context.mounted) _error(context, e);
    }
  }

  Future<void> _nuevoParte(
    BuildContext context,
    WidgetRef ref,
    List<PersonaLaboral> personas,
  ) async {
    final activas = personas.where((p) => p.activa).toList();
    var personaId = activas.first.id;
    var fecha = DateUtils.dateOnly(DateTime.now());
    PartidaManoObra? partida;
    final repository = ref.read(manoObraRepositoryProvider);
    final partidas = await repository.obtenerPartidasObra(expedienteId);
    final horas = TextEditingController();
    final descripcion = TextEditingController();
    if (!context.mounted) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (_, setState) => AlertDialog(
          title: const Text('Registrar horas reales'),
          content: SizedBox(
            width: 520,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: personaId,
                  decoration: const InputDecoration(labelText: 'Persona'),
                  items: activas
                      .map(
                        (p) => DropdownMenuItem(
                          value: p.id,
                          child: Text(p.nombre),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => personaId = v!),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Fecha del trabajo'),
                  subtitle: Text(_fecha(fecha)),
                  trailing: const Icon(Icons.calendar_today_outlined),
                  onTap: () async {
                    final selected = await showDatePicker(
                      context: dialogContext,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      initialDate: fecha,
                    );
                    if (selected != null) setState(() => fecha = selected);
                  },
                ),
                TextField(
                  controller: horas,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(labelText: 'Horas'),
                ),
                TextField(
                  controller: descripcion,
                  decoration: const InputDecoration(
                    labelText: 'Trabajo realizado',
                  ),
                ),
                DropdownButtonFormField<PartidaManoObra?>(
                  initialValue: partida,
                  decoration: const InputDecoration(
                    labelText: 'Partida del plan (opcional)',
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('Sin asignar'),
                    ),
                    ...partidas.map(
                      (p) => DropdownMenuItem(
                        value: p,
                        child: Text(p.descripcion),
                      ),
                    ),
                  ],
                  onChanged: (v) => setState(() => partida = v),
                ),
                const SizedBox(height: 8),
                FutureBuilder<TarifaPersona?>(
                  future: repository.obtenerTarifaAplicable(personaId, fecha),
                  builder: (_, snapshot) => Text(
                    snapshot.data == null
                        ? 'Sin tarifa: las horas se registrarán, pero el coste quedará pendiente de valorar.'
                        : 'Tarifa interna aplicable: ${_euros(snapshot.data!.importeHoraCentimos)}/h. Al confirmar contará como coste real.',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Confirmar'),
            ),
          ],
        ),
      ),
    );
    if (ok != true || !context.mounted) return;
    final value = double.tryParse(horas.text.replaceAll(',', '.'));
    if (value == null || value <= 0 || descripcion.text.trim().isEmpty) {
      return _error(context, 'Indica horas positivas y una descripción.');
    }
    try {
      await repository.registrarParte(
        expedienteId: expedienteId,
        personaId: personaId,
        fechaTrabajo: fecha,
        horasDiezMilesimas: (value * 10000).round(),
        descripcionTrabajo: descripcion.text,
        planEconomicoId: partida?.planId,
        planEconomicoPartidaId: partida?.id,
      );
    } catch (e) {
      if (context.mounted) _error(context, e);
    }
  }

  Future<void> _completar(
    BuildContext context,
    WidgetRef ref,
    String id,
  ) async {
    try {
      await ref.read(manoObraRepositoryProvider).completarValoracion(id);
    } catch (e) {
      if (context.mounted) _error(context, e);
    }
  }

  Future<void> _revertir(BuildContext context, WidgetRef ref, String id) async {
    final ok = await ConfirmDialog.show(
      context,
      title: 'Revertir parte',
      message:
          'Se conservará el histórico y se generará un contramovimiento del coste.',
      confirmLabel: 'Revertir',
    );
    if (!ok || !context.mounted) return;
    try {
      await ref
          .read(manoObraRepositoryProvider)
          .revertirParte(id, motivo: 'Parte revertido por el usuario');
    } catch (e) {
      if (context.mounted) _error(context, e);
    }
  }

  static void _error(BuildContext context, Object error) =>
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
  static String _fecha(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  static String _euros(int cents) => '${(cents / 100).toStringAsFixed(2)} €';
  static String _horas(int value) => (value / 10000).toStringAsFixed(2);
  static String _tipo(TipoPersonaLaboral tipo) => switch (tipo) {
    TipoPersonaLaboral.titular => 'Titular/autónomo',
    TipoPersonaLaboral.empleado => 'Empleado',
    TipoPersonaLaboral.colaboradorInterno => 'Colaborador interno',
    TipoPersonaLaboral.otroInterno => 'Otro interno',
  };
  static String _estado(ParteTrabajo p) => switch (p.estado) {
    EstadoParteTrabajo.pendienteValoracion => 'Coste pendiente de valorar',
    EstadoParteTrabajo.valorado =>
      'Coste ${_euros(p.costeSnapshotCentimos!)} · tarifa congelada ${_euros(p.tarifaHoraSnapshotCentimos!)}/h',
    EstadoParteTrabajo.revertido =>
      'Revertido · coste histórico ${_euros(p.costeSnapshotCentimos!)}',
  };
  static String _cobertura(CoberturaManoObra value) => switch (value) {
    CoberturaManoObra.sinHoras => 'Sin horas',
    CoberturaManoObra.completa => 'Completa',
    CoberturaManoObra.parcial => 'Parcial',
    CoberturaManoObra.sinValorar => 'Sin valorar',
  };
}

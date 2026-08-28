import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/shortcuts/app_shortcuts.dart';
import '../../../clientes/domain/cliente.dart';
import '../../data/expediente_repository.dart';
import '../../domain/expediente.dart';
import '../providers/edicion_expediente_providers.dart';

class EditarExpedienteScreen extends ConsumerStatefulWidget {
  const EditarExpedienteScreen({super.key, required this.expediente});
  final Expediente expediente;

  @override
  ConsumerState<EditarExpedienteScreen> createState() =>
      _EditarExpedienteScreenState();
}

class _EditarExpedienteScreenState
    extends ConsumerState<EditarExpedienteScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codigoController;
  late final TextEditingController _nombreController;
  late String? _clienteId;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _codigoController = TextEditingController(text: widget.expediente.codigo);
    _nombreController = TextEditingController(text: widget.expediente.nombre);
    _clienteId = widget.expediente.clienteId;
  }

  @override
  void dispose() {
    _codigoController.dispose();
    _nombreController.dispose();
    super.dispose();
  }

  Future<void> _guardar(List<Cliente> clientes) async {
    if (_guardando || !_formKey.currentState!.validate()) return;

    final cliente = _clienteId == null
        ? null
        : clientes.where((item) => item.id == _clienteId).firstOrNull;
    if (_clienteId != null && cliente == null) {
      _mostrarError(
        'El cliente seleccionado ya no está disponible. '
        'Elige otro cliente o quítalo antes de guardar.',
      );
      return;
    }

    setState(() => _guardando = true);
    try {
      await ref
          .read(expedienteRepositoryProvider)
          .actualizarDatosPrincipales(
            id: widget.expediente.id,
            codigo: _codigoController.text.trim(),
            nombre: _nombreController.text.trim(),
            clienteId: cliente?.id,
            cliente: cliente == null
                ? null
                : '${cliente.nombre} ${cliente.apellidos}'.trim(),
          );

      if (mounted) Navigator.of(context).pop();
    } catch (error) {
      if (mounted) {
        _mostrarError(
          error is ExpedienteNoEncontradoException
              ? error.toString()
              : 'No se pudieron guardar los cambios. Inténtalo de nuevo.',
        );
      }
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(mensaje)));
  }

  @override
  Widget build(BuildContext context) {
    final clientesAsync = ref.watch(clientesEdicionExpedienteProvider);
    final expedienteAsync = ref.watch(expedienteProvider(widget.expediente.id));

    return clientesAsync.when(
      loading: () =>
          _scaffoldEstado(const Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) => _scaffoldEstado(
        _MensajeEstado(
          mensaje: 'No se pudieron cargar los clientes.',
          onReintentar: () => ref.invalidate(clientesEdicionExpedienteProvider),
        ),
      ),
      data: (clientes) => expedienteAsync.when(
        loading: () =>
            _scaffoldEstado(const Center(child: CircularProgressIndicator())),
        error: (error, stackTrace) => _scaffoldEstado(
          _MensajeEstado(
            mensaje: 'No se pudo comprobar el expediente.',
            onReintentar: () =>
                ref.invalidate(expedienteProvider(widget.expediente.id)),
          ),
        ),
        data: (expedienteActual) {
          if (expedienteActual == null) {
            return _scaffoldEstado(
              const _MensajeEstado(
                mensaje: 'El expediente ya no existe o no está disponible.',
              ),
            );
          }

          final cambioExterno =
              expedienteActual.codigo != widget.expediente.codigo ||
              expedienteActual.nombre != widget.expediente.nombre ||
              expedienteActual.clienteId != widget.expediente.clienteId ||
              expedienteActual.estadoCiclo != widget.expediente.estadoCiclo;

          return _formulario(clientes, cambioExterno);
        },
      ),
    );
  }

  Widget _formulario(List<Cliente> clientes, bool cambioExterno) {
    final clienteDisponible =
        _clienteId == null ||
        clientes.any((cliente) => cliente.id == _clienteId);
    final clienteSeleccionado = clienteDisponible ? _clienteId : null;
    final puedeGuardar = !_guardando && !cambioExterno;

    return AppShortcutScope(
      onBack: () => Navigator.maybePop(context),
      onSave: puedeGuardar ? () => _guardar(clientes) : null,
      child: Scaffold(
        appBar: AppBar(title: const Text('Editar expediente')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (cambioExterno) ...[
                  const _Aviso(
                    mensaje:
                        'El expediente cambió mientras lo editabas. Vuelve a '
                        'la ficha y abre de nuevo la edición para no sobrescribir cambios.',
                  ),
                  const SizedBox(height: 20),
                ],
                TextFormField(
                  controller: _codigoController,
                  enabled: !_guardando,
                  decoration: const InputDecoration(labelText: 'Código'),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'El código es obligatorio'
                      : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nombreController,
                  enabled: !_guardando,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'El nombre es obligatorio'
                      : null,
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  key: ValueKey(clienteSeleccionado),
                  initialValue: clienteSeleccionado,
                  decoration: const InputDecoration(labelText: 'Cliente'),
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('Sin cliente'),
                    ),
                    ...clientes.map(
                      (cliente) => DropdownMenuItem(
                        value: cliente.id,
                        child: Text(
                          '${cliente.nombre} ${cliente.apellidos}'.trim(),
                        ),
                      ),
                    ),
                  ],
                  onChanged: puedeGuardar
                      ? (value) => setState(() => _clienteId = value)
                      : null,
                ),
                if (!clienteDisponible) ...[
                  const SizedBox(height: 12),
                  _Aviso(
                    mensaje:
                        'El cliente seleccionado ya no está disponible. '
                        'Elige otro o quítalo de este expediente.',
                    accion: TextButton(
                      onPressed: puedeGuardar
                          ? () => setState(() => _clienteId = null)
                          : null,
                      child: const Text('Quitar cliente'),
                    ),
                  ),
                ],
                const SizedBox(height: 30),
                FilledButton.icon(
                  onPressed: puedeGuardar && clienteDisponible
                      ? () => _guardar(clientes)
                      : null,
                  icon: _guardando
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  label: const Text('Guardar cambios'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _scaffoldEstado(Widget body) {
    return AppShortcutScope(
      onBack: () => Navigator.maybePop(context),
      child: Scaffold(
        appBar: AppBar(title: const Text('Editar expediente')),
        body: body,
      ),
    );
  }
}

class _Aviso extends StatelessWidget {
  const _Aviso({required this.mensaje, this.accion});
  final String mensaje;
  final Widget? accion;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.errorContainer,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(mensaje),
            if (accion != null) ...[const SizedBox(height: 8), accion!],
          ],
        ),
      ),
    );
  }
}

class _MensajeEstado extends StatelessWidget {
  const _MensajeEstado({required this.mensaje, this.onReintentar});
  final String mensaje;
  final VoidCallback? onReintentar;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(mensaje, textAlign: TextAlign.center),
            if (onReintentar != null) ...[
              const SizedBox(height: 16),
              FilledButton(
                onPressed: onReintentar,
                child: const Text('Reintentar'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

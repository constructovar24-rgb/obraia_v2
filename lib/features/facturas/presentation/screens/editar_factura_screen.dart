import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/shortcuts/app_shortcuts.dart';
import '../../../../core/widgets/app_page_header.dart';
import '../../../../core/widgets/entity_summary_card.dart';
import '../../../../core/widgets/money_text.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../../database/database_provider.dart';
import '../../../clientes/data/cliente_repository.dart';
import '../../../clientes/domain/cliente.dart';
import '../../../cobros/data/cobro_repository.dart';
import '../../../cobros/domain/cobro.dart' as cobro_domain;
import '../../../cobros/domain/factura_estado_economico.dart';
import '../../../cobros/presentation/screens/cobros_screen.dart';
import '../../../cobros/presentation/screens/nuevo_cobro_screen.dart';
import '../../data/factura_linea_repository.dart';
import '../../data/factura_repository.dart';
import '../../domain/estado_factura.dart';
import '../../domain/factura.dart' as factura_domain;
import '../../domain/factura_linea.dart' as factura_linea_domain;
import 'factura_pdf_preview_screen.dart';
import 'editar_linea_factura_screen.dart';
import 'nueva_linea_factura_screen.dart';

class EditarFacturaScreen extends ConsumerStatefulWidget {
  const EditarFacturaScreen({
    super.key,
    required this.factura,
  });

  final factura_domain.Factura factura;

  @override
  ConsumerState<EditarFacturaScreen> createState() => _EditarFacturaScreenState();
}

class _EditarFacturaScreenState extends ConsumerState<EditarFacturaScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fechaController;
  late final TextEditingController _fechaVencimientoController;
  late final TextEditingController _observacionesController;

  late DateTime _fechaSeleccionada;
  late DateTime _fechaVencimientoSeleccionada;
  late EstadoFactura _estadoSeleccionado;
  String? _clienteSeleccionadoId;
  EstadoFactura? _estadoPersistido;
  bool? _tieneCobros;
  late final StreamSubscription<List<factura_domain.Factura>> _facturasSubscription;
  late final StreamSubscription<List<cobro_domain.Cobro>> _cobrosSubscription;

  EstadoFactura get _estadoActual => _estadoPersistido ?? _estadoSeleccionado;

  bool get _puedeEditarDocumento =>
      estadoFacturaPermiteEditarDocumento(_estadoActual);

  bool get _puedeEditarVencimiento =>
      estadoFacturaPermiteEditarVencimiento(_estadoActual);

  bool get _puedeEditarLineas =>
      estadoFacturaPermiteEditarLineas(_estadoActual);

  bool get _puedeEliminarFactura =>
      _estadoPersistido != null &&
      _tieneCobros != null &&
      facturaPuedeEliminarse(
        estado: _estadoPersistido!,
        tieneCobros: _tieneCobros!,
      );

  @override
  void initState() {
    super.initState();
    _fechaController = TextEditingController();
    _fechaVencimientoController = TextEditingController();
    _observacionesController = TextEditingController(
      text: widget.factura.observaciones,
    );
    _fechaSeleccionada = widget.factura.fecha;
    _fechaVencimientoSeleccionada = widget.factura.fechaVencimiento;
    _estadoSeleccionado = widget.factura.estado;
    _clienteSeleccionadoId = widget.factura.clienteId;
    _fechaController.text = _formatearFecha(_fechaSeleccionada);
    _fechaVencimientoController.text = _formatearFecha(
      _fechaVencimientoSeleccionada,
    );
    _facturasSubscription = ref
        .read(facturaRepositoryProvider)
        .observarFacturas()
        .listen((facturas) {
          factura_domain.Factura? persistida;
          for (final factura in facturas) {
            if (factura.id == widget.factura.id) {
              persistida = factura;
              break;
            }
          }
          if (!mounted) return;
          setState(() => _estadoPersistido = persistida?.estado);
        });
    _cobrosSubscription = ref
        .read(cobroRepositoryProvider)
        .observarPorFactura(widget.factura.id)
        .listen((cobros) {
          if (!mounted) return;
          setState(() => _tieneCobros = cobros.isNotEmpty);
        });
  }

  @override
  void dispose() {
    _facturasSubscription.cancel();
    _cobrosSubscription.cancel();
    _fechaController.dispose();
    _fechaVencimientoController.dispose();
    _observacionesController.dispose();
    super.dispose();
  }

  String _formatearFecha(DateTime fecha) {
    final day = fecha.day.toString().padLeft(2, '0');
    final month = fecha.month.toString().padLeft(2, '0');
    final year = fecha.year.toString();
    return '$day/$month/$year';
  }

  String _formatearMoneda(double value) {
    return '${value.toStringAsFixed(2).replaceAll('.', ',')} €';
  }

  String _formatearCantidad(double value) {
    if (value == value.truncateToDouble()) {
      return value.toStringAsFixed(0);
    }

    return value.toStringAsFixed(2).replaceAll('.', ',');
  }

  String _formatearPorcentaje(double value) {
    if (value == value.truncateToDouble()) {
      return value.toStringAsFixed(0);
    }

    return value.toStringAsFixed(2).replaceAll('.', ',');
  }

  StatusType _statusTypeFromEstadoEconomico(EstadoEconomicoFactura estado) {
    switch (estado) {
      case EstadoEconomicoFactura.pendiente:
        return StatusType.warning;
      case EstadoEconomicoFactura.parcialmenteCobrada:
        return StatusType.info;
      case EstadoEconomicoFactura.cobrada:
        return StatusType.success;
    }
  }

  StatusType _statusTypeFromEstadoFactura(EstadoFactura estado) {
    switch (estado) {
      case EstadoFactura.borrador:
        return StatusType.neutral;
      case EstadoFactura.emitida:
        return StatusType.info;
      case EstadoFactura.cobrada:
        return StatusType.success;
      case EstadoFactura.vencida:
        return StatusType.warning;
      case EstadoFactura.anulada:
        return StatusType.error;
    }
  }

  Widget _buildResumenEconomico(double totalFactura) {
    final cobroRepository = ref.read(cobroRepositoryProvider);

    return StreamBuilder<FacturaEstadoEconomico>(
      stream: cobroRepository.observarEstadoEconomicoFactura(
        facturaId: widget.factura.id,
        totalFactura: totalFactura,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SelectableText(
              'ERROR:\n\n${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final resumen = snapshot.data ??
            FacturaEstadoEconomico(
              totalFactura: totalFactura,
              totalCobrado: 0,
              pendiente: totalFactura,
              estado: EstadoEconomicoFactura.pendiente,
            );

        final textTheme = Theme.of(context).textTheme;
        final estadoLabel = estadoEconomicoFacturaToLabel(resumen.estado);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Resumen economico',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total factura'),
                MoneyText(
                  resumen.totalFactura,
                  style: textTheme.bodyLarge,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total cobrado'),
                MoneyText(
                  resumen.totalCobrado,
                  style: textTheme.bodyLarge,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Pendiente'),
                MoneyText(
                  resumen.pendiente,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Estado'),
                StatusChip(
                  label: estadoLabel,
                  type: _statusTypeFromEstadoEconomico(resumen.estado),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _seleccionarFecha() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked == null) {
      return;
    }

    setState(() {
      _fechaSeleccionada = picked;
      _fechaController.text = _formatearFecha(_fechaSeleccionada);
    });
  }

  Future<void> _seleccionarFechaVencimiento() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fechaVencimientoSeleccionada,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked == null) {
      return;
    }

    setState(() {
      _fechaVencimientoSeleccionada = picked;
      _fechaVencimientoController.text = _formatearFecha(
        _fechaVencimientoSeleccionada,
      );
    });
  }

  Future<void> _confirmarEliminar() async {
    if (!_puedeEliminarFactura) return;

    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar factura'),
          content: const Text(
            'La factura y todas sus líneas se eliminarán definitivamente. '
            'No existen cobros asociados que vayan a eliminarse. '
            'Esta acción no se puede deshacer.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmado != true || !mounted) return;

    try {
      await ref
          .read(facturaRepositoryProvider)
          .eliminarFactura(widget.factura.id);
      if (!mounted) return;
      Navigator.of(context).pop();
    } on FacturaNoEncontradaAlEliminarException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La factura ya no existe.')),
      );
    } on FacturaNoEliminablePorEstadoException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Solo se pueden eliminar facturas en borrador.'),
        ),
      );
    } on FacturaNoEliminableConCobrosException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'La factura contiene cobros asociados que requieren revisión.',
          ),
        ),
      );
    }
  }

  Future<void> _guardarCambios() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final repository = ref.read(facturaRepositoryProvider);
    final fecha = _puedeEditarDocumento
        ? DateTime(
            _fechaSeleccionada.year,
            _fechaSeleccionada.month,
            _fechaSeleccionada.day,
          )
        : widget.factura.fecha;
    final fechaVencimiento = DateTime(
      _fechaVencimientoSeleccionada.year,
      _fechaVencimientoSeleccionada.month,
      _fechaVencimientoSeleccionada.day,
    );

    try {
      await repository.actualizarFactura(
        id: widget.factura.id,
        clienteId: _clienteSeleccionadoId!,
        fecha: fecha,
        fechaVencimiento: fechaVencimiento,
        observaciones: _observacionesController.text.trim(),
      );
    } on FacturaDocumentoCongeladoException catch (error) {
      if (!mounted) return;
      _mostrarDocumentoCongelado(error.estado);
      return;
    } on FechaVencimientoFacturaNoValidaException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'El vencimiento no puede ser anterior a la fecha de factura.',
          ),
        ),
      );
      return;
    }

    if (!mounted) {
      return;
    }
    Navigator.of(context).pop();
  }

  void _mostrarDocumentoCongelado(EstadoFactura estado) {
    final mensaje = estado == EstadoFactura.anulada
        ? 'Una factura anulada se conserva sin modificaciones por trazabilidad.'
        : 'Una factura emitida no puede modificarse. Para corregir su contenido, anúlala y crea una nueva factura. La fecha de vencimiento sí puede corregirse.';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  Future<void> _emitirFactura() async {
    try {
      final repository = ref.read(facturaRepositoryProvider);
      await repository.emitirFactura(widget.factura.id);
      final emitida = await repository.obtenerPorId(widget.factura.id);
      if (!mounted) return;
      setState(
        () => _estadoSeleccionado =
            emitida?.estado ?? EstadoFactura.emitida,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Factura emitida.')),
      );
    } on FacturaEmisionException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.mensaje)),
      );
    }
  }

  Future<void> _anularFactura() async {
    try {
      await ref
          .read(facturaRepositoryProvider)
          .anularFactura(widget.factura.id);
      if (!mounted) return;
      setState(() => _estadoSeleccionado = EstadoFactura.anulada);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Factura anulada.')),
      );
    } on FacturaAnulacionConCobrosException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No se puede anular una factura con cobros. Los cobros registrados deben corregirse o eliminarse primero si se introdujeron por error.',
          ),
        ),
      );
    }
  }
  Future<void> _abrirNuevoCobroDirecto() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NuevoCobroScreen(
          facturaId: widget.factura.id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final clienteRepository = ClienteRepository(ref.read(databaseProvider));

    return AppShortcutScope(
      onBack: () {
        Navigator.maybePop(context);
      },
      onSave: _puedeEditarVencimiento
          ? () {
              _guardarCambios();
            }
          : null,
      onDelete: _puedeEliminarFactura ? _confirmarEliminar : null,
      child: Scaffold(
        appBar: AppPageHeader(
          showBackButton: true,
          title: 'Factura',
          actions: [
            AppPageHeaderAction(
              icon: Icons.picture_as_pdf_outlined,
              tooltip: 'Ver PDF',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FacturaPdfPreviewScreen(
                      factura: widget.factura,
                    ),
                  ),
                );
              },
            ),
            if (_puedeEliminarFactura)
              AppPageHeaderAction(
                icon: Icons.delete_outline,
                tooltip: 'Eliminar factura',
                onPressed: _confirmarEliminar,
              ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
              EntitySummaryCard(
                title: widget.factura.codigo,
                subtitle: widget.factura.clienteNombre.isNotEmpty
                    ? widget.factura.clienteNombre
                    : 'Sin cliente',
                details: [
                  Text(
                    'Fecha: ${_fechaController.text}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    'Vencimiento: ${_fechaVencimientoController.text}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
                statusWidget: StatusChip(
                  label: estadoFacturaToLabel(_estadoSeleccionado),
                  type: _statusTypeFromEstadoFactura(_estadoSeleccionado),
                ),
              ),
              const SizedBox(height: 20),
              StreamBuilder<List<Cliente>>(
                stream: clienteRepository.observarClientes(),
                builder: (context, snapshot) {
                  final clientes = snapshot.data ?? const [];

                  final existeClienteSeleccionado = clientes.any(
                    (cliente) => cliente.id == _clienteSeleccionadoId,
                  );

                  final items = <DropdownMenuItem<String>>[
                    if (_clienteSeleccionadoId != null &&
                        !existeClienteSeleccionado)
                      DropdownMenuItem<String>(
                        value: _clienteSeleccionadoId,
                        child: Text(widget.factura.clienteNombre),
                      ),
                    ...clientes.map(
                      (cliente) => DropdownMenuItem<String>(
                        value: cliente.id,
                        child: Text(
                          '${cliente.nombre} ${cliente.apellidos}'.trim(),
                        ),
                      ),
                    ),
                  ];

                  return DropdownButtonFormField<String>(
                    initialValue: _clienteSeleccionadoId,
                    decoration: const InputDecoration(
                      labelText: 'Cliente',
                    ),
                    items: items,
                    onChanged: _puedeEditarDocumento
                        ? (value) {
                            setState(() {
                              _clienteSeleccionadoId = value;
                            });
                          }
                        : null,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El cliente es obligatorio';
                      }
                      return null;
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                readOnly: true,
                controller: _fechaController,
                decoration: const InputDecoration(
                  labelText: 'Fecha',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: _puedeEditarDocumento ? _seleccionarFecha : null,
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'La fecha es obligatoria'
                    : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                readOnly: true,
                controller: _fechaVencimientoController,
                decoration: const InputDecoration(
                  labelText: 'Fecha de vencimiento',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: _puedeEditarVencimiento
                    ? _seleccionarFechaVencimiento
                    : null,
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'La fecha de vencimiento es obligatoria'
                    : null,
              ),
              const SizedBox(height: 20),
              InputDecorator(
                decoration: const InputDecoration(labelText: 'Estado'),
                child: Text(estadoFacturaToLabel(_estadoSeleccionado)),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _observacionesController,
                readOnly: !_puedeEditarDocumento,
                decoration: const InputDecoration(
                  labelText: 'Observaciones',
                ),
                minLines: 3,
                maxLines: 5,
              ),
              if (_puedeEditarVencimiento) ...[
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _guardarCambios,
                    icon: const Icon(Icons.save),
                    label: Text(
                      _puedeEditarDocumento
                          ? 'Guardar cambios'
                          : 'Guardar vencimiento',
                    ),
                  ),
                ),
              ],
              if (_estadoSeleccionado == EstadoFactura.borrador) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _emitirFactura,
                    icon: const Icon(Icons.send_outlined),
                    label: const Text('Emitir factura'),
                  ),
                ),
              ],
              if (_estadoPersistido == EstadoFactura.emitida ||
                  _estadoPersistido == EstadoFactura.vencida) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _anularFactura,
                    icon: const Icon(Icons.cancel_outlined),
                    label: const Text('Anular factura'),
                  ),
                ),
              ],
              if (_estadoPersistido == EstadoFactura.borrador &&
                  _tieneCobros == true) ...[
                const SizedBox(height: 12),
                const Text(
                  'Esta factura en borrador contiene cobros asociados que '
                  'requieren revisión. No se pueden eliminar desde el borrador.',
                ),
              ],
              const SizedBox(height: 24),
              const Text(
                'Lineas de factura',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Consumer(
                builder: (context, ref, _) {
                  final repository = ref.read(facturaLineaRepositoryProvider);

                  return StreamBuilder<List<factura_linea_domain.FacturaLinea>>(
                    stream: repository.observarPorFactura(widget.factura.id),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: SelectableText(
                            'ERROR:\n\n${snapshot.error}',
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final lineas = snapshot.data ?? const [];

                      if (lineas.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text('Todavia no hay lineas de factura.'),
                        );
                      }

                      final subtotal = lineas.fold<double>(
                        0,
                        (sum, linea) => sum + linea.importe,
                      );
                      final iva = subtotal * widget.factura.ivaPorcentaje / 100;
                      final total = subtotal + iva;

                      final lineasWidgets = lineas
                          .map<Widget>(
                            (linea) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(linea.descripcion),
                              subtitle: Text(
                                '${_formatearCantidad(linea.cantidad)} ${linea.unidad} x ${_formatearMoneda(linea.precioUnitario)} - ${_formatearPorcentaje(linea.descuento)}% = ${_formatearMoneda(linea.importe)}',
                              ),
                              onTap: _puedeEditarLineas
                                  ? () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              EditarLineaFacturaScreen(
                                            linea: linea,
                                          ),
                                        ),
                                      );
                                    }
                                  : null,
                            ),
                          )
                          .toList();

                      lineasWidgets.addAll([
                        const SizedBox(height: 12),
                        const Divider(),
                        const SizedBox(height: 8),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Subtotal',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _formatearMoneda(subtotal),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'IVA (${_formatearPorcentaje(widget.factura.ivaPorcentaje)}%)',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _formatearMoneda(iva),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Total',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _formatearMoneda(total),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Divider(),
                        const SizedBox(height: 12),
                        _buildResumenEconomico(total),
                      ]);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: lineasWidgets,
                      );
                    },
                  );
                },
              ),
              if (_puedeEditarLineas) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NuevaLineaFacturaScreen(
                            facturaId: widget.factura.id,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Nueva linea'),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              if (estadoFacturaAdmiteNuevosCobros(_estadoSeleccionado)) ...[
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _abrirNuevoCobroDirecto,
                    icon: const Icon(Icons.payments_outlined),
                    label: const Text('Registrar cobro'),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CobrosScreen(
                          facturaId: widget.factura.id,
                          facturaCodigo: widget.factura.codigo,
                          facturaEstado: _estadoSeleccionado,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.payments_outlined),
                  label: const Text('Ver cobros'),
                ),
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

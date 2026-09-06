import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../environment/presentation/widgets/environment_controls.dart';
import '../../domain/configuracion_fiscal.dart';
import '../providers/configuracion_fiscal_providers.dart';

class ConfiguracionFiscalScreen extends ConsumerStatefulWidget {
  const ConfiguracionFiscalScreen({super.key});
  @override
  ConsumerState<ConfiguracionFiscalScreen> createState() =>
      _ConfiguracionFiscalScreenState();
}

class _ConfiguracionFiscalScreenState
    extends ConsumerState<ConfiguracionFiscalScreen> {
  final _ejercicio = TextEditingController(
    text: DateTime.now().year.toString(),
  );
  final _ordinaria = TextEditingController();
  final _rectificativa = TextEditingController();
  final _inicioOrd = TextEditingController();
  final _inicioRect = TextEditingController();
  List<ConfiguracionSerieFiscal> _config = [];
  bool _ocupado = true;
  int? _cargado;
  String? _error;
  @override
  void initState() {
    super.initState();
    _cargar();
  }

  @override
  void dispose() {
    for (final c in [
      _ejercicio,
      _ordinaria,
      _rectificativa,
      _inicioOrd,
      _inicioRect,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  ConfiguracionSerieFiscal? _serie(String tipo) =>
      _config.where((c) => c.tipo == tipo).firstOrNull;
  Future<void> _cargar() async {
    final anio = int.tryParse(_ejercicio.text);
    if (anio == null || anio < 1900 || anio > 9999) {
      setState(() {
        _error = 'Introduce un ejercicio válido.';
        _ocupado = false;
      });
      return;
    }
    setState(() {
      _ocupado = true;
      _error = null;
    });
    try {
      final config = await ref
          .read(configuracionFiscalRepositoryProvider)
          .obtener(anio);
      if (!mounted) return;
      setState(() {
        _config = config;
        _cargado = anio;
        _ordinaria.text = _serie('ordinaria')?.serie ?? '';
        _rectificativa.text = _serie('rectificativa')?.serie ?? '';
        _inicioOrd.text = _serie('ordinaria')?.numeroInicial.toString() ?? '';
        _inicioRect.text =
            _serie('rectificativa')?.numeroInicial.toString() ?? '';
      });
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'No se pudo cargar la configuración fiscal.');
      }
    } finally {
      if (mounted) setState(() => _ocupado = false);
    }
  }

  Future<void> _guardar(bool preparar) async {
    final ord = int.tryParse(_inicioOrd.text),
        rect = int.tryParse(_inicioRect.text);
    if (_cargado == null ||
        int.tryParse(_ejercicio.text) != _cargado ||
        ord == null ||
        rect == null) {
      setState(
        () => _error =
            'Carga el ejercicio e introduce los dos números iniciales.',
      );
      return;
    }
    if (preparar) {
      final ok = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Preparar numeración fiscal'),
          content: Text(
            'Ejercicio $_cargado\nOrdinarias: ${_ordinaria.text.trim().toUpperCase()} desde $ord\nRectificativas: ${_rectificativa.text.trim().toUpperCase()} desde $rect\n\nConfirma las series y números con tu gestoría antes de la primera factura real. Preparar no emite facturas. Tras el primer uso quedarán protegidos.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Volver'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Confirmar preparación'),
            ),
          ],
        ),
      );
      if (ok != true || !mounted) return;
    }
    setState(() {
      _ocupado = true;
      _error = null;
    });
    try {
      await ref
          .read(configuracionFiscalRepositoryProvider)
          .configurarEjercicio(
            ejercicio: _cargado!,
            serieOrdinaria: _ordinaria.text,
            inicialOrdinaria: ord,
            serieRectificativa: _rectificativa.text,
            inicialRectificativa: rect,
            preparada: preparar,
          );
      if (!mounted) return;
      await _cargar();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              preparar
                  ? 'Numeración preparada. No se ha emitido ninguna factura.'
                  : 'Configuración guardada. Las series ya utilizadas siguen preparadas.',
            ),
          ),
        );
      }
    } on ConfiguracionFiscalException catch (e) {
      if (mounted) setState(() => _error = e.mensaje);
    } catch (_) {
      if (mounted) {
        setState(
          () => _error =
              'No se pudo guardar. Revisa las series; no se han aplicado cambios parciales.',
        );
      }
    } finally {
      if (mounted) setState(() => _ocupado = false);
    }
  }

  Widget _circuito(
    String tipo,
    String titulo,
    TextEditingController serie,
    TextEditingController inicio,
  ) {
    final c = _serie(tipo), bloqueada = _serie(tipo)?.utilizada ?? false;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo, style: Theme.of(context).textTheme.titleLarge),
            Text(
              c == null
                  ? 'Sin configurar'
                  : c.utilizada
                  ? 'En uso · configuración protegida'
                  : c.preparada
                  ? 'Preparada para emitir'
                  : 'Pendiente de preparación',
            ),
            const SizedBox(height: 12),
            TextField(
              key: ValueKey("fiscal-$tipo-serie"),
              controller: serie,
              enabled: !_ocupado && !bloqueada,
              decoration: const InputDecoration(
                labelText: 'Serie fiscal',
                helperText:
                    'Letras, números, guion o guion bajo. Máximo 20 caracteres.',
              ),
            ),
            TextField(
              key: ValueKey("fiscal-$tipo-inicio"),
              controller: inicio,
              enabled: !_ocupado && !bloqueada,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Número inicial'),
            ),
            if (c != null) ...[
              const SizedBox(height: 12),
              Text(
                'Documentos históricos de esta serie: ${c.documentosPrevios}',
              ),
              Text(
                'Próximo número: ${c.siguienteNumero} · Emitidas desde esta configuración: ${c.emisiones}',
              ),
              Text(
                'Referencia prevista: ${NumeroFiscal(c.ejercicio, c.serie, c.siguienteNumero).codigo}',
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Numeración fiscal')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const EnvironmentIndicator(),
        const SizedBox(height: 16),
        const Text(
          'La configuración pertenece a esta empresa y a este entorno. Antes de la primera factura real, valida ejercicio, series y números con tu gestoría.',
        ),
        TextField(
          controller: _ejercicio,
          enabled: !_ocupado,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Ejercicio'),
        ),
        TextButton(
          onPressed: _ocupado ? null : _cargar,
          child: const Text('Cargar ejercicio'),
        ),
        if (_ocupado) const LinearProgressIndicator(),
        if (_error != null)
          Text(
            _error!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        _circuito('ordinaria', 'Facturas ordinarias', _ordinaria, _inicioOrd),
        _circuito(
          'rectificativa',
          'Facturas rectificativas',
          _rectificativa,
          _inicioRect,
        ),
        const Text(
          'Los números de presupuesto son comerciales e independientes. Un nuevo año necesita su propia preparación; no se configura automáticamente.',
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed:
              _ocupado ||
                  (_config.length == 2 && _config.every((c) => c.utilizada))
              ? null
              : () => _guardar(false),
          child: const Text('Guardar sin preparar'),
        ),
        FilledButton(
          onPressed: _ocupado ? null : () => _guardar(true),
          child: const Text('Preparar numeración'),
        ),
      ],
    ),
  );
}

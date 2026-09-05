import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/shortcuts/app_shortcuts.dart';
import '../../../../core/ui/app_spacing.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_section.dart';
import '../../domain/documento.dart';
import '../providers/documento_providers.dart';

class NuevoDocumentoScreen extends ConsumerStatefulWidget {
  const NuevoDocumentoScreen({super.key, required this.expedienteId});

  final String expedienteId;

  @override
  ConsumerState<NuevoDocumentoScreen> createState() =>
      _NuevoDocumentoScreenState();
}

class _NuevoDocumentoScreenState extends ConsumerState<NuevoDocumentoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _nombreArchivoController = TextEditingController();
  final _rutaArchivoController = TextEditingController();
  final _mimeTypeController = TextEditingController();
  final _tamanoBytesController = TextEditingController(text: '0');
  final _fechaController = TextEditingController();
  final _observacionesController = TextEditingController();

  late DateTime _fechaSeleccionada;
  DocumentoTipo _tipoSeleccionado = DocumentoTipo.otro;

  @override
  void initState() {
    super.initState();
    _fechaSeleccionada = DateTime.now();
    _fechaController.text = _formatearFecha(_fechaSeleccionada);
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _nombreArchivoController.dispose();
    _rutaArchivoController.dispose();
    _mimeTypeController.dispose();
    _tamanoBytesController.dispose();
    _fechaController.dispose();
    _observacionesController.dispose();
    super.dispose();
  }

  String _formatearFecha(DateTime fecha) {
    final day = fecha.day.toString().padLeft(2, '0');
    final month = fecha.month.toString().padLeft(2, '0');
    final year = fecha.year.toString();
    return '$day/$month/$year';
  }

  String _formatearTipo(DocumentoTipo tipo) {
    switch (tipo) {
      case DocumentoTipo.contrato:
        return 'Contrato';
      case DocumentoTipo.licencia:
        return 'Licencia';
      case DocumentoTipo.plano:
        return 'Plano';
      case DocumentoTipo.fotografia:
        return 'Fotografía';
      case DocumentoTipo.factura:
        return 'Factura';
      case DocumentoTipo.presupuesto:
        return 'Presupuesto';
      case DocumentoTipo.documentacionTecnica:
        return 'Documentación técnica';
      case DocumentoTipo.certificado:
        return 'Certificado';
      case DocumentoTipo.otro:
        return 'Otro';
    }
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

  int _parseTamanoOrZero(String value) {
    final raw = value.trim();
    if (raw.isEmpty) {
      return 0;
    }

    return int.tryParse(raw) ?? 0;
  }

  Future<void> _guardarDocumento() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final repository = ref.read(documentoRepositoryProvider);
    final fecha = DateTime(
      _fechaSeleccionada.year,
      _fechaSeleccionada.month,
      _fechaSeleccionada.day,
    );

    await repository.registrarDocumento(
      Documento(
        id: '',
        expedienteId: widget.expedienteId,
        titulo: _tituloController.text.trim(),
        nombreArchivo: _nombreArchivoController.text.trim(),
        rutaArchivo: _rutaArchivoController.text.trim(),
        mimeType: _mimeTypeController.text.trim().isEmpty
            ? null
            : _mimeTypeController.text.trim(),
        tamanoBytes: _parseTamanoOrZero(_tamanoBytesController.text),
        fecha: fecha,
        observaciones: _observacionesController.text.trim().isEmpty
            ? null
            : _observacionesController.text.trim(),
        tipo: _tipoSeleccionado,
      ),
    );

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AppShortcutScope(
      onBack: () => Navigator.maybePop(context),
      child: Scaffold(
        appBar: AppBar(title: const Text('Nuevo documento')),
        body: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                AppSection(
                  title: 'Datos del documento',
                  subtitle:
                      'Completa la información y guarda el documento en el expediente.',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _tituloController,
                        decoration: const InputDecoration(labelText: 'Título'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'El título es obligatorio';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      DropdownButtonFormField<DocumentoTipo>(
                        initialValue: _tipoSeleccionado,
                        decoration: const InputDecoration(labelText: 'Tipo'),
                        items: DocumentoTipo.values
                            .map(
                              (tipo) => DropdownMenuItem<DocumentoTipo>(
                                value: tipo,
                                child: Text(_formatearTipo(tipo)),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            _tipoSeleccionado = value;
                          });
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      TextFormField(
                        controller: _nombreArchivoController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre del archivo',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'El nombre del archivo es obligatorio';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      TextFormField(
                        controller: _rutaArchivoController,
                        decoration: const InputDecoration(
                          labelText: 'Ruta del archivo',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'La ruta del archivo es obligatoria';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      TextFormField(
                        controller: _mimeTypeController,
                        decoration: const InputDecoration(
                          labelText: 'MIME Type',
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      TextFormField(
                        controller: _tamanoBytesController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Tamaño en bytes',
                        ),
                        validator: (value) {
                          final raw = value?.trim() ?? '';
                          if (raw.isEmpty) {
                            return null;
                          }

                          final parsed = int.tryParse(raw);
                          if (parsed == null || parsed < 0) {
                            return 'Introduce un tamaño válido (>= 0)';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      TextFormField(
                        readOnly: true,
                        controller: _fechaController,
                        decoration: const InputDecoration(
                          labelText: 'Fecha',
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        onTap: _seleccionarFecha,
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                            ? 'La fecha es obligatoria'
                            : null,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      TextFormField(
                        controller: _observacionesController,
                        decoration: const InputDecoration(
                          labelText: 'Observaciones',
                        ),
                        minLines: 3,
                        maxLines: 5,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      AppPrimaryButton(
                        onPressed: _guardarDocumento,
                        icon: Icons.save,
                        label: 'Guardar',
                      ),
                    ],
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

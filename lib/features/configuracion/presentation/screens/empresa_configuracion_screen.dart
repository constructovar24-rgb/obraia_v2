import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/shortcuts/app_shortcuts.dart';
import '../../data/empresa_configuracion_repository.dart';
import '../../../backup/presentation/screens/backup_screen.dart';
import '../../../economia/presentation/providers/plan_economico_providers.dart';

class EmpresaConfiguracionScreen extends ConsumerStatefulWidget {
  const EmpresaConfiguracionScreen({super.key});

  @override
  ConsumerState<EmpresaConfiguracionScreen> createState() =>
      _EmpresaConfiguracionScreenState();
}

class _EmpresaConfiguracionScreenState
    extends ConsumerState<EmpresaConfiguracionScreen> {
  final _nombreEmpresaController = TextEditingController();
  final _cifController = TextEditingController();
  final _direccionController = TextEditingController();
  final _codigoPostalController = TextEditingController();
  final _poblacionController = TextEditingController();
  final _provinciaController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _emailController = TextEditingController();
  final _webController = TextEditingController();
  final _logoPathController = TextEditingController();
  final _indirectosController = TextEditingController();

  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  @override
  void dispose() {
    _nombreEmpresaController.dispose();
    _cifController.dispose();
    _direccionController.dispose();
    _codigoPostalController.dispose();
    _poblacionController.dispose();
    _provinciaController.dispose();
    _telefonoController.dispose();
    _emailController.dispose();
    _webController.dispose();
    _logoPathController.dispose();
    _indirectosController.dispose();
    super.dispose();
  }

  Future<void> _cargarDatos() async {
    final repository = ref.read(empresaConfiguracionRepositoryProvider);
    final config = await repository.obtenerOCrearConfiguracion();

    _nombreEmpresaController.text = config.nombreEmpresa;
    _cifController.text = config.cif;
    _direccionController.text = config.direccion;
    _codigoPostalController.text = config.codigoPostal;
    _poblacionController.text = config.poblacion;
    _provinciaController.text = config.provincia;
    _telefonoController.text = config.telefono;
    _emailController.text = config.email;
    _webController.text = config.web;
    _logoPathController.text = config.logoPath ?? '';
    final porcentaje = await ref
        .read(planEconomicoRepositoryProvider)
        .obtenerPorcentajeIndirectos();
    _indirectosController.text = porcentaje?.toString() ?? '';

    if (mounted) {
      setState(() {
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final repository = ref.read(empresaConfiguracionRepositoryProvider);

    return AppShortcutScope(
      onBack: () => Navigator.maybePop(context),
      child: Scaffold(
        appBar: AppBar(title: const Text('Configuración - Empresa')),
        body: _cargando
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const BackupScreen(),
                            ),
                          ),
                          icon: const Icon(Icons.backup_outlined),
                          label: const Text('Copias de seguridad'),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _nombreEmpresaController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre empresa',
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _cifController,
                        decoration: const InputDecoration(labelText: 'CIF'),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _direccionController,
                        decoration: const InputDecoration(
                          labelText: 'Dirección',
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _codigoPostalController,
                        decoration: const InputDecoration(
                          labelText: 'Código postal',
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _poblacionController,
                        decoration: const InputDecoration(
                          labelText: 'Población',
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _provinciaController,
                        decoration: const InputDecoration(
                          labelText: 'Provincia',
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _telefonoController,
                        decoration: const InputDecoration(
                          labelText: 'Teléfono',
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _webController,
                        decoration: const InputDecoration(labelText: 'Web'),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _logoPathController,
                        decoration: const InputDecoration(
                          labelText: 'Logo path (opcional)',
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _indirectosController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Indirectos previstos (%)',
                          helperText:
                              'Uso interno. Se congela al aceptar cada presupuesto.',
                        ),
                      ),
                      const SizedBox(height: 30),
                      FilledButton.icon(
                        onPressed: () async {
                          final textoIndirectos = _indirectosController.text
                              .trim()
                              .replaceAll(',', '.');
                          final porcentajeIndirectos = textoIndirectos.isEmpty
                              ? null
                              : double.tryParse(textoIndirectos);
                          if (textoIndirectos.isNotEmpty &&
                              (porcentajeIndirectos == null ||
                                  porcentajeIndirectos < 0 ||
                                  porcentajeIndirectos > 100)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'El porcentaje debe estar entre 0 y 100.',
                                ),
                              ),
                            );
                            return;
                          }
                          await repository.guardarConfiguracion(
                            nombreEmpresa: _nombreEmpresaController.text.trim(),
                            cif: _cifController.text.trim(),
                            direccion: _direccionController.text.trim(),
                            codigoPostal: _codigoPostalController.text.trim(),
                            poblacion: _poblacionController.text.trim(),
                            provincia: _provinciaController.text.trim(),
                            telefono: _telefonoController.text.trim(),
                            email: _emailController.text.trim(),
                            web: _webController.text.trim(),
                            logoPath: _logoPathController.text.trim().isEmpty
                                ? null
                                : _logoPathController.text.trim(),
                          );
                          await ref
                              .read(planEconomicoRepositoryProvider)
                              .guardarPorcentajeIndirectos(
                                porcentajeIndirectos,
                              );

                          if (!context.mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Configuración de empresa guardada',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.save),
                        label: const Text('Guardar'),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

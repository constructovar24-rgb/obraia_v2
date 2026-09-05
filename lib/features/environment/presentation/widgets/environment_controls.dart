import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/environment/app_environment.dart';
import '../providers/environment_controller.dart';

class EnvironmentIndicator extends ConsumerWidget {
  const EnvironmentIndicator({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(environmentControllerProvider);
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Row(
          children: [
            const Icon(Icons.storage_outlined, size: 16),
            const SizedBox(width: 8),
            Text('Entorno: ${controller.environment.label}'),
            if (controller.error != null) ...[
              const SizedBox(width: 16),
              Expanded(child: Text(controller.error!)),
            ],
          ],
        ),
      ),
    );
  }
}

class EnvironmentSelector extends ConsumerWidget {
  const EnvironmentSelector({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(environmentControllerProvider);
    final target = controller.environment == AppEnvironment.development
        ? AppEnvironment.production
        : AppEnvironment.development;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text('Entorno actual: ${controller.environment.label}'),
      subtitle: const Text('Los datos y las copias se mantienen separados.'),
      trailing: OutlinedButton(
        onPressed: controller.switching
            ? null
            : () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => AlertDialog(
                    title: Text('Cambiar a ${target.label}'),
                    content: const Text(
                      'Se cerrará la sesión actual y se abrirá la base del otro entorno. '
                      'Los cambios sin guardar se descartarán. Guarda primero cualquier trabajo pendiente. '
                      'No se copiarán datos entre entornos. No introduzcas todavía datos reales.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancelar'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Confirmar cambio'),
                      ),
                    ],
                  ),
                );
                if (confirmed != true) return;
                try {
                  await controller.changeEnvironment(target);
                } catch (_) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Hay una operación en curso. Espera a que termine antes de cambiar.',
                        ),
                      ),
                    );
                  }
                }
              },
        child: const Text('Cambiar entorno'),
      ),
    );
  }
}

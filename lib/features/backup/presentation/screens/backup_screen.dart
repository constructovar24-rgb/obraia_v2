import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/backup_providers.dart';

class BackupScreen extends ConsumerWidget {
  const BackupScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(backupControllerProvider);
    Future<void> manual() async {
      try {
        final file = await controller.createManual();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Copia creada correctamente en ${file.path}'),
            ),
          );
        }
      } catch (_) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No se pudo crear la copia de seguridad.'),
            ),
          );
        }
      }
    }

    Future<void> restore() async {
      final file = await openFile(
        acceptedTypeGroups: const [
          XTypeGroup(label: 'Copias de OBRA IA', extensions: ['obraia-backup']),
        ],
      );
      if (file == null || !context.mounted) {
        return;
      }
      final ok = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Restaurar copia de seguridad'),
          content: const Text(
            'Los datos actuales serán sustituidos por los de la copia. Antes, OBRA IA creará una copia de recuperación automática.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Restaurar copia'),
            ),
          ],
        ),
      );
      if (ok != true) {
        return;
      }
      try {
        await controller.restore(file.path);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Copia restaurada correctamente.')),
          );
        }
      } catch (_) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'No se pudo restaurar la copia. Los datos anteriores se han conservado cuando ha sido posible.',
              ),
            ),
          );
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Copias de seguridad')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Protege la información de OBRA IA creando copias que podrás recuperar cuando las necesites.',
            ),
            const SizedBox(height: 24),
            Text(
              controller.lastBackupPath == null
                  ? 'Aún no hay una copia manual realizada en esta sesión.'
                  : 'Última copia correcta: ${controller.lastBackupPath}',
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: controller.busy ? null : manual,
              icon: const Icon(Icons.save_outlined),
              label: const Text('Crear copia de seguridad'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: controller.busy ? null : restore,
              icon: const Icon(Icons.restore),
              label: const Text('Restaurar copia de seguridad'),
            ),
            if (controller.busy)
              const Padding(
                padding: EdgeInsets.only(top: 24),
                child: Row(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(width: 12),
                    Text('Operación en curso…'),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

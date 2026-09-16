import 'package:flutter/material.dart';

Future<bool?> showBackupRestoreConfirmation(
  BuildContext context, {
  required String coverage,
}) => showDialog<bool>(
  context: context,
  builder: (_) => _BackupRestoreConfirmation(coverage: coverage),
);

class _BackupRestoreConfirmation extends StatefulWidget {
  const _BackupRestoreConfirmation({required this.coverage});

  final String coverage;

  @override
  State<_BackupRestoreConfirmation> createState() =>
      _BackupRestoreConfirmationState();
}

class _BackupRestoreConfirmationState
    extends State<_BackupRestoreConfirmation> {
  bool _understood = false;

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Restaurar copia de seguridad'),
    content: SizedBox(
      width: 520,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.coverage),
            const SizedBox(height: 16),
            const Text(
              'Los datos actuales de todas las empresas del entorno serán sustituidos por los de la copia. Antes, OBRA IA creará una copia de recuperación automática.',
            ),
            const SizedBox(height: 16),
            const Text(
              'También se recuperarán los contadores fiscales de esa fecha. Las facturas emitidas y los cobros o pagos posteriores pueden quedar fuera. Restaurar no anula documentos enviados ni movimientos bancarios.',
            ),
            const SizedBox(height: 16),
            const Text(
              'Antes de volver a emitir o registrar movimientos, compara los datos recuperados con el archivo externo y los justificantes. Si existen facturas reales posteriores, detén la emisión y revisa la continuidad con la gestoría y soporte. No reinicies ni ajustes los contadores por tu cuenta.',
            ),
            const SizedBox(height: 8),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              value: _understood,
              onChanged: (value) =>
                  setState(() => _understood = value ?? false),
              title: const Text(
                'Entiendo el riesgo y revisaré la continuidad antes de reanudar operaciones.',
              ),
            ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context, false),
        child: const Text('Cancelar'),
      ),
      FilledButton(
        onPressed: _understood ? () => Navigator.pop(context, true) : null,
        child: const Text('Restaurar copia'),
      ),
    ],
  );
}

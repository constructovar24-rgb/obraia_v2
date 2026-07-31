import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppShortcutScope extends StatelessWidget {
  const AppShortcutScope({
    super.key,
    required this.child,
    this.onSave,
    this.onBack,
    this.onFind,
    this.onNew,
    this.onDelete,
  });

  final Widget child;
  final VoidCallback? onSave;
  final VoidCallback? onBack;
  final VoidCallback? onFind;
  final VoidCallback? onNew;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    debugPrint('[Shortcut] AppShortcutScope construido');

    final shortcuts = <ShortcutActivator, VoidCallback>{
      // Ctrl+S -> Guardar cambios en la pantalla actual.
      if (onSave != null)
        const SingleActivator(
          LogicalKeyboardKey.keyS,
          control: true,
        ): () {
          debugPrint('[Shortcut] Ctrl+S recibido');
          onSave!.call();
        },

      // Esc -> Volver a la pantalla anterior.
      if (onBack != null)
        const SingleActivator(
          LogicalKeyboardKey.escape,
        ): () {
          debugPrint('[Shortcut] Escape recibido');
          onBack!.call();
        },

      // Ctrl+F -> Enfocar/abrir búsqueda donde exista.
      if (onFind != null)
        const SingleActivator(
          LogicalKeyboardKey.keyF,
          control: true,
        ): () {
          debugPrint('[Shortcut] Ctrl+F recibido');
          onFind!.call();
        },

      // Ctrl+N -> Crear nuevo registro en pantallas de listado.
      if (onNew != null)
        const SingleActivator(
          LogicalKeyboardKey.keyN,
          control: true,
        ): () {
          debugPrint('[Shortcut] Ctrl+N recibido');
          onNew!.call();
        },

      // Supr -> Ejecutar eliminación (la pantalla mantiene su confirmación).
      if (onDelete != null)
        const SingleActivator(
          LogicalKeyboardKey.delete,
        ): () {
          debugPrint('[Shortcut] Delete recibido');
          onDelete!.call();
        },
    };

    debugPrint('[Shortcut] Atajos registrados: ${shortcuts.length}');

    if (shortcuts.isEmpty) {
      return child;
    }

    return CallbackShortcuts(
      bindings: shortcuts,
      child: Focus(
        autofocus: true,
        child: child,
      ),
    );
  }
}
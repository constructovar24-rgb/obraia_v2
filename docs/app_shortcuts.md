# AppShortcutScope

## Objetivo

Centralizar todos los atajos de teclado de la aplicación evitando duplicar lógica.

---

## Pantallas de listado

Atajos:

Ctrl+N
    Crear nuevo registro.

Ctrl+F
    Abrir búsqueda (solo cuando exista buscador).

Escape
    Volver.

---

## Pantallas de creación

Atajos:

Escape
    Cancelar / volver.

---

## Pantallas de edición

Atajos:

Ctrl+S
    Guardar reutilizando el callback existente.

Delete
    Eliminar reutilizando la acción existente.

Escape
    Volver.

---

## Reglas

- Nunca duplicar lógica.
- Reutilizar callbacks existentes.
- No crear nuevas funciones únicamente para un atajo.
- AppShortcutScope debe envolver el Scaffold.
- En pantallas con TabBar se coloca un único AppShortcutScope en el contenedor principal.
- No envolver cada Tab individualmente.

## No utilizar AppShortcutScope

- Widgets reutilizables.
- Formularios incrustados.
- Tabs individuales dentro de un TabBar.
- Componentes que no representan una pantalla navegable.

---

## Flujo recomendado

1. Implementar la funcionalidad.
2. Añadir AppShortcutScope.
3. Reutilizar callbacks.
4. Ejecutar flutter analyze.
5. Validar funcionamiento manual.

---

## Ejemplo

```dart
return AppShortcutScope(
    onBack: () => Navigator.maybePop(context),
    onSave: guardarCambios,
    onDelete: eliminarRegistro,
    child: Scaffold(
        ...
    ),
);
```

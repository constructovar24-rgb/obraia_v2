# Arquitectura

La arquitectura oficial de OBRA IA v3 sigue esta separación de capas:

Presentation
↓
Providers
↓
Repositories
↓
DAOs
↓
Drift
↓
SQLite

Nunca se deben saltar capas.

No permitido:

- Presentation -> Repository sin pasar por Providers cuando la dependencia debe resolverse con Riverpod.
- Presentation -> DAO
- Presentation -> Drift
- Presentation -> SQLite
- Repository -> Widget
- DAO -> Flutter
- DAO -> lógica de negocio

# Features

Cada feature debe seguir esta estructura estándar:

```text
data/
domain/
presentation/
    providers/
    screens/
    widgets/
```

Reglas:

- `data/` contiene repositories, mappers y acceso a datos de la feature.
- `domain/` contiene entidades y tipos del dominio.
- `presentation/providers/` contiene todos los providers de Riverpod de la feature.
- `presentation/screens/` contiene pantallas.
- `presentation/widgets/` contiene widgets reutilizables de la feature.

# Repositories

Reglas:

- No importar `flutter_riverpod`.
- No depender de Widgets.
- No usar `BuildContext`.
- No acceder directamente a SQLite.
- Toda persistencia debe pasar por un DAO.
- Deben mantenerse pequeños y legibles.
- Deben contener solo lógica de aplicación y coordinación de acceso a datos.

# Providers

Reglas:

- Todos viven en `presentation/providers`.
- Son responsables de construir los Repository.
- La UI consume únicamente Providers.
- No deben contener lógica de negocio.
- Deben reutilizar `databaseProvider` cuando necesiten acceso a `AppDatabase`.

# UI

Reglas:

- Nunca acceder a `AppDatabase`.
- Nunca crear Repository manualmente.
- No contener lógica de negocio.
- Debe limitarse a renderizado, interacción y consumo de Providers.
- La UI no debe acceder directamente a DAO, Drift ni SQLite.

# Drift

Toda nueva tabla requiere:

- Tabla
- DAO
- Registro en `app_database.dart`
- `build_runner`

Reglas:

- Las tablas viven en `lib/database/tables`.
- Los DAOs viven en `lib/database/dao`.
- Cualquier cambio de esquema debe actualizar `schemaVersion` y su migración correspondiente.

# Calidad

Antes de cualquier commit:

- `flutter analyze`
- Sin warnings
- Sin errors

Si cambia Drift, además:

- `flutter packages pub run build_runner build --delete-conflicting-outputs`

# Flujo de trabajo

Flujo oficial:

Prompt
↓
Copilot
↓
Review
↓
Keep
↓
flutter analyze
↓
Commit

# Principios

- No duplicar lógica.
- Trabajar por entregas pequeñas.
- No hacer refactorizaciones globales.
- Mantener compatibilidad.
- Priorizar claridad frente a complejidad.
- Explicar el plan antes de modificar código.
- Reutilizar patrones existentes antes de crear nuevos.
- Evolucionar la arquitectura sin romper la estructura actual.

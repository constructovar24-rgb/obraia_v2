# ARCHITECTURE.md

## Organización por features
El proyecto sigue una estructura modular por features, con carpetas separadas para cada dominio funcional.

Ejemplo de organización:
- lib/features/expedientes
- lib/features/clientes
- lib/screens
- lib/database
- lib/models
- lib/engines

## Drift + SQLite
La persistencia local se gestiona con Drift sobre SQLite.

### Componentes principales
- Tablas Drift en lib/database/tables
- DAOs en lib/database/dao
- Base de datos central en lib/database/app_database.dart

## Riverpod
Riverpod se usa para la gestión de dependencias y acceso a la base de datos desde las capas de presentación.

## Convenciones de carpetas
- data: acceso a datos y repositorios
- domain: entidades del dominio
- presentation: pantallas y vistas
- screens: pantallas generales de la aplicación

## Flujo de persistencia
1. La pantalla accede al repositorio.
2. El repositorio delega en AppDatabase.
3. Drift ejecuta la operación sobre SQLite.
4. Los cambios se reflejan en la UI mediante streams.

## Reglas de arquitectura
- Mantener la estructura actual salvo indicación expresa.
- Reutilizar patrones existentes antes de crear nuevos.
- Evitar duplicar lógica.
- Mantener compatibilidad con el código ya implementado.
- Priorizar claridad y mantenibilidad.

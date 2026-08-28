# Arquitectura

## Tecnologías y ejecución

OBRA IA es una aplicación Flutter/Dart con Riverpod para estado e inyección de dependencias y Drift sobre SQLite para persistencia local. Windows es la plataforma prioritaria actual. La generación documental utiliza `pdf` y `printing`.

La aplicación arranca con `MaterialApp` y navega mediante `Navigator` y `MaterialPageRoute`. `go_router` está declarado como dependencia, pero no existe una implementación activa; cualquier migración debe decidirse y ejecutarse por separado.

## Organización

- `lib/features/<módulo>/domain`: entidades y reglas de dominio.
- `lib/features/<módulo>/data`: repositorios y acceso a datos heredado.
- `lib/features/<módulo>/presentation`: pantallas, widgets y providers.
- `lib/database/tables`: 13 tablas Drift.
- `lib/database/dao`: DAOs de persistencia.
- `lib/database/app_database.dart`: base central, migraciones y `schemaVersion` 17.
- `lib/screens`: pantallas generales y motor heredado de presupuestos de piscinas.

## Dirección objetivo

`Presentation → Providers → Repositories → DAOs → Drift → SQLite`

La UI no debe acceder directamente a `databaseProvider`, DAOs, Drift o SQLite. Los providers deben vivir en `presentation/providers`, y los repositorios no deben depender de Riverpod, widgets ni `BuildContext`.

## Estado real y deuda conocida

El código todavía contiene providers en `data/`, pantallas que construyen repositorios o acceden a `databaseProvider`, métodos heredados en `AppDatabase`, archivos grandes y varias ubicaciones para tema/UI. Estas desviaciones se corrigen solo al trabajar en el flujo afectado, sin reescrituras globales.

Los streams de Drift permiten que cambios persistidos se reflejen reactivamente. Las operaciones compuestas que afecten datos y trazabilidad deben ejecutarse en transacciones. Todo cambio de esquema exige versión, migración compatible, regeneración, pruebas de conservación y documentación según `AGENTS.md`.

# Registro de cambios

## No publicado

### Copias de seguridad

- Definida la estrategia segura de backup y restauración de SQLite.
- Incorporado un primer servicio aislado de snapshot consistente mediante `VACUUM INTO`.
- Añadidas 3 pruebas con bases temporales para consistencia, rollback, integridad y protección del destino.

### Expedientes

- Añadida la edición segura de código, nombre y cliente desde la ficha.
- La ficha y el listado reciben las actualizaciones mediante streams reactivos.
- El guardado conserva los demás datos y registra un único evento de Timeline dentro de la misma transacción.
- Añadido tratamiento explícito de errores, doble guardado y desaparición concurrente de expediente o cliente.
- Incorporadas 8 pruebas específicas con SQLite en memoria.

### Calidad y documentación

- Línea base comprobada con `flutter analyze --no-pub` limpio y 102 pruebas superadas.
- Toolchain Windows validada con Visual Studio Community 2026 18.9.2 y Windows SDK 10.0.26100.0.
- Compilación debug para Windows completada correctamente con `flutter build windows --debug --no-pub`.
- Añadidas instrucciones persistentes para agentes y actualizada la documentación de producto, arquitectura, estado y planificación.

## [0.1.0] - 2026-07-24

### Añadido

- Base inicial del proyecto Flutter.
- Módulo Expedientes con persistencia local.
- Módulo Clientes con entidad, tabla Drift, DAO y pantallas de gestión.
- Motor de cálculo de presupuestos para piscinas.

### Cambios

- Inicio de la documentación técnica y funcional de OBRA IA v3.

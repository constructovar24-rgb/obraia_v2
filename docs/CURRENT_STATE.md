# Estado actual de OBRA IA

Fotografía verificada el **31 de agosto de 2026**. Debe actualizarse cuando cambien de forma relevante el producto, la arquitectura, la persistencia o las prioridades. No sustituye a Git, al código ni a las pruebas.

## Base tecnológica

- Flutter/Dart con Riverpod.
- Drift sobre SQLite; 16 tablas y `schemaVersion` 22. Las conexiones activan claves foráneas.
- `pdf` y `printing` para generación documental.
- Windows como plataforma prioritaria.
- 171 archivos Dart en la auditoría de esta línea base.

## Producto presente

Hay implementación para Expedientes, Clientes, Presupuestos, Facturas, Cobros, Compras, Proveedores, Certificaciones, Documentos, Timeline, Dashboard, Búsqueda y Configuración. También permanece un motor heredado de presupuestos de piscinas en `lib/screens`. La presencia de código no acredita por sí sola que una capacidad esté terminada o lista para producción.

La navegación real usa `MaterialApp`, `Navigator` y `MaterialPageRoute`. GoRouter figura en dependencias, pero no está implementado.

## Línea base verificada

- La edición principal de Expedientes permite cambiar código, nombre y cliente, o quitarlo, preservando los demás campos.
- El guardado y su evento único de Timeline son atómicos; ficha y listado se actualizan mediante streams.
- 8 pruebas específicas de Expedientes superadas sobre SQLite en memoria.
- Suite completa: 203 pruebas superadas.
- `flutter analyze --no-pub`: sin incidencias.
- `git diff --check`: sin errores en el cierre funcional; los avisos existentes corresponden a finales de línea de registradores generados.
- Toolchain Windows instalada y validada: Flutter 3.47.1 stable, Dart 3.13.1, Visual Studio Community 2026 18.9.2 y Windows SDK 10.0.26100.0.
- `flutter build windows --debug --no-pub`: compilación debug superada; ejecutable generado en `build\windows\x64\runner\Debug\obraia_v2.exe`.
- La compilación no produjo cambios accidentales en Git.

Flutter está instalado en `C:\src\flutter`, aunque no está incluido globalmente en `PATH`. Es una observación del entorno y no un bloqueo: la compilación es reproducible en este equipo invocando el ejecutable por su ruta completa. Los avisos de Android y Chrome no afectan a la plataforma prioritaria Windows.

Con análisis, pruebas y compilación Windows superados, Expedientes queda técnicamente validado y la fase 0 cumple sus comprobaciones técnicas. Esto no acredita todavía una versión publicable ni la existencia de un instalador.

## Fase actual

La fase 1 está cerrada. Las restauraciones admiten los esquemas 16, 17, 18, 19, 20, 21 y 22, comprobados con integridad, relaciones, documentos emitidos, movimientos económicos y conservación de importes. Se rechazan versiones anteriores o futuras. La aceptación manual Windows con datos ficticios confirmó crear una copia, modificar un cliente y restaurar correctamente el estado anterior. Las pruebas automatizadas nunca tocaron datos reales.

La fase 2 está cerrada. Cliente → Expediente → Presupuesto → aceptación → facturación total o parcial → emisión → cobro y reversión conserva relaciones, importes, estados y Timeline. FAC y RECT emitidas son inmutables, guardan su PDF definitivo exacto con SHA-256 y mantienen numeración independiente y transaccional. Una FAC legacy sin PDF archivado se identifica como reconstrucción de consulta y nunca se presenta ni almacena como original. Las correcciones forman cadenas RECT por diferencias; la cancelación neutraliza el neto familiar mediante RECT sin borrar documentos ni cobros. El crédito derivado admite devolución, compensación entre familias fiscalmente compatibles y reversiones inmutables. IVA, redondeo a céntimos, asignaciones presupuestarias, concurrencia, rollback, migraciones 16–22 y backup/restauración están cubiertos con SQLite aislado.

Las aceptaciones manuales acumuladas confirmaron presupuestos aceptados y facturación parcial, la cadena real `FAC-2026-0004 → RECT-2026-0001 → RECT-2026-0002`, crédito de 121,00 € con devolución de 50,00 € y saldo de 71,00 €, exclusión de destinos fiscalmente incompatibles, y `FAC-2026-0006` con cobros de 500,00 € + 710,00 €, estado cobrada y reversión posterior de 710,00 € que dejó 500,00 € cobrados y 710,00 € pendientes. La incidencia visual de doble activación detectada durante esta última aceptación quedó corregida y cubierta por prueba widget.

## Deuda y riesgos prioritarios

1. La cobertura continúa siendo desigual y aún se concentra principalmente en Facturas; el primer tramo de Presupuestos ya cuenta con pruebas de persistencia y atomicidad.
2. Persisten providers en `data/`, accesos de UI a `databaseProvider`, métodos heredados en `AppDatabase` y archivos grandes.
3. Las rectificativas sustitutivas y la integración de Certificaciones con las asignaciones parciales quedan aplazadas y no forman parte del alcance cerrado de Fase 2.
4. Compras, proveedores, certificaciones, costes y rentabilidad se consolidarán en fases posteriores.
5. Aún no se han verificado un instalador, firma, actualización ni reversión para una distribución publicable en Windows.

## Próximo hito

Iniciar un **rediseño profesional global de la interfaz** como bloque independiente antes de entrar profundamente en la Fase 3. No iniciar todavía cambios económicos de Fase 3 como parte de ese rediseño.

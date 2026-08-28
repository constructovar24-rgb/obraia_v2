# Estado actual de OBRA IA

Fotografía verificada el **28 de agosto de 2026**. Debe actualizarse cuando cambien de forma relevante el producto, la arquitectura, la persistencia o las prioridades. No sustituye a Git, al código ni a las pruebas.

## Base tecnológica

- Flutter/Dart con Riverpod.
- Drift sobre SQLite; 13 tablas y `schemaVersion` 17.
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
- Suite completa: 116 pruebas superadas.
- `flutter analyze --no-pub`: sin incidencias.
- `git diff --check`: sin errores en el cierre funcional; los avisos existentes corresponden a finales de línea de registradores generados.
- Toolchain Windows instalada y validada: Flutter 3.47.1 stable, Dart 3.13.1, Visual Studio Community 2026 18.9.2 y Windows SDK 10.0.26100.0.
- `flutter build windows --debug --no-pub`: compilación debug superada en aproximadamente 67,1 segundos; ejecutable generado en `build\windows\x64\runner\Debug\obraia_v2.exe`.
- La compilación no produjo cambios accidentales en Git.

Flutter está instalado en `C:\src\flutter`, aunque no está incluido globalmente en `PATH`. Es una observación del entorno y no un bloqueo: la compilación es reproducible en este equipo invocando el ejecutable por su ruta completa. Los avisos de Android y Chrome no afectan a la plataforma prioritaria Windows.

Con análisis, pruebas y compilación Windows superados, Expedientes queda técnicamente validado y la fase 0 cumple sus comprobaciones técnicas. Esto no acredita todavía una versión publicable ni la existencia de un instalador.

## Fase actual

La fase 0 está cerrada y sincronizada con el repositorio remoto. La fase 1 dispone de snapshot SQLite consistente, contenedor manual `.obraia-backup` de formato 1 y preparación de restauración en staging a nivel de servicio. Las versiones 16 y 17 se validan; una copia 16 se migra sobre un duplicado temporal y vuelve a comprobarse sin alterar el backup de origen ni la base activa. Diecisiete pruebas específicas usan exclusivamente bases y archivos temporales: tres del snapshot, siete del contenedor y siete del staging. Todavía no existe sustitución de la base activa ni interfaz de usuario.

## Deuda y riesgos prioritarios

1. No existe una estrategia completa y verificada de backup/restauración de la base SQLite.
2. La cobertura es desigual y continúa concentrada principalmente en Facturas.
3. Persisten providers en `data/`, accesos de UI a `databaseProvider`, métodos heredados en `AppDatabase` y archivos grandes.
4. El ciclo económico completo y varias capacidades operativas aún no están consolidados de extremo a extremo.
5. Aún no se han verificado un instalador, firma, actualización ni reversión para una distribución publicable en Windows.

## Próximo hito

Implementar el intercambio recuperable de la base preparada, con cierre verificable, tratamiento conjunto de sidecars y rollback ante fallos inyectados, exclusivamente sobre directorios temporales.

# Estado actual de OBRA IA

Fotografía verificada el **29 de agosto de 2026**. Debe actualizarse cuando cambien de forma relevante el producto, la arquitectura, la persistencia o las prioridades. No sustituye a Git, al código ni a las pruebas.

## Base tecnológica

- Flutter/Dart con Riverpod.
- Drift sobre SQLite; 13 tablas y `schemaVersion` 19. Las conexiones activan claves foráneas.
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
- Suite completa: 152 pruebas superadas.
- `flutter analyze --no-pub`: sin incidencias.
- `git diff --check`: sin errores en el cierre funcional; los avisos existentes corresponden a finales de línea de registradores generados.
- Toolchain Windows instalada y validada: Flutter 3.47.1 stable, Dart 3.13.1, Visual Studio Community 2026 18.9.2 y Windows SDK 10.0.26100.0.
- `flutter build windows --debug --no-pub`: compilación debug superada en aproximadamente 67,1 segundos; ejecutable generado en `build\windows\x64\runner\Debug\obraia_v2.exe`.
- La compilación no produjo cambios accidentales en Git.

Flutter está instalado en `C:\src\flutter`, aunque no está incluido globalmente en `PATH`. Es una observación del entorno y no un bloqueo: la compilación es reproducible en este equipo invocando el ejecutable por su ruta completa. Los avisos de Android y Chrome no afectan a la plataforma prioritaria Windows.

Con análisis, pruebas y compilación Windows superados, Expedientes queda técnicamente validado y la fase 0 cumple sus comprobaciones técnicas. Esto no acredita todavía una versión publicable ni la existencia de un instalador.

## Fase actual

La fase 1 está cerrada. Las restauraciones admiten los esquemas 16, 17, 18 y 19, comprobados con integridad, relaciones y conservación de importes. Se rechazan versiones anteriores o futuras. La aceptación manual Windows con datos ficticios confirmó crear una copia, modificar un cliente y restaurar correctamente el estado anterior. Las pruebas automatizadas nunca tocaron datos reales.

La fase 2 está en curso. Cliente → Expediente → Presupuesto → Factura → Cobro está consolidado técnicamente: convertir un presupuesto aceptado crea un borrador sin número legal; al emitir, se asigna una serie anual `FAC-AAAA-NNNN` y se congelan cliente, empresa, presupuesto y expediente. Facturas y cobros comparten la política monetaria de dos decimales. Los cobros admiten parciales y múltiples movimientos sin sobrecobro; las correcciones económicas se registran como reversiones positivas vinculadas que conservan el original. Alta, reversión, saldo y estado se actualizan atómicamente. La eliminación física queda limitada al saneamiento legacy de facturas ya anuladas.

## Deuda y riesgos prioritarios

1. La cobertura continúa siendo desigual y aún se concentra principalmente en Facturas; el primer tramo de Presupuestos ya cuenta con pruebas de persistencia y atomicidad.
2. Persisten providers en `data/`, accesos de UI a `databaseProvider`, métodos heredados en `AppDatabase` y archivos grandes.
3. Faltan facturas rectificativas completas y facturación parcial; no deben modificarse facturas históricas para resolver esas necesidades.
4. El ciclo económico completo y varias capacidades operativas aún no están consolidados de extremo a extremo.
5. Aún no se han verificado un instalador, firma, actualización ni reversión para una distribución publicable en Windows.

## Próximo hito

Realizar la validación manual aislada de Factura → Cobro y continuar después con facturación parcial como incremento independiente.

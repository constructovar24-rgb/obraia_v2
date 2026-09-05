# PROD-1 — Entornos de desarrollo y producción

## Alcance

PROD-1 separa físicamente SQLite y las copias de seguridad sin cambiar el esquema 32. No borra, mueve, limpia, renumera ni copia los datos de desarrollo. No se han introducido datos reales ni se ha iniciado el piloto real. PROD-2 y Fase 5 permanecen pendientes.

## Arranque y rutas

La carpeta Documentos se obtiene mediante `getApplicationDocumentsDirectory()`; no se fija una ruta personal ni el nombre de una empresa.

| Recurso | Desarrollo | Producción |
| --- | --- | --- |
| SQLite | `<Documentos>/obraia.sqlite` (ruta existente) | `<Documentos>/OBRA IA/production/obraia_prod.sqlite` |
| Carpeta operativa | `<Documentos>/OBRA IA/development/` | `<Documentos>/OBRA IA/production/` |
| Backups nuevos | `development/backups/{manuales,automaticas,recuperacion}/` | `production/backups/{manuales,automaticas,recuperacion}/` |
| Ruta reservada para archivos generados | `development/generated/` | `production/generated/` |

Las rutas abreviadas de backups y archivos generados son relativas a `<Documentos>/OBRA IA/`. Desarrollo conserva expresamente la ubicación histórica de SQLite para no mover ni duplicar la base existente. Los backups antiguos de `<Documentos>/copias_seguridad/` permanecen intactos; las nuevas copias se escriben en las carpetas separadas. Las recuperaciones previas a una migración siguen junto a su SQLite, por lo que tampoco se comparten entre entornos.

El perfil de arranque se guarda en `<Documentos>/OBRA IA/environment.txt` con el valor `development` o `production`. La interfaz lo administra; no es necesario editar código ni rutas. La escritura usa un archivo temporal, flush y renombrado. Si no existe perfil se abre Desarrollo; si es inválido o ilegible, el arranque se bloquea con un mensaje, sin elegir otra base silenciosamente.

El sistema documental actual registra rutas externas y no copia archivos. Los PDFs emitidos congelados están en su SQLite. No se ha rediseñado Documentos ni se han trasladado originales externos: **los originales externos siguen fuera del backup SQLite**. La carpeta `generated` queda definida para salidas administradas; no se afirma que los originales ya se almacenen allí. Los temporales de backup/restauración son carpetas únicas por operación, eliminadas por los servicios existentes, sin reutilización persistente entre entornos.

## Primer arranque de producción

Se crea una SQLite independiente con schema 32. Se reutiliza exclusivamente la inicialización técnica existente:

- Un tenant neutral «Empresa inicial», con UUID nuevo.
- Nueve categorías económicas iniciales y una fila de configuración económica.
- Cero clientes, expedientes, presupuestos, FAC/RECT, cobros, proveedores, compras, costes, documentos y demás registros funcionales.

La configuración fiscal se rellena normalmente en Configuración. No se copian datos de Desarrollo ni se hardcodea una empresa. Se mantienen TenantContext, filtros, relaciones y numeración tenant-scoped. El selector de entornos no habilita un selector multiempresa ni autenticación.

## Cambio deliberado y ciclo de vida

El indicador «Entorno: Desarrollo/Producción» permanece visible por encima de la navegación. Configuración muestra el entorno actual y «Cambiar entorno». El diálogo exige «Confirmar cambio» y avisa del descarte de formularios sin guardar.

Se adquiere el bloqueo exclusivo del lifecycle existente. Durante el cambio se desmontan la navegación, los formularios y todo el contenedor de providers de la sesión. Se espera al final del frame y a las transacciones SQLite pendientes antes de cerrar la conexión. Se abre y valida la base del nuevo entorno, se persiste el perfil y se crea una sesión nueva. No se reutilizan repositorios, streams, cachés ni tenant activo del entorno anterior.

Copias manuales, automáticas, restauración y guardado de Configuración usan el mismo bloqueo, evitando cambios a mitad de esas operaciones. Los callbacks de backup de una sesión antigua se rechazan. Un fallo al abrir el destino o guardar el perfil intenta reabrir el entorno anterior y muestra el error; si tampoco se puede recuperar, no se muestra una sesión operativa.

## Backups y restauración

El manifiesto incorpora `environment` a partir de la instancia de base que origina el backup. Se aplica a copias manuales, automáticas y de recuperación. La restauración compara el manifiesto con la base activa antes de crear recuperación o intercambiar archivos.

- DEV → PROD y PROD → DEV se bloquean.
- Backups antiguos sin el campo se consideran únicamente Desarrollo.
- Un valor desconocido o nulo se rechaza.
- Restaurar dentro del mismo entorno conserva las garantías de staging, validación, recuperación y rollback existentes.

Esto previene errores operativos normales; el manifiesto no es una firma contra manipulación deliberada. Los backups siguen siendo SQLite, no un archivo completo de originales externos.

## Prueba manual posterior (pendiente)

Esta aceptación manual no se ha ejecutado sobre la base actual durante el desarrollo de PROD-1. Las verificaciones automatizadas utilizan exclusivamente temporales.

1. Abrir Desarrollo y confirmar que siguen apareciendo los datos de prueba existentes.
2. Ir a Configuración, elegir Cambiar entorno y cancelar: debe permanecer Desarrollo.
3. Volver a elegir Cambiar entorno y confirmar Producción.
4. Confirmar indicador Producción y listados funcionales vacíos.
5. Cerrar la aplicación y abrirla de nuevo: debe continuar en Producción.
6. Si es necesario, crear un registro claramente ficticio, sin datos fiscales reales, y comprobar su persistencia.
7. Volver a Desarrollo y comprobar que ese registro no aparece.
8. Crear una copia en cada entorno y verificar sus carpetas separadas.
9. Intentar seleccionar en Producción una copia DEV (y a la inversa): debe bloquearse sin sustituir datos.
10. No introducir datos reales ni iniciar PROD-2 o Fase 5.

## Verificación automatizada

Verificación final del 5 de septiembre de 2026:

- `dart format`: aplicado exclusivamente a los 19 archivos Dart propios; dos avisos de estilo corregidos durante el análisis.
- `flutter analyze --no-pub`: sin incidencias.
- `flutter test --no-pub test/features/environment`: 17 pruebas superadas.
- `flutter test --no-pub`: 333 pruebas superadas (una ejecución completa).
- `flutter build windows --debug --no-pub`: superado en una copia aislada del código actual, `build/prod1-verification/`. Se compararon byte a byte 335 archivos de código/configuración con el origen. Ejecutable: `build/prod1-verification/build/windows/x64/runner/Debug/obraia_v2.exe`.
- El primer intento de build en la carpeta habitual falló en INSTALL/CMake, con una instancia de OBRA IA ejecutándose desde esa carpeta. Se conservó la sesión abierta y se validó la compilación aislada; no se ha ejecutado el nuevo binario sobre datos actuales.
- `git diff --check`: sin errores. Los avisos LF/CRLF no son errores del diff.
- `analysis_options.yaml` preservado byte a byte: SHA-256 `75d2d8ff5435cb5d89f2f36d0ae95dcefe6cbb6906f80616094905a33d957e50`; excluido de la entrega.
- Sin push, sin datos reales, sin PROD-2 y sin Fase 5.

Las pruebas específicas cubren rutas, conservación y separación de registros/bytes, tablas vacías salvo inicialización técnica, schema 32, perfil persistido, perfil inválido, rollback por fallo de persistencia, transacciones en curso, conexión cerrada, providers/cachés nuevos, indicador y confirmación, backups manuales/automáticos/recuperación, rechazo cruzado, callbacks antiguos, restauración en PROD y aislamiento tenant. Se mantiene la aceptación manual posterior pendiente.

## Archivos de la entrega

- `lib/core/environment/`: entorno, rutas y perfil persistido.
- `lib/features/environment/presentation/`: coordinación del cambio, sesión y controles de UI.
- `lib/main.dart`, `lib/app/app.dart`, `lib/database/app_database.dart`, `lib/database/database_provider.dart`: arranque, indicador, conexión e invalidación.
- `lib/features/backup/`: manifiesto, creación, restauración, controlador, providers y mensaje de rechazo.
- `lib/features/configuracion/presentation/screens/empresa_configuracion_screen.dart`: selector y protección del guardado frente al cambio.
- `test/features/environment/`: pruebas de datos y widgets.
- `docs/CURRENT_STATE.md`, `docs/MASTER_PLAN.md`, `docs/CHANGELOG.md` y este procedimiento.

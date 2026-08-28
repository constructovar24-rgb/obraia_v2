# Diseño de copias de seguridad y restauración

## Propósito y estado

Este documento guía la fase 1 desde la auditoría inicial. Ya están implementados el snapshot SQLite consistente, el contenedor manual de formato 1 y la preparación validada de una restauración en staging. Todavía no existe sustitución de la base activa ni interfaz de usuario. La prioridad sigue siendo restaurar sin sobrescribir nunca la única copia válida.

## Situación actual

### Base de datos y ciclo de vida

- `AppDatabase` abre de forma diferida `obraia.sqlite` mediante `NativeDatabase`.
- La ruta es `getApplicationDocumentsDirectory()/obraia.sqlite`. En Windows, la ubicación concreta la resuelve `path_provider`; el usuario no debe necesitar conocerla.
- `databaseProvider`, en `lib/database/database_provider.dart`, crea un `AppDatabase` dentro del `ProviderScope` raíz.
- El provider no registra `ref.onDispose(database.close)`. Tampoco existe un coordinador que impida operaciones, cierre la conexión, sustituya la base y reconstruya todos sus consumidores durante una restauración.
- La ruta completa de la base se imprime actualmente con `debugPrint`. No debe aparecer en logs de producción o de backup.

### SQLite, diario y transacciones

- No hay configuración explícita de `journal_mode`, checkpoint, `foreign_keys` ni otros pragmas.
- `NativeDatabase(file)` conserva el modo de diario predeterminado de SQLite. Drift solo activa WAL si se solicita en `setup`, cosa que OBRA IA no hace.
- En la configuración actual no se espera un `obraia.sqlite-wal` persistente. Aun así, el diseño debe detectar y tratar `-wal` y `-shm`, porque podrían existir tras un cambio futuro, una apertura con otra herramienta o una interrupción.
- El proyecto usa transacciones Drift para varias operaciones económicas y de trazabilidad. Copiar directamente el archivo principal mientras la conexión está abierta no es una estrategia de backup aceptable.

### Esquema, migraciones e integridad

- `schemaVersion` actual: 17.
- Hay 13 tablas: `clientes`, `expedientes`, `presupuestos`, `lineas_presupuesto`, `empresa_configuracion`, `facturas`, `factura_lineas`, `cobros`, `compras`, `proveedores`, `certificaciones`, `documentos` y `timeline_events`.
- Las migraciones incrementales cubren cambios de las versiones 2 a 17. La versión 6 reconstruye `presupuestos`; la 17 añade y rellena `iva_porcentaje` en facturas sin recalcular importes históricos.
- Hay relaciones declaradas entre clientes, expedientes, presupuestos, líneas, facturas, cobros, certificaciones, documentos y Timeline. No se declaran acciones `ON DELETE`. `compras.proveedorId` no es una referencia Drift.
- La conexión no activa expresamente `PRAGMA foreign_keys = ON`. La restauración debe ejecutar `PRAGMA foreign_key_check` y no asumir que SQLite impidió previamente todos los huérfanos.
- Solo hay una prueba específica de migración, de 16 a 17. El resto de rutas históricas carece de cobertura automatizada completa.

### Archivos asociados

- `documentos.ruta_archivo` es una ruta obligatoria introducida manualmente. Alta, edición y repositorio no seleccionan, leen ni copian ese archivo al espacio de la aplicación.
- Las fotografías son únicamente un tipo de Documento; no existe un almacén propio de fotografías.
- `empresa_configuracion.logo_path` también almacena texto manual. Los PDF no usan esa ruta: cargan el asset empaquetado `assets/images/logo_empresa.png`.
- Facturas y presupuestos PDF se generan como bytes en memoria y se entregan a `PdfPreview` para imprimir o compartir. OBRA IA no conserva una copia gestionada de esos PDF.
- Por tanto, el único conjunto de datos gestionado actualmente por la aplicación es SQLite. Las rutas externas pueden apuntar a archivos personales, unidades extraíbles o carpetas sincronizadas fuera del control de OBRA IA.

### Dependencias, pruebas y Windows

- Dependencias directas útiles: `drift`, `path_provider`, `path`, `sqlite3`, `archive` y `crypto`. Las tres últimas se declararon directamente al implementar el contenedor de formato 1; sus versiones ya estaban resueltas en el lock.
- No hay un selector de archivos directo (`file_selector` o equivalente) ni una API declarada para obtener la versión de la aplicación.
- Las pruebas de repositorios usan principalmente `NativeDatabase.memory()` y cierran la conexión. La prueba de migración también usa memoria. Snapshot, contenedor, staging e intercambio recuperable disponen de veintiséis pruebas sobre bases y archivos temporales; siguen pendientes la orquestación con backup previo y la integración con el ciclo de vida real.
- La compilación debug de Windows está validada. El intercambio de archivos debe probarse específicamente en Windows por sus reglas de bloqueo y renombrado.

## Alcance del backup

### Formato inicial

La primera versión incluirá:

1. Un snapshot consistente y autocontenido de `obraia.sqlite`.
2. Un manifiesto versionado.
3. Un inventario con ruta interna, tipo, tamaño y SHA-256 de cada payload.

No copiará archivos señalados por `documentos.ruta_archivo` o `empresa_configuracion.logo_path`: son referencias externas, no archivos gestionados, y leerlos automáticamente ampliaría el alcance a documentos personales sin una política de propiedad, permisos o portabilidad. El logotipo empaquetado y los PDF regenerables tampoco se incluirán.

Cuando exista un almacén propio de adjuntos, sus archivos se guardarán bajo una raíz gestionada con identificadores relativos y podrán incluirse bajo `files/`. Nunca se restaurarán rutas absolutas de un equipo en otro.

Los archivos `-wal` y `-shm` no se incluirán como payload normal si el snapshot se genera con `VACUUM INTO`, porque la salida será una base autocontenida. Si una estrategia futura usa copia física, base y sidecars se tratarán como una unidad después de checkpoint y cierre; nunca se copiará solo el archivo principal.

## Formato recomendado

Usar un contenedor ZIP con extensión propia, por ejemplo `obraia-backup-AAAA-MM-DD-HHmmss.obraia-backup`. El nombre no contendrá empresa, cliente, obra, NIF ni información sensible.

Estructura de formato 1:

```text
manifest.json
database/obraia.sqlite
files/                         # reservado para adjuntos gestionados futuros
```

Campos mínimos del manifiesto:

- identificador estable `format`, por ejemplo `obraia-backup`;
- entero `formatVersion`, inicialmente `1`;
- `createdAtUtc` en ISO 8601;
- `appVersion` y `appBuildNumber`;
- `schemaVersion`;
- ruta relativa de la base;
- inventario de entradas con ruta interna normalizada, tipo, tamaño y SHA-256;
- tamaño total sin comprimir y número de entradas.

El manifiesto no contendrá rutas originales absolutas. Su propio hash no se incluye recursivamente; se validarán su estructura y los hashes de todos los payloads. El lector impondrá límites de entradas, tamaños y ratio de descompresión, rechazará rutas absolutas o con `..` y extraerá solo a un directorio temporal propio para impedir ZIP Slip y agotamiento de disco.

Antes de usar `archive` y `crypto`, deberán convertirse en dependencias directas. Para seleccionar origen y destino en Windows se evaluará `file_selector` en una entrega separada. Este diseño no añade dependencias.

## Creación segura

### Alternativas

- **Copia después de cerrar la conexión:** segura si el cierre es verificable y se incluyen los sidecars pertinentes, pero interrumpe la aplicación y hoy no existe un ciclo fiable de cierre y reapertura.
- **Checkpoint WAL y copia:** viable con escrituras serializadas, checkpoint y cierre; es más sensible al modo de diario y a archivos auxiliares.
- **API de backup de SQLite:** ofrece snapshots online robustos y funciona con WAL, pero exige exponer de forma controlada la conexión nativa encapsulada por Drift o coordinar una segunda conexión.
- **`VACUUM INTO`:** SQLite crea una base nueva, compacta y consistente desde la conexión activa. Drift puede invocarlo como sentencia parametrizada y la salida no depende de copiar sidecars. No puede ejecutarse dentro de una transacción y el destino debe ser nuevo.

### Estrategia elegida

Para el primer incremento se recomienda `VACUUM INTO` hacia un archivo nuevo en un directorio temporal privado. Es la alternativa más pequeña compatible con la arquitectura actual y evita copiar una base activa. El servicio serializará las operaciones de mantenimiento para impedir backups o restauraciones simultáneos.

Flujo de creación:

1. Crear un directorio temporal único fuera de la ubicación final.
2. Comprobar espacio disponible con margen y que el destino de `VACUUM INTO` no existe.
3. Ejecutar `VACUUM INTO ?` mediante la conexión Drift activa.
4. Abrir la salida de forma aislada y comprobar `user_version`, tablas esperadas, `quick_check` o `integrity_check` y `foreign_key_check`.
5. Calcular tamaño y SHA-256 del snapshot.
6. Construir y validar el manifiesto.
7. Crear el contenedor en otro archivo temporal, reabrirlo y validar estructura, límites y hashes.
8. Publicarlo solo después de validar. Si el destino está en otro volumen, copiar primero a un nombre temporal en ese volumen, cerrar/sincronizar y renombrar allí.
9. Ante un fallo, conservar intacta la base activa y retirar únicamente los temporales identificados de esa operación.

Un backup no se marcará como correcto hasta que el contenedor publicado se haya reabierto y validado.

## Restauración segura

La restauración será exclusiva y nunca escribirá encima de la única base válida.

1. Seleccionar un archivo `.obraia-backup`.
2. Copiarlo a un directorio temporal privado.
3. Validar límites, estructura, formato, versión, rutas internas, tamaños y hashes antes de tocar la base activa.
4. Rechazar formatos futuros desconocidos, manifiestos incompletos, entradas duplicadas, rutas peligrosas, corrupción o un `schemaVersion` superior al soportado.
5. Extraer a staging. Abrir una copia aislada y ejecutar `integrity_check`, `foreign_key_check`, comprobación de las 13 tablas y `user_version`.
6. Si el esquema es anterior pero soportado, migrar solo otra copia de staging con `AppDatabase` y repetir todas las validaciones. Un fallo rechaza la restauración sin tocar datos activos.
7. Crear y validar automáticamente un backup de recuperación del estado actual.
8. Entrar en modo mantenimiento, impedir nuevas operaciones y esperar las activas.
9. Cerrar explícitamente `AppDatabase` y confirmar que no queda ningún consumidor.
10. En el directorio de la base activa, mover `obraia.sqlite` y cualquier `obraia.sqlite-wal` o `obraia.sqlite-shm` a un conjunto de rollback con nombres únicos. No borrarlos.
11. Mover la base validada desde un staging del mismo volumen a `obraia.sqlite`. La restaurada no llevará sidecars del origen.
12. Abrir una instancia nueva y comprobar versión, tablas, integridad, claves foráneas y una lectura mínima de salud.
13. Si falla un paso posterior al cierre, cerrar la conexión nueva, apartar el intento fallido y devolver el conjunto de rollback completo a sus nombres originales. Reabrir y validar el estado anterior.
14. Solo tras el éxito, invalidar providers dependientes o reconstruir controladamente el `ProviderScope`; pedir reinicio si no se puede demostrar que no quedan referencias antiguas.

En Windows, cualquier handle abierto puede impedir el renombrado. El cierre verificable y las pruebas con fallos inyectados son criterios de aceptación. El intercambio se hará en el mismo volumen para aprovechar el renombrado atómico y no se intentará reemplazar directamente un archivo existente.

## Experiencia de usuario

Configuración incorporará una sección “Copias de seguridad” con:

- **Crear copia de seguridad**;
- **Restaurar copia**;
- fecha y resultado de la última copia verificada;
- recomendación de conservar otra copia en una unidad física o ubicación distinta;
- progreso por etapas: preparando, validando, guardando, restaurando y verificando;
- mensajes diferenciados para cancelación, poco espacio, incompatibilidad, corrupción, fallo de migración y recuperación;
- confirmación reforzada antes de restaurar, mostrando la fecha del backup y explicando que primero se guardará el estado actual;
- acciones deshabilitadas durante otra operación de mantenimiento.

La UI no mostrará términos SQLite, WAL, `schemaVersion` ni rutas internas. Intentar una copia no equivale a tenerla: solo se registrará como correcta después de validarla.

## Seguridad y privacidad

La base incluye datos personales, fiscales y de contacto, además de importes, facturas, cobros, compras y trazabilidad.

- Usar temporales privados y permisos restrictivos disponibles. El borrado normal no garantiza eliminación forense en SSD.
- No registrar filas, rutas externas, manifiestos completos, contraseñas ni nombres sensibles. Los logs se limitarán a identificador de operación, etapa, código de error y métricas no sensibles.
- Advertir que una carpeta sincronizada replica la copia a terceros y puede conservar versiones eliminadas.
- Evitar información sensible en el nombre del backup.
- No subir automáticamente a nube ni inventar servicios, cuentas o credenciales.

### Cifrado

El primer incremento técnico puede producir un backup manual local sin cifrar, con una advertencia clara. Incorporar ahora cifrado autenticado, derivación de clave, UX de contraseña y recuperación de credenciales elevaría el riesgo de generar copias irrecuperables antes de demostrar el flujo básico.

El cifrado debe ser una entrega posterior obligatoria antes de una versión publicable o de automatizar copias en ubicaciones sincronizadas. No se almacenará la contraseña junto al backup ni existirá una contraseña por defecto.

## Arquitectura propuesta

Mantener `Presentation → Providers → Repositories/Services → Drift/SQLite → sistema de archivos`:

- `lib/features/backup/domain/backup_manifest.dart`: manifiesto, versión de formato y entradas.
- `lib/features/backup/domain/backup_result.dart`: estados y errores tipados sin detalles sensibles.
- `lib/features/backup/data/backup_archive_service.dart`: empaquetado, extracción segura, límites, hashes y validación SQLite.
- `lib/features/backup/data/database_snapshot_service.dart`: snapshot consistente mediante `VACUUM INTO`; sin widgets ni Riverpod.
- `lib/features/backup/data/backup_restore_staging_service.dart`: copia privada, migración aislada y ciclo de vida del staging preparado.
- `lib/features/backup/data/database_file_swap_service.dart`: intercambio en el volumen activo, tratamiento conjunto de sidecars y rollback ante fallos.
- `lib/features/backup/data/backup_repository.dart`: orquestación de creación, restauración y copia de recuperación con reloj y sistema de archivos inyectables.
- `lib/features/backup/presentation/providers/backup_providers.dart`: construcción de dependencias, progreso y modo mantenimiento.
- `lib/features/backup/presentation/screens/backup_restore_screen.dart`: UI dentro de Configuración, sin acceso directo a Drift o archivos.
- Un controlador próximo a `databaseProvider` será dueño de abrir, cerrar y reemplazar `AppDatabase`. El provider deberá cerrar con `ref.onDispose`; repositorios y streams se reconstruirán después del intercambio.
- Los validadores de manifiesto, contenedor y SQLite serán componentes separados y funciones puras cuando sea posible.

No hace falta cambiar el esquema para guardar “última copia”: puede mantenerse inicialmente como preferencia local no crítica. Si en el futuro se persiste en SQLite, no será prueba de que el archivo externo siga existiendo.

## Plan incremental

### 1. Prueba de snapshot consistente

**Resultado:** demostrar `VACUUM INTO` sobre una base de archivo temporal con la conexión abierta.

**Aceptación y pruebas:** datos confirmados presentes, transacción no confirmada ausente, integridad correcta, mismo `user_version`, tablas esperadas y original intacto. Probar rutas con espacios y destino existente en Windows.

**Estado:** completado. `DatabaseSnapshotService` serializa el snapshot mediante el bloqueo exclusivo de Drift. Tres pruebas con bases de archivo temporales cubren consistencia e independencia, rollback, esquema e integridad y rechazo de un destino existente. El análisis, las 125 pruebas actuales del proyecto y la compilación debug de Windows están limpios.

### 2. Backup manual con manifiesto e integridad

**Resultado:** contenedor de formato 1, todavía solo con SQLite.

**Aceptación y pruebas:** manifiesto válido, tamaños y SHA-256 correctos, publicación posterior a la reapertura, rechazo de rutas peligrosas y límites, temporales retirados tras éxito o fallo. Añadir como directas únicamente las dependencias aprobadas.

**Estado:** completado a nivel de servicio. El contenedor `.obraia-backup` incluye `manifest.json` y `database/obraia.sqlite`; se publica mediante renombrado en el volumen de destino solo después de validar formato, versión, rutas, límites, inventario, SHA-256, esquema, tablas, `quick_check` y claves foráneas. Siete pruebas temporales cubren creación y reapertura, destino existente, relaciones huérfanas, corrupción, formato futuro, límite de entradas y rutas peligrosas. Aún no hay selector de destino ni pantalla para el usuario.

### 3. Restauración validada en temporal

**Resultado:** convertir un backup en staging migrado y validado sin tocar la base activa.

**Aceptación y pruebas:** rechazar hash incorrecto, ZIP truncado, formato futuro, esquema futuro, tabla ausente, FK inválida y migración fallida. Probar al menos esquemas 16 y 17 y ampliar fixtures históricos soportados.

**Estado:** completado a nivel de servicio para los esquemas 16 y 17. La entrada se fija primero en un temporal privado para impedir cambios entre validación y extracción. Se conservan por separado la base extraída y la copia preparada; solo esta última se migra mediante Drift y se vuelve a validar. Siete pruebas demuestran conservación de datos e importes, limpieza explícita, rechazo de ZIP truncado, esquema futuro, tabla ausente, claves foráneas inválidas y migración fallida. No se abre ni sustituye la base activa.

### 4. Sustitución y recuperación

**Resultado:** cerrar, intercambiar, reabrir y recuperar ante fallo usando bases temporales.

**Aceptación y pruebas:** backup previo validado; fallos inyectados antes y después de cada renombrado; rollback conserva datos; sidecars se apartan como unidad; no quedan handles; providers reciben la nueva instancia. Incluir pruebas Windows.

**Estado:** implementado el primitivo de intercambio recuperable sobre directorios temporales. La base preparada se copia y valida primero en el volumen activo; después del cierre, la base y los sidecars existentes se apartan juntos. Nueve pruebas cubren éxito, archivo preparado inválido, fallos inyectados en cada etapa, fallo de validación de la base nueva y conservación del conjunto de rollback si la recuperación tampoco puede reabrirse. Todavía faltan el backup automático previo, la retención y la integración con el propietario real de `AppDatabase` y sus providers; por ello no se usa aún sobre datos reales.

### 5. Archivos asociados gestionados

**Resultado:** definir un almacén interno e incluir después sus adjuntos con rutas relativas.

**Aceptación y pruebas:** no leer rutas externas automáticamente; política de colisiones; ausencias comunicadas; hashes y referencias restauradas; rollback conjunto de base y archivos. Requiere decisión de producto.

### 6. Interfaz de usuario

**Resultado:** pantalla de Configuración con creación, restauración, progreso, última copia y mensajes recuperables.

**Aceptación y pruebas:** confirmación reforzada, doble envío impedido, cancelación segura antes del intercambio, accesibilidad y teclado, mensajes sin datos sensibles.

### 7. Aceptación Windows

**Resultado:** validar el flujo completo en la plataforma prioritaria.

**Aceptación y pruebas:** rutas largas y con espacios, permisos denegados, poco espacio, unidad retirada y archivos bloqueados; análisis, suite completa, compilación Windows y prueba manual con datos ficticios aislados.

## Decisiones técnicas adoptadas

- Snapshot inicial mediante `VACUUM INTO`, no copia directa de una base abierta.
- Contenedor único versionado con manifiesto y SHA-256.
- Backup inicial limitado a la base, único dato actualmente gestionado por OBRA IA.
- Validación y migración siempre en staging antes de cerrar la base activa.
- Backup automático de recuperación y rollback mediante renombrado en el mismo volumen.
- Sin cambio de esquema en los primeros incrementos.
- Cifrado posterior, pero obligatorio antes de distribución profesional o copias automatizadas/sincronizadas.

## Decisiones de negocio aprobadas

1. La primera versión de validación interna podrá crear backups manuales sin cifrar, con una advertencia clara. No será apta para distribución profesional. El cifrado autenticado será obligatorio antes de entregar la aplicación a usuarios reales o automatizar copias en ubicaciones sincronizadas.
2. La primera versión no copiará documentos, fotografías ni logotipos externos. OBRA IA mantendrá por ahora las referencias existentes. La gestión interna de adjuntos será una fase posterior independiente.
3. Se conservarán las tres últimas copias automáticas de recuperación creadas antes de restauraciones. Las copias manuales nunca se eliminarán automáticamente. Una futura eliminación desde la aplicación requerirá confirmación explícita.

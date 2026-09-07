# PROD-5 — Documentos originales y copias de seguridad

## Alcance y auditoría inicial

Base inicial publicada: `882c1599703c01916321041cfe0759cd2cf0c51f`, schema 35. PROD-4 publicado y cerrado. PROD-5 no importa información real ni habilita cloud, autenticación, sincronización, OCR, PROD-6 o Fase 5.

Antes de este bloque, Documentos conservaba nombre, ruta externa, tipo, tamaño declarado y vínculo con Expediente. Fotografías e incidencias reutilizan Documentos; albaranes y facturas recibidas también se vinculan por documentoId con aislamiento de tenant. No existía copia gestionada del archivo seleccionado. El backup ZIP incluía exclusivamente SQLite y manifest. La restauración ya utilizaba staging, migración temporal, recuperación previa e intercambio con rollback. DEV/PROD estaban separados por EnvironmentPaths; el backup era de la base completa, no de una empresa aislada.

Los PDFs definitivos de presupuestos y de facturas emitidas, junto a snapshots y SHA-256, ya están dentro de SQLite. PROD-5 mantiene esa conservación sin duplicar sus bytes en el almacén externo. Otros PDFs exportados, logos y archivos fuera de Documentos no adquieren protección automática.

**El documento original nunca se sustituye por los datos extraídos. Se conservan ambos y permanecen vinculados.** No se implementa extracción en PROD-5.

## Conservación implementada

El alta de un documento copia el archivo antes de registrar el vínculo. Calcula SHA-256 y tamaño real, conserva nombre original (con extensión), ruta de procedencia, MIME si se indicó, fecha de incorporación UTC y ruta gestionada relativa. El origen permanece intacto. Si el guardado de SQLite falla, puede quedar un archivo sin referencia; se conserva y no se limpia automáticamente.

Estructura bajo el directorio de documentos de la aplicación:

```text
OBRA IA/
  development/
    documents/<SHA-256 del tenant UTF-8>/<SHA-256 del contenido>.original
    backups/{manuales,automaticas,recuperacion}/
  production/
    documents/<SHA-256 del tenant UTF-8>/<SHA-256 del contenido>.original
    backups/{manuales,automaticas,recuperacion}/
```

La SQLite de Desarrollo conserva su ubicación histórica `obraia.sqlite`; la de Producción sigue en `OBRA IA/production/obraia_prod.sqlite`. No se abre ni altera Producción para verificar este bloque.

El nombre físico es determinista y evita problemas de nombres Windows. Archivos con igual nombre y diferente contenido no se pisan; contenido idéntico dentro del mismo tenant reutiliza bytes, con metadatos y vínculos independientes. No se comparten rutas entre tenants. Se rechazan rutas incoherentes y enlaces en la ubicación gestionada. El contenido se verifica antes de aceptar una copia existente. No hay sobrescritura silenciosa de originales.

La edición conserva el original protegido: permite título, fecha, tipo y observaciones, pero no sustituir ruta, nombre, tamaño o MIME. Otro original se incorpora como documento nuevo. La eliminación lógica mantiene tanto el registro como el archivo. Se puede comprobar integridad y exportar una copia con el nombre original; la exportación exige un destino nuevo.

## Migración e históricos

Schema **36**, migración explícita desde 35, aditiva y compatible:

- `documentos.ruta_gestionada`, nullable.
- `documentos.sha256_original`, nullable.
- `documentos.incorporado_utc`, nullable.

Drift regenerado. Las columnas nuevas quedan NULL en documentos antiguos. No se copian, mueven, borran ni reinterpretan archivos históricos. Se muestran como «Archivo externo» y conservan las relaciones existentes. Su disponibilidad se comprueba, pero no se afirma que estén protegidos ni que formen parte del paquete documental.

## Backup v2

Contenedor `.obraia-backup` ZIP con:

1. `manifest.json`: formato y versión 2, entorno, fecha UTC, versión/build de aplicación, schemaVersion, ruta de SQLite, inventario, número de entradas, total de bytes, SHA-256 y tamaño de cada entrada, estado `documentPackageComplete`.
2. `database/obraia.sqlite`: snapshot consistente, con todas las empresas, sus relaciones, datos comerciales/económicos, snapshots y PDFs congelados.
3. `documents/<tenant-hash>/<content-hash>.original`: cada original gestionado referenciado por el snapshot, incluidos documentos eliminados lógicamente. No se copian archivos sin referencia.

El inventario nace de la SQLite del snapshot, no de un recorrido indiscriminado del disco. Se validan SQLite, claves foráneas, metadatos documentales, correspondencia exacta DB/inventario, tamaño y hash de cada archivo, entradas duplicadas, rutas inseguras y contenido inesperado. Una copia normal falla si falta o cambia un original. No publica una copia parcial como válida.

Límites del piloto: 100 MiB por original; contenedor y contenido total hasta 512 MiB; manifest hasta 1 MiB; hasta 1000 entradas contando DB y manifest; límite de compresión 500:1. Superarlos rechaza la operación. El paquete se procesa en memoria: no está diseñado para archivo fotográfico masivo.

Las copias manuales y automáticas usan el mismo formato. Las anteriores de formato 1 siguen identificadas como SQLite sin paquete documental; no se atribuye cobertura de rutas externas. Los snapshots SQLite internos previos a migración tampoco son una copia documental completa.

## Restauración

1. Validar y extraer una copia estable del contenedor en temporales.
2. Migrar SQLite temporal si procede y verificarla, sin tocar la activa.
3. Rechazar paquetes incompletos, otro entorno o un conjunto de empresas diferente.
4. Crear recuperación previa de la base actual. Si sus originales faltan o están alterados, conservar una recuperación explícitamente marcada `documentPackageComplete=false`: protege SQLite, no los archivos, y no se ofrece como restauración documental completa. No se aplica retención al crear esa recuperación incompleta.
5. Cerrar la conexión activa y conservar SQLite/WAL/SHM anteriores en el directorio de intercambio existente.
6. Instalar originales validados antes de activar la SQLite entrante. Reutilizar bytes idénticos; conservar los archivos alterados reemplazados en `documents/.restore-*`. No eliminar archivos válidos que no aparezcan en el backup entrante.
7. Activar y validar SQLite. Solo entonces publicar la nueva sesión.
8. Si falla, retirar originales instalados por la operación, devolver archivos anteriores y ejecutar el rollback de SQLite. Los archivos previos y el backup de recuperación permanecen para recuperación asistida.

Los nombres por contenido permiten conservar archivos no referenciados por la base restaurada sin mezclarlos con sus documentos. No hay limpieza automática del almacén.

Las copias abarcan todas las empresas del entorno. No existe restore de un solo tenant. El control de identidad es estricto: una instalación nueva con otro tenant necesita recuperación asistida y validación de identidad; no se habilita aquí una importación entre empresas. Backups muy antiguos sin identidad compatible también pueden requerir asistencia. El rollback cubre errores de operación inyectados; fallos físicos del disco, apagados y manipulación simultánea por otros programas no equivalen a una transacción distribuida garantizada.

## Interfaz

- Selección del archivo original en Nuevo documento y explicación de su copia.
- «Protegido por OBRA IA» o «Archivo externo» en listado/ficha.
- «Comprobar archivo»: integridad correcta, archivo no encontrado, archivo modificado o metadatos incoherentes.
- «Guardar copia del original» con comprobación y sin reemplazar destinos existentes.
- Errores de guardado visibles y bloqueo de dobles envíos.
- Configuración explica cobertura, alcance de todas las empresas, exclusión de archivos externos y necesidad de una copia fuera del equipo.
- Antes de restaurar, indica formato antiguo o número de originales del paquete y exige confirmación.

## Límites antes de ser archivo documental único

No hay copia off-device automática, cifrado, firma, autenticación, sincronización multi-PC, gestión de permisos ni protección contra manipulación deliberada de la DB y los archivos conjuntamente. OneDrive por sí solo no acredita una copia validada. Debe conservarse otro backup verificado fuera del equipo y ensayar recuperación. Los históricos externos, logos, PDFs no congelados exportados y archivos ajenos al modelo Documentos siguen fuera de cobertura. Una referencia «Protegido» indica incorporación, no una verificación continua: usar «Comprobar archivo». El backup comprueba todos los originales incluidos.

Faltan aceptación manual de este bloque, política operativa de copias externas y procedimiento asistido de recuperación en equipo nuevo antes de tratar OBRA IA como archivo único. No se inicia PROD-6 ni Fase 5.

## Aceptación manual — solo Desarrollo y datos ficticios

1. Confirmar visualmente **Desarrollo**. No seleccionar Producción. Cerrar otras sesiones de la aplicación y no efectuar cambios ajenos a esta prueba entre backup y restauración.
2. En Configuración → Copias de seguridad, crear una copia inicial y conservarla fuera de la carpeta de trabajo de la prueba. Si falla por un original preexistente, detener esta aceptación y revisar el aviso; no borrar datos para hacerla pasar.
3. Crear una carpeta temporal propia `PROD5_PRUEBA` y, con Bloc de notas, un archivo `original.txt` con «Documento ficticio PROD-5». No utilizar información real. Crear un expediente ficticio `PRUEBA-PROD5` y abrir Documentos → Nuevo documento.
4. Seleccionar `original.txt`, poner título «Original de prueba», tipo Otro y guardar. Debe aparecer «Protegido por OBRA IA». Abrir ficha → Comprobar archivo: «Integridad correcta».
5. Renombrar únicamente el archivo de origen de la carpeta temporal a `original-renombrado.txt`. Repetir Comprobar archivo: sigue correcto. Guardar copia del original con un nombre nuevo en la carpeta temporal y abrirla: contenido idéntico.
6. Crear otro archivo temporal llamado `original.txt` con contenido «Segundo documento ficticio PROD-5». Incorporarlo como otro documento. Exportar ambos con nombres nuevos: cada uno conserva su contenido. No deben sustituirse.
7. Abrir el primer documento: ruta, nombre, tamaño y MIME están bloqueados; título/observaciones permanecen editables. Si hay un documento histórico externo, comprobar solamente su etiqueta: no debe aparecer como protegido. No modificarlo ni mover su fuente.
8. Crear un backup manual tras estas altas. Anotar ruta. Cambiar exclusivamente el título del primer documento a «Después de la copia». Restaurar el backup recién creado: confirmar cobertura y sustitución. El título debe volver a «Original de prueba» y ambos originales deben verificar y exportarse correctamente. No efectuar otros cambios durante este intervalo.
9. Copiar ese backup a un archivo desechable distinto `corrupto.obraia-backup` dentro de la carpeta temporal y alterar únicamente esa copia (por ejemplo, reemplazar su contenido por texto con Bloc de notas). Intentar restaurarla: debe rechazarse sin alterar los documentos ni la base actual. No modificar el backup válido.
10. Volver a comprobar los originales y abrir un presupuesto definitivo/factura emitida ficticios existentes, si están disponibles: sus PDFs congelados siguen accesibles. No emitir ninguna factura para esta prueba.
11. Conservar una copia verificada fuera del equipo. Comunicar resultados de cada paso y cualquier aviso. No publicar, no iniciar PROD-6 ni Fase 5. La aceptación no exige borrar el expediente ficticio ni archivos gestionados.

La alteración/pérdida de archivos gestionados, la reparación y el fallo a mitad de restore se verifican automáticamente en temporales; no manipular el almacén de Desarrollo para reproducirlas manualmente.

## Verificación técnica

Verificación final: 439 pruebas superadas (26 nuevas de PROD-5: 9 de originales/repositorio, 13 de backup documental, 2 de UI, 1 de migración y 1 adicional de rollback); analyze sin incidencias; Windows debug compilado en copia aislada con 361 archivos relevantes idénticos; formato propio y git diff --check sin errores.

Veredicto: GO para aceptación manual en Desarrollo, no autorización de uso como archivo único ni de publicación. Regresiones de presupuestos, facturas/PDF congelado, circuito proveedor, entornos, DB/migraciones y backups incluidas en la suite completa. Pruebas siempre en memoria o temporales; Producción y datos de desarrollo existentes intactos. No se ha hecho push.

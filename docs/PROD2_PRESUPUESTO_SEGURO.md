# PROD-2 — Presupuesto seguro

## Alcance y estado

Implementación sobre schema 33 (anterior: 32). Punto de partida: main y origin/main en `92abcf26567dc109f8a03ca986f09b5301040f23`; único cambio previo: `analysis_options.yaml`, excluido de esta entrega. PROD-1 publicado; validación manual DEV/PROD comunicada por el usuario. PROD-2 requiere todavía aceptación manual en DEV. PROD-3, PROD-4, PROD-5 y Fase 5 no iniciados. Sin push ni uso de datos reales.

## Diagnóstico

El PDF anterior no resolvía el cliente canónico del Expediente y utilizaba un logo genérico. Aceptar guardaba el estado, Timeline y un plan económico interno, pero no el documento comercial ni sus bytes. Las partidas seguían siendo editables mientras no tenían historial facturado. La referencia se calculaba fuera de la transacción y solo dentro de cada Expediente.

## Documento y aceptación

`presupuesto_documentos_aceptados` conserva una fila por tenant y presupuesto, con FK compuesta, snapshot JSON versionado, bytes PDF, SHA-256 y fecha UTC de congelación. No depende de rutas para recuperar el original. El logo configurado se incorpora por valor al snapshot y al PDF.

El snapshot incluye identidad técnica y comercial del presupuesto, título, fecha, descripción/condiciones; Expediente/Obra; Cliente canónico (identidad, nombre, apellidos, razón social, NIF, dirección, CP, población, provincia, país, teléfono y email); emisor del tenant (nombre, NIF/CIF, dirección, CP, población, provincia, teléfono, email, web y logo); partidas con concepto, cantidad, unidad, precio y base en céntimos; base total, tipo y cuota de IVA y total.

Validación mínima: cliente vinculado y disponible, nombre o razón social; empresa con nombre y NIF/CIF; referencia no vacía; al menos una partida, concepto y unidad no vacíos, cantidad finita positiva y precio finito no negativo; IVA finito entre 0 y 100. NIF y dirección del cliente son opcionales. No se inventan valores. Un logo configurado ilegible impide congelar el documento hasta corregir su configuración.

Cada partida se redondea a céntimos con la función monetaria existente; la base es la suma de esos céntimos, IVA se redondea sobre esa base y total = base + cuota. Crear/editar/borrar partidas actualiza la cabecera con esa misma suma. Un borrador antiguo cuya cabecera no coincide se rechaza al aceptar, sin cambiarlo automáticamente. El plan económico conserva su modelo y sus costes internos, con las mismas partidas y base de venta que el documento.

La transacción de aceptación valida el borrador, preserva snapshot/PDF/hash, crea plan y partidas económicas, cambia estado y registra Timeline. Cualquier fallo revierte todo. La segunda aceptación se rechaza y no duplica documento, plan ni evento. El botón evita envíos simultáneos y explica la congelación.

## PDF y protección

El borrador se genera desde los datos actuales, indica expresamente que no está aceptado y puede cambiar. El definitivo se descarga/previsualiza devolviendo exactamente los bytes conservados, comprobando SHA-256 e identidad del snapshot; no se regenera desde Cliente, Empresa ni una plantilla posterior. Admite varias páginas, repite cabeceras de tabla, muestra referencia, estado, datos documentales, partidas y totales.

Repositorios y DAOs rechazan editar o borrar presupuestos aceptados, su IVA, importes, partidas y costes previstos de línea, incluso sin facturas. Triggers protegen cabeceras aceptadas y documentos; las partidas con documento congelado tienen también protección SQL. La UI oculta añadir/eliminar y desactiva la apertura de edición. Para cambios se crea otra propuesta; duplicación guiada y versionado formal quedan pendientes.

Los aceptados históricos quedan protegidos por estado sin fabricar snapshot ni PDF. La UI indica que no existe original congelado; no se presenta una reconstrucción como definitivo. La migración no modifica sus importes, partidas, plan, estado ni relaciones.

## Referencias, tenant y facturación

Referencia comercial `codigoExpediente-Pnn`: búsqueda por tenant y creación completa dentro de una transacción. Índice tenant/código y triggers rechazan nuevas colisiones. No se reutilizan referencias borradas. Los duplicados históricos se conservan para no romper la migración; una referencia ambigua bloquea la aceptación de un borrador hasta revisión explícita. No hay renumeración automática ni cambios en FAC/RECT.

Todas las lecturas documentales filtran el tenant activo. PK/FK compuestas protegen la vinculación. Empresas distintas pueden tener la misma referencia comercial. Se conservan los IDs originales de partidas y presupuesto que utiliza facturación total/parcial, sin alterar numeración fiscal ni rectificativas.

## Migración y backup

La migración 32→33 añade tabla, índice y triggers; no rellena documentos históricos ni cambia datos existentes. Se mantiene la recuperación previa a migración y se admite schema 32 como origen. Drift regenerado.

El PDF, logo congelado, snapshot y hash forman parte de SQLite y de su backup. La validación del contenedor exige la nueva tabla para schema 33 y no para versiones anteriores. La restauración en staging migra a 33. Esto no resuelve el backup de los restantes archivos externos de Documentos; esa deuda sigue pendiente.

## Verificación

Pruebas con SQLite en memoria o archivos temporales: documento y branding canónicos, opcionales, logo independiente de ruta, inmutabilidad sin facturas, coherencia del plan, rollback inyectado en PDF/snapshot/plan/Timeline, doble aceptación, códigos concurrentes, tenants, facturación parcial, backup/restauración y corrupción de PDF. Prueba dedicada de migración conserva fila a fila borradores, aceptados, duplicados legacy, líneas, plan, clientes, empresa y Timeline.

Se añaden pruebas de interfaz para borrador, aceptado y legacy. Se ajustan fixtures históricos de facturación y expectativas de esquema actual a 33. Revisión visual de un borrador y de un aceptado de cuatro páginas con datos ficticios, renderizados mediante PDFium local. Verificación final: dart format solo archivos tocados, flutter analyze --no-pub sin incidencias, 366 pruebas de suite completa superadas (incluyen 33 nuevas: 29 documentales, 3 UI y 1 migración), flutter build windows --debug --no-pub superado en build/prod2-verification, sin abrir la aplicación; fuentes de compilación comparadas byte a byte con el repositorio. git diff --check sin errores. Las advertencias de Helvetica proceden de la fuente estándar existente; se ha comprobado visualmente el texto español de los PDFs ficticios.

## Aceptación manual pendiente — solo DEV

1. Confirmar indicador Desarrollo; no cambiar a PROD para esta prueba.
2. Usar una empresa ficticia de prueba con nombre y NIF/CIF; anotar cualquier configuración que se modifique.
3. Crear un cliente ficticio identificable, con nombre/razón social, NIF opcional y dirección de prueba.
4. Crear Expediente/Obra de prueba y vincular ese cliente canónico.
5. Crear presupuesto Borrador con referencia automática y descripción/condiciones.
6. Añadir varias partidas con unidades y cantidades decimales. Revisar base, IVA y total.
7. Abrir «Ver PDF borrador» y verificar emisor, logo configurado si existe, cliente, obra, referencia, fecha, partidas e importes.
8. Modificar una partida del borrador y volver a abrir su PDF; comprobar el cambio.
9. Pulsar «Aceptar presupuesto» y leer/confirmar el aviso de protección.
10. Comprobar estado Aceptado, aviso de documento protegido y ausencia de acciones para añadir, editar o eliminar.
11. Abrir «Ver PDF definitivo», guardarlo y comprobar la identidad e importes aceptados.
12. Cerrar y volver a abrir la ficha y el PDF definitivo; comprobar que el documento permanece disponible.
13. Cambiar únicamente el cliente ficticio de prueba (por ejemplo nombre o dirección) y verificar que el PDF aceptado conserva los datos anteriores.
14. Si resulta razonable, cambiar temporalmente la configuración ficticia de la empresa y comprobar la misma preservación; restaurar manualmente la configuración anotada.
15. Revisar el plan económico: base y partidas coinciden con lo aceptado; costes no informados figuran incompletos.
16. Si se revisa un aceptado histórico, comprobar el aviso de ausencia de PDF congelado.
17. Registrar resultado y cualquier incidencia. No crear factura, no iniciar numeración fiscal, no borrar datos existentes ni introducir datos reales.

La revisión visual automatizada con datos ficticios no sustituye esta aceptación manual del usuario.

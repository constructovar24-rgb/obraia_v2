# PROD-3 — Arranque fiscal seguro

## Estado y alcance

Inicio: main y origin/main en `60ea9ac3f17e28072deab402eaeee3551b9a1e38`, schema 33, única modificación previa `analysis_options.yaml`. PROD-1 y PROD-2 publicados y cerrados; aceptación manual de PROD-2 superada según el usuario.

PROD-3 implementa preparación explícita de numeración fiscal. No configura series reales ni emite documentos reales. PROD-3 cerrado técnicamente; aceptación manual superada en DEV con datos ficticios según confirmación del usuario. Pendiente únicamente validación con gestoría antes de configurar numeración real en Producción. Publicación pendiente de autorización; sin push, PROD-4 ni Fase 5.

## Modelo fiscal y ámbito de unicidad

Schema 34 añade:

- `series_fiscales`: tenant, ejercicio, tipo (`ordinaria` o `rectificativa`), serie configurable, número inicial, siguiente número, preparada, cantidad de emisiones, documentos históricos previos, fecha de configuración y primer uso.
- `eventos_serie_fiscal`: auditoría por tenant/ejercicio/tipo, UUID, acción, detalle JSON y fecha UTC. Registra configuraciones (incluido estado anterior) y emisiones (factura, serie, número y referencia).

PK de configuración: tenant + ejercicio + tipo. UNIQUE: tenant + ejercicio + serie, por lo que ordinarias y rectificativas no comparten serie en un ejercicio. FK compuesta para la auditoría. Se conserva el índice fiscal existente UNIQUE sobre facturas(tenant, serie, año, número). Además se comprueba la referencia textual dentro del tenant antes de emitir.

Formato: `SERIE-EJERCICIO-NNNN`, con al menos cuatro dígitos y sin truncar números mayores. La serie se normaliza a mayúsculas, de 1 a 20 caracteres (A–Z, 0–9, guion o guion bajo). Ejercicio entre 1900 y 9999; inicio positivo menor que 2147483647. El límite superior reserva el último valor como estado agotado; no se desborda ni se reinicia.

Los nombres FAC/RECT no son obligatorios. Los valores heredados de borradores se sustituyen por la serie preparada al emitir; documentos emitidos anteriores no se modifican.

## Preparación y secuencias

Configuración → Numeración fiscal muestra entorno, ejercicio, ambos circuitos, estado, número inicial, próximo número, referencia prevista e información de uso. Cargar otro ejercicio no crea configuración. Los formularios vacíos no proponen números reales por defecto.

«Guardar sin preparar» conserva un borrador de configuración. «Preparar numeración» exige una confirmación que resume ambas series y números y recuerda la validación con gestoría. La preparación conjunta de los dos circuitos es transaccional; si uno es inválido, no se aplica ninguno.

La emisión requiere una configuración preparada para el tenant, tipo y año de la fecha de la factura. No se utiliza el año actual como sustituto. La UI comprueba la preparación antes de confirmar y muestra entorno, ejercicio, serie y próximo número; ese número es una previsión, pues otra emisión puede consumirlo antes.

La asignación lee la secuencia persistida, comprueba ocupación de referencia y número, avanza exactamente una unidad mediante actualización condicional y emite en la misma transacción SQLite. No usa MAX + 1 para asignar. La consulta histórica de máximo sigue disponible para lecturas antiguas, pero no participa en emisión.

La transacción incluye contador, primer uso, cabecera/snapshot fiscal, PDF, Timeline existente y auditoría fiscal. El contador solo se confirma si existe el documento emitido con la referencia asignada y su PDF preservado. Fallos de validación, PDF, auditoría o persistencia revierten todo. No existe una reserva pública independiente que pueda consumir números sin completar un documento.

Dos emisiones no obtienen el mismo número. En una misma conexión se serializan; entre conexiones SQLite puede rechazar una por contención, sin consumir número: se comprueba el estado y se reintenta. No se salta automáticamente un número ocupado. Dos intentos de emitir el mismo borrador solo permiten un éxito.

## Primer uso, histórico y cambio de ejercicio

Después de la primera emisión no se permite cambiar serie, ejercicio, tipo, número inicial, preparación ni retroceder/adelantar manualmente la secuencia. Tampoco borrar configuración ni auditoría. Triggers refuerzan esas reglas. El único avance admitido durante uso es el consecutivo ligado a la emisión.

La preparación sobre una serie histórica exige que el número elegido sea posterior a todos sus números legales existentes y que no mezcle tipos de documento. Los documentos previos se cuentan y muestran; al preparar esa continuidad la configuración también queda protegida. Los documentos identificados en esa serie y ejercicio con tipo incompatible o número legal ausente bloquean la preparación para revisión. Los registros legacy sin ejercicio de numeración requieren revisión manual de continuidad; no se reparan ni renumeran datos automáticamente.

Un año nuevo tiene configuración y contador propios. Puede reutilizarse el nombre de serie en otro ejercicio, y mantenerse configuraciones de años anteriores. No hay apertura automática de ejercicio ni cambios de código para años futuros.

Por simplicidad se admite una serie ordinaria y una rectificativa por tenant/ejercicio. No se implementan múltiples series simultáneas del mismo tipo, cambios excepcionales de una serie ya usada ni correcciones manuales del contador.

## DEV, PROD y compatibilidad

Las mismas reglas se aplican en ambos entornos. Sus bases y backups siguen separados según PROD-1; preparar DEV no prepara PROD. No hay bootstrap fiscal ni configuración derivada automáticamente de facturas ficticias o históricas.

Migración 33→34: crea exclusivamente tablas y triggers nuevos; las series quedan vacías. No renumera facturas ni altera PDF, snapshots, rectificativas, cobros, partidas, presupuestos aceptados o planes. Se admite schema 33 en recuperación previa. Drift regenerado.

La emisión ordinaria y rectificativa conserva el resto de sus reglas y reutiliza el mismo servicio de secuencias con tipos distintos. La rectificación conserva el requisito previo de trazabilidad a un Expediente. La numeración comercial de Presupuestos no cambia.

Backups SQLite contienen configuración, contadores y auditoría junto a los documentos. La validación exige las tablas nuevas para schema 34; backups anteriores migran sin inventar configuración fiscal. La prueba de restauración recupera el próximo número y el PDF.

## Límites operativos

Este incremento no acredita cumplimiento de un régimen fiscal externo ni sustituye la revisión de la gestoría. Antes de la primera factura real deben validarse ejercicio, series, continuidad y números iniciales.

La seguridad transaccional cubre la base activa. Restaurar una copia antigua o usar una copia de la misma base en otro equipo puede omitir emisiones posteriores y desactualizar el contador. Antes de reanudar emisiones tras una recuperación debe contrastarse el histórico externo y la continuidad con la gestoría. No hay autoridad central ni sincronización entre instalaciones, y no debe usarse una misma serie en copias independientes simultáneamente.

El mecanismo de auditoría es local, sin identidad de usuario/autenticación ni sello externo. No se protege contra manipulación externa directa del fichero SQLite. El backup de archivos externos de otros módulos sigue fuera del alcance de PROD-3.

## Verificación técnica

Pruebas en memoria o temporales: preparación por tenant y año, normalización/validación, configuración atómica de ambos circuitos, ausencia de configuración, independencia ordinaria/rectificativa con series personalizadas, consecutivos desde inicio elegido, bloqueo tras uso, colisiones, doble emisión, concurrencia en una y dos conexiones, rollback, continuidad legacy, entorno PROD simulado y backup/restauración.

Prueba de migración reconstruye schema 33 en temporal con presupuesto aceptado, factura ordinaria y rectificativa emitidas y sus PDFs. Compara todas las filas de las tablas existentes antes/después; comprueba ausencia de configuración inventada e integridad referencial. Pruebas de UI comprueban entorno, estado inicial vacío, confirmación de preparación y bloqueo de campos usados. Se ajustan fixtures existentes para preparar únicamente numeración ficticia.

Análisis sin incidencias, 22 pruebas nuevas y suite completa de 388 pruebas superadas; compilación Windows debug en copia aislada idéntica y revisión de diff sin errores. Pruebas nuevas: 19 de repositorio, 2 de UI y 1 de migración. No se han abierto ni modificado las bases actuales para verificar.

## Procedimiento de aceptación manual — solo DEV

1. Confirmar indicador **Desarrollo**. No usar Producción para estas pruebas y no limpiar datos existentes.
2. Usar exclusivamente empresa/cliente/obra ficticios de prueba. No introducir series ni números definitivos de la empresa real.
3. Abrir Configuración → Numeración fiscal y cargar el ejercicio correspondiente a la fecha que tendrán las facturas de prueba. Comprobar que muestra el entorno y que no se ha creado configuración automáticamente.
4. Elegir dos series ficticias sin uso previo, por ejemplo DEMO3 y DEMO3R, con inicios 25 y 7. Si ya existen, usar un ejercicio de prueba distinto sin sobrescribir configuración utilizada.
5. Guardar sin preparar. Crear un presupuesto ficticio vinculado a una obra y cliente, añadir partidas, aceptarlo y convertirlo en borrador de factura.
6. Intentar emitir: debe bloquearse por numeración no preparada, sin número ni PDF definitivo.
7. Volver a Numeración fiscal, revisar ejercicio/series/inicios y pulsar Preparar numeración. Cancelar una vez y verificar que no cambia el estado; volver a preparar y confirmar.
8. Emitir la factura ficticia desde el presupuesto. Revisar referencia DEMO3-ejercicio-0025, datos, snapshot y PDF. Comprobar próximo número 26.
9. Emitir otra factura ficticia de otro presupuesto/parte disponible: debe recibir 26, sin reutilizar 25.
10. Crear y emitir una rectificativa ficticia de la primera factura, con motivo explícito y ajuste válido. Debe usar DEMO3R-ejercicio-0007; el próximo ordinario no cambia.
11. Volver a configuración: comprobar información de uso, campos protegidos y ausencia de mecanismos para reiniciar o borrar el contador.
12. Cargar otro ejercicio: debe tener estado independiente. Un borrador de ese año debe quedar bloqueado hasta prepararlo; su preparación no altera el anterior.
13. Cerrar y reabrir las fichas y PDFs ficticios; verificar referencias y datos preservados.
14. Si se valida backup/restore, hacerlo en una instalación o copia de prueba aislada; no restaurar sobre los datos actuales de desarrollo. Comprobar próximo número, auditoría y PDFs.
15. Registrar resultado, incidencias y referencias ficticias creadas. No borrar las facturas emitidas para limpiar pruebas. No publicar ni iniciar PROD-4/Fase 5.
16. La preparación real de PROD queda para una actuación humana posterior, validada con gestoría antes de la primera factura real.

La aceptación manual comunicada por el usuario está superada. Se comprobó la preparación explícita del ejercicio 2026, el bloqueo sin preparar y sin consumo tras fallo, ordinarias DEMO3-2026-0025 y DEMO3-2026-0026, y rectificativa trazable DEMO3R-2026-0007. Estado final: ordinarias próximo 27 y 2 emisiones; rectificativas próximo 8 y 1 emisión, con ambos circuitos protegidos. También se verificaron los bloqueos de rectificación sin expediente y por superar el disponible del presupuesto. Todo se realizó en Desarrollo con datos ficticios, sin tocar Producción ni emitir facturas reales.

Este resultado es el comunicado por el usuario; la revisión de cierre no abre sus bases. Los pasos del procedimiento sobre otro ejercicio, reapertura de PDFs y restauración aislada no se presentan como comprobaciones manuales comunicadas; mantienen cobertura automatizada. No se requiere repetir la aceptación descrita para cerrar técnicamente PROD-3.

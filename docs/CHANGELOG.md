# Registro de cambios

## No publicado

### Diario de obra — Fase 4-B

- Añadido un Diario tenant-scoped dentro de cada Expediente con fecha, trabajos libres, observaciones, meteorología manual, incidencia textual y actuación opcional.
- Incorporadas edición controlada, anulación lógica, orden cronológico y resumen compacto de la última entrada.
- Mostradas las horas del día desde los partes existentes de Mano de obra, excluyendo partes revertidos y sin duplicar registros ni costes.
- Registradas creación y anulación como eventos relevantes de Timeline en la misma transacción; las ediciones menores no generan ruido.
- Elevado Drift a schema v30 con relaciones compuestas, índices tenant-first, backup/restauración y migración v29 a v30 sin datos inventados.
- Añadida UI adaptable con validación, actuación opcional y protección efectiva frente al doble guardado.

### Planificación básica de obra — Fase 4-A

- Añadido estado operativo independiente: pendiente, preparada, en ejecución, pausada, finalizada o cancelada.
- Incorporadas fechas previstas y reales opcionales con validación de rangos y migración legacy sin fechas inventadas.
- Añadidos próximo paso explícito y actuaciones ordenadas con estados pendiente, completada y cancelada.
- Integrada una pestaña Planificación y un resumen operativo compacto dentro del Expediente.
- Registrados en Timeline los cambios relevantes mediante transacciones y mantenido el cierre económico independiente.
- Elevado Drift a schema v29 con tabla tenant-scoped, índices, backup/restauración y pruebas de migración.

### Mano de obra y tarifas históricas — Fase 3-D

- Añadidas personas económicas internas tenant-scoped para titular/autónomo, empleados y colaboradores, sin introducir nóminas ni RRHH completo.
- Incorporado historial no solapado de tarifas internas de coste por hora; cada parte valorado congela tarifa y coste según la fecha trabajada.
- Las horas sin tarifa quedan pendientes de valorar y se distinguen de un coste explícito de cero.
- Cada parte valorado genera un único hecho canónico de coste y Timeline en la misma transacción; la reversión añade un contramovimiento y conserva el histórico.
- Añadidos agregados de horas, coste por persona/partida, coste sin partida y cobertura completa, parcial o sin valorar.
- Elevado Drift a schema v26 con migración v25 → v26, backup preventivo, relaciones compuestas e índices tenant-first, sin fabricar historia legacy.
- Incorporada una pestaña mínima de Mano de obra en el Expediente para gestionar personas/tarifas y registrar, valorar o revertir partes.

### Hechos canónicos de coste y Compras — Fase 3-C

- Añadido el ledger tenant-scoped `hechos_coste` con importes en céntimos, origen idempotente, categoría y vínculos opcionales al plan económico.
- Separada la clasificación económica de Compra de su estado manual: provisional no suma; gasto incurrido requiere confirmación explícita.
- Incorporadas confirmación y reversión atómicas con Timeline, además de ajustes auditables positivos y negativos.
- Bloqueada la edición silenciosa de Compras devengadas y neutralizado su coste antes de una eliminación lógica.
- Añadidos agregados reproducibles por obra, categoría y costes sin asignar, sin mezclarlos con facturación o cobros.
- Elevado Drift a schema v25; Compras legacy permanecen provisionales y no generan costes inventados.

### Plan económico y categorías — Fase 3-B

- Incorporadas categorías económicas y configuración de indirectos aisladas por tenant, sin valores específicos de una empresa.
- Añadida carga interna de categoría y coste previsto por línea de presupuesto, separada del modelo y PDF comerciales.
- La aceptación genera atómicamente un plan y partidas inmutables junto al estado y Timeline, congelando venta, costes, categorías y parámetros.
- Diferenciados coste desconocido, parcial y completo; beneficio y margen solo se muestran cuando son reproducibles.
- Elevado Drift a schema v24 con migración segura, bootstrap tenant-scoped, backup/restauración adaptados y sin inventar planes legacy.
- Añadidas pruebas de dominio, integración, aislamiento, rollback, migración y regresión.

### Diseño del modelo económico de Fase 3

- Auditadas las fuentes actuales de presupuesto, facturación, cobro, crédito, compras, certificaciones y resumen de obra, sin reinterpretar Compra como factura de proveedor.
- Definidas magnitudes netas de IVA para venta, costes, beneficio, margen y desviaciones, separadas de facturación fiscal y caja.
- Diseñados el plan económico inmutable, los hechos canónicos de coste, mano de obra propia/ajena, compromisos, estimaciones, cierres y trazabilidad.
- Propuestos el modelo mínimo tenant-scoped, la migración conceptual v23 → v24, la secuencia de implementación y la matriz de aceptación, sin modificar código, esquema ni pruebas.
- Cerradas las decisiones de negocio sobre tarifa interna del titular, indirectos previstos, devengo explícito de Compras y cierre/reapertura económica auditable.

### Cierre end-to-end de la puerta multi-tenant P0

- Invalidados repositorios, streams y agregados tenant-scoped al cambiar el contexto activo, evitando cachés cruzadas.
- Retirado el acceso directo a base de datos de la pestaña Cliente del expediente y encapsulado mediante providers/repositorios.
- Sustituido el identificador global de Configuración por UUID independientes, manteniendo una configuración por tenant.
- Ampliada la cobertura a las 16 tablas empresariales, operaciones por ID, configuración, FAC/RECT, relaciones cruzadas, cambio de contexto y backup/reapertura con dos tenants.
- Cerrada P0-C/D con 241 pruebas, análisis estático y compilación Windows debug superados, sin iniciar selector multiempresa, autenticación, cloud, sincronización ni Fase 3.

### Aislamiento multi-tenant v23

- Incorporada la tabla Tenant y `tenantId` obligatorio en las 16 tablas empresariales, con claves y relaciones compuestas que impiden referencias entre empresas.
- Añadida migración transaccional v22 → v23 con tenant inicial neutral, backfill íntegro, validación y copia SQLite previa de recuperación sin sobrescritura.
- Aisladas por tenant las lecturas y escrituras de DAOs/repositorios, búsqueda, dashboard, Timeline, configuración y numeraciones FAC/RECT.
- Adaptados backup y restore al esquema 23 como copia completa de la instalación, conservando la migración segura de copias v22.
- Añadidas pruebas con dos tenants para migración, rollback, relaciones cruzadas, numeración fiscal, contexto ausente, agregados y backup/restauración.

### Expediente / Obra como centro operativo

- Añadida una pestaña Resumen que consolida presupuestos, facturación, cobros, pendiente y compras mediante agregados existentes, sin calcular rentabilidad ni márgenes.
- Reorganizados los accesos del workspace a Presupuestos, Compras, Certificaciones, Facturas, Documentos/fotos, Timeline, Cliente y Datos generales.
- Añadida navegación directa desde la cabecera al Cliente y accesos desde cada bloque del resumen a su área real.
- Conservadas las compras como apuntes de gasto y diferenciados documentos, fotografías, certificaciones y eventos realmente registrados.

### Rediseño profesional de Compras

- Convertida la entrada global en un centro desktop de apuntes de gasto con búsqueda, filtro por estado registrado, obra, proveedor, fecha e importes reales.
- Añadida una ficha profesional con navegación a Proveedor y Expediente, desglose de base, IVA y total, y aviso explícito sobre la ausencia de documento original y movimientos de pago.
- Unificados alta y edición en un formulario responsive con validación, feedback y prevención de doble envío; la eliminación lógica exige confirmación.
- Conservado el modelo existente: una compra pertenece a una obra y guarda proveedor/nombre histórico, fecha, factura opcional, concepto, importes, estado manual y observaciones.
- No se han añadido albaranes, documentos, pagos, vencimientos, reparto multiobra, OCR, automatizaciones ni cambios de esquema.

### Rediseño profesional de Proveedores

- Convertido el directorio global en un listado desktop denso con búsqueda por identidad fiscal, contacto y localidad, contador y estados de carga, error y vacío.
- Reorganizada la ficha en secciones fiscales, de contacto y observaciones que muestran exclusivamente datos reales disponibles.
- Unificados alta y edición en un formulario adaptable con validación, feedback de error y prevención de doble envío.
- Añadidas navegación a la ficha, edición reactiva y confirmación informativa antes de la eliminación lógica.
- Añadida cobertura widget para vacío responsive, búsqueda, detalle, persistencia del formulario, eliminación y doble envío.

### Rediseño profesional de Cobros

- Convertida la entrada global del AppShell en un centro desktop de seguimiento por factura con búsqueda, filtros de situación, vencimiento, total, cobrado y pendiente.
- Conservada la vista mensual utilizada por Dashboard y consolidado el detalle por factura con resumen económico y movimientos auditables diferenciando cobros y reversiones.
- Mejoradas las pantallas de alta y reversión con contexto de factura, saldo pendiente, importe original, disponible para revertir y prevención de doble envío.
- Expuesto desde el repositorio el importe disponible para reversión usando la misma regla validada, sin introducir cálculos económicos en presentación.
- Añadida cobertura widget para vacío responsive, búsqueda, filtros, saldos, vencimiento y apertura de factura.

### Rediseño profesional de Facturas

- Convertido el listado global en una vista desktop densa con búsqueda, filtros documentales, diferenciación FAC/RECT y lectura conjunta de total, cobrado, pendiente y vencimiento.
- Reforzada la ficha con trazabilidad hacia Cliente, Expediente y Presupuesto, documento emitido claramente congelado, confirmación de emisión y familia RECT navegable.
- Integrados los movimientos de cobro y su saldo progresivo junto al resumen económico y al panel de crédito existente.
- Eliminado el acceso directo a `databaseProvider` desde el alta de factura y añadida prevención de doble activación en guardados, emisión, cancelación y registro de cobros.
- Añadida cobertura widget para vacío responsive, búsqueda, filtros FAC/RECT, vencimiento, importes y apertura.

### Rediseño profesional de Presupuestos

- Convertida la entrada global en un listado desktop denso con búsqueda, filtros por estado, contexto de obra/cliente y base, IVA y total.
- Integrada la ficha con accesos directos a Expediente y Cliente, conservando líneas, aceptación, PDF y acciones por estado.
- Conservada sin cambios la lógica validada de facturación parcial, reservas, importes emitidos y pendiente disponible.
- Añadida cobertura widget para vacío responsive, búsqueda/filtros, importes y disponibilidad de apertura del detalle.

### Rediseño profesional de Clientes

- Implantado un listado desktop denso con búsqueda inmediata, contador y estados de carga, error y vacío.
- Convertida la ficha en el centro del cliente, con resumen, contacto y expedientes/obras relacionados.
- Añadidos acceso directo Cliente → Expediente y alta de expediente con el cliente preseleccionado.
- Unificados alta y edición en un formulario adaptable con validación, feedback y prevención de doble envío.
- Añadida confirmación informativa antes del borrado lógico y trasladados los providers de Clientes a presentación.

### Rediseño profesional de interfaz — base desktop

- Sustituida la cuadrícula inicial por un shell persistente con navegación funcional agrupada, cabecera contextual, búsqueda global, actividad y configuración.
- Unificado el tema activo sobre Material 3 y los tokens de `core/ui`, con densidad y contraste orientados a Windows.
- Integrados el dashboard real y Expedientes dentro del shell, con navegación compacta para ventanas reducidas y ficha de Obra organizada por secciones reutilizables.
- Añadida cobertura widget de shell, navegación responsive, dashboard y patrones de Expediente; Fase 2 permanece cerrada y no se incorporan reglas de Fase 3.

### Cierre de Fase 2

- Declarado cerrado el circuito Cliente → Expediente → Presupuesto → facturación total/parcial → emisión → cobros/reversiones → RECT/cancelación → crédito/devolución/compensación.
- Consolidada la evidencia con 203 pruebas, análisis limpio, build Windows y aceptaciones manuales del flujo económico y documental.
- Corregido el doble envío en la pantalla de reversión de cobro: durante una operación en curso el botón queda bloqueado y muestra estado de carga, evitando un segundo error después de una reversión ya confirmada.
- Establecido como siguiente bloque el rediseño profesional global de la interfaz, antes de profundizar en la Fase 3.

### Cierre fiscal de emisión y cancelación

- Las FAC ordinarias conservan el PDF definitivo exacto con SHA-256 y verificación de integridad, igual que las RECT.
- Numeración, snapshot, PDF, hash, estado y evento `facturaEmitida` se confirman atómicamente; los fallos revierten la emisión completa.
- Las FAC legacy sin PDF archivado muestran una reconstrucción de consulta claramente identificada y nunca se archivan como si fuera el original.
- Eliminada la anulación directa de FAC emitidas; la acción `Cancelar mediante rectificativa` crea una RECT por diferencias que neutraliza el neto familiar vigente sin alterar cobros históricos.
- La cancelación reabre la facturación parcial y genera crédito para importes cobrados, compatible con devoluciones y compensaciones existentes.
- La rectificativa sustitutiva queda expresamente aplazada y fuera de los requisitos de Fase 2.

### Crédito de cliente

- Añadido el agregado económico derivado por familia FAC/RECT con pendiente, liquidado, crédito generado, dispuesto y disponible normalizados a céntimos.
- Incorporadas devoluciones y compensaciones inmutables, reversiones parciales auditables, Timeline en origen/destino y acciones desde la ficha de factura.
- Las compensaciones solo vinculan familias del mismo cliente fiscal, liquidan la deuda destino sin crear cobros bancarios y respetan concurrencia transaccional.
- Nuevos cobros, reversiones y cambios rectificativos quedan protegidos por el neto familiar y el crédito ya dispuesto.
- Elevado el esquema a v22; migraciones 16–21 crean movimientos vacíos sin inventar crédito histórico y backup/restauración conserva sus relaciones.
- Corregido el selector de compensaciones para excluir facturas con NIF histórico diferente o incompleto usando la misma identidad fiscal que la validación final.

### Facturas rectificativas por diferencias

- Mostrados en cada ficha el documento padre inmediato y todas sus rectificativas hijas directas, con navegación, estado y efecto económico.
- Permitida desde la ficha la creación de una nueva rectificativa sobre otra rectificativa emitida, conservando documento inmediato, raíz y efectos acumulados.
- Corregida la emisión ordinaria para exigir y congelar nombre/NIF del cliente y nombre/CIF de la empresa, evitando que una factura nueva quede erróneamente inhabilitada para rectificar.
- Incorporada la serie legal independiente `RECT-AAAA-NNNN`, asignada atómicamente al emitir.
- Añadidas cadenas inmutables original–rectificativas, motivo obligatorio y efectos firmados de base, IVA, total, partidas y cantidades.
- Integrados el neto presupuestario, el crédito pendiente sin falsa liquidación y la protección de cobros existentes.
- Conservado el PDF rectificativo exacto en SQLite con SHA-256 y eventos específicos de Timeline.
- Elevado el esquema a v21 con migraciones y restauración verificable desde los esquemas 16 a 20.

### Facturación parcial

- Añadidas facturas parciales acumulativas por porcentaje, importe y selección de partidas o cantidades.
- Los borradores reservan base y cantidades; eliminación y anulación liberan el disponible conforme al estado documental.
- Incorporada trazabilidad mediante asignaciones por línea, resumen reactivo y listado de múltiples facturas por presupuesto.
- Elevado el esquema a v20 con migraciones desde 16, 17, 18 y 19 y estrategia conservadora para facturas legacy.
- Corregido el refresco de número, PDF, cobros y cabecera inmediatamente después de emitir.

### Copias de seguridad

- Definida la estrategia segura de backup y restauración de SQLite.
- Incorporado un primer servicio aislado de snapshot consistente mediante `VACUUM INTO`.
- Añadidas 3 pruebas con bases temporales para consistencia, rollback, integridad y protección del destino.
- Implementado el contenedor manual `.obraia-backup` de formato 1 con manifiesto versionado, inventario, tamaños y SHA-256.
- La copia solo se publica tras reabrir y validar el archivo; se rechazan destinos existentes, corrupción, formatos futuros, rutas peligrosas, relaciones huérfanas y límites excedidos.
- Añadidas 7 pruebas temporales del contenedor; ninguna accede a la base real.
- Incorporada la preparación de restauraciones en staging, conservando separadas la copia original y la migrada.
- Verificada la migración 16→17 con conservación de datos e importes y el rechazo de copias truncadas, esquemas futuros, tablas ausentes, relaciones rotas y migraciones fallidas.
- Añadidas 7 pruebas temporales de preparación de restauración; todavía no se sustituye la base activa.
- Añadido el intercambio recuperable de una base preparada, incluyendo `-wal` y `-shm`, renombrados en el volumen activo y rollback ante fallos.
- Incorporados fallos inyectados en cada etapa; un fallo de recuperación conserva los archivos apartados para intervención posterior.
- Añadidas 9 pruebas temporales del intercambio; el mecanismo todavía no está conectado a la base real ni a la interfaz.
- Incorporado el backup automático de recuperación con nombre no sensible, validación completa y retención de las tres copias más recientes.
- La retención reconoce únicamente copias automáticas gestionadas y nunca elimina backups manuales ni archivos ajenos.
- Añadidas 4 pruebas temporales del backup automático; todavía no está conectado al ciclo de restauración real.
- Añadido `DatabaseLifecycleController` como propietario único de la instancia activa y publicación reactiva tras una reapertura válida.
- Añadido `BackupRestoreCoordinator`, que integra validación, staging, backup de recuperación, intercambio, rollback y reapertura sin widgets.
- Añadidas 4 pruebas temporales de restauración completa, incluidos publicación, fallo previo, rollback y exclusión mutua.
- Añadida la pantalla de Copias de seguridad en Configuración, con creación manual, selector de restauración, confirmación reforzada y mensajes recuperables.
- Añadidas copias automáticas diarias con retención de siete y sin eliminación de copias manuales.

### Expedientes

- Añadida la edición segura de código, nombre y cliente desde la ficha.
- La ficha y el listado reciben las actualizaciones mediante streams reactivos.
- El guardado conserva los demás datos y registra un único evento de Timeline dentro de la misma transacción.
- Añadido tratamiento explícito de errores, doble guardado y desaparición concurrente de expediente o cliente.
- Incorporadas 8 pruebas específicas con SQLite en memoria.

### Calidad y documentación

- Línea base comprobada con `flutter analyze --no-pub` limpio y 134 pruebas superadas.
- Compilación debug de Windows repetida correctamente después de integrar el contenedor de backup.
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
# Fase 3-E

- Añadidos compromisos económicos tenant-scoped, aplicaciones explícitas contra hechos de coste y estimaciones restantes versionadas.
- Añadido forecast de obra con cobertura explícita, comparación con el plan original y soporte de beneficio/margen negativos.
- Añadida migración segura v26→v27, regeneración Drift, compatibilidad de backup y panel mínimo en el resumen del Expediente.
- Añadidas pruebas de consumo parcial/completo, sobreconsumo, reversión, versionado, rollback de Timeline y migración sin datos fabricados.
# Fase 3-F

- Añadido centro económico profesional como pestaña del Expediente.
- Añadidos bloques de previsto inicial, situación actual y previsión final, con desviaciones, cobertura y alertas visuales.
- Añadido desglose real por categorías y «Sin asignar», integración del resumen de mano de obra y navegación a áreas relacionadas.
- El Resumen del Expediente muestra una lectura económica compacta; no cambia el esquema 27 ni las superficies comerciales.
# Fase 3-G

- Añadidos estado económico abierto/cerrado, snapshots de cierre y reaperturas auditables por tenant.
- Añadidos precheck, confirmación de advertencias y alertas deterministas de coste, margen, pérdida, cobertura, clasificación, mano de obra y compromisos.
- Protegidas centralmente las mutaciones económicas sobre obras cerradas.
- Integrados cierre, reapertura e historial en el centro económico.
- Añadida migración segura v27→v28 sin fabricar cierres legacy.

# Plan maestro de OBRA IA

**Fase 3-G implementada técnicamente:** cierre económico explícito con controles, advertencias confirmables, snapshot inmutable, reapertura auditada e historial de cierres sucesivos. Las operaciones que cambian la rentabilidad exigen economía abierta. Alertas y severidad proceden de reglas deterministas existentes, sin notificaciones externas. Esquema v28; Fase 4 no iniciada.

**Fase 3-F implementada técnicamente:** centro económico profesional dentro de cada obra, con previsto inicial, situación actual, forecast final, desviaciones y tabla por categoría. Integra mano de obra y accesos a presupuesto, compras, facturas/cobros, compromisos y estimaciones reutilizando la proyección 3-E. No cambia persistencia ni documentos comerciales. Fase 3-G no se ha iniciado.

El plan ordena resultados, no fechas. Cada fase se aborda con entregas pequeñas y solo se cierra con evidencia verificable. `CURRENT_STATE.md` registra la situación efectiva.

## Fase 0 — Línea base y cierre de Expedientes

**Objetivo:** disponer de una base conocida y estable, con los cambios pendientes clasificados y el flujo de edición de Expedientes cerrado.

**Estado:** cerrada. Expedientes está validado con 8 pruebas específicas, análisis limpio, una suite completa de 99 pruebas y una compilación debug reproducible para Windows. Los grupos de cambios de la línea base se cerraron por separado y el repositorio quedó sincronizado.

**Criterio de salida:** cambios clasificados sin mezclar orígenes; Expedientes revisado y probado; análisis y suite completa superados; compilación Windows verificada con una toolchain compatible; diff y documentación coherentes.

**Transición:** completada hacia la fase 1. La compilación debug validada no equivale a una versión publicable ni a un instalador; esa preparación corresponde a la fase 7.

## Fase 1 — Copias de seguridad, restauración y migraciones

**Objetivo:** proteger la información empresarial antes de ampliar el producto.

**Estado:** cerrada. Backup, restauración, migración soportada, recuperación e interfaz están validados con temporales y aceptación manual Windows con datos ficticios. Se admiten restauraciones de esquemas 16, 17, 18 y 19; versiones anteriores o futuras se rechazan explícitamente.

**Criterio de salida:** creación, validación y restauración de backups probadas sobre copias temporales; recuperación documentada; migraciones desde las versiones soportadas verifican integridad y conservación; ninguna prueba toca la base real.

**Transición:** Fase 2 — Cliente → Expediente → Presupuesto → Factura → Cobro.

## Fase 2 — Cliente → Expediente → Presupuesto → Factura → Cobro

**Objetivo:** consolidar el flujo comercial y financiero principal con trazabilidad y estados coherentes.

**Estado:** cerrada. El circuito Cliente → Expediente → Presupuesto → aceptación → facturación total/parcial → emisión → cobros/reversiones → RECT/cancelación → crédito/devolución/compensación está validado con SQLite aislado y aceptaciones manuales acumuladas. Relaciones, IVA, redondeo a céntimos, numeración concurrente, documentos congelados, PDF exacto con SHA-256, Timeline, estados económicos, rollback, backup y compatibilidad legacy conservan trazabilidad. La modalidad rectificativa sustitutiva queda expresamente aplazada y no es requisito de esta fase.

**Criterio de salida:** pruebas automatizadas y validación manual con datos aislados recorren el ciclo completo; relaciones, transiciones, IVA, redondeos, documentos congelados, anulaciones y cobros mantienen importes y trazabilidad.

**Cierre verificado:** 31 de agosto de 2026, con `schemaVersion` 22, 203 pruebas superadas, análisis limpio y compilación Windows debug reproducible.

**Transición:** antes de entrar profundamente en la Fase 3 se realizará un bloque independiente de **rediseño profesional global de la interfaz**, sin mezclarlo con nuevas reglas económicas.

**Rediseño global — incremento 1:** implementada la base desktop con tema común, shell y navegación persistentes, dashboard real y Expediente/Obra como patrón maestro. Los siguientes incrementos extenderán el sistema por módulos, empezando por Clientes, sin reabrir la Fase 2 ni adelantar reglas de Fase 3.

**Rediseño global — incremento 2:** Clientes queda migrado al patrón desktop profesional con listado denso y buscable, ficha central con contacto y expedientes, formulario compartido de alta/edición, eliminación segura y navegación Cliente → Expediente integrada en el shell. Fase 2 sigue cerrada y Fase 3 continúa sin comenzar.

**Rediseño global — incremento 3:** Presupuestos queda integrado como módulo global desktop con búsqueda, filtros, lectura económica densa y navegación a Cliente/Expediente. El detalle reutiliza sin reinterpretar líneas, aceptación, PDF y facturación parcial validados en Fase 2. Fase 3 continúa sin comenzar.

**Rediseño global — incremento 4:** Facturas queda integrada como módulo financiero-documental desktop con listado FAC/RECT denso, búsqueda y filtros, vencimiento y situación de cobro. Su ficha conserva la lógica validada de emisión congelada, PDF, cobros, cadenas RECT y crédito, añadiendo trazabilidad operativa y protección visual frente a dobles acciones. Fase 3 continúa sin comenzar.

**Rediseño global — incremento 5:** Cobros queda integrado como centro desktop de seguimiento por factura, con búsqueda, filtros, vencimientos, saldos y movimientos auditables. Alta y reversión presentan el contexto económico calculado por repositorios existentes; la vista mensual del Dashboard se conserva. Fase 3 continúa sin comenzar.

**Rediseño global — incremento 6:** Proveedores queda integrado como directorio desktop profesional con búsqueda fiscal y de contacto, ficha adaptable, formulario compartido de alta/edición y eliminación lógica confirmada. No se inventan compras, actividad, métricas ni relaciones ausentes, y Fase 3 continúa sin comenzar.

**Rediseño global — incremento 7:** Compras profesionaliza el apunte de gasto existente vinculado a una obra, con centro global, búsqueda/filtro, detalle, navegación real y formulario compartido. Se separa expresamente del futuro circuito Proveedor → Albarán → Obra → Factura recibida → Pago: no incorpora documentos, pagos, vencimientos, reparto multiobra ni automatización. Fase 3 continúa sin comenzar.

**Rediseño global — incremento 8:** Expediente/Obra queda consolidado como workspace operativo con resumen administrativo basado en agregados reales y accesos a Cliente, Presupuestos, Facturas/Cobros, Compras, Certificaciones, Documentos/fotos, Timeline y Datos generales. No incorpora rentabilidad, margen, beneficio, desviaciones ni reglas nuevas. Fase 3 continúa sin comenzar.

## Puerta arquitectónica multi-tenant — antes de Fase 3

**Visión:** OBRA IA es un producto multiempresa y un empleado digital para autónomos y pequeñas empresas de construcción y oficios relacionados. Construcciones Tovar es el primer tenant y banco de pruebas, nunca una dependencia del core.

**Estado:** puerta P0 cerrada sobre `schemaVersion` 23. Una SQLite puede contener tenants aislados mediante contexto obligatorio, consultas tenant-scoped, relaciones compuestas, invalidación de providers al cambiar contexto y numeraciones FAC/RECT independientes. Siguen fuera de alcance usuario, rol, autorización, selector público, cloud y sincronización.

**P0-A — diseño ejecutable:** completado documentalmente en `MULTI_TENANT_MIGRATION_PLAN.md`. Define tenant inicial, las 16 tablas, rebuild v22 → v23, constraints/FKs e índices compuestos, `TenantContext`, accesos, rollback, validaciones y pruebas. No hay implementación.

**P0-B — migración vertical segura:** implementado. Las 16 tablas incorporan `tenantId`, Drift está regenerado, v22 se protege y migra a v23, y contexto/accesos, numeración fiscal y backup están cubiertos con dos tenants y rechazo de relaciones cruzadas.

**P0-C — ciclo de tenant y endurecimiento:** preparar selección/cambio futuro, invalidación de sesión, retirada de accesos heredados y consolidación de casos de uso. No habilitar multiempresa pública sin autorización/membresías.

**P0-D — fiscal:** aislar secuencias FAC/RECT, snapshots, PDFs, familias, cobros, rectificaciones y crédito, con concurrencia probada entre tenants.

**Cierre P0-C/D:** verificación end-to-end completada con dos tenants, 16 tablas empresariales inspeccionadas, relaciones cruzadas rechazadas, configuración y cachés aisladas, backup/reapertura conservados y suite completa de 241 pruebas. Fase 3 queda técnicamente desbloqueada, pero no iniciada.

**Criterio de salida:** dos tenants de prueba no pueden leer, modificar, relacionar ni eliminar datos entre sí; la migración conserva los datos previos en el tenant inicial; numeraciones y operaciones económicas mantienen las garantías de Fase 2; backup/restauración tienen alcance explícito y probado.

La auditoría completa, prioridades P0–P3 y roadmap revisado están en `MULTI_TENANT_ARCHITECTURE_AUDIT.md`.

## Fase 3 — Gestión económica y rentabilidad por obra

**Objetivo:** ofrecer costes, ingresos, desviaciones, tesorería y margen fiables por expediente.

**Prerequisito:** completar la puerta P0 multi-tenant. Un presupuesto aceptado será el plan económico versionado de la obra y todos los costes, tarifas, márgenes, históricos y métricas pertenecerán al tenant activo.

**Estado:** Fases 3-A, 3-B y 3-C están cerradas; 3-D y 3-E están implementadas técnicamente. Sobre schema v27, el coste real procede exclusivamente de `hechos_coste`; los compromisos se consumen explícitamente contra ese ledger y las estimaciones restantes son adicionales, justificadas y versionadas. El forecast separa plan original y previsión actual y no convierte cobertura desconocida en cero. Fase 3-F no se ha iniciado.

**Secuencia:** 3-B plan económico/categorías y v24; 3-C hechos de coste/Compras; 3-D mano de obra; 3-E compromisos/estimaciones y motor de desviación; 3-F centro económico del Expediente; 3-G cierres, alertas e histórico.

**Criterio de salida:** reglas económicas documentadas y probadas; compras, certificaciones, facturación y cobros concilian; informes reproducibles explican cada cifra con precisión y redondeo consistentes.

**Bloque administrativo futuro aprobado:** facturas recibidas de proveedores; conservación del documento original recibido y del PDF exacto emitido; albaranes vinculados preferentemente a una obra con reparto entre varias obras; líneas exactas de materiales y vinculación posterior a materiales normalizados; histórico de precios reales de compra; conciliación albaranes–facturas; pagos y pendientes de proveedores; costes reales por expediente; IVA soportado/repercutido e IRPF; libros de facturas emitidas/recibidas y resúmenes trimestrales. Se prevé además recepción futura desde correo, extracción asistida por IA, detección de duplicados y propuesta de proveedor/obra. El backup deberá ampliarse para proteger también el archivo documental.

## Fase 4 — Operación de obra

**Objetivo:** consolidar planificación, personal, subcontratas, materiales y documentos vinculados a la ejecución.

**Criterio de salida:** cada capacidad priorizada dispone de flujo completo, reglas, trazabilidad, validaciones y pruebas; los documentos son recuperables y están correctamente vinculados.

## Fase 5 — Deuda arquitectónica y navegación

**Objetivo:** reducir acoplamientos gradualmente y decidir por separado el futuro de GoRouter.

**Criterio de salida:** los flujos tocados siguen la arquitectura objetivo sin regresiones; disminuyen accesos directos desde UI y providers fuera de lugar; una decisión registrada determina mantener Navigator o migrar a GoRouter mediante un proyecto propio.

## Fase 6 — IA segura y auditable

**Objetivo:** incorporar asistencia de IA sin delegar decisiones críticas ni comprometer información empresarial.

**Dirección:** interfaz gráfica, voz, lenguaje natural y automatizaciones invocarán los mismos casos de uso tenant-aware; no automatizarán widgets ni accederán directamente a persistencia.

**Criterio de salida:** casos de uso delimitados, minimización de datos, entradas y salidas auditables, resultados explicables, confirmación humana y pruebas contra acciones incorrectas o no autorizadas.

## Fase 7 — Preparación profesional para Windows

**Objetivo:** entregar una aplicación instalable, identificable, actualizable y recuperable.

**Criterio de salida:** identidad definitiva, compilación reproducible, instalador probado en limpio, firma gestionada con secretos seguros, actualización y reversión verificadas, recuperación validada y guía de publicación completa.

## Evolución posterior — identidad, cloud, móvil y producto multigremio

**Objetivo:** incorporar usuarios con membresías/roles y tenant activo, backend autoritativo, sincronización y offline delimitado, almacenamiento e integraciones por tenant, solicitudes web configurables, branding y módulos por oficio sin forks.

**Condición:** conflictos, timestamps UTC, revisiones, tombstones, idempotencia, secuencias fiscales y documentos por identidad estable deberán definirse antes de habilitar escritura multi-dispositivo.

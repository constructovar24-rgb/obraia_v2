# Plan maestro de OBRA IA

El plan ordena resultados, no fechas. Cada fase se aborda con entregas pequeñas y solo se cierra con evidencia verificable. `CURRENT_STATE.md` registra la situación efectiva.

## Fase 0 — Línea base y cierre de Expedientes

**Objetivo:** disponer de una base conocida y estable, con los cambios pendientes clasificados y el flujo de edición de Expedientes cerrado.

**Estado:** técnicamente superada. Expedientes está validado con 8 pruebas específicas, análisis limpio, una suite completa de 99 pruebas y una compilación debug reproducible para Windows. Queda cerrar por separado la configuración del analizador, el lockfile y los cambios de finales de línea generados, sin mezclar sus orígenes.

**Criterio de salida:** cambios clasificados sin mezclar orígenes; Expedientes revisado y probado; análisis y suite completa superados; compilación Windows verificada con una toolchain compatible; diff y documentación coherentes.

**Transición:** cerrar ordenadamente los grupos de cambios actuales y, después, comenzar la fase 1. La compilación debug validada no equivale a una versión publicable ni a un instalador; esa preparación corresponde a la fase 7.

## Fase 1 — Copias de seguridad, restauración y migraciones

**Objetivo:** proteger la información empresarial antes de ampliar el producto.

**Criterio de salida:** creación, validación y restauración de backups probadas sobre copias temporales; recuperación documentada; migraciones desde las versiones soportadas verifican integridad y conservación; ninguna prueba toca la base real.

## Fase 2 — Cliente → Expediente → Presupuesto → Factura → Cobro

**Objetivo:** consolidar el flujo comercial y financiero principal con trazabilidad y estados coherentes.

**Criterio de salida:** pruebas automatizadas y validación manual con datos aislados recorren el ciclo completo; relaciones, transiciones, IVA, redondeos, documentos congelados, anulaciones y cobros mantienen importes y trazabilidad.

## Fase 3 — Gestión económica y rentabilidad por obra

**Objetivo:** ofrecer costes, ingresos, desviaciones, tesorería y margen fiables por expediente.

**Criterio de salida:** reglas económicas documentadas y probadas; compras, certificaciones, facturación y cobros concilian; informes reproducibles explican cada cifra con precisión y redondeo consistentes.

## Fase 4 — Operación de obra

**Objetivo:** consolidar planificación, personal, subcontratas, materiales y documentos vinculados a la ejecución.

**Criterio de salida:** cada capacidad priorizada dispone de flujo completo, reglas, trazabilidad, validaciones y pruebas; los documentos son recuperables y están correctamente vinculados.

## Fase 5 — Deuda arquitectónica y navegación

**Objetivo:** reducir acoplamientos gradualmente y decidir por separado el futuro de GoRouter.

**Criterio de salida:** los flujos tocados siguen la arquitectura objetivo sin regresiones; disminuyen accesos directos desde UI y providers fuera de lugar; una decisión registrada determina mantener Navigator o migrar a GoRouter mediante un proyecto propio.

## Fase 6 — IA segura y auditable

**Objetivo:** incorporar asistencia de IA sin delegar decisiones críticas ni comprometer información empresarial.

**Criterio de salida:** casos de uso delimitados, minimización de datos, entradas y salidas auditables, resultados explicables, confirmación humana y pruebas contra acciones incorrectas o no autorizadas.

## Fase 7 — Preparación profesional para Windows

**Objetivo:** entregar una aplicación instalable, identificable, actualizable y recuperable.

**Criterio de salida:** identidad definitiva, compilación reproducible, instalador probado en limpio, firma gestionada con secretos seguros, actualización y reversión verificadas, recuperación validada y guía de publicación completa.

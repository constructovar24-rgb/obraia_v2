# Plan maestro de OBRA IA

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

**Estado:** en curso. Cliente → Expediente → Presupuesto → Factura → Cobro está consolidado técnicamente y validado con SQLite aislado. La facturación parcial admite porcentaje, importe y partidas/cantidades con reservas de borrador, acumulados y asignaciones trazables. Los cobros parciales y múltiples, el saldo exacto, el sobrecobro, los estados y las reversiones auditables conservan integridad transaccional y una política monetaria única de dos decimales. Existe un núcleo documental de rectificativas por diferencias con serie propia, cadena inmutable, efecto firmado, integración presupuestaria y PDF exacto verificable. La fase no está cerrada: falta la aceptación manual rectificativa y siguen fuera de alcance devoluciones, compensaciones y modalidad sustitutiva.

**Criterio de salida:** pruebas automatizadas y validación manual con datos aislados recorren el ciclo completo; relaciones, transiciones, IVA, redondeos, documentos congelados, anulaciones y cobros mantienen importes y trazabilidad.

## Fase 3 — Gestión económica y rentabilidad por obra

**Objetivo:** ofrecer costes, ingresos, desviaciones, tesorería y margen fiables por expediente.

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

**Criterio de salida:** casos de uso delimitados, minimización de datos, entradas y salidas auditables, resultados explicables, confirmación humana y pruebas contra acciones incorrectas o no autorizadas.

## Fase 7 — Preparación profesional para Windows

**Objetivo:** entregar una aplicación instalable, identificable, actualizable y recuperable.

**Criterio de salida:** identidad definitiva, compilación reproducible, instalador probado en limpio, firma gestionada con secretos seguros, actualización y reversión verificadas, recuperación validada y guía de publicación completa.

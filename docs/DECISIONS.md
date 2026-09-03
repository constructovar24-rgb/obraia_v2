# DECISIONS.md

Este documento está preparado para registrar decisiones arquitectónicas, tecnológicas y de producto del proyecto OBRA IA v3.

## Producto multi-tenant

- 2026-09-03: OBRA IA se diseña como producto multiempresa y empleado digital para autónomos y pequeñas empresas de construcción y oficios relacionados. Construcciones Tovar es el primer tenant y banco de pruebas, no una dependencia del core.
- 2026-09-03: La frontera de tenant se aplicará con defensa en profundidad: contexto obligatorio en casos de uso, consultas tenant-scoped y constraints compuestos en persistencia. Filtrar solo la interfaz no constituye aislamiento.
- 2026-09-03: Antes de Fase 3 se resolverán tenant inicial, `tenantId` en todas las filas empresariales, relaciones dentro del mismo tenant, configuración, búsqueda, dashboard, Timeline, backup y numeraciones FAC/RECT por tenant.
- 2026-09-03: Los UUID se conservan como identidad técnica. La numeración fiscal definitiva pertenece a tenant, serie y ejercicio y necesitará una autoridad transaccional compatible con concurrencia y futura sincronización.
- 2026-09-03: El documento original es inmutable e independiente de los datos extraídos. Su identidad de dominio no será una ruta física; almacenamiento, branding, plantillas, integraciones y credenciales serán configurables por tenant.
- 2026-09-03: UI, automatización, lenguaje natural y voz compartirán casos de uso con autorización, tenant, validaciones, transacciones, idempotencia cuando corresponda y confirmación humana para acciones relevantes.
- 2026-09-03: El producto se compondrá de core, configuración de tenant, módulos por oficio y plantillas/workflows; no habrá forks por gremio ni tarifas o históricos privados en el core.
- 2026-09-03: El diseño v23 mantiene PK e IDs históricos, añade `tenantId` obligatorio a las 16 tablas empresariales y protege cada relación con FK compuesta hacia `UNIQUE (tenantId, id)`. Las acciones `ON DELETE` siguen siendo `NO ACTION`.
- 2026-09-03: Una instalación v22 crea transaccionalmente un UUID v4 de tenant inicial. Su nombre procede de la configuración si es inequívoca y no vacía; en otro caso usa “Empresa inicial”. No se deriva identidad de Construcciones Tovar ni se usa un UUID común entre instalaciones.
- 2026-09-03: P0-B será una migración vertical: esquema v23, contexto local mínimo y accesos tenant-scoped se implementarán juntos. Separar persistencia y consultas dejaría escrituras incompatibles o lecturas globales inseguras.
- 2026-09-03: v23 mantiene temporalmente `MAX(numeroLegal) + 1` dentro de la transacción de emisión, aislado por tenant, serie y ejercicio. Una tabla de secuencias se aplaza; un futuro servidor será autoridad del número fiscal definitivo.
- 2026-09-03: P0-B materializa la defensa en profundidad con `TenantContext` obligatorio, claves candidatas `(tenantId, id)` y FKs compuestas expresadas mediante constraints SQL de Drift e inspeccionadas en SQLite. Los defaults de tenant solo facilitan fixtures de prueba; producción resuelve el contexto antes de operar.
- 2026-09-03: una base v22 cerrada recibe antes de abrir Drift un snapshot SQLite validado y no sobrescribible. El restore sigue siendo de instalación completa; exportación o fusión por tenant quedan fuera de P0-B.

## Interfaz y navegación

- 2026-09-01: La interfaz prioriza Windows mediante un shell desktop persistente con barra lateral adaptable, cabecera de contexto y un navegador interno basado en `Navigator`; no se introduce GoRouter incidentalmente.
- 2026-09-01: `core/ui` es la fuente activa de tema, color, tipografía y espaciado. Las pantallas se migrarán por incrementos y no mediante una reescritura global.
- 2026-09-01: Expediente/Obra es el patrón maestro operativo. Los módulos sin vista global real pueden estar presentes en la navegación, pero deben dirigir al flujo existente o explicar su alcance sin inventar datos.
- 2026-09-01: Clientes es el segundo patrón desktop profesional. Su ficha concentra identificación, contacto y expedientes reales; alta y edición comparten formulario, la UI consume providers de presentación y la navegación Cliente → Expediente continúa sobre `Navigator` dentro del shell.
- 2026-09-01: El borrado de Clientes conserva la eliminación lógica existente y exige confirmación informativa, incluyendo la presencia de expedientes asociados, sin alterar reglas de persistencia.
- 2026-09-01: Presupuestos es el tercer patrón desktop profesional. Presentation muestra base, IVA, total y facturación parcial exclusivamente desde valores y resúmenes existentes; no recalcula reservas, asignaciones ni disponibilidad con reglas nuevas.
- 2026-09-02: Facturas es el cuarto patrón desktop profesional. La interfaz distingue estado documental y económico, y muestra importes, cobros, familia RECT y crédito solo desde repositorios y modelos existentes; la emisión conserva su transacción y añade confirmación visual sin reinterpretar reglas fiscales.
- 2026-09-02: Cobros es el quinto patrón desktop profesional. El centro global se organiza por facturas ordinarias operativas y consume `FacturaConEstadoEconomico`; las RECT continúan como ajustes documentales en Facturas y no se reinterpretan como cobros. El disponible de reversión se expone desde el repositorio para evitar duplicar reglas en presentación.
- 2026-09-03: Proveedores es el sexto patrón desktop profesional. Su ficha se limita a identidad fiscal, contacto, domicilio y observaciones existentes; no muestra compras, actividad ni indicadores sin una relación real en el modelo. Alta y edición comparten formulario y el borrado conserva la eliminación lógica existente.
- 2026-09-03: Compras es el séptimo patrón desktop profesional y conserva su significado actual de apunte de gasto asociado a un único expediente. El estado pendiente/pagada/anulada es un valor manual existente, no un libro de pagos. El número de factura opcional no convierte el registro en una factura recibida documental.
- 2026-09-03: El futuro circuito administrativo mantendrá el documento original como evidencia independiente de los datos estructurados extraídos. Albaranes, facturas recibidas, pagos, vencimientos, reparto multiobra, almacén, precios históricos, email, OCR e IA quedan fuera de este incremento.
- 2026-09-03: Expediente/Obra es el octavo patrón profesional y centro operativo. Su resumen consume agregados de repositorio para presupuestos y estado económico de facturas; Presentation solo compone la información y enlaza las áreas existentes. Quedan expresamente excluidas las métricas de rentabilidad de Fase 3.

## Formato recomendado
- Fecha
- Contexto
- Decisión adoptada
- Justificación
- Consecuencias

## Ejemplo
- 2026-07-24: Se adopta la estructura modular por features para nuevos módulos.
- 2026-07-24: Se mantiene Drift + SQLite como capa de persistencia local.
- 2026-07-24: Se reutiliza el patrón existente de Expedientes para Clientes.

## Factura → Cobro

- 2026-08-29: Un cobro confirmado es histórico y no se sobrescribe ni elimina en el uso normal. Las correcciones económicas se representan mediante movimientos positivos de reversión vinculados al cobro original.
- 2026-08-29: El cobrado aplicado es el neto de cobros menos reversiones, normalizado con la política monetaria común de dos decimales. El sobrecobro permanece prohibido y saldo `0,00` determina el estado `cobrada` sin exigir conciliación bancaria.
- 2026-08-31: Una FAC emitida no se anula directamente, aunque todos sus cobros hayan sido revertidos. Toda cancelación fiscal se representa mediante RECT por diferencias; la reversión solo corrige el movimiento de cobro.
- 2026-08-29: Los métodos admitidos son Transferencia, Efectivo, Tarjeta, Domiciliacion y Otro. Otro requiere descripción; los valores legacy desconocidos se conservan al mostrarse y no se sustituyen silenciosamente.

## Facturación parcial

- 2026-08-29: La base imponible sin IVA es la magnitud de control. Los borradores reservan y las facturas emitidas consumen asignaciones; las anuladas dejan de consumirlas.
- 2026-08-29: La trazabilidad se conserva en una tabla de asignaciones entre presupuesto, partida, factura y línea de factura, con cantidad opcional, base aplicada y vínculo futuro nullable a Certificaciones.
- 2026-08-29: Porcentaje e importe se reparten proporcionalmente sobre partidas disponibles; el residuo de céntimos se asigna de forma determinista sin superar ninguna partida.
- 2026-08-29: Las facturas legacy vinculadas sin asignaciones consumen su subtotal global, pero no se inventan cantidades por partida. Se bloquea nueva facturación parcial hasta regularizarlas.

## Facturas rectificativas

- 2026-08-30: La Fase 2 utiliza rectificativas por diferencias. La modalidad sustitutiva queda aplazada a una fase posterior y su ausencia no bloquea el cierre de Fase 2.
- 2026-08-30: Una FAC emitida no cambia directamente a `anulada`. La cancelación crea una RECT por diferencias con motivo obligatorio que neutraliza el neto vigente de toda la familia; la FAC, sus cobros y todos los documentos previos permanecen históricos.
- 2026-08-30: FAC y RECT nuevas conservan exactamente los bytes del PDF definitivo y su SHA-256. Las FAC legacy sin archivo no se completan retrospectivamente: la UI solo permite una reconstrucción inequívocamente identificada como no original.

- 2026-08-29: La primera modalidad soportada es exclusivamente la rectificación por diferencias. Una rectificativa conserva el documento rectificado y la factura ordinaria raíz; puede ser rectificada de nuevo sin reescribir ningún documento emitido.
- 2026-08-29: Las rectificativas usan la serie anual independiente `RECT-AAAA-NNNN`, numerada al emitir. La unicidad legal se controla por serie, año y correlativo; las facturas ordinarias existentes conservan `FAC` y su numeración histórica.
- 2026-08-29: El efecto económico se persiste con signo y se aplica a las asignaciones del presupuesto. Los documentos ordinarios y rectificativos emitidos son inmutables y la rectificación acumulada no puede superar la base, IVA o cantidad de la factura raíz.
- 2026-08-29: Un saldo a favor se muestra como crédito pendiente. No se considera liquidado, no altera cobros existentes y todavía no admite devolución bancaria ni compensación.
- 2026-08-29: El PDF rectificativo emitido se conserva exactamente en SQLite junto con su SHA-256. El backup protege el binario como parte de la base de datos.

## Crédito de cliente

- 2026-08-30: El crédito es un agregado derivado por familia FAC/RECT; no se persiste un saldo editable. Su fuente de verdad son el neto documental efectivo, los cobros netos y los movimientos inmutables de crédito.
- 2026-08-30: Devolución, compensación y sus reversiones son movimientos distintos de cobros y reversiones de cobro. Una compensación solo une familias del mismo cliente fiscal y liquida el destino sin movimiento bancario.
- 2026-08-30: Toda disposición valida céntimos disponibles dentro de la misma transacción. Cobros, reversiones y cambios RECT se bloquean cuando dejarían crédito dispuesto sin respaldo.
- 2026-08-30: Ningún movimiento económico confirmado se edita o elimina en el flujo ordinario; las correcciones se representan mediante reversiones vinculadas y parcialmente acumulables.
- 2026-08-30: Selector y confirmación de compensaciones usan una única identidad fiscal conservadora: mismo cliente estructural y NIF histórico congelado, no vacío y coincidente tras normalizar formato. Una factura legacy sin NIF histórico no es elegible y no se modifica automáticamente.

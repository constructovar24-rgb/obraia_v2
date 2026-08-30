# DECISIONS.md

Este documento está preparado para registrar decisiones arquitectónicas, tecnológicas y de producto del proyecto OBRA IA v3.

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

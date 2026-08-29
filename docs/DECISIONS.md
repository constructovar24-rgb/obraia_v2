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
- 2026-08-29: Una factura con saldo neto cobrado mayor que cero no puede anularse. Tras revertirlo completamente puede utilizarse la anulación documental existente.
- 2026-08-29: Los métodos admitidos son Transferencia, Efectivo, Tarjeta, Domiciliacion y Otro. Otro requiere descripción; los valores legacy desconocidos se conservan al mostrarse y no se sustituyen silenciosamente.

## Facturación parcial

- 2026-08-29: La base imponible sin IVA es la magnitud de control. Los borradores reservan y las facturas emitidas consumen asignaciones; las anuladas dejan de consumirlas.
- 2026-08-29: La trazabilidad se conserva en una tabla de asignaciones entre presupuesto, partida, factura y línea de factura, con cantidad opcional, base aplicada y vínculo futuro nullable a Certificaciones.
- 2026-08-29: Porcentaje e importe se reparten proporcionalmente sobre partidas disponibles; el residuo de céntimos se asigna de forma determinista sin superar ninguna partida.
- 2026-08-29: Las facturas legacy vinculadas sin asignaciones consumen su subtotal global, pero no se inventan cantidades por partida. Se bloquea nueva facturación parcial hasta regularizarlas.

# Fase 3-A — Modelo económico y rentabilidad por obra

Estado: **Fase 3-A cerrada; 3-B, 3-C y 3-D implementadas técnicamente**. Fecha de actualización: 4 de septiembre de 2026. El esquema vigente es v26 y las reglas fiscales existentes permanecen separadas.

## 1. Principios y lenguaje oficial

La rentabilidad pertenece al Expediente/Obra y se calcula normalmente **sin IVA recuperable o repercutido**. Se mantienen separadas cuatro dimensiones:

1. **Venta prevista:** lo aceptado comercialmente por el cliente.
2. **Coste previsto:** recursos que se estima consumir para ejecutar esa venta.
3. **Coste real:** recursos efectivamente consumidos o devengados por la obra.
4. **Facturación y cobro:** documentos fiscales emitidos y movimientos financieros recibidos.

Nunca se consideran equivalentes `presupuestado`, `facturado`, `cobrado`, `comprado`, `pagado`, `coste previsto`, `coste real`, `beneficio` o `caja`. Un hecho económico se reconoce una sola vez; documento, vencimiento y pago son evidencias o liquidaciones del mismo hecho, no costes nuevos. **Rentabilidad, facturación y tesorería son dimensiones distintas**: una obra rentable puede tener mucho pendiente de cobro, y un anticipo puede producir caja positiva mientras la estimación final proyecta pérdidas.

Términos oficiales:

- **Recargo (markup) %** = `beneficio / coste × 100`; no se etiqueta como margen.
- **Margen sobre venta %** = `beneficio / venta × 100` cuando venta es positiva.
- **Beneficio** = `venta − coste`.
- Los porcentajes no se muestran cuando el denominador no es positivo; se muestra “No disponible”.

## 2. Auditoría económica del modelo actual

| Concepto | Qué representa y fuente de verdad | Qué no representa / limitación para rentabilidad | Estado y tenant |
|---|---|---|---|
| Expediente | Agregado de obra, cliente, ubicación y ciclo; `expedientes` | No tiene fechas de cierre económico ni reglas de rentabilidad | Activo/archivado; tenant-scoped |
| Presupuesto | Cabecera comercial con base `importeTotal`, IVA y estado; `presupuestos` | No guarda coste, margen, versión ni snapshot económico completo | Borrador/aceptado y valores heredados como presentado; tenant-scoped |
| Línea de presupuesto | Cantidad, unidad, precio unitario de venta e importe dinámico; `lineas_presupuesto` | No tiene categoría, jerarquía ni desglose de coste; usa `double` y no redondea explícitamente cada línea | Vinculada al presupuesto; tenant-scoped |
| Aceptación | Transición transaccional de borrador a aceptado y evento Timeline | No congela hoy una copia separada; las líneas solo quedan protegidas cuando tienen historial facturado | Estado en presupuesto; tenant-scoped |
| Facturación parcial | Consumo de base aceptada por factura y `factura_asignaciones_presupuesto` | Es grado de facturación comercial, no avance físico ni coste | Borrador reservado / emitido facturado; tenant-scoped |
| FAC | Documento fiscal ordinario con base, IVA, total, vencimiento y snapshot al emitir | No acredita cobro, producción ni coste | Borrador/emitida/cobrada/vencida/anulada; tenant-scoped |
| RECT | Ajuste fiscal por diferencias con efectos base/IVA/total y familia documental | No es un coste ni una devolución bancaria por sí misma | Misma disciplina documental; tenant-scoped |
| PDF emitido | Binario y SHA-256 del documento definitivo; `factura_documentos_emitidos` | Evidencia documental, no métrica económica adicional | Inmutable; tenant-scoped |
| Cobro | Movimiento positivo y reversión vinculada; `cobros` | No modifica beneficio; solo liquidación/tesorería | Neto por suma firmada; tenant-scoped |
| Crédito cliente | Devoluciones, compensaciones y reversiones sobre familia FAC/RECT | No es venta ni coste; explica liquidación y saldo a favor | Movimientos inmutables; tenant-scoped |
| Compra | Apunte administrativo de gasto con obra, proveedor opcional, base, IVA, total y estado manual | No acredita factura recibida, albarán, obligación ni pago; carece de líneas, reparto multiobra y documento original | Pendiente/pagada/anulada, borrado lógico; tenant-scoped |
| Proveedor | Identidad fiscal y contacto | No aporta importes, tarifas ni saldos | Activo/borrado lógico; tenant-scoped |
| Certificación | Cabecera de avance declarada con base, IVA, total y posible presupuesto | No tiene detalle por partida ni semántica suficiente para producción devengada; no debe alimentar rentabilidad automáticamente | Borrador/emitida/facturada; tenant-scoped |
| Configuración | Datos empresariales usados, entre otros, en snapshots fiscales | No contiene tarifas, política de indirectos ni categorías de coste | Singleton por tenant |
| Timeline | Trazabilidad operativa de acciones | No es libro económico ni fuente de importes | Eventos tenant-scoped por expediente |
| Dashboard/Resumen de expediente | Agregados dinámicos de presupuesto, facturas, cobros y compras | Sus “compras” no equivalen a coste contable completo; no calcula margen | Lectura tenant-scoped |

Otros datos económicos existentes: descuentos e importes de líneas de factura; asignaciones de base por partida; vencimientos; estados documentales; numeración fiscal concurrente; snapshots de cliente/empresa/expediente; y conservación de importes en migraciones y backups.

## 3. Magnitudes oficiales de una obra

Todas las magnitudes de rentabilidad son netas de IVA, se calculan en céntimos y se presentan a dos decimales. `ND` significa no disponible; nunca se sustituye por cero un dato desconocido.

| Magnitud | Fórmula y fuente | Disponibilidad, IVA y naturaleza |
|---|---|---|
| Venta prevista | Suma de base de las versiones de plan vigentes | Al existir plan aceptado; sin IVA; snapshot |
| Coste directo previsto | Suma de material + mano de obra + maquinaria + subcontrata + transporte + alquiler + tasa/residuo + otros directos del plan | Solo con desglose de coste; sin IVA recuperable; snapshot |
| Indirectos previstos | Política congelada del plan aplicada a su base | Si la política está definida; sin IVA; snapshot |
| Coste total previsto | Directo previsto + indirectos previstos | Requiere ambos componentes; snapshot |
| Beneficio previsto | Venta prevista − coste total previsto | ND si falta coste previsto; snapshot |
| Margen previsto | Beneficio previsto / venta prevista × 100 | ND si venta ≤ 0 o coste incompleto; snapshot |
| Coste real acumulado | Suma de hechos de coste activos devengados | Disponible por cobertura; sin IVA recuperable; dinámico y trazable |
| Coste comprometido pendiente | Compromisos aprobados − importe ya convertido en coste real − cancelaciones | Solo si se registran compromisos; sin IVA; dinámico |
| Coste pendiente estimado | Última estimación explícita todavía necesaria, excluyendo real y comprometido | ND sin estimación; snapshot fechado y revisable |
| Coste final estimado | Coste real + compromiso pendiente + coste pendiente estimado | Solo si los tres componentes están disponibles; dinámico sobre snapshots |
| Facturado neto | Base de FAC efectivas + efectos base de RECT efectivas | Tras emisión; sin IVA; dinámico desde familia documental |
| Cobrado neto | Cobros netos + compensaciones recibidas, con reversiones | Importe financiero **con IVA** liquidado; dinámico |
| Pendiente de cobro | Máximo entre cero y total fiscal neto de familia − total liquidado | Con IVA; dinámico; no es beneficio |
| Resultado realizado acumulado | Producción reconocida neta − coste real asociado al mismo grado de ejecución | Solo con criterio de producción fiable; ND inicialmente si no existe avance fiable |
| Beneficio final estimado | Venta final estimada − coste final estimado | ND si falta una estimación; dinámico |
| Margen final estimado | Beneficio final estimado / venta final estimada × 100 | ND si venta ≤ 0 o estimación incompleta |
| Beneficio de obra cerrada | Venta final neta − coste real final | Solo tras cierre económico; snapshot de cierre |
| Desviación de costes € | Coste real comparable o coste final estimado − coste previsto comparable | Positivo = sobrecoste; por total/categoría/partida |
| Desviación de costes % | Desviación / coste previsto comparable × 100 | ND si previsto ≤ 0 |
| Avance económico | Coste real comparable / coste final estimado × 100 | Indicador auxiliar, no avance físico; solo con estimación fiable |

La **venta final estimada** es la venta vigente del plan más modificados aprobados. El “pendiente de facturar” es venta vigente menos base neta ya facturada y reservada según las reglas actuales; no implica trabajo pendiente.

## 4. IVA, precisión y redondeo

- Rentabilidad: bases netas. El IVA recuperable de compras y costes queda fuera; el IVA no recuperable se incorpora al coste con motivo explícito y snapshot de su proporción recuperable.
- Facturación fiscal: conserva base, cuota, tipo y total según el motor actual.
- Cobro y pago: magnitudes de caja por total liquidado, incluido IVA.
- Costes de mano de obra propia no llevan IVA.
- Cálculos monetarios persistidos: céntimos enteros o equivalente exacto; cantidades/horas admiten precisión decimal suficiente, recomendada escala 4. Resultados monetarios se redondean por línea/hecho y después se suman, reutilizando la política half-away-from-zero de `redondearMoneda`.
- Los datos actuales en `REAL` siguen válidos; la migración no los reinterpretará ni redondeará de nuevo.

## 5. Presupuesto aceptado como plan económico

Aceptar un presupuesto creará en el futuro una **versión inmutable del plan**. Congelará cabecera, estructura, partidas, cantidades, precios de venta, desglose de costes, política de indirectos, venta/coste/beneficio/margen y fecha de aceptación. Cambios posteriores de tarifas o catálogos no alterarán ese snapshot.

Reglas para varios presupuestos:

1. Un presupuesto aceptado inicial crea el plan base.
2. Una revisión que sustituye completamente al anterior crea una nueva versión y marca la previa como sustituida; solo la vigente suma.
3. Una ampliación o modificado aprobado crea una versión incremental ligada al plan; suma únicamente su delta aprobado.
4. Borradores, rechazados, presentados y versiones sustituidas no alimentan la venta prevista.
5. Cada partida del plan conserva identidad estable de seguimiento aunque proceda de otra línea/versionado; no se suman simultáneamente original y sustitución.
6. Corregir un plan aceptado exige una nueva versión; no se edita el snapshot.

Desglose mínimo por partida: venta neta; materiales; mano de obra; maquinaria; subcontratación; transporte; alquileres; tasas/licencias; residuos; otros directos; indirectos asignados; coste total; beneficio y margen. Los componentes pueden estar “sin informar”; el total no se declara completo hasta cubrir la política requerida.

## 6. Fuente de verdad del coste real

Se recomienda un enfoque **híbrido**:

- Un registro canónico de hechos de coste responde cuánto, cuándo, en qué obra/categoría/partida y de qué origen procede. Es la única entrada del motor de rentabilidad.
- Entidades especializadas guardan el detalle que un asiento genérico perdería —por ejemplo trabajador, horas y tarifa— y generan/revierten exactamente un hecho de coste dentro de la misma transacción.
- Documentos administrativos futuros (albarán, factura recibida) y pagos no generan automáticamente otro coste. Se concilian con el mismo hecho o sustituyen su evidencia mediante una transición trazada.

Cada hecho tiene clave de origen única `(tenantId, tipoOrigen, origenId, claveAsignacion)`. Así un albarán, su factura y su pago no pueden convertirse en tres costes. Las correcciones se realizan con reversión o ajuste enlazado, nunca reescribiendo silenciosamente historia cerrada.

### Categorías directas iniciales

`materiales`, `mano_obra`, `maquinaria`, `subcontrata`, `transporte`, `alquileres`, `tasas_licencias`, `residuos` y `otros_directos`. Son códigos del sistema con etiquetas configurables por tenant; el tenant puede añadir subcategorías sin convertir el producto en un catálogo contable.

### Compra actual

Una Compra puede reutilizar su `baseImponible` como hecho de coste real únicamente cuando represente un gasto **realmente incurrido** para la obra. Estar pendiente o pagada no demuestra ni niega el devengo: pago es tesorería, no coste. Una previsión no suma; un compromiso alimenta coste comprometido; una anulación no suma; y una devolución/abono genera un ajuste negativo. `importeTotal` sigue siendo dato fiscal/caja potencial. Sus límites deben mostrarse: una sola obra, sin líneas, sin documento verificable, sin reparto, estado de pago manual y sin categoría.

Los estados actuales de Compra no distinguen de forma segura gasto incurrido, previsión y compromiso. Por ello v24 **no materializará automáticamente todas las Compras**. Fase 3-C introducirá un mapeo/confirmación explícito y auditable antes de crear exactamente un hecho canónico con origen único `compra:<id>`; desde entonces el motor no sumará Compra directamente. Al enlazarla a una futura factura recibida se conservará el hecho y cambiará o añadirá evidencia, sin crear otro coste.

## 7. Mano de obra y personal

Registro mínimo: persona/colaborador, fecha, expediente, horas, tipo de trabajo opcional, partida opcional, tarifa de coste aplicada, importe resultante y origen de tarifa. La tarifa y el coste calculado quedan congelados.

- Empleado: coste/hora empresarial histórico, no salario neto; puede incorporar cargas según política documentada.
- Autónomo titular: tiene coste económico interno aunque no haya nómina ni salida de caja. Se registra como mano de obra propia mediante una tarifa interna de coste/hora configurable por tenant, distinta del precio/hora de venta.
- Colaborador: según relación, mano de obra externa o subcontrata; no se cuenta además su factura.
- Subcontratado por resultado: normalmente coste de subcontrata, no horas internas, salvo que las horas sean solo analíticas y estén marcadas no valorizables.

El modelo de persona y tarifa histórica será mínimo, no RRHH: identidad operativa, tipo, vigencia y coste/hora. Nóminas, contratos, vacaciones y documentación laboral quedan fuera.

## 8. Maquinaria, transporte y subcontratas

- **Maquinaria propia:** uso × tarifa interna congelada. La tarifa puede integrar amortización y mantenimiento; combustible imputado aparte solo si la tarifa declara que lo excluye.
- **Maquinaria alquilada:** coste neto del alquiler como hecho real; horas pueden ser dato operativo sin segundo coste.
- **Servicio externo con operario:** subcontrata o servicio externo, no maquinaria propia más mano de obra.
- **Transporte:** porte/camión/grúa/combustible/desplazamiento se imputa directamente cuando existe relación causal con la obra. Gastos generales no identificables son indirectos.
- **Subcontrata:** compromiso previsto/aprobado y hechos reales asociados a proveedor, obra, concepto y futura evidencia documental; el modelo inicial no necesita certificación completa del subcontratista.

## 9. Costes indirectos

Política inicial aprobada: **costes indirectos previstos = porcentaje configurable × costes directos previstos**. El porcentaje pertenece al tenant, no se hardcodea y queda congelado en el plan aceptado, por lo que cambiar después la configuración empresarial no altera obras históricas. Es comprensible, estable y permite comparar obras.

Gestoría, seguros generales, teléfono, software, administración, oficina y estructura empresarial son ejemplos de indirectos cuando no pueden imputarse causalmente a una obra. El reparto periódico de indirectos reales queda expresamente fuera de la primera implementación. No se mezclará en el futuro con el porcentaje presupuestario congelado.

## 10. Compromisos y estimaciones

Un compromiso es una obligación operativa aprobada todavía no devengada totalmente: pedido, alquiler reservado o subcontrata aceptada. Entra en la primera implementación del motor porque anticipa pérdidas. Al reconocer coste real se consume el compromiso; solo el saldo pendiente forma parte del coste final estimado.

El coste pendiente estimado es una previsión explícita, fechada, por obra y opcionalmente categoría/partida. No se deduce ciegamente como `previsto − real`: el sobrecoste puede hacerla negativa o esconder trabajo pendiente. Guarda autor, motivo, nivel de confianza (`bajo`, `medio`, `alto`) y cobertura. Sin revisión vigente, el coste final estimado y margen estimado aparecen incompletos.

## 11. Obra en curso y cierres

Mientras la obra está en curso se mostrarán por separado:

- **Resultado realizado:** solo cuando exista producción reconocida comparable; no se usará `facturado − coste acumulado`.
- **Resultado final estimado:** venta final estimada menos coste final estimado, con indicador de cobertura/confianza.
- **Caja:** cobrado y, en el futuro, pagado; nunca se etiqueta beneficio.

Cierres independientes:

1. **Operativo:** ejecución terminada; no implica que todos los documentos hayan llegado.
2. **Económico:** costes reales completos, compromisos resueltos, estimación pendiente cero/justificada y venta final definida. Congela un snapshot de resultado, pero admite reapertura auditada.
3. **Financiero:** cobros y futuros pagos/saldos resueltos. Puede ser posterior al económico.

“Cerrar económicamente la obra” será una acción explícita. Antes evaluará costes pendientes, compromisos abiertos, costes sin asignar, estimaciones pendientes, posible facturación incompleta, documentación económica pendiente y demás inconsistencias disponibles. Presentará advertencias comprensibles y distinguirá bloqueos de avisos: el usuario podrá cerrar conscientemente con avisos no bloqueantes, que quedarán incluidos en el snapshot.

Una obra económicamente cerrada guarda venta final, coste final por categorías/partidas, beneficio, margen, cobertura, fecha, actor disponible y todas las advertencias aceptadas. El futuro modelo de usuarios resolverá quién está autorizado; no se implementan roles ahora. Reabrir será una acción explícita, registrada y con motivo obligatorio: no elimina el cierre histórico. Una factura de proveedor tardía obliga a reabrir o registrar un ajuste posterior trazado.

## 12. Facturación, cobro, certificaciones y producción

- **Facturado neto:** base de FAC efectivas más efectos base de RECT emitidas efectivas. Borradores y anuladas no suman. Se usa la familia documental y reglas existentes, no una nueva suma en Presentation.
- **Venta final:** plan vigente y modificados aprobados; una RECT no reescribe el plan. Si revela un cambio comercial, debe existir modificado del plan para que previsto y facturado sean comparables.
- **Cobrado neto/pendiente:** repositorio económico actual, incluyendo reversiones y compensaciones. Crédito, devolución y compensación pertenecen a liquidación/tesorería, no al coste ni al beneficio.
- **Certificación:** hoy no acredita por sí sola producción ejecutada fiable. Puede enlazar facturación parcial, pero hasta disponer de detalle y regla de aceptación no alimentará “resultado realizado” ni avance físico.

## 13. Desviaciones y partidas

Primera granularidad: obra total y categoría. Segunda: partida presupuestaria opcional. Cada coste puede quedar “Sin asignar a partida”; no se bloquea la administración y se genera una alerta de calidad de imputación.

Comparación por categoría/partida:

- previsto congelado;
- real acumulado;
- comprometido pendiente;
- pendiente estimado;
- final estimado;
- desviación € y %, con cobertura.

Una partida sin coste previsto no muestra desviación porcentual; un coste sin partida solo afecta al total y a su categoría hasta ser reclasificado de forma auditada.

## 14. Multiobra, almacén y abonos de proveedor

Un documento futuro puede tener una cabecera única y asignaciones netas a varias obras o a destino general/almacén. La suma de asignaciones no puede superar la base neta conciliable; cada asignación produce o referencia un hecho económico único. Fase 3 inicial necesita que el hecho soporte origen y clave de asignación, pero la UI documental multiobra puede esperar al circuito de proveedores.

Comprar para almacén no es coste de obra. El coste aparece al consumir/imputar material a la obra, con coste unitario histórico. Inventario, lotes y valoración de existencias quedan fuera de la primera Fase 3, pero no se imputará una compra a obra y luego su consumo otra vez.

Un abono/devolución de proveedor reduce coste mediante un hecho negativo enlazado al original y conserva fecha, importe y evidencia. No se modifica el coste histórico original ni se usan importes negativos sin relación causal.

## 15. Modelo mínimo de persistencia propuesto

El siguiente incremento requerirá previsiblemente **`schemaVersion` 24**. Todas las tablas empresariales tendrán `tenantId NOT NULL`, FK a Tenant, relaciones compuestas, índices tenant-first, timestamps y contexto obligatorio.

### `categorias_coste`

- Propósito: categorías y subcategorías configurables sin catálogo contable.
- PK `id`; campos `tenantId`, `codigo`, `nombre`, `categoriaSistema`, `activa`, `orden`, timestamps.
- Únicos `(tenantId,id)` y `(tenantId,codigo)`; índice `(tenantId,activa,orden)`.
- Los códigos base no se borran si tienen uso; desactivación lógica.

### `planes_economicos_obra`

- Propósito: cabecera inmutable de plan base, sustitución o modificado.
- PK `id`; `tenantId`, `expedienteId`, `presupuestoId`, `tipo` (`base`,`sustitucion`,`modificado`), `version`, `planAnteriorId`, `estado` (`vigente`,`sustituido`,`anulado`), fecha/usuario de aceptación, venta neta, directos, indirectos, total, beneficio, margen, política/base/tasa de indirectos, completitud y timestamps.
- FKs compuestas a Expediente, Presupuesto y autorreferencia; únicos por presupuesto y versión; índices `(tenantId,expedienteId,estado)`.
- Snapshots monetarios obligatorios; no se actualiza un plan aceptado.

### `plan_partidas_economicas`

- Propósito: snapshot por partida y desglose previsto.
- PK `id`; `tenantId`, `planId`, `lineaPresupuestoOrigenId`, `partidaAnteriorId?`, orden/código/concepto/unidad/cantidad/precio venta, venta neta, costes por categorías iniciales, indirectos, total, beneficio, margen, completitud y timestamps.
- FK compuesta al plan, referencia opcional a línea original y autorreferencia a la partida de la versión previa; único `(tenantId,planId,id)` e índice por plan/orden. Es inmutable y solo cambia de vigencia con su plan.

### `hechos_coste_obra`

- Propósito: única fuente canónica del coste real.
- PK `id`; `tenantId`, `expedienteId`, `categoriaId`, `planPartidaId?`, `tipoOrigen`, `origenId`, `claveAsignacion`, `hechoOrigenId?`, `fechaDevengo`, `concepto`, `baseNetaCentimos`, `ivaCentimos`, `ivaRecuperableCentimos`, `costeEconomicoCentimos`, `estado` (`activo`,`revertido`,`sustituido`), `calidadImputacion`, timestamps.
- Snapshots: concepto, categoría y regla fiscal aplicados. Importe puede ser positivo o negativo solo para ajustes tipados; coste económico = base + IVA no recuperable.
- Único `(tenantId,tipoOrigen,origenId,claveAsignacion)`; FKs compuestas; índices `(tenantId,expedienteId,fechaDevengo)`, por categoría/partida y origen. Sin borrado físico; reversión enlazada.

### `partes_trabajo_obra`

- Propósito: detalle de horas que origina un único hecho de coste.
- PK `id`; `tenantId`, `expedienteId`, `personaId`, `planPartidaId?`, fecha, horas en unidad decimal exacta, tipoTrabajo, costeHoraCentimos congelado, costeCentimos, tipoPersona, tarifaOrigenId?, `hechoCosteId`, notas, estado y timestamps.
- Único `(tenantId,hechoCosteId)`; índices por obra/fecha y persona/fecha. Corrección mediante reversión/sustitución.

### `personas_coste` y `tarifas_persona`

- Propósito: identidad operativa mínima e histórico de coste/hora.
- Persona: PK, tenant, nombre, tipo (`titular`,`empleado`,`colaborador`), activa, timestamps.
- Tarifa: PK, tenant, persona, vigencia desde/hasta, coste/hora en céntimos, composición/notas, timestamps; rangos no solapados por persona mediante validación transaccional.
- No almacenan nómina ni documentación RRHH.

### `compromisos_coste_obra`

- Propósito: coste aprobado pendiente de devengo.
- PK; tenant, expediente, categoría, `planPartidaId?`, proveedor?, concepto, importe comprometido neto, consumido neto, estado (`borrador`,`aprobado`,`parcial`,`cumplido`,`cancelado`), origen futuro, fechas y timestamps.
- Constraints de importes no negativos y consumido ≤ comprometido; índices por obra/estado.

### `estimaciones_pendientes_obra`

- Propósito: revisiones explícitas de coste todavía necesario.
- PK; tenant, expediente, categoría/`planPartidaId` opcional, fecha de corte, importe, confianza, motivo, estado (`vigente`,`sustituida`), estimaciónAnteriorId?, timestamps.
- Solo una vigente por ámbito; historial inmutable e índice por obra/estado/fecha.

### `cierres_economicos_obra`

- Propósito: snapshot auditado de cierre/reapertura.
- PK; tenant, expediente, tipo de evento (`cierre`,`reapertura`,`ajustePosterior`), fecha, venta final, coste final, beneficio, margen, cobertura, motivo y actor.
- Índice por obra/fecha; no se borra.

Política común: importes con constraints de signo y consistencia; relaciones siempre dentro del tenant; registros históricos sin borrado físico; anulaciones, sustituciones y reversiones explícitas; `createdAt`/`updatedAt` y, cuando corresponda, autor y fecha efectiva. No se propone una tabla de resultados: resumen, margen y desviaciones se derivan en repositorios/servicios de dominio, salvo snapshots de plan y cierre que deben ser históricos.

## 16. Casos de uso y arquitectura

Casos de uso mínimos:

1. Crear/congelar plan económico desde presupuesto aceptado.
2. Registrar, reclasificar mediante ajuste y revertir un coste.
3. Registrar/corregir/revertir horas con tarifa congelada.
4. Aprobar, consumir y cancelar compromiso.
5. Revisar coste pendiente estimado con nivel de confianza.
6. Consultar resumen económico y desviaciones por obra/categoría/partida.
7. Evaluar requisitos, cerrar y reabrir económicamente la obra.

Flujo obligatorio: `Presentation → Providers → casos de uso/repositorios → DAOs → Drift → SQLite`. Presentation solo renderiza DTOs de resumen y nunca recalcula beneficio. UI, voz e integraciones futuras invocarán los mismos casos de uso con tenant y autorización explícitos.

## 17. Migración conceptual v23 → v24 y legacy

1. Crear tablas e índices dentro de una migración transaccional, con backup previo y verificación del DDL real.
2. Sembrar categorías del sistema por cada tenant, sin datos específicos de Construcciones Tovar.
3. No inventar planes para presupuestos aceptados históricos sin coste: pueden crear snapshot de venta marcado `costeIncompleto` o permanecer “Plan económico no disponible” según validación de datos.
4. Conservar todas las Compras sin convertirlas automáticamente: solo una clasificación/confirmación explícita en Fase 3-C podrá reconocer un gasto incurrido una vez mediante origen único y base neta.
5. No fabricar horas, categorías detalladas, compromisos, indirectos ni costes históricos.
6. Mantener FAC/RECT, cobros, crédito, certificaciones y documentos sin reinterpretación.
7. Verificar conteos, importes, aislamiento, FKs, rollback, backups y rutas soportadas 16–24.

Para obras legacy se informará por métrica: `disponible`, `incompleta` o `no disponible`, con causas (sin plan de coste, compras sin clasificar, horas ausentes, previsión pendiente no revisada). Cero significa cero conocido, nunca ausencia de datos.

## 18. Centro económico futuro del Expediente

Orden funcional, sin UI implementada:

- **Venta:** vendimos/prevemos, facturado neto, cobrado y pendiente de cobro.
- **Costes:** previsto, real, comprometido pendiente y pendiente estimado, con cobertura.
- **Resultado:** beneficio previsto, beneficio final estimado, beneficio cerrado y margen correspondiente.
- **Desviaciones:** total, categorías y partidas causantes; costes sin asignar.
- **Estado:** operativo/económico/financiero y fecha de última revisión.

Cada cifra permitirá abrir su trazabilidad. Estados incompletos y nivel de confianza serán más visibles que una precisión falsa.

## 19. Alertas y dashboard futuros

Alertas simples: real > previsto; final estimado erosiona margen; partida/categoría sobrecoste; exceso de horas/material; coste sin partida; compromiso vencido; obra operativamente terminada con costes pendientes; facturación por debajo del plan vigente. Tendrán umbrales configurables y explicación, no un motor opaco.

Dashboard tenant-scoped futuro: obras rentables/en riesgo/con pérdida, beneficio previsto y estimado, coste real, desviación y cobertura. No agregará porcentajes de margen promediándolos: calculará margen sobre sumas compatibles.

## 20. Aprendizaje histórico y voz

Se conservarán snapshots de previsto y real por categoría/partida, horas previstas/reales, tarifas aplicadas, consumo de materiales/maquinaria, modificaciones, desviaciones, motivos y resultado final. Esto permite comparar obras terminadas y mejorar futuras estimaciones sin implementar IA/ML ahora.

Casos futuros como “apunta 6 horas mías” o “¿qué obra pierde dinero?” resolverán tenant, entidad y autorización fuera del texto, pedirán confirmación cuando corresponda y ejecutarán casos de uso idempotentes; nunca escribirán desde widgets ni calcularán métricas por lenguaje natural.

## 21. Decisiones de negocio aprobadas

Reglas oficiales aprobadas para la implementación:

- Rentabilidad sin IVA recuperable; IVA no recuperable sí es coste.
- Tiempo del titular valorizado mediante tarifa interna de coste/hora tenant-configurable y congelada en cada parte, sin fingir salida de tesorería ni confundirla con precio de venta.
- Indirectos previstos como porcentaje tenant-configurable sobre coste directo previsto, congelado por plan y sin porcentaje hardcodeado.
- Plan aceptado inmutable; modificados incrementales y sustituciones explícitas.
- Coste real por gasto incurrido/devengo/consumo, no por pago; Compra requiere clasificación explícita si sus estados no lo demuestran.
- Coste comprometido entra en el primer motor de previsión.
- Costes sin partida permitidos con alerta.
- Cierre económico explícito y auditable, permitido con advertencias no bloqueantes registradas y reapertura motivada sin borrar historia.

No quedan decisiones de negocio bloqueantes para comenzar Fase 3-B. Los valores concretos de tarifa interna y porcentaje de indirectos son configuración de cada tenant, no decisiones del núcleo. La clasificación de Compras se resolverá mediante el flujo explícito diseñado para Fase 3-C, y la autorización del cierre cuando exista el futuro modelo de usuarios.

## 22. Secuencia recomendada de implementación

1. **Fase 3-B — plan económico y categorías:** schema v24, snapshots inmutables y migración legacy segura.
2. **Fase 3-C — hechos de coste y Compras:** fuente canónica, categorías, partida opcional, ajustes y deduplicación de orígenes.
3. **Fase 3-D — mano de obra:** personas/tarifas históricas, partes y coste del titular.
4. **Fase 3-E — compromisos y estimaciones:** coste final estimado, confianza y desviaciones.
5. **Fase 3-F — centro económico del Expediente:** consultas trazables y UI profesional.
6. **Fase 3-G — cierres, alertas e histórico:** cierre operativo/económico/financiero, dashboard y base de aprendizaje.

Maquinaria especializada, documentos de proveedor, reparto multiobra y almacén se incorporarán en incrementos propios cuando el circuito administrativo lo requiera; el contrato de hechos de coste ya los admite.

### Estado de 3-B

Implementada técnicamente sobre schema v24. El coste previsto editable se conserva en un desglose interno asociado a cada línea borrador; no se añade al documento comercial. Al aceptar, una única transacción congela el plan, sus partidas, las categorías descriptivas y el porcentaje de indirectos, cambia el estado y registra Timeline. La cobertura distingue `sinCostes`, `parcial` y `completo`, sin convertir ausencias en cero. La migración inicializa categorías y configuración por tenant, pero no crea planes retrospectivos para presupuestos legacy. Los tipos `base`, `sustitucion` y `modificado` y la versión física reservan la evolución sin implementar todavía sustituciones ni doble contabilización.

### Estado de 3-C

Implementada técnicamente sobre schema v25. `hechos_coste` es la fuente canónica append-only: cada movimiento conserva tenant, obra, categoría opcional, devengo, neto, IVA no recuperable explícito, coste, origen, idempotencia y vínculos opcionales al plan/partida. Las Compras nacen y migran como provisionales; sus estados manuales no generan coste. Confirmación, clasificación y Timeline son atómicos. Reversión y eliminación añaden contramovimientos, los ajustes se registran como hechos nuevos y la edición económica histórica queda bloqueada. Los agregados suman únicamente el ledger por obra/categoría/sin asignar. Este incremento no incorporó mano de obra, que se añadió posteriormente en 3-D.

### Estado de 3-D

Implementada técnicamente sobre schema v26. `personas_laborales` delimita personas internas imputables sin convertirse en un modelo de RRHH; `tarifas_persona` conserva intervalos históricos tenant-scoped y `partes_trabajo` registra horas con precisión de diezmilésimas. La fecha del trabajo selecciona la tarifa y el parte congela tarifa y coste. El cálculo usa enteros y redondeo determinista a céntimos.

Un parte sin tarifa conserva horas y cobertura pendiente, pero no crea `hechos_coste`. La valoración posterior crea el alta con origen `parteTrabajo`; la reversión crea el contramovimiento y el parte original permanece auditable. Una corrección económica es reversión más parte nuevo. Alta valorada, valoración posterior y reversión coordinan parte, ledger y Timeline transaccionalmente. Los agregados ofrecen horas/coste por obra y persona, coste por partida y sin partida, y cobertura completa, parcial o sin valorar. No se modifican venta, PDFs comerciales, nóminas, pagos ni tesorería. Fase 3-E no se ha iniciado.

## 23. Matriz de pruebas futura

- Aislamiento de tenant en cada tabla, consulta, agregado, caché, FK e índice.
- Creación, sustitución, modificado y no doble conteo de varios presupuestos.
- Congelación de venta, costes, tarifas e indirectos ante cambios futuros.
- Redondeo de cantidades, horas, bases, IVA no recuperable, negativos y céntimos límite.
- Costes por todas las categorías, sin partida, por partida, ajustes y reversiones.
- Compra legacy incurrida/provisional/comprometida/anulada/eliminada, confirmación explícita, conciliación futura y origen único.
- Horas de titular, empleado y colaborador; vigencias de tarifa y concurrencia.
- Compromiso parcial/cumplido/cancelado y ausencia de doble conteo con coste real.
- Estimación incompleta, confianza y cálculo de coste final estimado.
- FAC/RECT/anulación, cobros/reversiones, crédito/devolución/compensación sin afectar coste.
- Obra en curso sin producción fiable, cierre/reapertura y documento tardío.
- Desviación total, categoría, partida, previsto cero y datos incompletos.
- Multiobra y almacén cuando existan: sumas de asignación y consumo único.
- Migración v23→v24 poblada/vacía, rutas 16–24, rollback, backup/restore y conservación exacta.
- Pruebas de repositorio/servicio demuestran trazabilidad; widgets solo presentan DTOs.

## 24. Criterios de aceptación de rentabilidad fiable

La rentabilidad de una obra será fiable cuando:

1. exista un plan vigente inmutable con venta y cobertura de coste declarada;
2. cada coste real tenga origen, fecha, categoría, obra, importe y política de IVA trazables;
3. ninguna evidencia administrativa o pago duplique un hecho económico;
4. horas y tarifas históricas estén congeladas, incluida mano de obra propia;
5. modificados y sustituciones eviten doble venta;
6. compromisos y estimaciones declaren fecha, saldo, cobertura y confianza;
7. FAC/RECT y cobros procedan exclusivamente de sus reglas actuales;
8. resultados en curso no se presenten como beneficio definitivo;
9. cierres sean auditables y reabribles;
10. toda cifra navegue hasta sus datos origen y pueda reconstruirse;
11. datos incompletos se identifiquen como tales;
12. aislamiento multi-tenant, precisión, migración, concurrencia y backup estén probados.
# Implementación 3-E: compromisos y coste final estimado

El plan aceptado continúa siendo la referencia original e inmutable. El coste real se obtiene únicamente sumando el ledger `hechos_coste`. Un compromiso representa una obligación firme pendiente y solo se consume mediante una aplicación explícita a un hecho real; las reversiones del ledger neutralizan esa aplicación a efectos de saldo. El coste restante estimado significa siempre coste adicional no incluido en real ni compromisos.

La proyección aplica `coste final = real + pendiente comprometido + restante adicional`. Solo publica coste final, beneficio y margen cuando la cobertura es completa. Esta exige una estimación vigente explícita para cada categoría relevante del plan; cualquier subconjunto es cobertura parcial y la ausencia de información es no disponible. Las obras sin plan pueden registrar operación, pero no tienen venta, beneficio ni margen fiables.

Las estimaciones conservan todas sus versiones por serie, fecha y justificación. Los compromisos admiten ajuste y cancelación con Timeline transaccional; una reducción nunca puede quedar por debajo del consumo efectivo. La migración v26→v27 crea estructuras vacías y no fabrica historia legacy. El panel de Expediente sirve para validar el dominio; conciliación automática, cierre, alertas, permisos/autores y el centro económico completo permanecen fuera de 3-E.
# Cierre económico 3-G

El cierre económico no crea una proyección alternativa: congela exactamente la proyección vigente de 3-E junto con cobertura, desviaciones y resultado del precheck. Los snapshots son append-only. El estado abierto/cerrado es independiente del ciclo operativo y las obras legacy permanecen abiertas. Reabrir requiere motivo y nunca elimina cierres anteriores. Mientras una economía está cerrada se bloquean en repositorio las mutaciones de hechos reales, compromisos, estimaciones y mano de obra; consulta, facturación, cobros y documentos permanecen disponibles.

# PROD-4 — Correcciones de proveedores

## Estado
Implementación técnicamente preparada y verificada. Inicio en main y origin/main `02f55f2507456f067ea4292a36d5fd8571945291`, schema 34; única modificación previa `analysis_options.yaml`, preservada. PROD-3 publicado y cerrado. Aceptación manual de PROD-4 superada en Desarrollo según confirmación del usuario; cierre técnico completado; publicación pendiente de autorización. No push, PROD-5, PROD-6 ni Fase 5.

## Modelo y conservación
Schema 35 añade tres tablas tenant-scoped, sin reescribir filas anteriores:
- `control_facturas_proveedor`: factura, estado documental (borrador/registrada/anulada), pago verificado, tipo (factura/abono), documento original relacionado y destino (obra/general/sinAsignar). PK tenant+factura y FK compuestas a factura/original.
- `eventos_proveedor`: UUID, factura, acción, motivo, actor, detalle JSON y fecha. Conserva valores anteriores en las correcciones y referencias de sustitución.
- `reversiones_pagos_proveedor`: PK tenant+pago, motivo, actor y fecha; garantiza una sola reversión por pago.

Triggers impiden borrar facturas, controles, pagos y auditoría; pagos y eventos son inmutables. Los datos esenciales de una factura consolidada no pueden actualizarse directamente. Un control registrado no vuelve a borrador ni un documento anulado vuelve a estar activo.

Los históricos sin control nuevo se consideran consolidados y conservan su estado de pago anterior; no se crea una verificación histórica ficticia durante la migración. Las nuevas facturas y compras pueden expresar pago no verificado. El actor disponible es «operador local»; no se inventa una identidad autenticada.

## Registro y corrección
Una factura recibida nueva es borrador, sin coste confirmado. Su edición permite corregir proveedor, número, fecha, importes y reparto antes de consolidar. Consolidar reconoce una sola vez las asignaciones de obra y deja auditoría.

Una factura registrada se corrige con:
- **Sustitución por error de registro:** motivo obligatorio, anulación del original y creación de borrador relacionado, todo atómico. Conserva el original y permite mantener el número real del proveedor en la sustituta. Hay que consolidar después la sustituta.
- **Abono recibido:** nuevo documento del proveedor, conservado y relacionado cuando corresponde. Nunca se emite una rectificativa en nombre del proveedor.
- **Anulación por error:** conserva el documento, registra motivo/fecha/actor y revierte sus costes. No permite una segunda anulación. Con pagos efectivos exige resolver antes los pagos erróneos; con abonos relacionados exige revisar primero estos.

La sustitución corrige la transcripción del documento recibido; no transforma ni reemplaza el documento empresarial original. El vínculo `documentoId` se conserva; el almacenamiento externo sigue fuera de PROD-4.

## Duplicados
Se comprueba tenant + proveedor + ejercicio de la fecha + número normalizado (mayúsculas, sin separadores). Los importes y las fechas coincidentes por sí solos no bloquean documentos.

Para registros nuevos, la clave técnica incluye ejercicio y número; las sustituciones incluyen su relación de corrección. Se conserva la restricción UNIQUE existente y no se cambian claves ni números históricos. Se revisa también el histórico por número visible para evitar eludir duplicados con claves nuevas. Un original anulado solo admite reutilizar su referencia mediante sustitución relacionada; no mediante una alta independiente. La normalización puede requerir revisión si el proveedor distingue referencias únicamente por signos.

## Abonos y saldo
Se introducen base e IVA como magnitudes positivas; el tipo abono determina el efecto negativo y se muestra claramente en la ficha. La consolidación produce costes negativos de obra en `hechos_coste`. Los abonos registrados relacionados reducen el saldo del original, sin borrarlo ni modificar su importe. Su anulación revierte el efecto.

Saldo de factura verificada = total original − abonos registrados − pagos efectivos. Un saldo negativo representa importe a favor. No se implementa todavía un circuito bancario de devolución o compensación de ese crédito; tampoco se simula un pago negativo.

## Pagos
Se admiten pagos parciales y múltiples, con fecha, medio y referencia. Se prohíbe superar el saldo. Revertir un pago exige motivo, conserva el pago original y lo excluye del total efectivo; la PK impide dobles reversiones. Para corregir importe/fecha/medio se revierte el registro erróneo y se registra el correcto. No revierte transferencias bancarias reales.

Pago no verificado no se presenta como pendiente: el saldo aparece «No verificado» y se bloquean nuevos pagos hasta revisar justificantes y confirmar expresamente el estado. Los pagos registrados se muestran aunque la información pudiera estar incompleta. No se generan avisos de vencimiento a partir de estados desconocidos.

Las compras independientes permiten corregir su marca de pago con motivo e historial, sin cambiar el coste. Las compras vinculadas exigen gestionar pagos desde su factura recibida; sus marcas se sincronizan con esta. Los pagos parciales detallados pertenecen al circuito Facturas recibidas.

## Imputación y coste canónico
Se distinguen obra, gasto general y sin asignar. Una factura puede consolidarse sin obra; no se inventa un Expediente. General/sin asignar conservan el gasto documental pero no se incluyen en la rentabilidad de una obra hasta asignarse.

La primera consolidación ordinaria reutiliza Compra → `hechos_coste`; respeta la reconciliación con compras existentes. Reimputar revierte los hechos vigentes y registra los nuevos de forma atómica, con valores anteriores auditados, sin duplicar coste. Conserva las compras y hechos previos. El IVA recuperable no es coste; el no recuperable se valida contra el IVA recibido. Las obras cerradas bloquean cambios económicos y los fallos revierten toda la operación.

Se conserva el número de tramos de un reparto existente; pueden cambiarse sus obras e importes respetando la base global. La interfaz permite reasignar el documento y editar las bases de sus tramos en borrador. No hay un nuevo motor de contabilidad general o reparto automático de gastos de empresa entre obras.

Las compras confirmadas no desaparecen mediante eliminación lógica: deben revertirse con motivo. Una compra reconciliada no permite revertir el coste por fuera de su factura.

## Migración y backup
34→35 crea tablas y triggers, sin backfill de controles, modificaciones de pagos, costes, proveedores, documentos, facturas ni Timeline. Se amplía recuperación previa a schema 34. Drift regenerado.

Backup exige las nuevas tablas para schema 35, y admite anteriores mediante migración. Las pruebas reconstruyen schema 34 en una base temporal, comparan todas las filas anteriores y verifican restauración de pagos, reversiones y auditoría. Las bases actuales de Desarrollo y Producción no se abren para verificar.

## Futura importación y límites
No se implementa importador ni se lee Año 2026.xlsx. Se admiten ejercicios anteriores, pago desconocido, falta de obra, falta de vencimiento/documento y abonos. Los campos esenciales de una factura (proveedor, referencia, fecha e importes) deben revisarse antes de registrarla: una futura importación deberá conservar los registros incompletos y sus originales sin inventar esos datos ni consolidarlos automáticamente.

La auditoría es local; no protege frente a manipulación externa del SQLite ni coordina copias independientes. No se altera la facturación emitida. PROD-5 (originales externos), PROD-6 y Fase 5 no iniciados.

## Verificación
Verificación técnica superada: 25 pruebas nuevas (22 de repositorio, 2 de interfaz y 1 de migración/backup); 28 pruebas del circuito, 28 de base de datos/migraciones y 41 de compras/proveedores/economía superadas. Suite completa: 413 pruebas. Análisis sin incidencias; Windows debug compilado en copia aislada con 359 archivos relevantes idénticos. Formato propio y diff sin errores. Pruebas únicamente en memoria/temporales, sin limpiar los datos ficticios actuales.

## Aceptación manual propuesta — solo Desarrollo
1. Confirmar Desarrollo y utilizar un proveedor ficticio; conservar los datos existentes.
2. Abrir Compras → Facturas recibidas. Crear PRUEBA-P4-01: base 100 €, IVA 21 €, fecha de prueba. Debe quedar en borrador, sin obra y con pago no verificado.
3. Editar número/fecha/base antes de consolidar. Cancelar un diálogo y comprobar que no aplica cambios.
4. Asignar a una obra ficticia abierta y consolidar con confirmación. Verificar coste de base, estado registrado e historial.
5. Intentar repetir el número/proveedor/ejercicio: debe bloquearse. Un ejercicio distinto puede utilizarlo.
6. Comprobar que no se puede editar directamente lo consolidado. En otra factura sin pagos, usar Corregir con sustitución y motivo; conservar el original anulado y consolidar el nuevo borrador relacionado.
7. Verificar que «Pago no verificado» no muestra deuda cierta ni permite pagar. Revisar justificantes ficticios y verificar con motivo.
8. Registrar pagos ficticios de 21 € y 100 € para la factura original de 121 €. Comprobar parcial/completa y que el coste no aumenta.
9. Revertir el pago de 21 € con motivo. Debe permanecer visible como REVERTIDO y volver el saldo de 21 €. No repetir la reversión.
10. Registrar el pago correcto con su fecha/medio/referencia. Comprobar historial y saldo.
11. Registrar un abono ficticio relacionado por base 20 €, IVA 4,20 €, asignarlo a la misma obra y consolidarlo. Verificar coste neto 80 € y saldo a favor si estaba pagada.
12. En un documento sin pagos ni abonos activos, anular con motivo; comprobar documento conservado y coste neto cero. No debe poder anularse otra vez.
13. Crear otro documento sin obra. Pasarlo a gasto general y después asignarlo a una obra con motivo; comprobar que solo aparece el coste en la obra elegida.
14. Cambiar su imputación a otra obra abierta; la primera debe quedar compensada y la segunda recibir el coste una sola vez. Intentar una obra cerrada: debe bloquearse sin cambios parciales.
15. En una compra independiente confirmada, corregir la marca de pago con motivo y comprobar que no cambia el coste. Revertir el coste y comprobar que la compra no desaparece.
16. Revisar referencias, importes, pagos y Timeline. Si se valida restore, usar únicamente una copia de prueba aislada, nunca las bases actuales.
17. Registrar resultados y conservar los documentos ficticios. No utilizar Producción, no introducir datos reales ni iniciar otro bloque.

Aceptación manual superada según confirmación del usuario, exclusivamente en Desarrollo con datos ficticios. PROD4-001 se corrigió de 121,00 € a 133,10 € antes de consolidar; el pago de 50,00 € dejó 83,10 € y su reversión restauró 133,10 €. La sustitución conservó el original anulado y consolidó 145,20 €. ABONO-TEST-001 redujo el saldo a 121,00 €; al anularlo, el abono dejó de computar y el saldo volvió a 145,20 €, manteniendo todo el histórico.

El procedimiento ampliado anterior se conserva como referencia. No se atribuyen al usuario comprobaciones manuales adicionales a las comunicadas; la revisión técnica utiliza exclusivamente bases aisladas.

En la revisión se reprodujeron y corrigieron dos defectos: el saldo mostrado de una factura anulada ahora es cero, conservando el importe histórico; y el control creado para una factura histórica conserva la identificación de su obra existente. No cambia schema 35 ni se reescriben históricos.

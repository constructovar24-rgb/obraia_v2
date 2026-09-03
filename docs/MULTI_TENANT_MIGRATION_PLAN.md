# Diseño ejecutable de migración multi-tenant v22 → v23

Estado del documento: **P0-B implementado y pendiente de aceptación/publicación**. Diseñado e implementado el 3 de septiembre de 2026. El código usa `schemaVersion` 23, tabla `tenants`, `tenant_id` obligatorio, contexto local y accesos tenant-scoped; selector público, usuarios, autenticación, cloud y sincronización siguen fuera de alcance.

Este documento especifica el contrato que deberá implementar P0-B. La auditoría y prioridades generales permanecen en `MULTI_TENANT_ARCHITECTURE_AUDIT.md`.

## 1. Decisiones cerradas

1. Cada instalación v22 migrada recibe un **tenant inicial neutral**. No existe un tenant especial “Tovar” en el core.
2. Las 16 tablas empresariales actuales almacenarán `tenant_id` directamente y con `NOT NULL`.
3. Se conservan todos los IDs actuales. Las entidades nuevas usarán UUID v4 generado en la capa de aplicación mediante una fábrica inyectable.
4. Todas las relaciones empresariales se convierten en FKs compuestas `(tenant_id, foreign_id)` hacia `UNIQUE (tenant_id, id)` del padre.
5. Las acciones `ON DELETE` actuales son `NO ACTION`; v23 las conservará. No se añadirán cascadas incidentales.
6. La configuración pasa de singleton global a una fila por tenant. Los snapshots fiscales y PDFs históricos no se recalculan ni modifican.
7. La numeración inmediata conserva el algoritmo actual `MAX + 1` dentro de la transacción de emisión, pero queda aislada por tenant, serie y ejercicio. No se crea todavía tabla de secuencias.
8. Backup/restore continúa siendo de la base local completa. No se implementa exportación por tenant en P0.
9. La migración y los accesos tenant-scoped deben aterrizar juntos: un esquema con `tenant_id NOT NULL` no puede convivir de forma segura con escrituras que no conocen tenant.

## 2. Definición mínima de Tenant

`Tenant` representa el límite propietario y de aislamiento de los datos de una empresa. No es su ficha fiscal, un usuario ni una sesión.

Esquema lógico futuro:

```sql
CREATE TABLE tenants (
  id TEXT NOT NULL PRIMARY KEY,
  nombre TEXT NOT NULL CHECK (length(trim(nombre)) > 0),
  fecha_creacion INTEGER NOT NULL,
  fecha_modificacion INTEGER NOT NULL
);
```

- `id`: UUID v4 opaco. No deriva de nombre, CIF ni datos personales.
- `nombre`: etiqueta operativa para seleccionar la empresa. No es el nombre fiscal congelado.
- `fecha_creacion` y `fecha_modificacion`: instante UTC generado una sola vez durante migración o por reloj inyectable en altas futuras.
- No se añade `estado`, borrado lógico, plan comercial, dominio web, región, moneda ni configuración fiscal en P0. Desactivar tenants será una decisión posterior ligada a usuarios/suscripciones.

Separación conceptual:

| Concepto | Responsabilidad | P0 |
|---|---|---|
| Tenant | Identidad y frontera propietaria | Tabla mínima anterior |
| Configuración empresarial/fiscal | Emisor, contacto y branding de la empresa | `empresa_configuracion` tenant-scoped |
| Usuario | Persona/identidad autenticable | No se implementa |
| Membresía | Acceso de un usuario a un tenant y rol | No se implementa |
| Tenant activo | Contexto autorizado de una operación | Contexto local mínimo, sin autenticación ni selector multiempresa público |

## 3. Creación del tenant inicial

### Preflight v22

Antes de cambiar tablas:

1. Confirmar `PRAGMA user_version = 22`.
2. Ejecutar `PRAGMA integrity_check` y exigir exactamente `ok`.
3. Ejecutar `PRAGMA foreign_key_check` y exigir cero filas.
4. Confirmar la existencia de las 16 tablas esperadas.
5. Exigir cero o una fila en `empresa_configuracion`. Aunque el uso previsto es singleton, v22 no lo fuerza. Más de una fila es una anomalía ambigua: la migración aborta sin perder ninguna; no elige silenciosamente.
6. Capturar recuentos, IDs, sumas y huellas descritas en la sección 17.

### ID, nombre y fecha

- Generar exactamente un UUID v4 con una fábrica inyectable al inicio de la transacción y reutilizarlo como `initialTenantId` en todo el backfill.
- La aleatoriedad del valor no compromete la atomicidad: si la transacción falla, tenant y backfill se revierten; si termina, `user_version` evita repetirla. Las pruebas inyectarán un UUID fijo.
- No usar un UUID constante compartido por instalaciones, porque colisionaría al converger bases locales en cloud.
- Nombre: `trim(nombre_empresa)` de la única configuración si no está vacío; en otro caso, `Empresa inicial`.
- Usar un único `migrationNowUtc` para ambos timestamps; no inferirlos de documentos ni alterar fechas históricas.

### Conservación

Todos los registros v22 reciben el mismo `initialTenantId`. Se conservan sin transformación sus IDs, relaciones, nulos, estados, importes `REAL`, códigos, fechas, snapshots, hashes y bytes PDF. La fila de configuración conserva su `id` actual —normalmente `empresa_principal`—; ese literal deja de tener semántica global y las configuraciones futuras usarán UUID.

Una base vacía también recibe exactamente un tenant. No se crea una configuración vacía si no existía: la futura operación tenant-scoped `obtenerOCrearConfiguracion` mantiene esa responsabilidad.

## 4. Política general de tenantId, PK e índices

- `tenant_id TEXT NOT NULL REFERENCES tenants(id) ON DELETE NO ACTION` en las 16 tablas.
- Tablas con `id`: conservan `PRIMARY KEY (id)` para no romper identidades y añaden `UNIQUE (tenant_id, id)` como clave candidata de FKs compuestas.
- `factura_documentos_emitidos`, que no tiene ID propio, pasa a `PRIMARY KEY (tenant_id, factura_id)`; continúa habiendo un único PDF definitivo por factura.
- Toda FK empresarial pasa de `foreign_id → parent.id` a `(tenant_id, foreign_id) → parent(tenant_id, id)`.
- Las columnas nullable mantienen nulabilidad. En SQLite, una FK compuesta nullable no se comprueba si alguno de sus componentes es `NULL`; `tenant_id` nunca lo es, de modo que el carácter opcional depende solo de `foreign_id`.
- No basta la PK global `id`: se declara la clave candidata compuesta para que SQLite pueda validar igualdad de tenant.
- Los índices operativos empiezan por `tenant_id`. Se conservan solo los necesarios para relaciones y consultas observadas; P0-B verificará planes de las consultas críticas sin añadir índices especulativos.

## 5. Matriz exacta de las 16 tablas v22

“Índices actuales” enumera índices explícitos del proyecto; las PK y `UNIQUE` generan autoíndices SQLite.

| Tabla / función | PK v22 | FK y unique v22 | Índices actuales relevantes | Diseño v23, backfill y riesgo |
|---|---|---|---|---|
| `clientes` — clientes/promotores | `id` | Sin FK ni unique adicional | Ninguno explícito | `tenant_id`; `UNIQUE(tenant_id,id)`; índice `(tenant_id,eliminado,fecha_creacion)`; backfill directo. Riesgo bajo: raíz, pero todos sus hijos deben coincidir. |
| `proveedores` — proveedores propios de la empresa | `id` | Sin FK ni unique adicional | Ninguno | Igual que clientes; índice `(tenant_id,eliminado,fecha_creacion)`. No deduplicar nombres/NIF entre tenants. |
| `empresa_configuracion` — emisor/contacto/logo | `id` | Sin FK ni límite de filas | Ninguno | FK a tenant, `UNIQUE(tenant_id)` y `UNIQUE(tenant_id,id)`; conservar ID/campos. Abortar si v22 tiene más de una fila. |
| `expedientes` — obra/agregado central | `id` | `cliente_id → clientes.id`, nullable | Ninguno | FK `(tenant_id,cliente_id)`; índices `(tenant_id,eliminado,fecha_creacion)` y `(tenant_id,cliente_id)`; backfill directo. Riesgo: snapshot textual `cliente` se conserva. |
| `presupuestos` — propuesta/plan comercial | `id` | `expediente_id → expedientes.id` | Ninguno | FK compuesta; índices `(tenant_id,expediente_id,eliminado,fecha)` y `(tenant_id,eliminado,fecha)`; conservar códigos sin imponer nueva unicidad. |
| `lineas_presupuesto` — partidas | `id` | `presupuesto_id → presupuestos.id` | Ninguno | FK compuesta e índice `(tenant_id,presupuesto_id)`; importes/cantidades sin transformación. |
| `facturas` — FAC/RECT y snapshots | `id` | `cliente_id → clientes`; `presupuesto_origen_id → presupuestos`, nullable; autorreferencias `factura_rectificada_id` y `factura_raiz_id`, nullable | Unique parcial global `(serie,anio_numeracion,numero_legal)`; índices globales de rectificada y raíz | Cuatro FKs compuestas; unique parcial `(tenant_id,serie,anio_numeracion,numero_legal)`; índices `(tenant_id,cliente_id)`, `(tenant_id,presupuesto_origen_id)`, `(tenant_id,factura_rectificada_id)`, `(tenant_id,factura_raiz_id)`, `(tenant_id,fecha)`. Riesgo fiscal alto; no recalcular snapshots. |
| `factura_lineas` — líneas y genealogía RECT | `id` | `factura_id → facturas`; autorreferencias `linea_rectificada_id`, `linea_raiz_id`, nullable | Ninguno | Tres FKs compuestas; índices `(tenant_id,factura_id)`, `(tenant_id,linea_rectificada_id)`, `(tenant_id,linea_raiz_id)`; conservar signos/importes. |
| `factura_asignaciones_presupuesto` — puente de facturación parcial | `id` | FK a factura, línea factura, presupuesto, línea presupuesto y certificación nullable; `UNIQUE(factura_linea_id)` | Índices globales por `presupuesto_id` y `factura_id` | Cinco FKs compuestas; sustituir unique por `UNIQUE(tenant_id,factura_linea_id)`; índices tenant-first por cada FK. Riesgo alto por coherencia simultánea de cinco padres. |
| `factura_documentos_emitidos` — PDF definitivo | `factura_id` | `factura_id → facturas.id` | Autoíndice de PK | PK y FK `(tenant_id,factura_id)`; copiar BLOB y SHA-256 byte a byte. Riesgo de memoria/tiempo en rebuild; verificar hash antes/después. |
| `cobros` — cobros y reversiones | `id` | `factura_id → facturas`; `cobro_origen_id → cobros`, nullable | Ninguno | Dos FKs compuestas; índices `(tenant_id,factura_id,fecha)` y `(tenant_id,cobro_origen_id)`; conservar movimientos. |
| `movimientos_credito_cliente` — devolución/compensación/reversión | `id` | FK a cliente, factura raíz origen, factura raíz destino nullable y movimiento origen nullable; cuatro `CHECK` funcionales | Índices globales por origen, destino, movimiento origen y cliente | Cuatro FKs compuestas; conservar los cuatro `CHECK`; recrear índices tenant-first equivalentes. Riesgo económico alto: origen/destino/reversión deben ser del tenant. |
| `compras` — apunte de gasto de una obra | `id` | `expediente_id → expedientes`; `proveedor_id` es texto nullable sin FK | Ninguno | FK compuesta a expediente y nueva FK compuesta nullable a proveedor; índices `(tenant_id,expediente_id,eliminado,fecha)` y `(tenant_id,proveedor_id)`. Preflight: todo proveedor_id no nulo debe existir; si hay huérfano legacy, abortar y reportar, no borrar ni convertir a null. |
| `certificaciones` — certificación de obra | `id` | `expediente_id → expedientes`; `presupuesto_id → presupuestos`, nullable | Ninguno | Dos FKs compuestas; índices `(tenant_id,expediente_id,eliminado,fecha)` y `(tenant_id,presupuesto_id)`. v23 garantiza tenant común, pero no inventa una constraint nueva entre las obras de ambos campos. |
| `documentos` — metadata/ruta de documento | `id` | `expediente_id → expedientes` | Ninguno | FK compuesta e índice `(tenant_id,expediente_id,eliminado,fecha)`; P0 solo añade aislamiento. `ruta_archivo` permanece intacta y sigue siendo deuda; no se ingiere archivo ni añade hash todavía. |
| `timeline_events` — trazabilidad de expediente | `id` | `expediente_id → expedientes`; `referencia_id` sin FK/tipo | Ninguno | FK compuesta; índices `(tenant_id,expediente_id,fecha)` y `(tenant_id,fecha)`; conservar `referencia_id` tal cual. Tipado/actor queda fuera de v23. |

### Catálogo de índices v23

Los nombres son parte del diseño para que migración, validadores y tests comprueben el mismo DDL:

- Clave candidata en cada tabla con ID: `<tabla>_tenant_id_id_unica` sobre `(tenant_id, id)`. En `empresa_configuracion` se añade `empresa_configuracion_tenant_unica` sobre `(tenant_id)`. `factura_documentos_emitidos` usa su PK compuesta.
- `clientes_tenant_activos_fecha_idx`, `proveedores_tenant_activos_fecha_idx`: `(tenant_id, eliminado, fecha_creacion)`.
- `expedientes_tenant_activos_fecha_idx`: `(tenant_id, eliminado, fecha_creacion)`; `expedientes_tenant_cliente_idx`: `(tenant_id, cliente_id)`.
- `presupuestos_tenant_expediente_idx`: `(tenant_id, expediente_id, eliminado, fecha)`; `presupuestos_tenant_fecha_idx`: `(tenant_id, eliminado, fecha)`.
- `lineas_presupuesto_tenant_presupuesto_idx`: `(tenant_id, presupuesto_id)`.
- `facturas_numeracion_legal_unica`: unique parcial fiscal; `facturas_tenant_cliente_idx`, `facturas_tenant_presupuesto_idx`, `facturas_tenant_rectificada_idx`, `facturas_tenant_raiz_idx` y `facturas_tenant_fecha_idx` sobre las combinaciones de la matriz.
- `factura_lineas_tenant_factura_idx`, `factura_lineas_tenant_rectificada_idx`, `factura_lineas_tenant_raiz_idx`.
- `factura_asignaciones_tenant_linea_unica`: unique `(tenant_id, factura_linea_id)`; índices `factura_asignaciones_tenant_factura_idx`, `_presupuesto_idx`, `_linea_presupuesto_idx` y `_certificacion_idx`.
- `cobros_tenant_factura_fecha_idx`: `(tenant_id, factura_id, fecha)`; `cobros_tenant_origen_idx`: `(tenant_id, cobro_origen_id)`.
- `movimientos_credito_tenant_origen_idx`, `_destino_idx`, `_movimiento_origen_idx` y `_cliente_idx`, siempre `(tenant_id, foreign_id)`.
- `compras_tenant_expediente_idx`: `(tenant_id, expediente_id, eliminado, fecha)`; `compras_tenant_proveedor_idx`: `(tenant_id, proveedor_id)`.
- `certificaciones_tenant_expediente_idx`: `(tenant_id, expediente_id, eliminado, fecha)`; `certificaciones_tenant_presupuesto_idx`: `(tenant_id, presupuesto_id)`.
- `documentos_tenant_expediente_idx`: `(tenant_id, expediente_id, eliminado, fecha)`.
- `timeline_tenant_expediente_fecha_idx`: `(tenant_id, expediente_id, fecha)`; `timeline_tenant_fecha_idx`: `(tenant_id, fecha)`.

P0-B podrá retirar un índice redundante solo si `EXPLAIN QUERY PLAN` y la cobertura demuestran que otra clave con el mismo prefijo lo sustituye. La decisión se documentará; no se eliminarán índices por intuición.

## 6. Relaciones y constraints compuestos

Relaciones que deberán declararse exactamente:

```text
expedientes(tenant_id, cliente_id) -> clientes(tenant_id, id) [nullable]
presupuestos(tenant_id, expediente_id) -> expedientes(tenant_id, id)
lineas_presupuesto(tenant_id, presupuesto_id) -> presupuestos(tenant_id, id)

facturas(tenant_id, cliente_id) -> clientes(tenant_id, id)
facturas(tenant_id, presupuesto_origen_id) -> presupuestos(tenant_id, id) [nullable]
facturas(tenant_id, factura_rectificada_id) -> facturas(tenant_id, id) [nullable]
facturas(tenant_id, factura_raiz_id) -> facturas(tenant_id, id) [nullable]

factura_lineas(tenant_id, factura_id) -> facturas(tenant_id, id)
factura_lineas(tenant_id, linea_rectificada_id) -> factura_lineas(tenant_id, id) [nullable]
factura_lineas(tenant_id, linea_raiz_id) -> factura_lineas(tenant_id, id) [nullable]

factura_asignaciones_presupuesto(tenant_id, factura_id) -> facturas(tenant_id, id)
factura_asignaciones_presupuesto(tenant_id, factura_linea_id) -> factura_lineas(tenant_id, id)
factura_asignaciones_presupuesto(tenant_id, presupuesto_id) -> presupuestos(tenant_id, id)
factura_asignaciones_presupuesto(tenant_id, linea_presupuesto_id) -> lineas_presupuesto(tenant_id, id)
factura_asignaciones_presupuesto(tenant_id, certificacion_origen_id) -> certificaciones(tenant_id, id) [nullable]

factura_documentos_emitidos(tenant_id, factura_id) -> facturas(tenant_id, id)
cobros(tenant_id, factura_id) -> facturas(tenant_id, id)
cobros(tenant_id, cobro_origen_id) -> cobros(tenant_id, id) [nullable]

movimientos_credito_cliente(tenant_id, cliente_id) -> clientes(tenant_id, id)
movimientos_credito_cliente(tenant_id, factura_raiz_origen_id) -> facturas(tenant_id, id)
movimientos_credito_cliente(tenant_id, factura_raiz_destino_id) -> facturas(tenant_id, id) [nullable]
movimientos_credito_cliente(tenant_id, movimiento_origen_id) -> movimientos_credito_cliente(tenant_id, id) [nullable]

compras(tenant_id, expediente_id) -> expedientes(tenant_id, id)
compras(tenant_id, proveedor_id) -> proveedores(tenant_id, id) [nullable; nueva FK]
certificaciones(tenant_id, expediente_id) -> expedientes(tenant_id, id)
certificaciones(tenant_id, presupuesto_id) -> presupuestos(tenant_id, id) [nullable]
documentos(tenant_id, expediente_id) -> expedientes(tenant_id, id)
timeline_events(tenant_id, expediente_id) -> expedientes(tenant_id, id)
empresa_configuracion.tenant_id -> tenants.id
```

Todo `ON DELETE` sigue siendo `NO ACTION`. La eliminación funcional actual continúa siendo lógica donde existe. Drift necesitará constraints SQL personalizados o claves/índices compuestos expresados con las capacidades compatibles de su versión; P0-B debe inspeccionar el DDL generado y no asumir que dos FKs simples equivalen a una compuesta.

## 7. Política de IDs

- No cambiar ni prefijar IDs v22.
- Las altas actuales usan mayoritariamente UUID v4, pero el contrato del esquema acepta cualquier texto legacy válido; no se rechazará un ID histórico por no tener formato UUID.
- `empresa_principal` se conserva como ID histórico de configuración, sin reutilizarlo como tenant ID.
- `factura_documentos_emitidos.factura_id` conserva su identidad derivada.
- Desde P0, toda entidad nueva usa UUID v4 opaco generado antes de persistir por una fábrica inyectable en caso de uso/repositorio, nunca por widget ni por SQLite.
- UUID identifica una entidad; `tenant_id` determina autoridad y aislamiento. Conocer un UUID no autoriza acceso.
- Para sincronización futura se mantendrán IDs estables; no se introduce remapeo ni autoincremento.

## 8. Contrato propuesto de TenantContext

API conceptual, no implementada:

```dart
final class TenantId {
  const TenantId(this.value);
  final String value;
}

final class TenantContext {
  const TenantContext({required this.tenantId});
  final TenantId tenantId;
}

abstract interface class ActiveTenantSession {
  TenantContext? get current;
  Stream<TenantContext?> watch();
  Future<void> selectAuthorized(TenantId tenantId);
  Future<void> clear();
}

final class MissingTenantContextException implements Exception {}
```

Responsabilidades:

- La sesión es la única fuente del tenant activo para Presentation/providers; no es una variable global informal.
- Providers empresariales observan un `TenantContext` no nulo y reconstruyen repositorios/streams al cambiarlo.
- Casos de uso capturan un contexto inmutable al comenzar y lo pasan explícitamente a repositorios. Un cambio de selección no altera una operación en curso.
- Repositorios/DAOs empresariales exigen `TenantId` o se construyen ligados a uno; no ofrecen fallback global ni tenant opcional.
- Ausencia de tenant produce estado explícito de arranque/selección, nunca consulta sin filtro.
- Jobs futuros guardan tenant en el payload y revalidan autorización al ejecutar.
- IA/voz recibe contexto ya autorizado desde la sesión/canal; nunca infiere tenant únicamente del texto.
- En P0 local, el bootstrap selecciona el único tenant existente. Crear/cambiar varios tenants públicamente queda fuera hasta diseñar membresías.

## 9. Inventario de accesos afectados

Todas las categorías A–H requieren `tenant + id/filtro`, incluso si el ID es globalmente único.

| Componente | Categorías actuales | Cambio obligatorio |
|---|---|---|
| `ClientesDao` / `ClienteRepository` | A, B, E, F | Listar/observar por tenant; obtener, actualizar y eliminar por `(tenant,id)`; insertar fuerza tenant |
| `ExpedientesDao` / `ExpedienteRepository` | A, B, D, E, F, G | Todos los listados, sin actividad y snapshots por tenant; validar cliente; transacciones y gestión capturan tenant |
| `PresupuestosDao` / `PresupuestoRepository` | A, B, D, E, F, G, H de código interno | Listados/backlog/códigos y estado por tenant; toda relación con obra/factura del mismo tenant |
| `LineasPresupuestoDao` / repositorio | A, B, D, E, F, G | Línea y recálculo por tenant; no mutar por ID solo |
| `FacturasDao` / `FacturaRepository` | A–H | Toda lectura/familia/agregado/escritura por tenant; secuencia, emisión, PDF y Timeline en misma transacción tenant-scoped |
| `FacturaLineasDao` / repositorio | A, B, D, E, F, G | Factura y líneas por tenant; validaciones y totales con padre tenant-scoped |
| `FacturaAsignacionesPresupuestoDao` / repositorios parcial/RECT | B, D, E, F, G | Todos los padres y consultas por tenant; no existe `observarTodas` empresarial sin filtro |
| `FacturaDocumentosEmitidosDao` | A, E, G | Obtener/insertar por `(tenant,factura)`; hash/PDF no accesibles por ID solo |
| `CobrosDao` / `CobroRepository` | A, B, D, E, F, G | Listados, mes, saldos, reversión y sincronización de estado por tenant |
| DAO de crédito / `CreditoClienteRepository` | A, B, D, E, G | Familia, destinos, compensación, devolución y reversión restringidos al tenant |
| `ProveedoresDao` / repositorio | A, B, E, F | Directorio independiente por tenant; no catálogo global BigMat |
| `ComprasDao` / repositorio | A, B, D, E, F | Obra/proveedor y listados por tenant; alta–Timeline sigue con deuda atómica separada |
| `CertificacionesDao` / repositorio | A, B, E, F | Obra/presupuesto y mutaciones por tenant |
| `DocumentosDao` / repositorio | A, B, E, F | Metadata por tenant y obra; ruta no concede acceso |
| `TimelineEventsDao` / repositorio | B, C, E, F, G | “Global” significa global dentro del tenant; deduplicación por referencia incluye tenant |
| `EmpresaConfiguracionDao` / repositorio | A, B, E | Sustituir `limit(1)` y `empresa_principal` operativo por `(tenant_id)` |
| `SearchRepository` | C | Cada fuente ya tenant-scoped antes de combinar/filtrar; nunca cargar universo completo |
| `DashboardRepository` y resúmenes de Expediente | D | Todas las fuentes comparten el mismo tenant capturado |
| Providers Riverpod | Todas | Clave/árbol por tenant; invalidar streams al cambiar; sacar providers heredados de `data/` progresivamente |
| `AppDatabase` heredado | A, B, E, F | Métodos directos también reciben tenant o se retiran al migrar sus consumidores |
| Backup services | G administrativa | Alcance explícito de base completa; no dependen del tenant activo para omitir filas |

Categorías: A lectura por ID; B listados; C búsquedas; D agregados; E escrituras; F eliminaciones; G transacciones; H secuencias/numeraciones.

## 10. Defensa en profundidad

1. **Contexto/autorización de aplicación.** Impide que UI, webhook, job o IA elijan un tenant no autorizado; captura el tenant durante toda la operación. Evita confusión de sesión y deputy attacks.
2. **Repositorios, DAOs y queries.** Todo `SELECT/UPDATE/DELETE` incluye `tenant_id`; inserciones lo fijan desde contexto, no desde formularios. Evita exposición masiva, mutación por ID conocido y métricas mezcladas ante bugs de Presentation.
3. **Constraints SQLite.** FKs y unique compuestas rechazan relaciones cruzadas aunque una query o companion sea errónea. Evita corrupción silenciosa, pero no sustituye filtros de lectura.

Las pruebas negativas deben fallar de manera controlada en los tres niveles. Un bug de UI nunca podrá crear un Expediente del tenant A ligado al Cliente B.

## 11. Facturación y numeración FAC/RECT

Se preservan reglas económicas, estados, redondeo, inmutabilidad, asignaciones, rectificación por diferencias, cobros y crédito.

Índice a retirar:

```sql
CREATE UNIQUE INDEX facturas_numeracion_legal_unica
ON facturas(serie, anio_numeracion, numero_legal)
WHERE anio_numeracion IS NOT NULL AND numero_legal IS NOT NULL;
```

Sustituto v23:

```sql
CREATE UNIQUE INDEX facturas_numeracion_legal_unica
ON facturas(tenant_id, serie, anio_numeracion, numero_legal)
WHERE anio_numeracion IS NOT NULL AND numero_legal IS NOT NULL;
```

La consulta inmediata será conceptualmente:

```sql
SELECT COALESCE(MAX(numero_legal), 0)
FROM facturas
WHERE tenant_id = ? AND anio_numeracion = ? AND serie = ?;
```

Se ejecutará dentro de la misma transacción exclusiva de emisión que inserta/actualiza número, snapshot y PDF. `FAC` y `RECT` siguen siendo series independientes. Dos tenants pueden tener legítimamente `FAC-2026-0001`; un tenant no puede repetirla.

No se crea tabla de series en v23 porque el mecanismo actual ya es transaccional y solo existen defaults FAC/RECT. Configuración de prefijos, huecos, centros o varias series se aplaza. En cloud/multidispositivo, el servidor será autoridad de números definitivos; clientes offline solo crean borradores UUID sin número legal.

Las FKs compuestas garantizan dentro del tenant: factura–cliente–presupuesto, RECT–documento rectificado–raíz, línea–genealogía, asignación–presupuesto/partidas/certificación, cobro–reversión y crédito–origen/destino/reversión. Los checks funcionales actuales del crédito se conservan literalmente.

## 12. Configuración, emisor y branding

P0 incluye:

- `tenant_id NOT NULL`, FK y `UNIQUE(tenant_id)` en `empresa_configuracion`;
- DAO/repositorio por tenant, sin `limit(1)` global;
- conservación exacta de nombre, CIF, dirección, contacto, web y `logo_path` actuales;
- snapshot fiscal de nueva factura obtenido de la configuración del mismo tenant.

P0 no incluye cuenta bancaria, plantillas, almacén dinámico de logos ni nuevos campos fiscales. Esos conceptos serán tablas/configuraciones tenant-scoped cuando exista necesidad real.

`assets/images/logo_empresa.png` deja de considerarse contrato de producto: podrá actuar temporalmente como fallback visual genérico, pero ningún documento nuevo debe asumir que representa a todos los tenants. La sustitución por branding gestionado es P1/P2. Los PDFs emitidos existentes se preservan byte a byte; nunca se regeneran al cambiar branding. Sus snapshots empresariales permanecen inmutables.

## 13. Tarifas heredadas

- `lib/database/precios.dart` contiene constantes globales para excavación, hormigones, bloque, gresite y mano de obra.
- `lib/engines/pool_engine.dart` usa esas constantes y además precios literales `18`, `42` y `38` para partidas de piscina.
- `lib/screens/presupuesto_menu_screen.dart` y `presupuesto_screen.dart` exponen el flujo heredado de piscinas.

No modifica el core persistido de Presupuestos/Facturas salvo cuando un usuario copie su resultado manualmente. Es deuda legacy aislable, **P1**, no bloquea P0. Antes de integrar ese motor con el core económico o aprendizaje, tarifas y plantillas deberán pertenecer al tenant y al módulo de oficio. No se refactoriza en v23.

## 14. Documentos y Timeline

### Documentos

P0 solo añade `tenant_id`, FK compuesta a Expediente, clave candidata e índices tenant-first. Conserva `ruta_archivo`, nombre, MIME, tamaño y fechas sin tocar el archivo externo. El modelo futuro añadirá original inmutable gestionado, hash, metadata derivada y `storageObjectId`; la ubicación física no será identidad, pero ese gestor no pertenece a v23.

### Timeline

Cada evento se backfillea al tenant de su Expediente y queda protegido por FK compuesta. Consultas llamadas “globales” pasan a significar globales dentro de un tenant. `referencia_id` se conserva sin inventar FK porque es polimórfica y no tipada.

La falta de atomicidad Compra–Timeline sigue como deuda independiente. La migración solo preserva ambos conjuntos y su tenant; no cambia la operación de alta salvo lo imprescindible para aportar `tenant_id`.

## 15. Backup y restore en P0

- El archivo sigue conteniendo todos los tenants de esa instalación local y se etiqueta en documentación/UI como **copia completa de la instalación**.
- El manifiesto mantiene formato de contenedor 1 salvo que una prueba demuestre necesidad de elevarlo; `schemaVersion` pasa a 23 dentro del payload y la lista de tablas esperadas incorpora `tenants`.
- Validación: versión soportada, integridad, cero FK rotas, al menos un tenant y cero filas empresariales sin tenant válido.
- Restore de v22 sigue permitido: staging lo migra a v23 y valida antes del swap.
- Restore de v23 reemplaza la instalación completa después de mostrar alcance y crear backup de recuperación. No fusiona tenants ni consulta el tenant activo.
- Un backup v23 incompatible/corrupto se rechaza antes de cerrar la base activa.
- Exportación, importación o restore parcial por tenant, adjuntos, cloud y cifrado quedan fuera de P0.

## 16. Búsqueda, dashboard y proveedores

`SearchRepository` combina streams de Expedientes, Clientes, Presupuestos y Facturas y filtra en memoria; sus cuatro fuentes deben estar filtradas por el mismo `TenantContext` antes de combinarse. Resultados y navegación conservan tenant en contexto, aunque el resultado exponga solo el ID.

`DashboardRepository`, resúmenes de Expediente, facturación mensual, cobros mensuales, backlog, pendientes y Timeline global deberán capturar un tenant único. Se prohibirá combinar streams creados bajo contextos distintos.

Proveedores son relaciones privadas del tenant. Dos filas “BigMat” en tenants distintos son entidades independientes, con UUID, observaciones, condiciones e histórico propios. P0 no crea catálogo maestro, deduplicación global ni proveedor compartido.

## 17. Orden ejecutable v22 → v23

SQLite no permite añadir después una FK compuesta ni cambiar PK/unique con `ALTER COLUMN`; **las 16 tablas requieren rebuild**. El diseño usa tablas sombra `_v23` para mantener intactas las v22 hasta validar la copia.

La base se abre actualmente mediante `AppDatabase()`, lo que dispara la migración antes de disponer de un repositorio activo. Por ello P0-B debe añadir un coordinador de actualización **pre-open** próximo a `DatabaseLifecycleController`: inspeccionará `user_version` con una conexión SQLite controlada, creará una recuperación consistente mediante snapshot SQLite de la base todavía cerrada para Drift y solo entonces permitirá abrir `AppDatabase`. No puede afirmarse que habrá backup previo reutilizando sin cambios `BackupArchiveService`, porque ese servicio exige un `AppDatabase` ya abierto.

1. Antes de publicar `databaseProvider`, el coordinador pre-open toma exclusividad sobre el archivo y confirma que no existe una instancia activa.
2. Inspeccionar `user_version`; si es 22, abrir SQLite controladamente, recuperar cualquier WAL comprometido, crear un snapshot v22 consistente en ubicación temporal/recuperación y validarlo. No iniciar migración si falla. Si ya es 23, omitir migración y ejecutar validación de apertura normal.
3. Abrir la base mediante la ruta Drift de migración controlada; confirmar v22 y ejecutar preflight. El snapshot v22 deberá poder empaquetarse/restaurarse con el formato actual de backup.
4. Con `foreign_keys` desactivado antes de iniciar la transacción —SQLite no permite cambiarlo dentro—, comenzar una única transacción inmediata/exclusiva. No exponer la conexión.
5. Generar `initialTenantId` y `migrationNowUtc`; crear `tenants`; insertar el tenant inicial.
6. Crear las 16 tablas sombra `*_v23` con DDL final, `tenant_id NOT NULL`, checks y FKs compuestas que apuntan a los nombres finales. No eliminar todavía tablas v22.
7. Copiar raíces: `clientes`, `proveedores`, `empresa_configuracion`, añadiendo `initialTenantId`.
8. Copiar agregado: `expedientes`.
9. Copiar presupuestación/obra: `presupuestos`, `lineas_presupuesto`, `certificaciones`, `compras`, `documentos`, `timeline_events`.
10. Copiar facturación: `facturas`, `factura_lineas`, `factura_asignaciones_presupuesto`, `factura_documentos_emitidos`, `cobros`, `movimientos_credito_cliente`.
11. Ejecutar sobre tablas sombra recuentos, IDs, sumas/hashes y comprobaciones manuales de igualdad de tenant en todas las relaciones. Abortar ante cualquier discrepancia.
12. Eliminar tablas v22 en orden hijo→padre: movimientos de crédito, documentos emitidos, asignaciones, cobros, líneas de factura, facturas, líneas de presupuesto, certificaciones, compras, documentos, Timeline, presupuestos, expedientes, configuración, proveedores y clientes. El orden exacto se verificará contra el DDL generado.
13. Renombrar tablas sombra a sus nombres finales en orden padre→hijo: clientes, proveedores, configuración, expedientes, presupuestos, líneas presupuesto, certificaciones, compras, documentos, Timeline, facturas, líneas factura, asignaciones, documentos emitidos, cobros y crédito.
14. Crear índices tenant-first y el unique fiscal parcial. Confirmar mediante `sqlite_master` que no queda el índice global.
15. Ejecutar `PRAGMA foreign_key_check` aun dentro de la transacción y todos los checks post-migración. Establecer versión 23 solo al finalizar correctamente por el mecanismo de Drift.
16. Commit. Reactivar `PRAGMA foreign_keys = ON` fuera de la transacción, confirmarlo y ejecutar de nuevo `foreign_key_check` e `integrity_check`.
17. Abrir una instancia nueva, ejecutar lecturas de salud del tenant inicial y publicar la conexión. Si falla, no continuar silenciosamente: cerrar y ofrecer recuperación desde backup.

P0-B deberá validar con la versión SQLite incluida que las operaciones de rename no reescriben FKs a nombres sombra de forma inesperada. El test inspeccionará `PRAGMA foreign_key_list` de todas las tablas finales.

## 18. Fallo, rollback y reapertura

- Cualquier error entre los pasos 4 y 15 provoca rollback de la única transacción; las tablas v22, índices y `user_version=22` permanecen.
- No se capturan errores para continuar con datos parciales ni se usa `INSERT OR IGNORE`.
- El UUID generado en un intento fallido puede cambiar al reintentar; ningún dato lo observa porque el intento se revierte íntegramente.
- Si falla después del commit pero antes de publicar conexión, cerrar la v23, conservar diagnóstico no sensible y usar el backup de recuperación mediante el coordinador probado. No intentar “desmigrar” fila a fila.
- La UI mostrará que no pudo actualizar los datos, que la copia anterior se conserva y si la recuperación automática tuvo éxito; no mostrará SQL, rutas ni datos fiscales.
- La aplicación nunca abrirá normalmente una base cuyo `user_version`, tablas, integridad o FK check no superen validación.

## 19. Validaciones post-migración

### Estructura

- `user_version = 23`, 17 tablas esperadas y exactamente una fila inicial en `tenants` al migrar v22.
- Cero `tenant_id IS NULL`, vacío o sin padre en cada una de las 16 tablas.
- `PRAGMA integrity_check = ok`; `foreign_keys = 1` tras reapertura; `foreign_key_check` vacío.
- FKs compuestas presentes según la sección 6; cuatro checks de crédito presentes; índices tenant-first y unique fiscal presentes; índice fiscal global ausente.

### Conservación por tabla

- Mismo `COUNT(*)` y mismo conjunto ordenado de IDs antes/después para las 15 tablas con `id` o clave identificadora; para documentos emitidos, mismo conjunto `factura_id`.
- Todas las filas tienen `tenant_id = initialTenantId`.
- Mismas relaciones nullable/no nullable y valores de borrado/estado.
- Sumas y, preferiblemente, huellas deterministas por fila de: presupuestos `importe_total`; facturas `subtotal/iva/total/efectos`; asignaciones `cantidad_aplicada/base_aplicada`; cobros `importe`; compras/certificaciones `base/iva/total`; crédito `importe`; líneas y descuentos.
- Mismos códigos, series, año, número legal, fechas de emisión/vencimiento, snapshots de cliente/empresa/obra/presupuesto y genealogías FAC/RECT.
- Por PDF emitido: mismo tamaño, SHA-256 almacenado y SHA-256 recalculado de BLOB.
- Mismos metadatos/rutas de documentos y eventos Timeline.

### Coherencia adicional

- Toda factura y sus líneas/asignaciones/PDF/cobros/crédito comparten tenant.
- `compras.proveedor_id` no nulo existe en mismo tenant.
- Toda certificación con presupuesto referencia un presupuesto del mismo tenant. La coincidencia entre `certificaciones.expediente_id` y el expediente de ese presupuesto se audita como consistencia de dominio, pero v23 no rechaza datos legacy ni añade esa regla sin una decisión funcional separada.
- No hay duplicados fiscales por `(tenant,serie,año,número)`.
- Configuración, si existe, pertenece al tenant inicial y hay como máximo una por tenant.

## 20. Plan de pruebas P0-B

1. Fixture v22 poblada con las 16 tablas, relaciones opcionales, borrados lógicos, FAC, varias RECT, asignaciones, PDF BLOB/hash, cobros/reversiones, crédito/compensación/reversión, compras, certificaciones, documentos y Timeline → v23.
2. v22 vacía → v23 con un tenant y cero filas empresariales.
3. Configuración con nombre fiable nombra tenant; configuración vacía/ausente usa `Empresa inicial`; nunca aparece Tovar hardcoded.
4. Más de una configuración, proveedor de Compra huérfano, FK rota o integridad fallida aborta y conserva v22.
5. UUID/reloj inyectados producen tenant y timestamps esperados; reabrir v23 no duplica tenant ni backfill.
6. IDs, recuentos, relaciones, nulos, estados, fechas y eliminados idénticos.
7. Conservación económica y monetaria fila a fila y por agregados; ningún redondeo durante migración.
8. PDFs exactamente iguales y hashes válidos.
9. Dos tenants pueden crear Cliente/Proveedor/códigos iguales sin compartir entidad.
10. Tenant B no lee, observa, busca, actualiza ni elimina Cliente/Proveedor/Expediente del A, incluso conociendo ID.
11. Rechazo SQLite de Expediente A→Cliente B y Presupuesto A→Expediente B.
12. Rechazo de Factura A→Cliente/Presupuesto B, RECT A→Factura B y línea RECT cruzada.
13. Rechazo de asignación que mezcle factura, líneas, presupuesto, partida o certificación de tenants.
14. Rechazo de Cobro A→Factura B y reversión A→Cobro B.
15. Rechazo de devolución/compensación/reversión de crédito cruzada; destinos elegibles nunca incluyen B.
16. Rechazo de Compra A→Expediente/Proveedor B; dos BigMat independientes funcionan.
17. Rechazo de Certificación, Documento y Timeline cruzados.
18. FAC A y FAC B pueden emitir mismo año/correlativo; dos FAC del mismo tenant no. Repetir para RECT.
19. Emisiones concurrentes dentro de tenant no colisionan; emisiones simultáneas de tenants distintos son independientes.
20. Búsqueda, dashboard, resúmenes, contadores, backlog, mensuales y Timeline global muestran solo tenant activo.
21. Cambio de tenant cancela/invalida streams; una operación iniciada conserva su contexto capturado.
22. Ausencia de tenant bloquea toda operación empresarial.
23. Backup v23 completo crea/valida/restaura todos los tenants; restore v22 migra en staging y conserva datos; backup corrupto no toca activa.
24. Fallo inyectado en cada bloque de rebuild revierte a v22 sin tablas sombra visibles ni versión parcial.
25. Migraciones soportadas 16–22 continúan llegando a v23 por rutas probadas, sin saltarse garantías históricas.
26. Inspección de `sqlite_master`, `foreign_key_list`, `index_list` e `index_info` confirma DDL real.

Todas las pruebas de persistencia usan memoria o archivos temporales; nunca la base real.

## 21. Criterios de aceptación de P0-B

Implementación verificada: Drift usa constraints SQL personalizados para las FKs compuestas que su API declarativa no expresa en esta versión; el DDL real y los rechazos SQLite se prueban directamente. El contexto se resuelve antes de publicar la base y no existe fallback empresarial silencioso. La copia previa usa `VACUUM INTO` sobre el archivo v22 cerrado, valida integridad/relaciones y genera nombres únicos. Los defaults de `tenantId` en companions existen únicamente para compatibilidad de fixtures; DAOs y producción inyectan siempre el tenant activo. El backup v23 conserva deliberadamente todos los tenants de la instalación y el restore parcial continúa fuera de alcance.

- [ ] `schemaVersion` aumenta exactamente a 23 y el código Drift se regenera, sin ediciones manuales del generado.
- [ ] Migración desde cada versión soportada y apertura v23 directa están probadas.
- [ ] Backup de recuperación previo y rollback ante fallos están demostrados.
- [ ] Cero pérdida o transformación de IDs, relaciones, importes, estados, snapshots, PDF, documentos o Timeline.
- [ ] Las 16 tablas tienen tenant obligatorio; todas las FKs críticas son compuestas y `foreign_key_check` queda vacío.
- [ ] Lectura, escritura, actualización y eliminación por ID exigen tenant.
- [ ] Pruebas negativas con dos tenants cubren todas las relaciones y agregados.
- [ ] FAC/RECT son independientes entre tenants y únicas dentro de cada tenant; concurrencia sigue protegida.
- [ ] Cobros, crédito, rectificaciones, asignaciones y PDF conservan transacciones/inmutabilidad.
- [ ] Configuración, búsqueda, dashboard, Timeline y providers no mezclan tenants.
- [ ] Backup/restore completo v23 y restore soportado de v22 funcionan con staging y datos temporales.
- [ ] `flutter analyze --no-pub`, pruebas específicas, suite completa, `git diff --check` y build Windows debug superan.
- [ ] No se habilita selector multiempresa, usuarios, autenticación, cloud, sync, storage documental ni Fase 3.
- [ ] `CURRENT_STATE`, `MASTER_PLAN`, decisiones y diseño de backup quedan alineados con lo realmente implementado.

## 22. Web, IA y cloud/offline: contratos futuros

- Ninguna operación empresarial puede ejecutarse sin tenant explícito y autorizado.
- IA/voz no elige tenant por texto; recibe el contexto de sesión/canal y solicita confirmación para operaciones relevantes.
- Entrada externa: `formulario/webhook/integración → integración autenticada → tenant → contexto autorizado → caso de uso`. Se prohíbe buscar globalmente empresa por texto y escribir.
- Necesario en P0: IDs estables, tenant obligatorio, `createdAt/updatedAt` conservados, reloj inyectable para lo nuevo, borrado lógico existente sin reinterpretarlo, secuencias fiscales tenant-scoped e interfaces preparadas para idempotency key futura.
- Preparado conceptualmente, no implementado: timestamps completamente normalizados a UTC, revisión/versionado de fila, tombstones uniformes, outbox, resolución de conflictos, autoridad cloud, sync y edición offline.
- No se añadirán columnas de sync a las 16 tablas en v23 sin diseñar previamente semántica y migración; P0 evita bloquearlas mediante UUID y tenant explícito.

## 23. Roadmap P0 refinado

El orden auditado P0-B persistencia → P0-C contexto/accesos no es aterrizable como dos estados productivos independientes: `tenant_id NOT NULL` obliga a todas las escrituras a aportar tenant, y dejar lecturas globales permitiría mezcla al probar dos tenants.

Orden refinado:

1. **P0-A — diseño ejecutable:** este documento.
2. **P0-B — migración vertical segura:** tabla Tenant, v23, backfill, constraints, `TenantContext` local mínimo, DAOs/repositorios/providers/búsqueda/dashboard tenant-scoped, backup y pruebas con dos tenants. Sin selector público, usuarios ni auth.
3. **P0-C — ciclo de tenant y limpieza de frontera:** bootstrap/cambio de tenant preparado para futuras membresías, invalidación de sesión, retirada de accesos heredados y consolidación de casos de uso. Solo se habilitará multiempresa visible cuando exista autorización adecuada.
4. **P0-D — endurecimiento fiscal end-to-end:** revisión independiente y pruebas ampliadas de FAC/RECT, concurrencia, snapshots, PDFs, cobros, crédito y backup bajo múltiples tenants.

P0-B será mayor que una migración aislada, pero constituye el mínimo estado seguro y compilable. Debe desarrollarse en commits técnicos pequeños dentro del incremento, sin publicar estados intermedios inseguros.

## 24. Riesgos abiertos

- Drift puede no expresar directamente todas las FKs compuestas; se deberá verificar y, si procede, usar DDL controlado con pruebas del SQL final.
- `compras.proveedor_id` puede contener huérfanos porque v22 no tiene FK; la política es abortar y diagnosticar, nunca perder el valor.
- v22 no fuerza singleton de configuración; más de una fila bloquea migración automática.
- Rebuild de BLOB PDF puede requerir espacio temporal significativo; backup y comprobación de espacio son obligatorios.
- Desactivar `foreign_keys` exige control exclusivo y reactivación verificada; una excepción no puede devolver una conexión normal con el pragma apagado.
- Semántica UTC histórica no se corrige en migración; convertir timestamps sería destructivo e incierto.
- IDs legacy no UUID se conservan; la política UUID solo rige nuevas altas.
- La atomicidad Compra–Timeline, ruta documental, branding dinámico, tarifas de piscinas y sync siguen como deudas separadas.

## 25. Estado de cierre

P0-A, P0-B, P0-C y P0-D están completados. La verificación end-to-end confirma aislamiento por tenant en las 16 tablas empresariales, consultas por ID, relaciones compuestas, configuración, búsqueda, dashboard, expediente, Timeline, providers, numeración y concurrencia FAC/RECT, y backup/reapertura con dos tenants. La suite completa alcanza 241 pruebas y se mantienen `schemaVersion` 23 y la restauración de instalación completa.

El siguiente hito recomendado es definir expresamente la Fase 3. No se habilitan por este cierre usuarios, autenticación, selector multiempresa público, cloud, sincronización, web ni IA.

## 26. Clasificación final de accesos

- **A — tenant-scoped correcto:** operaciones empresariales de DAOs y repositorios, consultas por ID, agregados, búsquedas, streams y numeraciones filtran por el tenant capturado; las relaciones críticas usan claves compuestas.
- **B — global interno legítimo:** PRAGMAs, inspección de `sqlite_master`, salud de SQLite, migraciones y coordinación de copias completas de instalación.
- **C — deuda aceptada fuera de P0:** selector/autorización, exportación parcial, storage documental, branding, tarifas, cloud/sync/web/IA, circuito administrativo de compras, atomicidad Compra–Timeline y métricas de Fase 3.
- **D — fuga corregida:** cachés de providers sin dependencia explícita del tenant, acceso directo de `ClienteTab` a la base y el identificador fijo de Configuración.

La evidencia ejecutable cubre tenant ausente, dos tenants con IDs conocidos, lectura/actualización/eliminación negativas, constraints cruzadas, FAC/RECT realistas y concurrentes, cambio de contexto, configuración independiente, búsqueda/dashboard/expediente/Timeline y snapshot/reapertura. No se detectan fugas D pendientes dentro del alcance auditado.

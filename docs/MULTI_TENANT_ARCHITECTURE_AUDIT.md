# Auditoría arquitectónica multi-tenant

Auditoría documental realizada el **3 de septiembre de 2026** sobre el código de `main` en `62f76547effc0cbc7303532811e098066fc6aedb`. No implementa multi-tenancy, no modifica el esquema Drift y no presenta capacidades futuras como existentes.

## Conclusión ejecutiva

OBRA IA funciona hoy como una aplicación local de **una sola empresa implícita**: una base `obraia.sqlite`, una configuración empresarial singleton y consultas globales. La trazabilidad económica de Fase 2, los UUID, las claves foráneas, las transacciones y los snapshots históricos son activos reutilizables, pero no existe una frontera de seguridad entre empresas.

El nivel de preparación multi-tenant es **conceptual inicial / técnico insuficiente para alojar dos tenants en el mismo almacén**. Añadir `tenantId` a algunas tablas o filtrar la UI no bastaría: la frontera debe existir en persistencia, constraints, consultas, casos de uso, documentos, cachés, búsquedas, backups e integraciones.

La decisión mínima que evita deuda cara es completar antes de Fase 3 un bloque independiente que introduzca el contexto de tenant y migre de forma compatible todo el esquema y los accesos actuales, asignando los datos existentes al tenant inicial. Fase 3 no debe crear nuevas entidades económicas sobre el modelo monoempresa.

## Visión de producto adoptada

OBRA IA evolucionará hacia un **empleado digital especializado en autónomos y pequeñas empresas de construcción y oficios relacionados**. Una función se prioriza por cuánto tiempo, dinero, administración, carga mental o errores evita al profesional.

```text
CORE DEL PRODUCTO
  + TENANT / EMPRESA Y SU CONFIGURACIÓN
  + MÓDULOS ACTIVABLES POR OFICIO
  + PLANTILLAS Y WORKFLOWS CONFIGURABLES
```

Construcciones Tovar es el primer tenant, usuario real y banco de pruebas; no forma parte del core. No se crearán forks por gremio. Interfaz gráfica, automatización e interfaces futuras de lenguaje natural o voz deberán invocar las mismas operaciones seguras del dominio.

## Arquitectura actual relevante

- Flutter/Dart y Riverpod; Windows es la plataforma prioritaria actual.
- Drift sobre una única SQLite local, con 16 tablas y `schemaVersion` 22.
- Flujo objetivo: `Presentation → Providers → Repositories → DAOs → Drift → SQLite`.
- Persisten providers en `data/`, acceso de una pantalla a `databaseProvider` y operaciones de creación que aún nacen en widgets. Esto dificulta reutilizar operaciones desde IA/voz.
- Los identificadores principales son textos y las altas modernas usan UUID v4. Es una buena base para sincronización, aunque su generación debe salir de los widgets.
- Las fechas usan `DateTime.now()` y defaults SQLite sin política uniforme de UTC, reloj de servidor, revisión o control de conflictos.
- Base, búsqueda, dashboard, configuración y backup operan globalmente; no existe `TenantContext`, usuario, membresía, rol ni tenant activo.

## Evaluación por área

Leyenda: **A** compatible o activo reutilizable; **B** necesita adaptación; **C** riesgo importante; **D** acoplamiento empresarial específico; **E** decisión necesaria antes de ampliar el dominio.

| Área | A | B/C/D | E — decisión previa |
|---|---|---|---|
| Tablas, PK, FK e IDs | UUID y varias FK reutilizables | B/C: ninguna fila tiene tenant; un UUID global no impide relaciones cruzadas | `tenantId` directo, FK/unique compuestas e índices tenant-first |
| DAOs | Acceso encapsulado por tablas | B/C: selects, updates y deletes globales o solo por ID | Tenant obligatorio en toda API; consultas globales solo administrativas |
| Repositorios | Varias transacciones económicas maduras | B/C: no reciben contexto tenant; algunos contienen providers Riverpod | Casos de uso tenant-aware y repositorios sin UI/Riverpod |
| Providers y cachés | Riverpod permite reconstruir dependencias | B/C: no hay tenant activo en claves; streams pueden sobrevivir a un cambio | Árbol tenant-scoped e invalidación completa al cambiar tenant |
| Servicios | PDF y backup están separados de widgets | B/C: logo, configuración, base y archivos son globales | Dependencias y políticas explícitas por tenant |
| Modelos de dominio | UUID y snapshots históricos aprovechables | B: no expresan pertenencia/autoridad tenant | Contexto de operación obligatorio; decidir cuándo exponer `tenantId` al dominio |
| Configuración/settings | Datos empresariales configurables, sin valores reales incrustados | C: singleton `empresa_principal`, `limit(1)`; D: logo empaquetado global | Una configuración y branding versionado por tenant |
| Clientes y proveedores | Raíces bien delimitadas | B/C: listados, NIF y borrado lógico globales | Tenant directo y políticas de unicidad por empresa |
| Expedientes | Agregado operativo y relaciones existentes | B/C: cliente/descendientes sin frontera; faltan capacidades futuras | Toda relación del agregado debe probar igualdad de tenant |
| Presupuestos | Líneas y estados existentes | B/C: códigos, tarifas, IVA y cálculo sin tenant; motor piscina global | Plan aceptado versionado y catálogos/márgenes del tenant |
| Facturación/RECT | Inmutabilidad, snapshots, transacciones y PDF definitivo | C: secuencias, unique, configuración, familias y crédito globales | Secuencia `(tenant, serie, ejercicio)` y constraints cruzados |
| Cobros/crédito | Movimientos y reversiones trazables | C: una relación por ID puede cruzar tenants | Tenant en cada movimiento y transacción de extremo a extremo |
| Compras | Gasto ligado a una obra | B/C: proveedor sin FK, sin original/pagos; no es circuito administrativo | Mantener semántica actual y diseñar entidades P1 tenant-scoped |
| Certificaciones | FK a obra/presupuesto | B/C: sin tenant; integración parcial aplazada | FK compuesta y encaje con plan previsto/versiones |
| Documentos/fotos | Metadata y vínculo a obra | C: ruta externa como localización esencial; backup no incluye original | Objeto estable, original inmutable y storage por tenant |
| Timeline | Trazabilidad por obra | B/C: referencia no tipada, consultas globales y falta actor | Tenant directo y futura auditoría de actor/origen |
| Búsqueda | Agrega módulos existentes | C: carga resultados globales y filtra en memoria | Índice/consulta tenant-scoped desde el origen |
| Dashboard | Reutiliza repositorios y estados reales | C: agregados y streams globales | Contexto tenant obligatorio en cada fuente |
| Backup/restore | Snapshot y restore completos y robustos | C: unidad única global, sin tenant ni adjuntos externos | Distinguir backup técnico de export/restore por tenant |
| Web, correo e integraciones | No hay dependencia productiva encontrada | B/E: no existe modelo de conexión ni secretos | Configuración por tenant y resolución confiable del tenant de entrada |
| UI frente a IA/voz | Parte de la lógica ya reside en repositorios | B/C: creación/IDs en widgets y accesos directos heredados | Casos de uso comunes, autorizados, auditables e idempotentes |
| Cloud/móvil/offline | UUID y SQLite local son aprovechables | C: sin sync, revisiones, UTC uniforme, conflictos u outbox | Autoridad remota, política de conflictos y límites offline |
| Producto multigremio | Core comercial general coexistente | B/D: motor y tarifas de piscinas están hardcoded | Módulos/plantillas configurables, nunca forks |

No hay ningún área de datos empresariales que sea ya multi-tenant de extremo a extremo. Las marcas A identifican piezas reutilizables, no aislamiento efectivo.

## Inventario de persistencia y frontera futura

Ninguna tabla contiene `tenantId`. Se recomienda una columna directa y obligatoria en todas las filas empresariales, incluso si pudiera inferirse por el padre. Esta duplicación controlada permite constraints compuestos, consultas defensivas e índices eficaces.

| Tabla actual | Dependencia actual | Evaluación | Frontera futura recomendada |
|---|---|---|---|
| `empresa_configuracion` | Ninguna; DAO toma la primera fila | Riesgo importante | Configuración por `tenantId`; eliminar singleton global |
| `clientes` | Raíz global | Necesita adaptación | `tenantId`; unicidades fiscales, si se adoptan, por tenant |
| `proveedores` | Raíz global | Necesita adaptación | `tenantId`; identidad y precios por tenant |
| `expedientes` | Cliente opcional | Riesgo importante | `tenantId` y FK compuesta al cliente del mismo tenant |
| `presupuestos` | Expediente | Riesgo importante | `tenantId`, FK compuesta y códigos/series por tenant |
| `lineas_presupuesto` | Presupuesto | Necesita adaptación | `tenantId` y FK compuesta al presupuesto |
| `facturas` | Cliente y presupuesto opcional | Riesgo crítico fiscal | `tenantId`; FKs compuestas; numeración y familia RECT por tenant |
| `factura_lineas` | Factura y autorrelaciones RECT | Riesgo importante | `tenantId` y FKs compuestas, incluidas raíz/rectificada |
| `factura_asignaciones_presupuesto` | Cinco referencias económicas | Riesgo crítico | `tenantId`; todas las relaciones compuestas y coherentes |
| `factura_documentos_emitidos` | Factura | Riesgo crítico documental | `tenantId`; PK/FK compuesta; bytes y hash ligados al emisor |
| `cobros` | Factura y reversión | Riesgo crítico económico | `tenantId`; FKs compuestas y operaciones tenant-scoped |
| `movimientos_credito_cliente` | Cliente, FAC/RECT y reversión | Riesgo crítico económico | `tenantId`; origen, destino y reversión del mismo tenant |
| `compras` | Expediente; proveedor sin FK Drift | Riesgo importante | `tenantId`; FKs compuestas a obra/proveedor; snapshot de nombre |
| `certificaciones` | Expediente y presupuesto opcional | Riesgo importante | `tenantId` y FKs compuestas |
| `documentos` | Expediente y ruta física | Riesgo crítico documental | `tenantId`, FK compuesta y objeto almacenado, no identidad por ruta |
| `timeline_events` | Expediente; referencia no tipada | Riesgo importante | `tenantId`, FK compuesta y futura referencia tipada/validada |

La futura tabla `tenants` no llevaría `tenantId` sobre sí misma. Usuarios, membresías, roles, permisos, integraciones, plantillas, tarifas, automatizaciones y almacenamiento son entidades futuras y no se crean en esta auditoría.

## Estrategia recomendada de aislamiento

### Persistencia

1. Crear `tenants` y un tenant inicial con UUID estable; migrar todas las filas actuales a ese tenant mediante una migración compatible y probada.
2. Añadir `tenant_id TEXT NOT NULL` a toda tabla empresarial.
3. Mantener UUID como identidad técnica y declarar `UNIQUE (tenant_id, id)` en padres para permitir FKs `(tenant_id, parent_id)`.
4. Convertir toda unicidad empresarial a ámbito tenant, incluida factura `(tenant_id, serie, ejercicio, correlativo)` y una configuración por tenant.
5. Indexar primero `tenant_id` y después campos habituales de filtro/ordenación.
6. Probar que insertar o relacionar datos entre tenants falla en SQLite, no solo en la aplicación.

### Acceso y operaciones

- Introducir un `TenantContext` obligatorio e inmutable durante cada operación.
- Hacer que DAOs y repositorios reciban el tenant explícitamente; reservar consultas globales para administración separada y autorizada.
- Centralizar comandos en casos de uso/servicios de aplicación transaccionales. UI, automatización e IA/voz usarán los mismos comandos.
- Aplicar defensa en profundidad: autorización en caso de uso, filtro en consulta y constraint en persistencia.
- Evitar un `tenantId` opcional o singleton mutable que pueda cambiar durante una operación.
- En backend futuro, no confiar en un identificador de tenant enviado por el cliente.

### Cachés y estado

- Incluir `tenantId` en claves de providers, cachés, streams, búsquedas y trabajos en segundo plano.
- Al cambiar tenant activo, invalidar dependencias tenant-scoped y cancelar suscripciones anteriores.
- No mezclar entidades de tenants en caché sin claves y autorización explícitas.

## Usuarios, roles y tenant activo

```text
Usuario ──< Membresía >── Tenant
                    └── Rol / permisos
Sesión ── tenant activo + usuario autenticado
```

La identidad del usuario no sustituye al tenant: un usuario podrá pertenecer a varios y deberá seleccionar uno activo. Los permisos se evaluarán dentro de la membresía. Auditoría, autor de operaciones, invitaciones, revocación y cambio de tenant requerirán casos de uso propios. No debe introducirse autenticación hasta definir autoridad de sesión, recuperación, almacenamiento seguro de credenciales y comportamiento offline.

## Facturación, numeraciones y crédito

La facturación actual tiene garantías que deben preservarse: FAC y RECT separadas, numeración al emitir, operación transaccional, documentos emitidos inmutables, cadenas rectificativas, snapshots fiscales, PDF exacto con SHA-256 y movimientos de cobro/crédito reversibles.

Riesgos actuales:

- El índice único es global: `(serie, anio_numeracion, numero_legal)`.
- `MAX(numero_legal)` filtra año y serie, pero no empresa.
- `FAC` y `RECT` son defaults globales, no configuración versionada por tenant.
- Familias RECT, asignaciones, cobros, compensaciones y reversiones se validan por IDs sin igualdad de tenant.
- La configuración emisora se obtiene como primera fila global.

Antes de Fase 3 el tenant debe formar parte de consultas, constraints y transacciones fiscales. La secuencia será única por `(tenant, serie, ejercicio)` y la asignará una autoridad transaccional compatible con concurrencia y futura sincronización. Offline podrá crear borradores con UUID, pero no reservará números definitivos sin estrategia explícita.

No se alteran aquí reglas fiscales ni documentos emitidos.

## PDFs y snapshots fiscales

- Las facturas emitidas congelan datos de cliente, empresa, expediente y presupuesto: buena base histórica.
- El PDF definitivo se guarda en SQLite con hash y debe quedar ligado al tenant de la factura.
- Los presupuestos se generan desde configuración viva y no guardan snapshot definitivo equivalente.
- El helper carga siempre `assets/images/logo_empresa.png`; `empresa_configuracion.logoPath` existe pero no se usa. Es branding global empaquetado y deuda de producto.

El branding debe resolverse mediante configuración/plantilla versionada por tenant y snapshot completo del emisor. Cambiar el logo futuro nunca reescribirá un documento emitido.

## Documentos y almacenamiento

Se mantiene el principio: **el documento original nunca es sustituido por los datos estructurados extraídos**.

Hoy `documentos` almacena metadatos y una `rutaArchivo` obligatoria; no ingiere ni controla el archivo. La ruta puede romperse, revelar estructura local y no es portable. El backup excluye esos archivos. Fotografías son solo un tipo de documento.

```text
Tenant → entidad/Expediente → Documento
                             ├─ original inmutable
                             ├─ hash, tamaño, MIME y metadata
                             ├─ datos estructurados derivados/versionados
                             └─ storageObjectId abstracto
```

El proveedor de almacenamiento, bucket, carpeta y credenciales pertenecen al tenant. El dominio conserva un ID estable y abstracción de almacenamiento; rutas o URLs son detalles reemplazables. OCR/extracción guardará procedencia, versión, confianza y revisión humana sin sobrescribir el original.

## Backups y restauración

El backup es sólido para el producto local monoempresa: snapshot consistente, manifiesto versionado, hashes, validación, staging, restore recuperable e inclusión de PDFs emitidos en SQLite. Su unidad es toda `obraia.sqlite`; el manifiesto no identifica tenant y no incluye documentos externos.

En multi-tenancy se distinguirán:

- **backup técnico completo**, para recuperar servicio y todos los tenants, con acceso restringido;
- **exportación/backup de tenant**, autocontenido, autorizado, cifrado y sin filas ajenas;
- **restore de tenant**, con identidad, referencias, secuencias, configuración y documentos consistentes.

Nunca se restaurará un backup de tenant sobrescribiendo globalmente una base compartida. El restore parcial necesita mapeo de IDs, conflictos y auditoría. Backups cloud del proveedor no sustituyen exportación, retención ni recuperación verificada por tenant.

## Integraciones y solicitudes web

No se encontraron integraciones productivas, credenciales, correo, web ni OneDrive de Construcciones Tovar en el core. Toda integración futura será por tenant, con secreto fuera de SQLite cuando corresponda, permisos mínimos, rotación, estado, webhook validado y auditoría.

```text
Formulario del tenant → Solicitud tenant-scoped → posible Cliente
→ Expediente → originales/fotos → preguntas pendientes
→ propuesta de Presupuesto → revisión humana → envío → seguimiento
```

El tenant se resolverá desde un identificador confiable del canal (dominio, formulario o token), no desde un `tenantId` libre del navegador. Formularios, campos y workflow podrán variar por tenant, oficio y trabajo.

## Presupuestos, costes y aprendizaje

El presupuesto actual tiene partidas con cantidad, unidad y precio, pero no separa materiales, mano de obra, maquinaria, transportes, subcontratas, indirectos o beneficio. El motor heredado de piscinas incorpora mediciones y precios constantes globales en `lib/engines/pool_engine.dart` y `lib/database/precios.dart`.

El futuro motor usará catálogos, tarifas, reglas de margen e históricos del tenant; las plantillas por oficio se montarán sobre contratos del core. Un presupuesto aceptado será una versión congelada del plan económico, no una vista mutable de tarifas vivas. Al cierre, previsto/real y causas alimentarán aprendizaje privado. Conocimiento común futuro exigirá anonimización, autorización y garantías contra reconstrucción.

## Expediente como agregado central

La decisión actual es correcta: Expediente/Obra agrega navegación y resúmenes reales sin inventar rentabilidad. Sus relaciones actuales permiten crecer.

Limitaciones:

- solicitud, visitas, mediciones, contrato, anticipos, comunicaciones, trabajadores, maquinaria, incidencias, garantías y cierre no existen;
- factura se relaciona con expediente indirectamente por presupuesto, salvo snapshot;
- `timeline_events.referenciaId` no expresa tipo ni integridad;
- Compra solo admite una obra y no representa factura recibida ni pago;
- no hay versionado formal del presupuesto aceptado como plan base.

No se corrigen ahora. Las entidades futuras nacerán tenant-scoped sin convertir Expediente en objeto monolítico.

## UI, casos de uso e IA/voz

La dirección por repositorios es aprovechable, pero parte de la composición e IDs aún nace en pantallas, hay providers en `data/`, una pantalla lee `databaseProvider` y varios repositorios declaran providers Riverpod. IA/voz no automatizará widgets ni llamará DAOs.

```text
UI / Voz / Automatización
        ↓ comandos y consultas tipados
Casos de uso / servicios de aplicación
        ↓ autorización + tenant + validación + transacción
Repositorios de dominio
        ↓
DAOs / almacenamiento / integraciones
```

Cada acción relevante tendrá precondiciones, resultado tipado, idempotencia cuando proceda, auditoría y confirmación humana antes de emitir, pagar, borrar, restaurar, enviar o cambiar estados sensibles.

## Cloud, móvil y offline

Activos favorables: UUID, SQLite local, timestamps y documentos emitidos inmutables. Carencias: cuenta/tenant, protocolo de sincronización, revisión de fila, tombstones uniformes, UTC uniforme, conflictos, outbox/eventos y autoridad remota de secuencias.

Decisiones que deben fijarse ahora:

- UUID opacos como IDs de dominio, sin nuevos IDs autoincrementales.
- tiempos persistidos en UTC y reloj inyectable para operaciones nuevas.
- revisión y política de eliminación/sincronización antes de escritura multi-dispositivo.
- servidor como autoridad de permisos y numeración fiscal definitiva.
- documentos por objeto estable, no por ruta local.
- comandos idempotentes y outbox para efectos externos futuros.

No se prometerá edición offline conflictiva hasta definir por agregado qué puede fusionarse, bloquearse o es inmutable.

## Acoplamientos a Construcciones Tovar

| Hallazgo | Clasificación | Decisión |
|---|---|---|
| “Construcciones Tovar” en pruebas de Presupuestos y Facturas | Dato de prueba | Fixture legítima; usar nombres inequívocamente ficticios al tocar esas pruebas |
| Nombres/apellidos “Tovar” y “Áridos Tovar” en pruebas UI | Dato de prueba | No es configuración productiva ni dependencia del core |
| ID fijo `empresa_principal` y lectura `limit(1)` | Deuda arquitectónica importante | Sustituir por configuración tenant-scoped en P0 |
| `assets/images/logo_empresa.png` global | Acoplamiento crítico de branding; el nombre no prueba que la imagen sea de Tovar | Branding por tenant antes de comercialización; preservar PDFs históricos |
| Tarifas fijas y plantillas de piscinas | Deuda de producto multigremio | Futuro módulo/plantilla y tarifas del tenant; no llevar al core económico |
| `España`, IVA 21 y métodos de pago por defecto | Configuración legítima actual, no acoplamiento probado a Tovar | Hacer configurable al ampliar jurisdicciones; no cambiar reglas verificadas ahora |

No se encontraron en producción nombres, NIF/CIF, domicilios, teléfonos, emails, IBAN, web, rutas OneDrive, proveedores reales, credenciales ni automatizaciones identificables de Construcciones Tovar. URLs de paquetes/documentación no son acoplamientos empresariales.

## Clasificación por prioridad

### P0 — antes de Fase 3

1. Aprobar modelo mínimo `Tenant`, `TenantContext` y migración del tenant inicial.
2. Introducir `tenantId` en las 16 tablas, FKs/constraints compuestos e índices tenant-first mediante cambio de esquema completo, regenerado y probado.
3. Hacer tenant-scoped DAOs, repositorios, providers, búsqueda, dashboard, Timeline, configuración y transacciones.
4. Aislar FAC/RECT, familias, cobros, crédito y snapshots/PDF; demostrar concurrencia y rechazo de cruces.
5. Mantener el backup actual como backup completo local y definir identidad del tenant inicial; no ofrecer restore parcial sin diseño.
6. Probar lectura, escritura, relación y borrado cruzado con al menos dos tenants.

### P1 — durante el núcleo económico

- Casos de uso tenant-aware compartidos por UI y automatizaciones.
- Presupuesto aceptado versionado como plan; categorías, tarifas, indirectos y márgenes por tenant.
- Proveedor → Albarán → Obra → Factura recibida → Pago, conservando originales y reparto explícito.
- Catálogo/histórico de materiales y precios; previsto vs real y aprendizaje privado.
- Documento gestionado con original, hash, metadata, extracción y almacenamiento abstracto.
- Auditoría de actor, tenant y operación económica.

### P2 — cloud, móvil y comercialización

- Usuarios, membresías, roles/permisos, tenant activo y autenticación.
- Backend autoritativo, sincronización, revisiones, tombstones, conflictos, outbox e idempotencia.
- Almacenamiento e integraciones por tenant; secretos seguros.
- Backup/export/restore por tenant y recuperación cloud.
- Solicitudes web, comunicaciones, branding, plantillas y “qué toca ahora”.
- Módulos por oficio sin forks.

### P3 — largo plazo

- IA/voz sobre casos de uso seguros, explicables y con confirmación humana.
- Aprendizaje avanzado por obra y conocimiento común solo anonimizado y autorizado.
- Predicción de infravaloración, planificación y asistencia proactiva.
- Libros, IVA/IRPF, amortizaciones, previsión fiscal, tesorería e informes.

## Roadmap revisado

1. **P0-A — diseño ejecutable.** DDL objetivo, v22 → v23, backfill, constraints, `TenantContext`, consultas y pruebas.
2. **P0-B — persistencia.** Cambio de esquema, migración, regeneración y aislamiento/conservación en SQLite temporal.
3. **P0-C — accesos.** DAOs, repositorios, providers, búsqueda, dashboard, configuración y backup tenant-scoped.
4. **P0-D — fiscal.** FAC/RECT, snapshots, PDFs, cobros, crédito, rectificaciones y concurrencia con dos tenants.
5. **Fase 3.** Presupuesto aceptado como previsto; costes reales y métricas explicables por obra y tenant.
6. **Administración documental.** Albaranes, facturas recibidas, pagos, originales, extracción e histórico de precios.
7. **Operación y workflow.** Recursos, ejecución, incidencias, comunicaciones, garantías y “qué toca ahora”.
8. **Identidad, cloud y movilidad.** Membresías, backend, sincronización, offline, almacenamiento e integraciones.
9. **IA segura.** Voz/lenguaje natural sobre casos de uso, permisos, auditoría y confirmación.
10. **Comercialización.** Branding, módulos multigremio, onboarding, distribución y operación cloud.

## Recomendación exacta del siguiente incremento

P0-A está diseñado en `MULTI_TENANT_MIGRATION_PLAN.md`, sin implementación. El siguiente incremento propuesto es **P0-B — migración vertical segura multi-tenant v23**: esquema, backfill, constraints, contexto local mínimo y todos los accesos tenant-scoped deben aterrizar juntos para no dejar un estado intermedio inseguro. No incluye usuarios, selector multiempresa público, cloud, sincronización ni Fase 3.

# Estado actual de OBRA IA

**PROD-1 — implementado y verificado técnicamente:** entornos Desarrollo y Producción con SQLite físicamente distintas; la base actual conserva su ruta como Desarrollo. Producción nueva utiliza solo inicialización técnica neutral, con schema 32 y sin copia de datos funcionales. Backups separados y restauración cruzada bloqueada; selector confirmado e indicador visible. No se han introducido datos reales. PROD-2, piloto real y Fase 5 no iniciados. Análisis limpio, 17 pruebas específicas y 333 totales superadas; Windows debug compilado en copia aislada idéntica porque la sesión abierta bloqueaba la carpeta habitual. Procedimiento y aceptación manual pendiente en [PROD1_ENVIRONMENTS.md](PROD1_ENVIRONMENTS.md).

Fase 4 está completada técnicamente. 4-F consolida el Expediente como centro operativo diario sobre `schemaVersion` 32: cabecera con estado operativo/económico, recomendaciones destacadas, acciones rápidas, planificación, incidencias, diario, actividad reciente, suministros, economía y agregados administrativos canónicos. No se añaden fuentes de verdad ni reglas económicas. El siguiente hito es la **Puerta de entrada a producción / piloto real**, antes de Fase 5.

Fase 4-E está implementada técnicamente sin cambio de esquema. «Qué toca ahora» calcula recomendaciones deterministas, explicables y no persistidas a partir de Presupuestos, Planificación, Incidencias, Facturas/Cobros, Suministros y Economía. El motor puro no muta estados ni importes, no usa IA y mantiene separado el próximo paso manual. El Resumen muestra hasta cinco acciones prioritarias y permite navegar a su fuente.

Fase 4-D está implementada técnicamente sobre `schemaVersion` 32. El circuito Proveedor → Albarán → Obra → Factura recibida → Pago admite líneas, reparto multiobra, varios albaranes por factura y pagos parciales. Cada imputación se reconcilia explícitamente con una Compra y su único `hechos_coste`; el IVA recuperable no es coste y pagar no genera coste. La migración v31→v32 no inventa datos legacy. Los originales reutilizan Documentos; incorporar sus archivos físicos al backup sigue siendo deuda prioritaria.

Fase 4-C está implementada técnicamente sobre `schemaVersion` 31. Las fotografías y demás evidencias reutilizan exclusivamente `Documentos`; una incidencia profesional tenant-scoped puede vincular cero o varios documentos existentes y jornadas del Diario sin copiar archivos. Las incidencias mantienen fecha, título, descripción, prioridad, estado, resolución y timestamps; sus transiciones relevantes son atómicas con Timeline y no alteran economía ni estado operativo. La migración v30→v31 no inventa incidencias. Análisis, 305 pruebas y compilación Windows debug superan. El almacenamiento físico sigue dependiendo de rutas locales heredadas y el backup SQLite no incorpora todavía los archivos originales: esta deuda debe resolverse antes de una distribución o sincronización fiable. Fase 4-D no se ha iniciado.

Fase 4-B está implementada técnicamente sobre `schemaVersion` 30. Cada Expediente incorpora un Diario de obra tenant-scoped con fecha de trabajo, texto libre de trabajos, observaciones, meteorología manual, incidencia textual y actuación opcional. Las entradas se ordenan cronológicamente, admiten edición controlada y anulación lógica; creación y anulación son atómicas con Timeline. Las horas mostradas proceden exclusivamente de los partes de 3-D y el Diario no genera costes ni cambia estados. La migración v29→v30 no inventa entradas legacy. Análisis, 299 pruebas y compilación Windows debug superan. Fase 4-C no se ha iniciado.

Fase 4-A está implementada técnicamente sobre `schemaVersion` 29. El Expediente conserva su ciclo administrativo y añade un estado operativo independiente, calendario previsto/real opcional, próximo paso explícito y actuaciones ordenadas con estados pendiente/completada/cancelada. Toda persistencia nueva está aislada por tenant; los cambios operativos relevantes son atómicos con Timeline y no alteran el cierre económico. La migración v28→v29 deja el legacy en programación y no inventa fechas ni actuaciones.

Fase 3-G está implementada técnicamente sobre `schemaVersion` 28. Cada obra dispone de estado económico independiente, abierto por defecto, cierres con precheck centralizado y confirmación de advertencias, snapshots históricos inmutables y reaperturas con motivo. El cierre y la reapertura son atómicos con Timeline. Hechos de coste, compromisos, estimaciones y operaciones laborales rechazan cambios mientras la economía está cerrada. El centro económico muestra estado, alertas deterministas e historial. La migración v27→v28 no fabrica cierres legacy. Fase 3 queda técnicamente completa; Fase 4 no se ha iniciado.

Fase 3-F está implementada técnicamente sin cambio de esquema. El Expediente incorpora una pestaña «Economía» con lectura temporal del plan original, situación actual y previsión final; desviaciones globales; desglose por categorías; cobertura y alertas derivadas; resumen laboral; gestión de compromisos/estimaciones y navegación a las áreas operativas. El Resumen general conserva una versión compacta. Los widgets consumen la proyección económica de 3-E y no duplican fuentes ni fórmulas. `schemaVersion` permanece en 27 y Fase 3-G no se ha iniciado.

Fotografía verificada el **3 de septiembre de 2026**. Debe actualizarse cuando cambien de forma relevante el producto, la arquitectura, la persistencia o las prioridades. No sustituye a Git, al código ni a las pruebas.

## Base tecnológica

- Flutter/Dart con Riverpod.
- Drift sobre SQLite con `schemaVersion` 32. Las conexiones activan claves foráneas y todas las tablas empresariales exigen `tenantId`.
- `pdf` y `printing` para generación documental.
- Windows como plataforma prioritaria.
- 171 archivos Dart en la auditoría de esta línea base.

## Producto presente

Hay implementación para Expedientes, Clientes, Presupuestos, Facturas, Cobros, Compras, Proveedores, Certificaciones, Documentos, Timeline, Dashboard, Búsqueda y Configuración. También permanece un motor heredado de presupuestos de piscinas en `lib/screens`. La presencia de código no acredita por sí sola que una capacidad esté terminada o lista para producción.

La navegación real usa `MaterialApp`, `Navigator` y `MaterialPageRoute`. GoRouter figura en dependencias, pero no está implementado.

## Línea base verificada

- La edición principal de Expedientes permite cambiar código, nombre y cliente, o quitarlo, preservando los demás campos.
- El guardado y su evento único de Timeline son atómicos; ficha y listado se actualizan mediante streams.
- 8 pruebas específicas de Expedientes superadas sobre SQLite en memoria.
- Suite completa: 208 pruebas superadas.
- `flutter analyze --no-pub`: sin incidencias.
- `git diff --check`: sin errores en el cierre funcional; los avisos existentes corresponden a finales de línea de registradores generados.
- Toolchain Windows instalada y validada: Flutter 3.47.1 stable, Dart 3.13.1, Visual Studio Community 2026 18.9.2 y Windows SDK 10.0.26100.0.
- `flutter build windows --debug --no-pub`: compilación debug superada; ejecutable generado en `build\windows\x64\runner\Debug\obraia_v2.exe`.
- La compilación no produjo cambios accidentales en Git.

Flutter está instalado en `C:\src\flutter`, aunque no está incluido globalmente en `PATH`. Es una observación del entorno y no un bloqueo: la compilación es reproducible en este equipo invocando el ejecutable por su ruta completa. Los avisos de Android y Chrome no afectan a la plataforma prioritaria Windows.

Con análisis, pruebas y compilación Windows superados, Expedientes queda técnicamente validado y la fase 0 cumple sus comprobaciones técnicas. Esto no acredita todavía una versión publicable ni la existencia de un instalador.

## Fase actual

Fase 3-B está implementada técnicamente. Cada tenant dispone de categorías económicas neutrales y porcentaje configurable de indirectos; las líneas de presupuesto en borrador pueden registrar categoría y coste previsto interno sin contaminar el PDF comercial. La aceptación crea atómicamente con el cambio de estado y Timeline un plan económico inmutable y sus partidas congeladas. El plan distingue coste cero de coste desconocido mediante cobertura completa, parcial o sin costes, y solo publica coste total, beneficio y margen cuando los datos necesarios están completos.

Fase 3-C está implementada técnicamente sobre schema v25. `hechos_coste` es el ledger append-only y tenant-scoped del coste real: admite altas, reversiones y ajustes firmados, origen idempotente, categoría opcional y vínculos opcionales al plan/partida. Una Compra permanece provisional hasta confirmación explícita; entonces su base neta se registra atómicamente con clasificación y Timeline. Revertir o eliminar una Compra devengada añade el contramovimiento y nunca borra historia. Los estados manuales pendiente/pagada/anulada no determinan devengo y ninguna Compra legacy se convierte automáticamente.

Fase 3-D está implementada técnicamente sobre schema v26. Personas laborales, tarifas internas históricas y partes son tenant-scoped. Cada parte valorado congela tarifa y coste y genera un único `hechos_coste`; las horas sin tarifa permanecen explícitamente pendientes, sin coste cero ficticio, y pueden valorarse después usando la tarifa aplicable a la fecha del trabajo. La reversión conserva parte y alta originales y añade un contramovimiento. Los agregados separan horas valoradas y pendientes y declaran cobertura completa, parcial o sin valorar. Titular/autónomo y empleado generan coste económico, nunca nómina ni salida de caja automática.

Fase 3-E está implementada técnicamente sobre schema v27. Los compromisos registran coste futuro identificable, admiten ajustes y cancelación auditables y se consumen mediante aplicaciones explícitas contra `hechos_coste`; una reversión del hecho reabre el saldo sin borrar historia. Las estimaciones de coste restante son adicionales al coste real y al compromiso pendiente, conservan versiones y justificación. El forecast solo publica coste final, beneficio y margen cuando su cobertura es completa; desconocido nunca equivale a cero. Todas las operaciones escriben Timeline en la misma transacción y permanecen aisladas por tenant.

El esquema v24 añade categorías, configuración económica, costes previstos de borrador, planes y partidas de plan con claves compuestas e índices tenant-first. La migración v23 → v24 conserva los datos, inicializa categorías/configuración por tenant y no fabrica planes ni costes para presupuestos legacy. Backup/restauración y la copia preventiva admiten la nueva versión. Fase 3-C no se ha iniciado.

La verificación acumulada supera 259 pruebas, incluidas reglas económicas, aceptación/rollback, aislamiento, migraciones, backup y toda la regresión de Fase 2. `flutter analyze --no-pub`, `git diff --check` y `flutter build windows --debug --no-pub` también superan.

Fase 3-A está formalmente cerrada como diseño aprobado, no como implementación. `PHASE_3_ECONOMIC_MODEL.md` define la separación entre rentabilidad, facturación y tesorería; las magnitudes oficiales; el presupuesto aceptado como plan económico inmutable; hechos de coste; tarifa interna de mano de obra propia; indirectos sobre coste directo previsto; clasificación explícita de Compras por devengo; cierre/reapertura auditables; trazabilidad y una propuesta conceptual v23 → v24. No quedan decisiones de negocio bloqueantes para iniciar 3-B. No existen todavía nuevas tablas, migración v24, motor de rentabilidad ni interfaz económica.

La auditoría arquitectónica está en `MULTI_TENANT_ARCHITECTURE_AUDIT.md` y el diseño ejecutable v22 → v23 en `MULTI_TENANT_MIGRATION_PLAN.md`. La puerta P0 multi-tenant está cerrada: existe Tenant, el esquema v23 migra y backfillea v22 de forma transaccional, las relaciones críticas impiden cruces entre tenants y DAOs, repositorios, búsqueda, dashboard, configuración, numeraciones FAC/RECT y backup quedan aislados por un `TenantContext` obligatorio. El cambio de contexto invalida los providers tenant-scoped y Configuración admite una identidad independiente por tenant. Antes de migrar una base v22 se crea y valida una copia SQLite de recuperación sin sobrescritura. No existen aún selector público, usuarios, roles, autenticación, cloud ni sincronización. La implementación de Fase 3 ha comenzado exclusivamente con 3-B; costes reales y 3-C continúan sin iniciar.

La verificación final de P0 supera 241 pruebas, incluidas conservación v22 → v23 poblada y vacía, rollback por anomalía, contexto ausente, las 16 tablas empresariales, relaciones cross-tenant, cambio de contexto sin caché cruzada, configuración independiente, numeraciones FAC/RECT, concurrencia, búsqueda/dashboard y backup/restore con dos tenants. `flutter analyze --no-pub`, `git diff --check` y `flutter build windows --debug --no-pub` también superan.

La fase 1 está cerrada. Las restauraciones admiten los esquemas 16, 17, 18, 19, 20, 21 y 22, comprobados con integridad, relaciones, documentos emitidos, movimientos económicos y conservación de importes. Se rechazan versiones anteriores o futuras. La aceptación manual Windows con datos ficticios confirmó crear una copia, modificar un cliente y restaurar correctamente el estado anterior. Las pruebas automatizadas nunca tocaron datos reales.

La fase 2 está cerrada. Cliente → Expediente → Presupuesto → aceptación → facturación total o parcial → emisión → cobro y reversión conserva relaciones, importes, estados y Timeline. FAC y RECT emitidas son inmutables, guardan su PDF definitivo exacto con SHA-256 y mantienen numeración independiente y transaccional. Una FAC legacy sin PDF archivado se identifica como reconstrucción de consulta y nunca se presenta ni almacena como original. Las correcciones forman cadenas RECT por diferencias; la cancelación neutraliza el neto familiar mediante RECT sin borrar documentos ni cobros. El crédito derivado admite devolución, compensación entre familias fiscalmente compatibles y reversiones inmutables. IVA, redondeo a céntimos, asignaciones presupuestarias, concurrencia, rollback, migraciones 16–22 y backup/restauración están cubiertos con SQLite aislado.

Las aceptaciones manuales acumuladas confirmaron presupuestos aceptados y facturación parcial, la cadena real `FAC-2026-0004 → RECT-2026-0001 → RECT-2026-0002`, crédito de 121,00 € con devolución de 50,00 € y saldo de 71,00 €, exclusión de destinos fiscalmente incompatibles, y `FAC-2026-0006` con cobros de 500,00 € + 710,00 €, estado cobrada y reversión posterior de 710,00 € que dejó 500,00 € cobrados y 710,00 € pendientes. La incidencia visual de doble activación detectada durante esta última aceptación quedó corregida y cubierta por prueba widget.

## Rediseño profesional de interfaz

El primer incremento está implementado sobre una arquitectura desktop persistente: barra lateral agrupada y adaptable, cabecera de contexto, búsqueda global, actividad y configuración permanecen disponibles al cambiar de módulo. Inicio usa el dashboard real; Expedientes dispone de listado embebido, estados vacíos y ficha operativa por secciones. El tema activo se ha unificado sobre `core/ui` y el contenido se compacta para ventanas reducidas. Compras, Certificaciones y Documentos se anuncian en la navegación sin inventar datos y continúan operándose desde cada expediente. Cinco pruebas widget nuevas elevan la suite completa a 208.

Clientes es el segundo módulo migrado al patrón profesional. Dispone de listado desktop denso, búsqueda inmediata, estados de carga/error/vacío, ficha adaptable con datos de contacto y expedientes relacionados, alta y edición mediante un formulario compartido, prevención de doble guardado y eliminación confirmada. Desde la ficha se abre cada expediente dentro del shell y se puede iniciar un expediente nuevo con el cliente preseleccionado. La UI de Clientes consume providers de presentación y no accede directamente a la base de datos. Cuatro pruebas widget específicas elevan la suite completa a 212. Fase 2 permanece cerrada y Fase 3 no ha comenzado.

Presupuestos es el tercer módulo migrado al patrón profesional. Su vista global muestra todos los documentos con búsqueda, filtros por estados existentes, contexto de expediente/cliente y lectura densa de base, IVA y total. La ficha conserva las líneas, aceptación, PDF, eliminación protegida y el resumen validado de facturación parcial, añadiendo navegación directa a Expediente y Cliente. Tres pruebas widget elevan la suite a 215 sin cambiar reglas económicas. Fase 2 sigue cerrada y Fase 3 no ha comenzado.

Facturas es el cuarto módulo migrado al patrón profesional. El listado global diferencia FAC y RECT y reúne búsqueda, filtros, cliente, origen, fecha, vencimiento, total, cobrado, pendiente y estados documental/económico. La ficha presenta el documento emitido como congelado, mantiene líneas, PDF, familia rectificativa, crédito y acciones validadas, integra movimientos de cobro con saldo y permite navegar a Cliente, Expediente y Presupuesto. La emisión exige confirmación explícita y las operaciones sensibles tocadas evitan dobles activaciones. No se han modificado numeración, snapshots, PDF definitivo, reglas fiscales, cobros, rectificaciones ni crédito. Tres pruebas widget elevan la suite completa a 218. Fase 3 no ha comenzado.

Cobros es el quinto módulo migrado al patrón profesional. Su entrada global funciona como centro de seguimiento por facturas emitidas, con búsqueda, filtros de pendiente/parcial/cobrada/vencida, cliente, expediente, vencimiento, total, cobrado y pendiente obtenidos del resumen económico validado. El detalle conserva los movimientos auditables y diferencia cobros y reversiones; alta y reversión muestran contexto económico real y bloquean dobles envíos. La vista mensual del Dashboard permanece disponible. Tres pruebas widget elevan la suite completa a 221 sin cambiar reglas, persistencia ni estados. Fase 3 no ha comenzado.

Proveedores es el sexto módulo migrado al patrón profesional. Su directorio ofrece búsqueda inmediata por identidad fiscal, contacto y ubicación, contador y filas densas adaptables. La ficha organiza únicamente los datos fiscales, de contacto y observaciones existentes; alta y edición comparten formulario, bloquean dobles envíos y la eliminación lógica exige confirmación. La UI consume providers de presentación sin acceso directo a persistencia. Cinco pruebas widget elevan la suite completa a 226, sin introducir Compras, métricas económicas, relaciones ficticias ni cambios de esquema. Fase 3 no ha comenzado.

Compras es el séptimo módulo migrado al patrón profesional. Actualmente una Compra es un apunte de gasto ligado obligatoriamente a un único Expediente, con proveedor opcional y nombre histórico, fecha, número de factura opcional, concepto, base, porcentaje de IVA, total, estado manual y observaciones. El centro global permite buscar, filtrar y navegar; la ficha enlaza Proveedor y Expediente cuando siguen disponibles, y alta/edición comparten formulario protegido contra doble envío. No existen documentos originales, pagos trazables, vencimientos, albaranes, líneas ni reparto multiobra. Cinco pruebas widget elevan la suite completa a 231. Fase 3 no ha comenzado.

Expediente/Obra es el octavo incremento y actúa como centro operativo. Su resumen muestra importes de presupuestos, facturado, cobrado, pendiente y compras desde repositorios y estados económicos existentes, junto con recuentos reales de certificaciones, documentos, fotografías y Timeline. La cabecera conserva identidad, cliente y estado y permite abrir el Cliente; cada bloque lleva a la pestaña operativa correspondiente. No se muestran beneficio, margen, rentabilidad, desviaciones ni previsiones. Una prueba widget adicional eleva la suite a 232. Fase 3 no ha comenzado.

## Deuda y riesgos prioritarios

1. La cobertura continúa siendo desigual y aún se concentra principalmente en Facturas; el primer tramo de Presupuestos ya cuenta con pruebas de persistencia y atomicidad.
2. Persisten providers en `data/`, métodos heredados en `AppDatabase` y archivos grandes; los accesos directos de Presentation revisados quedan encapsulados en providers o coordinadores de infraestructura.
3. Las rectificativas sustitutivas y la integración de Certificaciones con las asignaciones parciales quedan aplazadas y no forman parte del alcance cerrado de Fase 2.
4. El futuro circuito administrativo de Compras sigue pendiente: albaranes, facturas recibidas con original documental, pagos, vencimientos, reparto multiobra, discrepancias, almacén, histórico de materiales/precios y automatización asistida. El registro actual no acredita por sí solo un pago ni sustituye el documento original.
5. El alta de Compra y su evento de Timeline aún no forman una única transacción atómica; esta deuda no se corrige en el incremento visual de Expediente.
6. Aún no se han verificado un instalador, firma, actualización ni reversión para una distribución publicable en Windows.

## Próximo hito

Realizar la aceptación manual posterior de PROD-1 según su procedimiento. PROD-2 permanece pendiente y no iniciado; no comenzar Fase 5 ni introducir datos reales.

# Estado actual de OBRA IA

Fotografía verificada el **3 de septiembre de 2026**. Debe actualizarse cuando cambien de forma relevante el producto, la arquitectura, la persistencia o las prioridades. No sustituye a Git, al código ni a las pruebas.

## Base tecnológica

- Flutter/Dart con Riverpod.
- Drift sobre SQLite; 17 tablas y `schemaVersion` 23. Las conexiones activan claves foráneas y las 16 tablas empresariales exigen `tenantId`.
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

Fase 3-A está formalmente cerrada como diseño aprobado, no como implementación. `PHASE_3_ECONOMIC_MODEL.md` define la separación entre rentabilidad, facturación y tesorería; las magnitudes oficiales; el presupuesto aceptado como plan económico inmutable; hechos de coste; tarifa interna de mano de obra propia; indirectos sobre coste directo previsto; clasificación explícita de Compras por devengo; cierre/reapertura auditables; trazabilidad y una propuesta conceptual v23 → v24. No quedan decisiones de negocio bloqueantes para iniciar 3-B. No existen todavía nuevas tablas, migración v24, motor de rentabilidad ni interfaz económica.

La auditoría arquitectónica está en `MULTI_TENANT_ARCHITECTURE_AUDIT.md` y el diseño ejecutable v22 → v23 en `MULTI_TENANT_MIGRATION_PLAN.md`. La puerta P0 multi-tenant está cerrada: existe Tenant, el esquema v23 migra y backfillea v22 de forma transaccional, las relaciones críticas impiden cruces entre tenants y DAOs, repositorios, búsqueda, dashboard, configuración, numeraciones FAC/RECT y backup quedan aislados por un `TenantContext` obligatorio. El cambio de contexto invalida los providers tenant-scoped y Configuración admite una identidad independiente por tenant. Antes de migrar una base v22 se crea y valida una copia SQLite de recuperación sin sobrescritura. No existen aún selector público, usuarios, roles, autenticación, cloud ni sincronización. La implementación de Fase 3 continúa sin comenzar.

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

Tras aceptar y publicar este diseño, el siguiente incremento recomendado es **Fase 3-B — plan económico y categorías**: implementar schema v24, snapshots inmutables del presupuesto aceptado y migración legacy segura. No iniciar aún costes reales, mano de obra, UI económica, usuarios, selector multiempresa, cloud ni sincronización.

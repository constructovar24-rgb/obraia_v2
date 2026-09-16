# PROD-6 — Piloto real controlado

## 1. Objetivo y alcance

Preparar la aceptación manual en **Desarrollo, exclusivamente con datos ficticios**, antes de autorizar un piloto con una empresa, un cliente y una obra. No se configura Producción durante esta entrega. No se importa histórico ni se inicia Fase 5.

Base auditada el 15 de septiembre de 2026: rama `main`; HEAD y referencia local `origin/main` en `7e000333077f8b143190fa7c42d066df0ab10ae7`; schemaVersion 36. Único cambio previo: `analysis_options.yaml`, SHA-256 `75d2d8ff5435cb5d89f2f36d0ae95dcefe6cbb6906f80616094905a33d957e50`, excluido. No se ha hecho fetch ni push.

## 2. Auditoría prepiloto, anterior a los cambios de código

La revisión contrasta UI, providers, repositorios, DAOs, esquema y pruebas; no inspecciona ninguna base empresarial existente. **Correcto** significa protección técnica identificada, pendiente de la verificación de esta entrega; **Atención** exige control operativo; **Bloqueante** impide el paso indicado. No es una certificación legal ni fiscal.

Clases: **A**, bloqueante o protección mínima imprescindible; **B**, importante compatible con el piloto limitado y sus controles; **C**, mejora futura.

| # | Área | Resultado inicial y evidencia del repositorio | Clase / condición |
| --- | --- | --- | --- |
| 1 | Arranque limpio PROD | `AppDatabase.onCreate` crea tenant neutral y categorías, sin datos comerciales; `environment_test.dart` comprueba tablas vacías. | Correcto; no abrir PROD en esta aceptación. |
| 2 | Empresa/tenant | Configuración por tenant; sin copia de DEV. El nombre técnico «Empresa inicial» no sustituye la identidad documental de Configuración. | B / revisar identidad guardada y PDF. |
| 3 | Datos fiscales | Emisión exige nombre y NIF/CIF, pero no valida exhaustivamente identidad, domicilio ni situación tributaria. | B / completar y revisar con gestoría antes de factura real; ese paso queda bloqueado sin revisión. |
| 4 | Números de presupuestos | `PresupuestosDao` y protección documental: referencia por tenant, creación transaccional, no reutilización y rechazo de ambigüedad; pruebas PROD-2. | Correcto; no renumerar históricos. |
| 5 | Configuración fiscal | `ConfiguracionFiscalRepository`: preparación explícita por año/tipo, consecutivo atómico, colisiones, rollback y bloqueo tras uso. | Correcto; continuidad externa pendiente de revisión humana. |
| 6 | Clientes | DAO filtra tenant; formulario y edición protegida. No hay deduplicación universal del directorio. | B / buscar antes de dar de alta. |
| 7 | Expedientes | Cliente canónico, edición transaccional con Timeline, relaciones por tenant; pruebas de edición y aislamiento. | Correcto; usar código inequívoco de piloto. |
| 8 | Presupuestos | Partidas y totales en céntimos coherentes, borrador y PDF diferenciados; `PresupuestoDocumentalRepository`. | Correcto; revisar costes internos y cobertura. |
| 9 | Aceptación | Transacción de snapshot/PDF/hash, plan, estado y Timeline; triggers impiden cambios posteriores. | Correcto; nueva propuesta para cambios. |
| 10 | Planificación | Estado operativo separado del económico, fechas validadas, actuaciones y Timeline; pruebas de repositorio/UI. | Correcto. |
| 11 | Diario | Entradas por obra/tenant, edición y anulación; las horas proceden de partes, no generan costes duplicados. | B / la edición no conserva un historial completo de versiones. |
| 12 | Fotos/documentos | `DocumentoRepository` y `ManagedDocumentStore`: copia, tamaño real, hash, rechazo de vacíos, exportación e históricos externos señalados. | Correcto para originales gestionados; B para rutas externas. |
| 13 | Proveedores | Directorio por tenant; búsqueda y baja lógica. | B / comprobar identidad y evitar altas duplicadas. |
| 14 | Albaranes | Líneas/reparto por obra; no devengan coste por sí solos. Repositorio admite vínculos documentales; UI básica de alta. | B / registrar original en Documentos y referencia cruzada; no asumir enlace automático. |
| 15 | Facturas recibidas | Borrador/consolidación, original relacionado, sustitución, abono, normalización de duplicados; pruebas PROD-4. | Correcto; revisar transcripción y asignación antes de consolidar. |
| 16 | Pagos | No verificado distinto de pendiente; pagos parciales, límite de saldo, reversión con motivo e historial. | Correcto; no ejecuta movimientos bancarios. |
| 17 | Costes reales | `HechoCosteRepository` y reconciliación de proveedor: un origen confirmado, reversiones e idempotencia; el pago no crea coste. | Correcto; no volver a crear una compra por la misma factura. |
| 18 | Facturación a clientes | Presupuesto prioriza `cliente.empresa`; `FacturaRepository.emitirFactura` y PDF borrador usan nombre/apellidos. Un contacto puede quedar como destinatario de la factura empresarial. | **A / bloqueante encontrado: unificar identidad en documentos nuevos.** |
| 19 | Cobros | Repositorio transaccional, importes/saldo y reversiones protegidos; pruebas de atomicidad, parciales y crédito. | Correcto; registrar cobro efectivo una sola vez. |
| 20 | Rentabilidad | Plan aceptado, `hechos_coste`, previsión y cierre; cobertura desconocida no se convierte en cero. | Correcto; B / no interpretar margen incompleto como beneficio definitivo. |
| 21 | Backup | Paquete v2 valida SQLite, relaciones e inventario/hash de originales; falla ante original ausente o alterado. | B / copia externa y revisión diaria obligatorias. |
| 22 | Restore | Staging, recuperación, intercambio/rollback, rechazo de entorno y tenants distintos. El diálogo no explica que también retroceden contadores fiscales. | **A / protección mínima: advertencia y reconocimiento antes de restaurar.** No resuelve continuidad externa automáticamente. |
| 23 | DEV/PROD | Rutas SQLite/documentos/backups distintas, perfil explícito y sesión invalidada; pruebas de cambio/rollback. | Correcto; una sola sesión de trabajo. |
| 24 | Multi-tenant | Consultas y relaciones compuestas; pruebas de aislamiento, cachés y backup de todos los tenants. | B / no es autorización: sin usuarios, roles ni selector multiempresa público. |
| 25 | Trazabilidad | Timeline, eventos fiscales/proveedor y snapshots; actor local sin identidad autenticada ni sello externo. | B / conservar evidencia externa; no equivale a auditoría inviolable. |
| 26 | Duplicidad | Secuencias, aceptación, factura recibida normalizada y reconciliación protegidas. Directorios, documentos y compras independientes pueden duplicarse. | B / búsqueda y cotejo antes de registrar; una sola base escritora. |
| 27 | Riesgos fiscales | Una copia antigua o bases paralelas pueden reutilizar números; destinatario empresarial incoherente identificado en #18. | A para #18 y protección #22; revisión con gestoría antes de emitir y después de recuperar. |
| 28 | Riesgos documentales | Externos/logos fuera del paquete, límites de tamaño, copias en mismo disco, recuperación en equipo nuevo asistida. | B / mantener archivo actual y backup externo; STOP si no se puede recuperar. |

### Decisión sobre diagnóstico dentro de Configuración

No se implementa una pantalla nueva. El indicador de entorno, Configuración de empresa, Numeración fiscal, «Comprobar archivo» y una copia manual completa ya permiten comprobar el circuito. Crear un backup ejercita escritura y validación de SQLite y de todos los originales gestionados; restaurarlo en prueba verifica la recuperación. Una luz verde general no comprobaría identidad fiscal, continuidad fuera de OBRA IA, permisos futuros, copia externa o recuperación tras pérdida del equipo. Se priorizan el manual y las dos protecciones concretas anteriores. Un diagnóstico persistente y comprobaciones programadas quedan en C.

### Qué está listo y qué no

Hay implementación y pruebas para el circuito limitado de obra, documentos, compras, facturación, cobros y economía. El estado final de verificación se recoge al final de este documento. La aceptación manual PROD-6 y la autorización real siguen pendientes.

No están incluidos: importación masiva/Excel, sustitución de gestoría, libros o declaraciones tributarias completos, certificación de un régimen fiscal, sincronización multi-PC, usuarios/roles, copia externa automática, instalador de producción ni recuperación autónoma en un equipo nuevo. No se requiere desarrollar esos módulos para este piloto paralelo. Sí se exige detener el paso afectado si los sistemas paralelos o las comprobaciones no pueden cubrir el riesgo.

## 3. Cambios mínimos de PROD-6

1. **Destinatario documental coherente.** Presupuesto y factura nueva usan la razón social de «Empresa» cuando está informada; en otro caso, nombre y apellidos. La emisión congela esa identidad y las rectificativas conservan la de la factura raíz. Los documentos históricos y sus bytes no se reescriben. La identidad vacía sigue bloqueando sin consumir número. El provider del repositorio de facturas y la composición consumidora de Dashboard/Búsqueda viven en `presentation/providers`; los repositorios de `data` no dependen de presentación.
2. **Confirmación de recuperación.** Tras validar la copia, el diálogo explica el retroceso de contadores y la posible ausencia de facturas/cobros/pagos posteriores. «Restaurar copia» permanece deshabilitado hasta reconocer el riesgo. Cancelar no restaura. Cada nueva apertura vuelve a exigir reconocimiento. Es una protección de interfaz: no persiste un bloqueo fiscal después de restaurar ni acredita continuidad.
3. **Manual y criterios de aceptación.** Recorrido acotado con evidencias y condiciones de parada. Sin migración, renumeración, nuevos módulos ni cambios de importes.

No se implementan diagnóstico general, deduplicación universal, importaciones, conciliación bancaria, fiscalidad nueva, multiempresa pública, servicios externos ni sincronización. La falta de validación exhaustiva de domicilio/identidad fiscal se controla mediante revisión obligatoria de datos y PDF. La factura actual utiliza el logo de la aplicación, no el logo configurable del presupuesto; no atribuirle personalización que no tiene. La factura usa una página: mantener pocas líneas en el piloto; si un documento no cabe o falla su PDF, detener su emisión y solicitar revisión.

## 4. Sistemas que deben continuar en paralelo

- **Excel actual:** control de clientes, proveedores, documentos, pagos/cobros y seguimiento económico. Registrar en una hoja de control la referencia OBRA IA y la referencia externa.
- **Archivo documental/OneDrive actual:** originales recibidos y copias exactas de presupuestos aceptados y facturas emitidas. La sincronización no sustituye una copia verificable independiente.
- **Gestoría:** revisar identidad, domicilio, ejercicio, series, continuidad y tratamiento aplicable antes de la primera emisión real. No emitir dos veces la misma operación desde herramientas distintas.
- **Una sola instalación escritora:** no trabajar en paralelo con duplicados de SQLite ni con una misma serie en varios equipos. Los backups se archivan, no se convierten en otra base operativa.

## 5. Aceptación manual PROD-6 — SOLO DESARROLLO

### Preparación y evidencias

No se ha ejecutado esta aceptación durante el desarrollo. Debe realizarla el usuario después de revisar el informe.

1. Cerrar otras sesiones de OBRA IA. Abrir el ejecutable verificado indicado en el informe. Confirmar **Entorno: Desarrollo**. Si aparece Producción, no introducir datos ni continuar.
2. Utilizar una sesión de Desarrollo que contenga exclusivamente datos ficticios. Si no puede garantizarse, detenerse y solicitar una sesión de prueba aislada; no vaciar bases existentes.
3. Anotar fecha, versión/HEAD probado, operador y resultados en una hoja «Aceptación PROD-6». Registrar cada paso como Correcto, Incidencia o No ejecutado. No marcar GO con pasos obligatorios sin comprobar.
4. **Configuración → Copias de seguridad → Crear copia de seguridad**: esperar éxito y anotar la ruta. Copiar el archivo .obraia-backup a una ubicación externa segura. Si falla, STOP; no borrar referencias para conseguir una copia válida.
5. Elegir un sufijo único, por ejemplo P6-01; si existe, usar P6-02. Crear una carpeta propia de documentos ficticios. Con Bloc de notas, guardar P6-01-original.txt con «Original ficticio PROD-6, versión A», y P6-01-FR-001.txt con «Factura de proveedor FICTICIA: base 400, IVA 84, total 484». No usar escaneos empresariales.
6. En **Configuración**, anotar la configuración ficticia previa antes de cambiarla. Guardar «EMISOR PILOTO P6-01», CIF de prueba B00000000, dirección «Calle Ficticia 1», CP 28000, población/provincia Madrid y correo piloto@example.invalid. No usar datos reales. Mantener un logo ficticio legible o dejarlo vacío anotando el valor previo.

### Cliente, obra y presupuesto

7. **Clientes → Nuevo cliente**: «Nombre / razón social»: Contacto P6-01; «Apellidos»: Ficticio; «Empresa»: CLIENTE PILOTO P6-01 SL; «NIF / CIF»: B00000000; domicilio ficticio «Calle Prueba 2, 28000 Madrid». Guardar, buscar y abrir ficha. El contacto difiere deliberadamente de la razón social.
8. **Expedientes → Nuevo expediente**: código P6-01, nombre «Obra ficticia piloto P6-01», cliente recién creado. Guardar y comprobar relación en **Cliente**. No reutilizar obras existentes.
9. En la obra, **Presupuestos**: crear borrador y anotar referencia automática. No escribir una numeración fiscal aquí.
10. **Añadir línea**: concepto «Trabajo ficticio piloto», unidad ud, cantidad 1, precio unitario 1000. IVA de prueba del 21 %. Esperado: base **1.000,00 €**, IVA **210,00 €**, total **1.210,00 €**. Si el IVA es otro, ajustarlo en borrador.
11. Opcionalmente informar «Coste interno previsto» de esa línea como 400 €. Si no se informa o faltan indirectos, la cobertura debe señalarlo; no forzar cifras para obtener un margen.
12. **Ver PDF borrador**: comprobar emisor ficticio, destinatario **CLIENTE PILOTO P6-01 SL**, NIF, domicilio, obra, referencia y totales. El contacto no debe sustituir al destinatario empresarial.
13. **Aceptar presupuesto**: confirmar congelación; comprobar estado aceptado y ausencia de edición de partidas. **Ver PDF definitivo**: guardar copia y reabrirla. Revisar plan económico y **Timeline**.

### Documentos y operación

14. **Documentos → Nuevo documento**: seleccionar P6-01-original.txt, título «Original ficticio P6-01», tipo Otro. Debe indicar **Protegido por OBRA IA**. **Comprobar archivo**: **Integridad correcta**. **Guardar copia del original** en destino nuevo y abrirlo.
15. Editar únicamente el archivo fuente ficticio con Bloc de notas para que diga «versión B». Repetir comprobación/exportación del documento incorporado: debe conservar «versión A». Si se incorpora B como otro documento, ambos mantienen su contenido. No modificar archivos internos de OBRA IA.
16. Intentar incorporar un archivo ficticio de cero bytes: debe rechazarlo sin crear documento. No borrar históricos.
17. **Planificación**: definir próximo paso «Visita ficticia P6-01», editar calendario con inicio anterior a fin y crear una actuación. Una fecha de fin anterior al inicio no debe guardarse. Marcar actuación completada; revisar Timeline y que no cambien facturas ni cobros.
18. **Diario de obra → Nueva entrada**: fecha del día, trabajos «Replanteo ficticio P6-01», observación de prueba. Guardar, salir y volver: una sola entrada. El diario no añade costes laborales. No registrar partes de mano de obra en este ejemplo numérico.

### Proveedor, albarán, factura recibida y pago

19. **Proveedores → Nuevo proveedor**: crear «PROVEEDOR FICTICIO P6-01», NIF y contacto ficticios; buscar antes de guardar.
20. En la obra, **Compras / Suministros → Albaranes → Albarán**: proveedor creado, referencia P6-01-ALB-001, descripción «Material ficticio», cantidad 1. Guardar y comprobar vínculo con obra. No debe generar coste real por sí solo.
21. En **Documentos**, incorporar P6-01-FR-001.txt, título «P6-01-FR-001 · proveedor ficticio · obra P6-01», y comprobar integridad. La UI básica no enlaza automáticamente ese original con factura/albarán: mantener referencia común en título y hoja de control. Si no puede identificarse inequívocamente, no consolidar.
22. **Compras / Suministros → Facturas recibidas**, alta mediante +: elegir proveedor, número P6-01-FR-001, fecha de prueba, base 400, IVA 84. Aparece en borrador, inicialmente sin obra. El listado puede mostrar otras obras del tenant: localizar referencia exacta.
23. Expandir ficha → **Cambiar imputación** → seleccionar obra P6-01. Revisar base 400 € y destino antes de **Consolidar**, motivo «Registro ficticio comprobado P6-01». Esperado: total **484 €**, coste real de obra **400 €** en Economía. No crear una Compra independiente por ese documento.
24. Intentar segunda alta del mismo proveedor/año/número: debe bloquearse sin duplicar factura ni coste. Cancelar el alta fallida.
25. Pago **No verificado**: revisar justificante ficticio, **Verificar estado de pago**, motivo «Sin pagos anteriores, prueba ficticia P6-01». **Registrar pago**: 200 €, fecha, medio y referencia ficticios. Esperado: pagado **200 €**, saldo **284 €**, coste real **400 €**.
26. Intentar pagar otros 300 €: debe rechazarlo por superar el saldo, sin movimiento. Revisar historial. No hacer transferencias reales.

### Numeración, primera factura ficticia y cobro

27. **Configuración → Numeración fiscal**: cargar el ejercicio de la factura. Si ya tiene series preparadas/usadas, **conservarlas** y anotar el próximo número; no cambiar ni reiniciar configuraciones. Si está libre, series P6DEMO y P6RECT, inicio 1 en ambas.
28. Solo si el ejercicio está libre: **Guardar sin preparar**, crear el borrador del paso siguiente e intentar emitir. Debe bloquearse sin número. Volver a configuración, **Preparar numeración**, cancelar y comprobar que sigue sin preparar; después confirmar. Con series previamente preparadas, registrar «No aplica: configuración ya usada»; el bloqueo está cubierto por regresiones de PROD-3.
29. Desde presupuesto aceptado → **Crear factura parcial**: seleccionar cantidad completa (1) y crear borrador. Revisar base 1.000 €, IVA 210 €, total 1.210 €, cliente y vínculo presupuesto/obra. Fecha y ejercicio deben coincidir.
30. Abrir PDF borrador: destinatario **CLIENTE PILOTO P6-01 SL**. En la factura, **Emitir factura**: revisar entorno, ejercicio, serie y próximo número antes de confirmar. Anotar referencia final. Próximo ordinario avanza una unidad; rectificativo no cambia.
31. Abrir/guardar PDF emitido y verificar razón social, NIF, domicilio, referencias e importes. Cerrar/reabrir ficha y PDF. Editar solo el cliente ficticio: «Empresa» = CLIENTE PILOTO P6-01 MODIFICADO SL. Presupuesto aceptado y factura emitida conservan el nombre anterior. Devolver ese campo del cliente a su valor inicial.
32. Desde factura, registrar **Cobro** ficticio de 500 €, fecha y referencia P6-01-COBRO-001. Esperado: cobrado **500 €**, pendiente **710 €**. Intentar otro de 800 €: debe bloquearse sin movimiento. No emitir otra factura por el cobro.
33. **Economía**: distinguir facturación/cobros, y comprobar que pagar al proveedor no aumentó el coste. Sin otros costes, confirmado **400 €**. La previsión puede seguir incompleta; **1.210 − 200 no es el beneficio**. Revisar Timeline y referencias.

### Recuperación y cierre

34. Crear **nueva copia completa después de factura, cobro y pago**. Anotar referencias, próximos números, importes, documentos y texto del diario. Copiarla fuera del equipo; conservar también la inicial. Para el ensayo usar esta reciente, no la inicial antigua.
35. Hasta restaurar, no registrar ninguna otra factura, rectificativa, cobro, pago, documento ni trabajo ajeno. Cambiar únicamente la observación del diario ficticio a «Cambio posterior a copia P6-01».
36. **Configuración → Copias de seguridad → Restaurar copia de seguridad**: seleccionar copia del paso 34. Leer cobertura y aviso. **Restaurar copia** debe estar deshabilitado sin marcar casilla. **Cancelar**: sigue la observación modificada.
37. Repetir selección, marcar/desmarcar reconocimiento: el botón vuelve a bloquearse. Marcar y confirmar solo tras comprobar que no existen cambios ajenos al ensayo. Esperar; no cerrar el proceso mientras restaura.
38. Volver a obra: observación anterior recuperada, PDF definitivos y originales íntegros, factura/cobro/pago, costes y próximos números iguales a los anotados. Saldos: cliente **710 €**, proveedor **284 €**. Reabrir aplicación y confirmar **Desarrollo** y datos iguales.
39. No modificar contadores. Si número/documento no coincide, STOP aunque la copia figure restaurada. En este ensayo no debe faltar operación fiscal: la copia se tomó después de todas ellas.
40. Crear copia final y guardar evidencias. No borrar facturas ni restaurar la copia inicial para «limpiar». Si se cambió configuración ficticia en paso 6, devolver solo campos al valor anotado al finalizar; nunca deshacer series usadas.
41. Entregar hoja de resultados con referencias, importes, backup, fecha y reapertura. **GO de aceptación manual** solo con pasos aplicables correctos y sin bloqueantes. Todavía no autoriza configurar Producción.

## 6. Checklist posterior — SOLO TRAS AUTORIZACIÓN REAL EXPRESA

Este apartado no se ejecuta durante PROD-6. No utilizarlo como prueba con datos reales.

### Preparación de Producción

- [ ] Aceptación anterior aprobada y autorización explícita. Responsable designado y único equipo/instalación escritora.
- [ ] Validar con gestoría identidad, domicilio, NIF, tratamiento fiscal, ejercicio, series e inicio, contrastados con último documento real de todos los sistemas. Caso no soportado: STOP antes de emitir.
- [ ] Disco disponible y copia externa independiente. Mantener archivo actual. Designar responsable de copia diaria y recuperación.
- [ ] Crear/verificar backup de Desarrollo antes de cambiar: protege DEV, no es semilla de PROD.
- [ ] **Configuración → Cambiar entorno → Producción → Confirmar cambio**. Confirmar indicador y listados vacíos esperados. Si hay registros, detener y revisar origen; nunca borrar para vaciar.
- [ ] Antes de configurar o crear registros, generar **backup inicial de Producción neutral** y conservar fuera del equipo. No restaurar DEV en PROD. Cerrar/reabrir y comprobar entorno.
- [ ] Configurar identidad empresarial real autorizada. Guardar, salir y volver a revisar; tenant técnico y nombre impreso son distintos.
- [ ] En Numeración fiscal configurar ejercicio y ambos circuitos según lo validado con gestoría. Revisar/confirmar preparación y anotar próximas referencias. No crear facturas «de prueba» en PROD.
- [ ] Copia completa posterior a configuración; conservar ambas. Sin copia, identidad, escritura o numeración verificables, no comenzar la obra.

### Flujo de la primera obra real

1. Buscar/dar de alta **un cliente** con identidad y domicilio comprobados. Para empresa, revisar «Empresa» como razón social y distinguir contacto.
2. Crear **un expediente/obra** con referencia inequívoca y cliente correcto.
3. Crear **un presupuesto** de pocas partidas. Revisar mediciones, precios, IVA y condiciones contra oferta autorizada. Los importes ficticios anteriores no son valores por defecto.
4. Revisar PDF borrador, obtener aceptación comercial por medio habitual, conservarla externamente y confirmar aceptación en OBRA IA. Exportar/verificar definitivo.
5. Incorporar originales en Documentos y comprobar integridad. Si un histórico externo debe protegerse, incorporar copia como nuevo documento conservando la referencia anterior.
6. Planificar y registrar diario. Usar partes para coste laboral; no inventar horas ni confundir diario con coste.
7. Introducir progresivamente proveedor, albaranes y recibidas. Conservar originales y referencias cruzadas; comprobar destino/base/IVA/duplicados antes de consolidar. No duplicar costes en Compras.
8. Verificar justificantes antes de marcar pago conocido y registrar pagos efectivos; cotejar costes/saldos en paralelo.
9. Copia al finalizar cada jornada y antes de cualquier recuperación.

### Primera factura real, posterior al arranque

1. Autorizar específicamente facturación real tras comprobar obra/documentación iniciales.
2. Reconfirmar continuidad y adecuación del caso con gestoría. Completar datos y revisar borrador; los campos mínimos no validan toda la fiscalidad.
3. Desde presupuesto aceptado, facturar partidas/cantidades procedentes, comparando disponible, base, IVA y total con evidencia externa.
4. Revisar emisor, destinatario, domicilio, fecha, referencia prevista y PDF completo. Con desbordamiento o datos incorrectos, no emitir.
5. Copia previa; confirmar emisión una vez. Anotar referencia final y conservar PDF exacto externamente. Comunicarlo por circuito habitual; esta entrega no envía documentos.
6. Comprobar avance de una unidad y concordancia externa. La hoja paralela referencia la misma factura, no emite otra.
7. Cuando exista cobro efectivo, registrar una vez fecha/importe/medio/justificante. Comprobar pendiente y que no cambia coste. Copia posterior.
8. Error después de emitir: conservar original, detener caso y revisar circuito de rectificación. No improvisar corrección histórica ni ajustar contadores.

## 7. Backups y controles diarios/semanales

**Cobertura:** todas las empresas del entorno, SQLite, PDF congelados y originales gestionados, incluidos eliminados lógicamente. Excluye referencias externas, logos y archivos ajenos a Documentos. «Protegido» no equivale a verificación continua: usar «Comprobar archivo».

**Límites:** 100 MiB por original; paquete/contenido total 512 MiB; manifest 1 MiB; 1000 entradas contando DB y manifest; compresión 500:1. Revisar antes de incorporar fotos masivamente.

**Diariamente:**

- Confirmar entorno/empresa; una sola instalación escritora.
- Cotejar referencias, base/IVA, pagos/cobros y documentos con Excel y justificantes.
- Comprobar originales nuevos; conservar PDF exactos externamente.
- **Copia manual al terminar**, esperar éxito, anotar ruta/fecha y copiar fuera del equipo. La automática se intenta al inicializar el controlador de backups, como máximo una al día con retención de 7. No es un servicio programado que cubra el trabajo posterior de la jornada.
- Para validar el archivo externo sin restaurar, seleccionarlo con «Restaurar copia de seguridad»: alcanzar el diálogo de cobertura acredita validación técnica del paquete; después **Cancelar**. No demuestra recuperación en un equipo nuevo.
- Fallo de backup/originales: STOP. Conservar copias anteriores válidas.

**Semanalmente:**

- Revisar coste único por origen/obra, pagos desconocidos, pendientes, gastos sin asignar y cobertura económica.
- Comparar series/referencias con archivo externo; no ajustar números manualmente.
- Ensayar recuperación asistida y aislada con la misma identidad de tenant. No usar la sesión real para ejercicios rutinarios.
- Registrar discrepancias y resolución. Conservar copias semanales según política de empresa; OBRA IA no administra esa retención externa.

## 8. Criterios STOP y procedimiento ante incidencia

**Detener el paso afectado** ante entorno/empresa inesperado, duplicidad, destinatario/importes incorrectos, diferencia con archivo externo, original ausente/alterado, error de copia/restore, saldo inexplicable, coste duplicado, PDF incompleto, permisos/disco insuficientes o pérdida del equipo.

1. No reintentar repetidamente emisión/pago/cobro: comprobar antes si se registró.
2. Anotar hora, entorno, referencia, acción, mensaje y captura; no borrar ni editar para ocultar el problema.
3. Suspender escrituras. Si puede crearse copia completa, conservarla; si falla, no manipular SQLite/originales. Pedir asistencia conservando instalación y archivos.
4. Continuar provisionalmente en Excel, archivo y gestoría. Anotar desde qué referencia/hora y quién autoriza. No emitir desde dos sistemas con la misma secuencia sin coordinación.
5. Diagnóstico técnico; decidir corrección o recuperación de copia validada. Restore afecta a todo el entorno, no solo a una obra.
6. Antes de restaurar, conservar estado y copias e identificar operaciones posteriores. Después, cotejar documentos/justificantes/importes/secuencias.
7. **No reanudar emisiones si faltan facturas posteriores.** Backup no cancela esas facturas. Gestoría/soporte deben validar continuidad y recuperación compatible. Esta versión no ofrece ajuste manual seguro de contador ni conciliación fiscal automática.
8. Reincorporar trabajo paralelo uno a uno tras revisar duplicados; no importar Excel completo.
9. Documentar causa/solución y repetir aceptación del paso antes de levantar STOP.

Reversibilidad operativa significa volver al sistema paralelo y recuperar información, no deshacer documentos enviados ni movimientos bancarios.

## 9. Criterios de piloto superado y qué viene después

El responsable debe confirmar por escrito, con evidencias:

- Empresa/cliente/obra completan presupuesto aceptado, originales recuperables, planificación/diario y un circuito proveedor con coste/pago conciliado.
- Primera factura/cobro cotejados externamente, continuidad sin duplicados.
- Rentabilidad y pendientes explicables; cobertura incompleta reconocida.
- Controles diarios y al menos una revisión semanal; copia externa validada y ensayo de recuperación asistido.
- Sin incidencias A abiertas; cada B documentada con responsable y medida operativa aceptada.
- Usuario y gestoría aceptan alcance realmente probado. Compilación correcta no sustituye aceptación.

Después: autorizar por separado ampliación gradual a otra obra/circuito según lo aprendido. Fase 5, importación histórica, distribución y nuevas funciones requieren sus propias entregas; PROD-6 no las inicia.

## 10. Resultado de la aceptación manual en Desarrollo

**GO confirmado por el usuario el 2026-09-16**, exclusivamente para PROD-6 en Desarrollo y con la aplicación cerrada al finalizar.

- La asignación inicial de la factura recibida permitió consolidarla.
- P6-01-FR-003: registrada por 484,00 €; 200,00 € pagados; 284,00 € pendientes; un único coste real de 400,00 €.
- P6DEMO-2026-0001: emitida por 1.210,00 €; 500,00 € cobrados; 710,00 € pendientes.
- El PDF congelado conservó los datos históricos y mostró el logotipo configurado de Construcciones Tovar.
- Los duplicados de números y los movimientos que superaban saldos quedaron bloqueados.
- Los documentos gestionados mantuvieron su integridad.
- La restauración recuperó datos, documentos y numeración fiscal; tras cerrar y reabrir, los datos permanecieron correctos.
- Backup final: `obraia-1789585288035.obraia-backup`, conservado también en OneDrive.

Este resultado no acredita ni autoriza Producción, datos reales, despliegue, commit o push. El checklist de la sección 6 continúa sujeto a una autorización real independiente.

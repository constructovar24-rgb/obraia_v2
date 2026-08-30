# Registro de cambios

## No publicado

### Crédito de cliente

- Añadido el agregado económico derivado por familia FAC/RECT con pendiente, liquidado, crédito generado, dispuesto y disponible normalizados a céntimos.
- Incorporadas devoluciones y compensaciones inmutables, reversiones parciales auditables, Timeline en origen/destino y acciones desde la ficha de factura.
- Las compensaciones solo vinculan familias del mismo cliente fiscal, liquidan la deuda destino sin crear cobros bancarios y respetan concurrencia transaccional.
- Nuevos cobros, reversiones y cambios rectificativos quedan protegidos por el neto familiar y el crédito ya dispuesto.
- Elevado el esquema a v22; migraciones 16–21 crean movimientos vacíos sin inventar crédito histórico y backup/restauración conserva sus relaciones.
- Corregido el selector de compensaciones para excluir facturas con NIF histórico diferente o incompleto usando la misma identidad fiscal que la validación final.

### Facturas rectificativas por diferencias

- Mostrados en cada ficha el documento padre inmediato y todas sus rectificativas hijas directas, con navegación, estado y efecto económico.
- Permitida desde la ficha la creación de una nueva rectificativa sobre otra rectificativa emitida, conservando documento inmediato, raíz y efectos acumulados.
- Corregida la emisión ordinaria para exigir y congelar nombre/NIF del cliente y nombre/CIF de la empresa, evitando que una factura nueva quede erróneamente inhabilitada para rectificar.
- Incorporada la serie legal independiente `RECT-AAAA-NNNN`, asignada atómicamente al emitir.
- Añadidas cadenas inmutables original–rectificativas, motivo obligatorio y efectos firmados de base, IVA, total, partidas y cantidades.
- Integrados el neto presupuestario, el crédito pendiente sin falsa liquidación y la protección de cobros existentes.
- Conservado el PDF rectificativo exacto en SQLite con SHA-256 y eventos específicos de Timeline.
- Elevado el esquema a v21 con migraciones y restauración verificable desde los esquemas 16 a 20.

### Facturación parcial

- Añadidas facturas parciales acumulativas por porcentaje, importe y selección de partidas o cantidades.
- Los borradores reservan base y cantidades; eliminación y anulación liberan el disponible conforme al estado documental.
- Incorporada trazabilidad mediante asignaciones por línea, resumen reactivo y listado de múltiples facturas por presupuesto.
- Elevado el esquema a v20 con migraciones desde 16, 17, 18 y 19 y estrategia conservadora para facturas legacy.
- Corregido el refresco de número, PDF, cobros y cabecera inmediatamente después de emitir.

### Copias de seguridad

- Definida la estrategia segura de backup y restauración de SQLite.
- Incorporado un primer servicio aislado de snapshot consistente mediante `VACUUM INTO`.
- Añadidas 3 pruebas con bases temporales para consistencia, rollback, integridad y protección del destino.
- Implementado el contenedor manual `.obraia-backup` de formato 1 con manifiesto versionado, inventario, tamaños y SHA-256.
- La copia solo se publica tras reabrir y validar el archivo; se rechazan destinos existentes, corrupción, formatos futuros, rutas peligrosas, relaciones huérfanas y límites excedidos.
- Añadidas 7 pruebas temporales del contenedor; ninguna accede a la base real.
- Incorporada la preparación de restauraciones en staging, conservando separadas la copia original y la migrada.
- Verificada la migración 16→17 con conservación de datos e importes y el rechazo de copias truncadas, esquemas futuros, tablas ausentes, relaciones rotas y migraciones fallidas.
- Añadidas 7 pruebas temporales de preparación de restauración; todavía no se sustituye la base activa.
- Añadido el intercambio recuperable de una base preparada, incluyendo `-wal` y `-shm`, renombrados en el volumen activo y rollback ante fallos.
- Incorporados fallos inyectados en cada etapa; un fallo de recuperación conserva los archivos apartados para intervención posterior.
- Añadidas 9 pruebas temporales del intercambio; el mecanismo todavía no está conectado a la base real ni a la interfaz.
- Incorporado el backup automático de recuperación con nombre no sensible, validación completa y retención de las tres copias más recientes.
- La retención reconoce únicamente copias automáticas gestionadas y nunca elimina backups manuales ni archivos ajenos.
- Añadidas 4 pruebas temporales del backup automático; todavía no está conectado al ciclo de restauración real.
- Añadido `DatabaseLifecycleController` como propietario único de la instancia activa y publicación reactiva tras una reapertura válida.
- Añadido `BackupRestoreCoordinator`, que integra validación, staging, backup de recuperación, intercambio, rollback y reapertura sin widgets.
- Añadidas 4 pruebas temporales de restauración completa, incluidos publicación, fallo previo, rollback y exclusión mutua.
- Añadida la pantalla de Copias de seguridad en Configuración, con creación manual, selector de restauración, confirmación reforzada y mensajes recuperables.
- Añadidas copias automáticas diarias con retención de siete y sin eliminación de copias manuales.

### Expedientes

- Añadida la edición segura de código, nombre y cliente desde la ficha.
- La ficha y el listado reciben las actualizaciones mediante streams reactivos.
- El guardado conserva los demás datos y registra un único evento de Timeline dentro de la misma transacción.
- Añadido tratamiento explícito de errores, doble guardado y desaparición concurrente de expediente o cliente.
- Incorporadas 8 pruebas específicas con SQLite en memoria.

### Calidad y documentación

- Línea base comprobada con `flutter analyze --no-pub` limpio y 134 pruebas superadas.
- Compilación debug de Windows repetida correctamente después de integrar el contenedor de backup.
- Toolchain Windows validada con Visual Studio Community 2026 18.9.2 y Windows SDK 10.0.26100.0.
- Compilación debug para Windows completada correctamente con `flutter build windows --debug --no-pub`.
- Añadidas instrucciones persistentes para agentes y actualizada la documentación de producto, arquitectura, estado y planificación.

## [0.1.0] - 2026-07-24

### Añadido

- Base inicial del proyecto Flutter.
- Módulo Expedientes con persistencia local.
- Módulo Clientes con entidad, tabla Drift, DAO y pantallas de gestión.
- Motor de cálculo de presupuestos para piscinas.

### Cambios

- Inicio de la documentación técnica y funcional de OBRA IA v3.

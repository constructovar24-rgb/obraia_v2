# PROD-6 — Informe de entrega técnica

Fecha: 15 de septiembre de 2026. Trabajo realizado en C:\dev\obraia_v2.
Encargo original leído íntegramente; auditoría anterior a modificaciones de código.

## 1. Veredicto

**GO técnico para la aceptación manual de PROD-6 en Desarrollo.**
**NO-GO para comenzar aún el piloto real:** falta aceptación del usuario y autorización expresa para configurar Producción, revisión previa con gestoría y comprobación operativa de las copias externas.

No se presenta la aceptación manual como ejecutada ni se certifica cumplimiento fiscal.

## 2. Auditoría prepiloto

Los 28 puntos, evidencia, clasificación A/B/C y medidas operativas están en [la matriz de auditoría](PROD6_PILOTO_REAL.md#2-auditoría-prepiloto-anterior-a-los-cambios-de-código).

Se verificaron arranque/entornos/tenant, configuración, numeraciones, clientes/obras, presupuesto/aceptación, operación, documentos, proveedores/albaranes/recibidas/pagos, coste, facturación/cobros/rentabilidad, backup/restore y riesgos transversales. La suite cubre regresiones de esas áreas con bases ficticias en memoria o temporales.

## 3. Bloqueantes encontrados

- **A1, identidad empresarial:** presupuesto usa razón social y factura usaba contacto; un documento nuevo podía congelar destinatario incoherente. Corregido.
- **A2, protección mínima de recuperación:** el diálogo no explicaba retroceso de contadores ni operaciones posteriores ausentes. Añadidos aviso y reconocimiento. El riesgo de continuidad externa se mitiga mediante procedimiento STOP; no queda resuelto automáticamente.

Son condiciones previas al uso real la revisión fiscal humana y la recuperabilidad externa. No se dan por satisfechas con pruebas de código.

## 4. Qué se implementó y por qué

- Nombre documental común en Cliente, usado por presupuesto, PDF borrador y emisión de factura. Mantiene snapshots y originales emitidos; rectificativas heredan la identidad histórica.
- Confirmación de restauración desplazable con reconocimiento inicial desmarcado, botón bloqueado hasta marcar y cancelación disponible.
- Manual operativo completo y adaptación del provider de facturas a presentación al tocar ese repositorio. Los demás consumidores solo ajustan importaciones.
- Siete pruebas nuevas para esas protecciones; no se añadieron pruebas de módulos futuros.

## 5. Qué no se implementó

Sin nuevos módulos, importadores, deduplicador general, fiscalidad externa, roles, sincronización, instalación de servicios, limpieza histórica, ajustes de contadores, migración ni GoRouter. No se ha iniciado Fase 5. Se mantienen los controles paralelos del piloto.

## 6. HEAD inicial/final

Ambos: **7e000333077f8b143190fa7c42d066df0ab10ae7**. Rama main.

Los cambios de esta entrega permanecen en el árbol de trabajo; el binario verificado incluye esos cambios aunque HEAD siga en la base inicial.

## 7. origin/main

Referencia local comprobada al inicio y al final: **7e000333077f8b143190fa7c42d066df0ab10ae7**.
No se ha hecho fetch ni se afirma haber consultado de nuevo el servidor remoto.

## 8. Commits

**Ninguno.** Índice sin archivos preparados. Sin push ni reescritura de commits publicados.

## 9. Esquema final

**schemaVersion 36**, igual al inicial. Sin cambios de tablas, triggers, migraciones ni código Drift generado.

## 10. Cambios principales

Documentos nuevos con destinatario coherente; conservación histórica; reconocimiento del riesgo antes de restaurar; auditoría y procedimientos. Ningún cambio en cálculos monetarios, reglas de cobro/pago, asignación de números o motor de restauración.

## 11. Health check

**No implementado.** Se reutilizan controles existentes: entorno visible, empresa, Numeración fiscal, Comprobar archivo y backup completo validado. Una pantalla verde no demostraría identidad fiscal, continuidad externa, copia off-device ni recuperación tras pérdida del equipo. Decisión y alcance en el manual.

## 12. Archivos principales

- lib/features/clientes/domain/cliente.dart
- lib/features/presupuestos/data/presupuesto_documental_repository.dart
- lib/features/facturas/data/factura_repository.dart
- lib/features/facturas/services/factura_pdf_service.dart
- lib/features/facturas/presentation/providers/factura_providers.dart
- lib/features/dashboard/presentation/providers/dashboard_providers.dart
- lib/features/search/presentation/providers/search_providers.dart
- lib/features/backup/presentation/screens/backup_screen.dart
- lib/features/backup/presentation/widgets/backup_restore_confirmation.dart
- test/features/facturas/data/prod6_identidad_documental_test.dart
- test/features/backup/presentation/backup_restore_confirmation_test.dart
- docs/PROD6_PILOTO_REAL.md y este informe.
- docs/CURRENT_STATE.md, docs/MASTER_PLAN.md y docs/CHANGELOG.md.

Las restantes modificaciones Dart son adaptación de imports del provider, con formato exigido de los archivos tocados. La composición heredada de Dashboard/Search se trasladó a sus respectivos `presentation/providers`, de modo que ningún repositorio de `data` depende de presentación, sin iniciar una limpieza arquitectónica global.

## 13. Pruebas específicas PROD-6

**7/7 superadas:**

- Empresa con contacto distinto: presupuesto, FAC y RECT coherentes.
- Empresa sin contacto: emisión con razón social.
- Persona sin empresa: nombre/apellidos.
- Identidad vacía tras crear borrador: rechazo sin consumir contador ni PDF.
- Cancelar restore: devuelve false, reconocimiento no preaceptado.
- Marcar/desmarcar/confirmar/reabrir: bloqueo y reinicio correctos.
- Ventana 640 × 480: desplazamiento, cancelación y ausencia de overflow.

Comando (Flutter instalado en C:\src\flutter):

~~~powershell
& 'C:\src\flutter\bin\flutter.bat' test --no-pub test/features/facturas/data/prod6_identidad_documental_test.dart test/features/backup/presentation/backup_restore_confirmation_test.dart --reporter expanded
~~~

Durante preparación se corrigió un tipo de fixture (fila Drift frente al modelo de dominio); la repetición pasó. Los PDF ficticios de borrador/emitida se extrajeron/renderizaron con PDFium local: razón social presente, contacto ausente y una página legible sin solapamientos. Se conservan como evidencia local en build/prod6-pdf-review. El logo mostrado es el asset preexistente de la aplicación; no se configuró una empresa real para generarlos.

## 14. Suite completa y regresiones

**456/456 superadas en la última ejecución**, posterior al formato final; salida 0, 1 min 28 s. Incluye las 449 previas y las 7 nuevas.

~~~powershell
& 'C:\src\flutter\bin\flutter.bat' test --no-pub --reporter expanded
~~~

Evidencia local: build/prod6-suite-final.log. Incluye entornos, configuración fiscal, presupuestos, facturación/rectificativas, proveedores, documentos, backup/restore/migraciones, economía y aislamiento multi-tenant.

Los avisos existentes de Helvetica y de múltiples instancias de Drift en pruebas no provocaron fallos. No se han ocultado ni cambiado reglas de análisis para silenciarlos.

## 15. Análisis y formato

- **flutter analyze --no-pub: No issues found**, salida 0.
- Formato de **23 archivos Dart propios**, última comprobación con --output=none --set-exit-if-changed: 0 cambios.
- Se corrigieron imports que quedaron sin uso al mover el provider y tres avisos de estilo de las pruebas nuevas.
- analysis_options.yaml no se formateó ni modificó.

## 16. Compilación Windows

**flutter build windows --debug --no-pub: correcta**, salida 0; 69,4 s.

Compilación en build/prod6-verification, dentro del repositorio. Se copiaron y compararon **368 archivos de entrada**, idénticos antes y después de compilar. No se copió analysis_options.yaml. No se ha ejecutado el binario ni abierto bases existentes.

Ejecutable para la aceptación:
[obraia_v2.exe](../build/prod6-verification/build/windows/x64/runner/Debug/obraia_v2.exe)

Ruta completa: C:\dev\obraia_v2\build\prod6-verification\build\windows\x64\runner\Debug\obraia_v2.exe.

Evidencia: build/prod6-windows-build.log y build/prod6-build-files.txt.
Es un debug verificado, no un instalador de Producción.

### Compilación posterior a la corrección del bloqueante

El 2026-09-16 se generó un nuevo Windows debug aislado que incluye la distinción entre asignación inicial de borrador y reimputación posterior. Ruta: `C:\dev\obraia_v2\build\prod6-blocker-verification-20260916\build\windows\x64\runner\Debug\obraia_v2.exe`. Marca de compilación local: `2026-09-16 16:03:56 +02:00`; SHA-256: `42766FEDFAE55E2FAC61BFC1EBAB4A84C6954B3D9E01E8C10F25EAD3DFBF1013`.

La copia excluyó `analysis_options.yaml`, `.git` y cualquier build anterior. No contenía bases SQLite. Tras compilar, 366 archivos de entrada relevantes coincidieron byte a byte con el árbol fuente y se confirmó la presencia de la corrección. El ejecutable no se inició.

### Compilación posterior a la corrección del logotipo

`FacturaPdfService` resuelve el logotipo desde `empresaConfiguracion.logoPath` para FAC y RECT. Sin ruta conserva `assets/images/logo_empresa.png`; con ruta exige que el archivo sea legible y una imagen PNG/JPEG válida. Un fallo se comunica de forma explícita y revierte la emisión completa, incluido estado, numeración y PDF congelado.

Verificación: cinco pruebas del servicio para selección exacta, fallback e imagen inválida; una regresión transaccional de factura; 35 pruebas relacionadas; suite completa de 461 pruebas y analyze sin incidencias. Schema 36 sin cambios.

Windows debug aislado: `C:\dev\obraia_v2\build\prod6-logo-verification-20260916\build\windows\x64\runner\Debug\obraia_v2.exe`. Marca local: `2026-09-16 19:12:35 +02:00`. SHA-256: `FABC55D7643A001A77701EFA00D68287BE8DF13E213EF4FB825F67AE861D3BF5`. Se compararon 366 entradas sin diferencias; la copia no contenía bases ni `analysis_options.yaml` y el ejecutable no se inició. P6-01 continúa en borrador.

## 17. Revisión de diff

**git diff --check: correcto.** Revisión de los cambios y de archivos nuevos, relaciones, conservación histórica, cancelación y secuencia de restore. Sin acceso nuevo de UI a DAO/Drift/SQLite/databaseProvider. Los repositorios de Facturas, Dashboard y Búsqueda no dependen de Riverpod ni de presentación; su composición reside en `presentation/providers`. No se modificó el algoritmo de numeración ni el de backup.

Los avisos de conversión LF/CRLF de Git no son errores de diff.

## 18. Git final

Salida de git status --short; analysis_options.yaml es el único cambio previo, todos los demás pertenecen a esta entrega:

~~~text
 M analysis_options.yaml
 M docs/CHANGELOG.md
 M docs/CURRENT_STATE.md
 M docs/MASTER_PLAN.md
 M lib/core/services/pdf/pdf_document_helper.dart
 M lib/features/backup/presentation/screens/backup_screen.dart
 M lib/features/circuito_proveedor/data/correcciones_proveedor.dart
 M lib/features/clientes/domain/cliente.dart
 M lib/features/cobros/presentation/screens/cobros_screen.dart
 M lib/features/cobros/presentation/screens/nuevo_cobro_screen.dart
 M lib/features/dashboard/data/dashboard_repository.dart
 M lib/features/dashboard/presentation/screens/dashboard_screen.dart
 M lib/features/expedientes/presentation/providers/expediente_workspace_providers.dart
 M lib/features/facturas/data/factura_repository.dart
 M lib/features/facturas/data/rectificativa_repository.dart
 M lib/features/facturas/presentation/screens/editar_factura_screen.dart
 M lib/features/facturas/presentation/screens/factura_pdf_preview_screen.dart
 M lib/features/facturas/presentation/screens/facturas_screen.dart
 M lib/features/facturas/presentation/screens/nueva_factura_screen.dart
 M lib/features/facturas/presentation/screens/nueva_rectificativa_screen.dart
 M lib/features/facturas/presentation/widgets/facturas_tab.dart
 M lib/features/facturas/services/factura_pdf_service.dart
 M lib/features/presupuestos/data/presupuesto_documental_repository.dart
 M lib/features/search/data/search_repository.dart
 M lib/features/search/presentation/screens/search_screen.dart
 M test/database/multi_tenant_isolation_test.dart
 M test/features/circuito_proveedor/data/correcciones_proveedor_test.dart
 M test/features/cobros/presentation/cobros_ui_test.dart
 M test/features/facturas/presentation/facturas_ui_test.dart
 M test/features/facturas/services/factura_pdf_service_test.dart
?? docs/PROD6_INFORME.md
?? docs/PROD6_PILOTO_REAL.md
?? lib/features/backup/presentation/widgets/
?? lib/features/dashboard/presentation/providers/
?? lib/features/facturas/presentation/providers/factura_providers.dart
?? lib/features/search/presentation/providers/
?? test/features/backup/presentation/
?? test/features/facturas/data/prod6_identidad_documental_test.dart
~~~

## 19. analysis_options.yaml preservado

SHA-256 inicial y final idéntico:

75d2d8ff5435cb5d89f2f36d0ae95dcefe6cbb6906f80616094905a33d957e50

No tocado, restaurado, formateado, preparado para commit ni incluido en la entrega.

## 20. Riesgos, límites y bloqueos pendientes

- Aceptación manual PROD-6 superada en Desarrollo según confirmación del usuario. Sin GO de Producción ni de operación con datos reales.
- Identidad/domicilio/tratamiento fiscal requieren revisión humana; los campos mínimos no acreditan cumplimiento de un régimen fiscal.
- Restore no bloquea persistentemente nuevas emisiones; seguir STOP y cotejo con gestoría/soporte si faltan documentos posteriores. Nunca ajustar contadores ni operar copias simultáneas.
- Copias externas y recuperación en un equipo nuevo requieren procedimiento asistido; no tratar OBRA IA como archivo único.
- Históricos externos/logos fuera del backup; límites de volumen y factura de una página.
- Directorios y compras independientes no tienen deduplicación universal; el enlace documental de albarán/recibida desde la UI básica requiere referencias cruzadas manuales.
- Auditoría local sin identidad autenticada ni protección contra manipulación externa.
- No quedan verificaciones técnicas obligatorias bloqueadas. El primer intento restringido de Flutter no arrancó; se canceló y se ejecutó con permiso para la caché. Python no estaba disponible; la revisión PDF se completó con PDFium existente, sin instalar dependencias.
- No se validó una instalación limpia en otro equipo ni una sesión real de Producción: quedan fuera de esta entrega.

## 21. Datos y Producción

No se han abierto ni modificado las bases actuales de Desarrollo/Producción. No se han introducido datos empresariales reales, configurado Producción ni enviado documentos. Pruebas con registros ficticios, SQLite en memoria/temporales y assets ya incluidos en el proyecto.

## 22. Fase 5

**NO iniciada.** Sin migración a GoRouter ni refactorización global. La extracción del provider de facturas se limita al repositorio afectado y a las referencias necesarias.

## 23. Aceptación manual exacta en Desarrollo

Seguir los **41 pasos de la sección 5** de [PROD6_PILOTO_REAL.md](PROD6_PILOTO_REAL.md#5-aceptación-manual-prod-6--solo-desarrollo), empezando por el ejecutable del punto 16 y confirmando Desarrollo. Incluye copias, configuración ficticia, cliente/obra/presupuesto, documentos, operación, proveedor, factura/cobro, conservación de PDF y restauración controlada.

El backup de recuperación del ensayo se tomó **después** de las operaciones fiscales. La aceptación fue completada por el usuario en Desarrollo el 2026-09-16: P6-01-FR-003 quedó registrada por 484,00 €, con 200,00 € pagados, 284,00 € pendientes y un único coste real de 400,00 €; P6DEMO-2026-0001 quedó emitida por 1.210,00 €, con 500,00 € cobrados y 710,00 € pendientes. Se verificaron PDF histórico con logotipo configurado, bloqueos de duplicados y excesos, integridad documental, restore de datos/documentos/numeración y persistencia tras reapertura. Backup final `obraia-1789585288035.obraia-backup`, guardado también en OneDrive. La aplicación DEV quedó cerrada.

## 24. Checklist real posterior, separado

Solo tras autorización expresa: [sección 6 del manual](PROD6_PILOTO_REAL.md#6-checklist-posterior--solo-tras-autorización-real-expresa). Cubre backup inicial neutral, primera entrada en Producción, identidad y numeración revisadas, primera obra y posterior primera factura/cobro.

Siguiente paso recomendado: conservar las evidencias y el backup final. No configurar Producción, desplegar, hacer commit o push sin una autorización independiente y explícita.

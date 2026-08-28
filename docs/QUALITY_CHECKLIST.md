# Checklist de calidad

Marca únicamente lo comprobado. Usa “No aplica” con una razón breve; no marques como superada una verificación bloqueada.

## Estado inicial y Git

- [ ] Leídos `AGENTS.md`, `CURRENT_STATE.md` y documentos relevantes.
- [ ] Ejecutado `git status --short --branch` antes de editar.
- [ ] Identificados y preservados los cambios previos del usuario.
- [ ] Alcance y criterio de aceptación concretos.

## Arquitectura

- [ ] Flujo respetado: `Presentation → Providers → Repositories → DAOs → Drift → SQLite`.
- [ ] La UI no accede a `databaseProvider`, DAOs, Drift ni SQLite.
- [ ] Providers situados en `presentation/providers`.
- [ ] Repositorios sin Riverpod, widgets ni `BuildContext`.
- [ ] Sin refactorización global ni migración incidental a GoRouter.

## Código

- [ ] Cambio pequeño, cohesivo y sin archivos generados editados a mano.
- [ ] Manejo explícito de errores, nulos, carga y estados vacíos.
- [ ] Sin duplicación evitable ni APIs públicas alteradas sin necesidad.
- [ ] Pruebas añadidas o actualizadas para el comportamiento cambiado.

## Drift y protección de datos

- [ ] Pruebas con base en memoria o copia temporal; datos reales intactos.
- [ ] Operaciones relacionadas son atómicas mediante transacción.
- [ ] Si cambia el esquema: `schemaVersion` aumentado, migración compatible, código regenerado, prueba desde versiones anteriores y conservación de datos demostrada.
- [ ] Archivado conserva datos y relaciones y puede distinguirse de la eliminación.
- [ ] Eliminación tiene política explícita, comprueba dependencias y evita huérfanos.
- [ ] Restauración recupera un estado consistente.

## Reglas económicas del ERP

- [ ] Base imponible, IVA y total usan una fuente de verdad coherente.
- [ ] IVA (tipo, cuota, exención si aplica) se conserva en documentos que deban quedar congelados.
- [ ] Importes negativos, cero, descuentos y cantidades decimales tienen una política comprobada.
- [ ] Redondeo y precisión se aplican en un punto definido y son consistentes entre UI, persistencia y PDF.
- [ ] Estados documentales permiten solo transiciones válidas y protegen documentos emitidos/aceptados/cobrados.
- [ ] Cobros, facturas y sus estados económicos se actualizan atómicamente.
- [ ] Anulación conserva trazabilidad; no equivale a borrar ni reescribir silenciosamente un documento histórico.

## Experiencia de usuario

- [ ] Acciones destructivas o irreversibles requieren confirmación clara.
- [ ] Mensajes explican el resultado y permiten recuperarse de errores.
- [ ] Formularios validan antes de guardar y evitan dobles envíos.
- [ ] Navegación, foco, teclado y tamaños funcionan en Windows.
- [ ] Textos, fechas, moneda y estados son comprensibles y consistentes.

## Análisis, pruebas y compilación

- [ ] Formato aplicado solo a archivos propios.
- [ ] `flutter analyze --no-pub` ejecutado y resultado registrado.
- [ ] Pruebas específicas ejecutadas.
- [ ] Suite completa ejecutada si afecta código compartido, importes o persistencia.
- [ ] Compilación Windows ejecutada cuando corresponde.
- [ ] Toda comprobación omitida o bloqueada está declarada con su motivo.

## Revisión del diff

- [ ] Revisión independiente del comportamiento, regresiones y seguridad de datos.
- [ ] `git diff --check` sin errores.
- [ ] El diff contiene solo la entrega prevista.
- [ ] No se incluyeron secretos, rutas personales, logs ni artefactos temporales.

## Entrega final

- [ ] Ejecutado `git status --short` y separados cambios propios y previos.
- [ ] Informados resultado, archivos, verificaciones, bloqueos y riesgos.
- [ ] Indicado un siguiente paso pequeño y concreto.
- [ ] Sin commit, `push`, publicación ni despliegue no solicitados.

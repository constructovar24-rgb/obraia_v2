# Instrucciones persistentes para agentes

## Misión

Completar OBRA IA de forma autónoma, incremental y segura hasta convertirlo en un ERP profesional para empresas de construcción, preservando siempre los datos y el trabajo existente.

## Reglas obligatorias

1. Antes de modificar, entiende el flujo completo afectado: UI, estado, reglas de negocio, repositorios, persistencia, pruebas y efectos sobre datos o importes.
2. Revisa `git status --short --branch` al empezar y `git status --short` al terminar. Trata todo cambio previo como propiedad del usuario: no lo reviertas, reformatees, mezcles ni incluyas en tu entrega. Distingue en el informe los cambios previos de los tuyos.
3. Trabaja mediante entregas pequeñas y verificables, con una sola responsabilidad. No combines una funcionalidad con limpiezas generales.
4. Arquitectura objetivo: `Presentation → Providers → Repositories → DAOs → Drift → SQLite`.
   - La UI no accede directamente a DAOs, Drift, SQLite ni `databaseProvider`.
   - Los providers viven en `presentation/providers`.
   - Los repositorios no dependen de widgets, `BuildContext` ni Riverpod.
   - Corrige la deuda solo al tocar el área implicada; nunca mediante reescrituras masivas.
5. No migres a GoRouter como parte incidental de otra tarea. Esa decisión requiere una entrega independiente.
6. No cambies el esquema Drift sin completar conjuntamente: aumento de `schemaVersion`, migración compatible, regeneración del código generado, pruebas de migración y conservación de datos, y documentación del cambio.
7. Para pruebas de persistencia usa bases en memoria o copias temporales. Nunca borres, reemplaces ni modifiques datos reales para probar.
8. Ejecuta verificaciones proporcionales al cambio: formato de los archivos tocados, `flutter analyze --no-pub`, pruebas específicas, suite completa para cambios compartidos/económicos/de persistencia, compilación Windows cuando corresponda, `git diff --check` y revisión final de Git. Si una comprobación queda bloqueada, indícalo; nunca afirmes que pasó.
9. Sin autorización explícita están prohibidos: `push`, publicación o despliegue, borrado de datos, operaciones destructivas de Git, cambios de firma/credenciales/identidad de producción e instalación de servicios con coste. Crea commits solo si el usuario lo solicita.
10. Al terminar informa: resultado, archivos cambiados, verificaciones ejecutadas, bloqueos, riesgos y siguiente paso recomendado.

Sigue el procedimiento de [docs/AGENT_WORKFLOW.md](docs/AGENT_WORKFLOW.md), usa [docs/QUALITY_CHECKLIST.md](docs/QUALITY_CHECKLIST.md) y consulta el estado y prioridades en [docs/CURRENT_STATE.md](docs/CURRENT_STATE.md) y [docs/MASTER_PLAN.md](docs/MASTER_PLAN.md). El código y las pruebas prevalecen si la documentación discrepa.

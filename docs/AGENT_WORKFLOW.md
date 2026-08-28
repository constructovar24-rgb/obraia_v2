# Flujo de trabajo del agente

Este procedimiento desarrolla las reglas obligatorias de `AGENTS.md`. Debe aplicarse a cada entrega sin ampliar su alcance de forma oportunista.

## 1. Entender

- Lee la petición, `AGENTS.md`, `CURRENT_STATE.md` y la documentación relevante.
- Ejecuta `git status --short --branch` e identifica cambios previos del usuario.
- Recorre el flujo afectado de extremo a extremo y localiza reglas, persistencia, consumidores y pruebas.
- Contrasta la documentación con el código y las pruebas. Registra discrepancias; no las corrijas fuera del alcance.

## 2. Diseñar una entrega pequeña

- Define un resultado observable, una sola responsabilidad y un criterio de aceptación verificable.
- Limita los archivos y capas afectados. Separa refactorizaciones, migraciones y cambios de navegación si no son imprescindibles.
- Identifica antes de implementar los riesgos para datos, importes, compatibilidad y trabajo local.
- Si una decisión funcional puede cambiar datos, impuestos, totales, estados o documentos emitidos y no hay evidencia suficiente, detente y solicita una decisión de negocio clara. No inventes la regla.

## 3. Implementar

- Respeta la arquitectura objetivo y las convenciones del área.
- Conserva compatibilidad y datos. Haz cambios mínimos y reversibles.
- Añade o ajusta pruebas que demuestren el comportamiento, especialmente para reglas económicas y persistencia.
- No edites archivos ajenos a la entrega ni cambios locales del usuario. Si hay solapamiento inevitable, detente y explica el conflicto.

## 4. Revisar como revisor independiente

Relee el diff como si perteneciera a otra persona. Busca errores lógicos, regresiones, accesos entre capas, estados imposibles, pérdida de datos, cálculos monetarios incorrectos, problemas de concurrencia/atomicidad, UX confusa y pruebas insuficientes. Corrige solo lo incluido en la entrega.

## 5. Verificar

- Ejecuta la sección aplicable de `QUALITY_CHECKLIST.md` y las verificaciones proporcionales de `AGENTS.md`.
- Usa datos de prueba aislados. No abras ni alteres la base real para validar.
- Ante un fallo, determina si lo causa la entrega. Corrige los fallos propios.
- Si es un fallo preexistente y no relacionado, no amplíes el alcance: conserva evidencia reproducible, indica el comando y separa claramente ese fallo del resultado de la entrega.
- Si el entorno bloquea una comprobación, prueba alternativas seguras dentro del alcance y documenta exactamente qué no pudo verificarse y por qué. No sustituyas una verificación omitida por una afirmación.

## 6. Entregar

- Revisa `git diff --check`, el diff completo y `git status --short`.
- Confirma que solo están incluidos los archivos previstos y separa los cambios previos del usuario.
- Resume en lenguaje claro: resultado, archivos propios, verificaciones y resultados, bloqueos, riesgos residuales y siguiente paso recomendado.
- No hagas commit, `push`, publicación ni despliegue salvo petición expresa.

## Tratamiento de cambios locales

Los cambios existentes son una frontera de seguridad. Se pueden leer para comprender el estado, pero no revertir, normalizar, completar ni atribuir al agente sin que formen parte explícita de la tarea. Si una prueba o formato los modificaría, restringe el comando a los archivos propios o no lo ejecutes y deja constancia.

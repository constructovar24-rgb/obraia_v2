# Filosofia

El desarrollo de OBRA IA v3 se realiza mediante entregas pequenas y seguras.

Principios operativos:

- Cada cambio debe tener una unica responsabilidad.
- Es preferible avanzar con commits pequenos y estables que con cambios grandes y arriesgados.
- La arquitectura tiene prioridad sobre la velocidad.
- La consistencia del proyecto prevalece sobre introducir patrones nuevos.

# Flujo oficial

Flujo completo:

Idea
↓
Plan
↓
Prompt
↓
Copilot
↓
Revision tecnica
↓
Keep
↓
build_runner (si aplica)
↓
flutter analyze
↓
Commit
↓
Siguiente tarea

Proposito de cada paso:

- Idea: definir claramente la necesidad y su alcance.
- Plan: delimitar archivos y cambios minimos antes de tocar codigo.
- Prompt: pedir una tarea concreta, con una sola responsabilidad.
- Copilot: ejecutar la implementacion siguiendo arquitectura y estilo.
- Revision tecnica: comprobar riesgos, arquitectura, consistencia y calidad.
- Keep: aceptar solo cambios correctos y alineados con el proyecto.
- build_runner (si aplica): regenerar codigo cuando haya cambios en Drift.
- flutter analyze: validar que no hay warnings ni errores.
- Commit: guardar una entrega pequena, clara y trazable.
- Siguiente tarea: continuar con el siguiente objetivo aislado.

# Reglas de trabajo

- Un prompt = una responsabilidad.
- No modificar archivos innecesarios.
- Explicar siempre el plan antes de modificar codigo.
- Esperar revision antes de aceptar cambios.
- No realizar refactorizaciones globales.
- Mantener compatibilidad con el codigo existente.
- Reutilizar patrones ya presentes en el proyecto.
- No saltar capas de arquitectura.

# Revision de codigo

Checklist obligatoria antes de aceptar un cambio:

- Compila correctamente.
- `flutter analyze` limpio.
- No rompe arquitectura.
- No duplica logica.
- Mantiene el estilo del proyecto.
- No introduce deuda tecnica innecesaria.

# Commits

Reglas:

- Deben ser pequenos.
- Deben representar una unica tarea.
- Deben tener mensajes claros y consistentes.

Convencion recomendada:

- `feat(...)`
- `fix(...)`
- `refactor(...)`
- `docs(...)`

# Gestion de Drift

Cuando una entrega modifique Drift:

- actualizar `schemaVersion`
- crear migracion
- ejecutar:

```bash
dart run build_runner build --delete-conflicting-outputs
```

- ejecutar `flutter analyze`

# Buenas practicas

- Priorizar claridad frente a complejidad.
- Evitar duplicacion.
- Mantener clases pequenas.
- Mantener metodos con una unica responsabilidad.
- Crear primero una arquitectura solida y despues anadir funcionalidades.
- Favorecer cambios incrementales y faciles de revisar.

# Objetivo del proyecto

El objetivo de OBRA IA v3 es construir un ERP mantenible, escalable y consistente, priorizando la calidad del codigo y su evolucion a largo plazo.

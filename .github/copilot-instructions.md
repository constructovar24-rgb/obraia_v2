# Instrucciones permanentes de desarrollo para OBRA IA v3

## Contexto del proyecto
- Proyecto: OBRA IA v3.
- Mantener la arquitectura existente salvo indicación expresa.

## Arquitectura
- Mantener una arquitectura modular por features.
- Antes de crear un nuevo patrón reutilizar los existentes.
- No duplicar lógica.

## Calidad
- Código legible y documentado cuando sea necesario.
- Evitar archivos excesivamente largos.
- Mantener nombres consistentes.

## Drift
- Cada cambio en tablas debe actualizar app_database.dart.
- Ejecutar build_runner después de modificar el esquema.
- Ejecutar flutter analyze antes de finalizar.

## Flujo de trabajo
- Trabajar siempre por entregas pequeñas.
- Explicar el plan antes de modificar código.
- Esperar aprobación entre entregas.

## Seguridad
- Nunca eliminar código existente sin justificación.
- Nunca hacer refactorizaciones globales salvo petición expresa.

## Normas de trabajo
- Ejecutar build_runner cuando cambie Drift.
- Ejecutar flutter analyze al finalizar cada entrega.
- No continuar con la siguiente entrega sin aprobación.
- No hacer refactorizaciones generales.
- Reutilizar el estilo y patrones existentes.
- Mantener compatibilidad con el código ya implementado.
- Priorizar código claro, mantenible y consistente.

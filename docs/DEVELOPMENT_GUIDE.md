# DEVELOPMENT_GUIDE.md

## Flujo de trabajo
1. Revisar el estado del proyecto y el patrón existente.
2. Trabajar por entregas pequeñas.
3. Explicar el plan antes de modificar código.
4. Mantener compatibilidad con el código actual.
5. Validar el cambio antes de finalizar.

## Cómo desarrollar nuevas features
- Reutilizar el patrón de features ya presente en el proyecto.
- Mantener la estructura de data, domain y presentation.
- Evitar duplicar lógica y componentes.
- Integrar nuevas funcionalidades sin modificar módulos ya consolidados salvo necesidad justificada.

## build_runner
Cuando cambie el esquema de Drift, ejecutar:

```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

## flutter analyze
Antes de finalizar cada entrega, ejecutar:

```bash
flutter analyze
```

## Revisión antes de finalizar
- Revisar que no se hayan modificado módulos no previstos.
- Confirmar que la nueva funcionalidad sea coherente con el estilo actual.
- Verificar que la app siga compilando correctamente.

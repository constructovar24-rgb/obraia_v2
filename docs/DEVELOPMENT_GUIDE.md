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

## Compilación Windows

La toolchain Windows está validada en este equipo. Flutter 3.47.1 stable está instalado en `C:\src\flutter`, pero no se encuentra globalmente en `PATH`; esto no bloquea la compilación. Para reproducir la compilación debug sin actualizar dependencias, ejecutar desde PowerShell:

```powershell
& 'C:\src\flutter\bin\flutter.bat' build windows --debug --no-pub
```

Este comando valida la compilación local, pero no genera ni acredita un instalador o una versión publicable.

## Revisión antes de finalizar
- Revisar que no se hayan modificado módulos no previstos.
- Confirmar que la nueva funcionalidad sea coherente con el estilo actual.
- Verificar que la app siga compilando correctamente.

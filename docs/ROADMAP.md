# Roadmap operativo

Este documento resume el orden inmediato de ejecución. Los objetivos y criterios de salida completos están en `MASTER_PLAN.md`; no se usan estimaciones de fechas.

## Ahora — cerrar la línea base

- Conservar y clasificar los cambios pendientes sin mezclar sus orígenes.
- Mantener el cierre funcional de edición de Expedientes, respaldado por 8 pruebas específicas.
- Conseguir una compilación Windows reproducible instalando o configurando una toolchain compatible de Visual Studio/C++.
- Cerrar la línea base únicamente cuando Git, análisis, pruebas y compilación tengan evidencia clara.

## Después — proteger los datos

- Diseñar copias de seguridad verificables de la base SQLite.
- Restaurar sobre copias temporales y comprobar integridad y conservación.
- Consolidar pruebas de migración desde las versiones soportadas.

## Siguientes bloques

1. Consolidar `Cliente → Expediente → Presupuesto → Factura → Cobro`.
2. Completar gestión económica y rentabilidad por obra.
3. Desarrollar operación de obra: planificación, personal, subcontratas, materiales y documentos.
4. Reducir deuda arquitectónica gradualmente y decidir GoRouter en una entrega independiente.
5. Incorporar IA segura, auditable y sujeta a confirmación humana.
6. Preparar distribución profesional para Windows.

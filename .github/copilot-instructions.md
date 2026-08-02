# OBRA IA v3 - GitHub Copilot Instructions

## Project Context

You are working on **OBRA IA v3**, an ERP application specialized in construction and renovation companies.

This is not a generic CRUD application.

Every implementation must respect the existing architecture and coding style.

The project has evolved over time and consistency is more important than introducing new patterns.

Always prefer extending the current architecture instead of inventing a new one.

---

# Main Goal

Generate production-quality code.

Code should be:

- simple
- readable
- maintainable
- testable
- consistent with the rest of the project

Never generate demonstration code.

Never generate placeholder implementations unless explicitly requested.

---

# Core Domain

The central entity of the application is:

Expediente

Every business feature should be related to an Expediente whenever appropriate.

Examples:

- Clientes
- Presupuestos
- Facturas
- Cobros
- Timeline
- Compras
- Documentos
- Fotografías
- Diario de obra

Never design isolated modules that ignore the project domain.

---

# Architecture

Always follow this architecture:

UI

↓

Riverpod

↓

Repository

↓

DAO

↓

Drift

↓

SQLite

Never break this flow.

Forbidden:

UI → DAO

UI → Drift

Repository → Widget

DAO → Flutter

DAO → Business Logic

---

# General Principles

Before writing code ask yourself:

1. Does this already exist?

If yes:

Reuse it.

Never duplicate logic.

---

2. Does this follow the current project style?

If not:

Adapt to the project.

Never adapt the project to the generated code.

---

3. Is this the simplest implementation?

Prefer simple solutions.

Avoid unnecessary abstractions.

Avoid premature optimization.

---

4. Is this production-ready?

If not:

Improve it before returning.

---

# Project Philosophy

OBRA IA v3 is intended to become a professional ERP.

Every implementation should improve:

- maintainability
- consistency
- scalability

without increasing unnecessary complexity.

Prefer evolution over redesign.

---

# Mandatory Workflow (Obligatorio)

Toda implementación debe seguir este flujo:

## Fase 0 — Análisis (obligatoria)

Antes de modificar cualquier archivo:

- Identificar el punto real de entrada de la UI.
- Localizar todos los archivos implicados.
- Detectar widgets reutilizables existentes.
- Analizar completamente la estructura del layout.
- Detectar posibles conflictos de composición como `Expanded`, `Flexible`, `ListView`, `SingleChildScrollView`, `Column`, `Row` y constraints.
- Verificar la navegación existente.
- Verificar si existen pantallas reutilizables relacionadas.
- Definir exactamente qué archivos deben modificarse.
- Si el alcance inicial no coincide con la estructura real del proyecto, detenerse y proponer un ajuste antes de generar código.

Durante esta fase no se debe generar ningún parche.

## Plan de ejecución

Antes de implementar, presentar siempre:

- Archivos que se modificarán.
- Motivo de cada modificación.
- Riesgos detectados.
- Estrategia de implementación.

Esperar aprobación antes de modificar código.

## Implementación

- Modificar únicamente los archivos aprobados.
- Mantener la arquitectura existente.
- No modificar lógica de negocio salvo indicación expresa.
- Evitar desarrollo por ensayo y error.
- Priorizar una implementación completa en una sola iteración.

## Validación

Antes de finalizar:

- Ejecutar `flutter analyze`.
- Corregir cualquier incidencia detectada.
- Informar de los archivos modificados.
- Resumir los cambios realizados.
- Esperar revisión antes de considerar la tarea finalizada.

## Principios generales

- Reutilizar antes que crear.
- No duplicar componentes.
- Si una mejora puede hacerse en un componente reutilizable, preferir esa opción antes que repetir cambios en varias pantallas.
- No inventar pantallas, widgets o flujos que no existan en el proyecto.
- Si existe cualquier duda sobre el alcance, detenerse y pedir confirmación.

# OBRA IA

OBRA IA es un ERP para empresas de construcción actualmente en desarrollo. Centraliza información comercial, administrativa y operativa alrededor de cada expediente u obra. La existencia de código para una capacidad no significa por sí sola que esté terminada ni lista para producción.

## Estado resumido

- Tecnologías: Flutter, Riverpod y Drift sobre SQLite.
- Plataforma prioritaria: Windows.
- Navegación actual: `MaterialApp`, `Navigator` y `MaterialPageRoute`. GoRouter figura como dependencia, pero no está implementado como sistema de navegación.
- Persistencia: 13 tablas Drift y `schemaVersion` 17.
- Módulos presentes: Expedientes, Clientes, Presupuestos, Facturas, Cobros, Compras, Proveedores, Certificaciones, Documentos, Timeline, Dashboard, Búsqueda y Configuración.
- Subsiste un motor heredado de presupuestos de piscinas.

La edición principal de Expedientes está validada con 8 pruebas específicas, `flutter analyze --no-pub` limpio, una suite completa de 99 pruebas y una compilación debug correcta para Windows. Esta validación técnica no implica que exista todavía una versión publicable ni un instalador.

## Documentación

- [Estado verificado](docs/CURRENT_STATE.md)
- [Producto](docs/PRODUCT.md)
- [Arquitectura](docs/ARCHITECTURE.md)
- [Plan maestro](docs/MASTER_PLAN.md)
- [Roadmap operativo](docs/ROADMAP.md)
- [Registro de cambios](docs/CHANGELOG.md)

Las reglas obligatorias para agentes están en [AGENTS.md](AGENTS.md).

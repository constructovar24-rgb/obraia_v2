import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import '../core/environment/app_environment.dart';
import '../core/environment/environment_paths.dart';
import 'package:uuid/uuid.dart';
import '../core/tenant/tenant_context.dart';
import 'tables/tenants.dart';
import 'tables/expedientes.dart';
import 'tables/clientes.dart';
import 'tables/presupuestos.dart';
import 'tables/lineas_presupuesto.dart';
import 'tables/empresa_configuracion.dart';
import 'tables/facturas.dart';
import 'tables/factura_lineas.dart';
import 'tables/cobros.dart';
import 'tables/compras.dart';
import 'tables/proveedores.dart';
import 'tables/certificaciones.dart';
import 'tables/documentos.dart';
import 'tables/timeline_events.dart';
import 'tables/factura_asignaciones_presupuesto.dart';
import 'tables/factura_documentos_emitidos.dart';
import 'tables/movimientos_credito_cliente.dart';
import 'tables/categorias_economicas.dart';
import 'tables/configuracion_economica.dart';
import 'tables/linea_presupuesto_costes_previstos.dart';
import 'tables/planes_economicos.dart';
import 'tables/plan_economico_partidas.dart';
import 'tables/hechos_coste.dart';
import 'tables/personas_laborales.dart';
import 'tables/tarifas_persona.dart';
import 'tables/partes_trabajo.dart';
import 'tables/compromisos_economicos.dart';
import 'tables/aplicaciones_compromiso_coste.dart';
import 'tables/estimaciones_coste_restante.dart';
import 'tables/estados_economicos_obra.dart';
import 'tables/cierres_economicos_obra.dart';
import 'tables/reaperturas_economicas_obra.dart';
import 'tables/actuaciones_obra.dart';
import 'tables/diario_obra.dart';
import 'tables/incidencias_obra.dart';
import 'tables/incidencia_documentos.dart';
import 'tables/incidencia_diario.dart';
import 'tables/circuito_proveedor.dart';
import 'dao/expedientes_dao.dart';
import 'dao/clientes_dao.dart';
import 'dao/presupuestos_dao.dart';
import 'dao/lineas_presupuesto_dao.dart';
import 'dao/empresa_configuracion_dao.dart';
import 'dao/facturas_dao.dart';
import 'dao/factura_lineas_dao.dart';
import 'dao/cobros_dao.dart';
import 'dao/compras_dao.dart';
import 'dao/proveedores_dao.dart';
import 'dao/certificaciones_dao.dart';
import 'dao/documentos_dao.dart';
import 'dao/timeline_events_dao.dart';
import 'dao/factura_asignaciones_presupuesto_dao.dart';
import 'dao/factura_documentos_emitidos_dao.dart';
import 'dao/movimientos_credito_cliente_dao.dart';
import 'dao/economia_prevista_dao.dart';
import 'dao/hechos_coste_dao.dart';
import 'dao/mano_obra_dao.dart';
import 'dao/prevision_economica_dao.dart';
import 'dao/cierre_economico_dao.dart';
import 'dao/planificacion_obra_dao.dart';
import 'dao/diario_obra_dao.dart';
import 'dao/incidencias_obra_dao.dart';
import 'dao/circuito_proveedor_dao.dart';
import 'pre_migration_recovery_service.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Tenants,
    Expedientes,
    Clientes,
    Presupuestos,
    LineasPresupuesto,
    EmpresaConfiguracion,
    Facturas,
    FacturaLineas,
    Cobros,
    Compras,
    Proveedores,
    Certificaciones,
    Documentos,
    TimelineEvents,
    FacturaAsignacionesPresupuesto,
    FacturaDocumentosEmitidos,
    MovimientosCreditoCliente,
    CategoriasEconomicas,
    ConfiguracionEconomica,
    LineaPresupuestoCostesPrevistos,
    PlanesEconomicos,
    PlanEconomicoPartidas,
    HechosCoste,
    PersonasLaborales,
    TarifasPersona,
    PartesTrabajo,
    CompromisosEconomicos,
    AplicacionesCompromisoCoste,
    EstimacionesCosteRestante,
    EstadosEconomicosObra,
    CierresEconomicosObra,
    ReaperturasEconomicasObra,
    ActuacionesObra,
    DiarioObra,
    IncidenciasObra,
    IncidenciaDocumentos,
    IncidenciaDiario,
    AlbaranesProveedor,
    LineasAlbaranProveedor,
    AsignacionesAlbaranObra,
    FacturasRecibidas,
    FacturaRecibidaAlbaranes,
    AsignacionesFacturaRecibida,
    FacturaRecibidaCompras,
    PagosProveedor,
  ],
  daos: [
    ExpedientesDao,
    ClientesDao,
    PresupuestosDao,
    LineasPresupuestoDao,
    EmpresaConfiguracionDao,
    FacturasDao,
    FacturaLineasDao,
    CobrosDao,
    ComprasDao,
    ProveedoresDao,
    CertificacionesDao,
    DocumentosDao,
    TimelineEventsDao,
    FacturaAsignacionesPresupuestoDao,
    FacturaDocumentosEmitidosDao,
    MovimientosCreditoClienteDao,
    EconomiaPrevistaDao,
    HechosCosteDao,
    ManoObraDao,
    PrevisionEconomicaDao,
    CierreEconomicoDao,
    PlanificacionObraDao,
    DiarioObraDao,
    IncidenciasObraDao,
    CircuitoProveedorDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase({File? file, this.environment = AppEnvironment.development})
    : tenantContext = TenantContext(),
      _initialTenantId = null,
      super(_openConnection(file, environment));

  AppDatabase.forTesting(
    super.executor, {
    String tenantId = '00000000-0000-4000-8000-000000000023',
    this.environment = AppEnvironment.development,
  }) : tenantContext = TenantContext(initialTenantId: tenantId),
       _initialTenantId = tenantId;

  final AppEnvironment environment;
  final TenantContext tenantContext;
  final String? _initialTenantId;

  String get activeTenantId => tenantContext.requireTenantId();

  Future<void> ensureReady() => customSelect('SELECT 1').getSingle();

  static Future<File> defaultDatabaseFile() async {
    return (await EnvironmentPaths.resolve(
      AppEnvironment.development,
    )).databaseFile;
  }

  @override
  int get schemaVersion => 32;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      final tenantId = _initialTenantId ?? _uuid.v4();
      await into(tenants).insert(
        TenantsCompanion.insert(
          id: tenantId,
          nombre: 'Empresa inicial',
          fechaCreacion: DateTime.now().toUtc(),
          fechaModificacion: DateTime.now().toUtc(),
        ),
      );
      await _crearIndicesMultiTenant();
      await _inicializarEconomiaPorTenant(tenantId);
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(expedientes, expedientes.clienteId);
      }

      if (from < 3) {
        await m.createTable(presupuestos);
      }

      if (from < 4) {
        await m.addColumn(presupuestos, presupuestos.codigo);
        await m.addColumn(presupuestos, presupuestos.fecha);
        await m.addColumn(presupuestos, presupuestos.descripcion);
      }

      if (from < 5) {
        await m.addColumn(presupuestos, presupuestos.importeTotal);
      }

      if (from < 6) {
        await customStatement(
          'ALTER TABLE presupuestos RENAME TO presupuestos_old',
        );

        await customStatement('''
              CREATE TABLE presupuestos (
                id TEXT NOT NULL PRIMARY KEY,
                expediente_id TEXT NOT NULL REFERENCES expedientes(id),
                titulo TEXT NOT NULL DEFAULT '',
                codigo TEXT NOT NULL DEFAULT '',
                fecha INTEGER NOT NULL DEFAULT (CAST(strftime('%s', CURRENT_TIMESTAMP) AS INTEGER)),
                descripcion TEXT NOT NULL DEFAULT '',
                importe_total REAL NOT NULL DEFAULT 0,
                estado TEXT NOT NULL DEFAULT 'Borrador',
                eliminado INTEGER NOT NULL DEFAULT 0 CHECK (eliminado IN (0, 1)),
                fecha_creacion INTEGER NOT NULL DEFAULT (CAST(strftime('%s', CURRENT_TIMESTAMP) AS INTEGER)),
                fecha_modificacion INTEGER NOT NULL DEFAULT (CAST(strftime('%s', CURRENT_TIMESTAMP) AS INTEGER))
              )
            ''');

        await customStatement('''
              INSERT INTO presupuestos (
                id,
                expediente_id,
                titulo,
                codigo,
                fecha,
                descripcion,
                importe_total,
                estado,
                eliminado,
                fecha_creacion,
                fecha_modificacion
              )
              SELECT
                id,
                expediente_id,
                titulo,
                codigo,
                fecha,
                descripcion,
                importe_total,
                CASE
                  WHEN typeof(estado) = 'integer' THEN
                    CASE estado
                      WHEN 1 THEN 'Presentado'
                      WHEN 2 THEN 'Aceptado'
                      WHEN 3 THEN 'Rechazado'
                      ELSE 'Borrador'
                    END
                  WHEN trim(COALESCE(estado, '')) = '' THEN 'Borrador'
                  ELSE estado
                END,
                eliminado,
                fecha_creacion,
                fecha_modificacion
              FROM presupuestos_old
            ''');

        await customStatement('DROP TABLE presupuestos_old');
      }

      if (from < 7) {
        await m.createTable(lineasPresupuesto);
      }

      if (from < 8) {
        await m.addColumn(presupuestos, presupuestos.ivaPorcentaje);
      }

      if (from < 9) {
        await m.createTable(empresaConfiguracion);
      }

      if (from < 10) {
        await m.createTable(facturas);
        await m.createTable(facturaLineas);
      }

      if (from < 11) {
        await m.createTable(cobros);
      }

      if (from < 12) {
        await m.createTable(timelineEvents);
      }

      if (from < 13) {
        await m.createTable(compras);
      }

      if (from < 14) {
        await m.createTable(proveedores);
      }

      if (from < 15) {
        await m.createTable(certificaciones);
      }

      if (from < 16) {
        await m.createTable(documentos);
      }

      if (from >= 10 && from < 17) {
        await m.addColumn(facturas, facturas.ivaPorcentaje);
        await customStatement('''
              UPDATE facturas
              SET iva_porcentaje = CASE
                WHEN subtotal != 0 THEN iva * 100 / subtotal
                ELSE 21
              END
            ''');
      }

      if (from < 18) {
        await m.addColumn(lineasPresupuesto, lineasPresupuesto.unidad);
        await m.addColumn(facturas, facturas.anioNumeracion);
        await m.addColumn(facturas, facturas.numeroLegal);
        await m.addColumn(facturas, facturas.fechaEmision);
        await m.addColumn(facturas, facturas.clienteNombreHistorico);
        await m.addColumn(facturas, facturas.clienteNifHistorico);
        await m.addColumn(facturas, facturas.clienteDireccionHistorica);
        await m.addColumn(facturas, facturas.clienteTelefonoHistorico);
        await m.addColumn(facturas, facturas.clienteEmailHistorico);
        await m.addColumn(facturas, facturas.empresaNombreHistorico);
        await m.addColumn(facturas, facturas.empresaCifHistorico);
        await m.addColumn(facturas, facturas.empresaDireccionHistorica);
        await m.addColumn(facturas, facturas.empresaCodigoPostalHistorico);
        await m.addColumn(facturas, facturas.empresaPoblacionHistorica);
        await m.addColumn(facturas, facturas.empresaProvinciaHistorica);
        await m.addColumn(facturas, facturas.empresaTelefonoHistorico);
        await m.addColumn(facturas, facturas.empresaEmailHistorico);
        await m.addColumn(facturas, facturas.empresaWebHistorica);
        await m.addColumn(facturas, facturas.expedienteOrigenIdHistorico);
        await m.addColumn(facturas, facturas.expedienteCodigoHistorico);
        await m.addColumn(facturas, facturas.expedienteNombreHistorico);
        await m.addColumn(facturas, facturas.presupuestoCodigoHistorico);
        await customStatement('''
          CREATE UNIQUE INDEX IF NOT EXISTS facturas_numeracion_legal_unica
          ON facturas(anio_numeracion, numero_legal)
          WHERE anio_numeracion IS NOT NULL AND numero_legal IS NOT NULL
        ''');
      }
      if (from < 19) {
        await m.addColumn(cobros, cobros.tipoMovimiento);
        await m.addColumn(cobros, cobros.cobroOrigenId);
        await m.addColumn(cobros, cobros.motivo);
      }
      if (from < 20) {
        await m.createTable(facturaAsignacionesPresupuesto);
        await customStatement('''
          CREATE INDEX IF NOT EXISTS factura_asignaciones_presupuesto_idx
          ON factura_asignaciones_presupuesto(presupuesto_id)
        ''');
        await customStatement('''
          CREATE INDEX IF NOT EXISTS factura_asignaciones_factura_idx
          ON factura_asignaciones_presupuesto(factura_id)
        ''');
      }
      if (from < 21) {
        await m.addColumn(facturas, facturas.tipoDocumento);
        await m.addColumn(facturas, facturas.serie);
        await m.addColumn(facturas, facturas.facturaRectificadaId);
        await m.addColumn(facturas, facturas.facturaRaizId);
        await m.addColumn(facturas, facturas.modalidadRectificacion);
        await m.addColumn(facturas, facturas.motivoRectificacion);
        await m.addColumn(facturas, facturas.efectoBase);
        await m.addColumn(facturas, facturas.efectoIva);
        await m.addColumn(facturas, facturas.efectoTotal);
        await m.addColumn(facturaLineas, facturaLineas.lineaRectificadaId);
        await m.addColumn(facturaLineas, facturaLineas.lineaRaizId);
        await m.createTable(facturaDocumentosEmitidos);
        await customStatement(
          'DROP INDEX IF EXISTS facturas_numeracion_legal_unica',
        );
        await customStatement('''
          CREATE UNIQUE INDEX facturas_numeracion_legal_unica
          ON facturas(serie, anio_numeracion, numero_legal)
          WHERE anio_numeracion IS NOT NULL AND numero_legal IS NOT NULL
        ''');
        await customStatement('''
          CREATE INDEX facturas_rectificada_idx
          ON facturas(factura_rectificada_id)
        ''');
        await customStatement('''
          CREATE INDEX facturas_raiz_idx ON facturas(factura_raiz_id)
        ''');
      }
      if (from < 22) {
        await m.createTable(movimientosCreditoCliente);
        await _crearIndicesCredito();
      }
      if (from < 23) {
        await _migrarMultiTenantV23(m);
      }
      if (from < 24) {
        await m.createTable(categoriasEconomicas);
        await m.createTable(configuracionEconomica);
        await m.createTable(lineaPresupuestoCostesPrevistos);
        await m.createTable(planesEconomicos);
        await m.createTable(planEconomicoPartidas);
        await _crearIndicesEconomicos();
        final tenantsExistentes = await select(tenants).get();
        for (final tenant in tenantsExistentes) {
          await _inicializarEconomiaPorTenant(tenant.id);
        }
      }
      if (from < 25) {
        if (await _existeTabla('compras') &&
            !await _existeColumna('compras', 'clasificacion_economica')) {
          await m.addColumn(compras, compras.clasificacionEconomica);
        }
        if (!await _existeTabla('hechos_coste')) {
          await m.createTable(hechosCoste);
        }
        await _crearIndicesHechosCoste();
      }
      if (from < 26) {
        await m.createTable(personasLaborales);
        await m.createTable(tarifasPersona);
        await m.createTable(partesTrabajo);
        await _crearIndicesManoObra();
      }
      if (from < 27) {
        await m.createTable(compromisosEconomicos);
        await m.createTable(aplicacionesCompromisoCoste);
        await m.createTable(estimacionesCosteRestante);
        await _crearIndicesPrevisionEconomica();
      }
      if (from < 28) {
        await m.createTable(estadosEconomicosObra);
        await m.createTable(cierresEconomicosObra);
        await m.createTable(reaperturasEconomicasObra);
        await _crearIndicesCierreEconomico();
      }
      if (from < 29) {
        if (await _existeTabla('expedientes')) {
          if (!await _existeColumna('expedientes', 'estado_operativo')) {
            await m.addColumn(expedientes, expedientes.estadoOperativo);
          }
          if (!await _existeColumna('expedientes', 'fecha_inicio_prevista')) {
            await m.addColumn(expedientes, expedientes.fechaInicioPrevista);
          }
          if (!await _existeColumna('expedientes', 'fecha_fin_prevista')) {
            await m.addColumn(expedientes, expedientes.fechaFinPrevista);
          }
          if (!await _existeColumna('expedientes', 'fecha_inicio_real')) {
            await m.addColumn(expedientes, expedientes.fechaInicioReal);
          }
          if (!await _existeColumna('expedientes', 'fecha_fin_real')) {
            await m.addColumn(expedientes, expedientes.fechaFinReal);
          }
          await m.createTable(actuacionesObra);
          await _crearIndicesPlanificacion();
        }
      }
      if (from < 30 && await _existeTabla('expedientes')) {
        await m.createTable(diarioObra);
        await _crearIndicesDiarioObra();
      }
      if (from < 31 && await _existeTabla('expedientes')) {
        await m.createTable(incidenciasObra);
        await m.createTable(incidenciaDocumentos);
        await m.createTable(incidenciaDiario);
        await _crearIndicesIncidencias();
      }
      if (from < 32 && await _existeTabla('expedientes')) {
        await m.createTable(albaranesProveedor);
        await m.createTable(lineasAlbaranProveedor);
        await m.createTable(asignacionesAlbaranObra);
        await m.createTable(facturasRecibidas);
        await m.createTable(facturaRecibidaAlbaranes);
        await m.createTable(asignacionesFacturaRecibida);
        await m.createTable(facturaRecibidaCompras);
        await m.createTable(pagosProveedor);
        await _crearIndicesCircuitoProveedor();
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      final tenantIdSolicitado = _initialTenantId;
      final query = select(tenants);
      if (tenantIdSolicitado != null) {
        query.where((row) => row.id.equals(tenantIdSolicitado));
      }
      final disponibles = await query.get();
      if (disponibles.length != 1) {
        throw StateError(
          tenantIdSolicitado == null
              ? 'La instalación local requiere exactamente un tenant activo.'
              : 'El tenant solicitado no existe.',
        );
      }
      tenantContext.activate(disponibles.single.id);
    },
  );

  Future<void> _migrarMultiTenantV23(Migrator m) async {
    final tieneConfiguracion = await _existeTabla('empresa_configuracion');
    final configuraciones = tieneConfiguracion
        ? await customSelect(
            'SELECT id, nombre_empresa FROM empresa_configuracion',
          ).get()
        : const <QueryRow>[];
    if (configuraciones.length > 1) {
      throw StateError(
        'La migración no puede resolver más de una configuración empresarial.',
      );
    }
    final tieneCompras = await _existeTabla('compras');
    final tieneProveedores = await _existeTabla('proveedores');
    final proveedoresHuerfanos = tieneCompras && tieneProveedores
        ? await customSelect('''
      SELECT COUNT(*) AS total
      FROM compras c
      LEFT JOIN proveedores p ON p.id = c.proveedor_id
      WHERE c.proveedor_id IS NOT NULL AND p.id IS NULL
    ''').getSingle()
        : null;
    if (proveedoresHuerfanos?.read<int>('total') != null &&
        proveedoresHuerfanos!.read<int>('total') != 0) {
      throw StateError(
        'La migración ha detectado compras con proveedor inexistente.',
      );
    }

    final tenantId = _initialTenantId ?? _uuid.v4();
    final ahora = DateTime.now().toUtc();
    final nombreConfigurado = configuraciones.isEmpty
        ? ''
        : configuraciones.single.read<String>('nombre_empresa').trim();
    if (!await _existeTabla('tenants')) {
      await m.createTable(tenants);
      await into(tenants).insert(
        TenantsCompanion.insert(
          id: tenantId,
          nombre: nombreConfigurado.isEmpty
              ? 'Empresa inicial'
              : nombreConfigurado,
          fechaCreacion: ahora,
          fechaModificacion: ahora,
        ),
      );
    }

    await _agregarTenant(m, clientes, clientes.tenantId, tenantId);
    await _agregarTenant(m, proveedores, proveedores.tenantId, tenantId);
    await _agregarTenant(
      m,
      empresaConfiguracion,
      empresaConfiguracion.tenantId,
      tenantId,
    );
    await _agregarTenant(m, expedientes, expedientes.tenantId, tenantId);
    await _agregarTenant(m, presupuestos, presupuestos.tenantId, tenantId);
    await _agregarTenant(
      m,
      lineasPresupuesto,
      lineasPresupuesto.tenantId,
      tenantId,
    );
    await _agregarTenant(
      m,
      certificaciones,
      certificaciones.tenantId,
      tenantId,
    );
    await _agregarTenant(m, compras, compras.tenantId, tenantId);
    await _agregarTenant(m, documentos, documentos.tenantId, tenantId);
    await _agregarTenant(m, timelineEvents, timelineEvents.tenantId, tenantId);
    await _agregarTenant(m, facturas, facturas.tenantId, tenantId);
    await _agregarTenant(m, facturaLineas, facturaLineas.tenantId, tenantId);
    await _agregarTenant(
      m,
      facturaAsignacionesPresupuesto,
      facturaAsignacionesPresupuesto.tenantId,
      tenantId,
    );
    await _agregarTenant(
      m,
      facturaDocumentosEmitidos,
      facturaDocumentosEmitidos.tenantId,
      tenantId,
    );
    await _agregarTenant(m, cobros, cobros.tenantId, tenantId);
    await _agregarTenant(
      m,
      movimientosCreditoCliente,
      movimientosCreditoCliente.tenantId,
      tenantId,
    );

    await _crearIndicesMultiTenant();
  }

  Future<void> _agregarTenant(
    Migrator migrator,
    TableInfo<Table, Object?> table,
    GeneratedColumn<String> tenantColumn,
    String tenantId,
  ) async {
    if (!await _existeTabla(table.actualTableName)) {
      return;
    }
    final columnas = await customSelect(
      'PRAGMA table_info(${table.actualTableName})',
    ).get();
    if (columnas.any((fila) => fila.read<String>('name') == 'tenant_id')) {
      return;
    }
    await migrator.alterTable(
      TableMigration(
        table,
        newColumns: [tenantColumn],
        columnTransformer: {tenantColumn: Constant(tenantId)},
      ),
    );
  }

  Future<bool> _existeTabla(String nombre) async {
    final fila = await customSelect(
      "SELECT 1 FROM sqlite_master WHERE type = 'table' AND name = ?",
      variables: [Variable<String>(nombre)],
    ).getSingleOrNull();
    return fila != null;
  }

  Future<bool> _existeColumna(String tabla, String columna) async {
    if (!await _existeTabla(tabla)) return false;
    final columnas = await customSelect('PRAGMA table_info($tabla)').get();
    return columnas.any((fila) => fila.read<String>('name') == columna);
  }

  Future<void> _crearIndicesMultiTenant() async {
    await customStatement(
      'DROP INDEX IF EXISTS facturas_numeracion_legal_unica',
    );
    for (final name in <String>[
      'factura_asignaciones_presupuesto_idx',
      'factura_asignaciones_factura_idx',
      'facturas_rectificada_idx',
      'facturas_raiz_idx',
      'movimientos_credito_origen_idx',
      'movimientos_credito_destino_idx',
      'movimientos_credito_movimiento_origen_idx',
      'movimientos_credito_cliente_idx',
    ]) {
      await customStatement('DROP INDEX IF EXISTS $name');
    }
    final indices = <String, List<String>>{
      'clientes': [
        'CREATE UNIQUE INDEX IF NOT EXISTS clientes_tenant_id_id_unica ON clientes(tenant_id,id)',
        'CREATE INDEX IF NOT EXISTS clientes_tenant_activos_fecha_idx ON clientes(tenant_id,eliminado,fecha_creacion)',
      ],
      'proveedores': [
        'CREATE UNIQUE INDEX IF NOT EXISTS proveedores_tenant_id_id_unica ON proveedores(tenant_id,id)',
        'CREATE INDEX IF NOT EXISTS proveedores_tenant_activos_fecha_idx ON proveedores(tenant_id,eliminado,fecha_creacion)',
      ],
      'empresa_configuracion': [
        'CREATE UNIQUE INDEX IF NOT EXISTS empresa_configuracion_tenant_id_id_unica ON empresa_configuracion(tenant_id,id)',
        'CREATE UNIQUE INDEX IF NOT EXISTS empresa_configuracion_tenant_unica ON empresa_configuracion(tenant_id)',
      ],
      'expedientes': [
        'CREATE UNIQUE INDEX IF NOT EXISTS expedientes_tenant_id_id_unica ON expedientes(tenant_id,id)',
        'CREATE INDEX IF NOT EXISTS expedientes_tenant_activos_fecha_idx ON expedientes(tenant_id,eliminado,fecha_creacion)',
        'CREATE INDEX IF NOT EXISTS expedientes_tenant_cliente_idx ON expedientes(tenant_id,cliente_id)',
      ],
      'presupuestos': [
        'CREATE UNIQUE INDEX IF NOT EXISTS presupuestos_tenant_id_id_unica ON presupuestos(tenant_id,id)',
        'CREATE INDEX IF NOT EXISTS presupuestos_tenant_expediente_idx ON presupuestos(tenant_id,expediente_id,eliminado,fecha)',
        'CREATE INDEX IF NOT EXISTS presupuestos_tenant_fecha_idx ON presupuestos(tenant_id,eliminado,fecha)',
      ],
      'lineas_presupuesto': [
        'CREATE UNIQUE INDEX IF NOT EXISTS lineas_presupuesto_tenant_id_id_unica ON lineas_presupuesto(tenant_id,id)',
        'CREATE INDEX IF NOT EXISTS lineas_presupuesto_tenant_presupuesto_idx ON lineas_presupuesto(tenant_id,presupuesto_id)',
      ],
      'facturas': [
        'CREATE UNIQUE INDEX IF NOT EXISTS facturas_tenant_id_id_unica ON facturas(tenant_id,id)',
        'CREATE UNIQUE INDEX IF NOT EXISTS facturas_numeracion_legal_unica ON facturas(tenant_id,serie,anio_numeracion,numero_legal) WHERE anio_numeracion IS NOT NULL AND numero_legal IS NOT NULL',
        'CREATE INDEX IF NOT EXISTS facturas_tenant_cliente_idx ON facturas(tenant_id,cliente_id)',
        'CREATE INDEX IF NOT EXISTS facturas_tenant_presupuesto_idx ON facturas(tenant_id,presupuesto_origen_id)',
        'CREATE INDEX IF NOT EXISTS facturas_tenant_rectificada_idx ON facturas(tenant_id,factura_rectificada_id)',
        'CREATE INDEX IF NOT EXISTS facturas_tenant_raiz_idx ON facturas(tenant_id,factura_raiz_id)',
        'CREATE INDEX IF NOT EXISTS facturas_tenant_fecha_idx ON facturas(tenant_id,fecha)',
      ],
      'factura_lineas': [
        'CREATE UNIQUE INDEX IF NOT EXISTS factura_lineas_tenant_id_id_unica ON factura_lineas(tenant_id,id)',
        'CREATE INDEX IF NOT EXISTS factura_lineas_tenant_factura_idx ON factura_lineas(tenant_id,factura_id)',
        'CREATE INDEX IF NOT EXISTS factura_lineas_tenant_rectificada_idx ON factura_lineas(tenant_id,linea_rectificada_id)',
        'CREATE INDEX IF NOT EXISTS factura_lineas_tenant_raiz_idx ON factura_lineas(tenant_id,linea_raiz_id)',
      ],
      'factura_asignaciones_presupuesto': [
        'CREATE UNIQUE INDEX IF NOT EXISTS factura_asignaciones_tenant_id_id_unica ON factura_asignaciones_presupuesto(tenant_id,id)',
        'CREATE UNIQUE INDEX IF NOT EXISTS factura_asignaciones_tenant_linea_unica ON factura_asignaciones_presupuesto(tenant_id,factura_linea_id)',
        'CREATE INDEX IF NOT EXISTS factura_asignaciones_tenant_factura_idx ON factura_asignaciones_presupuesto(tenant_id,factura_id)',
        'CREATE INDEX IF NOT EXISTS factura_asignaciones_tenant_presupuesto_idx ON factura_asignaciones_presupuesto(tenant_id,presupuesto_id)',
        'CREATE INDEX IF NOT EXISTS factura_asignaciones_tenant_linea_presupuesto_idx ON factura_asignaciones_presupuesto(tenant_id,linea_presupuesto_id)',
        'CREATE INDEX IF NOT EXISTS factura_asignaciones_tenant_certificacion_idx ON factura_asignaciones_presupuesto(tenant_id,certificacion_origen_id)',
      ],
      'factura_documentos_emitidos': [],
      'cobros': [
        'CREATE UNIQUE INDEX IF NOT EXISTS cobros_tenant_id_id_unica ON cobros(tenant_id,id)',
        'CREATE INDEX IF NOT EXISTS cobros_tenant_factura_fecha_idx ON cobros(tenant_id,factura_id,fecha)',
        'CREATE INDEX IF NOT EXISTS cobros_tenant_origen_idx ON cobros(tenant_id,cobro_origen_id)',
      ],
      'movimientos_credito_cliente': [
        'CREATE UNIQUE INDEX IF NOT EXISTS movimientos_credito_cliente_tenant_id_id_unica ON movimientos_credito_cliente(tenant_id,id)',
        'CREATE INDEX IF NOT EXISTS movimientos_credito_origen_idx ON movimientos_credito_cliente(tenant_id,factura_raiz_origen_id)',
        'CREATE INDEX IF NOT EXISTS movimientos_credito_destino_idx ON movimientos_credito_cliente(tenant_id,factura_raiz_destino_id)',
        'CREATE INDEX IF NOT EXISTS movimientos_credito_movimiento_origen_idx ON movimientos_credito_cliente(tenant_id,movimiento_origen_id)',
        'CREATE INDEX IF NOT EXISTS movimientos_credito_cliente_idx ON movimientos_credito_cliente(tenant_id,cliente_id)',
      ],
      'compras': [
        'CREATE UNIQUE INDEX IF NOT EXISTS compras_tenant_id_id_unica ON compras(tenant_id,id)',
        'CREATE INDEX IF NOT EXISTS compras_tenant_expediente_idx ON compras(tenant_id,expediente_id,eliminado,fecha)',
        'CREATE INDEX IF NOT EXISTS compras_tenant_proveedor_idx ON compras(tenant_id,proveedor_id)',
      ],
      'certificaciones': [
        'CREATE UNIQUE INDEX IF NOT EXISTS certificaciones_tenant_id_id_unica ON certificaciones(tenant_id,id)',
        'CREATE INDEX IF NOT EXISTS certificaciones_tenant_expediente_idx ON certificaciones(tenant_id,expediente_id,eliminado,fecha)',
        'CREATE INDEX IF NOT EXISTS certificaciones_tenant_presupuesto_idx ON certificaciones(tenant_id,presupuesto_id)',
      ],
      'documentos': [
        'CREATE UNIQUE INDEX IF NOT EXISTS documentos_tenant_id_id_unica ON documentos(tenant_id,id)',
        'CREATE INDEX IF NOT EXISTS documentos_tenant_expediente_idx ON documentos(tenant_id,expediente_id,eliminado,fecha)',
      ],
      'timeline_events': [
        'CREATE UNIQUE INDEX IF NOT EXISTS timeline_events_tenant_id_id_unica ON timeline_events(tenant_id,id)',
        'CREATE INDEX IF NOT EXISTS timeline_tenant_expediente_fecha_idx ON timeline_events(tenant_id,expediente_id,fecha)',
        'CREATE INDEX IF NOT EXISTS timeline_tenant_fecha_idx ON timeline_events(tenant_id,fecha)',
      ],
    };
    for (final entry in indices.entries) {
      if (!await _existeTabla(entry.key)) continue;
      for (final statement in entry.value) {
        await customStatement(statement);
      }
    }
    await _crearIndicesEconomicos();
    await _crearIndicesHechosCoste();
    await _crearIndicesManoObra();
    await _crearIndicesPrevisionEconomica();
    await _crearIndicesCierreEconomico();
    await _crearIndicesPlanificacion();
    await _crearIndicesDiarioObra();
    await _crearIndicesIncidencias();
    await _crearIndicesCircuitoProveedor();
  }

  Future<void> _crearIndicesCircuitoProveedor() async {
    if (!await _existeTabla('albaranes_proveedor')) return;
    for (final sql in <String>[
      'CREATE INDEX IF NOT EXISTS albaranes_tenant_proveedor_fecha_idx ON albaranes_proveedor(tenant_id,proveedor_id,fecha)',
      'CREATE INDEX IF NOT EXISTS lineas_albaran_tenant_albaran_idx ON lineas_albaran_proveedor(tenant_id,albaran_id)',
      'CREATE INDEX IF NOT EXISTS asignaciones_albaran_tenant_obra_idx ON asignaciones_albaran_obra(tenant_id,expediente_id)',
      'CREATE INDEX IF NOT EXISTS facturas_recibidas_tenant_proveedor_fecha_idx ON facturas_recibidas(tenant_id,proveedor_id,fecha_factura)',
      'CREATE INDEX IF NOT EXISTS asignaciones_factura_tenant_obra_idx ON asignaciones_factura_recibida(tenant_id,expediente_id)',
      'CREATE INDEX IF NOT EXISTS pagos_proveedor_tenant_factura_fecha_idx ON pagos_proveedor(tenant_id,factura_id,fecha)',
    ]) {
      await customStatement(sql);
    }
  }

  Future<void> _crearIndicesIncidencias() async {
    if (!await _existeTabla('incidencias_obra')) return;
    for (final statement in <String>[
      'CREATE UNIQUE INDEX IF NOT EXISTS incidencias_tenant_id_unica ON incidencias_obra(tenant_id,id)',
      'CREATE INDEX IF NOT EXISTS incidencias_tenant_obra_estado_fecha_idx ON incidencias_obra(tenant_id,expediente_id,estado,fecha_deteccion)',
      'CREATE INDEX IF NOT EXISTS incidencia_documentos_tenant_documento_idx ON incidencia_documentos(tenant_id,documento_id)',
      'CREATE INDEX IF NOT EXISTS incidencia_diario_tenant_entrada_idx ON incidencia_diario(tenant_id,entrada_diario_id)',
    ]) {
      await customStatement(statement);
    }
  }

  Future<void> _crearIndicesDiarioObra() async {
    if (!await _existeTabla('diario_obra')) return;
    for (final statement in <String>[
      'CREATE UNIQUE INDEX IF NOT EXISTS diario_obra_tenant_id_unica ON diario_obra(tenant_id,id)',
      'CREATE INDEX IF NOT EXISTS diario_obra_tenant_expediente_fecha_idx ON diario_obra(tenant_id,expediente_id,fecha_trabajo,fecha_creacion)',
      'CREATE INDEX IF NOT EXISTS diario_obra_tenant_actuacion_idx ON diario_obra(tenant_id,actuacion_id)',
    ]) {
      await customStatement(statement);
    }
  }

  Future<void> _crearIndicesPlanificacion() async {
    if (!await _existeTabla('actuaciones_obra')) return;
    for (final statement in <String>[
      'CREATE UNIQUE INDEX IF NOT EXISTS actuaciones_obra_tenant_id_unica ON actuaciones_obra(tenant_id,id)',
      'CREATE INDEX IF NOT EXISTS actuaciones_obra_tenant_expediente_orden_idx ON actuaciones_obra(tenant_id,expediente_id,orden)',
      "CREATE UNIQUE INDEX IF NOT EXISTS actuaciones_obra_proximo_pendiente_unico ON actuaciones_obra(tenant_id,expediente_id) WHERE tipo='proximoPaso' AND estado='pendiente'",
    ]) {
      await customStatement(statement);
    }
  }

  Future<void> _crearIndicesCierreEconomico() async {
    if (!await _existeTabla('estados_economicos_obra')) return;
    for (final statement in <String>[
      'CREATE UNIQUE INDEX IF NOT EXISTS cierre_estado_tenant_obra_unica ON estados_economicos_obra(tenant_id,expediente_id)',
      'CREATE UNIQUE INDEX IF NOT EXISTS cierres_tenant_id_unica ON cierres_economicos_obra(tenant_id,id)',
      'CREATE UNIQUE INDEX IF NOT EXISTS cierres_tenant_obra_numero_unica ON cierres_economicos_obra(tenant_id,expediente_id,numero)',
      'CREATE INDEX IF NOT EXISTS cierres_tenant_obra_fecha_idx ON cierres_economicos_obra(tenant_id,expediente_id,fecha_cierre)',
      'CREATE UNIQUE INDEX IF NOT EXISTS reaperturas_tenant_id_unica ON reaperturas_economicas_obra(tenant_id,id)',
      'CREATE INDEX IF NOT EXISTS reaperturas_tenant_obra_fecha_idx ON reaperturas_economicas_obra(tenant_id,expediente_id,fecha_reapertura)',
    ]) {
      await customStatement(statement);
    }
  }

  Future<void> _crearIndicesPrevisionEconomica() async {
    if (!await _existeTabla('compromisos_economicos')) return;
    for (final statement in <String>[
      'CREATE UNIQUE INDEX IF NOT EXISTS compromisos_tenant_id_unica ON compromisos_economicos(tenant_id,id)',
      'CREATE INDEX IF NOT EXISTS compromisos_tenant_obra_estado_idx ON compromisos_economicos(tenant_id,expediente_id,estado)',
      'CREATE INDEX IF NOT EXISTS compromisos_tenant_categoria_idx ON compromisos_economicos(tenant_id,categoria_economica_id)',
      'CREATE UNIQUE INDEX IF NOT EXISTS aplicaciones_tenant_id_unica ON aplicaciones_compromiso_coste(tenant_id,id)',
      'CREATE INDEX IF NOT EXISTS aplicaciones_tenant_compromiso_hecho_idx ON aplicaciones_compromiso_coste(tenant_id,compromiso_id,hecho_coste_id)',
      'CREATE INDEX IF NOT EXISTS aplicaciones_tenant_hecho_idx ON aplicaciones_compromiso_coste(tenant_id,hecho_coste_id)',
      'CREATE UNIQUE INDEX IF NOT EXISTS estimaciones_tenant_id_unica ON estimaciones_coste_restante(tenant_id,id)',
      'CREATE UNIQUE INDEX IF NOT EXISTS estimaciones_tenant_serie_version_unica ON estimaciones_coste_restante(tenant_id,serie_id,version)',
      'CREATE INDEX IF NOT EXISTS estimaciones_tenant_obra_fecha_idx ON estimaciones_coste_restante(tenant_id,expediente_id,fecha_estimacion)',
    ]) {
      await customStatement(statement);
    }
  }

  Future<void> _crearIndicesManoObra() async {
    if (!await _existeTabla('personas_laborales')) return;
    for (final statement in <String>[
      'CREATE UNIQUE INDEX IF NOT EXISTS personas_laborales_tenant_id_id_unica ON personas_laborales(tenant_id,id)',
      'CREATE INDEX IF NOT EXISTS personas_laborales_tenant_activa_idx ON personas_laborales(tenant_id,activa,nombre)',
      'CREATE UNIQUE INDEX IF NOT EXISTS tarifas_persona_tenant_id_id_unica ON tarifas_persona(tenant_id,id)',
      'CREATE INDEX IF NOT EXISTS tarifas_persona_tenant_persona_vigencia_idx ON tarifas_persona(tenant_id,persona_id,vigente_desde,vigente_hasta)',
      'CREATE UNIQUE INDEX IF NOT EXISTS partes_trabajo_tenant_id_id_unica ON partes_trabajo(tenant_id,id)',
      'CREATE UNIQUE INDEX IF NOT EXISTS plan_partidas_tenant_plan_id_unica ON plan_economico_partidas(tenant_id,plan_economico_id,id)',
      'CREATE INDEX IF NOT EXISTS partes_trabajo_tenant_obra_fecha_idx ON partes_trabajo(tenant_id,expediente_id,fecha_trabajo)',
      'CREATE INDEX IF NOT EXISTS partes_trabajo_tenant_persona_fecha_idx ON partes_trabajo(tenant_id,persona_id,fecha_trabajo)',
      'CREATE INDEX IF NOT EXISTS partes_trabajo_tenant_partida_idx ON partes_trabajo(tenant_id,plan_economico_partida_id)',
    ]) {
      await customStatement(statement);
    }
  }

  Future<void> _crearIndicesHechosCoste() async {
    if (!await _existeTabla('hechos_coste')) return;
    for (final statement in <String>[
      'CREATE UNIQUE INDEX IF NOT EXISTS hechos_coste_tenant_id_id_unica ON hechos_coste(tenant_id,id)',
      'CREATE UNIQUE INDEX IF NOT EXISTS hechos_coste_tenant_clave_unica ON hechos_coste(tenant_id,clave_idempotencia)',
      'CREATE INDEX IF NOT EXISTS hechos_coste_tenant_expediente_fecha_idx ON hechos_coste(tenant_id,expediente_id,fecha_devengo)',
      'CREATE INDEX IF NOT EXISTS hechos_coste_tenant_categoria_idx ON hechos_coste(tenant_id,categoria_economica_id)',
      'CREATE INDEX IF NOT EXISTS hechos_coste_tenant_origen_idx ON hechos_coste(tenant_id,origen_tipo,origen_id)',
      'CREATE INDEX IF NOT EXISTS hechos_coste_tenant_partida_idx ON hechos_coste(tenant_id,plan_economico_partida_id)',
    ]) {
      await customStatement(statement);
    }
  }

  Future<void> _crearIndicesEconomicos() async {
    final statements = <String, List<String>>{
      'categorias_economicas': [
        'CREATE UNIQUE INDEX IF NOT EXISTS categorias_economicas_tenant_id_id_unica ON categorias_economicas(tenant_id,id)',
        'CREATE UNIQUE INDEX IF NOT EXISTS categorias_economicas_tenant_codigo_unica ON categorias_economicas(tenant_id,codigo)',
        'CREATE INDEX IF NOT EXISTS categorias_economicas_tenant_activas_idx ON categorias_economicas(tenant_id,activa,orden)',
      ],
      'configuracion_economica': [
        'CREATE UNIQUE INDEX IF NOT EXISTS configuracion_economica_tenant_unica ON configuracion_economica(tenant_id)',
      ],
      'linea_presupuesto_costes_previstos': [
        'CREATE UNIQUE INDEX IF NOT EXISTS linea_costes_tenant_linea_unica ON linea_presupuesto_costes_previstos(tenant_id,linea_presupuesto_id)',
        'CREATE INDEX IF NOT EXISTS linea_costes_tenant_categoria_idx ON linea_presupuesto_costes_previstos(tenant_id,categoria_economica_id)',
      ],
      'planes_economicos': [
        'CREATE UNIQUE INDEX IF NOT EXISTS planes_tenant_presupuesto_unica ON planes_economicos(tenant_id,presupuesto_id)',
        'CREATE INDEX IF NOT EXISTS planes_tenant_expediente_estado_idx ON planes_economicos(tenant_id,expediente_id,estado)',
      ],
      'plan_economico_partidas': [
        'CREATE UNIQUE INDEX IF NOT EXISTS plan_partidas_tenant_plan_orden_unica ON plan_economico_partidas(tenant_id,plan_economico_id,orden)',
        'CREATE INDEX IF NOT EXISTS plan_partidas_tenant_categoria_idx ON plan_economico_partidas(tenant_id,categoria_economica_id)',
      ],
    };
    for (final entry in statements.entries) {
      if (!await _existeTabla(entry.key)) continue;
      for (final statement in entry.value) {
        await customStatement(statement);
      }
    }
  }

  Future<void> _inicializarEconomiaPorTenant(String tenantId) async {
    final ahora = DateTime.now().toUtc();
    final categorias = <(String, String)>[
      ('materiales', 'Materiales'),
      ('mano_obra', 'Mano de obra'),
      ('maquinaria', 'Maquinaria'),
      ('subcontratas', 'Subcontratas'),
      ('transporte', 'Transporte'),
      ('alquileres', 'Alquileres'),
      ('tasas_licencias', 'Tasas y licencias'),
      ('residuos', 'Residuos y vertedero'),
      ('otros_directos', 'Otros costes directos'),
    ];
    for (var i = 0; i < categorias.length; i++) {
      await into(categoriasEconomicas).insert(
        CategoriasEconomicasCompanion.insert(
          tenantId: tenantId,
          id: _uuid.v4(),
          codigo: categorias[i].$1,
          nombre: categorias[i].$2,
          orden: Value(i),
          fechaCreacion: ahora,
          fechaModificacion: ahora,
        ),
        mode: InsertMode.insertOrIgnore,
      );
    }
    await into(configuracionEconomica).insert(
      ConfiguracionEconomicaCompanion.insert(
        tenantId: tenantId,
        id: _uuid.v4(),
        fechaCreacion: ahora,
        fechaModificacion: ahora,
      ),
      mode: InsertMode.insertOrIgnore,
    );
  }

  Future<void> _crearIndicesCredito() async {
    await customStatement(
      'CREATE INDEX IF NOT EXISTS movimientos_credito_origen_idx ON movimientos_credito_cliente(tenant_id, factura_raiz_origen_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS movimientos_credito_destino_idx ON movimientos_credito_cliente(tenant_id, factura_raiz_destino_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS movimientos_credito_movimiento_origen_idx ON movimientos_credito_cliente(tenant_id, movimiento_origen_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS movimientos_credito_cliente_idx ON movimientos_credito_cliente(tenant_id, cliente_id)',
    );
  }

  final _uuid = const Uuid();

  Future<void> crearExpediente({
    required String codigo,
    required String nombre,
    String? clienteId,
    String? cliente,
  }) async {
    await into(expedientes).insert(
      ExpedientesCompanion.insert(
        tenantId: Value(activeTenantId),
        id: _uuid.v4(),
        codigo: codigo,
        nombre: nombre,
        cliente: Value(cliente ?? ''),
        clienteId: clienteId == null ? const Value.absent() : Value(clienteId),
      ),
    );
  }

  Stream<List<Expediente>> observarExpedientes() {
    return (select(expedientes)
          ..where(
            (t) =>
                t.tenantId.equals(activeTenantId) & t.eliminado.equals(false),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.fechaCreacion)]))
        .watch();
  }

  Future<Expediente?> obtenerExpediente(String id) {
    return (select(expedientes)
          ..where((t) => t.tenantId.equals(activeTenantId) & t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<void> actualizarExpediente({
    required String id,
    required String codigo,
    required String nombre,
    String? clienteId,
    String? cliente,
    required String direccion,
    required String poblacion,
    required String provincia,
    required String codigoPostal,
  }) async {
    await (update(
      expedientes,
    )..where((t) => t.tenantId.equals(activeTenantId) & t.id.equals(id))).write(
      ExpedientesCompanion(
        codigo: Value(codigo),
        nombre: Value(nombre),
        cliente: Value(cliente ?? ''),
        clienteId: Value(clienteId),
        direccion: Value(direccion),
        poblacion: Value(poblacion),
        provincia: Value(provincia),
        codigoPostal: Value(codigoPostal),
        fechaModificacion: Value(DateTime.now()),
      ),
    );
  }

  Future<void> crearCliente({
    required String nombre,
    required String apellidos,
    required String nif,
    required String telefono,
    required String email,
    required String direccion,
    required String poblacion,
    required String provincia,
    required String codigoPostal,
    required String pais,
    required String empresa,
    required String observaciones,
  }) async {
    await into(clientes).insert(
      ClientesCompanion(
        tenantId: Value(activeTenantId),
        id: Value(_uuid.v4()),
        nombre: Value(nombre),
        apellidos: Value(apellidos),
        nif: Value(nif),
        telefono: Value(telefono),
        email: Value(email),
        direccion: Value(direccion),
        poblacion: Value(poblacion),
        provincia: Value(provincia),
        codigoPostal: Value(codigoPostal),
        pais: Value(pais),
        empresa: Value(empresa),
        observaciones: Value(observaciones),
      ),
    );
  }

  Stream<List<Cliente>> observarClientes() {
    return (select(clientes)
          ..where(
            (t) =>
                t.tenantId.equals(activeTenantId) & t.eliminado.equals(false),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.fechaCreacion)]))
        .watch();
  }

  Future<Cliente?> obtenerCliente(String id) {
    return (select(clientes)
          ..where((t) => t.tenantId.equals(activeTenantId) & t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<void> actualizarCliente({
    required String id,
    required String nombre,
    required String apellidos,
    required String nif,
    required String telefono,
    required String email,
    required String direccion,
    required String poblacion,
    required String provincia,
    required String codigoPostal,
    required String pais,
    required String empresa,
    required String observaciones,
  }) async {
    await (update(
      clientes,
    )..where((t) => t.tenantId.equals(activeTenantId) & t.id.equals(id))).write(
      ClientesCompanion(
        nombre: Value(nombre),
        apellidos: Value(apellidos),
        nif: Value(nif),
        telefono: Value(telefono),
        email: Value(email),
        direccion: Value(direccion),
        poblacion: Value(poblacion),
        provincia: Value(provincia),
        codigoPostal: Value(codigoPostal),
        pais: Value(pais),
        empresa: Value(empresa),
        observaciones: Value(observaciones),
        fechaModificacion: Value(DateTime.now()),
      ),
    );
  }
}

LazyDatabase _openConnection(File? requestedFile, AppEnvironment environment) {
  return LazyDatabase(() async {
    final file =
        requestedFile ??
        (await EnvironmentPaths.resolve(environment)).databaseFile;
    await file.parent.create(recursive: true);
    await const PreMigrationRecoveryService().protectBeforeUpgrade(
      file,
      supportedVersions: {22, 23, 24, 25, 26, 27, 28, 29, 30, 31},
    );
    return NativeDatabase(file);
  });
}

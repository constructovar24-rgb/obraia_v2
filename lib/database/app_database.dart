import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
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
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase()
    : tenantContext = TenantContext(),
      _initialTenantId = null,
      super(_openConnection());

  AppDatabase.forTesting(
    super.executor, {
    String tenantId = '00000000-0000-4000-8000-000000000023',
  }) : tenantContext = TenantContext(initialTenantId: tenantId),
       _initialTenantId = tenantId;

  final TenantContext tenantContext;
  final String? _initialTenantId;

  String get activeTenantId => tenantContext.requireTenantId();

  Future<void> ensureReady() => customSelect('SELECT 1').getSingle();

  static Future<File> defaultDatabaseFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File(p.join(directory.path, 'obraia.sqlite'));
  }

  @override
  int get schemaVersion => 23;

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

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final file = await AppDatabase.defaultDatabaseFile();
    await const PreMigrationRecoveryService().protectV22(file);
    return NativeDatabase(file);
  });
}

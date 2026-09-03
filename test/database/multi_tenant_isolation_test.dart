import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/core/tenant/tenant_context.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/database/database_lifecycle_controller.dart';
import 'package:obraia_v2/database/database_provider.dart';
import 'package:obraia_v2/features/clientes/presentation/providers/cliente_providers.dart';
import 'package:obraia_v2/features/configuracion/data/empresa_configuracion_repository.dart';
import 'package:obraia_v2/features/dashboard/data/dashboard_repository.dart';
import 'package:obraia_v2/features/search/data/search_repository.dart';

const tenantA = '00000000-0000-4000-8000-000000000023';
const tenantB = '00000000-0000-4000-8000-000000000024';
const businessTables = <String>[
  'clientes',
  'expedientes',
  'presupuestos',
  'lineas_presupuesto',
  'empresa_configuracion',
  'facturas',
  'factura_lineas',
  'cobros',
  'proveedores',
  'compras',
  'certificaciones',
  'documentos',
  'timeline_events',
  'factura_asignaciones_presupuesto',
  'factura_documentos_emitidos',
  'movimientos_credito_cliente',
];

void main() {
  late AppDatabase database;

  setUp(() async {
    database = AppDatabase.forTesting(
      NativeDatabase.memory(),
      tenantId: tenantA,
    );
    await database.ensureReady();
    await database
        .into(database.tenants)
        .insert(
          TenantsCompanion.insert(
            id: tenantB,
            nombre: 'Empresa B',
            fechaCreacion: DateTime.utc(2026),
            fechaModificacion: DateTime.utc(2026),
          ),
        );
  });

  tearDown(() => database.close());

  test(
    'las 16 tablas tienen tenant obligatorio, FK e índice tenant-first',
    () async {
      for (final table in businessTables) {
        final columns = await database
            .customSelect('PRAGMA table_info($table)')
            .get();
        final tenantColumn = columns.singleWhere(
          (row) => row.read<String>('name') == 'tenant_id',
        );
        expect(tenantColumn.read<int>('notnull'), 1, reason: table);

        final foreignKeys = await database
            .customSelect("PRAGMA foreign_key_list('$table')")
            .get();
        expect(
          foreignKeys.any(
            (row) =>
                row.read<String>('table') == 'tenants' &&
                row.read<String>('from') == 'tenant_id' &&
                row.read<String>('to') == 'id',
          ),
          isTrue,
          reason: table,
        );

        final indexes = await database
            .customSelect("PRAGMA index_list('$table')")
            .get();
        var tenantFirst = false;
        for (final index in indexes) {
          final name = index.read<String>('name');
          final indexedColumns = await database
              .customSelect("PRAGMA index_info('$name')")
              .get();
          if (indexedColumns.isNotEmpty &&
              indexedColumns.first.read<String>('name') == 'tenant_id') {
            tenantFirst = true;
            break;
          }
        }
        expect(tenantFirst, isTrue, reason: table);
      }
    },
  );

  test(
    'los DAOs aíslan lecturas, ids y numeración fiscal por tenant',
    () async {
      await _crearBaseTenant(database, tenantA, 'A', 100);
      database.tenantContext.activate(tenantB);
      await _crearBaseTenant(database, tenantB, 'B', 250);

      expect(
        (await database.clientesDao.observarClientes().first).single.nombre,
        'Construcciones Ejemplo B',
      );
      expect(await database.facturasDao.obtenerMayorNumeroLegal(2026), 1);
      expect(
        await database.facturasDao.obtenerMayorNumeroLegal(2026, serie: 'RECT'),
        1,
      );

      database.tenantContext.activate(tenantA);
      expect(
        (await database.clientesDao.observarClientes().first).single.nombre,
        'Construcciones Ejemplo A',
      );
      expect(
        (await database.presupuestosDao.observarPresupuestos().first)
            .single
            .importeTotal,
        100,
      );
      expect(await database.facturasDao.obtenerMayorNumeroLegal(2026), 1);
      expect(
        await database.facturasDao.obtenerMayorNumeroLegal(2026, serie: 'RECT'),
        1,
      );

      await expectLater(
        database.facturasDao.insertarFactura(
          FacturasCompanion.insert(
            id: 'factura-a-duplicada',
            clienteId: 'cliente-a',
            anioNumeracion: const Value(2026),
            numeroLegal: const Value(1),
            serie: const Value('FAC'),
          ),
        ),
        throwsA(isA<SqliteException>()),
      );
    },
  );

  test('SQLite rechaza relaciones empresariales cross-tenant', () async {
    await _crearBaseTenant(database, tenantA, 'A', 100);
    database.tenantContext.activate(tenantB);
    await _crearBaseTenant(database, tenantB, 'B', 200);

    for (final statement in <String>[
      "INSERT INTO expedientes (tenant_id,id,codigo,nombre,cliente,cliente_id) VALUES ('$tenantA','cross-exp','X','X','','cliente-b')",
      "INSERT INTO presupuestos (tenant_id,id,expediente_id) VALUES ('$tenantA','cross-pre','expediente-b')",
      "INSERT INTO facturas (tenant_id,id,cliente_id,presupuesto_origen_id) VALUES ('$tenantA','cross-fac','cliente-a','presupuesto-b')",
      "INSERT INTO cobros (tenant_id,id,factura_id) VALUES ('$tenantA','cross-cob','factura-b')",
      "INSERT INTO facturas (tenant_id,id,cliente_id,tipo_documento,factura_rectificada_id,factura_raiz_id) VALUES ('$tenantA','cross-rect','cliente-a','rectificativa','factura-b','factura-b')",
      "INSERT INTO compras (tenant_id,id,expediente_id,proveedor_id,concepto) VALUES ('$tenantA','cross-com-exp','expediente-b','proveedor-a','X')",
      "INSERT INTO compras (tenant_id,id,expediente_id,proveedor_id,concepto) VALUES ('$tenantA','cross-com-pro','expediente-a','proveedor-b','X')",
      "INSERT INTO documentos (tenant_id,id,expediente_id,titulo,nombre_archivo,ruta_archivo,tamano_bytes) VALUES ('$tenantA','cross-doc','expediente-b','X','x','x',1)",
      "INSERT INTO timeline_events (tenant_id,id,expediente_id,tipo,titulo) VALUES ('$tenantA','cross-tim','expediente-b','sistema','X')",
      "INSERT INTO movimientos_credito_cliente (tenant_id,id,cliente_id,factura_raiz_origen_id,tipo_movimiento,importe,fecha,factura_raiz_destino_id,motivo) VALUES ('$tenantA','cross-cre','cliente-a','factura-a','compensacion',1,0,'factura-b','X')",
    ]) {
      await expectLater(
        database.customStatement(statement),
        throwsA(
          isA<SqliteException>().having(
            (error) => error.message,
            'message',
            contains('FOREIGN KEY constraint failed'),
          ),
        ),
      );
    }
  });

  test('un contexto ausente falla de forma explícita', () async {
    database.tenantContext.clear();
    await expectLater(
      database.clientesDao.obtenerCliente('cliente-a'),
      throwsA(isA<MissingTenantContextException>()),
    );
  });

  test(
    'conocer ids de otro tenant no permite leer, actualizar ni borrar',
    () async {
      await _crearBaseTenant(database, tenantA, 'A', 100);
      await _crearBaseTenant(database, tenantB, 'B', 250);

      database.tenantContext.activate(tenantA);
      expect(await database.clientesDao.obtenerCliente('cliente-b'), isNull);
      expect(
        await database.expedientesDao.obtenerExpediente('expediente-b'),
        isNull,
      );
      expect(
        await database.presupuestosDao.obtenerPorId('presupuesto-b'),
        isNull,
      );
      expect(await database.facturasDao.obtenerPorId('factura-b'), isNull);
      expect(await database.cobrosDao.obtenerPorId('cobro-b'), isNull);
      expect(
        await database.proveedoresDao.obtenerProveedor('proveedor-b'),
        isNull,
      );
      expect(
        await database.comprasDao.obtenerPorExpediente('expediente-b'),
        isEmpty,
      );
      expect(
        await database.certificacionesDao.obtenerCertificacion(
          'certificacion-b',
        ),
        isNull,
      );
      expect(
        await database.documentosDao.obtenerDocumento('documento-b'),
        isNull,
      );
      expect(
        await database.timelineEventsDao.obtenerPorExpediente('expediente-b'),
        isEmpty,
      );

      await database.clientesDao.actualizarCliente(
        'cliente-b',
        const ClientesCompanion(nombre: Value('Intrusión')),
      );
      await database.comprasDao.eliminarLogicamente('compra-b');

      database.tenantContext.activate(tenantB);
      expect(
        (await database.clientesDao.obtenerCliente('cliente-b'))!.nombre,
        'Construcciones Ejemplo B',
      );
      expect(
        (await database.comprasDao.obtenerPorExpediente(
          'expediente-b',
        )).single.eliminado,
        isFalse,
      );
    },
  );

  test('búsqueda y dashboard solo agregan el tenant activo', () async {
    await _crearBaseTenant(database, tenantA, 'A', 100);
    database.tenantContext.activate(tenantB);
    await _crearBaseTenant(database, tenantB, 'B', 250);
    final lifecycle = DatabaseLifecycleController(
      initialDatabase: database,
      databaseFactory: () => database,
      activeDatabasePathResolver: () async => '',
    );
    final container = ProviderContainer(
      overrides: [
        databaseLifecycleControllerProvider.overrideWith((ref) => lifecycle),
      ],
    );
    addTearDown(container.dispose);

    var sections = await container
        .read(searchRepositoryProvider)
        .observarResultados('Construcciones Ejemplo')
        .first;
    var items = sections.expand((section) => section.items).toList();
    expect(items, hasLength(4));
    expect(items.every((item) => item.id.endsWith('-b')), isTrue);
    var dashboard = await container
        .read(dashboardRepositoryProvider)
        .observarResumen()
        .first;
    expect(dashboard.numeroExpedientes, 1);
    expect(dashboard.totalPresupuestado, 250);

    database.tenantContext.activate(tenantA);
    sections = await container
        .read(searchRepositoryProvider)
        .observarResultados('Construcciones Ejemplo')
        .first;
    items = sections.expand((section) => section.items).toList();
    expect(items, hasLength(4));
    expect(items.every((item) => item.id.endsWith('-a')), isTrue);
    dashboard = await container
        .read(dashboardRepositoryProvider)
        .observarResumen()
        .first;
    expect(dashboard.numeroExpedientes, 1);
    expect(dashboard.totalPresupuestado, 100);
  });

  test(
    'los providers invalidan sus streams al cambiar TenantContext',
    () async {
      await _crearBaseTenant(database, tenantA, 'A', 100);
      await _crearBaseTenant(database, tenantB, 'B', 250);
      final lifecycle = DatabaseLifecycleController(
        initialDatabase: database,
        databaseFactory: () => database,
        activeDatabasePathResolver: () async => '',
      );
      final container = ProviderContainer(
        overrides: [
          databaseLifecycleControllerProvider.overrideWith((ref) => lifecycle),
        ],
      );
      addTearDown(container.dispose);

      expect(
        (await container.read(clientesProvider.future)).single.id,
        'cliente-b',
      );
      database.tenantContext.activate(tenantA);
      expect(
        (await container.read(clientesProvider.future)).single.id,
        'cliente-a',
      );
    },
  );

  test('cada tenant crea y resuelve su configuración empresarial', () async {
    final repository = EmpresaConfiguracionRepository(database);
    final configuracionA = await repository.obtenerOCrearConfiguracion();
    await repository.guardarConfiguracion(
      nombreEmpresa: 'Empresa A',
      cif: 'A00000001',
      direccion: '',
      codigoPostal: '',
      poblacion: '',
      provincia: '',
      telefono: '',
      email: '',
      web: '',
    );

    database.tenantContext.activate(tenantB);
    final configuracionB = await repository.obtenerOCrearConfiguracion();
    await repository.guardarConfiguracion(
      nombreEmpresa: 'Empresa B',
      cif: 'B00000002',
      direccion: '',
      codigoPostal: '',
      poblacion: '',
      provincia: '',
      telefono: '',
      email: '',
      web: '',
    );

    expect(configuracionB.id, isNot(configuracionA.id));
    expect(
      (await repository.obtenerOCrearConfiguracion()).nombreEmpresa,
      'Empresa B',
    );
    database.tenantContext.activate(tenantA);
    expect(
      (await repository.obtenerOCrearConfiguracion()).nombreEmpresa,
      'Empresa A',
    );
  });
}

Future<void> _crearBaseTenant(
  AppDatabase database,
  String tenantId,
  String suffix,
  double presupuesto,
) async {
  database.tenantContext.activate(tenantId);
  final lower = suffix.toLowerCase();
  await database.clientesDao.insertarCliente(
    ClientesCompanion.insert(
      id: 'cliente-$lower',
      nombre: 'Construcciones Ejemplo $suffix',
    ),
  );
  await database.expedientesDao.insertarExpediente(
    ExpedientesCompanion.insert(
      id: 'expediente-$lower',
      codigo: 'EXP-$suffix',
      nombre: 'Obra $suffix',
      clienteId: Value('cliente-$lower'),
    ),
  );
  await database.presupuestosDao.insertarPresupuesto(
    PresupuestosCompanion.insert(
      id: 'presupuesto-$lower',
      expedienteId: 'expediente-$lower',
      importeTotal: Value(presupuesto),
    ),
  );
  await database.proveedoresDao.insertarProveedor(
    ProveedoresCompanion.insert(
      id: 'proveedor-$lower',
      nombre: 'Proveedor $suffix',
    ),
  );
  await database.facturasDao.insertarFactura(
    FacturasCompanion.insert(
      id: 'factura-$lower',
      clienteId: 'cliente-$lower',
      presupuestoOrigenId: Value('presupuesto-$lower'),
      serie: const Value('FAC'),
      anioNumeracion: const Value(2026),
      numeroLegal: const Value(1),
      subtotal: Value(presupuesto),
      total: Value(presupuesto),
    ),
  );
  await database.facturasDao.insertarFactura(
    FacturasCompanion.insert(
      id: 'rect-$lower',
      clienteId: 'cliente-$lower',
      tipoDocumento: const Value('rectificativa'),
      serie: const Value('RECT'),
      anioNumeracion: const Value(2026),
      numeroLegal: const Value(1),
      facturaRectificadaId: Value('factura-$lower'),
      facturaRaizId: Value('factura-$lower'),
    ),
  );
  await database.cobrosDao.insertarCobro(
    CobrosCompanion.insert(
      id: 'cobro-$lower',
      facturaId: 'factura-$lower',
      importe: const Value(10),
    ),
  );
  await database.comprasDao.insertarCompra(
    ComprasCompanion.insert(
      id: 'compra-$lower',
      expedienteId: 'expediente-$lower',
      proveedorId: Value('proveedor-$lower'),
      concepto: Value('Compra $suffix'),
      importeTotal: Value(presupuesto / 2),
    ),
  );
  await database.certificacionesDao.insertarCertificacion(
    CertificacionesCompanion.insert(
      id: 'certificacion-$lower',
      expedienteId: 'expediente-$lower',
      presupuestoId: Value('presupuesto-$lower'),
    ),
  );
  await database.documentosDao.insertarDocumento(
    DocumentosCompanion.insert(
      id: 'documento-$lower',
      expedienteId: 'expediente-$lower',
      titulo: 'Documento $suffix',
      nombreArchivo: '$lower.pdf',
      rutaArchivo: '$lower.pdf',
      tamanoBytes: 1,
    ),
  );
  await database.timelineEventsDao.insertar(
    TimelineEventsCompanion.insert(
      id: 'timeline-$lower',
      expedienteId: 'expediente-$lower',
      tipo: 'notaCreada',
      titulo: Value('Evento $suffix'),
    ),
  );
}

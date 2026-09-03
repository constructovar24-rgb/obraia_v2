import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/core/tenant/tenant_context.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/database/database_lifecycle_controller.dart';
import 'package:obraia_v2/database/database_provider.dart';
import 'package:obraia_v2/features/dashboard/data/dashboard_repository.dart';
import 'package:obraia_v2/features/search/data/search_repository.dart';

const tenantA = '00000000-0000-4000-8000-000000000023';
const tenantB = '00000000-0000-4000-8000-000000000024';

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
}

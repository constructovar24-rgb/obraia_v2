import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
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

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
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
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  static Future<File> defaultDatabaseFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File(p.join(directory.path, 'obraia.sqlite'));
  }

  @override
  int get schemaVersion => 20;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await customStatement('''
        CREATE UNIQUE INDEX IF NOT EXISTS facturas_numeracion_legal_unica
        ON facturas(anio_numeracion, numero_legal)
        WHERE anio_numeracion IS NOT NULL AND numero_legal IS NOT NULL
      ''');
      await customStatement('''
        CREATE INDEX IF NOT EXISTS factura_asignaciones_presupuesto_idx
        ON factura_asignaciones_presupuesto(presupuesto_id)
      ''');
      await customStatement('''
        CREATE INDEX IF NOT EXISTS factura_asignaciones_factura_idx
        ON factura_asignaciones_presupuesto(factura_id)
      ''');
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
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  final _uuid = const Uuid();

  Future<void> crearExpediente({
    required String codigo,
    required String nombre,
    String? clienteId,
    String? cliente,
  }) async {
    await into(expedientes).insert(
      ExpedientesCompanion.insert(
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
          ..where((t) => t.eliminado.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.fechaCreacion)]))
        .watch();
  }

  Future<Expediente?> obtenerExpediente(String id) {
    return (select(
      expedientes,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
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
    await (update(expedientes)..where((t) => t.id.equals(id))).write(
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
          ..where((t) => t.eliminado.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.fechaCreacion)]))
        .watch();
  }

  Future<Cliente?> obtenerCliente(String id) {
    return (select(clientes)..where((t) => t.id.equals(id))).getSingleOrNull();
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
    await (update(clientes)..where((t) => t.id.equals(id))).write(
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
    return NativeDatabase(await AppDatabase.defaultDatabaseFile());
  });
}

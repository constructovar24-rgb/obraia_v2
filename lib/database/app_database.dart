import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'tables/expedientes.dart';
import 'tables/clientes.dart';
import 'tables/presupuestos.dart';
import 'dao/expedientes_dao.dart';
import 'dao/clientes_dao.dart';
import 'dao/presupuestos_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Expedientes,
    Clientes,
    Presupuestos,
  ],
  daos: [
    ExpedientesDao,
    ClientesDao,
    PresupuestosDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(expedientes, expedientes.clienteId);
          }

          if (from < 3) {
            await m.createTable(presupuestos);
          }
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
        clienteId: clienteId == null
            ? const Value.absent()
            : Value(clienteId),
      ),
    );
  }

  Stream<List<Expediente>> observarExpedientes() {
    return (select(expedientes)
          ..where((t) => t.eliminado.equals(false))
          ..orderBy([
            (t) => OrderingTerm.desc(t.fechaCreacion),
          ]))
        .watch();
  }

  Future<Expediente?> obtenerExpediente(String id) {
    return (select(expedientes)
          ..where((t) => t.id.equals(id)))
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
          ..orderBy([
            (t) => OrderingTerm.desc(t.fechaCreacion),
          ]))
        .watch();
  }

  Future<Cliente?> obtenerCliente(String id) {
    return (select(clientes)
          ..where((t) => t.id.equals(id)))
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
    final dir = await getApplicationDocumentsDirectory();

    final file = File(
      p.join(dir.path, 'obraia.sqlite'),
    );

    print('========================================');
    print('BASE DE DATOS: ${file.path}');
    print('========================================');

    return NativeDatabase(file);
  });
}
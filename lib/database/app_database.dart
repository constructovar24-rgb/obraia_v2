import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'tables/expedientes.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Expedientes,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  final _uuid = const Uuid();

  Future<void> crearExpediente({
    required String codigo,
    required String nombre,
  }) async {
    await into(expedientes).insert(
      ExpedientesCompanion.insert(
        id: _uuid.v4(),
        codigo: codigo,
        nombre: nombre,
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
    required String cliente,
    required String direccion,
    required String poblacion,
    required String provincia,
    required String codigoPostal,
  }) async {
    await (update(expedientes)..where((t) => t.id.equals(id))).write(
      ExpedientesCompanion(
        codigo: Value(codigo),
        nombre: Value(nombre),
        cliente: Value(cliente),
        direccion: Value(direccion),
        poblacion: Value(poblacion),
        provincia: Value(provincia),
        codigoPostal: Value(codigoPostal),
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
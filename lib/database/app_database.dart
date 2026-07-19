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
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();

    final file = File(
      p.join(dir.path, 'obraia.sqlite'),
    );

    return NativeDatabase(file);
  });
}
import 'package:drift/drift.dart';

import '../../features/expedientes/domain/expediente.dart' as expediente_domain;
import '../app_database.dart';
import '../tables/clientes.dart';
import '../tables/expedientes.dart';

part 'expedientes_dao.g.dart';

@DriftAccessor(tables: [Expedientes, Clientes])
class ExpedientesDao extends DatabaseAccessor<AppDatabase>
    with _$ExpedientesDaoMixin {
  ExpedientesDao(super.db);

  Stream<List<expediente_domain.Expediente>> observarExpedientes() {
    final table = attachedDatabase.expedientes;
    final clientes = attachedDatabase.clientes;

    final query = select(table).join([
      leftOuterJoin(clientes, clientes.id.equalsExp(table.clienteId)),
    ])
      ..where(
        table.eliminado.equals(false) &
            table.estado.equals(
              expediente_domain.expedienteEstadoCicloToDbValue(
                expediente_domain.ExpedienteEstadoCiclo.activo,
              ),
            ),
      )
      ..orderBy([OrderingTerm.desc(table.fechaCreacion)]);

    return query.watch().map((rows) {
      return rows.map((row) {
        final expediente = row.readTable(table);
        final cliente = row.readTableOrNull(clientes);

        return expediente_domain.Expediente(
          id: expediente.id,
          codigo: expediente.codigo,
          nombre: expediente.nombre,
          estadoCiclo: expediente_domain.expedienteEstadoCicloFromDbValue(
            expediente.estado,
          ),
          clienteId: expediente.clienteId,
          clienteNombre: cliente?.nombre ?? '',
        );
      }).toList();
    });
  }

  Future<expediente_domain.Expediente?> obtenerExpediente(String id) async {
    final table = attachedDatabase.expedientes;
    final clientes = attachedDatabase.clientes;

    final query = select(table).join([
      leftOuterJoin(clientes, clientes.id.equalsExp(table.clienteId)),
    ])
      ..where(table.id.equals(id));

    final row = await query.getSingleOrNull();

    if (row == null) {
      return null;
    }

    final expediente = row.readTable(table);
    final cliente = row.readTableOrNull(clientes);

    return expediente_domain.Expediente(
      id: expediente.id,
      codigo: expediente.codigo,
      nombre: expediente.nombre,
      estadoCiclo: expediente_domain.expedienteEstadoCicloFromDbValue(
        expediente.estado,
      ),
      clienteId: expediente.clienteId,
      clienteNombre: cliente?.nombre ?? '',
    );
  }

  Future<void> archivarExpediente(String id) async {
    final table = attachedDatabase.expedientes;

    await (update(table)..where((t) => t.id.equals(id))).write(
      ExpedientesCompanion(
        estado: Value(
          expediente_domain.expedienteEstadoCicloToDbValue(
            expediente_domain.ExpedienteEstadoCiclo.archivado,
          ),
        ),
        fechaModificacion: Value(DateTime.now()),
      ),
    );
  }

  Future<void> insertarExpediente(ExpedientesCompanion expediente) async {
    final table = attachedDatabase.expedientes;

    await into(table).insert(expediente);
  }

  Future<void> actualizarExpediente(
    String id,
    ExpedientesCompanion companion,
  ) async {
    final table = attachedDatabase.expedientes;

    await (update(table)
          ..where((t) => t.id.equals(id)))
        .write(companion);
  }

  Future<void> eliminarLogicamente(
    String id,
  ) async {
    final table = attachedDatabase.expedientes;

    await (update(table)
          ..where((t) => t.id.equals(id)))
        .write(
      const ExpedientesCompanion(
        eliminado: Value(true),
      ),
    );
  }
}
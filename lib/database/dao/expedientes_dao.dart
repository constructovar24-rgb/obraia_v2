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
    return _observarExpedientesPorEstado(
      expediente_domain.ExpedienteEstadoCiclo.activo,
    );
  }

  Stream<List<expediente_domain.Expediente>> observarExpedientesArchivados() {
    return _observarExpedientesPorEstado(
      expediente_domain.ExpedienteEstadoCiclo.archivado,
    );
  }

  Stream<List<expediente_domain.Expediente>> observarPorCliente(
    String clienteId,
  ) {
    final table = attachedDatabase.expedientes;
    final clientes = attachedDatabase.clientes;
    final query =
        select(table).join([
            leftOuterJoin(clientes, clientes.id.equalsExp(table.clienteId)),
          ])
          ..where(
            table.eliminado.equals(false) & table.clienteId.equals(clienteId),
          )
          ..orderBy([OrderingTerm.desc(table.fechaCreacion)]);

    return query.watch().map(
      (rows) => rows.map((row) {
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
          clienteNombre: _nombreCompletoCliente(cliente),
        );
      }).toList(),
    );
  }

  Future<expediente_domain.Expediente?> obtenerExpediente(String id) async {
    return observarExpediente(id).first;
  }

  Stream<expediente_domain.Expediente?> observarExpediente(String id) {
    final table = attachedDatabase.expedientes;
    final clientes = attachedDatabase.clientes;

    final query = select(table).join([
      leftOuterJoin(clientes, clientes.id.equalsExp(table.clienteId)),
    ])..where(table.id.equals(id));

    return query.watchSingleOrNull().map((row) {
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
        clienteNombre: _nombreCompletoCliente(cliente),
      );
    });
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

  Future<void> restaurarExpediente(String id) async {
    final table = attachedDatabase.expedientes;

    await (update(table)..where((t) => t.id.equals(id))).write(
      ExpedientesCompanion(
        estado: Value(
          expediente_domain.expedienteEstadoCicloToDbValue(
            expediente_domain.ExpedienteEstadoCiclo.activo,
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

  Future<int> actualizarExpediente(String id, ExpedientesCompanion companion) {
    final table = attachedDatabase.expedientes;

    return (update(table)..where((t) => t.id.equals(id))).write(companion);
  }

  Future<void> eliminarLogicamente(String id) async {
    final table = attachedDatabase.expedientes;

    await (update(table)..where((t) => t.id.equals(id))).write(
      const ExpedientesCompanion(eliminado: Value(true)),
    );
  }

  Stream<List<expediente_domain.Expediente>> _observarExpedientesPorEstado(
    expediente_domain.ExpedienteEstadoCiclo estadoCiclo,
  ) {
    final table = attachedDatabase.expedientes;
    final clientes = attachedDatabase.clientes;
    final estadoDb = expediente_domain.expedienteEstadoCicloToDbValue(
      estadoCiclo,
    );

    final query =
        select(table).join([
            leftOuterJoin(clientes, clientes.id.equalsExp(table.clienteId)),
          ])
          ..where(table.eliminado.equals(false) & table.estado.equals(estadoDb))
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
          clienteNombre: _nombreCompletoCliente(cliente),
        );
      }).toList();
    });
  }

  String _nombreCompletoCliente(Cliente? cliente) {
    if (cliente == null) return '';
    return '${cliente.nombre} ${cliente.apellidos}'.trim();
  }
}

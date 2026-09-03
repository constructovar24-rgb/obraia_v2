import 'package:drift/drift.dart';
import 'package:obraia_v2/features/clientes/domain/cliente.dart'
    as cliente_domain;

import '../app_database.dart';
import '../tables/clientes.dart';

part 'clientes_dao.g.dart';

@DriftAccessor(tables: [Clientes])
class ClientesDao extends DatabaseAccessor<AppDatabase>
    with _$ClientesDaoMixin {
  ClientesDao(super.db);

  Stream<List<cliente_domain.Cliente>> observarClientes() {
    return (select(clientes)
          ..where(
            (t) =>
                t.tenantId.equals(attachedDatabase.activeTenantId) &
                t.eliminado.equals(false),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.fechaCreacion)]))
        .watch()
        .map(
          (rows) => rows
              .map(
                (row) => cliente_domain.Cliente(
                  id: row.id,
                  nombre: row.nombre,
                  apellidos: row.apellidos,
                  nif: row.nif,
                  telefono: row.telefono,
                  email: row.email,
                  direccion: row.direccion,
                  poblacion: row.poblacion,
                  provincia: row.provincia,
                  codigoPostal: row.codigoPostal,
                  pais: row.pais,
                  empresa: row.empresa,
                  observaciones: row.observaciones,
                  estado: row.estado,
                  eliminado: row.eliminado,
                  fechaCreacion: row.fechaCreacion,
                  fechaModificacion: row.fechaModificacion,
                ),
              )
              .toList(),
        );
  }

  Future<cliente_domain.Cliente?> obtenerCliente(String id) async {
    final row =
        await (select(clientes)..where(
              (t) =>
                  t.tenantId.equals(attachedDatabase.activeTenantId) &
                  t.id.equals(id),
            ))
            .getSingleOrNull();

    if (row == null) {
      return null;
    }

    return cliente_domain.Cliente(
      id: row.id,
      nombre: row.nombre,
      apellidos: row.apellidos,
      nif: row.nif,
      telefono: row.telefono,
      email: row.email,
      direccion: row.direccion,
      poblacion: row.poblacion,
      provincia: row.provincia,
      codigoPostal: row.codigoPostal,
      pais: row.pais,
      empresa: row.empresa,
      observaciones: row.observaciones,
      estado: row.estado,
      eliminado: row.eliminado,
      fechaCreacion: row.fechaCreacion,
      fechaModificacion: row.fechaModificacion,
    );
  }

  Future<void> insertarCliente(ClientesCompanion cliente) async {
    await into(clientes).insert(
      cliente.copyWith(tenantId: Value(attachedDatabase.activeTenantId)),
    );
  }

  Future<void> actualizarCliente(String id, ClientesCompanion companion) async {
    await (update(clientes)..where(
          (t) =>
              t.tenantId.equals(attachedDatabase.activeTenantId) &
              t.id.equals(id),
        ))
        .write(companion);
  }

  Future<void> eliminarLogicamente(String id) async {
    await (update(clientes)..where(
          (t) =>
              t.tenantId.equals(attachedDatabase.activeTenantId) &
              t.id.equals(id),
        ))
        .write(const ClientesCompanion(eliminado: Value(true)));
  }
}

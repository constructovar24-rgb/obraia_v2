import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/database/database_provider.dart';
import 'package:obraia_v2/features/expedientes/domain/expediente.dart'
    as expediente_domain;
import 'package:obraia_v2/features/timeline/data/timeline_repository.dart';
import 'package:uuid/uuid.dart';

final expedienteRepositoryProvider = Provider<ExpedienteRepository>((ref) {
  final database = ref.read(databaseProvider);
  return ExpedienteRepository(database);
});

final expedienteGestionAccionProvider =
    FutureProvider.family<ExpedienteGestionAccion, String>((ref, expedienteId) {
  final repository = ref.read(expedienteRepositoryProvider);
  return repository.obtenerAccionGestionExpediente(expedienteId);
});

enum ExpedienteGestionAccion {
  eliminar,
  archivar,
}

class ExpedienteRepository {
  final AppDatabase database;
  final TimelineRepository _timelineRepository;
  final Uuid _uuid;

  ExpedienteRepository(this.database)
      : _timelineRepository = TimelineRepository(database.timelineEventsDao),
        _uuid = const Uuid();

  Future<void> crearExpediente({
    required String codigo,
    required String nombre,
    String? clienteId,
    String? cliente,
  }) async {
    final expedienteId = _uuid.v4();

    await database.expedientesDao.insertarExpediente(
      ExpedientesCompanion.insert(
        id: expedienteId,
        codigo: codigo,
        nombre: nombre,
        cliente: Value(cliente ?? ''),
        clienteId: clienteId == null
            ? const Value.absent()
            : Value(clienteId),
      ),
    );

    await _timelineRepository.registrarExpedienteCreado(
      expedienteId: expedienteId,
      titulo: codigo,
      descripcion: nombre,
    );
  }

  Stream<List<expediente_domain.Expediente>> observarExpedientes() {
    return database.expedientesDao.observarExpedientes();
  }

  Future<expediente_domain.Expediente?> obtenerExpediente(String id) {
    return database.expedientesDao.obtenerExpediente(id);
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
    await database.actualizarExpediente(
      id: id,
      codigo: codigo,
      nombre: nombre,
      clienteId: clienteId,
      cliente: cliente,
      direccion: direccion,
      poblacion: poblacion,
      provincia: provincia,
      codigoPostal: codigoPostal,
    );

    await _timelineRepository.registrarExpedienteActualizado(
      expedienteId: id,
      titulo: codigo,
      descripcion: nombre,
    );
  }

  Future<ExpedienteGestionAccion> obtenerAccionGestionExpediente(
    String expedienteId,
  ) async {
    final tieneActividad = await _tieneActividadRelacionada(expedienteId);

    return tieneActividad
        ? ExpedienteGestionAccion.archivar
        : ExpedienteGestionAccion.eliminar;
  }

  Future<void> gestionarExpediente(String expedienteId) async {
    final accion = await obtenerAccionGestionExpediente(expedienteId);

    switch (accion) {
      case ExpedienteGestionAccion.eliminar:
        await eliminarExpediente(expedienteId);
        break;
      case ExpedienteGestionAccion.archivar:
        await archivarExpediente(expedienteId);
        break;
    }
  }

  Future<void> eliminarExpediente(String id) {
    return database.expedientesDao.eliminarLogicamente(id);
  }

  Future<void> archivarExpediente(String id) {
    return database.expedientesDao.archivarExpediente(id);
  }

  Future<bool> _tieneActividadRelacionada(String expedienteId) async {
    if (await _tieneRegistros(
      () => database.presupuestosDao.observarPorExpediente(expedienteId).first,
    )) {
      return true;
    }

    if (await _tieneRegistros(
      () => database.facturasDao.observarPorExpediente(expedienteId).first,
    )) {
      return true;
    }

    if (await _tieneRegistros(
      () => database.comprasDao.observarPorExpediente(expedienteId).first,
    )) {
      return true;
    }

    if (await _tieneRegistros(
      () => database.documentosDao.observarPorExpediente(expedienteId).first,
    )) {
      return true;
    }

    if (await _tieneRegistros(
      () => database.certificacionesDao.observarPorExpediente(expedienteId).first,
    )) {
      return true;
    }

    return false;
  }

  Future<bool> _tieneRegistros<T>(Future<List<T>> Function() consulta) async {
    final registros = await consulta();
    return registros.isNotEmpty;
  }
}
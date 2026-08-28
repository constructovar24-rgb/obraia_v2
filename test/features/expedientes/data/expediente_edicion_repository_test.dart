import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/features/expedientes/data/expediente_repository.dart';
import 'package:obraia_v2/features/timeline/domain/timeline_event.dart';

void main() {
  late AppDatabase database;
  late ExpedienteRepository repository;
  final fechaCreacion = DateTime(2024, 1, 2, 9, 30);
  final fechaModificacion = DateTime(2024, 1, 3, 10, 45);

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = ExpedienteRepository(database);

    await database.clientesDao.insertarCliente(
      ClientesCompanion.insert(
        id: 'cliente-1',
        nombre: 'Cliente',
        apellidos: const Value('Anterior'),
      ),
    );
    await database.clientesDao.insertarCliente(
      ClientesCompanion.insert(
        id: 'cliente-2',
        nombre: 'Cliente',
        apellidos: const Value('Nuevo'),
      ),
    );
    await database.expedientesDao.insertarExpediente(
      ExpedientesCompanion.insert(
        id: 'expediente-1',
        codigo: 'EXP-001',
        nombre: 'Obra original',
        clienteId: const Value('cliente-1'),
        cliente: const Value('Cliente Anterior'),
        direccion: const Value('Calle conservada'),
        poblacion: const Value('Madrid'),
        provincia: const Value('Madrid'),
        codigoPostal: const Value('28001'),
        pais: const Value('España'),
        estado: const Value(1),
        eliminado: const Value(false),
        fechaCreacion: Value(fechaCreacion),
        fechaModificacion: Value(fechaModificacion),
      ),
    );
  });

  tearDown(() => database.close());

  test('actualizar código y nombre refresca ficha y listado', () async {
    final fichaActualizada = repository
        .observarExpediente('expediente-1')
        .firstWhere((item) => item?.codigo == 'EXP-002');
    final listadoActualizado = repository
        .observarExpedientesArchivados()
        .firstWhere((items) => items.any((item) => item.codigo == 'EXP-002'));

    await _actualizar(repository, codigo: 'EXP-002', nombre: 'Obra editada');

    final ficha = await fichaActualizada;
    final itemListado = (await listadoActualizado).single;
    expect(ficha?.codigo, 'EXP-002');
    expect(ficha?.nombre, 'Obra editada');
    expect(itemListado.codigo, 'EXP-002');
    expect(itemListado.nombre, 'Obra editada');
  });

  test('cambiar cliente refresca ficha y listado', () async {
    await _actualizar(
      repository,
      clienteId: 'cliente-2',
      cliente: 'Cliente Nuevo',
    );

    final ficha = await repository.obtenerExpediente('expediente-1');
    final listado = await repository.observarExpedientesArchivados().first;
    expect(ficha?.clienteId, 'cliente-2');
    expect(ficha?.clienteNombre, 'Cliente Nuevo');
    expect(listado.single.clienteId, 'cliente-2');
    expect(listado.single.clienteNombre, 'Cliente Nuevo');
  });

  test('quitar cliente deja ficha y listado sin cliente', () async {
    await _actualizar(repository, clienteId: null, cliente: null);

    final ficha = await repository.obtenerExpediente('expediente-1');
    final listado = await repository.observarExpedientesArchivados().first;
    final row = await _obtenerFila(database);
    expect(ficha?.clienteId, isNull);
    expect(ficha?.clienteNombre, isEmpty);
    expect(listado.single.clienteId, isNull);
    expect(listado.single.clienteNombre, isEmpty);
    expect(row.clienteId, isNull);
    expect(row.cliente, isEmpty);
  });

  test('conserva todos los campos ajenos a la edición', () async {
    await _actualizar(repository, codigo: 'EXP-002', nombre: 'Obra editada');

    final row = await _obtenerFila(database);
    expect(row.direccion, 'Calle conservada');
    expect(row.poblacion, 'Madrid');
    expect(row.provincia, 'Madrid');
    expect(row.codigoPostal, '28001');
    expect(row.pais, 'España');
    expect(row.estado, 1);
    expect(row.eliminado, isFalse);
    expect(row.fechaCreacion, fechaCreacion);
  });

  test('actualiza fechaModificacion', () async {
    await _actualizar(repository, codigo: 'EXP-002');

    final row = await _obtenerFila(database);
    expect(row.fechaModificacion, isNot(fechaModificacion));
    expect(row.fechaModificacion.isAfter(fechaModificacion), isTrue);
  });

  test('registra exactamente un evento de Timeline', () async {
    await _actualizar(repository, codigo: 'EXP-002', nombre: 'Obra editada');

    final eventos = await database.timelineEventsDao.obtenerPorExpediente(
      'expediente-1',
    );
    expect(eventos, hasLength(1));
    expect(eventos.single.tipo, TimelineEventType.expedienteActualizado.name);
    expect(eventos.single.titulo, 'EXP-002');
    expect(eventos.single.descripcion, 'Obra editada');
  });

  test(
    'revierte la actualización y no registra Timeline si el evento falla',
    () async {
      await database.customStatement('''
      CREATE TRIGGER impedir_timeline
      BEFORE INSERT ON timeline_events
      BEGIN
        SELECT RAISE(ABORT, 'fallo simulado de Timeline');
      END;
    ''');

      await expectLater(
        _actualizar(repository, codigo: 'EXP-ERROR'),
        throwsA(anything),
      );

      final row = await _obtenerFila(database);
      final eventos = await database.timelineEventsDao.obtenerPorExpediente(
        'expediente-1',
      );
      expect(row.codigo, 'EXP-001');
      expect(row.fechaModificacion, fechaModificacion);
      expect(eventos, isEmpty);
    },
  );

  test('rechaza un expediente inexistente sin registrar Timeline', () async {
    await expectLater(
      repository.actualizarDatosPrincipales(
        id: 'expediente-inexistente',
        codigo: 'EXP-404',
        nombre: 'No existe',
      ),
      throwsA(isA<ExpedienteNoEncontradoException>()),
    );

    final eventos = await database.timelineEventsDao.obtenerPorExpediente(
      'expediente-inexistente',
    );
    expect(eventos, isEmpty);
  });
}

Future<void> _actualizar(
  ExpedienteRepository repository, {
  String codigo = 'EXP-001',
  String nombre = 'Obra original',
  String? clienteId = 'cliente-1',
  String? cliente = 'Cliente Anterior',
}) {
  return repository.actualizarDatosPrincipales(
    id: 'expediente-1',
    codigo: codigo,
    nombre: nombre,
    clienteId: clienteId,
    cliente: cliente,
  );
}

Future<Expediente> _obtenerFila(AppDatabase database) {
  return (database.select(
    database.expedientes,
  )..where((table) => table.id.equals('expediente-1'))).getSingle();
}

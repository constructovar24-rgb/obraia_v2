import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/features/clientes/data/cliente_repository.dart';
import 'package:obraia_v2/features/expedientes/data/expediente_repository.dart';
import 'package:obraia_v2/features/presupuestos/data/linea_presupuesto_repository.dart';
import 'package:obraia_v2/features/presupuestos/data/presupuesto_repository.dart';

void main() {
  late AppDatabase database;
  late ClienteRepository clientes;
  late ExpedienteRepository expedientes;
  late PresupuestoRepository presupuestos;
  late LineaPresupuestoRepository lineas;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    clientes = ClienteRepository(database);
    expedientes = ExpedienteRepository(database);
    presupuestos = PresupuestoRepository(database);
    lineas = LineaPresupuestoRepository(database);
  });

  tearDown(() => database.close());

  test(
    'cliente, expediente y presupuesto conservan sus relaciones y totales',
    () async {
      await clientes.crearCliente(
        nombre: 'Constructora',
        apellidos: 'Ejemplo',
        nif: 'B12345678',
        telefono: '',
        email: '',
        direccion: '',
        poblacion: '',
        provincia: '',
        codigoPostal: '',
        pais: 'España',
        empresa: 'Constructora Ejemplo',
        observaciones: '',
      );
      final cliente = (await clientes.observarClientes().first).single;

      await expedientes.crearExpediente(
        codigo: 'EXP-001',
        nombre: 'Reforma completa',
        clienteId: cliente.id,
        cliente: 'Constructora Ejemplo',
      );
      final expediente = (await expedientes.observarExpedientes().first).single;

      await presupuestos.crearPresupuesto(
        expedienteId: expediente.id,
        fecha: DateTime(2026, 8, 29),
        descripcion: 'Oferta inicial',
        estado: 'Borrador',
      );
      final presupuesto =
          (await presupuestos.observarPorExpediente(expediente.id).first)
              .single;

      await lineas.crearLinea(
        presupuestoId: presupuesto.id,
        concepto: 'Demoliciones',
        cantidad: 2,
        precioUnitario: 12.5,
      );
      await lineas.crearLinea(
        presupuestoId: presupuesto.id,
        concepto: 'Albañilería',
        cantidad: 3,
        precioUnitario: 7,
      );

      var presupuestoPersistido = await _obtenerPresupuesto(
        database,
        presupuesto.id,
      );
      expect(presupuestoPersistido.expedienteId, expediente.id);
      expect(presupuestoPersistido.codigo, 'EXP-001-P01');
      expect(presupuestoPersistido.ivaPorcentaje, 21);
      expect(presupuestoPersistido.importeTotal, 46);

      final lineasCreadas = await database.lineasPresupuestoDao
          .obtenerPorPresupuesto(presupuesto.id);
      await lineas.actualizarLinea(
        id: lineasCreadas
            .singleWhere((linea) => linea.concepto == 'Demoliciones')
            .id,
        presupuestoId: presupuesto.id,
        concepto: 'Demoliciones revisadas',
        cantidad: 4,
        precioUnitario: 12.5,
      );
      presupuestoPersistido = await _obtenerPresupuesto(
        database,
        presupuesto.id,
      );
      expect(presupuestoPersistido.importeTotal, 71);

      final clientePersistido = await clientes.obtenerCliente(cliente.id);
      final expedientePersistido = await expedientes.obtenerExpediente(
        expediente.id,
      );
      expect(
        '${clientePersistido?.nombre} ${clientePersistido?.apellidos}'.trim(),
        'Constructora Ejemplo',
      );
      expect(expedientePersistido?.clienteId, cliente.id);
      expect(expedientePersistido?.clienteNombre, 'Constructora Ejemplo');
    },
  );

  test('un fallo al recalcular revierte la alta de línea', () async {
    final presupuestoId = await _crearPresupuestoBase(database);
    await database.customStatement('''
      CREATE TRIGGER impedir_actualizar_total
      BEFORE UPDATE OF importe_total ON presupuestos
      BEGIN
        SELECT RAISE(ABORT, 'fallo simulado al recalcular');
      END;
    ''');

    await expectLater(
      lineas.crearLinea(
        presupuestoId: presupuestoId,
        concepto: 'No debe guardarse',
        cantidad: 1,
        precioUnitario: 100,
      ),
      throwsA(anything),
    );

    expect(
      await database.lineasPresupuestoDao.obtenerPorPresupuesto(presupuestoId),
      isEmpty,
    );
    expect(
      (await _obtenerPresupuesto(database, presupuestoId)).importeTotal,
      0,
    );
  });
}

Future<String> _crearPresupuestoBase(AppDatabase database) async {
  await database.clientesDao.insertarCliente(
    ClientesCompanion.insert(id: 'cliente-test', nombre: 'Cliente'),
  );
  await database.expedientesDao.insertarExpediente(
    ExpedientesCompanion.insert(
      id: 'expediente-test',
      codigo: 'EXP-TEST',
      nombre: 'Expediente de prueba',
      clienteId: const Value('cliente-test'),
      cliente: const Value('Cliente'),
    ),
  );
  await database.presupuestosDao.insertarPresupuesto(
    PresupuestosCompanion.insert(
      id: 'presupuesto-test',
      expedienteId: 'expediente-test',
    ),
  );
  return 'presupuesto-test';
}

Future<Presupuesto> _obtenerPresupuesto(
  AppDatabase database,
  String presupuestoId,
) {
  return (database.select(
    database.presupuestos,
  )..where((table) => table.id.equals(presupuestoId))).getSingle();
}

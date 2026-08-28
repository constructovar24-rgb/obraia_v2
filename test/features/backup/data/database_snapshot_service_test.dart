import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/features/backup/data/database_snapshot_service.dart';
import 'package:path/path.dart' as p;

void main() {
  late Directory temporaryDirectory;
  late File sourceFile;
  late AppDatabase sourceDatabase;
  const service = DatabaseSnapshotService();

  setUpAll(() {
    // Estas pruebas abren a la vez la base original y un snapshot independiente.
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  });

  tearDownAll(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = false;
  });

  setUp(() async {
    temporaryDirectory = await Directory.systemTemp.createTemp(
      'obraia snapshot test ',
    );
    sourceFile = File(p.join(temporaryDirectory.path, 'source.sqlite'));
    sourceDatabase = AppDatabase.forTesting(NativeDatabase(sourceFile));

    await sourceDatabase.clientesDao.insertarCliente(
      ClientesCompanion.insert(id: 'cliente-1', nombre: 'Cliente original'),
    );
  });

  tearDown(() async {
    await sourceDatabase.close();
    if (await temporaryDirectory.exists()) {
      await temporaryDirectory.delete(recursive: true);
    }
  });

  test('crea un snapshot consistente sin modificar la base original', () async {
    final snapshotFile = File(
      p.join(temporaryDirectory.path, 'copia con espacios.sqlite'),
    );

    await service.createSnapshot(
      database: sourceDatabase,
      destinationPath: snapshotFile.path,
    );

    expect(await snapshotFile.exists(), isTrue);
    expect(await snapshotFile.length(), greaterThan(0));

    final snapshotDatabase = AppDatabase.forTesting(
      NativeDatabase(snapshotFile),
    );
    try {
      final clientes = await snapshotDatabase.clientesDao
          .observarClientes()
          .first;
      expect(clientes, hasLength(1));
      expect(clientes.single.nombre, 'Cliente original');

      final versionRow = await snapshotDatabase
          .customSelect('PRAGMA user_version;')
          .getSingle();
      expect(versionRow.data.values.single, sourceDatabase.schemaVersion);

      final integrityRow = await snapshotDatabase
          .customSelect('PRAGMA integrity_check;')
          .getSingle();
      expect(integrityRow.data.values.single, 'ok');

      final tableRows = await snapshotDatabase.customSelect('''
        SELECT name FROM sqlite_master
        WHERE type = 'table' AND name NOT LIKE 'sqlite_%'
      ''').get();
      final tableNames = tableRows
          .map((row) => row.read<String>('name'))
          .toSet();
      expect(tableNames, containsAll(_expectedTables));
    } finally {
      await snapshotDatabase.close();
    }

    await sourceDatabase.clientesDao.insertarCliente(
      ClientesCompanion.insert(id: 'cliente-2', nombre: 'Cliente posterior'),
    );
    final sourceClients = await sourceDatabase.clientesDao
        .observarClientes()
        .first;
    expect(sourceClients, hasLength(2));

    final snapshotAfterSourceChange = AppDatabase.forTesting(
      NativeDatabase(snapshotFile),
    );
    try {
      final snapshotClients = await snapshotAfterSourceChange.clientesDao
          .observarClientes()
          .first;
      expect(snapshotClients, hasLength(1));
    } finally {
      await snapshotAfterSourceChange.close();
    }
  });

  test('excluye datos de una transacción revertida', () async {
    final transactionStarted = Completer<void>();
    final allowRollback = Completer<void>();
    final snapshotFile = File(
      p.join(temporaryDirectory.path, 'snapshot tras rollback.sqlite'),
    );

    final transaction = sourceDatabase.transaction(() async {
      await sourceDatabase.clientesDao.insertarCliente(
        ClientesCompanion.insert(
          id: 'cliente-no-confirmado',
          nombre: 'No debe copiarse',
        ),
      );
      transactionStarted.complete();
      await allowRollback.future;
      throw const _RollbackForTest();
    });

    await transactionStarted.future;
    final snapshot = service.createSnapshot(
      database: sourceDatabase,
      destinationPath: snapshotFile.path,
    );
    allowRollback.complete();

    await expectLater(transaction, throwsA(isA<_RollbackForTest>()));
    await snapshot;

    final snapshotDatabase = AppDatabase.forTesting(
      NativeDatabase(snapshotFile),
    );
    try {
      final clientes = await snapshotDatabase.clientesDao
          .observarClientes()
          .first;
      expect(
        clientes.map((cliente) => cliente.id),
        isNot(contains('cliente-no-confirmado')),
      );
      expect(clientes.map((cliente) => cliente.id), contains('cliente-1'));
    } finally {
      await snapshotDatabase.close();
    }
  });

  test('rechaza un destino existente sin sobrescribirlo', () async {
    final destination = File(
      p.join(temporaryDirectory.path, 'destino existente.sqlite'),
    );
    const originalContents = <int>[79, 66, 82, 65, 73, 65];
    await destination.writeAsBytes(originalContents, flush: true);

    await expectLater(
      service.createSnapshot(
        database: sourceDatabase,
        destinationPath: destination.path,
      ),
      throwsA(isA<SnapshotDestinationExistsException>()),
    );

    expect(await destination.readAsBytes(), originalContents);
  });
}

const _expectedTables = <String>{
  'certificaciones',
  'clientes',
  'cobros',
  'compras',
  'documentos',
  'empresa_configuracion',
  'expedientes',
  'factura_lineas',
  'facturas',
  'lineas_presupuesto',
  'presupuestos',
  'proveedores',
  'timeline_events',
};

class _RollbackForTest implements Exception {
  const _RollbackForTest();
}

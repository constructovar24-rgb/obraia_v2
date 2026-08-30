import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:crypto/crypto.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/features/backup/data/backup_archive_service.dart';
import 'package:obraia_v2/features/backup/data/backup_restore_staging_service.dart';
import 'package:obraia_v2/features/backup/domain/backup_manifest.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

void main() {
  late Directory temporaryDirectory;
  late List<Directory> stagingDirectories;
  late BackupRestoreStagingService service;

  setUp(() async {
    temporaryDirectory = await Directory.systemTemp.createTemp(
      'obraia restore staging test ',
    );
    stagingDirectories = <Directory>[];
    service = BackupRestoreStagingService(
      temporaryDirectoryFactory: () async {
        final directory = await temporaryDirectory.createTemp('staging-');
        stagingDirectories.add(directory);
        return directory;
      },
    );
  });

  tearDown(() async {
    if (await temporaryDirectory.exists()) {
      await temporaryDirectory.delete(recursive: true);
    }
  });

  test(
    'prepara una copia de esquema actual sin tocar el archivo original',
    () async {
      final databaseFile = await _createCurrentDatabase(
        temporaryDirectory,
        'current.sqlite',
        withInvoice: true,
      );
      final source = AppDatabase.forTesting(NativeDatabase(databaseFile));
      final pdfFac = Uint8List.fromList([37, 80, 68, 70]);
      final hashFac = sha256.convert(pdfFac).toString();
      await source.facturaDocumentosEmitidosDao.insertar(
        facturaId: 'factura-1',
        pdf: pdfFac,
        sha256: hashFac,
      );
      await source.customStatement(
        '''
        INSERT INTO movimientos_credito_cliente
          (id, cliente_id, factura_raiz_origen_id, tipo_movimiento,
           importe, fecha, metodo, referencia, motivo, observaciones)
        VALUES ('devolucion-1', 'cliente-1', 'factura-1', 'devolucion',
                10.25, ?, 'Transferencia', 'REF-1', 'Prueba backup', 'Íntegra')
      ''',
        [DateTime.now().millisecondsSinceEpoch ~/ 1000],
      );
      await source.close();
      final backup = await _createBackupFromDatabase(
        databaseFile: databaseFile,
        schemaVersion: 22,
        destination: File(
          p.join(temporaryDirectory.path, 'current.obraia-backup'),
        ),
      );
      final backupBytesBefore = await backup.readAsBytes();

      final prepared = await service.prepare(
        backupPath: backup.path,
        currentSchemaVersion: 22,
      );
      addTearDown(prepared.dispose);

      expect(prepared.manifest.schemaVersion, 22);
      expect(prepared.preparedSchemaVersion, 22);
      expect(prepared.wasMigrated, isFalse);
      expect(await prepared.sourceDatabaseFile.exists(), isTrue);
      expect(await prepared.preparedDatabaseFile.exists(), isTrue);
      expect(
        prepared.sourceDatabaseFile.path,
        isNot(prepared.preparedDatabaseFile.path),
      );
      expect(await backup.readAsBytes(), backupBytesBefore);

      final database = sqlite3.open(
        prepared.preparedDatabaseFile.path,
        mode: OpenMode.readOnly,
      );
      try {
        expect(database.userVersion, 22);
        expect(
          database.select('SELECT nombre FROM clientes;').single['nombre'],
          'Cliente conservado',
        );
        expect(
          database
              .select(
                'SELECT length(pdf) AS bytes FROM factura_documentos_emitidos;',
              )
              .single['bytes'],
          4,
        );
        final documento = database
            .select('SELECT pdf, sha256 FROM factura_documentos_emitidos;')
            .single;
        expect(documento['pdf'], pdfFac);
        expect(documento['sha256'], hashFac);
        final movimiento = database.select('''
          SELECT factura_raiz_origen_id, tipo_movimiento, importe, referencia
          FROM movimientos_credito_cliente WHERE id = 'devolucion-1'
        ''').single;
        expect(movimiento['factura_raiz_origen_id'], 'factura-1');
        expect(movimiento['tipo_movimiento'], 'devolucion');
        expect(movimiento['importe'], 10.25);
        expect(movimiento['referencia'], 'REF-1');
      } finally {
        database.close();
      }

      final stagingPath = prepared.directory.path;
      await prepared.dispose();
      expect(await Directory(stagingPath).exists(), isFalse);
    },
  );

  test(
    'migra una copia auténtica 16 a 22 conservando datos e importes',
    () async {
      final databaseFile = await _createCurrentDatabase(
        temporaryDirectory,
        'legacy.sqlite',
        withInvoice: true,
      );
      final legacyDatabase = sqlite3.open(
        databaseFile.path,
        mode: OpenMode.readWrite,
      );
      try {
        legacyDatabase.execute('DROP TABLE factura_documentos_emitidos;');
        legacyDatabase.execute(
          'DROP INDEX IF EXISTS facturas_rectificada_idx;',
        );
        legacyDatabase.execute('DROP INDEX IF EXISTS facturas_raiz_idx;');
        legacyDatabase.execute(
          'DROP INDEX IF EXISTS facturas_numeracion_legal_unica;',
        );
        legacyDatabase.execute(
          'ALTER TABLE factura_lineas DROP COLUMN linea_raiz_id;',
        );
        legacyDatabase.execute(
          'ALTER TABLE factura_lineas DROP COLUMN linea_rectificada_id;',
        );
        for (final column in <String>[
          'efecto_total',
          'efecto_iva',
          'efecto_base',
          'motivo_rectificacion',
          'modalidad_rectificacion',
          'factura_raiz_id',
          'factura_rectificada_id',
          'serie',
          'tipo_documento',
        ]) {
          legacyDatabase.execute('ALTER TABLE facturas DROP COLUMN $column;');
        }
        legacyDatabase.execute('DROP TABLE factura_asignaciones_presupuesto;');
        legacyDatabase.execute(
          'DROP INDEX IF EXISTS facturas_numeracion_legal_unica;',
        );
        legacyDatabase.execute(
          'ALTER TABLE facturas DROP COLUMN iva_porcentaje;',
        );
        legacyDatabase.execute(
          'ALTER TABLE lineas_presupuesto DROP COLUMN unidad;',
        );
        legacyDatabase.execute('ALTER TABLE cobros DROP COLUMN motivo;');
        legacyDatabase.execute(
          'ALTER TABLE cobros DROP COLUMN cobro_origen_id;',
        );
        legacyDatabase.execute(
          'ALTER TABLE cobros DROP COLUMN tipo_movimiento;',
        );
        for (final column in <String>[
          'anio_numeracion',
          'numero_legal',
          'fecha_emision',
          'cliente_nombre_historico',
          'cliente_nif_historico',
          'cliente_direccion_historica',
          'cliente_telefono_historico',
          'cliente_email_historico',
          'empresa_nombre_historico',
          'empresa_cif_historico',
          'empresa_direccion_historica',
          'empresa_codigo_postal_historico',
          'empresa_poblacion_historica',
          'empresa_provincia_historica',
          'empresa_telefono_historico',
          'empresa_email_historico',
          'empresa_web_historica',
          'expediente_origen_id_historico',
          'expediente_codigo_historico',
          'expediente_nombre_historico',
          'presupuesto_codigo_historico',
        ]) {
          legacyDatabase.execute('ALTER TABLE facturas DROP COLUMN $column;');
        }
        legacyDatabase.userVersion = 16;
      } finally {
        legacyDatabase.close();
      }
      final backup = await _createBackupFromDatabase(
        databaseFile: databaseFile,
        schemaVersion: 16,
        destination: File(
          p.join(temporaryDirectory.path, 'legacy.obraia-backup'),
        ),
      );

      final prepared = await service.prepare(
        backupPath: backup.path,
        currentSchemaVersion: 22,
      );
      addTearDown(prepared.dispose);

      expect(prepared.wasMigrated, isTrue);
      final sourceDatabase = sqlite3.open(
        prepared.sourceDatabaseFile.path,
        mode: OpenMode.readOnly,
      );
      final migratedDatabase = sqlite3.open(
        prepared.preparedDatabaseFile.path,
        mode: OpenMode.readOnly,
      );
      try {
        expect(sourceDatabase.userVersion, 16);
        expect(migratedDatabase.userVersion, 22);
        final invoice = migratedDatabase.select('''
        SELECT subtotal, iva, total, iva_porcentaje
        FROM facturas WHERE id = 'factura-1'
      ''').single;
        expect(invoice['subtotal'], 80);
        expect(invoice['iva'], 8);
        expect(invoice['total'], 88);
        expect(invoice['iva_porcentaje'], 10);
      } finally {
        sourceDatabase.close();
        migratedDatabase.close();
      }
    },
  );

  test('rechaza una copia con una tabla obligatoria ausente', () async {
    final databaseFile = await _createCurrentDatabase(
      temporaryDirectory,
      'missing-table.sqlite',
    );
    final database = sqlite3.open(databaseFile.path, mode: OpenMode.readWrite);
    try {
      database.execute('DROP TABLE documentos;');
    } finally {
      database.close();
    }
    final backup = await _createBackupFromDatabase(
      databaseFile: databaseFile,
      schemaVersion: 22,
      destination: File(
        p.join(temporaryDirectory.path, 'missing-table.obraia-backup'),
      ),
    );

    await expectLater(
      service.prepare(backupPath: backup.path, currentSchemaVersion: 22),
      throwsA(isA<BackupValidationException>()),
    );
    expect(
      stagingDirectories.where((directory) => directory.existsSync()),
      isEmpty,
    );
  });

  test('rechaza una copia con relaciones huérfanas', () async {
    final databaseFile = await _createCurrentDatabase(
      temporaryDirectory,
      'orphan.sqlite',
    );
    final database = sqlite3.open(databaseFile.path, mode: OpenMode.readWrite);
    try {
      database.execute('''
        INSERT INTO expedientes (id, codigo, nombre, cliente, cliente_id)
        VALUES ('expediente-huerfano', 'EXP-H', 'Huérfano', '', 'ausente')
      ''');
    } finally {
      database.close();
    }
    final backup = await _createBackupFromDatabase(
      databaseFile: databaseFile,
      schemaVersion: 22,
      destination: File(
        p.join(temporaryDirectory.path, 'orphan.obraia-backup'),
      ),
    );

    await expectLater(
      service.prepare(backupPath: backup.path, currentSchemaVersion: 22),
      throwsA(isA<BackupValidationException>()),
    );
    expect(
      stagingDirectories.where((directory) => directory.existsSync()),
      isEmpty,
    );
  });

  test('rechaza un esquema posterior al soportado', () async {
    final databaseFile = await _createCurrentDatabase(
      temporaryDirectory,
      'future.sqlite',
    );
    final database = sqlite3.open(databaseFile.path, mode: OpenMode.readWrite);
    try {
      database.userVersion = 23;
    } finally {
      database.close();
    }
    final backup = await _createBackupFromDatabase(
      databaseFile: databaseFile,
      schemaVersion: 23,
      destination: File(
        p.join(temporaryDirectory.path, 'future.obraia-backup'),
      ),
    );

    await expectLater(
      service.prepare(backupPath: backup.path, currentSchemaVersion: 22),
      throwsA(isA<BackupSchemaNotSupportedException>()),
    );
    expect(
      stagingDirectories.where((directory) => directory.existsSync()),
      isEmpty,
    );
  });

  test('rechaza un contenedor truncado', () async {
    final databaseFile = await _createCurrentDatabase(
      temporaryDirectory,
      'truncated.sqlite',
    );
    final validBackup = await _createBackupFromDatabase(
      databaseFile: databaseFile,
      schemaVersion: 22,
      destination: File(
        p.join(temporaryDirectory.path, 'complete.obraia-backup'),
      ),
    );
    final validBytes = await validBackup.readAsBytes();
    final truncatedBackup = File(
      p.join(temporaryDirectory.path, 'truncated.obraia-backup'),
    );
    await truncatedBackup.writeAsBytes(
      validBytes.sublist(0, validBytes.length ~/ 2),
      flush: true,
    );

    await expectLater(
      service.prepare(
        backupPath: truncatedBackup.path,
        currentSchemaVersion: 22,
      ),
      throwsA(isA<BackupValidationException>()),
    );
    expect(
      stagingDirectories.where((directory) => directory.existsSync()),
      isEmpty,
    );
  });

  test('retira el staging si falla una migración', () async {
    final databaseFile = await _createCurrentDatabase(
      temporaryDirectory,
      'invalid-legacy.sqlite',
    );
    final database = sqlite3.open(databaseFile.path, mode: OpenMode.readWrite);
    try {
      database.userVersion = 16;
    } finally {
      database.close();
    }
    final backup = await _createBackupFromDatabase(
      databaseFile: databaseFile,
      schemaVersion: 16,
      destination: File(
        p.join(temporaryDirectory.path, 'invalid-legacy.obraia-backup'),
      ),
    );

    await expectLater(
      service.prepare(backupPath: backup.path, currentSchemaVersion: 22),
      throwsA(isA<BackupMigrationException>()),
    );
    expect(
      stagingDirectories.where((directory) => directory.existsSync()),
      isEmpty,
    );
  });
}

Future<File> _createCurrentDatabase(
  Directory directory,
  String name, {
  bool withInvoice = false,
}) async {
  final file = File(p.join(directory.path, name));
  final database = AppDatabase.forTesting(NativeDatabase(file));
  try {
    await database.clientesDao.insertarCliente(
      ClientesCompanion.insert(id: 'cliente-1', nombre: 'Cliente conservado'),
    );
    if (withInvoice) {
      await database.customStatement(
        '''
        INSERT INTO facturas (
          id, cliente_id, subtotal, iva, iva_porcentaje, total
        ) VALUES (?, ?, ?, ?, ?, ?)
      ''',
        <Object?>['factura-1', 'cliente-1', 80, 8, 10, 88],
      );
    }
  } finally {
    await database.close();
  }
  return file;
}

Future<File> _createBackupFromDatabase({
  required File databaseFile,
  required int schemaVersion,
  required File destination,
}) async {
  final databaseBytes = await databaseFile.readAsBytes();
  final entry = BackupManifestEntry(
    path: BackupManifest.defaultDatabasePath,
    type: BackupManifestEntry.sqliteDatabaseType,
    sizeBytes: databaseBytes.length,
    sha256: sha256.convert(databaseBytes).toString(),
  );
  final manifest = BackupManifest(
    createdAtUtc: DateTime.utc(2026, 8, 28),
    appVersion: '1.0.0',
    appBuildNumber: '1',
    schemaVersion: schemaVersion,
    databasePath: entry.path,
    totalUncompressedBytes: entry.sizeBytes,
    entries: <BackupManifestEntry>[entry],
  );
  final archive = Archive()
    ..addFile(
      ArchiveFile.string(
        BackupManifest.manifestPath,
        jsonEncode(manifest.toJson()),
      ),
    )
    ..addFile(ArchiveFile.bytes(entry.path, databaseBytes));
  await destination.writeAsBytes(
    ZipEncoder().encodeBytes(archive),
    flush: true,
  );
  return destination;
}

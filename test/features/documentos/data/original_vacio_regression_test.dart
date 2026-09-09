import 'dart:typed_data';
import 'package:obraia_v2/features/documentos/data/original_source_reader.dart';
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/core/environment/app_environment.dart';
import 'package:obraia_v2/core/environment/environment_paths.dart';
import 'package:obraia_v2/database/app_database.dart' as db;
import 'package:obraia_v2/features/documentos/data/documento_repository.dart';
import 'package:obraia_v2/features/documentos/data/managed_document_store.dart';
import 'package:obraia_v2/features/documentos/domain/documento.dart';

void main() {
  late Directory dir;
  late db.AppDatabase database;
  late EnvironmentPaths paths;
  late DocumentoRepository repository;
  late File source;
  setUp(() async {
    dir = await Directory.systemTemp.createTemp(
      'obraia-prod5-empty-regression-',
    );
    database = db.AppDatabase.forTesting(NativeDatabase.memory());
    paths = EnvironmentPaths(dir, AppEnvironment.development);
    repository = DocumentoRepository(
      database.documentosDao,
      store: ManagedDocumentStore(paths),
    );
    source = File('${dir.path}/original.txt');
    await database.expedientesDao.insertarExpediente(
      db.ExpedientesCompanion.insert(
        id: 'obra',
        codigo: 'FICTICIO',
        nombre: 'Ficticio',
      ),
    );
  });
  tearDown(() async {
    await database.close();
    await dir.delete(recursive: true);
  });
  Documento input(String title) => Documento(
    id: '',
    expedienteId: 'obra',
    titulo: title,
    nombreArchivo: 'original.txt',
    rutaArchivo: source.path,
    mimeType: 'text/plain',
    tamanoBytes: 0,
    fecha: DateTime(2026),
    observaciones: null,
    tipo: DocumentoTipo.otro,
  );

  test(
    'recreación de MISMA ruta: persistencia, hash, copia y exportación independientes A/B',
    () async {
      const a = 'Documento ficticio PROD-5';
      const b = 'Segundo documento ficticio PROD-5';
      await source.writeAsString(a, flush: true);
      await repository.registrarDocumento(input('Primero'));
      final first = (await repository.obtenerDocumentosPorExpediente(
        'obra',
      )).single;
      expect(first.tamanoBytes, utf8.encode(a).length);
      expect(first.sha256Original, sha256.convert(utf8.encode(a)).toString());
      await source.rename('${dir.path}/original-renombrado.txt');
      await source.writeAsString(b, flush: true);
      await repository.registrarDocumento(input('Segundo'));
      final documents = await repository.obtenerDocumentosPorExpediente('obra');
      expect(documents, hasLength(2));
      final second = documents.singleWhere((d) => d.id != first.id);
      expect(second.tamanoBytes, greaterThan(0));
      expect(second.tamanoBytes, utf8.encode(b).length);
      expect(second.sha256Original, sha256.convert(utf8.encode(b)).toString());
      expect(second.rutaGestionada, isNot(first.rutaGestionada));
      expect(
        await File(
          '${paths.managedDocumentsDirectory.path}/${first.rutaGestionada}',
        ).readAsString(),
        a,
      );
      expect(
        await File(
          '${paths.managedDocumentsDirectory.path}/${second.rutaGestionada}',
        ).readAsString(),
        b,
      );
      await repository.exportarOriginal(first.id, '${dir.path}/export-a.txt');
      await repository.exportarOriginal(second.id, '${dir.path}/export-b.txt');
      expect(await File('${dir.path}/export-a.txt').readAsString(), a);
      expect(await File('${dir.path}/export-b.txt').readAsString(), b);
      expect(await source.readAsString(), b);
    },
  );
  test(
    'fuente vacía se rechaza sin persistencia ni archivo gestionado',
    () async {
      await source.create();
      await expectLater(
        repository.registrarDocumento(input('Vacío')),
        throwsStateError,
      );
      expect(await database.select(database.documentos).get(), isEmpty);
      expect(await paths.managedDocumentsDirectory.exists(), isFalse);
    },
  );
  Future<void> noPartialImport() async {
    expect(await database.select(database.documentos).get(), isEmpty);
    if (await paths.managedDocumentsDirectory.exists()) {
      final contents = await paths.managedDocumentsDirectory
          .list(recursive: true)
          .toList();
      expect(contents.whereType<File>(), isEmpty);
      expect(contents.where((f) => f.path.contains('.import-')), isEmpty);
    }
  }

  test(
    'lectura vacía inesperada de fuente con contenido no se persiste',
    () async {
      await source.writeAsString('Contenido disponible', flush: true);
      repository = DocumentoRepository(
        database.documentosDao,
        store: ManagedDocumentStore(
          paths,
          sourceReader: (_) async => Uint8List(0),
        ),
      );
      await expectLater(
        repository.registrarDocumento(input('Fallo de lectura')),
        throwsStateError,
      );
      await noPartialImport();
      expect(await source.readAsString(), 'Contenido disponible');
    },
  );
  test(
    'cambio de contenido de igual tamaño entre lectura y copia aborta y limpia temporal',
    () async {
      await source.writeAsString('AAAA', flush: true);
      var reads = 0;
      repository = DocumentoRepository(
        database.documentosDao,
        store: ManagedDocumentStore(
          paths,
          sourceReader: (file) async {
            final bytes = await readStableOriginal(file);
            if (++reads == 1) await source.writeAsString('BBBB', flush: true);
            return bytes;
          },
        ),
      );
      await expectLater(
        repository.registrarDocumento(input('Cambio concurrente')),
        throwsStateError,
      );
      await noPartialImport();
      expect(await source.readAsString(), 'BBBB');
    },
  );
  test(
    'desaparición de fuente antes de publicar aborta y limpia temporal',
    () async {
      await source.writeAsString('Contenido', flush: true);
      var reads = 0;
      repository = DocumentoRepository(
        database.documentosDao,
        store: ManagedDocumentStore(
          paths,
          sourceReader: (file) async {
            final bytes = await readStableOriginal(file);
            if (++reads == 1) await source.delete();
            return bytes;
          },
        ),
      );
      await expectLater(
        repository.registrarDocumento(input('Desaparecido')),
        throwsStateError,
      );
      await noPartialImport();
    },
  );
  test('fallo de publicación no deja registro protegido ni temporales', () async {
    const content = 'Contenido';
    await source.writeAsString(content, flush: true);
    final hash = sha256.convert(utf8.encode(content)).toString();
    final target =
        '${paths.managedDocumentsDirectory.path}/${ManagedDocumentStore.tenantSegment(database.activeTenantId)}/$hash.original';
    await Directory(target).create(recursive: true);
    await expectLater(
      repository.registrarDocumento(input('Bloqueado')),
      throwsA(isA<FileSystemException>()),
    );
    await noPartialImport();
    expect(await source.readAsString(), content);
  });
  test(
    'vacío histórico avisa, bloquea exportación y conserva la fila sin repararla',
    () async {
      final hash = sha256.convert(<int>[]).toString();
      final relative =
          '${ManagedDocumentStore.tenantSegment(database.activeTenantId)}/$hash.original';
      final empty = File('${paths.managedDocumentsDirectory.path}/$relative');
      await empty.parent.create(recursive: true);
      await empty.create();
      final document = Documento(
        id: 'empty-legacy',
        expedienteId: 'obra',
        titulo: 'Vacío anterior',
        nombreArchivo: 'original.txt',
        rutaArchivo: source.path,
        mimeType: 'text/plain',
        tamanoBytes: 0,
        fecha: DateTime(2026),
        observaciones: null,
        tipo: DocumentoTipo.otro,
        rutaGestionada: relative,
        sha256Original: hash,
        incorporadoUtc: DateTime(2026),
      );
      await database.customStatement(
        'INSERT INTO documentos (tenant_id,id,expediente_id,titulo,nombre_archivo,ruta_archivo,tamano_bytes,ruta_gestionada,sha256_original,incorporado_utc) VALUES (?,?,?,?,?,?,?,?,?,?)',
        [
          database.activeTenantId,
          document.id,
          'obra',
          document.titulo,
          'original.txt',
          source.path,
          0,
          relative,
          hash,
          1,
        ],
      );
      expect(
        (await repository.obtenerDocumento(document.id))!.estadoProteccion,
        'Archivo vacío / revisar',
      );
      expect(
        await repository.verificarDocumento(document.id),
        'Archivo vacío / revisar',
      );
      await expectLater(
        repository.exportarOriginal(document.id, '${dir.path}/export.txt'),
        throwsStateError,
      );
      expect(await File('${dir.path}/export.txt').exists(), isFalse);
      expect(await empty.length(), 0);
      expect(await database.select(database.documentos).get(), hasLength(1));
    },
  );
  test(
    'incorporaciones concurrentes del mismo contenido no publican archivos parciales',
    () async {
      await source.writeAsString('Contenido compartido', flush: true);
      await Future.wait([
        repository.registrarDocumento(input('Uno')),
        repository.registrarDocumento(input('Dos')),
      ]);
      final docs = await repository.obtenerDocumentosPorExpediente('obra');
      expect(docs, hasLength(2));
      expect(docs.first.id, isNot(docs.last.id));
      expect(docs.first.rutaGestionada, docs.last.rutaGestionada);
      for (final doc in docs) {
        expect(
          await repository.verificarDocumento(doc.id),
          'Integridad correcta',
        );
      }
      expect(
        (await paths.managedDocumentsDirectory.list(recursive: true).toList())
            .whereType<File>(),
        hasLength(1),
      );
    },
  );
  test(
    'fuente truncada a cero entre lecturas aborta sin publicar ni persistir',
    () async {
      await source.writeAsString('Contenido inicial', flush: true);
      var reads = 0;
      repository = DocumentoRepository(
        database.documentosDao,
        store: ManagedDocumentStore(
          paths,
          sourceReader: (file) async {
            final bytes = await readStableOriginal(file);
            if (++reads == 1) {
              await source.writeAsString('', flush: true);
            }
            return bytes;
          },
        ),
      );
      await expectLater(
        repository.registrarDocumento(input('Truncado')),
        throwsStateError,
      );
      await noPartialImport();
    },
  );
}

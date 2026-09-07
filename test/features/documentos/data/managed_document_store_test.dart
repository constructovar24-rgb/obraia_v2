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
  late ManagedDocumentStore store;
  setUp(() async {
    dir = await Directory.systemTemp.createTemp('obraia-prod5-doc-');
    store = ManagedDocumentStore(
      EnvironmentPaths(dir, AppEnvironment.development),
    );
  });
  tearDown(() async => dir.delete(recursive: true));
  Future<File> original([String content = 'Original ficticio']) async =>
      File('${dir.path}/prueba.txt').writeAsString(content);

  test(
    'copia exacta, hash y conservación del original tras desaparecer la fuente',
    () async {
      final source = await original();
      final bytes = await source.readAsBytes();
      final saved = await store.incorporate(source.path, 'tenant-a');
      expect(await source.readAsBytes(), bytes);
      expect(saved.hash, sha256.convert(bytes).toString());
      expect(saved.originalName, 'prueba.txt');
      await source.delete();
      expect(
        await (await store.resolve(
          saved.relativePath,
          'tenant-a',
          saved.hash,
        )).readAsBytes(),
        bytes,
      );
      expect(
        await store.verify(
          relative: saved.relativePath,
          tenantId: 'tenant-a',
          hash: saved.hash,
          size: saved.size,
        ),
        'Integridad correcta',
      );
    },
  );
  test('detecta alteración y no sobrescribe silenciosamente', () async {
    final source = await original();
    final saved = await store.incorporate(source.path, 'a');
    final managed = await store.resolve(saved.relativePath, 'a', saved.hash);
    await managed.writeAsString('Alterado');
    expect(
      await store.verify(
        relative: saved.relativePath,
        tenantId: 'a',
        hash: saved.hash,
        size: saved.size,
      ),
      'Archivo modificado / revisar',
    );
    await expectLater(store.incorporate(source.path, 'a'), throwsStateError);
    expect(await managed.readAsString(), 'Alterado');
  });
  test('detecta archivo gestionado desaparecido', () async {
    final saved = await store.incorporate((await original()).path, 'a');
    await (await store.resolve(saved.relativePath, 'a', saved.hash)).delete();
    expect(
      await store.verify(
        relative: saved.relativePath,
        tenantId: 'a',
        hash: saved.hash,
        size: saved.size,
      ),
      'Archivo no encontrado',
    );
  });
  test('tenant y entorno físicamente aislados', () async {
    final source = await original();
    final a = await store.incorporate(source.path, 'a');
    final b = await store.incorporate(source.path, 'b');
    expect(a.relativePath, isNot(b.relativePath));
    await expectLater(
      store.resolve(a.relativePath, 'b', a.hash),
      throwsStateError,
    );
    final prod = ManagedDocumentStore(
      EnvironmentPaths(dir, AppEnvironment.production),
    );
    expect(
      await prod.verify(
        relative: a.relativePath,
        tenantId: 'a',
        hash: a.hash,
        size: a.size,
      ),
      'Archivo no encontrado',
    );
    expect(await prod.paths.managedDocumentsDirectory.exists(), isFalse);
  });
  test(
    'nombres duplicados con distinto contenido conservan ambos originales',
    () async {
      final first = await store.incorporate((await original('uno')).path, 'a');
      final second = await store.incorporate((await original('dos')).path, 'a');
      expect(first.relativePath, isNot(second.relativePath));
      expect(
        await (await store.resolve(
          first.relativePath,
          'a',
          first.hash,
        )).readAsString(),
        'uno',
      );
    },
  );
  test('rechaza rutas y metadatos incoherentes', () async {
    await expectLater(store.resolve('../otro', 'a', 'hash'), throwsStateError);
    expect(
      await store.verify(relative: 'x', tenantId: 'a', hash: 'x', size: 0),
      'Metadatos incoherentes / revisar',
    );
  });
  test(
    'repositorio preserva vínculo, calcula tamaño y protege edición del original',
    () async {
      final database = db.AppDatabase.forTesting(NativeDatabase.memory());
      try {
        await database.expedientesDao.insertarExpediente(
          db.ExpedientesCompanion.insert(
            id: 'obra',
            codigo: 'PRUEBA',
            nombre: 'Ficticia',
          ),
        );
        final repository = DocumentoRepository(
          database.documentosDao,
          store: store,
        );
        final source = await original();
        final input = Documento(
          id: '',
          expedienteId: 'obra',
          titulo: 'Prueba',
          nombreArchivo: 'ignorado',
          rutaArchivo: source.path,
          mimeType: 'text/plain',
          tamanoBytes: 999,
          fecha: DateTime(2026),
          observaciones: null,
          tipo: DocumentoTipo.otro,
        );
        await repository.registrarDocumento(input);
        final document = (await repository.obtenerDocumentosPorExpediente(
          'obra',
        )).single;
        expect(document.protegido, isTrue);
        expect(document.tamanoBytes, await source.length());
        expect(document.rutaArchivo, source.path);
        expect(
          await repository.verificarDocumento(document.id),
          'Integridad correcta',
        );
        await expectLater(
          repository.actualizarDocumento(
            Documento(
              id: document.id,
              expedienteId: 'obra',
              titulo: 'Cambio',
              nombreArchivo: 'otro',
              rutaArchivo: source.path,
              mimeType: 'text/plain',
              tamanoBytes: document.tamanoBytes,
              fecha: document.fecha,
              observaciones: null,
              tipo: DocumentoTipo.otro,
            ),
          ),
          throwsStateError,
        );
      } finally {
        await database.close();
      }
    },
  );
  test('histórico externo mantiene compatibilidad sin copiarlo', () async {
    final database = db.AppDatabase.forTesting(NativeDatabase.memory());
    try {
      await database.expedientesDao.insertarExpediente(
        db.ExpedientesCompanion.insert(
          id: 'obra',
          codigo: 'PRUEBA',
          nombre: 'Ficticia',
        ),
      );
      final source = await original();
      await database.documentosDao.insertarDocumento(
        db.DocumentosCompanion.insert(
          id: 'legacy',
          expedienteId: 'obra',
          titulo: 'Anterior',
          nombreArchivo: 'prueba.txt',
          rutaArchivo: source.path,
          tamanoBytes: 0,
        ),
      );
      final repository = DocumentoRepository(
        database.documentosDao,
        store: store,
      );
      expect((await repository.obtenerDocumento('legacy'))!.protegido, isFalse);
      expect(await repository.verificarDocumento('legacy'), 'Archivo externo');
      expect(await store.paths.managedDocumentsDirectory.exists(), isFalse);
    } finally {
      await database.close();
    }
  });
  test(
    'repositorio bloquea un almacén de otro entorno antes de copiar',
    () async {
      final database = db.AppDatabase.forTesting(NativeDatabase.memory());
      final otherPaths = EnvironmentPaths(dir, AppEnvironment.production);
      try {
        await database.ensureReady();
        final source = await original();
        final repository = DocumentoRepository(
          database.documentosDao,
          store: ManagedDocumentStore(otherPaths),
        );
        await expectLater(
          repository.registrarDocumento(
            Documento(
              id: '',
              expedienteId: 'obra',
              titulo: 'Ficticio',
              nombreArchivo: 'prueba.txt',
              rutaArchivo: source.path,
              mimeType: null,
              tamanoBytes: 0,
              fecha: DateTime(2026),
              observaciones: null,
              tipo: DocumentoTipo.otro,
            ),
          ),
          throwsStateError,
        );
        expect(await otherPaths.managedDocumentsDirectory.exists(), isFalse);
        expect(await database.select(database.documentos).get(), isEmpty);
      } finally {
        await database.close();
      }
    },
  );
}

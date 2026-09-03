import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/features/backup/data/database_snapshot_service.dart';
import 'package:path/path.dart' as p;

const _tenantA = '00000000-0000-4000-8000-000000000023';
const _tenantB = '00000000-0000-4000-8000-000000000024';

void main() {
  test('snapshot v23 conserva tenants y reabre cada ámbito', () async {
    final directory = await Directory.systemTemp.createTemp(
      'obraia-mt-backup-',
    );
    addTearDown(() => directory.delete(recursive: true));
    final sourceFile = File(p.join(directory.path, 'source.sqlite'));
    final snapshotFile = File(p.join(directory.path, 'snapshot.sqlite'));
    final source = AppDatabase.forTesting(
      NativeDatabase(sourceFile),
      tenantId: _tenantA,
    );
    await source.ensureReady();
    await source
        .into(source.tenants)
        .insert(
          TenantsCompanion.insert(
            id: _tenantB,
            nombre: 'Empresa B',
            fechaCreacion: DateTime.utc(2026),
            fechaModificacion: DateTime.utc(2026),
          ),
        );
    await source.clientesDao.insertarCliente(
      ClientesCompanion.insert(id: 'a', nombre: 'Cliente A'),
    );
    source.tenantContext.activate(_tenantB);
    await source.clientesDao.insertarCliente(
      ClientesCompanion.insert(id: 'b', nombre: 'Cliente B'),
    );

    await const DatabaseSnapshotService().createSnapshot(
      database: source,
      destinationPath: snapshotFile.path,
    );
    await source.close();

    final restored = AppDatabase.forTesting(
      NativeDatabase(snapshotFile),
      tenantId: _tenantB,
    );
    await restored.ensureReady();
    expect(await restored.select(restored.tenants).get(), hasLength(2));
    expect(
      (await restored.clientesDao.observarClientes().first).single.nombre,
      'Cliente B',
    );
    restored.tenantContext.activate(_tenantA);
    expect(
      (await restored.clientesDao.observarClientes().first).single.nombre,
      'Cliente A',
    );
    expect(
      await restored.customSelect('PRAGMA foreign_key_check').get(),
      isEmpty,
    );
    await restored.close();
  });
}

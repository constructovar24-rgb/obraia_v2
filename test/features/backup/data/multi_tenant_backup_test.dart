import 'dart:io';

import 'package:drift/drift.dart';
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
    await _seedTenant(source, 'a', 'Empresa A');
    source.tenantContext.activate(_tenantB);
    await _seedTenant(source, 'b', 'Empresa B');

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
    expect((await restored.facturasDao.observarFacturas().first), hasLength(2));
    expect(
      (await restored.empresaConfiguracionDao.obtenerConfiguracion())!
          .nombreEmpresa,
      'Empresa B',
    );
    restored.tenantContext.activate(_tenantA);
    expect(
      (await restored.clientesDao.observarClientes().first).single.nombre,
      'Cliente A',
    );
    expect((await restored.facturasDao.observarFacturas().first), hasLength(2));
    expect(
      (await restored.empresaConfiguracionDao.obtenerConfiguracion())!
          .nombreEmpresa,
      'Empresa A',
    );
    expect(
      await restored.customSelect('PRAGMA foreign_key_check').get(),
      isEmpty,
    );
    await restored.close();
  });
}

Future<void> _seedTenant(
  AppDatabase database,
  String suffix,
  String empresa,
) async {
  await database.clientesDao.insertarCliente(
    ClientesCompanion.insert(
      id: 'cliente-$suffix',
      nombre: 'Cliente ${suffix.toUpperCase()}',
    ),
  );
  await database.expedientesDao.insertarExpediente(
    ExpedientesCompanion.insert(
      id: 'expediente-$suffix',
      codigo: 'EXP-${suffix.toUpperCase()}',
      nombre: 'Obra ${suffix.toUpperCase()}',
      clienteId: Value('cliente-$suffix'),
    ),
  );
  await database.presupuestosDao.insertarPresupuesto(
    PresupuestosCompanion.insert(
      id: 'presupuesto-$suffix',
      expedienteId: 'expediente-$suffix',
    ),
  );
  await database.facturasDao.insertarFactura(
    FacturasCompanion.insert(
      id: 'factura-$suffix',
      clienteId: 'cliente-$suffix',
      presupuestoOrigenId: Value('presupuesto-$suffix'),
      serie: const Value('FAC'),
      anioNumeracion: const Value(2026),
      numeroLegal: const Value(1),
    ),
  );
  await database.facturasDao.insertarFactura(
    FacturasCompanion.insert(
      id: 'rect-$suffix',
      clienteId: 'cliente-$suffix',
      tipoDocumento: const Value('rectificativa'),
      serie: const Value('RECT'),
      anioNumeracion: const Value(2026),
      numeroLegal: const Value(1),
      facturaRectificadaId: Value('factura-$suffix'),
      facturaRaizId: Value('factura-$suffix'),
    ),
  );
  await database.empresaConfiguracionDao.insertarConfiguracion(
    EmpresaConfiguracionCompanion.insert(
      id: 'config-$suffix',
      nombreEmpresa: Value(empresa),
    ),
  );
}

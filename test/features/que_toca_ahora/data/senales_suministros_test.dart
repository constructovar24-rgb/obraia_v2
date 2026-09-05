import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/features/circuito_proveedor/data/circuito_proveedor_repository.dart';
import 'package:obraia_v2/features/circuito_proveedor/domain/circuito_proveedor.dart';

void main() {
  test('las señales derivadas respetan tenant y no mutan datos', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    await db.ensureReady();
    await db.expedientesDao.insertarExpediente(
      ExpedientesCompanion.insert(id: 'obra', codigo: 'A', nombre: 'Obra A'),
    );
    await db.proveedoresDao.insertarProveedor(
      ProveedoresCompanion.insert(id: 'proveedor', nombre: 'Proveedor A'),
    );
    final repository = CircuitoProveedorRepository(db);
    await repository.crearAlbaran(
      AlbaranInput(
        proveedorId: 'proveedor',
        referencia: 'ALB-1',
        fecha: DateTime(2026, 9, 5),
        lineas: const [
          LineaAlbaranInput(
            descripcion: 'Bloque',
            cantidad: 1,
            asignaciones: [
              AsignacionImporteInput(expedienteId: 'obra', importeCentimos: 0),
            ],
          ),
        ],
      ),
    );
    final before = await db.select(db.albaranesProveedor).get();
    expect(
      (await repository.obtenerSenalesObra(
        'obra',
        DateTime(2026, 9, 5),
      )).albaranesPendientesFactura,
      1,
    );
    expect(await db.select(db.albaranesProveedor).get(), before);
    await db
        .into(db.tenants)
        .insert(
          TenantsCompanion.insert(
            id: 'tenant-b',
            nombre: 'B',
            fechaCreacion: DateTime.now(),
            fechaModificacion: DateTime.now(),
          ),
        );
    db.tenantContext.activate('tenant-b');
    final other = await repository.obtenerSenalesObra(
      'obra',
      DateTime(2026, 9, 5),
    );
    expect(other.albaranesPendientesFactura, 0);
    expect(other.imputacionesPendientesReconciliar, 0);
  });
}

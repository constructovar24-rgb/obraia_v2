import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/features/circuito_proveedor/data/circuito_proveedor_repository.dart';
import 'package:obraia_v2/features/circuito_proveedor/domain/circuito_proveedor.dart';

void main() {
  late AppDatabase db; late CircuitoProveedorRepository repository;
  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory()); await db.ensureReady();
    await db.expedientesDao.insertarExpediente(ExpedientesCompanion.insert(id: 'obra-a', codigo: 'A', nombre: 'Obra A'));
    await db.expedientesDao.insertarExpediente(ExpedientesCompanion.insert(id: 'obra-b', codigo: 'B', nombre: 'Obra B'));
    await db.proveedoresDao.insertarProveedor(ProveedoresCompanion.insert(id: 'prov', nombre: 'BigMat'));
    repository = CircuitoProveedorRepository(db);
  });
  tearDown(() => db.close());

  test('crea un albarán con líneas y reparto multiobra sin coste', () async {
    await repository.crearAlbaran(AlbaranInput(proveedorId: 'prov', referencia: ' ALB-1 ', fecha: DateTime(2026, 9, 5), lineas: const [LineaAlbaranInput(descripcion: ' Bloque H ', cantidad: 10, importeCentimos: 50000, asignaciones: [AsignacionImporteInput(expedienteId: 'obra-a', importeCentimos: 30000), AsignacionImporteInput(expedienteId: 'obra-b', importeCentimos: 15000), AsignacionImporteInput(importeCentimos: 5000)])]));
    expect(await db.select(db.albaranesProveedor).get(), hasLength(1));
    expect((await db.select(db.lineasAlbaranProveedor).get()).single.descripcionOriginal, 'Bloque H');
    expect(await db.select(db.asignacionesAlbaranObra).get(), hasLength(3));
    expect(await db.select(db.hechosCoste).get(), isEmpty);
  });

  test('factura multiobra agrupa albaranes y detecta duplicado normalizado', () async {
    final albaran = await repository.crearAlbaran(AlbaranInput(proveedorId: 'prov', referencia: 'A-2', fecha: DateTime(2026, 9, 5), lineas: const [LineaAlbaranInput(descripcion: 'Arena', cantidad: 1)]));
    await repository.crearFactura(FacturaRecibidaInput(proveedorId: 'prov', numero: ' F-001/26 ', fecha: DateTime(2026, 9, 5), baseCentimos: 100000, ivaCentimos: 21000, albaranIds: [albaran], asignaciones: const [AsignacionImporteInput(expedienteId: 'obra-a', importeCentimos: 60000), AsignacionImporteInput(expedienteId: 'obra-b', importeCentimos: 30000), AsignacionImporteInput(importeCentimos: 10000)]));
    expect(await db.select(db.facturaRecibidaAlbaranes).get(), hasLength(1));
    expect(await db.select(db.asignacionesFacturaRecibida).get(), hasLength(3));
    await expectLater(repository.crearFactura(FacturaRecibidaInput(proveedorId: 'prov', numero: 'f00126', fecha: DateTime(2026, 9, 5), baseCentimos: 1, ivaCentimos: 0, asignaciones: const [AsignacionImporteInput(importeCentimos: 1)])), throwsA(anything));
  });

  test('reconoce una vez, excluye IVA recuperable y pago no crea coste', () async {
    final facturaId = await repository.crearFactura(FacturaRecibidaInput(proveedorId: 'prov', numero: 'F-2', fecha: DateTime(2026, 9, 5), baseCentimos: 50000, ivaCentimos: 10500, asignaciones: const [AsignacionImporteInput(expedienteId: 'obra-a', importeCentimos: 50000, ivaNoRecuperableCentimos: 0)]));
    final asignacion = (await db.select(db.asignacionesFacturaRecibida).get()).single;
    await repository.reconocerAsignacion(asignacionId: asignacion.id);
    await repository.reconocerAsignacion(asignacionId: asignacion.id);
    final hechos = await db.select(db.hechosCoste).get(); expect(hechos, hasLength(1)); expect(hechos.single.importeCosteCentimos, 50000);
    await repository.registrarPago(facturaId: facturaId, fecha: DateTime(2026, 9, 6), importeCentimos: 10000);
    expect(await db.select(db.hechosCoste).get(), hasLength(1));
    await repository.registrarPago(facturaId: facturaId, fecha: DateTime(2026, 9, 7), importeCentimos: 50500);
    expect((await db.select(db.facturasRecibidas).get()).single.estado, 'pagada');
    await expectLater(repository.registrarPago(facturaId: facturaId, fecha: DateTime.now(), importeCentimos: 1), throwsStateError);
  });

  test('tenant isolation y legacy sin datos inventados', () async {
    await repository.crearAlbaran(AlbaranInput(proveedorId: 'prov', referencia: 'A-3', fecha: DateTime.now(), lineas: const [LineaAlbaranInput(descripcion: 'Cemento', cantidad: 1, asignaciones: [AsignacionImporteInput(expedienteId: 'obra-a', importeCentimos: 0)])]));
    await db.into(db.tenants).insert(TenantsCompanion.insert(id: 'tenant-b', nombre: 'B', fechaCreacion: DateTime.now(), fechaModificacion: DateTime.now()));
    db.tenantContext.activate('tenant-b');
    expect(await repository.observarAlbaranesObra('obra-a').first, isEmpty);
    expect(await db.select(db.facturasRecibidas).get(), isEmpty);
  });
}

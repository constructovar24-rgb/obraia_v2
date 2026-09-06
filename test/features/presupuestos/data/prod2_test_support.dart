import 'package:drift/drift.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/features/presupuestos/data/presupuesto_repository.dart';
import 'package:obraia_v2/features/presupuestos/data/linea_presupuesto_repository.dart';

Future<void> configurarEmpresaPrueba(AppDatabase db) async {
  await db.ensureReady();
  if (await db.empresaConfiguracionDao.obtenerConfiguracion() != null) return;
  await db.empresaConfiguracionDao.insertarConfiguracion(
    EmpresaConfiguracionCompanion.insert(
      id: 'empresa-${db.activeTenantId}',
      nombreEmpresa: const Value('EMISOR DEMO'),
      cif: const Value('B00000000'),
      direccion: const Value('Calle Ficticia 1'),
      codigoPostal: const Value('28000'),
      poblacion: const Value('Madrid'),
      provincia: const Value('Madrid'),
      telefono: const Value('910000000'),
      email: const Value('demo@example.invalid'),
      web: const Value('example.invalid'),
    ),
  );
}

Future<String> crearPropuestaPrueba(
  AppDatabase db, {
  String suffix = '',
  bool opcionales = true,
}) async {
  await configurarEmpresaPrueba(db);
  await db.clientesDao.insertarCliente(
    ClientesCompanion.insert(
      id: 'cliente$suffix',
      nombre: 'CLIENTE DEMO',
      empresa: const Value('CLIENTE DEMO'),
      nif: Value(opcionales ? '00000000T' : ''),
      direccion: Value(opcionales ? 'Calle Prueba 2' : ''),
      codigoPostal: Value(opcionales ? '08000' : ''),
      poblacion: Value(opcionales ? 'Barcelona' : ''),
      provincia: Value(opcionales ? 'Barcelona' : ''),
    ),
  );
  await db.expedientesDao.insertarExpediente(
    ExpedientesCompanion.insert(
      id: 'obra$suffix',
      codigo: 'EXP$suffix',
      nombre: 'Obra ficticia',
      clienteId: Value('cliente$suffix'),
    ),
  );
  await PresupuestoRepository(db).crearPresupuesto(
    expedienteId: 'obra$suffix',
    fecha: DateTime(2026, 9, 6),
    descripcion: 'Condiciones: oferta de prueba, sin datos reales.',
  );
  final presupuesto =
      (await db.presupuestosDao.observarPorExpediente('obra$suffix').first)
          .single;
  await LineaPresupuestoRepository(db).crearLinea(
    presupuestoId: presupuesto.id,
    concepto: 'Material de prueba',
    cantidad: 2.5,
    unidad: 'm2',
    precioUnitario: 10.25,
  );
  await LineaPresupuestoRepository(db).crearLinea(
    presupuestoId: presupuesto.id,
    concepto: 'Trabajo de prueba',
    cantidad: 3,
    unidad: 'h',
    precioUnitario: 20,
  );
  return presupuesto.id;
}

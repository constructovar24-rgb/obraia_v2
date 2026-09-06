import 'package:drift/drift.dart';
import 'package:obraia_v2/database/app_database.dart';
import 'package:obraia_v2/features/facturas/data/factura_repository.dart';
import 'package:obraia_v2/features/facturas/data/factura_linea_repository.dart';

Future<String> crearFacturaFiscalPrueba(
  AppDatabase db, {
  int? ejercicio,
}) async {
  await db.ensureReady();
  final cliente = 'cliente-fiscal-${db.activeTenantId}';
  if (await db.clientesDao.obtenerCliente(cliente) == null) {
    await db.clientesDao.insertarCliente(
      ClientesCompanion.insert(
        id: cliente,
        nombre: 'CLIENTE FICTICIO',
        nif: const Value('00000000T'),
      ),
    );
  }
  if (await db.empresaConfiguracionDao.obtenerConfiguracion() == null) {
    await db.empresaConfiguracionDao.insertarConfiguracion(
      EmpresaConfiguracionCompanion.insert(
        id: 'emisor-${db.activeTenantId}',
        nombreEmpresa: const Value('EMISOR FICTICIO'),
        cif: const Value('B00000000'),
      ),
    );
  }
  final year = ejercicio ?? DateTime.now().year;
  final id = await FacturaRepository(db).crearFactura(
    clienteId: cliente,
    fecha: DateTime(year, 6, 1),
    fechaVencimiento: DateTime(year, 7, 1),
  );
  await FacturaLineaRepository(db).crearLinea(
    facturaId: id,
    descripcion: 'Trabajo ficticio',
    cantidad: 10,
    unidad: 'h',
    precioUnitario: 10,
    descuento: 0,
  );
  return id;
}

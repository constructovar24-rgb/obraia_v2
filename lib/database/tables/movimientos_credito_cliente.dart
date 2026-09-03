// ignore_for_file: unused_import

import 'package:drift/drift.dart';

import 'clientes.dart';
import 'facturas.dart';
import 'tenants.dart';

class MovimientosCreditoCliente extends Table {
  TextColumn get tenantId => text()
      .clientDefault(() => defaultTenantIdForTesting)
      .references(Tenants, #id)();
  TextColumn get id => text()();
  TextColumn get clienteId => text()();
  @ReferenceName('movimientosCreditoOrigen')
  TextColumn get facturaRaizOrigenId => text()();
  TextColumn get tipoMovimiento => text()();
  RealColumn get importe => real()();
  DateTimeColumn get fecha => dateTime()();
  TextColumn get movimientoOrigenId => text().nullable()();
  @ReferenceName('movimientosCreditoDestino')
  TextColumn get facturaRaizDestinoId => text().nullable()();
  TextColumn get metodo => text().nullable()();
  TextColumn get referencia => text().withDefault(const Constant(''))();
  TextColumn get motivo => text()();
  TextColumn get observaciones => text().withDefault(const Constant(''))();
  DateTimeColumn get fechaCreacion =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get fechaModificacion =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    'UNIQUE (tenant_id, id)',
    'FOREIGN KEY (tenant_id, cliente_id) REFERENCES clientes (tenant_id, id)',
    'FOREIGN KEY (tenant_id, factura_raiz_origen_id) REFERENCES facturas (tenant_id, id)',
    'FOREIGN KEY (tenant_id, factura_raiz_destino_id) REFERENCES facturas (tenant_id, id)',
    'FOREIGN KEY (tenant_id, movimiento_origen_id) REFERENCES movimientos_credito_cliente (tenant_id, id)',
    'CHECK (importe > 0)',
    "CHECK (tipo_movimiento IN ('devolucion', 'compensacion', 'reversionDevolucion', 'reversionCompensacion'))",
    "CHECK ((tipo_movimiento IN ('compensacion', 'reversionCompensacion')) = (factura_raiz_destino_id IS NOT NULL))",
    "CHECK ((tipo_movimiento IN ('reversionDevolucion', 'reversionCompensacion')) = (movimiento_origen_id IS NOT NULL))",
  ];
}

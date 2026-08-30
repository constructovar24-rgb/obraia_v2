import 'package:drift/drift.dart';

import 'clientes.dart';
import 'facturas.dart';

class MovimientosCreditoCliente extends Table {
  TextColumn get id => text()();
  TextColumn get clienteId => text().references(Clientes, #id)();
  @ReferenceName('movimientosCreditoOrigen')
  TextColumn get facturaRaizOrigenId => text().references(Facturas, #id)();
  TextColumn get tipoMovimiento => text()();
  RealColumn get importe => real()();
  DateTimeColumn get fecha => dateTime()();
  TextColumn get movimientoOrigenId =>
      text().nullable().references(MovimientosCreditoCliente, #id)();
  @ReferenceName('movimientosCreditoDestino')
  TextColumn get facturaRaizDestinoId =>
      text().nullable().references(Facturas, #id)();
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
    'CHECK (importe > 0)',
    "CHECK (tipo_movimiento IN ('devolucion', 'compensacion', 'reversionDevolucion', 'reversionCompensacion'))",
    "CHECK ((tipo_movimiento IN ('compensacion', 'reversionCompensacion')) = (factura_raiz_destino_id IS NOT NULL))",
    "CHECK ((tipo_movimiento IN ('reversionDevolucion', 'reversionCompensacion')) = (movimiento_origen_id IS NOT NULL))",
  ];
}

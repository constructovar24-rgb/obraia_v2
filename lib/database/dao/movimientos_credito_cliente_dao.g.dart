// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movimientos_credito_cliente_dao.dart';

// ignore_for_file: type=lint
mixin _$MovimientosCreditoClienteDaoMixin on DatabaseAccessor<AppDatabase> {
  $ClientesTable get clientes => attachedDatabase.clientes;
  $ExpedientesTable get expedientes => attachedDatabase.expedientes;
  $PresupuestosTable get presupuestos => attachedDatabase.presupuestos;
  $FacturasTable get facturas => attachedDatabase.facturas;
  $MovimientosCreditoClienteTable get movimientosCreditoCliente =>
      attachedDatabase.movimientosCreditoCliente;
  MovimientosCreditoClienteDaoManager get managers =>
      MovimientosCreditoClienteDaoManager(this);
}

class MovimientosCreditoClienteDaoManager {
  final _$MovimientosCreditoClienteDaoMixin _db;
  MovimientosCreditoClienteDaoManager(this._db);
  $$ClientesTableTableManager get clientes =>
      $$ClientesTableTableManager(_db.attachedDatabase, _db.clientes);
  $$ExpedientesTableTableManager get expedientes =>
      $$ExpedientesTableTableManager(_db.attachedDatabase, _db.expedientes);
  $$PresupuestosTableTableManager get presupuestos =>
      $$PresupuestosTableTableManager(_db.attachedDatabase, _db.presupuestos);
  $$FacturasTableTableManager get facturas =>
      $$FacturasTableTableManager(_db.attachedDatabase, _db.facturas);
  $$MovimientosCreditoClienteTableTableManager get movimientosCreditoCliente =>
      $$MovimientosCreditoClienteTableTableManager(
        _db.attachedDatabase,
        _db.movimientosCreditoCliente,
      );
}

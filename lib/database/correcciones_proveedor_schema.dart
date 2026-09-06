import 'app_database.dart';

Future<void> crearProteccionesProveedor(AppDatabase db) async {
  for (final table in [
    'facturas_recibidas',
    'pagos_proveedor',
    'eventos_proveedor',
    'reversiones_pagos_proveedor',
    'control_facturas_proveedor',
  ]) {
    await db.customStatement(
      "CREATE TRIGGER IF NOT EXISTS prod4_${table}_no_delete BEFORE DELETE ON $table BEGIN SELECT RAISE(ABORT, 'El historico de proveedor no se borra'); END",
    );
  }
  for (final table in [
    'pagos_proveedor',
    'eventos_proveedor',
    'reversiones_pagos_proveedor',
  ]) {
    await db.customStatement(
      "CREATE TRIGGER IF NOT EXISTS prod4_${table}_no_update BEFORE UPDATE ON $table BEGIN SELECT RAISE(ABORT, 'Registro inmutable: use reversion'); END",
    );
  }
  await db.customStatement("""
 CREATE TRIGGER IF NOT EXISTS prod4_factura_consolidada
 BEFORE UPDATE ON facturas_recibidas
 WHEN COALESCE((SELECT estado_documento FROM control_facturas_proveedor c WHERE c.tenant_id=OLD.tenant_id AND c.factura_id=OLD.id),'registrada') != 'borrador'
 AND (NEW.tenant_id IS NOT OLD.tenant_id OR NEW.id IS NOT OLD.id OR NEW.proveedor_id IS NOT OLD.proveedor_id
 OR NEW.numero_proveedor IS NOT OLD.numero_proveedor OR NEW.numero_normalizado IS NOT OLD.numero_normalizado
 OR NEW.fecha_factura IS NOT OLD.fecha_factura OR NEW.fecha_vencimiento IS NOT OLD.fecha_vencimiento
 OR NEW.base_centimos IS NOT OLD.base_centimos OR NEW.iva_centimos IS NOT OLD.iva_centimos
 OR NEW.total_centimos IS NOT OLD.total_centimos OR NEW.documento_id IS NOT OLD.documento_id)
 BEGIN SELECT RAISE(ABORT,'Factura consolidada: conservar original y corregir con trazabilidad'); END
 """);
  await db.customStatement("""
 CREATE TRIGGER IF NOT EXISTS prod4_control_inmutable BEFORE UPDATE ON control_facturas_proveedor
 WHEN NEW.tenant_id != OLD.tenant_id OR NEW.factura_id != OLD.factura_id
 OR (OLD.estado_documento != 'borrador' AND (NEW.estado_documento = 'borrador' OR NEW.tipo != OLD.tipo OR NEW.original_id IS NOT OLD.original_id))
 OR (OLD.estado_documento = 'anulada' AND NEW.estado_documento != 'anulada')
 BEGIN SELECT RAISE(ABORT,'Estado documental irreversible'); END
 """);
}

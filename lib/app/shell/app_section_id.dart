import 'package:flutter/material.dart';

enum AppSectionId {
  inicio('Inicio', Icons.space_dashboard_outlined),
  expedientes('Expedientes / Obras', Icons.business_outlined),
  clientes('Clientes', Icons.people_outline),
  presupuestos('Presupuestos', Icons.request_quote_outlined),
  facturas('Facturas', Icons.receipt_long_outlined),
  cobros('Cobros', Icons.payments_outlined),
  compras('Compras', Icons.shopping_cart_outlined),
  proveedores('Proveedores', Icons.local_shipping_outlined),
  certificaciones('Certificaciones', Icons.fact_check_outlined),
  documentos('Documentos', Icons.folder_copy_outlined),
  administracion('Centro administrativo', Icons.admin_panel_settings_outlined),
  configuracion('Configuración', Icons.settings_outlined);

  const AppSectionId(this.label, this.icon);

  final String label;
  final IconData icon;
}

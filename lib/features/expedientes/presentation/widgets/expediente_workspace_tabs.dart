import 'package:flutter/material.dart';

class ExpedienteWorkspaceTabs extends StatelessWidget {
  const ExpedienteWorkspaceTabs({super.key});

  static const labels = <String>[
    'Resumen',
    'Presupuestos',
    'Compras',
    'Mano de obra',
    'Certificaciones',
    'Facturas',
    'Documentos',
    'Timeline',
    'Cliente',
    'Datos generales',
    'Economía',
    'Planificación',
  ];

  static int get length => labels.length;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      tabs: labels.map((label) => Tab(text: label)).toList(growable: false),
    );
  }
}

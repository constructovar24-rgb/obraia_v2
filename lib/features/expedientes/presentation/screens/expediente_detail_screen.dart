import 'package:flutter/material.dart';

import '../../../../core/shortcuts/app_shortcuts.dart';
import '../../../../core/widgets/app_page_header.dart';
import '../../../../core/widgets/entity_summary_card.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../facturas/presentation/widgets/facturas_tab.dart';
import 'cliente_tab.dart';
import 'datos_generales_screen.dart';
import '../../../presupuestos/presentation/widgets/presupuestos_tab.dart';

class ExpedienteDetailScreen extends StatelessWidget {
  const ExpedienteDetailScreen({
    super.key,
    required this.id,
    required this.codigo,
    required this.nombre,
    this.clienteNombre,
  });

  final String id;
  final String codigo;
  final String nombre;
  final String? clienteNombre;

  static const List<Tab> _tabs = [
    Tab(text: 'Datos generales'),
    Tab(text: 'Cliente'),
    Tab(text: 'Presupuestos'),
    Tab(text: 'Certificaciones'),
    Tab(text: 'Facturas'),
    Tab(text: 'Documentos'),
    Tab(text: 'Notas'),
  ];

  @override
  Widget build(BuildContext context) {
    final hasCliente = clienteNombre != null && clienteNombre!.isNotEmpty;

    return DefaultTabController(
      length: _tabs.length,
      child: AppShortcutScope(
        onBack: () => Navigator.maybePop(context),
        child: Scaffold(
          appBar: AppPageHeader(
            showBackButton: true,
            title: 'Expediente',
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(hasCliente ? 196 : 172),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                    child: EntitySummaryCard(
                      title: codigo,
                      subtitle: nombre,
                      details: hasCliente
                          ? [
                              Text(
                                'Cliente: $clienteNombre',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ]
                          : null,
                      statusWidget: const StatusChip(
                        label: 'Sin estado',
                        type: StatusType.neutral,
                      ),
                    ),
                  ),
                  const TabBar(
                    isScrollable: true,
                    tabs: _tabs,
                  ),
                ],
              ),
            ),
          ),
          body: TabBarView(
            children: [
              DatosGeneralesTab(
                id: id,
                codigoExpediente: codigo,
              ),
              ClienteTab(expedienteId: id),
              PresupuestosTab(expedienteId: id),
              const Center(child: Text('En desarrollo')),
              FacturasTab(expedienteId: id),
              const Center(child: Text('En desarrollo')),
              const Center(child: Text('En desarrollo')),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/shortcuts/app_shortcuts.dart';
import '../../../clientes/presentation/screens/cliente_detail_screen.dart';
import '../../../expedientes/presentation/screens/expediente_detail_screen.dart';
import '../../../facturas/presentation/screens/editar_factura_screen.dart';
import '../../../presupuestos/presentation/screens/presupuesto_detail_screen.dart';
import '../../data/search_repository.dart';
import '../../domain/search_result.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final SearchRepository _repository;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _repository = ref.read(searchRepositoryProvider);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final normalizedQuery = _query.trim();

    return AppShortcutScope(
      onBack: () => Navigator.maybePop(context),
      onFind: () {
        _searchFocusNode.requestFocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Búsqueda global'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: TextField(
                focusNode: _searchFocusNode,
                controller: _searchController,
                autofocus: true,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  labelText: 'Buscar clientes, expedientes, presupuestos y facturas',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: normalizedQuery.isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _query = '';
                            });
                          },
                          icon: const Icon(Icons.clear),
                        ),
                  border: const OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _query = value;
                  });
                },
              ),
            ),
            Expanded(
              child: normalizedQuery.isEmpty
                  ? const _SearchHint()
                  : StreamBuilder<List<SearchResultsSection>>(
                      stream: _repository.observarResultados(normalizedQuery),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: SelectableText(
                                'ERROR:\n\n${snapshot.error}',
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          );
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final sections = snapshot.data ?? const [];

                        if (sections.isEmpty) {
                          return _NoResults(query: normalizedQuery);
                        }

                        return ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                          itemCount: sections.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final section = sections[index];

                            return _SearchSectionCard(
                              section: section,
                              onTapItem: (item) => _openResult(context, item),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _openResult(BuildContext context, SearchResultItem item) {
    if (item.type == SearchResultType.cliente) {
      final cliente = (item as ClienteSearchResult).cliente;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ClienteDetailScreen(cliente: cliente),
        ),
      );
      return;
    }

    if (item.type == SearchResultType.expediente) {
      final expediente = (item as ExpedienteSearchResult).expediente;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ExpedienteDetailScreen(
            id: expediente.id,
            codigo: expediente.codigo,
            nombre: expediente.nombre,
            clienteNombre: expediente.clienteNombre,
          ),
        ),
      );
      return;
    }

    if (item.type == SearchResultType.presupuesto) {
      final presupuesto = (item as PresupuestoSearchResult).presupuesto;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PresupuestoDetailScreen(
            presupuesto: presupuesto,
          ),
        ),
      );
      return;
    }

    final factura = (item as FacturaSearchResult).factura;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditarFacturaScreen(
          factura: factura,
        ),
      ),
    );
  }
}

class _SearchHint extends StatelessWidget {
  const _SearchHint();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.manage_search,
              size: 72,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Busca por cliente, expediente, presupuesto o factura',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              'Los resultados se agrupan por tipo y se actualizan al cambiar los datos.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _NoResults extends StatelessWidget {
  const _NoResults({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off,
              size: 64,
            ),
            const SizedBox(height: 12),
            Text(
              'No hay coincidencias para "$query"',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchSectionCard extends StatelessWidget {
  const _SearchSectionCard({
    required this.section,
    required this.onTapItem,
  });

  final SearchResultsSection section;
  final ValueChanged<SearchResultItem> onTapItem;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_iconForType(section.type)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    section.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                Chip(
                  label: Text(section.items.length.toString()),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(height: 16),
            ...section.items.map(
              (item) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  child: Icon(_iconForType(item.type)),
                ),
                title: Text(item.title),
                subtitle: Text(item.subtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => onTapItem(item),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

IconData _iconForType(SearchResultType type) {
  switch (type) {
    case SearchResultType.cliente:
      return Icons.people;
    case SearchResultType.expediente:
      return Icons.folder;
    case SearchResultType.presupuesto:
      return Icons.calculate;
    case SearchResultType.factura:
      return Icons.receipt_long;
  }
}
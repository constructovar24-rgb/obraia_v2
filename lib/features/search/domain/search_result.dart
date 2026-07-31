import 'package:obraia_v2/features/clientes/domain/cliente.dart';
import 'package:obraia_v2/features/expedientes/domain/expediente.dart';
import 'package:obraia_v2/features/facturas/domain/factura.dart';
import 'package:obraia_v2/features/presupuestos/domain/presupuesto.dart';

enum SearchResultType {
  cliente,
  expediente,
  presupuesto,
  factura,
}

sealed class SearchResultItem {
  const SearchResultItem({
    required this.type,
    required this.id,
    required this.title,
    required this.subtitle,
  });

  final SearchResultType type;
  final String id;
  final String title;
  final String subtitle;
}

final class ClienteSearchResult extends SearchResultItem {
  ClienteSearchResult({
    required this.cliente,
    required super.title,
    required super.subtitle,
  }) : super(
          type: SearchResultType.cliente,
          id: cliente.id,
        );

  final Cliente cliente;
}

final class ExpedienteSearchResult extends SearchResultItem {
  ExpedienteSearchResult({
    required this.expediente,
    required super.title,
    required super.subtitle,
  }) : super(
          type: SearchResultType.expediente,
          id: expediente.id,
        );

  final Expediente expediente;
}

final class PresupuestoSearchResult extends SearchResultItem {
  PresupuestoSearchResult({
    required this.presupuesto,
    required super.title,
    required super.subtitle,
  }) : super(
          type: SearchResultType.presupuesto,
          id: presupuesto.id,
        );

  final Presupuesto presupuesto;
}

final class FacturaSearchResult extends SearchResultItem {
  FacturaSearchResult({
    required this.factura,
    required super.title,
    required super.subtitle,
  }) : super(
          type: SearchResultType.factura,
          id: factura.id,
        );

  final Factura factura;
}

class SearchResultsSection {
  const SearchResultsSection({
    required this.type,
    required this.title,
    required this.items,
  });

  final SearchResultType type;
  final String title;
  final List<SearchResultItem> items;
}
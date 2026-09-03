import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obraia_v2/database/database_provider.dart';
import 'package:obraia_v2/features/clientes/data/cliente_repository.dart';
import 'package:obraia_v2/features/clientes/domain/cliente.dart';
import 'package:obraia_v2/features/expedientes/data/expediente_repository.dart';
import 'package:obraia_v2/features/expedientes/domain/expediente.dart';
import 'package:obraia_v2/features/facturas/data/factura_repository.dart';
import 'package:obraia_v2/features/facturas/domain/estado_factura.dart';
import 'package:obraia_v2/features/facturas/domain/factura.dart';
import 'package:obraia_v2/features/presupuestos/data/presupuesto_repository.dart';
import 'package:obraia_v2/features/presupuestos/domain/presupuesto.dart';
import 'package:obraia_v2/features/presupuestos/presentation/providers/presupuesto_providers.dart';

import '../domain/search_result.dart';

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  ref.watch(activeTenantIdProvider);
  return SearchRepository(
    clienteRepository: ref.watch(clienteRepositoryProvider),
    expedienteRepository: ref.watch(expedienteRepositoryProvider),
    presupuestoRepository: ref.watch(presupuestoRepositoryProvider),
    facturaRepository: ref.watch(facturaRepositoryProvider),
  );
});

class SearchRepository {
  SearchRepository({
    required this._clienteRepository,
    required this._expedienteRepository,
    required this._presupuestoRepository,
    required this._facturaRepository,
  });

  final ClienteRepository _clienteRepository;
  final ExpedienteRepository _expedienteRepository;
  final PresupuestoRepository _presupuestoRepository;
  final FacturaRepository _facturaRepository;

  Stream<List<SearchResultsSection>> observarResultados(String query) {
    final normalizedQuery = _normalize(query);
    if (normalizedQuery.isEmpty) {
      return Stream<List<SearchResultsSection>>.value(const []);
    }

    final controller = StreamController<List<SearchResultsSection>>();

    List<Cliente> clientes = const [];
    List<Expediente> expedientes = const [];
    List<Presupuesto> presupuestos = const [];
    List<Factura> facturas = const [];

    var clientesReady = false;
    var expedientesReady = false;
    var presupuestosReady = false;
    var facturasReady = false;

    StreamSubscription<List<Cliente>>? clientesSubscription;
    StreamSubscription<List<Expediente>>? expedientesSubscription;
    StreamSubscription<List<Presupuesto>>? presupuestosSubscription;
    StreamSubscription<List<Factura>>? facturasSubscription;

    void emitirResultados() {
      if (!clientesReady ||
          !expedientesReady ||
          !presupuestosReady ||
          !facturasReady) {
        return;
      }

      final sections = <SearchResultsSection>[
        _buscarClientes(clientes, normalizedQuery),
        _buscarExpedientes(expedientes, normalizedQuery),
        _buscarPresupuestos(presupuestos, normalizedQuery),
        _buscarFacturas(facturas, normalizedQuery),
      ].where((section) => section.items.isNotEmpty).toList(growable: false);

      if (!controller.isClosed) {
        controller.add(sections);
      }
    }

    controller.onListen = () {
      clientesSubscription = _clienteRepository.observarClientes().listen((
        value,
      ) {
        clientes = value;
        clientesReady = true;
        emitirResultados();
      }, onError: controller.addError);

      expedientesSubscription = _expedienteRepository
          .observarExpedientes()
          .listen((value) {
            expedientes = value;
            expedientesReady = true;
            emitirResultados();
          }, onError: controller.addError);

      presupuestosSubscription = _presupuestoRepository
          .observarPresupuestos()
          .listen((value) {
            presupuestos = value;
            presupuestosReady = true;
            emitirResultados();
          }, onError: controller.addError);

      facturasSubscription = _facturaRepository.observarFacturas().listen((
        value,
      ) {
        facturas = value;
        facturasReady = true;
        emitirResultados();
      }, onError: controller.addError);
    };

    controller.onCancel = () async {
      await Future.wait(
        [
          clientesSubscription?.cancel(),
          expedientesSubscription?.cancel(),
          presupuestosSubscription?.cancel(),
          facturasSubscription?.cancel(),
        ].whereType<Future<void>>(),
      );

      if (!controller.isClosed) {
        await controller.close();
      }
    };

    return controller.stream;
  }

  SearchResultsSection _buscarClientes(List<Cliente> clientes, String query) {
    final results = clientes
        .where(
          (cliente) => _matches(
            [
              cliente.nombre,
              cliente.apellidos,
              cliente.nif,
              cliente.telefono,
              cliente.email,
              cliente.direccion,
              cliente.poblacion,
              cliente.provincia,
              cliente.codigoPostal,
              cliente.empresa,
              cliente.observaciones,
            ].join(' '),
            query,
          ),
        )
        .map(
          (cliente) => ClienteSearchResult(
            cliente: cliente,
            title: '${cliente.nombre} ${cliente.apellidos}'.trim(),
            subtitle: cliente.empresa.isNotEmpty
                ? cliente.empresa
                : cliente.email.isNotEmpty
                ? cliente.email
                : cliente.telefono.isNotEmpty
                ? cliente.telefono
                : 'Sin datos',
          ),
        )
        .toList(growable: false);

    return SearchResultsSection(
      type: SearchResultType.cliente,
      title: 'Clientes',
      items: results,
    );
  }

  SearchResultsSection _buscarExpedientes(
    List<Expediente> expedientes,
    String query,
  ) {
    final results = expedientes
        .where(
          (expediente) => _matches(
            [
              expediente.codigo,
              expediente.nombre,
              expediente.clienteNombre ?? '',
            ].join(' '),
            query,
          ),
        )
        .map(
          (expediente) => ExpedienteSearchResult(
            expediente: expediente,
            title: '${expediente.codigo} · ${expediente.nombre}'.trim(),
            subtitle: expediente.clienteNombre?.isNotEmpty == true
                ? expediente.clienteNombre!
                : 'Sin cliente asociado',
          ),
        )
        .toList(growable: false);

    return SearchResultsSection(
      type: SearchResultType.expediente,
      title: 'Expedientes',
      items: results,
    );
  }

  SearchResultsSection _buscarPresupuestos(
    List<Presupuesto> presupuestos,
    String query,
  ) {
    final results = presupuestos
        .where(
          (presupuesto) => _matches(
            [
              presupuesto.codigo,
              presupuesto.descripcion,
              presupuesto.estado,
              presupuesto.importeTotal.toStringAsFixed(2),
            ].join(' '),
            query,
          ),
        )
        .map(
          (presupuesto) => PresupuestoSearchResult(
            presupuesto: presupuesto,
            title: presupuesto.codigo,
            subtitle: presupuesto.descripcion.isNotEmpty
                ? presupuesto.descripcion
                : '${presupuesto.estado} · ${presupuesto.importeTotal.toStringAsFixed(2)} €',
          ),
        )
        .toList(growable: false);

    return SearchResultsSection(
      type: SearchResultType.presupuesto,
      title: 'Presupuestos',
      items: results,
    );
  }

  SearchResultsSection _buscarFacturas(List<Factura> facturas, String query) {
    final results = facturas
        .where(
          (factura) => _matches(
            [
              factura.codigo,
              factura.clienteNombre,
              factura.observaciones,
              estadoFacturaToLabel(factura.estado),
              factura.total.toStringAsFixed(2),
            ].join(' '),
            query,
          ),
        )
        .map(
          (factura) => FacturaSearchResult(
            factura: factura,
            title: factura.codigo,
            subtitle: factura.clienteNombre.isNotEmpty
                ? '${factura.clienteNombre} · ${estadoFacturaToLabel(factura.estado)}'
                : estadoFacturaToLabel(factura.estado),
          ),
        )
        .toList(growable: false);

    return SearchResultsSection(
      type: SearchResultType.factura,
      title: 'Facturas',
      items: results,
    );
  }

  bool _matches(String text, String query) {
    return _normalize(text).contains(query);
  }

  String _normalize(String value) {
    return value.trim().toLowerCase();
  }
}

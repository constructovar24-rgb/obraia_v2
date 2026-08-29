import '../../presupuestos/domain/linea_presupuesto.dart';
import 'redondeo_monetario.dart';

enum ModalidadFacturacionParcial { porcentaje, importe, partidas }

class SeleccionPartidaFactura {
  const SeleccionPartidaFactura({
    required this.lineaPresupuestoId,
    this.cantidad,
    this.importe,
  });

  final String lineaPresupuestoId;
  final double? cantidad;
  final double? importe;
}

class AsignacionFacturaParcial {
  const AsignacionFacturaParcial({
    required this.linea,
    required this.baseCentimos,
    required this.cantidad,
  });

  final LineaPresupuesto linea;
  final int baseCentimos;
  final double? cantidad;
  double get base => centimosAMoneda(baseCentimos);
}

class ResumenFacturacionPresupuesto {
  const ResumenFacturacionPresupuesto({
    required this.basePresupuestadaCentimos,
    required this.facturadoCentimos,
    required this.reservadoCentimos,
    required this.pendienteCentimos,
    required this.tieneConsumoLegacySinDetalle,
  });

  final int basePresupuestadaCentimos;
  final int facturadoCentimos;
  final int reservadoCentimos;
  final int pendienteCentimos;
  final bool tieneConsumoLegacySinDetalle;

  double get basePresupuestada => centimosAMoneda(basePresupuestadaCentimos);
  double get facturado => centimosAMoneda(facturadoCentimos);
  double get reservado => centimosAMoneda(reservadoCentimos);
  double get pendiente => centimosAMoneda(pendienteCentimos);
}

class FacturacionParcialException implements Exception {
  const FacturacionParcialException(this.mensaje);
  final String mensaje;
  @override
  String toString() => mensaje;
}

List<AsignacionFacturaParcial> repartirProporcionalmente({
  required int importeCentimos,
  required List<LineaPresupuesto> lineas,
  required Map<String, int> consumidoPorLineaCentimos,
}) {
  if (importeCentimos <= 0) {
    throw const FacturacionParcialException(
      'El importe debe ser mayor que cero.',
    );
  }
  final disponibles = <(LineaPresupuesto, int)>[];
  for (final linea in lineas) {
    final total = monedaACentimos(linea.importe);
    final restante = total - (consumidoPorLineaCentimos[linea.id] ?? 0);
    if (restante > 0) disponibles.add((linea, restante));
  }
  final totalDisponible = disponibles.fold<int>(0, (s, item) => s + item.$2);
  if (importeCentimos > totalDisponible) {
    throw const FacturacionParcialException(
      'El importe supera el disponible del presupuesto.',
    );
  }

  var asignado = 0;
  final resultado = <AsignacionFacturaParcial>[];
  for (var i = 0; i < disponibles.length; i++) {
    final (linea, disponible) = disponibles[i];
    final esUltima = i == disponibles.length - 1;
    final parte = esUltima
        ? importeCentimos - asignado
        : (importeCentimos * disponible / totalDisponible).floor();
    final aplicada = parte.clamp(0, disponible);
    if (aplicada > 0) {
      resultado.add(
        AsignacionFacturaParcial(
          linea: linea,
          baseCentimos: aplicada,
          cantidad: null,
        ),
      );
      asignado += aplicada;
    }
  }
  var residuo = importeCentimos - asignado;
  for (var i = resultado.length - 1; i >= 0 && residuo > 0; i--) {
    final actual = resultado[i];
    final disponible = disponibles
        .firstWhere((item) => item.$1.id == actual.linea.id)
        .$2;
    final capacidad = disponible - actual.baseCentimos;
    final extra = residuo.clamp(0, capacidad);
    resultado[i] = AsignacionFacturaParcial(
      linea: actual.linea,
      baseCentimos: actual.baseCentimos + extra,
      cantidad: null,
    );
    residuo -= extra;
  }
  if (residuo != 0) {
    throw const FacturacionParcialException(
      'No se pudo distribuir el importe exacto.',
    );
  }
  return resultado;
}

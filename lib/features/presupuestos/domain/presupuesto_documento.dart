import 'dart:convert';
import 'dart:typed_data';

class PartidaPresupuestoDocumento {
  const PartidaPresupuestoDocumento({
    required this.id,
    required this.concepto,
    required this.cantidad,
    required this.unidad,
    required this.precioUnitario,
    required this.importeCentimos,
  });
  final String id, concepto, unidad;
  final double cantidad, precioUnitario;
  final int importeCentimos;
  Map<String, Object> toJson() => {
    'id': id,
    'concepto': concepto,
    'cantidad': cantidad,
    'unidad': unidad,
    'precioUnitario': precioUnitario,
    'importeCentimos': importeCentimos,
  };
  factory PartidaPresupuestoDocumento.fromJson(Map<String, dynamic> json) =>
      PartidaPresupuestoDocumento(
        id: json['id'] as String,
        concepto: json['concepto'] as String,
        cantidad: (json['cantidad'] as num).toDouble(),
        unidad: json['unidad'] as String,
        precioUnitario: (json['precioUnitario'] as num).toDouble(),
        importeCentimos: json['importeCentimos'] as int,
      );
}

/// Only commercial fields rendered in the document; internal costs stay in the plan.
class PresupuestoDocumento {
  PresupuestoDocumento({
    required this.tenantId,
    required this.presupuestoId,
    required this.codigo,
    required this.titulo,
    required this.fecha,
    required this.descripcion,
    required this.expedienteId,
    required this.expedienteCodigo,
    required this.expedienteNombre,
    required Map<String, String> emisor,
    required Map<String, String> cliente,
    required List<PartidaPresupuestoDocumento> partidas,
    required this.baseCentimos,
    required this.ivaPorcentaje,
    required this.ivaCentimos,
    required this.aceptado,
    this.fechaCongelacion,
    Uint8List? logo,
  }) : emisor = Map.unmodifiable(emisor),
       cliente = Map.unmodifiable(cliente),
       partidas = List.unmodifiable(partidas),
       logo = logo == null
           ? null
           : Uint8List.fromList(logo).asUnmodifiableView();
  final String tenantId,
      presupuestoId,
      codigo,
      titulo,
      descripcion,
      expedienteId,
      expedienteCodigo,
      expedienteNombre;
  final DateTime fecha;
  final DateTime? fechaCongelacion;
  final Map<String, String> emisor, cliente;
  final List<PartidaPresupuestoDocumento> partidas;
  final int baseCentimos, ivaCentimos;
  int get totalCentimos => baseCentimos + ivaCentimos;
  final double ivaPorcentaje;
  final bool aceptado;
  final Uint8List? logo;

  Map<String, Object?> toJson() => {
    'version': 1,
    'tenantId': tenantId,
    'presupuestoId': presupuestoId,
    'codigo': codigo,
    'titulo': titulo,
    'fecha': fecha.toIso8601String(),
    'descripcion': descripcion,
    'expedienteId': expedienteId,
    'expedienteCodigo': expedienteCodigo,
    'expedienteNombre': expedienteNombre,
    'emisor': emisor,
    'cliente': cliente,
    'partidas': partidas.map((p) => p.toJson()).toList(),
    'baseCentimos': baseCentimos,
    'ivaPorcentaje': ivaPorcentaje,
    'ivaCentimos': ivaCentimos,
    'totalCentimos': totalCentimos,
    'aceptado': aceptado,
    'fechaCongelacion': fechaCongelacion?.toIso8601String(),
    'logoBase64': logo == null ? null : base64Encode(logo!),
  };
  String encode() => jsonEncode(toJson());
  factory PresupuestoDocumento.decode(String value) {
    final j = jsonDecode(value) as Map<String, dynamic>;
    if (j['version'] != 1) {
      throw const FormatException('Versión documental no compatible.');
    }
    final doc = PresupuestoDocumento(
      tenantId: j['tenantId'] as String,
      presupuestoId: j['presupuestoId'] as String,
      codigo: j['codigo'] as String,
      titulo: j['titulo'] as String,
      fecha: DateTime.parse(j['fecha'] as String),
      descripcion: j['descripcion'] as String,
      expedienteId: j['expedienteId'] as String,
      expedienteCodigo: j['expedienteCodigo'] as String,
      expedienteNombre: j['expedienteNombre'] as String,
      emisor: Map<String, String>.from(j['emisor'] as Map),
      cliente: Map<String, String>.from(j['cliente'] as Map),
      partidas: (j['partidas'] as List)
          .map(
            (p) => PartidaPresupuestoDocumento.fromJson(
              Map<String, dynamic>.from(p as Map),
            ),
          )
          .toList(),
      baseCentimos: j['baseCentimos'] as int,
      ivaPorcentaje: (j['ivaPorcentaje'] as num).toDouble(),
      ivaCentimos: j['ivaCentimos'] as int,
      aceptado: j['aceptado'] as bool,
      fechaCongelacion: j['fechaCongelacion'] == null
          ? null
          : DateTime.parse(j['fechaCongelacion'] as String),
      logo: j['logoBase64'] == null
          ? null
          : base64Decode(j['logoBase64'] as String),
    );
    if (doc.totalCentimos != j['totalCentimos']) {
      throw const FormatException('Totales documentales incoherentes.');
    }
    return doc;
  }
}

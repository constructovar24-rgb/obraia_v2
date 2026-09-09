enum DocumentoTipo {
  contrato,
  licencia,
  plano,
  fotografia,
  factura,
  presupuesto,
  documentacionTecnica,
  certificado,
  otro,
}

class Documento {
  final String? rutaGestionada;
  final String? sha256Original;
  final DateTime? incorporadoUtc;
  bool get protegido => rutaGestionada != null && sha256Original != null;
  String get estadoProteccion => protegido && tamanoBytes <= 0
      ? 'Archivo vacío / revisar'
      : protegido
      ? 'Protegido por OBRA IA'
      : 'Archivo externo';
  final String id;
  final String expedienteId;
  final String titulo;
  final String nombreArchivo;
  final String rutaArchivo;
  final String? mimeType;
  final int tamanoBytes;
  final DateTime fecha;
  final String? observaciones;
  final DocumentoTipo tipo;

  const Documento({
    this.rutaGestionada,
    this.sha256Original,
    this.incorporadoUtc,
    required this.id,
    required this.expedienteId,
    required this.titulo,
    required this.nombreArchivo,
    required this.rutaArchivo,
    required this.mimeType,
    required this.tamanoBytes,
    required this.fecha,
    required this.observaciones,
    required this.tipo,
  });
}

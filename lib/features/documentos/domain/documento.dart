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

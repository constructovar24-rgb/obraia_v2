class ConfiguracionFiscalException implements Exception {
  const ConfiguracionFiscalException(this.mensaje);
  final String mensaje;
  @override
  String toString() => mensaje;
}

class ConfiguracionSerieFiscal {
  const ConfiguracionSerieFiscal({
    required this.ejercicio,
    required this.tipo,
    required this.serie,
    required this.numeroInicial,
    required this.siguienteNumero,
    required this.preparada,
    required this.emisiones,
    required this.documentosPrevios,
    required this.primerUso,
  });
  final int ejercicio,
      numeroInicial,
      siguienteNumero,
      emisiones,
      documentosPrevios;
  final String tipo, serie;
  final bool preparada;
  final DateTime? primerUso;
  bool get utilizada => emisiones > 0 || (preparada && documentosPrevios > 0);
}

class NumeroFiscal {
  const NumeroFiscal(this.ejercicio, this.serie, this.numero);
  final int ejercicio, numero;
  final String serie;
  String get codigo => '$serie-$ejercicio-${numero.toString().padLeft(4, '0')}';
}

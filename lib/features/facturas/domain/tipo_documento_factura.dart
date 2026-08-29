enum TipoDocumentoFactura { ordinaria, rectificativa }

enum ModalidadRectificacion { diferencias, sustitutiva }

TipoDocumentoFactura tipoDocumentoFacturaFromString(String value) =>
    value == TipoDocumentoFactura.rectificativa.name
    ? TipoDocumentoFactura.rectificativa
    : TipoDocumentoFactura.ordinaria;

ModalidadRectificacion? modalidadRectificacionFromString(String? value) {
  if (value == null || value.isEmpty) return null;
  return ModalidadRectificacion.values
      .where((item) => item.name == value)
      .firstOrNull;
}

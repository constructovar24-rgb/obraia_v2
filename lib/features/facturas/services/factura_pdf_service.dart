import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../core/services/pdf/pdf_document_helper.dart';
import '../../clientes/domain/cliente.dart' as cliente_domain;
import '../../configuracion/domain/empresa_configuracion.dart'
    as empresa_domain;
import '../domain/factura.dart';
import '../domain/factura_linea.dart';

class FacturaPdfService {
  static const double _titleFontSize = 20;
  static const double _generalFontSize = 10;
  static const double _tableHeaderFontSize = 10;
  static const double _tableRowFontSize = 9;
  static const double _totalFontSize = 12;

  Future<Uint8List> generarPdf({
    required Factura factura,
    required List<FacturaLinea> lineas,
    required empresa_domain.EmpresaConfiguracion empresaConfiguracion,
    cliente_domain.Cliente? cliente,
  }) async {
    final pdf = pw.Document();
    final logo = await PdfDocumentHelper.cargarLogo();

    final subtotal = factura.subtotal;
    final ivaImporte = factura.iva;
    final total = factura.total;
    final ivaPorcentaje = subtotal == 0 ? 21.0 : (ivaImporte * 100 / subtotal);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(24),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _cabecera(factura, empresaConfiguracion, logo),
                pw.SizedBox(height: 12),
                _bloqueCliente(factura, cliente),
                pw.SizedBox(height: 12),
                _linea(
                  'Observaciones',
                  factura.observaciones.trim().isEmpty
                      ? '-'
                      : factura.observaciones,
                ),
                pw.SizedBox(height: 12),
                _tablaLineas(lineas),
                pw.SizedBox(height: 10),
                _bloqueTotales(
                  subtotal: subtotal,
                  ivaPorcentaje: ivaPorcentaje,
                  ivaImporte: ivaImporte,
                  total: total,
                ),
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  pw.Widget _cabecera(
    Factura factura,
    empresa_domain.EmpresaConfiguracion empresaConfiguracion,
    pw.MemoryImage? logo,
  ) {
    final lineasEmpresa = PdfDocumentHelper.lineasEmpresa(
      nombreEmpresa: empresaConfiguracion.nombreEmpresa,
      cif: empresaConfiguracion.cif,
      direccion: empresaConfiguracion.direccion,
      codigoPostal: empresaConfiguracion.codigoPostal,
      poblacion: empresaConfiguracion.poblacion,
      provincia: empresaConfiguracion.provincia,
      telefono: empresaConfiguracion.telefono,
      email: empresaConfiguracion.email,
      web: empresaConfiguracion.web,
    );

    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (logo != null) ...[
                  pw.Image(
                    logo,
                    width: 120,
                    fit: pw.BoxFit.contain,
                  ),
                  pw.SizedBox(height: 8),
                ],
                ...lineasEmpresa.map((lineaEmpresa) => _companyLine(lineaEmpresa)),
              ],
            ),
          ),
          pw.SizedBox(width: 18),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'FACTURA',
                  style: pw.TextStyle(
                    fontSize: _titleFontSize,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                _lineaResumen('Numero', factura.codigo),
                _lineaResumen('Fecha', _formatearFecha(factura.fecha)),
                _lineaResumen(
                  'Vencimiento',
                  _formatearFecha(factura.fechaVencimiento),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _bloqueCliente(Factura factura, cliente_domain.Cliente? cliente) {
    final nombreCliente = cliente == null
        ? (factura.clienteNombre.trim().isEmpty
              ? 'Cliente no especificado'
              : factura.clienteNombre.trim())
        : '${cliente.nombre} ${cliente.apellidos}'.trim();

    final direccion = cliente == null
        ? '-'
        : _lineaDireccionCliente(
            direccion: cliente.direccion,
            codigoPostal: cliente.codigoPostal,
            poblacion: cliente.poblacion,
            provincia: cliente.provincia,
          );

    final telefono = cliente == null || cliente.telefono.trim().isEmpty
        ? '-'
        : cliente.telefono.trim();

    final email = cliente == null || cliente.email.trim().isEmpty
        ? '-'
        : cliente.email.trim();

    final nif = cliente == null || cliente.nif.trim().isEmpty
        ? '-'
        : cliente.nif.trim();

    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Cliente',
            style: pw.TextStyle(
              fontSize: _generalFontSize,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 6),
          _lineaResumen('Nombre', nombreCliente),
          _lineaResumen('NIF', nif),
          _lineaResumen('Direccion', direccion),
          _lineaResumen('Telefono', telefono),
          _lineaResumen('Email', email),
        ],
      ),
    );
  }

  String _lineaDireccionCliente({
    required String direccion,
    required String codigoPostal,
    required String poblacion,
    required String provincia,
  }) {
    final partes = <String>[];

    if (direccion.trim().isNotEmpty) {
      partes.add(direccion.trim());
    }

    final cpPoblacionProvincia = [
      if (codigoPostal.trim().isNotEmpty) codigoPostal.trim(),
      if (poblacion.trim().isNotEmpty) poblacion.trim(),
      if (provincia.trim().isNotEmpty) provincia.trim(),
    ].join(' ');

    if (cpPoblacionProvincia.isNotEmpty) {
      partes.add(cpPoblacionProvincia);
    }

    if (partes.isEmpty) {
      return '-';
    }

    return partes.join(' · ');
  }

  pw.Widget _companyLine(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 3),
      child: pw.Text(
        text,
        style: const pw.TextStyle(fontSize: _generalFontSize),
      ),
    );
  }

  pw.Widget _lineaResumen(String etiqueta, String valor) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 70,
            child: pw.Text(
              '$etiqueta:',
              style: pw.TextStyle(
                fontSize: _generalFontSize,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              valor,
              style: const pw.TextStyle(fontSize: _generalFontSize),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _tablaLineas(List<FacturaLinea> lineas) {
    if (lineas.isEmpty) {
      return pw.Text('Sin lineas de factura');
    }

    return pw.TableHelper.fromTextArray(
      headers: const [
        'Concepto',
        'Cantidad',
        'Precio',
        'Base imponible',
      ],
      data: lineas
          .map(
            (linea) => [
              linea.descripcion,
              '${_formatearCantidad(linea.cantidad)} ${linea.unidad}',
              _formatearMoneda(linea.precioUnitario),
              _formatearMoneda(linea.importe),
            ],
          )
          .toList(),
      headerStyle: pw.TextStyle(
        fontSize: _tableHeaderFontSize,
        fontWeight: pw.FontWeight.bold,
      ),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellStyle: const pw.TextStyle(fontSize: _tableRowFontSize),
      border: pw.TableBorder.all(color: PdfColors.grey500, width: 0.5),
      headerHeight: 24,
      cellHeight: 24,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.center,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.centerRight,
      },
      headerAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.center,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.centerRight,
      },
      cellPadding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
    );
  }

  pw.Widget _bloqueTotales({
    required double subtotal,
    required double ivaPorcentaje,
    required double ivaImporte,
    required double total,
  }) {
    return pw.Align(
      alignment: pw.Alignment.centerRight,
      child: pw.Container(
        width: 220,
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            pw.Divider(color: PdfColors.grey500, thickness: 0.6),
            pw.SizedBox(height: 6),
            _lineaTotal('Base imponible', _formatearMoneda(subtotal)),
            _lineaTotal(
              'IVA (${_formatearPorcentaje(ivaPorcentaje)}%)',
              _formatearMoneda(ivaImporte),
            ),
            pw.Container(
              margin: const pw.EdgeInsets.only(top: 6),
              padding: const pw.EdgeInsets.only(top: 6),
              decoration: const pw.BoxDecoration(
                border: pw.Border(
                  top: pw.BorderSide(color: PdfColors.grey700, width: 0.8),
                ),
              ),
              child: _lineaTotal(
                'TOTAL',
                _formatearMoneda(total),
                textStyle: pw.TextStyle(
                  fontSize: _totalFontSize,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  pw.Widget _lineaTotal(
    String etiqueta,
    String valor, {
    pw.TextStyle? textStyle,
  }) {
    final resolvedStyle =
        textStyle ?? const pw.TextStyle(fontSize: _generalFontSize);

    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(etiqueta, style: resolvedStyle),
        pw.Text(valor, style: resolvedStyle),
      ],
    );
  }

  pw.Widget _linea(
    String etiqueta,
    String valor, {
    pw.TextStyle? textStyle,
  }) {
    final resolvedStyle = textStyle ??
        const pw.TextStyle(
          fontSize: _generalFontSize,
        );

    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 110,
            child: pw.Text(
              '$etiqueta:',
              style: resolvedStyle.copyWith(fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Expanded(child: pw.Text(valor, style: resolvedStyle)),
        ],
      ),
    );
  }

  String _formatearFecha(DateTime fecha) {
    return PdfDocumentHelper.formatearFecha(fecha);
  }

  String _formatearMoneda(double value) {
    return PdfDocumentHelper.formatearMoneda(value);
  }

  String _formatearPorcentaje(double value) {
    return PdfDocumentHelper.formatearPorcentaje(value);
  }

  String _formatearCantidad(double value) {
    return PdfDocumentHelper.formatearCantidad(value);
  }
}
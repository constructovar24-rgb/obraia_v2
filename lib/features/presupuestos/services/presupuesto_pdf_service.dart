import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../core/services/pdf/pdf_document_helper.dart';
import '../domain/presupuesto_documento.dart';

class PresupuestoPdfService {
  const PresupuestoPdfService({this.comprimir = true});
  final bool comprimir;
  Future<Uint8List> generarPdf(PresupuestoDocumento documento) async {
    final pdf = pw.Document(compress: comprimir);
    final logo = documento.logo == null
        ? null
        : pw.MemoryImage(documento.logo!);
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        maxPages: 100,
        theme: pw.ThemeData.withFont(
          base: pw.Font.helvetica(),
          bold: pw.Font.helveticaBold(),
        ),
        footer: (context) => pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            '${documento.codigo} - ${context.pageNumber}/${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
          ),
        ),
        build: (context) => [
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    if (logo != null) ...[
                      pw.Image(
                        logo,
                        width: 110,
                        height: 60,
                        fit: pw.BoxFit.contain,
                      ),
                      pw.SizedBox(height: 8),
                    ],
                    ..._identidad(documento.emisor),
                  ],
                ),
              ),
              pw.SizedBox(width: 24),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'PRESUPUESTO',
                      style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    _texto('Referencia: ${documento.codigo}'),
                    _texto(
                      'Fecha: ${PdfDocumentHelper.formatearFecha(documento.fecha)}',
                    ),
                    _texto(
                      documento.aceptado
                          ? 'Aceptado - documento definitivo'
                          : 'Borrador - documento no aceptado',
                    ),
                  ],
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 18),
          pw.Text(
            'Cliente',
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 6),
          ..._identidad(documento.cliente),
          pw.SizedBox(height: 12),
          _texto(
            'Expediente / Obra: ${documento.expedienteCodigo} - ${documento.expedienteNombre}',
          ),
          if (documento.titulo.trim().isNotEmpty &&
              documento.titulo != documento.codigo)
            _texto(documento.titulo),
          if (documento.descripcion.trim().isNotEmpty) ...[
            pw.SizedBox(height: 8),
            _texto('Descripción / condiciones:'),
            _texto(documento.descripcion),
          ],
          pw.SizedBox(height: 14),
          pw.TableHelper.fromTextArray(
            headers: const [
              'Concepto',
              'Cantidad',
              'Unidad',
              'Precio unitario',
              'Importe',
            ],
            data: documento.partidas
                .map(
                  (linea) => [
                    linea.concepto,
                    _numero(linea.cantidad),
                    linea.unidad,
                    '${_numero(linea.precioUnitario)} EUR',
                    _moneda(linea.importeCentimos),
                  ],
                )
                .toList(),
            columnWidths: {
              0: const pw.FlexColumnWidth(4),
              1: const pw.FlexColumnWidth(1),
              2: const pw.FlexColumnWidth(1),
              3: const pw.FlexColumnWidth(1.7),
              4: const pw.FlexColumnWidth(1.5),
            },
            headerStyle: pw.TextStyle(
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
            ),
            cellStyle: const pw.TextStyle(fontSize: 9),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
            border: pw.TableBorder.all(color: PdfColors.grey500, width: 0.5),
            cellPadding: const pw.EdgeInsets.all(5),
            cellAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.centerRight,
              2: pw.Alignment.center,
              3: pw.Alignment.centerRight,
              4: pw.Alignment.centerRight,
            },
          ),
          pw.SizedBox(height: 14),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.SizedBox(
              width: 240,
              child: pw.Column(
                children: [
                  _total('Base imponible', documento.baseCentimos),
                  _total(
                    'IVA (${_numero(documento.ivaPorcentaje)}%)',
                    documento.ivaCentimos,
                  ),
                  pw.Divider(),
                  _total('TOTAL', documento.totalCentimos, bold: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    return pdf.save();
  }

  List<pw.Widget> _identidad(Map<String, String> datos) => [
    if ((datos['nombre'] ?? '').trim().isNotEmpty)
      pw.Text(
        datos['nombre']!,
        style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
      ),
    if ((datos['nif'] ?? '').trim().isNotEmpty)
      _texto('NIF/CIF: ${datos['nif']}'),
    if ((datos['direccion'] ?? '').trim().isNotEmpty)
      _texto(datos['direccion']!),
    if ([
      'codigoPostal',
      'poblacion',
      'provincia',
    ].any((k) => (datos[k] ?? '').trim().isNotEmpty))
      _texto(
        ['codigoPostal', 'poblacion', 'provincia']
            .map((k) => datos[k]?.trim() ?? '')
            .where((v) => v.isNotEmpty)
            .join(' '),
      ),
    for (final key in ['telefono', 'email', 'web'])
      if ((datos[key] ?? '').trim().isNotEmpty) _texto(datos[key]!),
  ];
  pw.Widget _texto(String value) => pw.Padding(
    padding: const pw.EdgeInsets.only(top: 3),
    child: pw.Text(value, style: const pw.TextStyle(fontSize: 10)),
  );
  pw.Widget _total(String label, int value, {bool bold = false}) => pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 3),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: bold ? 12 : 10,
            fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
        pw.Text(
          _moneda(value),
          style: pw.TextStyle(
            fontSize: bold ? 12 : 10,
            fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
      ],
    ),
  );
  String _moneda(int centimos) =>
      PdfDocumentHelper.formatearMoneda(centimos / 100);
  String _numero(double value) =>
      (value == value.truncateToDouble()
              ? value.toStringAsFixed(0)
              : value.toString())
          .replaceAll('.', ',');
}

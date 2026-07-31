import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/widgets.dart' as pw;

class PdfDocumentHelper {
  const PdfDocumentHelper._();

  static String formatearFecha(DateTime fecha) {
    final day = fecha.day.toString().padLeft(2, '0');
    final month = fecha.month.toString().padLeft(2, '0');
    final year = fecha.year.toString();
    return '$day/$month/$year';
  }

  static String formatearMoneda(double value) {
    return '${value.toStringAsFixed(2).replaceAll('.', ',')} EUR';
  }

  static String formatearPorcentaje(double value) {
    if (value == value.truncateToDouble()) {
      return value.toStringAsFixed(0);
    }

    return value.toStringAsFixed(2).replaceAll('.', ',');
  }

  static String formatearCantidad(double value) {
    if (value == value.truncateToDouble()) {
      return value.toStringAsFixed(0);
    }

    return value.toStringAsFixed(2).replaceAll('.', ',');
  }

  static List<String> lineasEmpresa({
    required String nombreEmpresa,
    required String cif,
    required String direccion,
    required String codigoPostal,
    required String poblacion,
    required String provincia,
    required String telefono,
    required String email,
    required String web,
  }) {
    final lineas = <String>[];

    final nombreEmpresaLimpio = _limpiar(nombreEmpresa);
    if (nombreEmpresaLimpio != null) {
      lineas.add(nombreEmpresaLimpio);
    }

    final cifLimpio = _limpiar(cif);
    if (cifLimpio != null) {
      lineas.add('CIF: $cifLimpio');
    }

    final direccionLimpia = _limpiar(direccion);
    if (direccionLimpia != null) {
      lineas.add(direccionLimpia);
    }

    final codigoPostalLimpio = _limpiar(codigoPostal);
    final poblacionLimpia = _limpiar(poblacion);
    final provinciaLimpia = _limpiar(provincia);
    final cpPoblacionProvincia = [
      codigoPostalLimpio,
      poblacionLimpia,
      provinciaLimpia,
    ].whereType<String>().join(' ');

    if (cpPoblacionProvincia.isNotEmpty) {
      lineas.add(cpPoblacionProvincia);
    }

    final telefonoLimpio = _limpiar(telefono);
    if (telefonoLimpio != null) {
      lineas.add(telefonoLimpio);
    }

    final emailLimpio = _limpiar(email);
    if (emailLimpio != null) {
      lineas.add(emailLimpio);
    }

    final webLimpia = _limpiar(web);
    if (webLimpia != null) {
      lineas.add(webLimpia);
    }

    return lineas;
  }

  static Future<pw.MemoryImage?> cargarLogo() async {
    try {
      final bytes = await rootBundle.load('assets/images/logo_empresa.png');
      return pw.MemoryImage(bytes.buffer.asUint8List());
    } catch (e) {
      debugPrint('No se encontro el logotipo corporativo: $e');
      return null;
    }
  }

  static String? _limpiar(String? value) {
    if (value == null) {
      return null;
    }

    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }

    return trimmed;
  }
}
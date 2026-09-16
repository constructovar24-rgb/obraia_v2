import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obraia_v2/features/configuracion/domain/empresa_configuracion.dart';
import 'package:obraia_v2/features/facturas/domain/estado_factura.dart';
import 'package:obraia_v2/features/facturas/domain/factura.dart';
import 'package:obraia_v2/features/facturas/domain/tipo_documento_factura.dart';
import 'package:obraia_v2/features/facturas/services/factura_pdf_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const empresa = EmpresaConfiguracion(
    id: 'empresa',
    nombreEmpresa: 'Empresa ficticia',
    cif: 'B00000000',
    direccion: '',
    codigoPostal: '',
    poblacion: '',
    provincia: '',
    telefono: '',
    email: '',
    web: '',
    logoPath: null,
  );

  Factura factura({bool rectificativa = false}) => Factura(
    id: rectificativa ? 'rect' : 'fac',
    codigo: rectificativa ? 'RECT-2026-0001' : 'FAC-2026-0001',
    clienteId: 'cliente',
    clienteNombre: 'Cliente ficticio',
    fecha: DateTime(2026),
    fechaVencimiento: DateTime(2026),
    estado: EstadoFactura.borrador,
    subtotal: rectificativa ? -10 : 10,
    iva: rectificativa ? -2.1 : 2.1,
    ivaPorcentaje: 21,
    total: rectificativa ? -12.1 : 12.1,
    observaciones: '',
    tipoDocumento: rectificativa
        ? TipoDocumentoFactura.rectificativa
        : TipoDocumentoFactura.ordinaria,
  );

  test('la etiqueta PDF usa el porcentaje persistido', () {
    expect(facturaIvaEtiqueta(7.5), 'IVA (7,50%)');
    expect(facturaIvaEtiqueta(0), 'IVA (0%)');
  });

  test('una rectificativa usa título documental específico', () {
    expect(
      facturaTituloPdf(factura(rectificativa: true)),
      'FACTURA RECTIFICATIVA',
    );
  });

  test('factura y rectificativa usan exactamente el logo configurado', () async {
    final temporal = await Directory.systemTemp.createTemp('obraia-logo-');
    addTearDown(() => temporal.delete(recursive: true));
    final esperados = base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=',
    );
    final archivo = File('${temporal.path}${Platform.pathSeparator}logo.png');
    await archivo.writeAsBytes(esperados, flush: true);
    final configurada = empresa.copyWith(logoPath: archivo.path);
    final servicio = FacturaPdfService();

    expect(
      await servicio.resolverLogoBytes(configurada),
      orderedEquals(esperados),
    );
    expect(
      await servicio.generarPdf(
        factura: factura(),
        lineas: const [],
        empresaConfiguracion: configurada,
      ),
      isNotEmpty,
    );
    expect(
      await servicio.generarPdf(
        factura: factura(rectificativa: true),
        facturaOriginal: factura(),
        lineas: const [],
        empresaConfiguracion: configurada,
      ),
      isNotEmpty,
    );
  });

  test('sin ruta conserva exactamente el logo predeterminado', () async {
    final predeterminado = await rootBundle.load(
      'assets/images/logo_empresa.png',
    );

    expect(
      await FacturaPdfService().resolverLogoBytes(
        empresa.copyWith(logoPath: '   '),
      ),
      orderedEquals(predeterminado.buffer.asUint8List()),
    );
  });

  test('ruta de logo inválida bloquea con un mensaje comprensible', () async {
    final temporal = await Directory.systemTemp.createTemp('obraia-logo-');
    addTearDown(() => temporal.delete(recursive: true));
    final archivo = File('${temporal.path}${Platform.pathSeparator}logo.png');
    await archivo.writeAsString('esto no es una imagen');
    final ruta = archivo.path;

    await expectLater(
      FacturaPdfService().resolverLogoBytes(empresa.copyWith(logoPath: ruta)),
      throwsA(
        isA<FacturaPdfException>()
            .having((error) => error.mensaje, 'mensaje', contains(ruta))
            .having(
              (error) => error.mensaje,
              'explicación',
              contains('imagen PNG o JPEG válida'),
            ),
      ),
    );
  });
}

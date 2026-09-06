import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import '../../../database/app_database.dart';
import '../../facturas/domain/redondeo_monetario.dart';
import '../domain/estado_presupuesto.dart';
import '../domain/presupuesto_documento.dart';
import '../services/presupuesto_pdf_service.dart';

class PresupuestoDocumentalRepository {
  PresupuestoDocumentalRepository(
    this.database, {
    PresupuestoPdfService? pdfService,
  }) : _pdfService = pdfService ?? PresupuestoPdfService();
  final AppDatabase database;
  final PresupuestoPdfService _pdfService;

  Future<PresupuestoDocumento> preparar(
    String id, {
    bool aceptado = false,
  }) async {
    final presupuesto = await database.presupuestosDao.obtenerPorId(id);
    if (presupuesto == null || presupuesto.eliminado) {
      throw const EstadoPresupuestoException(
        'El presupuesto no está disponible.',
      );
    }
    if (estadoPresupuestoEsAceptado(presupuesto.estado)) {
      final original = await obtenerSnapshot(id);
      if (original != null) return original;
      throw const EstadoPresupuestoException(
        'Presupuesto aceptado histórico sin documento congelado. No se reconstruye con datos actuales.',
      );
    }
    final expediente = await database.expedientesDao.obtenerExpediente(
      presupuesto.expedienteId,
    );
    final clienteId = expediente?.clienteId;
    final cliente = clienteId == null
        ? null
        : await database.clientesDao.obtenerCliente(clienteId);
    if (expediente == null || cliente == null || cliente.eliminado) {
      throw const EstadoPresupuestoException(
        'Vincula un cliente válido al expediente antes de generar el documento.',
      );
    }
    final nombreCliente = cliente.empresa.trim().isNotEmpty
        ? cliente.empresa.trim()
        : [
            cliente.nombre.trim(),
            cliente.apellidos.trim(),
          ].where((v) => v.isNotEmpty).join(' ');
    if (nombreCliente.isEmpty) {
      throw const EstadoPresupuestoException(
        'El cliente necesita nombre o razón social.',
      );
    }
    final empresa = await database.empresaConfiguracionDao
        .obtenerConfiguracion();
    if (empresa == null ||
        empresa.nombreEmpresa.trim().isEmpty ||
        empresa.cif.trim().isEmpty) {
      throw const EstadoPresupuestoException(
        'Configura el nombre y el NIF/CIF de la empresa antes de generar el documento.',
      );
    }
    final lineas = await database.lineasPresupuestoDao.obtenerPorPresupuesto(
      id,
    );
    if (lineas.isEmpty || presupuesto.codigo.trim().isEmpty) {
      throw const EstadoPresupuestoException(
        'El presupuesto necesita referencia y al menos una partida.',
      );
    }
    if (!presupuesto.ivaPorcentaje.isFinite ||
        presupuesto.ivaPorcentaje < 0 ||
        presupuesto.ivaPorcentaje > 100) {
      throw const EstadoPresupuestoException(
        'El IVA debe estar entre 0 y 100.',
      );
    }
    final partidas = <PartidaPresupuestoDocumento>[];
    for (final linea in lineas) {
      if (linea.concepto.trim().isEmpty ||
          linea.unidad.trim().isEmpty ||
          !linea.cantidad.isFinite ||
          linea.cantidad <= 0 ||
          !linea.precioUnitario.isFinite ||
          linea.precioUnitario < 0 ||
          !linea.importe.isFinite) {
        throw const EstadoPresupuestoException(
          'Revisa descripción, unidad, cantidad y precio de las partidas.',
        );
      }
      partidas.add(
        PartidaPresupuestoDocumento(
          id: linea.id,
          concepto: linea.concepto,
          cantidad: linea.cantidad,
          unidad: linea.unidad,
          precioUnitario: linea.precioUnitario,
          importeCentimos: monedaACentimos(linea.importe),
        ),
      );
    }
    final base = partidas.fold<int>(0, (sum, p) => sum + p.importeCentimos);
    if (!presupuesto.importeTotal.isFinite ||
        monedaACentimos(presupuesto.importeTotal) != base) {
      throw const EstadoPresupuestoException(
        'El total no coincide con las partidas. Revisa el borrador antes de aceptar.',
      );
    }
    Uint8List? logo;
    final rutaLogo = empresa.logoPath?.trim() ?? '';
    if (rutaLogo.isNotEmpty) {
      try {
        logo = await File(rutaLogo).readAsBytes();
      } catch (_) {
        throw const EstadoPresupuestoException(
          'No se puede leer el logo configurado. Corrige su ruta o retíralo de Configuración.',
        );
      }
    }
    return PresupuestoDocumento(
      tenantId: database.activeTenantId,
      presupuestoId: id,
      codigo: presupuesto.codigo,
      titulo: presupuesto.titulo,
      fecha: presupuesto.fecha,
      descripcion: presupuesto.descripcion,
      expedienteId: expediente.id,
      expedienteCodigo: expediente.codigo,
      expedienteNombre: expediente.nombre,
      emisor: {
        'nombre': empresa.nombreEmpresa,
        'nif': empresa.cif,
        'direccion': empresa.direccion,
        'codigoPostal': empresa.codigoPostal,
        'poblacion': empresa.poblacion,
        'provincia': empresa.provincia,
        'telefono': empresa.telefono,
        'email': empresa.email,
        'web': empresa.web,
      },
      cliente: {
        'id': cliente.id,
        'nombre': nombreCliente,
        'nombrePersonal': cliente.nombre,
        'apellidos': cliente.apellidos,
        'empresa': cliente.empresa,
        'nif': cliente.nif,
        'direccion': cliente.direccion,
        'codigoPostal': cliente.codigoPostal,
        'poblacion': cliente.poblacion,
        'provincia': cliente.provincia,
        'pais': cliente.pais,
        'telefono': cliente.telefono,
        'email': cliente.email,
      },
      partidas: partidas,
      baseCentimos: base,
      ivaPorcentaje: presupuesto.ivaPorcentaje,
      ivaCentimos: (base * presupuesto.ivaPorcentaje / 100).round(),
      aceptado: aceptado,
      fechaCongelacion: aceptado
          ? DateTime.fromMillisecondsSinceEpoch(
              (DateTime.now().millisecondsSinceEpoch ~/ 1000) * 1000,
              isUtc: true,
            )
          : null,
      logo: logo,
    );
  }

  /// Called inside the acceptance transaction, before publishing the state.
  Future<void> congelar(String id) async {
    final documento = await preparar(id, aceptado: true);
    final pdf = await _pdfService.generarPdf(documento);
    if (pdf.length < 5 || String.fromCharCodes(pdf.take(5)) != '%PDF-') {
      throw const EstadoPresupuestoException(
        'No se pudo generar el PDF definitivo.',
      );
    }
    await database.presupuestoDocumentosAceptadosDao.insertar(
      PresupuestoDocumentosAceptadosCompanion.insert(
        tenantId: database.activeTenantId,
        presupuestoId: id,
        snapshotJson: documento.encode(),
        pdf: pdf,
        sha256: sha256.convert(pdf).toString(),
        fechaCongelacion: documento.fechaCongelacion!,
      ),
    );
  }

  Future<PresupuestoDocumento?> obtenerSnapshot(String id) async {
    final row = await database.presupuestoDocumentosAceptadosDao.obtener(id);
    if (row == null) return null;
    final doc = PresupuestoDocumento.decode(row.snapshotJson);
    if (doc.tenantId != database.activeTenantId ||
        doc.presupuestoId != id ||
        !doc.aceptado) {
      throw const EstadoPresupuestoException(
        'La identidad del documento preservado no coincide.',
      );
    }
    return doc;
  }

  Future<Uint8List> obtenerPdf(String id) => database.transaction(() async {
    final presupuesto = await database.presupuestosDao.obtenerPorId(id);
    if (presupuesto == null || presupuesto.eliminado) {
      throw const EstadoPresupuestoException(
        'El presupuesto no está disponible.',
      );
    }
    final row = await database.presupuestoDocumentosAceptadosDao.obtener(id);
    if (row != null) {
      await obtenerSnapshot(id);
      if (sha256.convert(row.pdf).toString() != row.sha256) {
        throw const EstadoPresupuestoException(
          'El PDF preservado no supera la comprobación de integridad.',
        );
      }
      return Uint8List.fromList(row.pdf);
    }
    if (estadoPresupuestoEsAceptado(presupuesto.estado)) {
      throw const EstadoPresupuestoException(
        'Presupuesto aceptado histórico sin PDF congelado. No se reconstruye un original que no fue preservado.',
      );
    }
    return _pdfService.generarPdf(await preparar(id));
  });
}
